Shader "Unlit/像素风"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Params("PixelNumPerRow (X) Ratio (Y)", Vector) = (80, 1, 1, 1.5)
    }
    SubShader
    {
        Cull Off
        ZWrite Off 
        ZTest Always

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
            half4 _Params;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            half4 PixelOperation(sampler2D tex,half2 uv, float scale, float ratio)
            {
                //计算每个像素块的尺寸
                half PixelSize = 1 / scale ;

                //取整计算每个像素块的坐标 ceil函数用于向上取整
                float coordX = PixelSize * ceil(uv.x /PixelSize) ;
                float coordY = (ratio * PixelSize)* ceil(uv.y / PixelSize / ratio);

                //组合像素块坐标
                half2 coord = float2(coordX,coordY);

                return half4(tex2D(tex,coord).xyzw);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = PixelOperation(_MainTex,i.uv,_Params.x,_Params.y);
                return col;
            }
            ENDCG
        }
    }
}
