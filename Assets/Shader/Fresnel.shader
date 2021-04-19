// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Fresnel"
{
	Properties{
	   _MainTex("Base (RGB)", 2D) = "white" {}
	   _AlphaTex("Base (RGB)", 2D) = "white" {}
	   _RandomTex("Base (RGB)", 2D) = "white" {}
	   _RimColor("Rim Color", Color) = (1, 0, 0, 1)
	   _Color("_Color", Color) = (0.5,0.5,0.5,1)
	   _Rampage("_Rampage", Float) = 0
	   _Frezz("_Frezz", Range(0, 1)) = 0
	}

		SubShader{
		   //Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"} 
			  Pass {
				  cull off
				  Blend SrcAlpha OneMinusSrcAlpha
				  CGPROGRAM
		   // Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members pos1) 
		 //  #pragma exclude_renderers d3d11 xbox360 
						   #pragma vertex vert 
						   #pragma fragment frag 
						   #include "UnityCG.cginc" 

						   struct appdata {
							   float4 vertex : POSITION;
							   float3 normal : NORMAL;
							   float2 texcoord : TEXCOORD0;
						   };

						   struct v2f {
							   half4 pos : SV_POSITION;
							   half2 uv : TEXCOORD0;
							   fixed3 color : COLOR;
						   };

						   uniform fixed4 _RimColor;
						   uniform fixed _Rampage;
						   uniform fixed _Frezz;

						   v2f vert(appdata_base v) {
							   v2f o;
							   o.pos = UnityObjectToClipPos(v.vertex);
							   if (_Rampage == 1)
							   {
								   fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
								   fixed dotProduct = 1 - dot(v.normal, viewDir);
									   o.color = smoothstep(0, 1, dotProduct);
								   o.color *= _RimColor;
							   }
							   float3 normal = mul(SCALED_NORMAL, (float3x3)unity_WorldToObject);
							   fixed dotProduct = dot(normal, fixed3(0, 1, 0)) / 2;
							   if (dotProduct <= 0)
							   {
								   dotProduct = 0;
							   }
							   o.color += dotProduct.xxx;
							   o.uv = v.texcoord.xy;
							   return o;
						   }

						   uniform sampler2D _MainTex;
						   uniform sampler2D _AlphaTex;
						   uniform sampler2D _RandomTex;
						   uniform fixed4 _Color;
						   fixed4 frag(v2f i) : COLOR {
							   fixed4 texcol = tex2D(_MainTex, i.uv);
							   fixed4 alpha = tex2D(_AlphaTex, i.uv);
							   float ClipTex = tex2D(_RandomTex, i.uv).r;
							   float ClipAmount = (_Frezz - ClipTex) / 2 + 0.5;
							   if (ClipAmount < 0)
							   {
								   ClipAmount = 0;
							   }
							   if (ClipAmount > 1)
							   {
								   ClipAmount = 1;
							   }
							   if (_Rampage == 1)
							   {
								   texcol.rgb += i.color;
							   }
							   texcol = texcol * ClipAmount + alpha * (1 - ClipAmount);
							   texcol.a = alpha.a;
							   clip(texcol.a - 0.5);
							   texcol *= _Color;
							   return texcol;
						   }
					   ENDCG
				   }

	   }
}