Shader "Unlit/mySingleTexShader7_1"
{
    Properties
    {
        _Color("Color Tint",Color)=(1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;

            struct v2f{
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float2 uv:TEXCOORD2;
            };

            v2f vert(appdata_base a){
                v2f o;
                o.pos=UnityObjectToClipPos(a.vertex);
                o.worldNormal=UnityObjectToWorldNormal(a.normal);
                o.worldPos=mul(unity_ObjectToWorld,a.vertex);
                o.uv=a.texcoord*_MainTex_ST.xy+_MainTex_ST.zw;
                return o;
            }
            
            fixed4 frag(v2f o):SV_TARGET{
                fixed3 worldNormal=normalize(o.worldNormal);
                fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(o.worldPos));
                fixed3 albedo=tex2D(_MainTex,o.uv).rgb*_Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
                fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
                fixed3 viewDir=normalize(UnityWorldSpaceViewDir(o.worldPos));
                fixed3 halfDir=normalize(worldLightDir+viewDir);
                fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);
                return fixed4(ambient+diffuse+specular,1);
            }

            ENDCG
        }
    }
    Fallback "Specular"
}
