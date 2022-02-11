using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraPermissionHandling : MonoBehaviour
{
    [SerializeField] GameObject arSession_CameraPermissionPromptTrigger;
    [SerializeField] GameObject cameraPermissionInfo;
    [SerializeField] GameObject horizontalReminderInfo;

    private bool gameButtonPressed = false;
    private bool infoButtonPressed;
    private bool cameraPermissionGranted = false;

    // Start is called before the first frame update
    void Start()
    {
        //if the AR Session object exists, ...
        if (arSession_CameraPermissionPromptTrigger != null)
        {
            //disable it
            arSession_CameraPermissionPromptTrigger.SetActive(false);
        }

        //if the CP Info object exists, ...
        if (cameraPermissionInfo != null)
        {
            //disable it
            cameraPermissionInfo.SetActive(false);
            infoButtonPressed = false;
        }

        //if the CP Info object exists, ...
        if (horizontalReminderInfo != null)
        {
            //disable it
            horizontalReminderInfo.SetActive(false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ShowCameraPermissionInfo()
    {
        if (infoButtonPressed == false)
        {
            cameraPermissionInfo.SetActive(true);
            infoButtonPressed = true;
        } 
    }

    public void ShowHorizontalReminderInfo()
    {
        if (horizontalReminderInfo.activeSelf == false)
        {
            horizontalReminderInfo.SetActive(true);
        }
    }

    public void CameraPermissionProcess()
    {
        //if the game/start button has not yet been pressed, ...
        if (gameButtonPressed == false)
        {
            //activate the arSession object, which triggers the camera permission prompt
            arSession_CameraPermissionPromptTrigger.SetActive(true);
            //then immediately disable it in order to preserve performance
            DisableARSession(1.0f);

            //disables the CP info UI
            //cameraPermissionInfo.SetActive(false);

            ShowHorizontalReminderInfo();

            //game/start button has now been pressed
            gameButtonPressed = true;
        }
    }

    private IEnumerator DisableARSession(float time)
    {
        yield return new WaitForSeconds(time);

        //disabling the AR Session object to preserve performance
        arSession_CameraPermissionPromptTrigger.SetActive(false);
    }
}
