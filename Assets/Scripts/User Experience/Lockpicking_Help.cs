using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Lockpicking_Help : MonoBehaviour
{
    [SerializeField] private GameObject lockpickingHelp;
    [SerializeField] private GameObject closeOut_Button;
    [SerializeField] private AudioClip[] lockpickingHelpSounds;
    [SerializeField] private AudioSource audioSource;

    public void ShowLockpickingHelp()
    {
        lockpickingHelp.GetComponent<Image>().enabled = true;
        closeOut_Button.GetComponent<Image>().enabled = true;
        audioSource.PlayOneShot(lockpickingHelpSounds[0]);
    }

    public void HideLockpickingHelp()
    {
        lockpickingHelp.GetComponent<Image>().enabled = false;
        closeOut_Button.GetComponent<Image>().enabled = false;
        audioSource.PlayOneShot(lockpickingHelpSounds[1]);
    }
}
