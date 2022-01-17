using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnDoorway : MonoBehaviour
{
    [SerializeField]
    private GameObject doorwayPrefab;

    private GameObject gameMechanicsHandler;
    private bool doorsSpawned = false;
    
    // Start is called before the first frame update
    void Start()
    {
        //reference the Game Mechanics Handler go
        gameMechanicsHandler = GameObject.FindGameObjectWithTag("Level Handler");
    }

    // Update is called once per frame
    void Update()
    {
        //If level generation has finished and no doorways have been spawned yet, ...
        if (gameMechanicsHandler.GetComponent<RoomCounter>().levelGenerationFinished == true && doorsSpawned == false)
        {
            // ..., Calls the function to spawn doorways
            SpawnDoorways();
            //..., sets the flag to true
            doorsSpawned = true;
        }
    }

    // - - - Function Archive - - - //
    
    private void SpawnDoorways()
    {
        //Instantiating the Doorway prefab as a child at the pos and rot of the connector collider this script is on
        Instantiate(doorwayPrefab, this.transform.position, this.transform.rotation, transform);
    }
}
