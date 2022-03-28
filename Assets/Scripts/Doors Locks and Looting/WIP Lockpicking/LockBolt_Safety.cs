using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockBolt_Safety : MonoBehaviour
{
    private void Update()
    {
        if (this.gameObject.transform.localPosition.y < 0.0f)
        {
            this.gameObject.transform.localPosition = new Vector3(this.gameObject.transform.localPosition.x, 0.0f, this.gameObject.transform.localPosition.z);
        }
        else if (this.gameObject.transform.localPosition.y > 0.0304f)
        {
            this.gameObject.transform.localPosition = new Vector3(this.gameObject.transform.localPosition.x, 0.0304f, this.gameObject.transform.localPosition.z);
        }
    }
}
