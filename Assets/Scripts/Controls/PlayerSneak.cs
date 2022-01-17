using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerSneak : MonoBehaviour
{
    //vars
    private Button sneakButton;
    public bool btn_crouching = false;

    private Animator playerAnimator;

    // Start is called before the first frame update
    void Start()
    {
        sneakButton = GameObject.FindGameObjectWithTag("SneakButton").GetComponent<Button>();
        playerAnimator = GetComponent<Animator>();
        //Adding the Listener
        sneakButton.onClick.AddListener(ToggleSneak);
        //Debug.Log("Added the Listener!");
    }

    // - - - Function Archive - - - //

    public void ToggleSneak()
    {
        if (btn_crouching == false)
        {
            playerAnimator.SetBool("isCrouching", true);
            btn_crouching = true;
            GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>().crouching = true;

            //Debugging
            Debug.Log("crouching = true!");
        }
        else if (btn_crouching == true)
        {
            playerAnimator.SetBool("isCrouching", false);
            btn_crouching = false;
            GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>().crouching = false;

            //Debugging
            Debug.Log("crouching = false!");
        }
    }
}
