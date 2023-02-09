Shader "Unlit/my6_2LambertShader"
{
    // Properties
    // {
    //     _MainColor ("MainColor", Color) = (1,1,1,1)
    // }
    SubShader
    {
        Pass{
            //CG代码开始标识
            CGPROGRAM

            //定义顶点着色器和片元着色器的名称
            #pragma vertex vert
            #pragma fragment frag

            //引用包含文件
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            //获取并存储Unity给我们的各种信息
            struct appdata
            {
                //博主在这里用的是UntiyCG.cginc中自带的appdata_base，这是Unity在包含文件中给我们提供的，还有其他结构体，请自查，此处不再赘述。
                //我将UnityCG.cginc中提供的appdata_base信息结构在此appdata结构体列出
                float4 vertex:POSITION;
                float3 normal: NORMAL;
                float4 texcoord:TEXCOORD0;
            };
            //存储顶点着色器到片元着色器的各种信息
            struct v2f {
                float4 pos:SV_POSITION;
                fixed3 normal:NORMAL;
            };

            //顶点着色器
            v2f vert(appdata_base a){
                v2f v;
                v.pos=UnityObjectToClipPos(a.vertex);
                v.normal=UnityObjectToWorldNormal(a.normal);
                return v;
            }

            //片元着色器
            fixed3 frag(v2f v):SV_Target{
                fixed3 l=normalize(_WorldSpaceLightPos0);
                fixed3 color=_LightColor0*saturate(dot(v.normal,l));
                return color;
            }

            //CG代码结束标识
            ENDCG
        }

    }
    //若上述所有subshader不适用则调用fallBack所指向的默认shader
    FallBack"Diffuse"
}
