//
//  YTPlayerViewController.swift
//  testProject
//
//  Created by miniMAC Sferea on 17/09/21.
//

import UIKit
import WebKit

import os.log

/// The notification to listen for.
fileprivate extension Notification.Name {
    static let videoIsBeingPlayed = Notification.Name("AVSecondScreenConnectionPlayingDidChangeNotification")
}

class YTPlayerViewController: UIViewController {

    @IBOutlet weak var contentWebView: UIView!
    
    var webView : WKWebView? = nil
    var webTimes: [Int] = []
    
    /// The notification center.
        lazy var notificationCenter: NotificationCenter = {
            return NotificationCenter.default
        }()
        
        /// One time now playing observer for detecting video playback has occured.
        private var oneTimeRemoteNowPlayingObserver: NSObjectProtocol?
        
        private func addVideoPlayingObserver() {
            oneTimeRemoteNowPlayingObserver = notificationCenter.addObserver(forName: .videoIsBeingPlayed, object: nil, queue: nil) { [weak self] (_) in
                os_log("An embedded video has (at least in part) been watched.", log: .default, type: .debug)
                
                // Move to main as it called from a background queue
                DispatchQueue.main.async {
                    // Remove the one time observer (we only need a single notification).
                    self?.removeVideoPlayingObserver()

                    // do something, for example call a delegate.
                }
            }
        }
        
        /// Remove the video playing observer (if any).
        private func removeVideoPlayingObserver() {
            guard let observer = oneTimeRemoteNowPlayingObserver else { return }
            notificationCenter.removeObserver(observer)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webTimes.append(0)
        addVideoPlayingObserver()
        setupWebView()
        loadWebContent()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
        print("traitCollectionDidChange")
        DispatchQueue.main.async {
            self.loadWebContent()
        }
        
    }
    
    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsPictureInPictureMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = false
        config.allowsInlineMediaPlayback = true
        
        let contentController = WKUserContentController();
        contentController.add(
            self,
            name: "callbackHandler"
        )
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.scrollView.isScrollEnabled = false
        webView?.scrollView.bounces = false
        webView?.allowsLinkPreview = false
        webView?.scrollView.panGestureRecognizer.delaysTouchesBegan = true
    }
    
    func loadWebContent() {
        //Libera memoria del messageHandler
        webView?.stopLoading()
        
        let embedHTML = "<html>" +
            "<head><meta name='viewport' content='width=device-width, initial-scale=1'></head>" +
            "<body style='margin:0px;padding:0px;'>" +
//            "<script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>" +
//            "<script type='text/javascript'>" +
            "<script>" +
            "var tag = document.createElement('script');" +

            "tag.src = \"https://www.youtube.com/iframe_api\";" +
            "var firstScriptTag = document.getElementsByTagName('script')[0];" +
            "firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);" +
            "var player;" +
            "function onYouTubeIframeAPIReady()" +
            "{" +
            "    player = new YT.Player('playerId',{" +
                "events:{" +
                "'onReady': onPlayerReady," +
                "'onStateChange': onPlayerStateChange" +
                "}" +
                "});" +
            "}" +
            "function onPlayerReady(a)" +
            "{ " +
                "a.target.playVideo(); " +
            "}" +
            "function onPlayerStateChange(event) {" +
              "if (event.data == YT.PlayerState.PLAYING) {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"PLAYING\");" +
              "}" +
              "else if (event.data == YT.PlayerState.ENDED) {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"ENDED\");" +
              "}" +
              "else if (event.data == YT.PlayerState.PAUSED) {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"PAUSED\");" +
              "}" +
              "else if (event.data == YT.PlayerState.BUFFERING) {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"BUFFERING\");" +
              "}" +
              "else if (event.data == YT.PlayerState.CUED) {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"CUED\");" +
              "}" +
              "sendCurrentTime();" +
            "}" +
            "function callNativeApp () {" +
                "try {" +
                    "webkit.messageHandlers.callbackHandler.postMessage(player.getCurrentTime());" +
                    "} catch(err) {" +
                    "console.log('The native context does not exist yet');" +
                "}" +
            "}" +
            "function sendCurrentTime() {" +
                "webkit.messageHandlers.callbackHandler.postMessage(\"Current time\");" +
                "if (player.getPlayerState() == 1) {" +
                    "callNativeApp();" +
                    "setTimeout(sendCurrentTime,1000);" +
                "}" +
            "}" +
            "</script>" +
            "<iframe id='playerId' type='text/html' width='100%' height='100%' src='http://www.youtube.com/embed/Qa1zijvVpvc?enablejsapi=1&rel=0&playsinline=1&autoplay=1&start=\(webTimes[0])' frameborder='0'>" +
            "</body>" +
            "</html>"
        
//        let embedHTML = "<html>" +
//        "<body>" +
//        "<div id=\"player\"></div>" +
//        "<script>" +
//        "var tag = document.createElement('script');" +
//        "tag.src = \"https://www.youtube.com/iframe_api\";" +
//        "var firstScriptTag = document.getElementsByTagName('script')[0];" +
//        "firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);" +
//        "var player;" +
//        "function onYouTubeIframeAPIReady() {" +
//            "player = new YT.Player('player', {" +
//                "height: '100%'," +
//                "width: '100%'," +
//                "videoId: 'M7lc1UVf-VE'," +
//                "events: {" +
//                "'onReady': onPlayerReady," +
//                "'onStateChange': onPlayerStateChange" +
//                "}" +
//              "});" +
//            "}" +
//            "function onPlayerReady(event) {" +
//              "event.target.playVideo();" +
//              "player.addEventListener(\"onStateChange\", updateBar);" +
//            "}" +
//            "function onPlayerStateChange(event) {" +
//              "if (event.data == YT.PlayerState.PLAYING) {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"PLAYING\");" +
//              "}" +
//              "else if (event.data == YT.PlayerState.ENDED) {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"ENDED\");" +
//              "}" +
//              "else if (event.data == YT.PlayerState.PAUSED) {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"PAUSED\");" +
//              "}" +
//              "else if (event.data == YT.PlayerState.BUFFERING) {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"BUFFERING\");" +
//              "}" +
//              "else if (event.data == YT.PlayerState.CUED) {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"CUED\");" +
//              "}" +
//            "callNativeApp();" +
//            "}" +
//            "function stopVideo() {" +
//              "player.stopVideo();" +
//            "}" +
//            "function callNativeApp () {" +
//                "try {" +
//                    "webkit.messageHandlers.callbackHandler.postMessage(player.getCurrentTime());" +
//                    "} catch(err) {" +
//                    "console.log('The native context does not exist yet');" +
//                    "}" +
//            "}" +
//            "function updateBar() {" +
//                "webkit.messageHandlers.callbackHandler.postMessage(\"Update Bar\");" +
//                "if (YT.PlayerState.PLAYING) {" +
//                    "callNativeApp();" +
//                    "setTimeout(updateBar,1000);" +
//                "}" +
//            "}" +
//          "</script>" +
//        "</body>" +
//      "</html>"
        
        contentWebView.addSubview(webView!)
        webView?.fillSuperView()
        webView?.loadHTMLString(embedHTML, baseURL: Bundle.main.resourceURL!)
    }

}

extension YTPlayerViewController: WKUIDelegate {
    
}

extension YTPlayerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail: WKNavigation!, withError: Error){
        print("---------------\(withError)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("--------\(error)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WEBVIEW STARTS")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WEB VIEW DID FINISH!!!")
//        if webView == webviewDetail {
//            webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//                if complete != nil {
//                    DispatchQueue.main.async {
//                    webView.invalidateIntrinsicContentSize()
//                    self.updateWebViewHeight()
//                    self.webViewContent.isHidden = false
//                    }
//                }
//            })
//        }
    }
}

extension YTPlayerViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Body: ",message.body)
        
        if message.name == "callbackHandler" {
            if let seconds = message.body as? Double {
                webTimes.insert(Int(seconds), at: 0)
                print(seconds,"[s]")
            }
        }
        
//        switch action {
//        case 1:
//            print("1. PLAYING")
//        case 0:
//            print("0. ENDED")
//        case 2:
//            print("2. PAUSED")
//        case 3:
//            print("3. BUFFERING")
//        case 5:
//            print("5. CUED")
//        default:
//            print("INDEFINED")
//        }
        
    }
    
}

extension UIView {
    public func fillSuperView(padding: UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints  = false
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor,padding: padding)
    }
    
    public func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero){
        
        translatesAutoresizingMaskIntoConstraints  = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
    }
}
