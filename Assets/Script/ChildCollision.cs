using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChildCollision : MonoBehaviour
{
    IBook book;

    void Start()
    {
        book = GetComponentInParent<IBook>();
    }

    void OnTriggerEnter2D(Collider2D col)
    {
        book?.Collision(col);
    }

    void OnTriggerStay2D(Collider2D col)
    {
        book?.Collision(col);
    }
}
