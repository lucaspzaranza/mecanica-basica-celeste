Shader "Custom/SphereClip" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _Sections ("Sections", Int) = 1
        _FlipX ("Flip X Clip", Int) = 0
        _FlipY ("Flip Y Clip", Int) = 0
        _FlipZ ("Flip Z Clip", Int) = 0
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade vertex:vert

        fixed4 _Color;
        int _Sections;
        int _FlipX;
        int _FlipY;
        int _FlipZ;

        struct Input {
            float3 localPos;
        };

        void vert(inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.localPos = v.vertex.xyz;
        }

        void surf(Input IN, inout SurfaceOutput o) {
            float3 local = IN.localPos;

            float signX = (_FlipX == 1) ? -1.0 : 1.0;
            float signY = (_FlipY == 1) ? -1.0 : 1.0;
            float signZ = (_FlipZ == 1) ? -1.0 : 1.0;

            if (_Sections >= 1) {
                clip(local.y * signY);
            }

            if (_Sections >= 2) {
                clip(local.x * signX);
            }

            if (_Sections >= 3) {
                clip((local.y - local.x) * signZ);
            }

            if (_Sections >= 4) {
                float s = sin(radians(22.5));
                float c = cos(radians(22.5));
                clip((local.y * c - local.x * s) * signZ);
            }

            o.Albedo = _Color.rgb;
            o.Alpha = _Color.a;
        }
        ENDCG
    }
}
