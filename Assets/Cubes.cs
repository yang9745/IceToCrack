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

public class Cubes : MonoBehaviour
{
    public bool b = false;
    Vector3 pos = Vector3.zero;
    void Start()
    {
        pos = transform.position;
    }
    float _time=0;
    // Update is called once per frame
    void Update()
    {
        if(b==true)
        {
            _time += Time.deltaTime/5;
            if(_time>=1)
            {
                _time = 0;
                b = false;
            }
            transform.position += new Vector3(0, -10, 0)*Time.deltaTime;
        }
        else
        {
            transform.position = pos;
        }
    }
}
