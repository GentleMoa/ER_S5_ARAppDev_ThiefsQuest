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

    // Start is called before the first frame update
    void Start()
    {
        doorwayCol = GetComponent<Collider>();
        door = transform.GetChild(0).gameObject;
    }

    // Update is called once per frame
    void Update()
    {
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
        Destroy(transform.GetChild(1).gameObject);
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
            unlockButton.onClick.AddListener(UnlockDoor);
        }

    }

    //Add function to lock the door again?
}
