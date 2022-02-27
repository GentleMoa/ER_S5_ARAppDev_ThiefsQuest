using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GotItButton_AudioAllocator : MonoBehaviour
{
    [SerializeField] AudioClip scribbleSound;
    private AudioSource audioSource;

    [SerializeField] Button gotItButton;

    // Start is called before the first frame update
    void Start()
    {
        audioSource = GameObject.FindGameObjectWithTag("AudioHandler").GetComponent<AudioSource>();
        gotItButton.onClick.AddListener(GotItButtonPressed);
    }

    public void GotItButtonPressed()
    {
        audioSource.PlayOneShot(scribbleSound);
    }
}
