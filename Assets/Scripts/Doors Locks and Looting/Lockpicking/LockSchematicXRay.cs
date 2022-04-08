using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LockSchematicXRay : MonoBehaviour
{
    #region Variables

    //Opque/Transparent Lock mats
    [SerializeField] private Material matOpaque;
    [SerializeField] private Material matTransparent;
    //XRay booleans
    private bool layer_1Transparent = false;
    private bool layer_2Transparent = false;
    private bool layer_3Transparent = false;
    private bool layer_4Transparent = false;
    private bool layer_5Transparent = false;
    //Lock Layer Objects
    [SerializeField] private GameObject l1_obj_1;
    [SerializeField] private GameObject l1_obj_2;
    [SerializeField] private GameObject l2_obj_1;
    [SerializeField] private GameObject l2_obj_2;
    [SerializeField] private GameObject l2_obj_3;
    [SerializeField] private GameObject l2_obj_4;
    [SerializeField] private GameObject l2_obj_5;
    [SerializeField] private GameObject l2_obj_6;
    [SerializeField] private GameObject l2_obj_7;
    [SerializeField] private GameObject l2_obj_8;
    [SerializeField] private GameObject l3_obj_1;
    [SerializeField] private GameObject l4_obj_1;
    [SerializeField] private GameObject l5_obj_1;
    [SerializeField] private GameObject l5_obj_2;
    //Renderer / Material variables
    //l1_obj_1
    private Renderer l1_obj_1_rnd;
    private Material l1_obj_1_mat;
    private Material[] l1_obj_1_mats;
    //l1_obj_2
    private Renderer l1_obj_2_rnd;
    private Material l1_obj_2_mat;
    private Material[] l1_obj_2_mats;
    //l2_obj_1
    private Renderer l2_obj_1_rnd;
    private Material l2_obj_1_mat;
    private Material[] l2_obj_1_mats;
    //l2_obj_2
    private Renderer l2_obj_2_rnd;
    private Material l2_obj_2_mat;
    private Material[] l2_obj_2_mats;
    //l2_obj_3
    private Renderer l2_obj_3_rnd;
    private Material l2_obj_3_mat;
    private Material[] l2_obj_3_mats;
    //l2_obj_4
    private Renderer l2_obj_4_rnd;
    private Material l2_obj_4_mat;
    private Material[] l2_obj_4_mats;
    //l2_obj_5
    private Renderer l2_obj_5_rnd;
    private Material l2_obj_5_mat;
    private Material[] l2_obj_5_mats;
    //l2_obj_6
    private Renderer l2_obj_6_rnd;
    private Material l2_obj_6_mat;
    private Material[] l2_obj_6_mats;
    //l2_obj_7
    private Renderer l2_obj_7_rnd;
    private Material l2_obj_7_mat;
    private Material[] l2_obj_7_mats;
    //l2_obj_8
    private Renderer l2_obj_8_rnd;
    private Material l2_obj_8_mat;
    private Material[] l2_obj_8_mats;
    //l3_obj_1
    private Renderer l3_obj_1_rnd;
    private Material l3_obj_1_mat;
    private Material[] l3_obj_1_mats;
    //l4_obj_1
    private Renderer l4_obj_1_rnd;
    private Material l4_obj_1_mat;
    private Material[] l4_obj_1_mats;
    //l5_obj_1
    private Renderer l5_obj_1_rnd;
    private Material l5_obj_1_mat;
    private Material[] l5_obj_1_mats;
    //l5_obj_2
    private Renderer l5_obj_2_rnd;
    private Material l5_obj_2_mat;
    private Material[] l5_obj_2_mats;
    //Sprite Color / Image variables
    [SerializeField] private Image layer_1_img;
    [SerializeField] private Image layer_2_img;
    [SerializeField] private Image layer_3_img;
    [SerializeField] private Image layer_4_img;
    [SerializeField] private Image layer_5_img;
    private Color spriteColorOpaque;
    [SerializeField] private Color spriteColorTransparent;
    //Audio
    [SerializeField] AudioClip[] lockSchematicPaperSounds;
    private AudioSource audioSource;

    #endregion

    #region Reference Audio Source in Start

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    #endregion

    #region Layer_1XRay
    public void Layer_1XRay()
    {
        if (layer_1Transparent == false)
        {
            //l1_obj_1
            //grab the objs renderer
            l1_obj_1_rnd = l1_obj_1.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l1_obj_1_mats = l1_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l1_obj_1_mats[0] = matTransparent;
            l1_obj_1_rnd.materials = l1_obj_1_mats;

            //l1_obj_2
            //grab the objs renderer
            l1_obj_2_rnd = l1_obj_2.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l1_obj_2_mats = l1_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l1_obj_2_mats[0] = matTransparent;
            l1_obj_2_rnd.materials = l1_obj_2_mats;

            //sprite color change
            spriteColorOpaque = layer_1_img.color;
            layer_1_img.color = spriteColorTransparent;

            //set the flag
            layer_1Transparent = true;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[0]);
        }
        else if (layer_1Transparent == true)
        {
            //l1_obj_1
            //assigning the mats array to the objs mats
            l1_obj_1_mats = l1_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l1_obj_1_mats[0] = matOpaque;
            l1_obj_1_rnd.materials = l1_obj_1_mats;

            //l1_obj_2
            //assigning the mats array to the objs mats
            l1_obj_2_mats = l1_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l1_obj_2_mats[0] = matOpaque;
            l1_obj_2_rnd.materials = l1_obj_2_mats;

            //sprite color change
            layer_1_img.color = spriteColorOpaque;

            //set the flag
            layer_1Transparent = false;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[1]);
        }
    }
    #endregion

    #region Layer_2XRay
    public void Layer_2XRay()
    {
        if (layer_2Transparent == false)
        {
            //l2_obj_1
            //grab the objs renderer
            l2_obj_1_rnd = l2_obj_1.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_1_mats = l2_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_1_mats[0] = matTransparent;
            l2_obj_1_rnd.materials = l2_obj_1_mats;

            //l2_obj_2
            //grab the objs renderer
            l2_obj_2_rnd = l2_obj_2.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_2_mats = l2_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_2_mats[0] = matTransparent;
            l2_obj_2_rnd.materials = l2_obj_2_mats;

            //l2_obj_3
            //grab the objs renderer
            l2_obj_3_rnd = l2_obj_3.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_3_mats = l2_obj_3_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_3_mats[0] = matTransparent;
            l2_obj_3_rnd.materials = l2_obj_3_mats;

            //l2_obj_4
            //grab the objs renderer
            l2_obj_4_rnd = l2_obj_4.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_4_mats = l2_obj_4_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_4_mats[0] = matTransparent;
            l2_obj_4_rnd.materials = l2_obj_4_mats;

            //l2_obj_5
            //grab the objs renderer
            l2_obj_5_rnd = l2_obj_5.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_5_mats = l2_obj_5_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_5_mats[0] = matTransparent;
            l2_obj_5_rnd.materials = l2_obj_5_mats;

            //l2_obj_6
            //grab the objs renderer
            l2_obj_6_rnd = l2_obj_6.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_6_mats = l2_obj_6_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_6_mats[0] = matTransparent;
            l2_obj_6_rnd.materials = l2_obj_6_mats;

            //l2_obj_7
            //grab the objs renderer
            l2_obj_7_rnd = l2_obj_7.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_7_mats = l2_obj_7_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_7_mats[0] = matTransparent;
            l2_obj_7_rnd.materials = l2_obj_7_mats;

            //l2_obj_8
            //grab the objs renderer
            l2_obj_8_rnd = l2_obj_8.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l2_obj_8_mats = l2_obj_8_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_8_mats[0] = matTransparent;
            l2_obj_8_rnd.materials = l2_obj_8_mats;

            //sprite color change
            spriteColorOpaque = layer_2_img.color;
            layer_2_img.color = spriteColorTransparent;

            //set the flag
            layer_2Transparent = true;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[0]);
        }
        else if (layer_2Transparent == true)
        {
            //l2_obj_1
            //assigning the mats array to the objs mats
            l2_obj_1_mats = l2_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_1_mats[0] = matOpaque;
            l2_obj_1_rnd.materials = l2_obj_1_mats;

            //l2_obj_2
            //assigning the mats array to the objs mats
            l2_obj_2_mats = l2_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_2_mats[0] = matOpaque;
            l2_obj_2_rnd.materials = l2_obj_2_mats;

            //l2_obj_3
            //assigning the mats array to the objs mats
            l2_obj_3_mats = l2_obj_3_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_3_mats[0] = matOpaque;
            l2_obj_3_rnd.materials = l2_obj_3_mats;

            //l2_obj_4
            //assigning the mats array to the objs mats
            l2_obj_4_mats = l2_obj_4_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_4_mats[0] = matOpaque;
            l2_obj_4_rnd.materials = l2_obj_4_mats;

            //l2_obj_5
            //assigning the mats array to the objs mats
            l2_obj_5_mats = l2_obj_5_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_5_mats[0] = matOpaque;
            l2_obj_5_rnd.materials = l2_obj_5_mats;

            //l2_obj_6
            //assigning the mats array to the objs mats
            l2_obj_6_mats = l2_obj_6_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_6_mats[0] = matOpaque;
            l2_obj_6_rnd.materials = l2_obj_6_mats;

            //l2_obj_7
            //assigning the mats array to the objs mats
            l2_obj_7_mats = l2_obj_7_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_7_mats[0] = matOpaque;
            l2_obj_7_rnd.materials = l2_obj_7_mats;

            //l2_obj_8
            //assigning the mats array to the objs mats
            l2_obj_8_mats = l2_obj_8_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l2_obj_8_mats[0] = matOpaque;
            l2_obj_8_rnd.materials = l2_obj_8_mats;

            //sprite color change
            layer_2_img.color = spriteColorOpaque;

            //set the flag
            layer_2Transparent = false;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[1]);
        }
    }
    #endregion

    #region Layer_3XRay
    public void Layer_3XRay()
    {
        if (layer_3Transparent == false)
        {
            //l3_obj_1
            //grab the objs renderer
            l3_obj_1_rnd = l3_obj_1.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l3_obj_1_mats = l3_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l3_obj_1_mats[0] = matTransparent;
            l3_obj_1_rnd.materials = l3_obj_1_mats;

            //sprite color change
            spriteColorOpaque = layer_3_img.color;
            layer_3_img.color = spriteColorTransparent;

            //set the flag
            layer_3Transparent = true;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[0]);
        }
        else if (layer_3Transparent == true)
        {
            //l3_obj_1
            //assigning the mats array to the objs mats
            l3_obj_1_mats = l3_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l3_obj_1_mats[0] = matOpaque;
            l3_obj_1_rnd.materials = l3_obj_1_mats;

            //sprite color change
            layer_3_img.color = spriteColorOpaque;

            //set the flag
            layer_3Transparent = false;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[1]);
        }
    }
    #endregion

    #region Layer_4XRay
    public void Layer_4XRay()
    {
        if (layer_4Transparent == false)
        {
            //l4_obj_1
            //grab the objs renderer
            l4_obj_1_rnd = l4_obj_1.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l4_obj_1_mats = l4_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l4_obj_1_mats[0] = matTransparent;
            l4_obj_1_rnd.materials = l4_obj_1_mats;

            //sprite color change
            spriteColorOpaque = layer_4_img.color;
            layer_4_img.color = spriteColorTransparent;

            //set the flag
            layer_4Transparent = true;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[0]);
        }
        else if (layer_4Transparent == true)
        {
            //l4_obj_1
            //assigning the mats array to the objs mats
            l4_obj_1_mats = l4_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l4_obj_1_mats[0] = matOpaque;
            l4_obj_1_rnd.materials = l4_obj_1_mats;

            //sprite color change
            layer_4_img.color = spriteColorOpaque;

            //set the flag
            layer_4Transparent = false;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[1]);
        }
    }
    #endregion

    #region Layer_5XRay
    public void Layer_5XRay()
    {
        if (layer_5Transparent == false)
        {
            //l5_obj_1
            //grab the objs renderer
            l5_obj_1_rnd = l5_obj_1.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l5_obj_1_mats = l5_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l5_obj_1_mats[0] = matTransparent;
            l5_obj_1_rnd.materials = l5_obj_1_mats;

            //l5_obj_2
            //grab the objs renderer
            l5_obj_2_rnd = l5_obj_2.GetComponent<Renderer>();
            //assigning the mats array to the objs mats
            l5_obj_2_mats = l5_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l5_obj_2_mats[0] = matTransparent;
            l5_obj_2_rnd.materials = l5_obj_2_mats;

            //sprite color change
            spriteColorOpaque = layer_5_img.color;
            layer_5_img.color = spriteColorTransparent;

            //set the flag
            layer_5Transparent = true;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[0]);
        }
        else if (layer_5Transparent == true)
        {
            //l5_obj_1
            //assigning the mats array to the objs mats
            l5_obj_1_mats = l5_obj_1_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l5_obj_1_mats[0] = matOpaque;
            l5_obj_1_rnd.materials = l5_obj_1_mats;

            //l5_obj_2
            //assigning the mats array to the objs mats
            l5_obj_2_mats = l5_obj_2_rnd.materials;
            //assigning the first mat in the array to be the transparent mat
            l5_obj_2_mats[0] = matOpaque;
            l5_obj_2_rnd.materials = l5_obj_2_mats;

            //sprite color change
            layer_5_img.color = spriteColorOpaque;

            //set the flag
            layer_5Transparent = false;

            //play audio
            audioSource.PlayOneShot(lockSchematicPaperSounds[1]);
        }
    }
    #endregion
}
