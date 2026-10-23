using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour
{
    public Image woodBookImage;
    public Image fireBookImage;

    PlayerController player;
    // Start is called before the first frame update
    void Start()
    {
        player = FindObjectOfType<PlayerController>();
    }

    // Update is called once per frame
    void Update()
    {
        if (player == null) return;

        if (player.hasWoodBook)
        {
            woodBookImage.enabled = true;
        }
        else { woodBookImage.enabled = false; }

        if (player.hasFireBook)
        {
            fireBookImage.enabled = true;
        }
        else { fireBookImage.enabled = false; }
    }

}
