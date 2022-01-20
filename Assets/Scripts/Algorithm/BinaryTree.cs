using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Node<T>
{
    public T data;
    public Node<T> leftChild;
    public Node<T> rightChild;
    public Node<T> parentNode;

    public Node(T t)
    {
        data = t;
    }
}

public class BinaryTree : MonoBehaviour
{
    public int[] Array;
    // Start is called before the first frame update
    void Start()
    {
        Array = new int[] { 10, 6, 7, 4, 8, 2, 1 };
    }
    private void InsertNode(int num,int index,int[] array)
    {
        //根节点
        if (index == 0)
        {
            Node<int> root = new Node<int>(num);
            root.parentNode = null;
            root.leftChild = new Node<int>(array[index + 1]);
            root.rightChild= new Node<int>(array[index + 2]);
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
