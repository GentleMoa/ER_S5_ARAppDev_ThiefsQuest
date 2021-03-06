using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerformantColliderToggle : MonoBehaviour
{
    private GameObject levelHandlerObj;
    public GameObject wallColliders;
    private bool wallCollsDisabled = false;
    public int roomAge;
    public bool playerInRoom;

    public PropsPerformantColliderToggle[] propsColliderToggleScripts;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the procedural level handler
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
        //referencing the wall collider child
        wallColliders = transform.GetChild(transform.childCount - 1).gameObject; //This is a bad way of referencing an object, because if you change anything in the parents hierarchy, it wont work anymore.
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

            for (int i = 0; i < propsColliderToggleScripts.Length; i++)
            {
                propsColliderToggleScripts[i].EnablePropsColliders();
            }

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

            for (int i = 0; i < propsColliderToggleScripts.Length; i++)
            {
                propsColliderToggleScripts[i].DisablePropsColliders();
            }

            //Setting the flag to false
            playerInRoom = false;
        }
    }

    private void RequestRoomAge()
    {
        roomAge = levelHandlerObj.GetComponent<RoomCounter>().roomCount;
    } 
}
