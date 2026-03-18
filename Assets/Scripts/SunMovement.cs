using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SunMovement : MonoBehaviour
{
    [SerializeField] private float _speed;
    [SerializeField] private Vector3 _rotation;

    private Vector3 _initPos;

    void Start()
    {
        _initPos = transform.position;
    }
    
    void Update()
    {
        transform.Translate(Vector3.forward * _speed * Time.deltaTime);
        transform.Rotate(_rotation * Time.deltaTime);
    }
}
