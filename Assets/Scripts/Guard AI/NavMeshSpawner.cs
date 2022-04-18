using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class NavMeshSpawner : MonoBehaviour
{
    //Variables
    [SerializeField] private RoomCounter roomCounterScript;
    private NavMeshSurface navMeshSurface;
    private bool navMeshBuilt = false;

    private void Start()
    {
        //References
        navMeshSurface = GetComponent<NavMeshSurface>();
    }

    // Update is called once per frame
    void Update()
    {
        //If level generation has finished, ...
        if(roomCounterScript.levelGenerationFinished == true && navMeshBuilt == false)
        {
            // ..., generate the level's navmesh at runtime
            navMeshSurface.BuildNavMesh();
            //Flag
            navMeshBuilt = true;
            //Debugging
            Debug.Log("NavMesh has been built at runtime!");
        }
    }
}
