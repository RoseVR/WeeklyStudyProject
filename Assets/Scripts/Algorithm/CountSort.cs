using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CountSort : MonoBehaviour
{
    //计数排序：不在序列中对各个数值进行比较 而是先创建对应长度的数组(数组最大数+1)，该数组初始值为0，序列中数字与下标相等则下标位置初始值+1 最终将该数组根据下标与值输出即可
    //计数排序只适合在包含小范围的序列中使用
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 2, 5, 8, 9, 7 };
        //Array = new int[] { 77, 79, 83, 82, 77, 75, 80 };
        int maxNum = 0;
        int minNum = Array[0];
        //获取到数组最大值，以确定临时数组的长度 
        for (int i = 0; i < Array.Length; i++)
        {
            if (Array[i] > maxNum)
            {
                maxNum = Array[i];
            }
            if (minNum > Array[i])
            {
                minNum = Array[i];
            }
        }

        //如果数组的最小值比较大则可以把下标与数值进行替换
        //如：数组为{54，64，53，68，63}，则需先找到最小数，然后临时数组的0位为：最小数 长度则为最大值-最小值+1
        maxNum = maxNum - minNum + 1;
        int[] tempArray = new int[maxNum + 1];
        DoCountSort(Array, tempArray,minNum);
        for(int i = 0; i < Array.Length; i++)
        {
            Debug.Log(" 计数排序 ： " + Array[i]);
        }

    }
    private void DoCountSort(int[] array,int[] tempArray,int minNum)
    {
        for(int i = 0; i < tempArray.Length; i++)
        {
            for(int j = 0; j < array.Length; j++)
            {
                if (i == (array[j]-minNum))
                {
                    tempArray[i]++;
                }
            }
        }
        //排序 根据临时数组每个下标位上的大小来将序列重新排序
        int index = 0;
        for (int i = 0; i < tempArray.Length; i++)
        {
            if (tempArray[i] > 0)
            {
                for (int j = 0; j < tempArray[i]; j++)
                {
                    Array[index] = i+minNum;
                    index++;
                }
            }
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
