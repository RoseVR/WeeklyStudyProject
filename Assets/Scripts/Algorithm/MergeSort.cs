using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MergeSort : MonoBehaviour
{
    //归并排序：将序列对半拆分 直到每个子序列只包含一个元素 再将子序列两两比较并合并成大的序列 
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
        SplitUp(Array, 0, Array.Length-1);

        for (int i = 0; i < Array.Length; i++)
        {
            Debug.Log(" 归并排序" + Array[i]);

        }
    }
    //拆分序列
    private void SplitUp(int[] array,int left,int right)
    {
        if (left < right)
        {
            int _mid = (left + right) / 2;

            SplitUp(array, left, _mid);
            SplitUp(array, _mid + 1, right);
            MergeSorts(array,left,_mid,right);
        }
    }
    //归并
    private void MergeSorts(int[] array,int left,int mid, int right)
    {
        int[] mergeArray = new int[right - left + 1];
        int p1 = left;//序列1的起始指针
        int p2 = mid + 1;//序列2的起始指针
        int p = 0;//合并序列的起始指针
        while (p1<=mid&&p2<=right)
        {
            //如果序列1指针指向的值小于序列2指针指向的值 则将序列1该值存入合并序列 并都向右移一位
            if (array[p1] <= array[p2])
            {
                mergeArray[p++] = array[p1++];
            }
            //如果序列2指针指向的值小于序列1指针指向的值 则将序列2该值存入合并序列 并都向右移一位
            else
            {
                mergeArray[p++] = array[p2++];
            }
        }
        //如果序列1有剩下的话将剩下的都存入合并序列
        while (p1 <= mid)
        {
            mergeArray[p++] = array[p1++];
        }
        //如果序列2有剩下的话将剩下的都存入合并序列
        while (p2 <= right)
        {
            mergeArray[p++] = array[p2++];
        }
        p = 0;
        //将合并序列复制到原序列中
        while (left <= right)
        {
            array[left++] = mergeArray[p++];
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
