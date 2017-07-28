//
//  Global.swift
//  FlappyBird
//
//  Created by Guan Wong on 6/21/17.
//  Copyright © 2017 Fullstack.io. All rights reserved.
//

import SpriteKit

class Global: NSObject{
    
    static let sharedInstance = Global()
    
    enum Texture{
        case land
        case sky
        case pipeUp
        case pipeDown
        case bird01
        case bird02
    }
    
    private override init(){
        
    }
    
    func getSKTexture(texture:Texture) -> SKTexture{
        switch texture {
        case .land:
            return SKTexture(imageNamed: "land")
        case .sky:
            return SKTexture(imageNamed: "sky")
        case .pipeUp:
            return SKTexture(imageNamed: "PipeUp")
        case .pipeDown:
            return SKTexture(imageNamed: "PipeDown")
        case .bird01:
            return SKTexture(imageNamed: "bird-01")
        case .bird02:
            return SKTexture(imageNamed: "bird-02")
        }
    }
    
    
}
// Singleton to access all textures
let global = Global.sharedInstance
