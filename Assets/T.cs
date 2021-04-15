/*************************************
*
*版本：     V1.0.0
*创建人： 杨晓涛
*日期：    21/X/X
*作用：    未知
*描述：    未知
*
***********************************/
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class T : MonoBehaviour
{
    public Camera mainCamera;

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if(Physics.Raycast(ray,out hit,200,LayerMask.GetMask("Water")))
            {
                hit.transform.GetComponent<Cubes>().b = true; 
            }
        }
    }

}
