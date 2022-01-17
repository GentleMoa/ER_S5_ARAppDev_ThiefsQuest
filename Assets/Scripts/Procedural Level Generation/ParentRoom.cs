using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParentRoom : MonoBehaviour
{
    public GameObject[] connectors;

    private RoomSpawner roomSpawnerScript;

    private GameObject levelHandlerObj;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(ActivateConnectors(1.0f));

        levelHandlerObj = GameObject.FindGameObjectWithTag("Level Handler");
    }

    // Update is called once per frame
    void Update()
    {
        TerminateScript();

        /*
        if (transform.position.y < -49)
        {
            Destroy(gameObject);
        }
        */

    }

    // - - - Function Archive - - - //

    IEnumerator ActivateConnectors(float time)
    {
        yield return new WaitForSeconds(time);

        if (connectors.Length > 0)
        {
            for (int i = 0; i < connectors.Length; i++)
            {
                roomSpawnerScript = connectors[i].GetComponent<RoomSpawner>();

                if (roomSpawnerScript.connected == false)
                {
                    roomSpawnerScript.CreateAdjacentRoom();
                }

            }
        }
        else if (connectors.Length == 0)
        {
            Debug.Log("This path ends here!");
        }

    }

    private void TerminateScript()
    {
        if (levelHandlerObj.GetComponent<RoomCounter>().levelGenerationFinished == true)
        {
            Destroy(GetComponent<ParentRoom>());
        }
    }
}
