using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FastSort : MonoBehaviour
{
    //快速排序： 把数分成左右两堆（大的一堆小的一堆） 然后在分别在左右两堆中比较 一直到结束
    public int[] Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
    // Start is called before the first frame update
    void Start()
    {
        QuickSort(Array,0, Array.Length - 1);
        
    }

    private void QuickSort(int[] array,int left,int right)
    {
        //当左边小于右边的时候才计算 不然就不用计算啦
        if (left < right)
        {
            int middleNum = Array[left];
            int i = left, j = right;
            while (i < j)
            {
                //从右往左走，如果数大于此时定的中间值则--后继续走，如果小于的话，把该值赋给左边
                while (i < j && middleNum <= Array[j]) { j--; }
                Array[i] = Array[j];
                //从左往右走，如果数小于此时定的中间值则++
                while (i < j && middleNum >= Array[i]) { i++; }
                Array[j] = Array[i];
            }
            Array[i] = middleNum;
            //左边排序
            QuickSort(array, left, i - 1);
            //右边排序
            QuickSort(array, i + 1, right);
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
