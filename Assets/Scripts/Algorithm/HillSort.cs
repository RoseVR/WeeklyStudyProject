using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HillSort : MonoBehaviour
{
    //希尔排序：插入排序的升级版 插入排序是一个一个往前对比 希尔排序是设定步长对比 每对比结束便缩小一次步长 直到步长为一结束
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
        //设置步长
        int step = Array.Length / 2;
        DoHillSort(step, Array.Length-1);
        for(int i = 0; i < Array.Length; i++)
        {
            Debug.Log(" 希尔排序 : " + Array[i]);
        }
    }
    private void DoHillSort(int step,int right)
    {
        if (right >= step&&step>0)
        {
            for (int i = right; i >= step; i--)
            {
                int temp = Array[i];
                for (int j = i - step; j >= 0; j -= step)
                {
                    if (Array[j] > Array[i])
                    {
                        Array[i] = Array[j];
                        Array[j] = temp;
                        temp = Array[j];
                    }
                }

            }
            step /= 2;
            DoHillSort(step, right);
        }
        
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
