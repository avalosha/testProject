//
//  YouTubeViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 12/08/22.
//

import UIKit
import YoutubePlayer_in_WKWebView
import MediaPlayer
import WebKit

class YouTubeViewController: UIViewController {

    @IBOutlet weak var playerView: WKYTPlayerView!
    
    public var urlVideo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("_________________________________________________")
        self.rotateToLandscapeDevice()
        
        playerView.delegate = self
        
        // listen for videos playing in fullscreen
            NotificationCenter.default.addObserver(self, selector: #selector(onDidEnterFullscreen(_:)), name: UIWindow.didBecomeVisibleNotification, object: view.window)

        // listen for videos stopping to play in fullscreen
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLeaveFullscreen(_:)), name: UIWindow.didBecomeHiddenNotification, object: view.window)
        
        if let url = urlVideo {
            if let id = url.youtubePlaylistID {
                playList(with: id)
            } else if let id = url.youtubeID {
                playVideo(with: id)
            }
        }
    }
    
    deinit {
        NSLog ("YouTubeViewController deinit called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // remove video listeners
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeVisibleNotification, object: view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeHiddenNotification, object: view.window)
    }
    
    func rotateToLandscapeDevice(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }

    func rotateToPortraitDevice() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    // Video, En vivo
    private func playVideo(with id: String) {
        print("ID video: ",id)
        playerView.load(withVideoId: id, playerVars: ["playsinline" : 0, "fs" : 1, "origin": "http://www.youtube.com", "rel" : 0, "controls" : 0])
    }
    
    // Playlist
    private func playList(with id: String) {
        let listID = id.replacingOccurrences(of: "list=", with: "")
        print("ID playlist: ",listID)
        playerView.load(withPlaylistId: listID, playerVars: ["playsinline" : 1,"fs" : 1, "origin": "http://www.youtube.com"])
    }

    @IBAction func onClickBackBtn(_ sender: Any) {
        backTo()
    }
    
    @objc func onDidEnterFullscreen(_ notification: Notification) {
        print("video is now playing in fullscreen")
    }

    @objc func onDidLeaveFullscreen(_ notification: Notification) {
        print("video has stopped playing in fullscreen")
        backTo()
    }
    
    private func backTo() {
        dismiss(animated: true) {
            self.rotateToPortraitDevice()
        }
    }
}

extension YouTubeViewController: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        print("REPRODUCTOR LISTO: \(playerView)")
        // Obtener videos de la playlist
//        self.playerView.getPlaylist { response, error in
//            if error != nil {
//                print("Error: ",error ?? "")
//            } else {
//                print("Response: ",response ?? "")
//            }
//        }
        self.playerView.setPlaybackQuality(WKYTPlaybackQuality.highRes)
    }
    
    /// Detecta un error al cargar el reproductor de video.
    func playerViewIframeAPIDidFailed(toLoad playerView: WKYTPlayerView) {
        print("ERROR EN CARGAR VIDEO")
    }
    
    /// Detecta la reproducción actúal del reproductor.
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        print("PLAYTIME REPRODUCTOR DE VIDEO: \(playTime)")
    }
    
    ///
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        nil
    }
    
    /// Detecta algun error en el reproductor de video.
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        switch error {
        case .invalidParam:
            print("ERROR invalidParam: \(error)")
        case .html5Error:
            print("ERROR html5Error: \(error)")
        case .videoNotFound:
            print("ERROR videoNotFound: \(error)")
        case .notEmbeddable:
            print("ERROR notEmbeddable: \(error)")
        case .unknown:
            print("ERROR unknown: \(error)")
        @unknown default:
            print("ERROR REPRODUCTOR DE VIDEO: \(error)")
        }
    }
    
    /// Delegado que muestra el status del video.
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch state {
        case .unstarted:
            print("ESTATUS: Unstarted")
        case .ended:
            print("ESTATUS: Ended")
            backTo()
        case .playing:
            print("ESTATUS: Playing")
        case .paused:
            print("ESTATUS: Paused")
        case .buffering:
            print("ESTATUS: Buffering")
            self.playerView.setPlaybackQuality(WKYTPlaybackQuality.highRes)
        case .queued:
            print("ESTATUS: Queued")
        case .unknown:
            print("ESTATUS: Unknown")
        @unknown default:
            print("ESTATUS: Desconocido")
        }
    }
    
    /// Recibe la calidad del video.
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
        switch quality {
        case .small:
            print("CALIDAD REPRODUCTOR DE VIDEO: Small")
        case .medium:
            print("CALIDAD REPRODUCTOR DE VIDEO: Medium")
        case .large:
            print("CALIDAD REPRODUCTOR DE VIDEO: Large")
        case .HD720:
            print("CALIDAD REPRODUCTOR DE VIDEO: HD720")
        case .HD1080:
            print("CALIDAD REPRODUCTOR DE VIDEO: HD1080")
        case .highRes:
            print("CALIDAD REPRODUCTOR DE VIDEO: HighRes")
        case .auto:
            print("CALIDAD REPRODUCTOR DE VIDEO: Auto")
        case .default:
            print("CALIDAD REPRODUCTOR DE VIDEO: Default")
        case .unknown:
            print("CALIDAD REPRODUCTOR DE VIDEO: Unknown")
        @unknown default:
            print("CALIDAD REPRODUCTOR DE VIDEO: Desconocido")
        }
    }
    
    /// Agrega un color de fondo al contenido del video.
    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        .black
    }
}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    var youtubePlaylistID: String? {
        //[&?]list=([a-z0-9_-]+)
        //list=([a-zA-Z0-9-_]+)&?
        let pattern = "list=([a-zA-Z0-9-_]+)&?"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}
