using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AR_PlayerSeethroughWalls : MonoBehaviour
{
    public static int posID = Shader.PropertyToID("_position");
    public static int sizeID = Shader.PropertyToID("_size");

    public Material seethroughRoomMat_1;
    public Material seethroughRoomMat_2;
    public Material seethroughRoomMat_3;
    public Material seethroughRoomMat_4;
    //public Material opaqueRoomMat;
    private Camera arCamera;
    public LayerMask mask;

    //Adaptive seethrough Circle
    private float distCameraToPlayer;
    private float adaptiveCircleSize;
    private float sizeDistanceFactor = 1.0f;

    //UI-Debugging
    private Text debuggerText_distCameraToPlayer;
    
    void Start()
    {
        arCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        seethroughRoomMat_1.SetFloat(sizeID, 0.0f);
        seethroughRoomMat_2.SetFloat(sizeID, 0.0f);
        seethroughRoomMat_3.SetFloat(sizeID, 0.0f);
        seethroughRoomMat_4.SetFloat(sizeID, 0.0f);

        //UI-Debugging
        //debuggerText_distCameraToPlayer = GameObject.FindGameObjectWithTag("UIDebugger_distCameraToPlayer").GetComponent<Text>();
    }

    void FixedUpdate()
    {
        //Giving the player transform.pos a slight offset on the y to match the players hight
        Vector3 adjustedPlayerPos = new Vector3(transform.position.x, transform.position.y + 0.16f, transform.position.z);

        //Creating a vector 3 to describe the rays direction (pointing from camera to player)
        Vector3 raycastDir = (adjustedPlayerPos - arCamera.transform.position).normalized;
        //Creating a ray which stores its origin point as well as its direction
        var ray = new Ray(arCamera.transform.position, raycastDir);
        //Calculating the distance from camera to player
        float distCameraToPlayer = (Vector3.Distance(arCamera.transform.position, adjustedPlayerPos));
        //Creating the array in which to store all the raycasts hits
        RaycastHit[] hits;
        //Populating the array with the raycasts hits
        hits = (Physics.RaycastAll(ray, distCameraToPlayer, mask));

        //DEBUGGING
        //Debug.DrawRay(arCamera.transform.position, raycastDir, Color.green);

        for (int i = 0; i < hits.Length; i++)
        {
            RaycastHit hit = hits[i];

            if (hit.collider.transform.gameObject.tag == "Wall")
            {
                //DEBUGGING
                //Debug.Log("WALL");
                //hit.transform.parent.parent.gameObject.GetComponent<Renderer>().material = seethroughRoomMat;
                //Debug.Log(hit.transform.parent.gameObject.name + hit.transform.parent.gameObject.tag);

                //Adaptive size scaling of the seethrough circle
                distCameraToPlayer = Vector3.Distance(arCamera.transform.position, transform.position);
                
                //DEBUGGING
                //Debug.Log("Distance: " + distCameraToPlayer);

                //UI-Debugging
                /*
                if (debuggerText_distCameraToPlayer != null)
                {
                    debuggerText_distCameraToPlayer.text = "Distance: " + distCameraToPlayer;
                }
                */

                //Inverse proportional calculation
                adaptiveCircleSize = sizeDistanceFactor / distCameraToPlayer;

                seethroughRoomMat_1.SetFloat(sizeID, /* 0.6f */ adaptiveCircleSize);
                seethroughRoomMat_2.SetFloat(sizeID, /* 0.6f */ adaptiveCircleSize);
                seethroughRoomMat_3.SetFloat(sizeID, /* 0.6f */ adaptiveCircleSize);
                seethroughRoomMat_4.SetFloat(sizeID, /* 0.6f */ adaptiveCircleSize);
            }
            
            if (hit.collider.transform.gameObject.tag == "NonWall")
            {
                //DEBUGGING
                //Debug.Log("NONWALL");
                //hit.transform.parent.parent.gameObject.GetComponent<Renderer>().material = opaqueRoomMat;
                //Debug.Log(hit.transform.parent.gameObject.name + hit.transform.parent.gameObject.tag);

                seethroughRoomMat_1.SetFloat(sizeID, 0.0f);
                seethroughRoomMat_2.SetFloat(sizeID, 0.0f);
                seethroughRoomMat_3.SetFloat(sizeID, 0.0f);
                seethroughRoomMat_4.SetFloat(sizeID, 0.0f);
            }
        }

        var view = arCamera.WorldToViewportPoint(transform.position + new Vector3(0.0f, 0.085f, 0.0f));
        seethroughRoomMat_1.SetVector(posID, view);
        seethroughRoomMat_2.SetVector(posID, view);
        seethroughRoomMat_3.SetVector(posID, view);
        seethroughRoomMat_4.SetVector(posID, view);
    }
}
