using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BucketSort : MonoBehaviour
{
    //桶排序：为待排序的序列准备若干个桶，将序列中的对应数字放进对应桶中，并采用合适的方法对桶中的序列进行排序，依次输出各个桶中的序列即可
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 77, 79, 83, 82, 67, 59, 26, 31, 77, 75, 80, 5, 2 };
        //先确定序列的最大值和最小值
        int max = Array[0];
        int min = Array[0];
        for(int i = 1; i < Array.Length; i++)
        {
            if (max < Array[i])
                max = Array[i];
            if (min > Array[i])
                min = Array[i];
        }
        //假设使用5个桶 则每个桶需要预留的空间为(max-min+1)/5 多一个用来计数
        int average = (max - min + 1) / 5;
        int[,] bucket = new int[6, average];
        DoBucketSort(Array, bucket, min, max, average);
        for(int i = 0; i < Array.Length; i++)
        {
            Debug.Log(" 桶排序：" + Array[i]);
        }
    }
    private void DoBucketSort(int[] array,int[,] bucket,int min, int max,int average)
    {
        //按桶放置
        for(int i = 0; i < array.Length; i++)
        {
            if (array[i] >= min && array[i] < average)
            {
                bucket[0, bucket[5,0]] = array[i];
                bucket[5, 0]++;
            }
            else if (array[i] >= average && array[i] < 2 * average)
            {
                bucket[1, bucket[5, 1]] = array[i];
                bucket[5, 1]++;
            }
            else if (array[i] >= 2 *average && array[i] < 3 * average)
            {
                bucket[2, bucket[5, 2]] = array[i];
                bucket[5, 2]++;
            }
            else if (array[i] >= 3 * average && array[i] < 4 * average)
            {
                bucket[3, bucket[5, 3]] = array[i];
                bucket[5, 3]++;
            }
            else if (array[i] >= 4 * average && array[i] <= max)
            {
                bucket[4, bucket[5, 4]] = array[i];
                bucket[5, 4]++;
            }
        }
        //这里选择使用快速排序
        for(int i = 0; i < 5; i++)
        {
            if (bucket[5, i] > 0)
            {
                int[] tempArray = new int[bucket[5, i]];
                for (int j = 0; j < tempArray.Length; j++)
                {
                    tempArray[j] = bucket[i, j];
                }
               tempArray = QuickSort(tempArray, 0, tempArray.Length-1);
                for(int j = 0; j < tempArray.Length; j++)
                {
                    bucket[i, j] = tempArray[j];
                }
            }
        }
        int index = 0;
        for(int i = 0; i < 5; i++)
        {
            if (bucket[5, i] > 0)
            {
                for(int j = 0; j < bucket[5, i]; j++)
                {
                    array[index] = bucket[i, j];
                    index++;
                }
            }
        }
    }
    private int[] QuickSort(int[] array, int left, int right)
    {
        //当左边小于右边的时候才计算 不然就不用计算啦
        if (left < right)
        {
            int middleNum = array[left];
            int i = left, j = right;
            while (i < j)
            {
                //从右往左走，如果数大于此时定的中间值则--后继续走，如果小于的话，把该值赋给左边
                while (i < j && middleNum <= array[j]) { j--; }
                array[i] = array[j];
                //从左往右走，如果数小于此时定的中间值则++
                while (i < j && middleNum >= array[i]) { i++; }
                array[j] = array[i];
            }
            array[i] = middleNum;
            //左边排序
            QuickSort(array, left, i - 1);
            //右边排序
            QuickSort(array, i + 1, right);
            return array;
        }
        return array;
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
