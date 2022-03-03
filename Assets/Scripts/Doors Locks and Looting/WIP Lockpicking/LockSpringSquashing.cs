using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockSpringSquashing : MonoBehaviour
{
    [SerializeField]
    private Transform boltPosition;

    public float distanceSpringToBolt;
    public Vector3 initialSize;
    public float scaleMultiplier; //for a lock size of 0.1 the scaleMultiplier should be: 1.84 (the spring value on the bolt's spring joint component should be 50 at lock size of 01.)
                                  //for a lock size of 0.01 the scaleMultiplier should be: 1.84 * 10

    // Start is called before the first frame update
    void Start()
    {
        //setting up base values
        scaleMultiplier = 1.84f * 10.0f;
        initialSize = transform.localScale;
    }

    // Update is called once per frame
    void Update()
    {
        //getting the distance from the spring to the bolt anchor pos
        distanceSpringToBolt = Vector3.Distance(transform.position, boltPosition.position);
        //scaling the spring on the z axes depending on distance and a static scale multiplier
        transform.localScale = new Vector3(initialSize.x, initialSize.y, (initialSize.z * distanceSpringToBolt) * scaleMultiplier);
    }
}
