using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class State_Chasing : State
{
    public override State RunCurrentState()
    {
        return this;
    }
}
