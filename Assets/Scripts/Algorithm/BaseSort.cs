using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseSort : MonoBehaviour
{
    //基数排序：（以最大值不超过100为例）创建一个长度为10的数组 先根据序列中数的个位数将其放在数组对应下标处 将其根据该顺序取出 此时个位数有序 再根据十位数放在数组中对应下标处 此时即为有序
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 77, 79, 83, 82,67,59,26,31, 77, 75, 80,5,2 };
        DoBaseSort(Array, 10);
        for (int i = 0; i < Array.Length; i++)
        {
            Debug.Log(" 基数排序：" + Array[i]);
        }
    }
    private void DoBaseSort(int[] array,int arrayNum)
    {
        //用二维数组存储序列 [x,y]==>x为所有个位数的数量即10,y为序列长度,在第二维存放数据,增加一列作为标识
        int[,] tempArray = new int[arrayNum,array.Length+1];
        for(int i = 0; i < array.Length; i++)
        {
            for(int j = 0; j < 10; j++)
            {
                if (array[i] % 10 == j)
                {
                    tempArray[j, tempArray[j, array.Length]] = array[i];
                    tempArray[j, array.Length]++;
                }
            }
        }
        //取出
        TakeOut(array, tempArray);
        //根据十位存放
        for (int i = 0; i < array.Length; i++)
        {
            int index = 0;
            for (int j = 0; j < 10; j++)
            {
                if (array[i] / 10 == j)
                {
                    tempArray[j, tempArray[j, array.Length]] = array[i];
                    tempArray[j, array.Length]++;
                }
            }
        }
        //再取出
        TakeOut(array, tempArray);
    }
    private void TakeOut(int[] array, int[,] tempArray)
    {
        int index = 0;
        for (int i = 0; i < 10; i++)
        {
            if (tempArray[i, array.Length] > 0)
            {
                for (int j = 0; j < tempArray[i, array.Length]; j++)
                {
                    array[index] = tempArray[i, j];
                    index++;
                }
            }
        }
       for(int i = 0; i < 10; i++)
        {
            tempArray[i, array.Length] = 0;
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
