using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

namespace Lean.Touch
{
    public class LockpickScriptManager : MonoBehaviour
    {
        [SerializeField] private LockpickingLogic parentScript;
        private CustomRotateScript lockpickRotateScript;

        private GameObject uiDebugger;

        // Start is called before the first frame update
        void Start()
        {
            lockpickRotateScript = this.GetComponent<CustomRotateScript>();
            lockpickRotateScript.enabled = false;

            uiDebugger = GameObject.FindGameObjectWithTag("UIDebugger");
        }

        // Update is called once per frame
        void Update()
        {
            RotateScriptManagement_L1();
            RotateScriptManagement_L2();
            RotateScriptManagement_L3();
            RotateScriptManagement_L4();

            UIDebugging();
        }

        #region RotateScriptManagement

        private void RotateScriptManagement_L1()
        {
            if (this.gameObject.tag == "Lockpick_1")
            {
                if (parentScript.lockpick_1_Active == true)
                {
                    lockpickRotateScript.enabled = true;
                }
                else if (parentScript.lockpick_1_Active == false)
                {
                    lockpickRotateScript.enabled = false;
                }
            }
        }

        private void RotateScriptManagement_L2()
        {
            if (this.gameObject.tag == "Lockpick_2")
            {
                if (parentScript.lockpick_2_Active == true)
                {
                    lockpickRotateScript.enabled = true;
                }
                else if (parentScript.lockpick_2_Active == false)
                {
                    lockpickRotateScript.enabled = false;
                }
            }
        }

        private void RotateScriptManagement_L3()
        {
            if (this.gameObject.tag == "Lockpick_3")
            {
                if (parentScript.lockpick_3_Active == true)
                {
                    lockpickRotateScript.enabled = true;
                }
                else if (parentScript.lockpick_3_Active == false)
                {
                    lockpickRotateScript.enabled = false;
                }
            }
        }

        private void RotateScriptManagement_L4()
        {
            if (this.gameObject.tag == "Lockpick_4")
            {
                if (parentScript.lockpick_4_Active == true)
                {
                    lockpickRotateScript.enabled = true;
                }
                else if (parentScript.lockpick_4_Active == false)
                {
                    lockpickRotateScript.enabled = false;
                }
            }
        }

        #endregion

        private void UIDebugging()
        {
            uiDebugger.GetComponent<Image>().enabled = true;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().enabled = true;
            uiDebugger.transform.GetChild(1).gameObject.GetComponent<TMP_Text>().text = parentScript.lockpickGeneral.tag + " rotate script enabled: " + parentScript.lockpickGeneral.gameObject.GetComponent<CustomRotateScript>().isActiveAndEnabled;
        }
    }
}

