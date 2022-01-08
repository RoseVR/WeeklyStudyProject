using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleRange : MonoBehaviour
{
    //冒泡排序：两两对比，符合顺序则不调换顺序，不符合顺序则调换顺序,直到所有顺序都符合为止
    public int[] RandomArray = new int[] { 5, 7, 3, 1, 8, 2, 6, 9, 10 };
    // Start is called before the first frame update
    void Start()
    {
        BubbleSort(RandomArray);
    }

    private void BubbleSort(int[] array)
    {
        int m = 0;
        int n = 0;
        for(int i = 0; i < array.Length; i++)
        {
            for(int j = 0; j < array.Length - i - 1; j++)
            {
                if (array[j] > array[j + 1])
                {
                    int temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                    m++;
                }
                n++;
            }
            
        }
        for(int i = 0; i < array.Length; i++)
        {
            Debug.Log(" " + array[i]);
        }
        Debug.Log(" m = " + m+"  n = "+n);
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
