using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class SceneManagement : MonoBehaviour
{
    // variables - AudioAllocationUISounds_SceneTutorial
    private Button skipButton;
    private Button menuButton;
    // variables - AudioAllocationUISounds_SceneMenu
    private Button toGameButton;
    private Button toTutorialButton;
    private Button gotItButton;

    private UIAudioHandling uiAudioScript;

    // Start is called before the first frame update
    void Start()
    {
        //reference the Audio Handler's UIAudioScript component
        uiAudioScript = GameObject.FindGameObjectWithTag("AudioHandler").GetComponent<UIAudioHandling>();

        AudioAllocationUISounds_SceneTutorial();
        AudioAllocationUISounds_SceneMenu();
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
        if (SceneManager.GetActiveScene().name == "Scene_Menu" /*|| SceneManager.GetActiveScene().name == "Scene_Tutorial"*/)
        {
            //Invoke("DelayedGameStart", 0.5f);
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


    // - - - Scene specific sound allocation - - - //


    private void AudioAllocationUISounds_SceneTutorial()
    {
        if(SceneManager.GetActiveScene().name == "Scene_Tutorial")
        {
            //referencing the UI buttons in the tutorial scene
            skipButton = GameObject.FindGameObjectWithTag("SkipButton").GetComponent<Button>();
            menuButton = GameObject.FindGameObjectWithTag("MenuButton").GetComponent<Button>();
            //add button listeners
            skipButton.onClick.AddListener(uiAudioScript.UIButtonPressed);
            menuButton.onClick.AddListener(uiAudioScript.UIButtonPressed);
        }
    }

    private void AudioAllocationUISounds_SceneMenu()
    {
        if (SceneManager.GetActiveScene().name == "Scene_Menu")
        {
            //referencing the UI buttons in the tutorial scene
            toGameButton = GameObject.FindGameObjectWithTag("ToGameButton").GetComponent<Button>();
            toTutorialButton = GameObject.FindGameObjectWithTag("ToTutorialButton").GetComponent<Button>();
            //add button listeners
            toGameButton.onClick.AddListener(uiAudioScript.UIButtonPressed);
            toTutorialButton.onClick.AddListener(uiAudioScript.UIButtonPressed);;
        }
    }


    /*
    private void DelayedGameStart()
    {
        SceneManager.LoadScene("Scene_1");
    }
    */
}
