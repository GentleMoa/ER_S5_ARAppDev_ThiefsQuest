using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomSpawner : MonoBehaviour
{
    //boolean that is used to communicate whether there is an adjacent room connected at this connector or not
    public bool connected = false;

    private RoomRandomizer roomRandomizerScript;

    private GameObject adjacentRoom;

    private GameObject roomParent;

    public float roomSpawnDelay;

    private GameObject levelHandlerObj;

    private GameObject deadEndObj;

    public bool deadEndSpawned = false;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the parent room
        roomParent = this.transform.parent.gameObject;

        //referencing the procedural level handler
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
        //transmitting the dead end object from the proxi to this variable 
        deadEndObj = levelHandlerObj.GetComponent<DeadEndTransmitter>().deadEndProxi;
    }

    // Update is called once per frame
    void Update()
    {
        TerminateScript();
    }

    public void OnTriggerStay(Collider other)
    {
        if (other.gameObject.tag == "Connector")
        {
            //Stop trying to create new adjacent rooms ---> Success!
            connected = true;

            //Debug.Log(roomParent.name + "OnCollisionStay, connected = true");
        }
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Connector")
        {
            //Create new adjacent rooms again ---> Failure!
            connected = false;

            Debug.Log(roomParent.name + " ; Dead End reached!");

            //Spawn Dead End here!
            SpawnDeadEnd();
        }
    }

    // - - - Function Archive - - - //

    public void CreateAdjacentRoom()
    {
        //referncing the RoomRandomizer Script again (For some reason it has to be here!! Otherwise won't work)
        roomRandomizerScript = GameObject.FindGameObjectWithTag("Level Handler").GetComponent<RoomRandomizer>();
        //Calling the Randomizer function from that script
        roomRandomizerScript.RandomRoomSelection();

        //Assign the storage variable content to the "adjacentRoom" variable
        adjacentRoom = roomRandomizerScript.selectedRoom;
        //Print which room was selected
        //Debug.Log(adjacentRoom);

        //Sets how quickly new adjacent rooms are spawned (1.0f = 1 second)
        roomSpawnDelay = Random.Range(0.2f, 0.3f);
        
        StartCoroutine(SpawnRoom(roomSpawnDelay));
    }


    IEnumerator SpawnRoom(float time)
    {
        yield return new WaitForSeconds(time);

        
        Instantiate(adjacentRoom, this.transform.position, this.transform.rotation);

        //Print success!
        Debug.Log("Adjacent Room created: " + roomParent.name);
    }

    private void SpawnDeadEnd()
    {
        Instantiate(deadEndObj, this.transform.position, this.transform.rotation * Quaternion.Euler(0.0f, 0.0f, 180.0f), transform);
        //Setting the deadEndSpawned flag to true;
        deadEndSpawned = true;
    }

    private void TerminateScript()
    {
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            //Calling the coroutine to destroy the script with a delay
            StartCoroutine(DelayedScriptTermination(3.0f));
        }
    }


    IEnumerator DelayedScriptTermination(float time)
    {
        yield return new WaitForSeconds(time);

        //Deactivating the gameObject, this script is placed on (and therefore disabling all its colliders)
        gameObject.GetComponent<Collider>().enabled = false;
        Destroy(GetComponent<RoomSpawner>());
    }
}
