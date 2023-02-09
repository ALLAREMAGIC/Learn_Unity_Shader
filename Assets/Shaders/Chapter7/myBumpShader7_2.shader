Shader "Unlit/myBumpShader7_2"
{
    Properties
    {
        _Color("Color",color)=(1,1,1,1)
        _MainTex("Main Tex",2d)="white"{}
        _BumpMap("Normal Map",2d)="bump"{}
        _BumpScale("Bump Scale",float)=1
        _Specular("Specular",color)=(1,1,1,1)
        _Gloss("Gloss",range(8.0,256))=20
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;

            //TangentSpace

            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
                float4 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float4 uv:TEXCOORD0;
                float3 lightDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);

                o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv.zw=v.texcoord.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;

                // float3 binormal=cross(normalize(v.normal),normalize(v.tangent.xyz))*v.tangent.w;
                // float3x3 rotation=float3x3(v.tangent.xyz,binormal,v.normal);
                TANGENT_SPACE_ROTATION;

                o.lightDir=mul(rotation,normalize(ObjSpaceLightDir(v.vertex))).xyz;
                o.viewDir=mul(rotation,normalize(ObjSpaceViewDir(v.vertex))).xyz;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                fixed3 tangentLightDir=normalize(i.lightDir);
                fixed3 tangentViewDir=normalize(i.viewDir);

                fixed4 packedNormal=tex2D(_BumpMap,i.uv.zw);
                fixed3 tangentNormal=UnpackNormal(packedNormal);
                tangentNormal.xy*=_BumpScale;
                tangentNormal.z=sqrt(1-saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                fixed3 albedo=tex2D(_MainTex,i.uv.xy).rgb*_Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
                fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));
                fixed3 halfDir=normalize(tangentLightDir+tangentViewDir);
                fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);
                return fixed4(ambient+diffuse+specular,1);
            }

            // //WorldSpace
            //
            // struct v2f
            // {
            //     float4 pos:SV_POSITION;
            //     float4 uv:TEXCOORD0;
            //     float4 TtoW0:TEXCOORD1;
            //     float4 TtoW1:TEXCOORD2;
            //     float4 TtoW2:TEXCOORD3;
            // };
            //
            // v2f vert(a2v v)
            // {
            //     v2f o;
            //     o.pos=UnityObjectToClipPos(v.vertex);
            //     o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
            //     o.uv.zw=v.texcoord.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;
            //
            //     float3 worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
            //     float3 worldNormal=UnityObjectToWorldNormal(v.normal);
            //     float3 worldTangent=UnityObjectToWorldDir(v.tangent.xyz);
            //     float3 worldBinormal=cross(worldNormal,worldTangent)*v.tangent.w;
            //
            //     o.TtoW0=float4(worldTangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
            //     o.TtoW1=float4(worldTangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
            //     o.TtoW2=float4(worldTangent.z,worldBinormal.z,worldNormal.z,worldPos.z);
            //
            //     return o;
            // }
            //
            // fixed4 frag(v2f i):SV_Target
            // {
            //     float3 worldPos=float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
            //     fixed3 lightDir=normalize(UnityWorldSpaceLightDir(worldPos));
            //     fixed3 viewDir=normalize(UnityWorldSpaceViewDir(worldPos));
            //
            //     fixed3 bump=UnpackNormal(tex2D(_BumpMap,i.uv.zw));
            //     bump.xy*=_BumpScale;
            //     bump.z =sqrt(1-dot(bump.xy,bump.xy));
            //
            //     bump=normalize(half3(dot(i.TtoW0.xyz,bump),dot(i.TtoW1.xyz,bump),dot(i.TtoW2.xyz,bump)));
            //
            //     fixed3 albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
            //     fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
            //     fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(bump,lightDir));
            //
            //     fixed3 halfDir=normalize(lightDir+viewDir);
            //     fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(bump,halfDir)),_Gloss);
            //
            //     return fixed4(ambient+diffuse+specular,1);
            // }
            
            ENDCG
        }
    }
    FallBack"Specular"
}
