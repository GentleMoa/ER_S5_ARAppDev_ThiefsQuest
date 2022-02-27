using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayTrapdoorSFX : MonoBehaviour
{
    [SerializeField] AudioClip[] trapdoorSounds;
    [SerializeField] AudioSource audioSource;

    private Button placeLevelButton;

    // Start is called before the first frame update
    void Start()
    {
        placeLevelButton = GetComponent<Button>();
        placeLevelButton.onClick.AddListener(PlayTrapdoorAudio);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayTrapdoorAudio()
    {
        //Play Trapdoor Audio
        audioSource.PlayOneShot(trapdoorSounds[0]);
        Invoke("PlaySecondTrapdoorAudio", 1.0f);
    }
    private void PlaySecondTrapdoorAudio()
    {
    audioSource.PlayOneShot(trapdoorSounds[1]);
    }
}
