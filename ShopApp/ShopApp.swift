//
//  ShopApp.swift
//  ShopApp
//
//  Created by Olibo moni on 11/10/2023.
//

import SwiftUI

@main
struct ShopApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                CacheAsyncImage(url: URL(string: "https://images.stockx.com/images/Balenciaga-Defender-Grey.jpg?fit=fill&bg=FFFFFF&w=576&h=384&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1652297811&q=60")!, scale: 2.0, transaction: Transaction(animation: .bouncy)) { AsyncImagePhase in
                    HStack {
                        AsyncImagePhase.image
                            
                    }
                }
            }
            
        }
        
    }
}
