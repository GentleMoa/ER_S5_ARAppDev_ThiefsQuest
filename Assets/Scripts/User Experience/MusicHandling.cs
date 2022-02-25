using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MusicHandling : MonoBehaviour
{
    [SerializeField] AudioClip[] userJourneySongs;
    [SerializeField] AudioClip[] ingameSongs;
    [SerializeField] AudioSource audioSource;

    private bool switchedToGameScene = false;


    // Start is called before the first frame update
    void Start()
    {
        //Make this object (Music Handler obj) not be destroyed on scene change
        DontDestroyOnLoad(this.gameObject);
        //play the first song in the user journey songs array ("Marked" by default)
        audioSource.PlayOneShot(userJourneySongs[0]);
    }

    // Update is called once per frame
    void Update()
    {
        //if there is no song playing at the moment, ... (In scenes: menu, tutorial, player roles)
        if (audioSource.isPlaying == false && switchedToGameScene == false)
        {
            //... play a random one from the user journey songs array
            audioSource.PlayOneShot(userJourneySongs[Random.Range(0, userJourneySongs.Length)]);
        }

        //if there is no song playing at the moment, ... (In scene: in-game)
        if (audioSource.isPlaying == false && switchedToGameScene == true)
        {
            //... play a random one from the ingame songs array
            audioSource.PlayOneShot(ingameSongs[Random.Range(0, ingameSongs.Length)]);
        }

        
        if (SceneManager.GetActiveScene().name == "Scene_Menu" || SceneManager.GetActiveScene().name == "Scene_Tutorial" || SceneManager.GetActiveScene().name == "Scene_UserRole")
        {
            //keep playing the current User Journey Song
        }
        else if (SceneManager.GetActiveScene().name == "Scene_1" && switchedToGameScene == false)
        {
            //stop current song
            audioSource.Stop();
            //play the first song in the ingame songs array ("blacksmith" by default)
            audioSource.PlayOneShot(ingameSongs[0]);
            switchedToGameScene = true;
        }
        
    }
}
