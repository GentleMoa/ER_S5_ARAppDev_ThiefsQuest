using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class GuardNPCSpawner : MonoBehaviour
{
    private RoomCounter roomCounterScript;
    [SerializeField] private GameObject guardNPC;
    [SerializeField] private Vector3 spawnPoint;
    [SerializeField] private float spawnPointRange;
    [SerializeField] private bool guardNPCSpawned = false;

    // Start is called before the first frame update
    void Start()
    {
        roomCounterScript = GetComponent<RoomCounter>();
    }

    // Update is called once per frame
    void Update()
    {
        if(roomCounterScript.levelGenerationFinished == true)
        {
            SpawnGuardNPC();
        }
    }

    private void SpawnGuardNPC()
    {
        /*
        if (guardNPCSpawned == false)
        {
            //Calculate random walkpoint to patrol to
            float randomZ = Random.Range(-spawnPointRange, spawnPointRange);
            float randomX = Random.Range(-spawnPointRange, spawnPointRange);

            spawnPoint = new Vector3(transform.position.x + randomX, transform.position.y + 0.047f, transform.position.z + randomZ);

            RaycastHit hitObject;
            if (Physics.Raycast(spawnPoint + new Vector3(0.0f, 0.047f, 0.0f), -transform.up, out hitObject, 1.0f))
            {
                if (hitObject.transform.gameObject.tag != "InvalidSpawnPlacementTag")
                {
                    Instantiate(guardNPC, spawnPoint, Quaternion.identity);
                    guardNPCSpawned = true;
                }
            }
        }
        */

        if (guardNPCSpawned == false)
        {
            Vector3 randomDirection = Random.insideUnitSphere * spawnPointRange;

            randomDirection += transform.position;
            NavMeshHit hit;
            NavMesh.SamplePosition(randomDirection, out hit, spawnPointRange, 1);
            spawnPoint = hit.position;

            Instantiate(guardNPC, spawnPoint, Quaternion.identity);
            guardNPCSpawned = true;
        }
    }
}
