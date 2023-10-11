//
//  AsyncImage+Cache.swift
//  ShopApp
//
//  Created by Olibo moni on 11/10/2023.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            let _ = print("cached: \(url.absoluteString)")
            content(.success(cached))
        }else{
            let _ = print("request: \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
fileprivate class ImageCache{
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}

#Preview {
    VStack {
        CacheAsyncImage(url: URL(string: "https://images.stockx.com/images/Balenciaga-Defender-Grey.jpg?fit=fill&bg=FFFFFF&w=576&h=384&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1652297811&q=60")!, scale: 5, transaction: Transaction(animation: .bouncy)) { AsyncImagePhase in
           // HStack {
                AsyncImagePhase.image
            //}
        }
    }
}
