Shader "Unlit/EarthShader"
{
    Properties
    {
        _EarthTex("EarthTex",2D)="white"{}
        _CloudTex("CloudTex",2D)="white"{}

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

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
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _EarthTex;
            float4 _EarthTex_ST;
            sampler2D _CloudTex;
            float4 _CloudTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _EarthTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _CloudTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float earthUVX = i.uv.x + 0.1 * _Time ;
                float2 earthUV = float2(earthUVX,i.uv.y);
                float cloudUVX = i.uv.z + 0.2 * _Time ; 
                float2 cloudUV = float2(cloudUVX,i.uv.w);

                fixed4 colorEarth = tex2D(_EarthTex,earthUV);
                fixed4 colorCloud = fixed4(1,1,1,0) * tex2D(_CloudTex,cloudUV).x;
                fixed4 finalColor = lerp(colorEarth,colorCloud,0.5);
                return finalColor;
            }
            ENDCG
        }
    }
}
