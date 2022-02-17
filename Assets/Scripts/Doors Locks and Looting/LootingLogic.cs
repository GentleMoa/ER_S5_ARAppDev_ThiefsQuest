using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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

        //then loot the container
        Debug.Log("You looted " + Random.Range(30, 150) + " coins!");

        //call a delayed function, which plays the closing anim
        Invoke("DelayedClosing", 3.0f);
    }

    private void DelayedClosing()
    {
        //play container closing anim here
        containerAnimator.SetTrigger("containerClosing");
    }
}
