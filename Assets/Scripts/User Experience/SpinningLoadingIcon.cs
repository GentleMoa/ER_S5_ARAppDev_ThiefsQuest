using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpinningLoadingIcon : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.back * Time.deltaTime * 20);
    }
}
