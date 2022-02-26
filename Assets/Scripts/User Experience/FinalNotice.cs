using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinalNotice : MonoBehaviour
{
    [SerializeField] private GameObject cameraPermissionInformer;

    // Start is called before the first frame update
    void Start()
    {
        if (cameraPermissionInformer.activeSelf == true)
        {
            cameraPermissionInformer.SetActive(false);
        }
    }

    public void ShowCameraPermissionInformer()
    {
        cameraPermissionInformer.SetActive(true);
    }
}
