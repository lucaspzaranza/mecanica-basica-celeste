Shader "Custom/SphereClip" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture (optional)", 2D) = "white" {}
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

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            int _Sections;
            int _FlipX;
            int _FlipY;
            int _FlipZ;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 localPos : TEXCOORD1;
            };

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.localPos = v.vertex.xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 local = i.localPos;

                float signX = (_FlipX == 1) ? -1.0 : 1.0;
                float signY = (_FlipY == 1) ? -1.0 : 1.0;
                float signZ = (_FlipZ == 1) ? -1.0 : 1.0;

                if (_Sections >= 1) clip(local.y * signY);
                if (_Sections >= 2) clip(local.x * signX);
                if (_Sections >= 3) clip((local.y - local.x) * signZ);
                if (_Sections >= 4) {
                    float s = sin(radians(22.5));
                    float c = cos(radians(22.5));
                    clip((local.y * c - local.x * s) * signZ);
                }

                fixed4 texColor = tex2D(_MainTex, i.uv);
                return texColor * _Color;
            }
            ENDCG
        }
    }
}
