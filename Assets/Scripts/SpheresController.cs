using NUnit.Framework;
using System.Collections.Generic;
using UnityEngine;

public class SpheresController : MonoBehaviour
{
    [SerializeField] private List<SkyMovement> spheres = new List<SkyMovement>();

    void Start()
    {
        
    }

    void Update()
    {
        
    }

    public void ToggleSpheresMovement()
    {
        foreach (var sphere in spheres)
        {
            sphere.enabled = !sphere.enabled;
        }
    }
}
