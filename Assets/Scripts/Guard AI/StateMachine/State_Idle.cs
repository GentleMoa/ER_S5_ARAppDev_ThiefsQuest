using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class State_Idle : State
{
    //Variables - State Change
    public State_Patrolling statePatrolling;

    public bool isPatrolling = false;
    [SerializeField] float idlingLength;

    public override State RunCurrentState()
    {
        if(isPatrolling == true)
        {
            //reset "State_Patrolling" flags
            statePatrolling.walkPointIsSet = false;
            statePatrolling.walkPointReached = false;
            //change state
            return statePatrolling;
        }
        else
        {
            return this;
        }
    }

    private void Update()
    {
        Idling();
    }

    private void Idling()
    {
        if (isPatrolling == false)
        {
            //play idle/looking around anims
            StartCoroutine(ResumePatrolling(idlingLength));
        }
    }

    IEnumerator ResumePatrolling(float time)
    {
        yield return new WaitForSeconds(time);

        isPatrolling = true;
    }
}
