using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightningStriker : MonoBehaviour {

    [SerializeField] float lightningFrequency;
    [SerializeField] Light lighting;
    [SerializeField] float lightningDuration;
    [SerializeField] float thunderDelay;

    [SerializeField] AudioClip[] thunderSounds;
    [SerializeField] AudioSource audioSource;

    //public float offmin = 10f;
    //public float offMax = 60f;
    //public float onMin = 0.25f;
    //public float onMax = 0.8f;
    //public Light light;
    //public AudioClip[] thunderSounds;
    //public AudioSource audioSource;

	void Start () 
    {
        //if the lightning light obj has not been assigned in the inspector, create a reference to it now
        if (lighting == null)
        {
            lighting = GameObject.FindGameObjectWithTag("Lightning").GetComponent<Light>();
        }

        StartCoroutine("LightningStrike"); 
	}
	
    IEnumerator LightningStrike()
    {
        while(true)
        {
            //frequency of the lightning = how often there will be lightning
            lightningFrequency = Random.Range(10.0f, 15.0f);
            yield return new WaitForSeconds(lightningFrequency);
            lighting.enabled = true;

            StartCoroutine("Thunder");

            //lightning duration = how long a single lightning strike lasts
            lightningDuration = Random.Range(0.25f, 0.8f);
            yield return new WaitForSeconds(lightningDuration);
            lighting.enabled = false;
        }
    }

    IEnumerator Thunder()
    {
        //thunder Delay = how much time between the lightning and the following thunder will pass
        thunderDelay = Random.Range(2.0f, 4.0f);
        yield return new WaitForSeconds(thunderDelay);
        audioSource.PlayOneShot(thunderSounds[Random.Range(0, thunderSounds.Length)]); 
    }
}
