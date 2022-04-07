//Contents of this script: Lockpicking winning condition (Bolt Dist to reference point), door opening (freeze rb constraints first)
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Lock_WinningCondition : MonoBehaviour
{
    //Flag
    private bool lockpickingSuccessful = false;
    //Object References
    [SerializeField] private GameObject bolt;
    [SerializeField] private GameObject referencePoint;
    [SerializeField] private LockpickingLogic mainScript;
    public float distBoltToReference;
    private GameObject uiDebugger;
    private GameObject doorToBeUnlocked;

    private void Start()
    {
        //Referencing the respective Door you are lockpicking right now
        doorToBeUnlocked = GameObject.FindGameObjectWithTag("DoorToBeUnlocked");

        /*
        //UI Debugging
        uiDebugger = GameObject.FindGameObjectWithTag("UIDebugger");
        //Activating the UIDebugger
        uiDebugger.GetComponent<Image>().enabled = true;
        uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
        //Content of the UIDebugger
        uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "Lockpicking successful: " + lockpickingSuccessful;
        */
    }

    private void Update()
    {
        //Calculating the distance from the bolt to the reference point
        distBoltToReference = referencePoint.transform.position.x - bolt.transform.position.x;

        //Distance Check between Bolt and Reference Point
        if (distBoltToReference > 0.0f && lockpickingSuccessful == false)
        {
            //Set flag
            lockpickingSuccessful = true;
            //UI Debugging
            //UIDebugger();
            //Call open door function
            OpenDoor();
        }
    }

    private void OpenDoor()
    {
        //Call constraintsControl function
        ControlConstraints();

        //Calling the Rotate Door Coroutine
        StartCoroutine(RotateDoor());

        //Call lock destruction function from "LockpickingLogic" main script
        Invoke("CallLockDestruction", 4.0f);
    }

    private void ControlConstraints()
    {
        bolt.GetComponent<Rigidbody>().isKinematic = true;
    }

    IEnumerator RotateDoor()
    {
        float timePassed = 0.0f;
        while (timePassed < 2.5f)
        {
            transform.Rotate(1.5f, 0.0f, 0.0f, Space.Self);
            timePassed += Time.deltaTime;
            yield return null;
        }
    }

    private void CallLockDestruction()
    {
        //Player regains controls
        mainScript.ControlsEnabler();
        //Unlocking the Door
        doorToBeUnlocked.GetComponent<DoorLogic>().UnlockDoor();
        //Destroying the 3D Lockpicking Interface
        mainScript.DestroyLock();
    }

    private void UIDebugger()
    {
        //Content of the UIDebugger
        uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = "Lockpicking successful: " + lockpickingSuccessful;
    }
}
