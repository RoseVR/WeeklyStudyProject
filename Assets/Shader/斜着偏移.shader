Shader "Unlit/斜着偏移"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rad("Rad",Range(0,180))=0
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
            float _Rad;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float2 UV_Rotate(float2 uv,float rad)
            {
                float2x2 matrixRotate;
                matrixRotate[0] = float2(cos(rad),sin(rad));
                matrixRotate[1] = float2(-sin(rad),cos(rad));
                
                return float2(mul(matrixRotate,uv));
            }
            fixed4 frag (v2f i) : SV_Target
            {
                //移动方向
                float2 dir = float2(0,-_Time.y);// 在贴图中移动和旋转 的方向都是和实际运动方向去反的方向， 故每部分的的操作都需要进行一次取反
                //移动向量旋转
                dir = UV_Rotate(dir,_Rad);
                float2 uv = i.uv;
                uv += _Speed * dir;
                //uv旋转
                uv = UV_Rotate(uv,-_Rad);
                fixed4 col = tex2D(_MainTex,uv);
                return col;
            }
            ENDCG
        }
    }
}
