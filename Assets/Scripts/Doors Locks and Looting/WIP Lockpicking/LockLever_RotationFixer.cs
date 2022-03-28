using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockLever_RotationFixer : MonoBehaviour
{
    //public bool minAngleReached = false;
    //public bool maxAngleReached = false;

    private void Start()
    {
        Rigidbody rb = GetComponent<Rigidbody>();
        rb.velocity = Vector3.zero;
        rb.centerOfMass = Vector3.zero;
        rb.inertiaTensorRotation = Quaternion.identity;
    }

    /*
    private void Update()
    {
        if (this.gameObject.transform.rotation.eulerAngles.z < 0.0f)
        {
            this.gameObject.transform.rotation = Quaternion.Euler(0.0f, 0.0f, 0.0f);
            minAngleReached = true;
        }
        else if (this.gameObject.transform.rotation.eulerAngles.z > 49.0f)
        {
            this.gameObject.transform.rotation = Quaternion.Euler(0.0f, 0.0f, 0.0f);
            maxAngleReached = true;
        }
    }
    */
}
