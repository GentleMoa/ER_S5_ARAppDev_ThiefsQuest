using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class State_Patrolling : State
{
    //Variables - Patrolling Logic
    [SerializeField] private NavMeshAgent navMeshAgent;
    //public Vector3 walkPoint;
    public bool walkPointIsSet = false;
    public float walkPointRange;
    [SerializeField] private float walkPointReachedThreshold;
    public bool walkPointReached = false;
    [SerializeField] private float walkRadius;
    [SerializeField] private Vector3 finalPosition;
    //Variables - State Change
    [SerializeField] private State_Idle stateIdle;

    public override State RunCurrentState()
    {
        if (walkPointReached == true)
        {
            //reset "State_Idle" flags
            stateIdle.isPatrolling = false;

            //change state
            return stateIdle;
        }
        else
        {
            return this;
        }
    }

    private void Update()
    {
        Partolling();
    }

    private void Partolling()
    {
        if (walkPointIsSet == false)
        {
            SearchWalkPoint();
        }
        else if (walkPointIsSet == true)
        {
            //navMeshAgent.SetDestination(walkPoint);
            navMeshAgent.SetDestination(finalPosition);
        }

        Vector3 distanceToWalkPoint = transform.position - finalPosition;

        //Walkpoint reached
        if (distanceToWalkPoint.magnitude < walkPointReachedThreshold)
        {
            walkPointReached = true;
        }
    }

    private void SearchWalkPoint()
    {
        /*
        //Calculate random walkpoint to patrol to
        float randomZ = Random.Range(-walkPointRange, walkPointRange);
        float randomX = Random.Range(-walkPointRange, walkPointRange);

        walkPoint = new Vector3(transform.position.x + randomX, transform.position.y, transform.position.z + randomZ);

        RaycastHit hitObject;
        if (Physics.Raycast(walkPoint, -transform.up, out hitObject, 2.0f))
        {
            if (hitObject.transform.gameObject.tag != "InvalidSpawnPlacementTag")
            {
                walkPointIsSet = true;
            }
        }
        */

        Vector3 randomDirection = Random.insideUnitSphere * walkRadius;

        randomDirection += transform.position;
        NavMeshHit hit;
        NavMesh.SamplePosition(randomDirection, out hit, walkRadius, 1);
        finalPosition = hit.position;

        walkPointIsSet = true;
    }
}
