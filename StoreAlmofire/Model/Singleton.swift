//
//  Singleton.swift
//  StoreAlmofire
//
//  Created by GraceToa on 11/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation


public class Singleton
{
    var itemsProduct = [Product]()
    static let shared = Singleton()
    
    func removeProduct(_ product: Product)  {
        if let index = itemsProduct.firstIndex(where: {$0.codigo == product.codigo}) {
            itemsProduct.remove(at: index)
        }
    }
    
    func append(_ product: Product)  {
        itemsProduct.append(product)
    }

    func getCount() -> Int {
        return itemsProduct.count
    }
    
    func getItemAt(position:Int) -> Product? {
        guard position < itemsProduct.count else {return nil}
        return itemsProduct[position];
    }
    
    func removeAll()  {
        itemsProduct.removeAll()
    }
}
