using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private Rigidbody _rigidbody;
    [SerializeField] private FixedJoystick _joystick;
    [SerializeField] private Animator _animator;

    private Vector3 lastRotation;
    private Vector3 playerMovementVector;

    public float playerMovementSpeed;

    public bool crouching = false;

    private Camera arCamera;

    // Start is called before the first frame update
    void Start()
    {
        //reference the FixedJoystick script/object in the canvas
        _joystick = FixedJoystick.FindObjectOfType<FixedJoystick>();
        //referencing the AR Camera
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        //For Debugging: Printing the joystick pos into the console (from -1 to 1)
        //Debug.Log("Joystick Hor: " + _joystick.Horizontal);
        //Debug.Log("Joystick Ver: " + _joystick.Vertical);
    }

    private void FixedUpdate()
    {
        //Normal Movement
        if (_joystick.Horizontal != 0 || _joystick.Vertical != 0)
        {
            if (crouching == false)
            {
                //Setting the walking speed
                playerMovementSpeed = 0.5f;
            }
            else if (crouching == true)
            {
                //Setting the crouch walking speed
                playerMovementSpeed = 0.4f;
            }

            //Walking
            _animator.SetBool("isWalking", true);
            //No longer running
            _animator.SetBool("isRunning", false);
            //No longer idling
            _animator.SetBool("isIdling", false);

            //saving the last rotation, while moving
            lastRotation = _rigidbody.velocity;

            if (_joystick.Horizontal > 0.7 || _joystick.Vertical > 0.7)
            {
                if (crouching == false)
                {
                    //Setting the walking speed
                    playerMovementSpeed = 0.6f;
                }
                else if (crouching == true)
                {
                    //Setting the crouch walking speed
                    playerMovementSpeed = 0.4f;
                }

                //Running
                _animator.SetBool("isRunning", true);
                //No longer walking
                _animator.SetBool("isWalking", false);
            }
            else if (_joystick.Horizontal < -0.7 || _joystick.Vertical < -0.7)
            {
                if (crouching == false)
                {
                    //Setting the walking speed
                    playerMovementSpeed = 0.6f;
                }
                else if (crouching == true)
                {
                    //Setting the crouch walking speed
                    playerMovementSpeed = 0.4f;
                }

                //Running
                _animator.SetBool("isRunning", true);
                //No longer walking
                _animator.SetBool("isWalking", false);
            }

            //
            //playerMovementVector = arCamera.transform.TransformDirection( new Vector3(_joystick.Horizontal* playerMovementSpeed, /* _rigidbody.velocity.y */ 0.0f, _joystick.Vertical* playerMovementSpeed) );
            playerMovementVector = new Vector3(_joystick.Horizontal * playerMovementSpeed, /* _rigidbody.velocity.y */ 0.0f, _joystick.Vertical * playerMovementSpeed);

            Vector3 camForward = arCamera.transform.forward;
            camForward.y = 0.0f;
            Quaternion camRotationFlattened = Quaternion.LookRotation(camForward);
            playerMovementVector = camRotationFlattened * playerMovementVector;


            //moving the character in the direction of the joystick input
            _rigidbody.velocity = playerMovementVector;

            //rotating the character in the direction of the joystick input
            transform.rotation = Quaternion.LookRotation(_rigidbody.velocity);
            
        }
        else if (_joystick.Horizontal == 0 || _joystick.Vertical == 0)
        {
            //Idling
            _animator.SetBool("isIdling", true);
            //No longer walking
            _animator.SetBool("isWalking", false);
            //No longer running
            _animator.SetBool("isRunning", false);

            //copying the last rotation, while standing still
            transform.rotation = Quaternion.LookRotation(lastRotation);
        }
    }

    // - - - Function Archive - - - //



}
