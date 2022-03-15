using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//these libraries are necessary to use XR/AR related code
using UnityEngine.XR.ARFoundation;
using UnityEngine.Experimental.XR;
using UnityEngine.XR.ARSubsystems;

using UnityEngine.UI;
using System;



public class AR_PlaceLevel : MonoBehaviour
{
    //Variables for planetracking and level placement

    //referencing the level ground floor to place
    public GameObject levelGroundFloor;
    //referencing the player prefab to place
    public GameObject player;
    //setting up a reference to a object used as placement indicator (assigned in the inspector)
    public GameObject placementIndicator;
    //creating a reference to the AR Session Origin GameObject (Command 1)
    private ARSessionOrigin arOrigin;
    //instantiating a pose object, in which I will store the position of a plane, found by the camera
    private Pose placementPose;
    //creating a boolean, which is used to identify, wether the raycast hit list is empty or has at least one (> 0) hit.
    private bool placementPoseIsValid = false;
    //bool that contains whether there already is an plane or not
    public bool planePlaced = false;


    // Start is called before the first frame update
    void Start()
    {
        //creating a reference to the AR Session Origin GameObject (Command 2)
        arOrigin = FindObjectOfType<ARSessionOrigin>();
    }

    // Update is called once per frame
    void Update()
    {
        UpdatePlacementPose();
        UpdatePlacementIndicator();

    }

    private void UpdatePlacementIndicator()
    {
        //if atleast one hit has been registered by the raycast, ...
        if (placementPoseIsValid && planePlaced == false)
        {
            // ... the placement indicator object will be visible.
            placementIndicator.SetActive(true);
            //the position and rotation of the placement indicator adapts the position and rotation of the placement pose.
            placementIndicator.transform.SetPositionAndRotation(placementPose.position, placementPose.rotation);
        }
        //if the raycast has registered no hits at all, ...
        else if ((!placementPoseIsValid || planePlaced == true))
        {
            // ... the placement indicator object will be disappear.
            placementIndicator.SetActive(false);
        }
    }

    private void UpdatePlacementPose()
    {
        //initiating a new variable to store the center of my phone screen
        var screenCenter = Camera.current.ViewportToScreenPoint(new Vector3(0.5f, 0.5f));
        //creating a empty list, in which I will store any hits by the raycast operation
        var hits = new List<ARRaycastHit>();

        //establishing a connection to the ARRaycastManager Component on the AR Session Origin Object.
        ARRaycastManager arRayManager = arOrigin.GetComponent<ARRaycastManager>();

        //using the ARFoundation's inbuilt raycast operation to shoot a ray from the center of my screen into the "real world"
        //requires a (1) starting position, (2) a list in which to store hits and (3) a specification, which kind of hits are registered
        arRayManager.Raycast(screenCenter, hits, TrackableType.All);

        //sets placementPoseIsValid bool to true, if there is at least 1 hit in the raycast hit list.
        placementPoseIsValid = hits.Count > 0;

        //if the raycast registers at least one hit, ...
        if (placementPoseIsValid)
        {
            // ... the position of that hit is copied over to the placementPose object.
            placementPose = hits[0].pose;

            //creating a variable, that's acts as a forward vector of the camera direction.
            var cameraForward = Camera.current.transform.forward;

            //calculating a new rotation for the placement pose (and therefore the placement indicator), based on the camera direction. 
            //y orientation is determined wether the detected plane is vertical or horizontal.
            var cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;
            placementPose.rotation = Quaternion.LookRotation(cameraBearing);

        }
    }

    public void PlacePlane()
    {
        //With no level ground plane existing one will be created
        if (planePlaced == false)
        {
            //Instantiate the level ground plane
            Instantiate(levelGroundFloor, placementPose.position, placementPose.rotation);
            //Instantiate the player
            Instantiate(player, placementPose.position + new Vector3(0.0f, 0.00001f, 0.0f), placementPose.rotation);
            //Set the bool to false to prevent more than one level ground plane being placed
            planePlaced = true;
        }
    }
}
