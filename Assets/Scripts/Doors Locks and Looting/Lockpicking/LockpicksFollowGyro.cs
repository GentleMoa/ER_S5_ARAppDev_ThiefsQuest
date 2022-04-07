using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockpicksFollowGyro : MonoBehaviour
{
    private Quaternion baseRotation = new Quaternion(0, 0, 0, 0);
    private GyroHandler gyroHandler;

    // Start is called before the first frame update
    void Start()
    {
        gyroHandler = GameObject.FindGameObjectWithTag("Level Handler").GetComponent<GyroHandler>();
        gyroHandler.EnableGyro();
    }

    // Update is called once per frame
    void Update()
    {
        transform.localRotation = gyroHandler.GetGyroRotation() * baseRotation;
    }
}
