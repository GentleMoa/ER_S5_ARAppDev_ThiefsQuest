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

    private Image sneakButtonImage;
    [SerializeField] Sprite sneakSpriteStealthed;
    [SerializeField] Sprite sneakSpriteUnstealthed;

    // Start is called before the first frame update
    void Start()
    {
        //referencing the SneakButton & Animator
        sneakButton = GameObject.FindGameObjectWithTag("SneakButton").GetComponent<Button>();
        playerAnimator = GetComponent<Animator>();
        //Adding the Listener
        sneakButton.onClick.AddListener(ToggleSneak);
        //Debug.Log("Added the Listener!");

        //referncing the sneakButtonImage
        sneakButtonImage = sneakButton.GetComponent<Image>();
    }

    // - - - Function Archive - - - //

    public void ToggleSneak()
    {
        if (btn_crouching == false)
        {
            playerAnimator.SetBool("isCrouching", true);
            btn_crouching = true;
            GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>().crouching = true;

            //Swapping to the correct sprite (stealthed)
            sneakButtonImage.sprite = sneakSpriteStealthed;

            //Debugging
            Debug.Log("crouching = true!");
        }
        else if (btn_crouching == true)
        {
            playerAnimator.SetBool("isCrouching", false);
            btn_crouching = false;
            GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>().crouching = false;

            //Swapping to the correct sprite (unstealthed)
            sneakButtonImage.sprite = sneakSpriteUnstealthed;

            //Debugging
            Debug.Log("crouching = false!");
        }
    }
}
