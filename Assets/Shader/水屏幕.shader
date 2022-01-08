Shader "Unlit/水屏幕"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScreenWarterTex("水贴图",2D)="white"{}
        _CurTime("当前时间",Range(0,1))=0
        _XSize("XSize",Range(0,1))=1
        _YSize("YSize",Range(0,1))=1
        _DropSpeed("水流速度",Range(0,1))=1
        _Distortion("溶解度",Range(0,1))=1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            // make fog work
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _ScreenWarterTex;
            float4 _MainTex_ST;
            float4 _ScreenWarterTex_ST;
            float2 _MainTex_TexelSize;
            float2 _ScreenWarterTex_TexelSize;
            float _CurTime;
            float _XSize;
            float _YSize;
            float _DropSpeed;
            float _Distortion;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //获取顶点坐标值
                float2 uv = i.texcoord.xy;

                //解决平台差异 校正方向 若和规定方向相反则速度反向+1
                #if UNITY_UV_STARTS_AT_TOP
                if(_MainTex_TexelSize.y<0)
                    _DropSpeed=1-_DropSpeed;
                #endif

                //设置三层水流效果 按一定规律在水滴纹理上分别取样
                float3 rainTex1 = tex2D(_ScreenWarterTex,float2(uv.x*_XSize*1.15,(uv.y*_YSize*1.1)+_CurTime*_DropSpeed*0.15)).rgb/_Distortion;
                float3 rainTex2 = tex2D(_ScreenWarterTex,float2(uv.x*_XSize*1.25-0.1,(uv.y*_YSize*1.2)+_CurTime*_DropSpeed*0.2)).rgb/_Distortion;
                float3 rainTex3 = tex2D(_ScreenWarterTex,float2(uv.x*_XSize*0.9,(uv.y*_YSize*1.25)+_CurTime*_DropSpeed*0.032)).rgb/_Distortion;
                
                //整合三层水流效果的颜色信息存于finalRainTex中
                float2 finalRainTex = uv.xy -(rainTex1.xy-rainTex2.xy-rainTex3.xy)/3;

                //按照finalRainTex的坐标信息在主纹理上采样
                float3 finalColor = tex2D(_MainTex,finalRainTex).rgb;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}
