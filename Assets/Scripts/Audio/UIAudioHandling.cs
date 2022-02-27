using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIAudioHandling : MonoBehaviour
{
    [SerializeField] AudioClip[] paperUISounds;
    [SerializeField] AudioSource audioSource;

    public void UIButtonPressed()
    {
        audioSource.PlayOneShot(paperUISounds[Random.Range(0, paperUISounds.Length)]);
    }
}
