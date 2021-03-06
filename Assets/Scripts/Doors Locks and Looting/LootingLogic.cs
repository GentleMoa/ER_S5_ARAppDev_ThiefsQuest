using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using TMPro.Examples;

public class LootingLogic : MonoBehaviour
{
    [SerializeField]
    private GameObject lootingUI;

    private Collider containerCol;
    public Button lootingButton;
    private bool lootingUISpawned = false;

    private GameObject lootingUIToBeDestroyed;

    [SerializeField]
    private Animator containerAnimator;

    private bool containerOpened = false;

    private GameObject canvasLootMessageBackground;
    private Image lootBackgroundImage;
    private TMP_Text lootMessageText;

    private WarpTextExample warpTextScript;

    [SerializeField] AudioClip[] coinSounds;
    [SerializeField] AudioClip[] containerOpenSounds;
    [SerializeField] AudioClip[] containerCloseSounds;

    private AudioSource audioSource;

    private int lootedCoin;
    private GameObject totalLootUI;
    private TMP_Text totalLootText;

    public static int coinAmount = 0;

    // Start is called before the first frame update
    void Start()
    {
        //referencing this objects collider
        containerCol = GetComponent<Collider>();
        //in case isTrigger is not checked, ...
        if (containerCol.isTrigger == false)
        {
            //... do so now
            containerCol.isTrigger = true;
        }

        //referencing the canvasLootMessageBackground by tag
        canvasLootMessageBackground = GameObject.FindGameObjectWithTag("CanvasLootMessage");

        //referencing the TMPro WrapTextExample - script
        warpTextScript = canvasLootMessageBackground.transform.GetChild(0).gameObject.GetComponent<WarpTextExample>();

        //referencing the audio source component on this scripts holder go
        audioSource = GetComponent<AudioSource>();

        //reference the Total Loot UI
        totalLootUI = GameObject.FindGameObjectWithTag("TotalLootUI");
    }

    private void OnTriggerEnter(Collider other)
    {
        //if the player enters this collider, ...
        if (other.gameObject.tag == "Player")
        {
            //... the looting UI button in world space is spawned
            SpawnLootingUI();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        //if the playert exits this collider and there already is a looting UI, ...
        if (other.gameObject.tag == "Player" && lootingUISpawned == true)
        {
            //find the freshly spawned Looting UI
            lootingUIToBeDestroyed = GameObject.FindGameObjectWithTag("LootingButton");
            //Destroying it, when the player leaves the trigger without opening (and if there even is one)
            if (lootingUIToBeDestroyed != null)
            {
                Destroy(lootingUIToBeDestroyed);
                //resetting the flag to false
                lootingUISpawned = false;
            }
        }
    }

    private void SpawnLootingUI()
    {
        //if there is no Looting UI spawned yet, ...
        if (lootingUISpawned == false && containerOpened == false)
        {
            //Spawn Looting UI button
            Instantiate(lootingUI, this.transform.position + new Vector3(0.0f, 0.4f, 0.0f), this.transform.rotation, transform);

            //Setting the flag to true
            lootingUISpawned = true;

            //Reference the unlockButton Button (from the world space UI)
            lootingButton = transform.GetChild(1).GetChild(0).gameObject.GetComponent<Button>();
            //Adding the button press listener
            lootingButton.onClick.AddListener(LootContainer);
        }
    }

    public void LootContainer()
    {
        //find the freshly spawned Looting UI
        lootingUIToBeDestroyed = GameObject.FindGameObjectWithTag("LootingButton");
        //Destroying it, when the player leaves the trigger without opening (and if there even is one)
        if (lootingUIToBeDestroyed != null)
        {
            Destroy(lootingUIToBeDestroyed);
            //resetting the flag to false
            lootingUISpawned = false;
        }

        //flag
        containerOpened = true;
        //play container opening anim here
        containerAnimator.SetTrigger("containerOpening");
        //play a random container opening audio clip from the respective array
        audioSource.PlayOneShot(containerOpenSounds[Random.Range(0, containerOpenSounds.Length)]);

        //Invoke the ReceiveLoot function
        Invoke("ReceiveLoot", 1.5f);

        //call a delayed function, which plays the closing anim
        Invoke("DelayedClosing", 3.0f);
    }

    private void DelayedClosing()
    {
        //play container closing anim here
        containerAnimator.SetTrigger("containerClosing");
        //call DelayedClosingAudio function
        Invoke("DelayedClosingAudio", 1.0f);
    }

    private void ReceiveLoot()
    {
        //enable the lootBackgroundImage
        if (canvasLootMessageBackground.GetComponent<Image>().isActiveAndEnabled == false)
        {
            lootBackgroundImage = canvasLootMessageBackground.GetComponent<Image>();
            lootBackgroundImage.enabled = true;
        }

        //Randomize the amount of gold looted
        lootedCoin = Random.Range(2, 50);

        //enable and change the text
        lootMessageText = canvasLootMessageBackground.transform.GetChild(0).gameObject.GetComponent<TMP_Text>();
        lootMessageText.SetText("You looted " + lootedCoin + " coins!");
        lootMessageText.enabled = true;

        //Add the freshly looted coin to your total coin amount
        coinAmount = coinAmount + lootedCoin;

        //update the totalLootUI
        UpdateTotalLootUI();

        Invoke("DelayedDisableCanvasLootMessage", 3.5f);

        //Play the coins audio
        audioSource.PlayOneShot(coinSounds[Random.Range(0, coinSounds.Length)]);
    }

    private void DelayedDisableCanvasLootMessage()
    {
        if (lootBackgroundImage.enabled == true)
        {
            lootBackgroundImage.enabled = false;
        }
        lootMessageText.enabled = false;
        warpTextScript.textHasBeenWrapped = false;
    }

    private void DelayedClosingAudio()
    {
        //play a random container closing audio clip from the respective array
        audioSource.PlayOneShot(containerCloseSounds[Random.Range(0, containerCloseSounds.Length)]);
    }

    private void UpdateTotalLootUI()
    {
        totalLootText = totalLootUI.transform.GetChild(0).gameObject.GetComponent<TMP_Text>();
        totalLootText.text = coinAmount.ToString();
    }
}
