

import SceneKit.ModelIO

final public class ScnGenerator {
    static public func generate(_ urlString: String) -> SCNScene? {
        guard let url = Bundle.main.url(forResource: urlString,
                                        withExtension: "usdz") else { return nil }
        let mdlAsset = MDLAsset(url: url)
        let scnScene = SCNScene(mdlAsset: mdlAsset)
        return scnScene
    }
}
