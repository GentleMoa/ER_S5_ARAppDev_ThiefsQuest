using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GyroHandler : MonoBehaviour
{
    private Gyroscope gyro;
    private Quaternion gyroRotation;
    private bool gyroActive;

    public void EnableGyro()
    {
        //If the gyro is already activated
        if (gyroActive == true)
        {
            return;
        }

        if (SystemInfo.supportsGyroscope == true)
        {
            gyro = Input.gyro;
            gyro.enabled = true;
            gyroActive = gyro.enabled;
        }
        else
        {
            Debug.Log("Gyroscope is not supported on your device!");
        }
    }

    private void Update()
    {
        if (gyroActive == true)
        {
            gyroRotation = gyro.attitude;
        }
    }

    public Quaternion GetGyroRotation()
    {
        return gyroRotation;
    } 
}
