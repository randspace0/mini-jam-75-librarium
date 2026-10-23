using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [Header("Movement")]
    [SerializeField] private float speed;
    [SerializeField] private float jumpForce;
    private float horizontalMoveInput;
    private float verticalMoveInput;
    [SerializeField] private bool isFacingRight;

    [Space]
    [SerializeField] public bool isGrounded;
    [SerializeField] public Transform groundCheck;
    [SerializeField] public LayerMask groundLayer;
    [SerializeField] float checkRadius;

    [Header("Books Prefabs")]
    [SerializeField] private GameObject woodBook;
    [SerializeField] private GameObject fireBook;

    [Header("Ability Stuff")]
    [SerializeField] private Vector3 bookThrowOffset;
    [SerializeField] private GameObject stumpPrefab;
    [SerializeField] private float stumpMakingRate;
    [Space]
    [SerializeField] private GameObject fireBall;
    [SerializeField] private float fireRateForFireBall;
    [SerializeField] public Transform firePoint;
    public IAbility currentAbility = null;
    public Animator animator;
 

    public bool hasWoodBook { get; protected set; }
    public bool hasFireBook { get; protected set; }

    float stumpDelay;
    float fireDelay;

    private Rigidbody2D rb2d;


    // Start is called before the first frame update
    void Start()
    {
        rb2d = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();

        stumpDelay = stumpMakingRate;
        fireDelay = fireRateForFireBall;
    }

    private void Update()
    {
        horizontalMoveInput = Input.GetAxisRaw("Horizontal");
        animator.SetFloat("horizontalSpeed", Mathf.Abs(horizontalMoveInput));
        animator.SetFloat("verticalSpeed", rb2d.velocity.y);
        // WoodAbility();
        // FireAbility();

        //This line of code will control the jump power or DO the jump!!
        if (Input.GetKey(KeyCode.UpArrow) && isGrounded)
        {
            if (currentAbility == null)
            {
                rb2d.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
            }
        }

        // if (Input.GetKey(KeyCode.Backspace))
        // {
        //     DropBook();
        // }
            

       if (Input.GetKeyDown(KeyCode.Space))
        {
            if (currentAbility != null)
            {
                Debug.Log("Cast");
                currentAbility.Cast(this);
            }
        }

        if (Input.GetKeyDown(KeyCode.Q))
        {
            if (currentAbility != null)
            {
                currentAbility.Drop(this);
            }
        }
    }

    void FixedUpdate()
    {
        isGrounded = Physics2D.OverlapCircle(groundCheck.position, checkRadius, groundLayer);

        rb2d.velocity = new Vector2(horizontalMoveInput * speed, rb2d.velocity.y);
        if (isFacingRight && horizontalMoveInput > 0f)
        {
            Flip();
        }
        else if (!isFacingRight && horizontalMoveInput < 0f)
        {
            Flip();
        }
    }

    public void Flip()
    {
        isFacingRight = !isFacingRight;
        
        transform.Rotate(0f, 180f, 0f);
    }

    // private void OnCollisionEnter2D(Collision2D collision)
    // {
    //     if(collision.gameObject.GetComponent<Books>().bookName == "WoodBook" && !hasFireBook)
    //     {
    //         hasWoodBook = true;
    //     }
    //     else if(collision.gameObject.GetComponent<Books>().bookName == "FireBook" && !hasWoodBook)
    //     {
    //         hasFireBook = true;
    //     }
    // }

    public void WoodAbility()
    {
        if (hasWoodBook)
        {
            if (Input.GetKey(KeyCode.Space) && stumpDelay <= 0)
            {
                var hit = Physics2D.Raycast(transform.position, Vector2.down, Mathf.Infinity, groundLayer);
                if (hit)
                {
                    Instantiate(stumpPrefab, hit.point, Quaternion.identity);
                }
                stumpDelay = 2f;
            }
            else if (stumpDelay > 0)
            {
                stumpDelay -= Time.deltaTime;
            }
        }
    }

    public void FireAbility()
    {
        if (hasFireBook)
        {
            if (Input.GetKeyDown(KeyCode.Space) && fireDelay <= 0)
            {
                Instantiate(fireBall, firePoint.position, firePoint.rotation);
                fireDelay = fireRateForFireBall;
            }
            else if(fireDelay > 0)
            {
                fireDelay -= Time.deltaTime;
            }
        }
    }

    public void DropBook()
    {
        if (hasWoodBook)
        {
            Instantiate(woodBook, transform.position - bookThrowOffset, woodBook.transform.rotation);
            hasWoodBook = false;
        }
        else if (hasFireBook)
        {
            Instantiate(fireBook, transform.position - bookThrowOffset, fireBook.transform.rotation);
            hasFireBook = false;
        }
    }

    /* private void OnDrawGizmos()
     {
         Gizmos.color = Color.yellow;
         Gizmos.DrawWireSphere(groundCheck.position, checkRadius);
     }
    */
}
