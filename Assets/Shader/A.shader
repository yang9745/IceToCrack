Shader "Custom/A"
{
	Properties{
	_Color("Main Color", Color) = (1,1,1,1)
	_MainTex("BaseTex", 2D) = "white" {}
	_BumpMap("Normalmap", 2D) = "bump" {}
	_BumpAmt("Distortion", range(0,1)) = 0.12
	}

		SubShader{
			Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
			 ZWrite off
			 Lighting off

			GrabPass {
					Name "BASE"
					Tags { "LightMode" = "Always" }
				}

		CGPROGRAM
		#pragma surface surf Lambert nolightmap nodirlightmap
		#pragma target 3.0
		#pragma debug

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _GrabTexture;
		float _BumpAmt;



		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float4 screenPos;
		};


		void surf(Input IN, inout SurfaceOutput o) {
			fixed3 nor = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			fixed4 col = tex2D(_MainTex,IN.uv_MainTex);
			float4 screenUV2 = IN.screenPos;
			screenUV2.xy = screenUV2.xy / screenUV2.w;
			screenUV2.xy += nor.xy * _BumpAmt;

			fixed4 trans = tex2D(_GrabTexture,screenUV2.xy)*_Color;
			trans *= col;
			o.Albedo = trans.rgb;
			o.Emission = trans.rgb;
		;
		}
		ENDCG
	}

		FallBack "Transparent/VertexLit"
}



//    Properties
//    {
//        _Color ("Color", Color) = (1,1,1,1)
//        _MainTex ("Albedo (RGB)", 2D) = "white" {}
//        _Glossiness ("Smoothness", Range(0,1)) = 0.5
//        _Metallic ("Metallic", Range(0,1)) = 0.0
//    }
//    SubShader
//    {
//        Tags { "RenderType"="Opaque" }
//        LOD 200
//
//        CGPROGRAM
//        // Physically based Standard lighting model, and enable shadows on all light types
//        #pragma surface surf Standard fullforwardshadows
//
//        // Use shader model 3.0 target, to get nicer looking lighting
//        #pragma target 3.0
//
//        sampler2D _MainTex;
//
//        struct Input
//        {
//            float2 uv_MainTex;
//        };
//
//        half _Glossiness;
//        half _Metallic;
//        fixed4 _Color;
//
//        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
//        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
//        // #pragma instancing_options assumeuniformscaling
//        UNITY_INSTANCING_BUFFER_START(Props)
//            // put more per-instance properties here
//        UNITY_INSTANCING_BUFFER_END(Props)
//
//        void surf (Input IN, inout SurfaceOutputStandard o)
//        {
//            // Albedo comes from a texture tinted by color
//            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
//            o.Albedo = c.rgb;
//            // Metallic and smoothness come from slider variables
//            o.Metallic = _Metallic;
//            o.Smoothness = _Glossiness;
//            o.Alpha = c.a;
//        }
//        ENDCG
//    }
//    FallBack "Diffuse"
//}
