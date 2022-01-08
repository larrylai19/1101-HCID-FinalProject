//
//  MaximumFlowClass.swift
//  test
//
//  Created by Larry - 1024 on 2022/1/8.
//

import Foundation

class MaximumFlowClass {
    var rn = [[Int]]() // Residual Network
    
    var activityTime = [Int]()
    var availTime = [Int]()
    
    var totFlow = 0
    var totNode = 0
    
    var source = 0
    var sink = 0
    
    var p = [Int]()
    var vis = [Bool]()
    var ret = [Int: Int]() // result dict
    
    var mf = 0
    
    func setData(activityTime: [Int], availTime: [Int]) {
        self.activityTime = activityTime
        self.availTime = availTime
    }
    
    func initData() {
        self.totFlow = self.activityTime.count
        self.totNode = self.activityTime.count + self.availTime.count + 1
        
        self.sink = totNode
        
        self.p.removeAll()
        self.vis.removeAll()
        self.ret.removeAll()
        createNodes()
    }
    
    func createNodes() {
        var sourceL = [Int]()
        sourceL.append(0)
        for _ in self.activityTime {
            sourceL.append(1)
        }
        for _ in self.availTime {
            sourceL.append(0)
        }
        sourceL.append(0)
        self.rn.append(sourceL)
        
        for _ in 0...self.totNode {
            self.p.append(-1)
            self.vis.append(false)
        }
        
        for act in self.activityTime {
            var l = [Int]()
            l.append(0)
            for _ in self.activityTime {
                l.append(0)
            }
            for avail in self.availTime {
                l.append(act <= avail ? 1 : 0)
            }
            l.append(0)
            self.rn.append(l)
        }
        
        for _ in self.availTime {
            var l = [Int]()
            l.append(0)
            for _ in self.activityTime {
                l.append(0)
            }
            for _ in self.availTime {
                l.append(0)
            }
            l.append(1)
            self.rn.append(l)
        }
        
        var l = [Int]()
        l.append(0)
        for _ in self.activityTime {
            l.append(0)
        }
        for _ in self.availTime {
            l.append(0)
        }
        l.append(0)
        self.rn.append(l)
    }
    
    func augment(_ u: Int, _ v: Int, _ bottleNeck: Int) -> Int {
        if v == self.source {
            return bottleNeck
        }
        let tmp = augment(p[u], u, min(self.rn[u][v], bottleNeck))
        self.rn[u][v] -= tmp
        self.rn[v][u] += tmp
        return tmp
    }
    
    func maximumFlow() {
        initData()
        
        self.mf = 0
        
        while true {
            //print(mf)
            for idx in self.p.indices {
                self.p[idx] = -1
            }
            
            for idx in self.vis.indices {
                self.vis[idx] = false
            }
            
            var q = [Int]()
            q.append(self.source)
            self.vis[self.source] = true
            
            while (q.isEmpty == false && self.vis[self.sink] == false) {
                let u = q[0]
                q.removeFirst()
                
                for v in 1...self.sink {
                    if self.vis[v] || self.rn[u][v] == 0 {
                        continue
                    }
                    
                    q.append(v)
                    self.vis[v] = true
                    self.p[v] = u
                }
            }
            
            if self.vis[self.sink] == false {
                break
            }
            
            self.mf += augment(self.p[self.sink], self.sink, Int.max)
        }
        
        for u in 0..<activityTime.count {
            for v in 0..<availTime.count {
                if rn[u + 1][v + 1 + activityTime.count] == 0 && rn[v + 1 + activityTime.count][u + 1] == 1 {
                    ret[u] = v
                    break
                }
            }
        }
    }
    
    func isVaild() -> Bool {
        return self.mf == self.totFlow
    }
    
    func getMF() -> Int {
        return self.mf
    }
    
    func getResult() -> Array<(key: Int, value: Int)> {
        return ret.sorted(by: <)
    }
}
