using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum StatueState
{
    Stone,
    Wood,
    OnFire,
    Burnt
};

public class Statue : MonoBehaviour
{
    public StatueState state = StatueState.Stone;
    public AudioSource audioSource;
    public Animator animator;
    public GameManager gameManager;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        animator = GetComponent<Animator>();
    }

    public bool Spell(SpellType spellType)
    {
        var works = false;
        switch (spellType)
        {
            case SpellType.Wood:
                if (state == StatueState.Stone)
                {
                    // Change the sprite to wood sprite
                    animator.SetBool("givenWoodSpell", true);
                    state = StatueState.Wood;
                    works = true;
                }
                break;
            case SpellType.Fire:
                if (state == StatueState.Wood)
                {
                    // Change the sprite to on fire sprite with the animation?
                    animator.SetBool("givenFireSpell", true);
                    state = StatueState.OnFire;
                    works = true;
                }
                break;
            case SpellType.Water:
                if (state == StatueState.OnFire)
                {
                    // Change the sprite to burnt
                    animator.SetBool("givenWaterSpell", true);
                    state = StatueState.Burnt;
                    works = true;

                    if (gameManager != null)
                    {
                        gameManager.LevelCompleteIn();
                    }
                }
                break;
        };
        return works;
    }
}
