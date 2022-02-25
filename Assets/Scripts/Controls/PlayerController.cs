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

    /*
    [SerializeField] private AudioClip audioWalking;
    [SerializeField] private AudioClip audioRunning;
    private AudioSource audioSource;

    //Audio Flags
    private bool isWalking;
    private bool isRunning;
    private bool isIdling;

    private bool walkingAudioPlaying;
    private bool runningAudioPlaying;
    private bool sneakingAudioPlaying;
    */

    // Start is called before the first frame update
    void Start()
    {
        //reference the FixedJoystick script/object in the canvas
        _joystick = FixedJoystick.FindObjectOfType<FixedJoystick>();
        //referencing the AR Camera
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        //referemcing the audio source
        //audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        /*
        //Audio
        //Walking
        if (isWalking == true && walkingAudioPlaying == false)
        {
            //playing the walking footsteps audio
            audioSource.PlayOneShot(audioWalking);
            //reset volume
            audioSource.volume = 0.5f;
            //set flag
            walkingAudioPlaying = true;

            runningAudioPlaying = false;
            sneakingAudioPlaying = false;
        }
        //Running
        else if (isRunning == true && runningAudioPlaying == false)
        {
            //playing the running footsteps audio
            audioSource.PlayOneShot(audioRunning);
            //reset volume
            audioSource.volume = 0.5f;
            //set flag
            runningAudioPlaying = true;

            walkingAudioPlaying = false;
            sneakingAudioPlaying = false;
        }
        //Sneaking
        else if (crouching == true && sneakingAudioPlaying == false)
        {
            //playing the walking footsteps audio but with reduced volume
            audioSource.PlayOneShot(audioWalking);
            //reduce volume
            audioSource.volume = 0.2f;
            //set flag
            sneakingAudioPlaying = true;

            walkingAudioPlaying = false;
            runningAudioPlaying = false;
        }
        //Idle
        else if (isIdling == true)
        {
            //No footstep audio, because the player is standing still
            audioSource.Stop();
        }
        */

        //For Debugging: Printing the joystick pos into the console (from -1 to 1)
        //Debug.Log("Joystick Hor: " + _joystick.Horizontal);
        //Debug.Log("Joystick Ver: " + _joystick.Vertical);
    }

    private void FixedUpdate()
    {
        //Normal Movement

        // - - - Walking - - - //

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

            //Animation Flags
            //Walking
            _animator.SetBool("isWalking", true);
            //No longer running
            _animator.SetBool("isRunning", false);
            //No longer idling
            _animator.SetBool("isIdling", false);

            /*
            //Audio Flags
            //Walking
            isWalking = true;
            //No longer running
            isRunning = false;
            //No longer idling
            isIdling = false;
            */

            //saving the last rotation, while moving
            lastRotation = _rigidbody.velocity;

            //set walking flag

            // - - - Running - - - //

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

                //Animation Flags
                //Running
                _animator.SetBool("isRunning", true);
                //No longer walking
                _animator.SetBool("isWalking", false);
                
                /*
                //Audio Flags
                //Running
                isRunning = true;
                //No longer walking
                isWalking = false;
                */

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

                //Animation Flags
                //Running
                _animator.SetBool("isRunning", true);
                //No longer walking
                _animator.SetBool("isWalking", false);

                /*
                //Audio Flags
                //Running
                isRunning = true;
                //No longer walking
                isWalking = false;
                */
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
            //Animation Flags
            //Idling
            _animator.SetBool("isIdling", true);
            //No longer walking
            _animator.SetBool("isWalking", false);
            //No longer running
            _animator.SetBool("isRunning", false);

            /*
            //Audio Flags
            //Idling
            isIdling = true;
            //Running
            isRunning = false;
            //No longer walking
            isWalking = false;
            */

            //copying the last rotation, while standing still
            transform.rotation = Quaternion.LookRotation(lastRotation);

            //Stop the Footsteps audio
            //audioSource.Stop();
        }
    }

    // - - - Function Archive - - - //



}
