using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OrientationLock : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //In the following scenes, the orientation will be locked in portrait (vertical) mode: Scene_Menu, Scene_Tutorial, Scene_UserRole
        if (SceneManager.GetActiveScene().name == "Scene_Menu" || SceneManager.GetActiveScene().name == "Scene_Tutorial" || SceneManager.GetActiveScene().name == "Scene_UserRole")
        {
            Screen.orientation = ScreenOrientation.Portrait;
        }
        //In the following scenes, the orientation will be locked in landscape.left (horizontal) mode: Scene_1
        else if (SceneManager.GetActiveScene().name == "Scene_1")
        {
            Invoke("TurnOrientationLandscapeMode", 1.0f);
        }
    }

    private void TurnOrientationLandscapeMode()
    {
        Screen.orientation = ScreenOrientation.LandscapeLeft;
    }
}
