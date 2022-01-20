Shader "Unlit/椭圆旋转"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Length("椭圆长轴",Range(0,5))=5
        _Width("椭圆短轴",Range(0,3))=2
        _Speed("Speed",Range(0,10))=3
    }
    SubShader
    {
        Tags {"Queue"="Transparent"}
        Blend SrcAlpha  OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Length;
            float _Width;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float2 UV_Rotate(float2 uv,float center, float rad)
            {
                uv -= center;
                float2x2 ma;
                ma[0] = float2(cos(rad),sin(rad));
                ma[1] = float2(-sin(rad),cos(rad));

                return mul(ma,uv)+center;
            }

            float2 UV_RotateAround(float2 uv, float center, float length, float width, float rad)
            {
                uv -= center;
                uv *= float2(length,width);

                float2x2 ma;
                ma[0] = float2(cos(rad),sin(rad));
                ma[1] = float2(-sin(rad),cos(rad));

                return mul(ma,uv)+center;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = UV_Rotate(i.uv,float2(0.5,0.5),0.5);
                uv = UV_RotateAround(uv,float2(0.5,0.5),_Length,_Width,_Speed*_Time.y);
                // sample the texture
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
