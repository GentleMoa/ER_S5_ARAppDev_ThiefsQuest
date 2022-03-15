using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DoorLogic : MonoBehaviour
{
    [SerializeField]
    private GameObject unlockUI;

    private Collider doorwayCol;
    private GameObject door;

    public Button unlockButton;
    private bool uiSpawned = false;

    private GameObject unlockUIToBeDestroyed;

    //arCamera
    //3DLockpickingInterfaceToSpawn (prefab)
    [SerializeField]
    private GameObject lockpickingInterfaceToSpawn3D;

    private Camera arCamera;

    [SerializeField] AudioClip[] unlockSounds;
    [SerializeField] AudioSource audioSource;

    private GameObject arSessionOrigin;
    private bool lockpickingProcessOngoing = false;
    private IngameSceneManagement ingameSceneManagement;

    // Start is called before the first frame update
    void Start()
    {
        doorwayCol = GetComponent<Collider>();
        door = transform.GetChild(0).gameObject;
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();

        arSessionOrigin = GameObject.FindGameObjectWithTag("ARSessionOrigin");
        ingameSceneManagement = GameObject.FindGameObjectWithTag("IngameSceneManager").GetComponent<IngameSceneManagement>();
    }

    // Update is called once per frame
    void Update()
    {
        //If the lockpicking mini-game is currently going on, reduce the size of all AR content by 4x to make the 3D lock model fit
        //if (lockpickingProcessOngoing == true)
        //{
        //    arSessionOrigin.transform.localScale = new Vector3(8.0f, 8.0f, 8.0f);
        //}


        //Unlock door on button press
        /*
         * custom button code
         * if (button press)
         * UnlockDoor() (later start lockpicking mini game instead of simply unlocking the door)
         */
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            SpawnUnlockUI();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player" && uiSpawned == true)
        {
            //Finding the freshly spawned Unlock UI
            unlockUIToBeDestroyed = GameObject.FindGameObjectWithTag("UnlockButton");
            //Destroying it, when the player leaves the trigger without opening (and if there even is one)
            if (unlockUIToBeDestroyed != null)
            {
                Destroy(unlockUIToBeDestroyed);
                //resetting the flag to false
                uiSpawned = false;
            }
        }
    }


    public void UnlockDoor()
    {
        //DEBUGGING
        //Debug.Log("UNLOCK BUTTON CLICK!");

        //Changing the doors hinge joint parameters to allow it to be opened
        JointLimits hjLimits = door.GetComponent<HingeJoint>().limits;
        hjLimits.min = -90;
        hjLimits.max = 90;
        door.GetComponent<HingeJoint>().limits = hjLimits;

        //Destroy the Unlock UI
        //Destroy(transform.GetChild(1).gameObject);
    }

    private void SpawnUnlockUI()
    {
        if (uiSpawned == false)
        {
            //Spawn UI popup button
            Instantiate(unlockUI, this.transform.position + new Vector3(0.0f, 0.6f, 0.0f), this.transform.rotation, transform);

            //Setting the flag to true
            uiSpawned = true;

            //Reference the unlockButton Button (from the world space UI)
            unlockButton = transform.GetChild(1).GetChild(0).gameObject.GetComponent<Button>();
            //Adding the button press listener
            //unlockButton.onClick.AddListener(UnlockDoor);
            unlockButton.onClick.AddListener(Spawn3DLockpickingInterface);
        }

    }

    public void Spawn3DLockpickingInterface()
    {
        //Destroy the Unlock UI
        Destroy(transform.GetChild(1).gameObject);

        //Spawning the 3D Lockpicking Interface, which represents the lockpicking mini game the user has to complete in order to open the door
        Instantiate(lockpickingInterfaceToSpawn3D, arCamera.transform.position + new Vector3(-0.073f, -0.13f, +0.15f), Quaternion.identity * Quaternion.Euler(0.0f, 90.0f, -60.0f) /* arCamera.transform.rotation * Quaternion.Euler(0.0f, 90.0f, -90.0f) */ /* , arCamera.transform */);

        //Telling the game that now the lockpicking mini-game has started
        //lockpickingProcessOngoing = true;

        //placeholder code for intializing the lockpicking mini-game
        //ingameSceneManagement.LoadLockpickingScene();




        //this is the placeholder code for unlocking the door without the lockpicking mini-game
        

        //Once the lockpicking mini-game has been completed, the door this script is on has the be opened using the UnlockDoor() function!
        UnlockDoor();
        //Play the unlocking audio!
        audioSource.PlayOneShot(unlockSounds[Random.Range(0, unlockSounds.Length)]);

        
    }
}
