using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayPageturnAudioOnUISceneLoad : MonoBehaviour
{
    [SerializeField] AudioClip pageturnSFX;
    private AudioSource audioSource;

    // Start is called before the first frame update
    void Start()
    {
        audioSource = GameObject.FindGameObjectWithTag("AudioHandler").GetComponent<AudioSource>();
        audioSource.PlayOneShot(pageturnSFX);
    }
}
