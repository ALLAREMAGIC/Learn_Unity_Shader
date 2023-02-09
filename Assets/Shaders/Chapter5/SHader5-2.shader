// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/Shader5-2"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
	}
	SubShader
	{ 
	Pass{
		CGPROGRAM

		#include "UnityCG.cginc"

		#pragma vertex vert
		#pragma fragment frag

		uniform fixed4 _Color;

		struct a2v{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 texcoord : TEXCOORD0;
		};

		struct v2f{
		float4 pos:SV_POSITION;
		float3 color:COLOR0;
		};

		//float4 vert(a2v v):SV_POSITION
		//{
		//return UnityObjectToClipPos (v.vertex);
		//}

		v2f vert(a2v v){
		v2f o;
		o.pos=UnityObjectToClipPos(v.vertex);
		o.color=v.normal*0.5+fixed3(0.5,0.5,0.5);
		return o;
		}

		fixed4 frag(v2f i):SV_Target
		{
		float3 c=i.color;
		c*=_Color.rgb;
		return fixed4(c,1.0);
		}

		ENDCG
}
}
FallBack "Diffuse"
}