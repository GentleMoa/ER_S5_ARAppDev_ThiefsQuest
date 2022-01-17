using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SealUpLevelOrigin : MonoBehaviour
{
    private GameObject levelHandlerObj;
    private RoomCounter roomCounterScript;
    private GameObject deadEndObj;

    // Start is called before the first frame update
    void Start()
    {
        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
        roomCounterScript = levelHandlerObj.GetComponent<RoomCounter>();
        deadEndObj = levelHandlerObj.GetComponent<DeadEndTransmitter>().deadEndProxi;

        StartCoroutine(SealUpWithDeadEnd(0.19f));
    }

    // Update is called once per frame
    void Update()
    {
        TerminateScript();
    }

    // - - - Function Archive - - - //

    IEnumerator SealUpWithDeadEnd(float time)
    {
        yield return new WaitForSeconds(time);

        if (roomCounterScript.roomCount == 1)
        {
            Debug.Log("Seal the Level Entry in Room 1!");

            Instantiate(deadEndObj, this.transform.position, this.transform.rotation /* * Quaternion.Euler(0.0f, 0.0f, 180.0f) */, transform);
        }
    }
    private void TerminateScript()
    {
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            //Deactivating the gameObject, this script is placed on (and therefore disabling all its colliders)
            gameObject.GetComponent<Collider>().enabled = false;
            Destroy(GetComponent<SealUpLevelOrigin>());
        }
    }
}
