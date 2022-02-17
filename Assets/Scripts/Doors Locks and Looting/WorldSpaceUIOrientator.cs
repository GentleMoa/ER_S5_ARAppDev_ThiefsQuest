using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldSpaceUIOrientator : MonoBehaviour
{
    private Canvas canvas;
    private Camera arCamera;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the canvas component
        canvas = GetComponent<Canvas>();
        //referencing the arCamera
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        //setting the canvas' render mode to world space
        canvas.renderMode = RenderMode.WorldSpace;
        //assigning the correct event camera
        canvas.worldCamera = arCamera;
    }

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(arCamera.transform);
    }
}
