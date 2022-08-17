//
//  Tree.swift
//  AlgorithmLearn
//
//  Created by Mac mini on 2022/8/4.
//

import Foundation

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Tree {
    // MARK: - 100. 相同的树
    static func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        // dfs
        if p == nil && q == nil { return true }
        let isLeftSame = isSameTree(p?.left, q?.left)
        let isRightSame = isSameTree(p?.right, q?.right)
        return isLeftSame && isRightSame && p?.val == q?.val
    }
    
    // MARK: - 222. 完全二叉树的节点个数（中等）
    static func countNodes(_ root: TreeNode?) -> Int {
        var count = 0
        var queue = [TreeNode?]()
        queue.append(root)
        while !queue.isEmpty {
            let cur = queue.removeFirst()
            if cur == nil {
                break
            }
            queue.append(cur?.left)
            queue.append(cur?.right)
            count += 1
        }
        return count
    }
    
    // MARK: - 101. 对称二叉树
    /*
     给你一个二叉树的根节点 root ， 检查它是否轴对称。
     示例 1：
     输入：root = [1,2,2,3,4,4,3]
     输出：true
     
     示例 2：
     输入：root = [1,2,2,null,3,null,3]
     输出：false
     
     提示：
     树中节点数目在范围 [1, 1000] 内
     -100 <= Node.val <= 100
     
     进阶：你可以运用递归和迭代两种方法解决这个问题吗？
     */
    static func isSymmetric(_ root: TreeNode?) -> Bool {
        // 递归
        /*
        return isSymmetric(left: root?.left, right: root?.right)
        func isSymmetric(left: TreeNode?, right: TreeNode?) -> Bool {
            if left?.val != right?.val { return false }
            if left == nil && right == nil { return true }
            return isSymmetric(left: left?.right, right: right?.left) && isSymmetric(left: left?.left, right: right?.right)
        }
         */
        // 迭代
        var queue = [TreeNode?]()
        queue.append(root?.left)
        queue.append(root?.right)
        while !queue.isEmpty {
            let left = queue.removeFirst()
            let right = queue.removeFirst()
            if left?.val != right?.val {
                return false
            } else if left == nil && right == nil {
                continue
            } else {
                queue.append(left?.left)
                queue.append(right?.right)
                queue.append(left?.right)
                queue.append(right?.left)
            }
        }
        return true
    }
    
    // MARK: - 226
    static func invertTree(_ root: TreeNode?) -> TreeNode? {
        if root?.left == nil && root?.right == nil { return root }
        let newLeft = invertTree(root?.right)
        let newRight = invertTree(root?.left)
        root?.left = newLeft
        root?.right = newRight
        return root
    }
    
    // MARK: - 437.路径总和 III（中等）
    /*
     给定一个二叉树的根节点 root ，和一个整数 targetSum ，求该二叉树里节点值之和等于 targetSum 的 路径 的数目。
     路径 不需要从根节点开始，也不需要在叶子节点结束，但是路径方向必须是向下的（只能从父节点到子节点）。
     
     示例 1：
     输入：root = [10,5,-3,3,2,null,11,3,-2,null,1], targetSum = 8
     输出：3
     解释：和等于 8 的路径有 3 条，如图所示。
     
     示例 2：
     输入：root = [5,4,8,11,null,13,4,7,2,null,null,5,1], targetSum = 22
     输出：3
     
     提示:
     二叉树的节点个数的范围是 [0,1000]
     -109 <= Node.val <= 109
     -1000 <= targetSum <= 1000
     */
    static func pathSum(_ root: TreeNode?, _ targetSum: Int) -> Int {
        // 递归
        /*
        // 以root开头的和为targetSum的数目
        func rootSum(_ root: TreeNode?, _ targetSum: Int) -> Int {
            guard let root = root else { return 0 }
            var res = 0
            if root.val == targetSum {
                res += 1
            }
            res += rootSum(root.left, targetSum - root.val)
            res += rootSum(root.right, targetSum - root.val)
            return res
        }
        
        if root == nil { return 0 }
        var res = rootSum(root, targetSum)
        res += pathSum(root?.left, targetSum)
        res += pathSum(root?.right, targetSum)
        return res
         */
        
        // 前缀和
        var prefix = [Int : Int]()
        func dfs(root: TreeNode?, cur: Int, targetSum: Int) -> Int {
            guard let root = root else { return 0 }
            var cur = cur
            cur += root.val
            var res = 0
            if let count = prefix[cur - targetSum] {
                res = count
            }
            prefix[cur] = (prefix[cur] ?? 0) + 1
            res += dfs(root: root.left, cur: cur, targetSum: targetSum)
            res += dfs(root: root.right, cur: cur, targetSum: targetSum)
            prefix[cur] = (prefix[cur] ?? 0) - 1
            return res
        }
        prefix[0] = 1
        return dfs(root: root, cur: 0, targetSum: targetSum)
    }
    
    // MARK: - 563. 二叉树的坡度
    /*
     
     */
    static func findTilt(_ root: TreeNode?) -> Int {
        /*
        if root == nil { return 0 }
        let leftSum = rootSum(root?.left)
        let rightSum = rootSum(root?.right)
        return abs(leftSum - rightSum) + findTilt(root?.left) + findTilt(root?.right)
        func rootSum(_ root: TreeNode?) -> Int {
            guard let root = root else { return 0 }
            return root.val + rootSum(root.left) + rootSum(root.right)
        }
         */
        var res = 0
        func dfs(_ root: TreeNode?) -> Int {
            guard let root = root else { return 0 }
            let leftSum = dfs(root.left)
            let rightSum = dfs(root.right)
            res += abs(leftSum - rightSum)
            return root.val + leftSum + rightSum
        }
        dfs(root)
        return res
    }
    
    // MARK: - 617. 合并二叉树
    static func mergeTrees(_ root1: TreeNode?, _ root2: TreeNode?) -> TreeNode? {
        if root1 == nil {
            return root2
        }
        if root2 == nil {
            return root1
        }
        let newTree = TreeNode(root1!.val + root2!.val)
        newTree.left = mergeTrees(root1?.left, root2?.left)
        newTree.right = mergeTrees(root1?.right, root2?.right)
        return newTree
    }
    
    // MARK: - 508. 出现次数最多的子树元素和（中等）
    static func findFrequentTreeSum(_ root: TreeNode?) -> [Int] {
        var map = [Int : Int]()
        
        func dfs(_ root: TreeNode?) -> Int {
            guard let root = root else { return 0 }
            let leftSum = dfs(root.left)
            let rightSum = dfs(root.right)
            let sum = root.val + leftSum + rightSum
            map[sum] = (map[sum] ?? 0) + 1
            return sum
        }
        dfs(root)
        var maxCount = 0
        for (_, value) in map {
            maxCount = max(maxCount, value)
        }
        return map.filter({ $0.value == maxCount }).map { $0.key }
    }
    // MARK: - 572. 另一棵树的子树
    static func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
        if root == nil { return false }
        let isRootSub = isSubtreeFromRoot(root, subRoot)
        return isRootSub || isSubtree(root?.left, subRoot) || isSubtree(root?.right, subRoot)
        
        func isSubtreeFromRoot(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
            if root == nil && subRoot == nil { return true }
            if (subRoot == nil && root != nil) || (root == nil && subRoot != nil) { return false }
            let isLeftSame = isSubtreeFromRoot(root?.left, subRoot?.left)
            let isRightSame = isSubtreeFromRoot(root?.right, subRoot?.right)
            return isLeftSame && isRightSame && root?.val == subRoot?.val
        }
    }
    
    // MARK: - 543. 二叉树的直径
    static func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
        /*
        var maxDiameter = 0
        func diameterThroughTree(_ root: TreeNode?) -> Int {
            if root == nil { return 0 }
            let cur = dfs(root?.left) + dfs(root?.right) - 2
            maxDiameter = max(maxDiameter, cur)
            diameterThroughTree(root?.left)
            diameterThroughTree(root?.right)
            return cur
        }
        
        func dfs(_ root: TreeNode?) -> Int {
            if root == nil { return 0 }
            let leftHeight = dfs(root?.left)
            let rightHeight = dfs(root?.right)
            return max(leftHeight, rightHeight) + 1
        }
        diameterThroughTree(root)
        return maxDiameter
         */
        
        var maxDiameter = 0
        func dfs(_ root: TreeNode?) -> Int {
            if root == nil { return 0 }
            let leftHeight = dfs(root?.left)
            let rightHeight = dfs(root?.right)
            maxDiameter = max(maxDiameter, leftHeight + rightHeight)
            return max(leftHeight, rightHeight) + 1
        }
        dfs(root)
        return maxDiameter
    }
    
    // MARK: - 654. 最大二叉树
    static func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
        func constructMaximumBinaryTree(_ nums: [Int], left: Int, right: Int) -> TreeNode? {
            if left > right { return nil }
            let curNums = Array(nums[left...right])
            let max = curNums.max()!
            let maxIndex = nums.firstIndex(of: max)!
            let root = TreeNode(max)
            root.left = constructMaximumBinaryTree(nums, left: left, right: maxIndex - 1)
            root.right = constructMaximumBinaryTree(nums, left: maxIndex + 1, right: right)
            return root
        }
        return constructMaximumBinaryTree(nums, left: 0, right: nums.count - 1)
    }
    
    // MARK: - 687. 最长同值路径
    static func longestUnivaluePath(_ root: TreeNode?) -> Int {
        return 0
    }
}
