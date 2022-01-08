using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelectionSort : MonoBehaviour
{
    public int[] Array;
    //选择排序： 从当前选择出最小的数放在序列的首位
    // Start is called before the first frame update
    void Start()
    {
        Array=new int[] { 10, 5, 1, 2, 6, 4, 3, 8, 9, 7 };
        int left = 0;
        ChooseToSort(left);
    }

    private void ChooseToSort(int left)
    {
        if (left < Array.Length - 1)
        {
            int temp = Array[left];
            int index = left;
            for (int j = left + 1; j < Array.Length; j++)
            {
                if (temp > Array[j])
                {
                    temp = Array[j];
                    index = j;
                }
            }
            Array[index] = Array[left];
            Array[left] = temp;
            left++;
            ChooseToSort(left);
        }
        else
        {
            for(int i = 0; i < Array.Length; i++)
            {
                Debug.Log("  选择排序: " + Array[i]);
            }
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
