Shader "Unlit/B1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Normal("Normal",2D) = "bump"{}
		_D("D",Range(0,5)) = 1
	    _U("U",Range(0,1))=0
		_V("V",Range(0,1))=0
    }
    SubShader
    {
		
        Tags { "RenderType"="Opaque" "Queue"="Transparent"}
        LOD 100
        GrabPass{}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
               
                float4 vertex : SV_POSITION;
				float4 grabPos:TEXCOORD1;
            };

            sampler2D _MainTex;
			sampler2D _GrabTexture;
            float4 _MainTex_ST;
			sampler2D _Normal;
			float _D;
			float _U;
			float _V;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
			float3 normal = UnpackNormal(tex2D(_Normal, i.uv));
				i.grabPos.xy += normal.rg*_D;
			   fixed4 grabColor = tex2Dproj(_GrabTexture, i.grabPos);

                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col* grabColor;
            }
            ENDCG
        }
    }
}
