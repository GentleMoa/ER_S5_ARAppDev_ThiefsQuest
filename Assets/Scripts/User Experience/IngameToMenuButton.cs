using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class IngameToMenuButton : MonoBehaviour
{
    public void IngameToMenuTransition()
    {
        SceneManager.LoadSceneAsync("Scene_Menu");
    }
}
