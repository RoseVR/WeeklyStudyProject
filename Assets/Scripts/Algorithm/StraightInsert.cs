using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StraightInsert : MonoBehaviour
{
    //直接插入排序 假设第0个数为已排序的数 从第一个开始 往前比较，当遇到顺序不对则调换，一直比较到第0个后 继续从第二个开始往前比较 如此到全部比完
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
        StraightInsertSort(Array, 1);
    }
    private void StraightInsertSort(int[] array,int index)
    {
        if (index < array.Length)
        {
            int temp = 0;
            for(int i = index; i > 0; i--)
            {
                if (array[i] < array[i - 1])
                {
                    temp = array[i - 1];
                    array[i - 1] = array[i];
                    array[i] = temp;
                }
            }
            index++;
            StraightInsertSort(array, index);
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
