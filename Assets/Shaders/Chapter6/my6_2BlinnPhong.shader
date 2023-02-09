Shader "Unlit/my6_2BlinnPhong"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
        _SpecularColor("SpecularColor", Color) = (1,1,1,1)
        _Shininess("Shininess", Range(0, 100)) = 50
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _Shininess;
            
            struct v2f{
                float4 pos:SV_POSITION;
                float3 normal:TEXCOORD0;
                float4 vertex:TEXCOORD1;
            };
            v2f vert(appdata_base a){
                v2f o;
                o.pos=UnityObjectToClipPos(a.vertex);
                o.normal=UnityObjectToWorldNormal(a.normal);
                o.vertex=o.vertex;
                return o;
            }
            float4 frag(v2f o):SV_TARGET{
                float3 n=o.normal;
                float3 l=normalize(_WorldSpaceLightPos0.xyz);
                float3 ndotl=saturate(dot(n,l));
                float3 v=normalize(WorldSpaceViewDir(o.vertex));
                float3 h=normalize(l+v);
                float3 hdotn=saturate(dot(h,n));
                float3 diffuse=_LightColor0*_MainColor*ndotl;
                float3 spac=_LightColor0*_SpecularColor*pow(hdotn,_Shininess);
                float3 color=unity_AmbientSky+diffuse+spac;
                return float4(color,1);
            }
            ENDCG
        }
    }
    Fallback "diffuse"
}
