//
//  MultipeerSession.swift
//  
//
//  Created by ミズキ on 2022/11/12.
//

import MultipeerConnectivity

public final class MultipeerSession: NSObject {
    
    static let serviceType = "ar-collab"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrowser: MCNearbyServiceBrowser!
    
    private let receiveDataHandler: (Data, MCPeerID) -> (Void)
    private let peerJoinedHandler: (MCPeerID) -> Void
    private let peerLeftHandler: (MCPeerID) -> Void
    private let peerDiscoverdHandler: (MCPeerID) -> Bool
    
    public init(receiveDataHandler: @escaping (Data, MCPeerID) -> Void,
                peerJoinedHandler: @escaping (MCPeerID) -> Void,
                peerLeftHandler: @escaping (MCPeerID) -> Void,
                peerDiscoverdHandler: @escaping (MCPeerID) -> Bool) {
        self.receiveDataHandler = receiveDataHandler
        self.peerJoinedHandler = peerJoinedHandler
        self.peerLeftHandler = peerLeftHandler
        self.peerDiscoverdHandler = peerDiscoverdHandler
        
        super.init()
        // MCSessionをインスタンス化
        session = MCSession(peer: myPeerID,
                            securityIdentity: nil,
                            encryptionPreference: .required)
        // MCSessionDelegate
        session.delegate = self
        
        //
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                                      discoveryInfo: nil,
                                                      serviceType: MultipeerSession.serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID,
                                                serviceType: MultipeerSession.serviceType)
        serviceBrowser.delegate = self
        // 周りの検索を開始する。
        serviceBrowser.startBrowsingForPeers()
    }
    
    public func sendToAllPeers(_ data: Data,
                        reliably: Bool) {
        sendToPeers(data,
                    reliably: reliably,
                    peers: connectedPeers)
    }
    
    // PeerIDを送る。
    public func sendToPeers(_ data: Data,
                     reliably: Bool,
                     peers: [MCPeerID]) {
        // 空だったらreturn
        guard !peers.isEmpty else { return }
        // MCSessionに送る
        do {
            try session.send(data, toPeers: peers, with: reliably ? .reliable : .unreliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
}

// MARK: - MCSessionDelegate
extension MultipeerSession: MCSessionDelegate {
    
    // バイトストリーム接続
    public func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    
    // ファイル受信開始
    public func session(_ session: MCSession, didStartReceivingResourceWithName
                 resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    
    // ファイル時受信終了
    public func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }
    
    // PtoPの接続状態を変更
    public func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        if state == .connected {
            // 接続中
            peerJoinedHandler(peerID)
        } else if state == .notConnected {
            // 接続が切れる。
            peerLeftHandler(peerID)
        }
    }
    
    // データを受信　-> ARSession.CollaborationDataに変換してViewに反映する。
    public func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        receiveDataHandler(data, peerID)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    // 端末を発見した時を検知
    public func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        // 端末発見時
        let accepted = peerDiscoverdHandler(peerID)
        if accepted {
            // 招待を送る。
            browser.invitePeer(peerID,
                               to: session,
                               withContext: nil,
                               timeout: 10)
        }
    }
    
    // 発見した端末をロスト時に呼ばれる
    public func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) { }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {

    // Peerの招待を受け取ることを検知
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("advertiseが失敗")
    }
}
