using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PropsPerformantColliderToggle : MonoBehaviour
{
    private GameObject levelHandlerObj;
    private bool propsCollsDisabled = false;
    private int roomAge;
    private bool playerInRoom;

    public Collider[] propColliders;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the procedural level handler
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");

        //setting the array's length to the childCount of the parent obj
        propColliders = new Collider[gameObject.transform.childCount];

        //handing over the prop collection parent object's children colliders into the array
        for (int i = 0; i < gameObject.transform.childCount; i++)
        {
            //assigning the child obj's colliders to the array
            propColliders[i] = gameObject.transform.GetChild(i).GetComponent<Collider>();
        }

        //define this rooms age
        RequestRoomAge();
    }

    // Update is called once per frame
    void Update()
    {
        /*
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true && propsCollsDisabled == false && roomAge > 1)
        {
            //disable props colliders here
            for (int i = 0; i < propColliders.Length; i++)
            {
                //if the colliders is NOT Trigger (all except the isTrigger Collider on the armatures)
                if (propColliders[i].isTrigger == false)
                {
                    //disable the collider to save performance
                    propColliders[i].enabled = false;
                }
            }
        }
        */
    }

    public void DisablePropsColliders()
    {
        //disable props colliders here
        for (int i = 0; i < propColliders.Length; i++)
        {
            //if the colliders is NOT Trigger (all except the isTrigger Collider on the armatures)
            if (propColliders[i].isTrigger == false)
            {
                //disable the collider to save performance
                propColliders[i].enabled = false;
            }
        }

        //Debug.Log(name + "PROPS COLLIDERS: DISABLED");
    }

    public void EnablePropsColliders()
    {
        //enable props colliders here
        for (int i = 0; i < propColliders.Length; i++)
        {
            //if the colliders is NOT Trigger (all except the isTrigger Collider on the armatures)
            if (propColliders[i].isTrigger == false)
            {
                //enable the collider to save performance
                propColliders[i].enabled = true;
            }
        }

        //Debug.Log(name + "PROPS COLLIDERS: ENABLED");
    }

    private void RequestRoomAge()
    {
        roomAge = levelHandlerObj.GetComponent<RoomCounter>().roomCount;
    }
}
