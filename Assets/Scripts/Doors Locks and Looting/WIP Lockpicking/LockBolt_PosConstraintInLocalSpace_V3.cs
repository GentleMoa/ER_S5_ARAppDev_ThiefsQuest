using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LockBolt_PosConstraintInLocalSpace_V3 : MonoBehaviour
{
    private Rigidbody _rigidbody;
    private float _localX = 0;
    private float _localY = 0;
    private float _localZ = 0;
    public bool _freezeAlongX = false;
    public bool _freezeAlongY = false;
    public bool _freezeAlongZ = false;

    public bool threshold = false;
    public float transformLastFrame;
    public float transformCurrentFrame;
    public float transformDifference;

    // Use this for initialization
    void Start()
    {
        _rigidbody = gameObject.GetComponent<Rigidbody>();
        transformCurrentFrame = transform.localPosition.y;
    }

    void Update()
    {
        _localX = transform.localPosition.x;
        _localY = transform.localPosition.y;
        _localZ = transform.localPosition.z;

        if (_freezeAlongX) _localX = 0;
        if (_freezeAlongY) _localY = 0;
        if (_freezeAlongZ) _localZ = 0;

        transformDifference = transformCurrentFrame - transformLastFrame;

        if (transformDifference > 0.001f)
        {
            threshold = true;
        }
        else if (transformDifference < 0.001f)
        {
            threshold = false;
        }


        if (threshold == true)
        {
            gameObject.transform.localPosition = new Vector3(_localX, _localY, _localZ);
        }

        transformLastFrame = transformCurrentFrame;

        if (threshold == false)
        {
            gameObject.transform.localPosition = new Vector3(0.0f, 0.0f, 0.0f);
        }
    }
}
