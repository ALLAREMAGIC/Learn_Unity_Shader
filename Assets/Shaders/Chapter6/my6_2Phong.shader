Shader "Unlit/my6_2Phong"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
        _SpecularColor("SpecularColor", Color) = (1,1,1,1)
        _Shininess("Shininess", Range(0, 100)) = 50
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _Shininess;

            // //逐顶点光照
            // struct v2f{
                //     float4 pos:SV_POSITION;
                //     fixed3 color:COLOR0;
            // };
            // v2f vert(appdata_base a){
                //     v2f o;
                //     o.pos = UnityObjectToClipPos(a.vertex);
                //     float3 l=normalize(_WorldSpaceLightPos0.xyz);
                //     float3 n=UnityObjectToWorldNormal(a.normal);
                //     float3 v=normalize(WorldSpaceViewDir(a.vertex));
                //     float3 r=normalize(reflect(-l,n));
                //     float3 ldotn=saturate(dot(l,n));
                //     float3 rdotv=saturate(dot(r,v));
                
                //     float3 diffuse=saturate(ldotn);
                //     float3 spec=pow(rdotv,_Shininess);

                //     o.color=unity_AmbientSky+_LightColor0*(_MainColor*diffuse+_SpecularColor*spec);
                //     return o;
            // }

            // fixed4 frag(v2f o):SV_TARGET{
                //     return fixed4(o.color,1);
            // }

            //逐像素光照
            struct v2f{
                float4 pos:SV_POSITION;
                float3 normal:TEXCOORD0;
                float4 vertex:TEXCOORD1;
            };
            v2f vert(appdata_base a){
                v2f o;
                o.pos=UnityObjectToClipPos(a.vertex);
                o.normal=UnityObjectToWorldNormal(a.normal);
                o.vertex=a.vertex;
                return o;
            }
            float4 frag(v2f o):SV_TARGET{
                float3 l=normalize(_WorldSpaceLightPos0.xyz);
                float3 ndotl=saturate(dot(o.normal,l));
                float3 r=reflect(-l,o.normal);
                float3 v=normalize(WorldSpaceViewDir(o.vertex));
                float3 rdotv=saturate(dot(r,v));
                float3 diffuse=_LightColor0*_MainColor*ndotl;
                float3 spec=_LightColor0*_SpecularColor*pow(rdotv,_Shininess);
                return float4(diffuse+spec+unity_AmbientSky,1);
            }

            ENDCG
        }
    }
    Fallback "diffuse"
}
