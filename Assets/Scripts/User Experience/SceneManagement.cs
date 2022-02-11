using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneManagement : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    // - - - Scene Changing / Loading - - - //

    public void LoadScene_Menu()
    {
        if (SceneManager.GetActiveScene().name == "Scene_Tutorial" || SceneManager.GetActiveScene().name == "Scene_UserRole")
        {
            SceneManager.LoadSceneAsync("Scene_Menu");
        } 
    }

    public void LoadScene_Game()
    {
        if (SceneManager.GetActiveScene().name == "Scene_Menu")
        {
            SceneManager.LoadScene("Scene_1");
        }
    }

    public void LoadScene_Tutorial()
    {
        if (SceneManager.GetActiveScene().name == "Scene_Menu" || SceneManager.GetActiveScene().name == "Scene_UserRole")
        {
            SceneManager.LoadSceneAsync("Scene_Tutorial");
        }
    }

}
