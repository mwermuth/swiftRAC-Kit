//
//  swiftRAC-kit.swift
//  
//
//  Created by mwermuth on 08/08/14.
//
//

import Foundation


extension RACSignal {
    func subscribeNextAs<T>(nextClosure:(T) -> ()) -> RACDisposable {
        return subscribeNext {
            (next: AnyObject!) -> () in
            let nextAsT = next as T
            nextClosure(nextAsT)
        }
    }
    
}

extension RACStream {
    
    func mapAs<T,U: AnyObject>(block: (T) -> U) -> Self {
        return map({(value: AnyObject!) in
            if let casted = value as? T {
                return block(casted)
            }
            return nil
        })
    }
    
    func filterAs<T>(block: (T) -> Bool) -> Self {
        return filter({(value: AnyObject!) in
            if let casted = value as? T {
                return block(casted)
            }
            return false
        })
    }
    
}

func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
    return target.rac_valuesForKeyPath(keyPath, observer: target)
}

struct RAC  {
    var target : NSObject!
    var keyPath : String!
    var nilValue : AnyObject!
    
    init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
        self.target = target
        self.keyPath = keyPath
        self.nilValue = nilValue
    }
    
    func assignSignal(signal : RACSignal) {
        signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

infix operator  ~> {}
func ~> (signal: RACSignal, rac: RAC) {
    rac.assignSignal(signal)
}

infix operator <~ {}
func <~ (rac: RAC, signal: RACSignal) {
    rac.assignSignal(signal)
}