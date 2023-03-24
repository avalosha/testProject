//
//  EncryptViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 16/03/23.
//

import UIKit

class EncryptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        testEcdh()
    }

    func generateKeyPair() -> (privateKey: SecKey, publicKey: SecKey)? {
        let attributes = [
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: false
            ],
            kSecPublicKeyAttrs as String: [
                kSecAttrIsPermanent as String: false
            ]
        ] as CFDictionary

        var cfError: Unmanaged<CFError>?

        guard let privateKey = SecKeyCreateRandomKey(attributes, &cfError) else {
            print("\n[\(#function)] Error generating private key, cause:\n\((cfError?.takeRetainedValue() as Error?)?.localizedDescription ?? "unknown")\n")

            return nil
        }

        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("\n[\(#function)] Error generating public key, cause:\n\((cfError?.takeRetainedValue() as Error?)?.localizedDescription ?? "unknown")\n")

            return nil
        }

        return (privateKey: privateKey, publicKey: publicKey)
    }
    
    func ecdhSecretCalculation(publicKey: SecKey, privateKey: SecKey) -> Data? {
        let keyPairAttr = [
            kSecAttrKeySizeInBits as String: 256,
            SecKeyKeyExchangeParameter.requestedSize.rawValue as String: 32,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: false
            ],
            kSecPublicKeyAttrs as String: [
                kSecAttrIsPermanent as String: false
            ]
        ] as CFDictionary

        let algorithm = SecKeyAlgorithm.ecdhKeyExchangeStandardX963SHA256//.ecdhKeyExchangeCofactorX963SHA256

        var cfError: Unmanaged<CFError>?

        guard let sharedSecret = SecKeyCopyKeyExchangeResult(privateKey, algorithm, publicKey, keyPairAttr, &cfError) else {
            print("\n[\(#function)] Error during ecdh secret calculation, cause:\n\((cfError?.takeRetainedValue() as Error?)?.localizedDescription ?? "unknown")\n")

            return nil
        }

        return sharedSecret as Data
    }
    
    func testEcdh() {
        if let (alicePrivateKey, alicePublicKey) = generateKeyPair(),
           let (bobPrivateKey, bobPublicKey) = generateKeyPair()
        {
            print("****************************************")
            print("\nalicePrivateKey:\n\(alicePrivateKey)\n")
            print("\nalicePublicKey:\n\(alicePublicKey)\n")

            print("\nbobPrivateKey:\n\(bobPrivateKey)\n")
            print("\nbobPublicKey:\n\(bobPublicKey)\n")

            guard let aliceBobEcdhSecret = ecdhSecretCalculation(publicKey: alicePublicKey, privateKey: bobPrivateKey) else {
                return
            }

            let aliceBobEcdhSecretHex = aliceBobEcdhSecret.hexEncodedString()

            guard let bobAliceEcdhSecret = ecdhSecretCalculation(publicKey: bobPublicKey, privateKey: alicePrivateKey) else {
                return
            }

            let bobAliceEcdhsecretHex = bobAliceEcdhSecret.hexEncodedString()

            print("\nalice bob ecdh secret hex string: \(aliceBobEcdhSecretHex)\n")
            print("\nbob alice ecdh secret hex string: \(bobAliceEcdhsecretHex)\n")
            print("\naliceBobEcdhSecretHex == bobAliceEcdhsecretHex: \(aliceBobEcdhSecretHex == bobAliceEcdhsecretHex)\n")
            print("****************************************")
        }
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"

        return self.map { String(format: format, $0) }.joined()
    }
}
