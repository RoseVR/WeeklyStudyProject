using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BinaryHeapSort : MonoBehaviour
{
    //二叉堆排序：类似二叉树，分为大根堆和小根堆，升序排序用大根堆，降序排序用小根堆，大根堆的父节点比其左右子节点大，小根堆反之。 
    //通过将序列转化为大根堆 则最大数一定在堆顶 将堆顶删除并将堆底放置到堆顶 根据大根堆的性质堆底数字会被移动此时次大数上到堆顶 重复此操作则可得到升序序列
    
    //引用类型存储在堆中。类型实例化的时候，会在堆中开辟一部分空间存储类的实例。类对象的引用还是存储在栈中。
    //值类型总是分配在它声明的地方，做为局部变量时，存储在栈上；类对象的字段时，则跟随此类存储在堆中。

    //所以此处在进行交换的时候是将引用地址进行交换 要用到ref关键字

    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
        //先将序列转化为大根堆
        for(int i=Array.Length/2-1;i>=0; i--)
        {
            SetMaxHeap(Array, i, Array.Length);
        }
        
        for(int i = Array.Length-1; i >= 0 ; i--)
        {
            //将大根堆的堆顶与堆底交换
            Swap(ref Array[0], ref Array[i]);
            //序列0-i遍历产生大根堆
            SetMaxHeap(Array, 0, i);
        }
        for(int i = 0; i < Array.Length; i++)
        {
            Debug.Log("  二叉堆排序: " + Array[i]);
        }
    }
    private void SetMaxHeap(int[] array, int index,int size)
    {
        int leftChild = 2 * index + 1;//左子节点
        int rightChild = 2 * index + 2;//右子节点
        int largeParent = index;//父节点
        //如果左子节点大于父节点 则交换索引
        if (leftChild < size && array[leftChild] > array[largeParent])
        {
            largeParent = leftChild;
        }
        //如果右子节点大于父节点 则交换索引
        if (rightChild < size && array[rightChild] > array[largeParent])
        {
            largeParent = rightChild;
        }
        //如果产生了上述的交换 则交换顺序
        if (index != largeParent)
        {
            Swap(ref array[largeParent], ref array[index]);
            //交换之后再进行遍历确保为大根堆
            SetMaxHeap(array, largeParent, size);
        }
        
    }
    private void Swap(ref int first, ref int second)
    {
        int temp = first;
        first = second;
        second = temp;

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
