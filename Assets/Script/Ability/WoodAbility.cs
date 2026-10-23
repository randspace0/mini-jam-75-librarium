using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WoodAbility : MonoBehaviour, IAbility
{
    public GameObject prefabStump;
    public WoodBook prefabWoodBook;
    public float FireDelay  = 3f;
    float currentFireDelay = 0f;
    GameObject currentStump = null;

    public void Start()
    {
        prefabStump = (GameObject)Resources.Load("Prefab/Stump");
        prefabWoodBook = Resources.Load<WoodBook>("Prefab/WoodBook");
    }

    public void Cast(PlayerController player)
    {
        if (currentFireDelay <= 0f)
        {
            player.animator.SetTrigger("useWoodAbility");
            var hit = Physics2D.Raycast(player.transform.position, Vector2.down, Mathf.Infinity, LayerMask.GetMask("Ground"));
            if (hit.collider != null && hit.collider.gameObject.tag == "Pedestal")
            {
                hit.collider.GetComponent<Pedestal>().Spell(SpellType.Wood);
            }
            else if (hit.collider != null)
            {
                DestroyCurrentStump();
                currentStump = Instantiate(prefabStump, hit.point, Quaternion.identity);
            }
            currentFireDelay = FireDelay;
        }
    }

    public void Drop(PlayerController player)
    {
        player.animator.SetBool("isHoldingWoodBook", false);
        var woodBook = Instantiate(prefabWoodBook, player.firePoint.transform.position, player.transform.rotation);
        woodBook.UntakeableFor();
        player.currentAbility = null;
        DestroyCurrentStump();
        Destroy(this);
    }

    void Update()
    {
        if (currentFireDelay > 0f)
        {
            currentFireDelay -= Time.deltaTime;
        }
    }

    void DestroyCurrentStump()
    {
        if (currentStump != null)
        {
            Destroy(currentStump);
        }
    }
}
