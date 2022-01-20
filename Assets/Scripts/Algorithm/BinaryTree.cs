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
        for(int i = 0; i < Array.Length; i++)
        {
            InsertNode(i, Array);
        }
    }
    private void InsertNode(int index,int[] array)
    {
        //根节点
        if (index == 0)
        {
            Node<int> root = new Node<int>(array[index]);
            root.parentNode = null;
            if (index + 1 < array.Length)
            {
                root.leftChild = new Node<int>(array[index + 1]);
                root.leftChild.parentNode = root;
            }
            else
                root.leftChild = null;
            if (index + 2 < array.Length)
            {
                root.rightChild = new Node<int>(array[index + 2]);
                root.rightChild.parentNode = root;
            }
            else
                root.rightChild = null;
            Debug.Log(" root = " + root.data + "root.left = " + root.leftChild.data + "right=" + root.rightChild.data);
        }
        else
        {
            Node<int> parent = new Node<int>(array[index]);
            if (index + 1 < array.Length)
            {
                parent.leftChild = new Node<int>(array[index + 1]);
                parent.leftChild.parentNode = parent;
            }
            else
                parent.leftChild = null;
            if (index + 2 < array.Length)
            {
                parent.rightChild = new Node<int>(array[index + 2]);
                parent.rightChild.parentNode = parent;
            }
            else
                parent.rightChild = null;
            Debug.Log(" parent = " + parent.data + "root.left = " + parent.leftChild.data + "right=" + parent.rightChild.data);
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
