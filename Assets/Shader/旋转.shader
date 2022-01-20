Shader "Unlit/旋转"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed("Speed",Range(0,2))=1
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
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float2 UV_Rotate(float2 uv,float2 rotateOffset,float rad)
            {
                //先将UV平移到旋转中心 这里设置为0.5 0.5
                float2 UV_Move = uv - rotateOffset;

                float2x2 ma;
                ma[0] = float2(cos(rad),sin(rad));
                ma[1] = float2(-sin(rad),cos(rad));
                //先旋转 在平移回来
                return float2(mul(ma,UV_Move))+rotateOffset;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = UV_Rotate(i.uv,float2(0.5,0.5),-_Speed*_Time.y);

                // sample the texture
                fixed4 col = tex2D(_MainTex, uv);

                return col;
            }
            ENDCG
        }
    }
}
