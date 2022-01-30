using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleLights : MonoBehaviour
{
    private GameObject levelHandlerObj;
    private bool lightSwitch = false;
    public int roomAge;
    private GameObject lightsParent;

    private bool firstLightSwitch = true;


    // Start is called before the first frame update
    void Start()
    {
        //referencing the procedural level handler
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
        //assigning the room age
        roomAge = levelHandlerObj.GetComponent<RoomCounter>().roomCount;
        //referencing the collective lights (by calling the second lowest obj in the hierarchy)
        lightsParent = transform.GetChild(transform.childCount - 2).gameObject; //This is a bad way of referencing an object, because if you change anything in the parents hierarchy, it wont work anymore.

        //if this room is the first, then ...
        if (transform.position == new Vector3(0.0f, 0.0f, 0.0f))
        {
            //enable its lights
            lightsParent.SetActive(true);
        }
        //if it isn't, ...
        else
        {
            //disable its lights
            lightsParent.SetActive(false);
        }
    }

    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            ToggleLight();
        }
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            ToggleLight();
        }
    }

    private void ToggleLight()
    {
        if (lightSwitch == false)
        {
            //turn lights on
            lightsParent.SetActive(true);
            //set the conditional flag to true
            lightSwitch = true;
        }
        else if (lightSwitch == true)
        {
            //turn lights off
            lightsParent.SetActive(false);
            //set the conditional flag to false
            lightSwitch = false;
        }
    }
}
