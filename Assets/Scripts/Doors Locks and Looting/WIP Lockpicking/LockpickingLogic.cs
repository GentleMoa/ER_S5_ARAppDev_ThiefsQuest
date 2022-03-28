using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class LockpickingLogic : MonoBehaviour
{
    //Camera
    private Camera arCamera;
    //Lockpicking objects
    public GameObject lockpickGeneral;
    [SerializeField] private GameObject lockpick_1;
    [SerializeField] private GameObject lockpick_2;
    [SerializeField] private GameObject lockpick_3;
    [SerializeField] private GameObject lockpick_4;
    //Lockpicks State Flags
    public bool lockpick_1_Active = false;
    public bool lockpick_2_Active = false;
    public bool lockpick_3_Active = false;
    public bool lockpick_4_Active = false;
    //Lockpicks Rest Positions & Flags
    private Vector3 lockpick_1_restPos;
    private Vector3 lockpick_2_restPos;
    private Vector3 lockpick_3_restPos;
    private Vector3 lockpick_4_restPos;
    private Vector3 lockpick_1_restRot;
    private Vector3 lockpick_2_restRot;
    private Vector3 lockpick_3_restRot;
    private Vector3 lockpick_4_restRot;
    private bool lockpick_1_restFlag = false;
    private bool lockpick_2_restFlag = false;
    private bool lockpick_3_restFlag = false;
    private bool lockpick_4_restFlag = false;
    //Lockpicks Action Positions, Rotations & Flags
    private Vector3 lockpick_1_actionPos;
    private Vector3 lockpick_2_actionPos;
    private Vector3 lockpick_3_actionPos;
    private Vector3 lockpick_4_actionPos;
    //private Quaternion lockpick_1_actionRot;
    //private Quaternion lockpick_2_actionRot;
    //private Quaternion lockpick_3_actionRot;
    //private Quaternion lockpick_4_actionRot;
    private bool lockpick_1_actionFlag = false;
    private bool lockpick_2_actionFlag = false;
    private bool lockpick_3_actionFlag = false;
    private bool lockpick_4_actionFlag = false;
    //Rigidbody variables
    private bool lockpick_1_hasRB = false;
    private bool lockpick_2_hasRB = false;
    private bool lockpick_3_hasRB = false;
    private bool lockpick_4_hasRB = false;
    //UI Debugging
    public GameObject uiDebugger;
    private bool showUIDebugger = false;
    //Lockpick Inputs
    public Vector2 touchPosition = default;
    public bool onTouchHold = false;
    public Vector3 dragPosition = new Vector3();
    [SerializeField] private LayerMask lockpickLayer;
    //Controls / UI Management
    private bool lockpickingOngoing = true;
    private bool controlsDisabled = false;
    private GameObject uiJoystick;
    private GameObject uiSneakButton;
    private GameObject uiTotalLoot;
    private GameObject uiMenuButton;
    //Gyroscope Handling
    private Gyroscope gyro;
    private Quaternion gyroRotation;
    private bool gyroActive = false;

    // Start is called before the first frame update
    void Start()
    {
        //Referencing
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        uiDebugger = GameObject.FindGameObjectWithTag("UIDebugger");
        lockpickLayer = LayerMask.GetMask("Lockpick_Plane");

        //disabling the Lockpick Raycast Plane childed to the camera
        arCamera.transform.GetChild(0).gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        //Selecting the lockpicks
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            touchPosition = touch.position;

            if (touch.phase == TouchPhase.Began)
            {
                Ray ray = arCamera.ScreenPointToRay(touch.position);
                RaycastHit hitObject;
                if (Physics.Raycast(ray, out hitObject))
                {
                    /*
                    if (hitObject.transform.gameObject != null)
                    {
                        //Debugging
                        if (uiDebugger.GetComponent<Image>().enabled == false)
                        {
                            uiDebugger.GetComponent<Image>().enabled = true;
                            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
                            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = hitObject.transform.gameObject.name;
                        }
                    }
                    */

                    //Grabbing the correct lockpick parent obj
                    if (hitObject.transform.tag == "Lockpick_SubColl")
                    {
                        lockpickGeneral = hitObject.transform.gameObject.transform.parent.gameObject.transform.parent.gameObject;

                        /*
                        //Debugging
                        if (uiDebugger.GetComponent<Image>().enabled == false)
                        {
                            uiDebugger.GetComponent<Image>().enabled = true;
                            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
                        }
                        uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "HitObject: " + hitObject.transform.gameObject + ", Hit Object_P1: " + hitObject.transform.gameObject.transform.parent.gameObject + ", Hit Object_P2: " + hitObject.transform.gameObject.transform.parent.gameObject.transform.parent.gameObject + ", Lockpick_General: " + lockpickGeneral;
                        */
                }
                else if (hitObject.transform.tag == "Lockpick_Mesh")
                    {
                        lockpickGeneral = hitObject.transform.gameObject.transform.parent.gameObject;

                        /*
                        //Debugging
                        if (uiDebugger.GetComponent<Image>().enabled == false)
                        {
                            uiDebugger.GetComponent<Image>().enabled = true;
                            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
                        }
                        uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "HitObject: " + hitObject.transform.gameObject + ", Hit Object_P1: " + hitObject.transform.gameObject.transform.parent.gameObject + ", Lockpick_General: " + lockpickGeneral;
                        */
                    }

                    //onTouchHold flag is set to true
                    onTouchHold = true;

                    #region LockpickSelection

                    //if the hit object has the tag "Lockpick_1", then ...
                    if (lockpickGeneral.tag == "Lockpick_1")
                    {
                        //... I convert the hit of type hit to "Lockpick_1" of type gameObject
                        lockpick_1 = lockpickGeneral;
                        //change the mat for debugging purposes
                        //lockpick_1.transform.GetChild(0).GetComponent<Renderer>().material.color = Color.red;
                        //Reset other lockpicks to rest pos
                        Lockpick_2ToRestPos();
                        Lockpick_3ToRestPos();
                        Lockpick_4ToRestPos();
                        //flags (selection)
                        lockpick_1_Active = true;
                        lockpick_2_Active = false;
                        lockpick_3_Active = false;
                        lockpick_4_Active = false;
                        //Lockpick_1 set rest position
                        if (lockpick_1_restFlag == false)
                        {
                            lockpick_1_restPos = lockpick_1.transform.position;
                            lockpick_1_restRot = lockpick_1.transform.rotation.eulerAngles;
                            lockpick_1_restFlag = true;
                        }
                        //flags (action)
                        lockpick_2_actionFlag = false;
                        lockpick_3_actionFlag = false;
                        lockpick_4_actionFlag = false;
                    }

                    //if the hit object has the tag "Lockpick_2", then ...
                    else if (lockpickGeneral.tag == "Lockpick_2")
                    {
                        //... I convert the hit of type hit to "Lockpick_2" of type gameObject
                        lockpick_2 = lockpickGeneral;
                        //change the mat for debugging purposes
                        //lockpick_2.transform.GetChild(0).GetComponent<Renderer>().material.color = Color.red;
                        //Reset other lockpicks to rest pos
                        Lockpick_1ToRestPos();
                        Lockpick_3ToRestPos();
                        Lockpick_4ToRestPos();
                        //flags
                        lockpick_1_Active = false;
                        lockpick_2_Active = true;
                        lockpick_3_Active = false;
                        lockpick_4_Active = false;
                        //Lockpick_2 set rest position
                        if (lockpick_2_restFlag == false)
                        {
                            lockpick_2_restPos = lockpick_2.transform.position;
                            lockpick_2_restRot = lockpick_2.transform.rotation.eulerAngles;
                            lockpick_2_restFlag = true;
                        }
                        //flags (action)
                        lockpick_1_actionFlag = false;
                        lockpick_3_actionFlag = false;
                        lockpick_4_actionFlag = false;
                    }

                    //if the hit object has the tag "Lockpick_3", then ...
                    else if (lockpickGeneral.tag == "Lockpick_3")
                    {
                        //... I convert the hit of type hit to "Lockpick_3" of type gameObject
                        lockpick_3 = lockpickGeneral;
                        //change the mat for debugging purposes
                        //lockpick_3.transform.GetChild(0).GetComponent<Renderer>().material.color = Color.red;
                        //Reset other lockpicks to rest pos
                        Lockpick_1ToRestPos();
                        Lockpick_2ToRestPos();
                        Lockpick_4ToRestPos();
                        //flags
                        lockpick_1_Active = false;
                        lockpick_2_Active = false;
                        lockpick_3_Active = true;
                        lockpick_4_Active = false;
                        //Lockpick_3 set rest position
                        if (lockpick_3_restFlag == false)
                        {
                            lockpick_3_restPos = lockpick_3.transform.position;
                            lockpick_3_restRot = lockpick_3.transform.rotation.eulerAngles;
                            lockpick_3_restFlag = true;
                        }
                        //flags (action)
                        lockpick_1_actionFlag = false;
                        lockpick_2_actionFlag = false;
                        lockpick_4_actionFlag = false;
                    }

                    //if the hit object has the tag "Lockpick_4", then ...
                    else if (lockpickGeneral.tag == "Lockpick_4")
                    {
                        //... I convert the hit of type hit to "Lockpick_4" of type gameObject
                        lockpick_4 = lockpickGeneral;
                        //change the mat for debugging purposes
                        //lockpick_4.transform.GetChild(0).GetComponent<Renderer>().material.color = Color.red;
                        //Reset other lockpicks to rest pos
                        Lockpick_1ToRestPos();
                        Lockpick_2ToRestPos();
                        Lockpick_3ToRestPos();
                        //flags
                        lockpick_1_Active = false;
                        lockpick_2_Active = false;
                        lockpick_3_Active = false;
                        lockpick_4_Active = true;
                        //Lockpick_4 set rest position
                        if (lockpick_4_restFlag == false)
                        {
                            lockpick_4_restPos = lockpick_4.transform.position;
                            lockpick_4_restRot = lockpick_4.transform.rotation.eulerAngles;
                            lockpick_4_restFlag = true;
                        }
                        //flags (action)
                        lockpick_1_actionFlag = false;
                        lockpick_2_actionFlag = false;
                        lockpick_3_actionFlag = false;
                    }

                    #endregion

                }
            }

            #region TouchEnded

            //If stopped touching, onTouchHold is set to false
            if (touch.phase == TouchPhase.Ended)
            {
                //setting the holding flag to false
                onTouchHold = false;
                //disabling the Lockpick Raycast Plane childed to the camera
                arCamera.transform.GetChild(0).gameObject.SetActive(false);
                //disabling the gyro
                //DisableGyro();
                /*
                if (lockpick_1_hasRB == true)
                {
                    //destroy the rb component
                    Destroy(lockpick_1.GetComponent<Rigidbody>());
                    lockpick_1_hasRB = false;
                }
                else if (lockpick_2_hasRB == true)
                {
                    //destroy the rb component
                    Destroy(lockpick_2.GetComponent<Rigidbody>());
                    lockpick_2_hasRB = false;
                }
                else if (lockpick_3_hasRB == true)
                {
                    //destroy the rb component
                    Destroy(lockpick_3.GetComponent<Rigidbody>());
                    lockpick_3_hasRB = false;
                }
                else if (lockpick_4_hasRB == true)
                {
                    //destroy the rb component
                    Destroy(lockpick_4.GetComponent<Rigidbody>());
                    lockpick_4_hasRB = false;
                }
                */
            }

            #endregion

            Lockpick_Input();
        }

        LockpickToActionPos();
        //UIDebuggerInfo();
        ControlsDisabler();
        ControlsEnabler();

        //GetGyroRotation();
    }

    //Lockpick Functions

    #region LockpickToActionPos

    public void LockpickToActionPos()
    {
        //Lockpicking with lockpick_1
        if (lockpick_1_Active == true && lockpick_1_actionFlag == false)
        {
            //move into action position
            lockpick_1.transform.position = new Vector3(this.transform.position.x, this.transform.position.y + 0.1f, this.transform.position.z - 0.1f);
            lockpick_1.transform.Rotate(-75.0f, 90.0f, -75.0f);
            //saving the action pose rotation
            //lockpick_1_actionRot = lockpick_1.transform.rotation;
            //set actionFlag
            lockpick_1_actionFlag = true;
        }
        //Lockpicking with lockpick_2
        else if (lockpick_2_Active == true && lockpick_2_actionFlag == false)
        {
            //move into action position
            lockpick_2.transform.position = new Vector3(this.transform.position.x, this.transform.position.y + 0.1f, this.transform.position.z - 0.1f);
            lockpick_2.transform.Rotate(-75.0f, 90.0f, -75.0f);
            //saving the action pose rotation
            //lockpick_2_actionRot = lockpick_2.transform.rotation;
            //set actionFlag
            lockpick_2_actionFlag = true;
        }
        //Lockpicking with lockpick_3
        else if (lockpick_3_Active == true && lockpick_3_actionFlag == false)
        {
            //move into action position
            lockpick_3.transform.position = new Vector3(this.transform.position.x, this.transform.position.y + 0.1f, this.transform.position.z - 0.1f);
            lockpick_3.transform.Rotate(-75.0f, 90.0f, -75.0f);
            //saving the action pose rotation
            //lockpick_3_actionRot = lockpick_3.transform.rotation;
            //set actionFlag
            lockpick_3_actionFlag = true;
        }
        //Lockpicking with lockpick_4
        else if (lockpick_4_Active == true && lockpick_4_actionFlag == false)
        {
            //move into action position
            lockpick_4.transform.position = new Vector3(this.transform.position.x, this.transform.position.y + 0.1f, this.transform.position.z - 0.1f);
            lockpick_4.transform.Rotate(-75.0f, 90.0f, -75.0f);
            //saving the action pose rotation
            //lockpick_4_actionRot = lockpick_4.transform.rotation;
            //set actionFlag
            lockpick_4_actionFlag = true;
        }
    }

    #endregion

    #region LockpickToRestPos

    //Lockpicks to Rest Position
    private void Lockpick_1ToRestPos()
    {
        if (lockpick_1_Active == true)
        {
            lockpick_1.transform.position = lockpick_1_restPos;
            lockpick_1.transform.eulerAngles = lockpick_1_restRot;
        }
    }
    private void Lockpick_2ToRestPos()
    {
        if (lockpick_2_Active == true)
        {
            lockpick_2.transform.position = lockpick_2_restPos;
            lockpick_2.transform.eulerAngles = lockpick_2_restRot;
        }
    }
    private void Lockpick_3ToRestPos()
    {
        if (lockpick_3_Active == true)
        {
            lockpick_3.transform.position = lockpick_3_restPos;
            lockpick_3.transform.eulerAngles = lockpick_3_restRot;
        }
    }
    private void Lockpick_4ToRestPos()
    {
        if (lockpick_4_Active == true)
        {
            lockpick_4.transform.position = lockpick_4_restPos;
            lockpick_4.transform.eulerAngles = lockpick_4_restRot;
        }
    }

    #endregion

    #region LockpickInputs

    //Lockpick inputs
    private void Lockpick_Input()
    {
        if (onTouchHold == true)
        {
            //dragPosition now stores the touchPosition on Screen with a offset from the camera z, translated into world space 
            //dragPosition = arCamera.ScreenToWorldPoint(new Vector3(touchPosition.x, touchPosition.y, arCamera.transform.GetChild(0).transform.position.z));
            //dragPosition = arCamera.ScreenPointToRay()

            //enabling the gyro
            //EnableGyro();

            //enabling the Lockpick Raycast Plane childed to the camera
            arCamera.transform.GetChild(0).gameObject.SetActive(true);

            //Raycast variables
            Ray ray_lockpick = arCamera.ScreenPointToRay(touchPosition);
            RaycastHit hitObject_lockpick;


            if (Physics.Raycast(ray_lockpick, out hitObject_lockpick/*, lockpickLayer*/))
            {
                
                /*//Lockpick pos only updates, if raycast detects hit on target plane (IF THIS IS COMMENTED OUT, RAYCAST TARGET PLANE (CHILD OF CAMERA) IS DISABLED)
                if (hitObject_lockpick.collider.gameObject.tag == "Lock_RaycastTarget")
                {
                    dragPosition = hitObject_lockpick.point;
                }
                */
                dragPosition = hitObject_lockpick.point;
            }

            //placing the lockpicks at the dragPosition pos gives the player control over them.
            if (lockpick_1_Active == true)
            {
                /*
                if (lockpick_1_hasRB == false)
                {
                    //adding a rb component
                    Rigidbody lockpick_1_rb = lockpick_1.AddComponent<Rigidbody>() as Rigidbody;
                    lockpick_1_rb.useGravity = false;
                    lockpick_1_hasRB = true;
                }
                */
                //Updating the lockpick.pos to the drag.pos
                lockpick_1.transform.position = dragPosition;
                //Rotate the lockpick like the camera
                //lockpick_1.transform.localRotation = arCamera.transform.rotation /* gyroRotation */ /* * lockpick_1_actionRot */;
            }
            else if (lockpick_2_Active == true)
            {
                /*
                if (lockpick_2_hasRB == false)
                {
                    //adding a rb component
                    Rigidbody lockpick_2_rb = lockpick_2.AddComponent<Rigidbody>() as Rigidbody;
                    lockpick_2_rb.useGravity = false;
                    lockpick_2_hasRB = true;
                }
                */
                //Updating the lockpick.pos to the drag.pos
                lockpick_2.transform.position = dragPosition;
                //Rotate the lockpick like the camera
                //lockpick_2.transform.localRotation = arCamera.transform.rotation /* gyroRotation */  /* * lockpick_2_actionRot */
                ;
            }
            else if (lockpick_3_Active == true)
            {
                /*
                if (lockpick_3_hasRB == false)
                {
                    //adding a rb component
                    Rigidbody lockpick_3_rb = lockpick_3.AddComponent<Rigidbody>() as Rigidbody;
                    lockpick_3_rb.useGravity = false;
                    lockpick_3_hasRB = true;
                }
                */
                //Updating the lockpick.pos to the drag.pos
                lockpick_3.transform.position = dragPosition;
                //Rotate the lockpick like the camera
                //lockpick_3.transform.localRotation = arCamera.transform.rotation /* gyroRotation */  /* * lockpick_3_actionRot */
                ;
            }
            else if (lockpick_4_Active == true)
            {
                /*
                if (lockpick_4_hasRB == false)
                {
                    //adding a rb component
                    Rigidbody lockpick_4_rb = lockpick_4.AddComponent<Rigidbody>() as Rigidbody;
                    lockpick_4_rb.useGravity = false;
                    lockpick_4_hasRB = true;
                }
                */
                //Updating the lockpick.pos to the drag.pos
                lockpick_4.transform.position = dragPosition;
                //Rotate the lockpick like the camera
                //lockpick_4.transform.localRotation = arCamera.transform.rotation /* gyroRotation */  /* * lockpick_4_actionRot */
                ;
            }
        }
    }

    #endregion

    //UI Debugging Functions

    #region UIDebugger

    private void UIDebuggerInfo()
    {
        if (lockpick_1_Active || lockpick_2_Active || lockpick_3_Active || lockpick_4_Active)
        {
            //UI Debugging
            uiDebugger.GetComponent<Image>().enabled = true;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
            //uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "Lockpick_1: " + lockpick_1_Active + ", Lockpick_2" + lockpick_2_Active + ", Lockpick_3" + lockpick_3_Active + ", Lockpick_4" + lockpick_4_Active;
            //uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "touchPosition: " + touchPosition + ", onTouchHold: " + onTouchHold + ", dragPosition: " + dragPosition + ", CameraPos: " + arCamera.transform.position;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = lockpickGeneral.tag + ": " + lockpickGeneral.transform.rotation.eulerAngles;
        }

        /*
        if (showUIDebugger == false)
        {
            uiDebugger.GetComponent<Image>().enabled = true;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "Lockpick_1_Active: " + lockpick_1_Active + ", Lockpick_2_Active: " + lockpick_2_Active + ", Lockpick_3_Active: " + lockpick_3_Active + ", Lockpick_4_Active: " + lockpick_4_Active;
            showUIDebugger = true;
        }
        */
                    }

    #endregion

    //Controls

    #region ControlsDisabler

    private void ControlsDisabler()
    {
        if (lockpickingOngoing == true && controlsDisabled == false)
        {
            if (uiJoystick == null || uiSneakButton == null || uiTotalLoot == null || uiMenuButton == null)
            {
                uiJoystick = GameObject.FindGameObjectWithTag("Joystick");
                uiSneakButton = GameObject.FindGameObjectWithTag("SneakButton");
                uiTotalLoot = GameObject.FindGameObjectWithTag("TotalLootUI");
                uiMenuButton = GameObject.FindGameObjectWithTag("ToMenuButton");
            }

            uiJoystick.GetComponent<Image>().enabled = false;
            uiJoystick.transform.GetChild(0).gameObject.GetComponent<Image>().enabled = false;
            uiSneakButton.GetComponent<Image>().enabled = false;
            uiTotalLoot.GetComponent<Image>().enabled = false;
            uiTotalLoot.transform.GetChild(0).gameObject.GetComponent<TMP_Text>().enabled = false;
            uiMenuButton.GetComponent<Image>().enabled = false;

            controlsDisabled = true;
        }
    }

    #endregion

    #region ControlsEnabler

    private void ControlsEnabler()
    {
        if (lockpickingOngoing == false && controlsDisabled == true)
        {
            if (uiJoystick == null || uiSneakButton == null || uiTotalLoot == null || uiMenuButton == null)
            {
                uiJoystick = GameObject.FindGameObjectWithTag("Joystick");
                uiSneakButton = GameObject.FindGameObjectWithTag("SneakButton");
                uiTotalLoot = GameObject.FindGameObjectWithTag("TotalLootUI");
                uiMenuButton = GameObject.FindGameObjectWithTag("ToMenuButton");
            }

            uiJoystick.GetComponent<Image>().enabled = true;
            uiJoystick.transform.GetChild(0).gameObject.GetComponent<Image>().enabled = true;
            uiSneakButton.GetComponent<Image>().enabled = true;
            uiTotalLoot.GetComponent<Image>().enabled = true;
            uiTotalLoot.transform.GetChild(0).gameObject.GetComponent<TMP_Text>().enabled = true;
            uiMenuButton.GetComponent<Image>().enabled = true;

            controlsDisabled = false;
        }
    }

    #endregion
}
