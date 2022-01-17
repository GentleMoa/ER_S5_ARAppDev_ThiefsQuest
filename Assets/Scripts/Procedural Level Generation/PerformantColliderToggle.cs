using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerformantColliderToggle : MonoBehaviour
{
    private GameObject levelHandlerObj;
    private GameObject wallColliders;
    private bool wallCollsDisabled = false;
    public int roomAge;
    public bool playerInRoom;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the procedural level handler
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
        //referencing the wall collider child
        wallColliders = transform.GetChild(transform.childCount - 1).gameObject;
        //get this gameobjects collider
        gameObject.GetComponent<Collider>().isTrigger = true;
        //define this rooms age
        RequestRoomAge();

    }   
    
    private void Update()
    {
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true && wallCollsDisabled == false && roomAge > 1)
        {
            wallColliders.SetActive(false);
            wallCollsDisabled = true;
        }
    }


    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player" && levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            wallColliders.SetActive(true);
            //Debug.Log(name + "Wall Colliders ENABLED");

            //Setting the flag to true
            playerInRoom = true;
        }
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player" && levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            wallColliders.SetActive(false);
            //Debug.Log(name + "Wall Colliders DISABLED");

            //Setting the flag to false
            playerInRoom = false;
        }
    }

    private void RequestRoomAge()
    {
        roomAge = levelHandlerObj.GetComponent<RoomCounter>().roomCount;
    } 
}
