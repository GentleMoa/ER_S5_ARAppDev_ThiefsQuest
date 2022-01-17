using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomRandomizer : MonoBehaviour
{
    //Arrays of Room Tiles with...

    //1 Door
    public GameObject[] room1Door;
    //2 Doors
    public GameObject[] room2Doors;
    //3 Doors
    public GameObject[] room3Doors;
    //4 Doors
    public GameObject[] room4Doors;

    //Randomizer variables
    private int pass1Randomizer;
    private int pass2Randomizer;

    //Storage variable (accessed by RoomSpawner script)
    public GameObject selectedRoom;

    //Randomizer variables (for start room randomization)
    private int startRoomRandomizer_pass1;
    private int startRoomRandomizer_pass2;

    public GameObject selectedStartRoom;

    private GameObject levelHandlerObj;

    // Start is called before the first frame update
    void Start()
    {
        levelHandlerObj = this.gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        TerminateScript();
    }

    // - - - Function Archive - - - //

    //function to randomly choose one room out of the 40 (biased version)
    public void RandomRoomSelection()
    {
        //Two passes: 1. = amounts of doors (1-4), 2. = room shapes (1-5) or (1-15)

        //1. pass:
        //Throw the dice for pass 1!
        pass1Randomizer = Random.Range(1, 101);

        if (pass1Randomizer <= 25 /* = 25% */)
        {
            //Throw the dice for pass 2!
            pass2Randomizer = Random.Range(1, 6);

            //Debugging ---> REMOVE LATER!
            //Debug.Log(pass2Randomizer);

            //Assigning the randomized room to the storage variable
            selectedRoom = room1Door[pass2Randomizer - 1];

            //Debugging ---> REMOVE LATER!
            //Debug.Log("Allocation to 'selectedRoom':" + room1Door[pass2Randomizer - 1].name);
        }
        else if (pass1Randomizer > 25 && pass1Randomizer <= 60 /* = 35% */)
        {
            //Throw the dice for pass 2!
            pass2Randomizer = Random.Range(1, 16);

            //Debugging ---> REMOVE LATER!
            //Debug.Log(pass2Randomizer);

            //Assigning the randomized room to the storage variable
            selectedRoom = room2Doors[pass2Randomizer - 1];

            //Debugging ---> REMOVE LATER!
            //Debug.Log("Allocation to 'selectedRoom':" + room2Doors[pass2Randomizer - 1].name);
        }
        else if (pass1Randomizer > 60 && pass1Randomizer <= 85 /* = 25% */)
        {
            //Throw the dice for pass 2!
            pass2Randomizer = Random.Range(1, 16);

            //Debugging ---> REMOVE LATER!
            //Debug.Log(pass2Randomizer);

            //Assigning the randomized room to the storage variable
            selectedRoom = room3Doors[pass2Randomizer - 1];

            //Debugging ---> REMOVE LATER!
            //Debug.Log("Allocation to 'selectedRoom':" + room3Doors[pass2Randomizer - 1].name);
        }
        else if (pass1Randomizer > 85 && pass1Randomizer <= 100 /* = 15% */)
        {
            //Throw the dice for pass 2!
            pass2Randomizer = Random.Range(1, 6);

            //Debugging ---> REMOVE LATER!
            //Debug.Log(pass2Randomizer);

            //Assigning the randomized room to the storage variable
            selectedRoom = room4Doors[pass2Randomizer - 1];

            //Debugging ---> REMOVE LATER!
            //Debug.Log("Allocation to 'selectedRoom':" + room4Doors[pass2Randomizer - 1].name);
        }
        else if (pass1Randomizer < 1 || pass1Randomizer > 100)
        {
            Debug.Log("There was an error with the first pass of Room Randomization!");
        }

    }

    public void StartRoomSelection()
    {
        //Throwing the dice for pass 1:
        startRoomRandomizer_pass1 = Random.Range(1, 101);

        if (startRoomRandomizer_pass1 <= 30 /* = 30% */)
        {
            //Throw the dice for pass 2!
            startRoomRandomizer_pass2 = Random.Range(1, 16);

            //Assigning the randomized room to the storage variable (start room)
            selectedStartRoom = room2Doors[startRoomRandomizer_pass2 - 1];

        }
        else if (startRoomRandomizer_pass1 > 30 && startRoomRandomizer_pass1 <= 70 /* = 40% */)
        {
            //Throw the dice for pass 2!
            startRoomRandomizer_pass2 = Random.Range(1, 16);

            //Assigning the randomized room to the storage variable (start room)
            selectedStartRoom = room3Doors[startRoomRandomizer_pass2 - 1];

        }
        else if (startRoomRandomizer_pass1 > 70 && startRoomRandomizer_pass1 <= 100 /* = 30% */)
        {
            //Throw the dice for pass 2!
            startRoomRandomizer_pass2 = Random.Range(1, 6);

            //Assigning the randomized room to the storage variable (start room)
            selectedStartRoom = room4Doors[startRoomRandomizer_pass2 - 1];

        }
    }

    private void TerminateScript()
    {
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            Destroy(GetComponent<RoomRandomizer>());
        }
    }

}
