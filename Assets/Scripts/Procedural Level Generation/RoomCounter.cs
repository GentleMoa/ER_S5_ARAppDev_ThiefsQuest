using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomCounter : MonoBehaviour
{
    //variable to store the amount of rooms the level contains at the time of requesting this info
    public int roomCount;

    //bool that is used to determine whether the level generation has finished
    public bool levelGenerationFinished = false;

    //variables that help to determine if the roomCount is still changing (level is still generating)
    public int countA;
    public int countB;

    //referencing the AR_Initializer script on the game mechanics handler
    private AR_Initializer arInitScript;
    private bool genFinishCheckInitiated = false;

    // Start is called before the first frame update
    void Start()
    {
        arInitScript = GetComponent<AR_Initializer>();
    }

    // Update is called once per frame
    void Update()
    {
        //function that checks the total amound of rooms each frame
        CountRooms();

        if (arInitScript.levelStartPlaced == true && genFinishCheckInitiated == false)
        {
            //Calling the Check functions every 5 seconds
            InvokeRepeating("CheckLevelGenStatus_A", 10.0f, 10.0f);

            InvokeRepeating("CheckLevelGenStatus_B", 7.0f, 7.0f);

            //Debug
            Debug.Log("From now on: Checking if level has finished generating!!!!");
            //This is used so this code is only called once but the conditions are checked every frame
            genFinishCheckInitiated = true;
        }

        //TerminateScript();
    }

    // - - - Function Archive - - - //

    public void CountRooms()
    {
        if (levelGenerationFinished == false)
        {
            //get the amount of rooms of returning an array with all the gameobjects that have the "Room" tag
            roomCount = GameObject.FindGameObjectsWithTag("Room").Length;
        }
    }

    //Mostly a debugging function. It prints the amount of rooms into the console
    private void PrintRoomCount()
    {
        Debug.Log("There are " + roomCount + " rooms in total!");
    }

    public void CheckLevelGenStatus_A()
    {
        //Assigning the roomCount to the variable countA
        countA = roomCount;
    }

    public void CheckLevelGenStatus_B()
    {
        if (countA == roomCount)
        {
            levelGenerationFinished = true;
        }
    }

    private void TerminateScript()
    {
        if (levelGenerationFinished == true)
        {
            Debug.Log("Procedural Level Generation: done!");
            Destroy(GetComponent<RoomCounter>());
            CancelInvoke();
        }
    }
}
