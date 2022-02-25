using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//these libraries are necessary to use XR/AR related code
using UnityEngine.XR.ARFoundation;
using UnityEngine.Experimental.XR;
using UnityEngine.XR.ARSubsystems;

using UnityEngine.UI;
using System;

public class AR_Initializer : MonoBehaviour
{
    // - - - "Initializer" - Code
    private GameObject startChecker;
    private GameObject gameMechanicsHandler;

    private RoomRandomizer roomRandomizerScript;

    private GameObject levelOriginRoom;


    // - - - "AR_PlaceLevel" - Code
    //referencing the player prefab to place
    public GameObject player;
    //setting up a reference to a object used as placement indicator (assigned in the inspector)
    public GameObject placementIndicator;
    //creating a reference to the AR Session Origin GameObject (Command 1)
    public ARSessionOrigin arOrigin;

    //instantiating a pose object, in which I will store the position of a plane, found by the camera
    private Pose placementPose;
    //creating a boolean, which is used to identify, wether the raycast hit list is empty or has at least one (> 0) hit.
    private bool placementPoseIsValid = false;
    //bool that contains whether there already is an plane or not
    public bool levelStartPlaced = false;

    [SerializeField] AudioClip[] trapdoorSounds;
    [SerializeField] AudioSource audioSource;

    //DEBUGGING
    [SerializeField]
    ARRaycastManager arRayManager;
    [SerializeField]
    Camera arCamera;

    // Start is called before the first frame update
    void Start()
    {
        // - - - "Initializer" - Code
        //referencing the Game Mechanics Handler object
        gameMechanicsHandler = GameObject.FindGameObjectWithTag("Level Handler");
        //referencing the Room Randomizer script on the Game Mechanics Handler object
        roomRandomizerScript = gameMechanicsHandler.GetComponent<RoomRandomizer>();

        // - - - "AR_PlaceLevel" - Code
        //creating a reference to the AR Session Origin GameObject (Command 2)
        arOrigin = FindObjectOfType<ARSessionOrigin>();
        //creating a reference to the AR Raycast Manager GameObject
        arRayManager = arOrigin.GetComponent<ARRaycastManager>();
        //creating a reference to the AR Camera
        arCamera = arOrigin.transform.GetChild(0).GetComponent<Camera>();

        //DEBUGGING
        placementIndicator.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        // - - - "AR_PlaceLevel" - Code
        UpdatePlacementPose();
        UpdatePlacementIndicator();
    }

    // - - - Function Archive - - - //


    // - - - "AR_PlaceLevel" - Code
    private void UpdatePlacementPose()
    {
        //initiating a new variable to store the center of my phone screen
        var screenCenter = arCamera.ViewportToScreenPoint(new Vector3(0.5f, 0.5f));
        //creating a empty list, in which I will store any hits by the raycast operation
        var hits = new List<ARRaycastHit>();

        //using the ARFoundation's inbuilt raycast operation to shoot a ray from the center of my screen into the "real world"
        //requires a (1) starting position, (2) a list in which to store hits and (3) a specification, which kind of hits are registered
        arRayManager.Raycast(screenCenter, hits, TrackableType.Planes);

        //sets placementPoseIsValid bool to true, if there is at least 1 hit in the raycast hit list.
        placementPoseIsValid = hits.Count > 0;

        //if the raycast registers at least one hit, ...
        if (placementPoseIsValid)
        {

            // ... the position of that hit is copied over to the placementPose object.
            placementPose = hits[0].pose;

            //creating a variable, that's acts as a forward vector of the camera direction.
            var cameraForward = arCamera.transform.forward;

            //calculating a new rotation for the placement pose (and therefore the placement indicator), based on the camera direction. 
            //y orientation is determined wether the detected plane is vertical or horizontal.
            var cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;
            placementPose.rotation = Quaternion.LookRotation(cameraBearing);

        }
    }

    private void UpdatePlacementIndicator()
    {
        //if atleast one hit has been registered by the raycast, ...
        if (placementPoseIsValid && levelStartPlaced == false)
        {
            // ... the placement indicator object will be visible.
            placementIndicator.SetActive(true);
            //the position and rotation of the placement indicator adapts the position and rotation of the placement pose.
            placementIndicator.transform.SetPositionAndRotation(placementPose.position, placementPose.rotation);
        }
        //if the raycast has registered no hits at all, ...
        else if ((!placementPoseIsValid || levelStartPlaced == true))
        {
            // ... the placement indicator object will be disappear.
            placementIndicator.SetActive(false);
        }
    }

    // - - - Fused Code from both Scripts

    public void CreateLevelOrigin()
    {
        //With no level ground plane existing one will be created
        if (levelStartPlaced == false)
        {
            //running a specialized function to randomly select the first room/Level Origin (excluding 1 Door Room Tiles!)
            roomRandomizerScript.StartRoomSelection();
            //assigning the levelOriginRoom (first room to be spawned) to the randomly selected room from the randomizer script
            levelOriginRoom = roomRandomizerScript.selectedStartRoom;

            //Spawning in the levelOriginRoom
            Instantiate(levelOriginRoom, placementPose.position, Quaternion.identity * Quaternion.Euler(-90.0f, 0.0f, 0.0f));
            //Spawning in the player
            Instantiate(player, placementPose.position + new Vector3(0.0f, 0.1f, -0.4f), placementPose.rotation);
            //Instantiate(player, placementPose.position + new Vector3(0.0f, 0.1f, 1.5f), placementPose.rotation);

            //For Player Controller Unresponsiveness Debugging
            //Instantiate(debugPlayerSpawnPlane, placementPose.position + new Vector3(0.0f, 0.1f, 1.5f), placementPose.rotation);

            //Set the bool to false to prevent more than one level ground plane being placed
            levelStartPlaced = true;

            //Play Trapdoor Audio
            audioSource.PlayOneShot(trapdoorSounds[0]);
            Invoke("PlaySecondTrapdoorAudio", 2.0f);
        }
    }

    private void PlaySecondTrapdoorAudio()
    {
        audioSource.PlayOneShot(trapdoorSounds[1]);
    }

}
