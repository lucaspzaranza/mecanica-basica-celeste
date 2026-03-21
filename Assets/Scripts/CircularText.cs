using UnityEngine;
using TMPro;

[RequireComponent(typeof(TMP_Text))]
public class CircularText : MonoBehaviour
{
    [SerializeField] private float radius = 5f;
    [SerializeField] private float startAngleDeg = 0f;
    [SerializeField] private bool clockwise = false;

    private TMP_Text _tmp;

    void Awake() => _tmp = GetComponent<TMP_Text>();

    void OnEnable() => TMPro_EventManager.TEXT_CHANGED_EVENT.Add(OnTextChanged);
    void OnDisable() => TMPro_EventManager.TEXT_CHANGED_EVENT.Remove(OnTextChanged);

    void OnTextChanged(Object obj)
    {
        if (obj == _tmp) ApplyCurve();
    }

    void Start() => ApplyCurve();

    void ApplyCurve()
    {
        _tmp.ForceMeshUpdate();
        TMP_TextInfo textInfo = _tmp.textInfo;

        int dir = clockwise ? -1 : 1;
        float angleStep = 360f / Mathf.Max(textInfo.characterCount, 1);

        for (int i = 0; i < textInfo.characterCount; i++)
        {
            TMP_CharacterInfo charInfo = textInfo.characterInfo[i];
            if (!charInfo.isVisible) continue;

            float angleDeg = startAngleDeg + i * angleStep * dir;
            float angleRad = angleDeg * Mathf.Deg2Rad;

            // Posição do caractere na circunferência
            Vector3 charPos = new Vector3(
                Mathf.Cos(angleRad) * radius,
                Mathf.Sin(angleRad) * radius,
                0f
            );

            // Rotação tangente ao círculo
            Quaternion charRot = Quaternion.Euler(0, 0, angleDeg - 90f * dir);

            // Aplica offset nos vértices
            int meshIndex = charInfo.materialReferenceIndex;
            int vertexIndex = charInfo.vertexIndex;
            Vector3[] verts = textInfo.meshInfo[meshIndex].vertices;

            // Centro original do char
            Vector3 charCenter = (verts[vertexIndex] + verts[vertexIndex + 2]) / 2f;

            for (int j = 0; j < 4; j++)
            {
                Vector3 orig = verts[vertexIndex + j] - charCenter;
                verts[vertexIndex + j] = charRot * orig + charPos;
            }
        }

        // Atualiza a mesh
        for (int i = 0; i < textInfo.meshInfo.Length; i++)
        {
            var meshInfo = textInfo.meshInfo[i];
            meshInfo.mesh.vertices = meshInfo.vertices;
            _tmp.UpdateGeometry(meshInfo.mesh, i);
        }
    }
}