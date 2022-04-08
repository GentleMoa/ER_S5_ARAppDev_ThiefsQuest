using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockSchematicInitializer : MonoBehaviour
{
    //Layer Objs
    [SerializeField] private GameObject layer_1;
    [SerializeField] private GameObject layer_2;
    [SerializeField] private GameObject layer_3;
    [SerializeField] private GameObject layer_4;
    [SerializeField] private GameObject layer_5;
    //Expanded Pos
    private Vector2 layer_1_exPos = new Vector2(-17.1f, -21.2f);
    private Vector2 layer_2_exPos = new Vector2(-9.2f, -21.2f);
    private Vector2 layer_3_exPos = new Vector2(-0.7f, -21.2f);
    private Vector2 layer_4_exPos = new Vector2(7.1f, -21.2f);
    private Vector2 layer_5_exPos = new Vector2(15.8f, -21.2f);
    //Rest Pos
    private Vector2 layers_restPos = new Vector3(0.0f, -21.2f);
    //Expander
    [SerializeField] private GameObject expanderButton;
    //Lerp Variables
    float lerpDuration = 1.0f;
    //Audio
    [SerializeField] AudioClip openSchematicScribbleSound;
    private AudioSource audioSource;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    public void ExpandSchematic()
    {
        //Start Coroutine
        StartCoroutine(LerpLayersToExPos());
        //Play paper scribble audio
        audioSource.PlayOneShot(openSchematicScribbleSound);
        //Destroying the Expander Button so the Schematic can be interacted with
        Destroy(expanderButton);
    }

    IEnumerator LerpLayersToExPos()
    {
        float timeElapsed = 0.0f;
        while (timeElapsed < lerpDuration)
        {
            layer_1.GetComponent<RectTransform>().anchoredPosition = Vector2.Lerp(layers_restPos, layer_1_exPos, timeElapsed / lerpDuration);
            layer_2.GetComponent<RectTransform>().anchoredPosition = Vector2.Lerp(layers_restPos, layer_2_exPos, timeElapsed / lerpDuration);
            layer_3.GetComponent<RectTransform>().anchoredPosition = Vector2.Lerp(layers_restPos, layer_3_exPos, timeElapsed / lerpDuration);
            layer_4.GetComponent<RectTransform>().anchoredPosition = Vector2.Lerp(layers_restPos, layer_4_exPos, timeElapsed / lerpDuration);
            layer_5.GetComponent<RectTransform>().anchoredPosition = Vector2.Lerp(layers_restPos, layer_5_exPos, timeElapsed / lerpDuration);

            timeElapsed += Time.deltaTime;
            yield return null;
        }

        layer_1.GetComponent<RectTransform>().anchoredPosition = layer_1_exPos;
        layer_2.GetComponent<RectTransform>().anchoredPosition = layer_2_exPos;
        layer_3.GetComponent<RectTransform>().anchoredPosition = layer_3_exPos;
        layer_4.GetComponent<RectTransform>().anchoredPosition = layer_4_exPos;
        layer_5.GetComponent<RectTransform>().anchoredPosition = layer_5_exPos;
    }

}
