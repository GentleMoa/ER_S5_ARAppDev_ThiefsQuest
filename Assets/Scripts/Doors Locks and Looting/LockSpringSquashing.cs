using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockSpringSquashing : MonoBehaviour
{
    [SerializeField]
    private Transform boltPosition;

    private float distanceSpringToBolt;
    private Vector3 initialSize;
    private float scaleMultiplier;

    // Start is called before the first frame update
    void Start()
    {
        //setting up base values
        scaleMultiplier = 1.84f;
        initialSize = transform.localScale;
    }

    // Update is called once per frame
    void Update()
    {
        //getting the distance from the spring to the bolt anchor pos
        distanceSpringToBolt = Vector3.Distance(transform.position, boltPosition.position);
        //scaling the spring on the z axes depending on distance and a static scale multiplier
        transform.localScale = new Vector3(20.0f, 20.0f ,(initialSize.z * distanceSpringToBolt) * scaleMultiplier);
    }
}
