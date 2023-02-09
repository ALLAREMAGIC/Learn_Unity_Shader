using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float rotateSpeed = 5f;
    public GameObject center;

    private bool isRotate = false;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isRotate = !isRotate;
        }
        if (isRotate)
            transform.RotateAround(center.transform.position, Vector3.up, rotateSpeed * Time.deltaTime);
    }
}
