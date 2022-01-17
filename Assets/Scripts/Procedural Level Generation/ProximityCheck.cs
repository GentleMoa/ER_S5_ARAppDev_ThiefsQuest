using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProximityCheck : MonoBehaviour
{
    private Collider proximityCollider;
    private GameObject parentRoom;

    private Rigidbody proximityRigidbody;

    //bool to check if there was an intersection or not
    public bool intersectionCheck;
    //bool to check if placed room is valid
    public bool validRoom = false;

    //float to definte routine starting point
    public float routineStart;

    //A variable that stores the age of the room (the order in which is has been added to the "SceneArray" array))
    public int roomAge;
    public GameObject levelHandler;

    // Start is called before the first frame update
    void Start()
    {
        routineStart = Random.Range(1.0f, 2.0f);

        //references the (proximity) collier 
        proximityCollider = this.GetComponent<Collider>();

        //references the parent object (Room)
        parentRoom = this.transform.parent.gameObject;

        //referencing the "Procedural Level Handler"
        levelHandler = GameObject.FindGameObjectWithTag("Level Handler");

        //Requesting roomAge from the RoomCounter script on the "Procedural Level Handler" object.
        RequestSceneArrayIndex();

        //Calling the coroutine
        StartCoroutine(ChangeCollisionSettings(/*0.19f*/ routineStart));

        //adding a rigidbody, since you need to have at least one object with rigidbody for "OnTriggerEnter" to detect an collision with it.
        proximityRigidbody = this.gameObject.AddComponent<Rigidbody>();

        //freezing the rigidbody's rotation and position to make it static/immovable.
        proximityRigidbody.constraints = RigidbodyConstraints.FreezeAll;
    }

    private void Update()
    {
        TerminateScript();
    }

    //check for collision
    private void OnTriggerEnter(Collider other)
    {
        //if there is collision with another room, ...
        if (other.gameObject.tag == "Proximity" && validRoom == false /* && other.gameObject.GetComponent<Collider>().isTrigger == false */ && other.gameObject.GetComponent<ProximityCheck>().roomAge <= roomAge)
        {
            //bool is set to true (positive intersection check)
            intersectionCheck = true;

            // ... the newly created room is destroyed
            Debug.Log(parentRoom.name + " destroyed! Interescted with: " + other.gameObject.transform.parent.gameObject.name);

            //Moving the parent room to the side so a OnTriggerExit is fired in the RoomSpawner script!
            parentRoom.transform.Translate(new Vector3(0.0f, -50.0f, 0.0f), Space.World);

            //Setting the room inactive
            //parentRoom.SetActive(false);

            //Destroying the room
            //Destroy(parentRoom);
            StartCoroutine(DestroyRoom(0.5f));
        }
    }

    // - - - Function Archive - - - //

    IEnumerator ChangeCollisionSettings(float time)
    {
        yield return new WaitForSeconds(time);

        //room is now considered valid (set in stone/cannot be removed afterwards)
        validRoom = true;

        //disabling the "isTrigger" option. This is necessary because a collision during "OnTriggerEnter" is only detected, when only one of the colliders has "is Trigger" and the other one doesnt.
        proximityCollider.isTrigger = false;

        StartCoroutine(ConnectorSpecificIsTriggerEnabler(roomAge/100));
    }

 
    IEnumerator ConnectorSpecificIsTriggerEnabler(float time)
    {
        yield return new WaitForSeconds(time);

        proximityCollider.isTrigger = true;
        validRoom = false;

        //Debug.Log(parentRoom.name + "checks for intersections routinely");

        StartCoroutine(ConnectorSpecificIsTriggerDisabler(1.0f));
    }

    IEnumerator ConnectorSpecificIsTriggerDisabler(float time)
    {
        yield return new WaitForSeconds(time);

        proximityCollider.isTrigger = false;
        validRoom = true;

        //closing the circle
        StartCoroutine(ConnectorSpecificIsTriggerEnabler(1.0f));
    }

    public void RequestSceneArrayIndex()
    {
        roomAge = levelHandler.GetComponent<RoomCounter>().roomCount;
        Debug.Log(parentRoom.name + "'s age is: " + roomAge);
    }

    IEnumerator DestroyRoom(float time)
    {
        yield return new WaitForSeconds(time);

        Destroy(parentRoom);
    }

    private void TerminateScript()
    {
        if (levelHandler.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            Destroy(GetComponent<ProximityCheck>());
            //Stops all ongoing coroutines
            StopAllCoroutines();
        }
    }
}
