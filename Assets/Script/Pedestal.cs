using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pedestal : MonoBehaviour
{
    public Statue statue;
    public AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    public void Spell(SpellType spellType)
    {
        if (statue != null)
        {
            statue.Spell(spellType);
        }
    }
}
