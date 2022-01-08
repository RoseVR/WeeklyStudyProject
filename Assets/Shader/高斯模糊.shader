// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/高斯模糊"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        ZWrite Off
        Blend Off

        Pass{

            ZTest Always
            Cull Off
            //第一个通道，降采样通道
            CGPROGRAM

            #pragma vertex vert_DownSample
            #pragma fragment frag_DownSample

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            struct a2v{
                float4 vertex:POSITION;
                float2 texcoord:TEXCOORD;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                float2 uv20:TEXCOORD0;//一级纹理坐标 右上
                float2 uv21:TEXCOORD1;//二级纹理坐标 左下
                float2 uv22:TEXCOORD2;//三级纹理坐标 右下
                float2 uv23:TEXCOORD3;//四级纹理坐标 左上
            };

            

            v2f vert_DownSample(a2v v){
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                //图像降采样：取像素上下左右的点分别存在四级坐标中
                o.uv20=v.texcoord+_MainTex_TexelSize.xy*half2(0.5h,0.5h);
                o.uv21=v.texcoord+_MainTex_TexelSize.xy*half2(-0.5h,-0.5h);
                o.uv22=v.texcoord+_MainTex_TexelSize.xy*half2(0.5h,-0.5h);
                o.uv23=v.texcoord+_MainTex_TexelSize.xy*half2(-0.5h,0.5h);

                return o;
            }

            float4 frag_DownSample (v2f o):SV_TARGET0{
                fixed4 tempColor=(0,0,0,0);//定义临时颜色
                //四个像素点的纹理颜色相加
                tempColor+=tex2D(_MainTex,o.uv20);
                tempColor+=tex2D(_MainTex,o.uv21);
                tempColor+=tex2D(_MainTex,o.uv22);
                tempColor+=tex2D(_MainTex,o.uv23);

                //返回平均值
                return tempColor/4;
            }
            ENDCG
        }
        Pass{

            ZTest Always
            Cull Off
            //第二个通道，垂直方向模糊处理
            CGPROGRAM

            #pragma vertex vert_BlurVertical
            #pragma fragment frag_Blur

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            half _DownSampleValue;//C#中控制的变量

            struct a2v{
                float4 vertex:POSITION;
                float2 texcoord:TEXCOORD;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                half4 uv:TEXCOORD0;
                half2 offset : TEXCOORD1;
            };
            //高斯模糊权重矩阵 
            static const half4 GaussWeight[7]={
                float4(0.0205,0.0205,0.0205,0),
                float4(0.0855,0.0855,0.0855,0),
                float4(0.232,0.232,0.232,0),
                float4(0.324,0.324,0.324,1),
                float4(0.232,0.232,0.232,0),
                float4(0.0855,0.0855,0.0855,0),
                float4(0.0205,0.0205,0.0205,0),
            };
            v2f vert_BlurVertical(a2v v){
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);
                f.uv = half4(v.texcoord.xy,1,1);
                f.offset= _MainTex_TexelSize.xy*half2(1.0,0.0)*_DownSampleValue;//坐标偏移

                return f;
            }
            float4 frag_Blur(v2f f):SV_TARGET0{
                half2 uv = f.uv.xy;
                half OffsetWidth= f.offset;
                //从中心点偏移3各间隔，从最左或最上开始加权累加
                half2 uv_withOffset = uv- OffsetWidth *3.0;

                half4 color = 0;
                for(int j=0;j<7;j++){
                //偏移后的像素纹理值
                    half4 texCol = tex2D(_MainTex,uv_withOffset);
                    //偏移后的纹理像素值*高斯权重
                    color +=texCol *GaussWeight[j];
                    //移到下一个像素处进行下一次循环加权
                    uv_withOffset +=OffsetWidth;
                }
                return color;
            }
            ENDCG

        }
        Pass{

            ZTest Always
            Cull Off
            //第三个通道，水平模糊处理
            CGPROGRAM

            #pragma vertex vert_BlurHorizontle
            #pragma fragment frag_Blur
#include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            half _DownSampleValue;//C#中控制的变量

            struct a2v{
                float4 vertex:POSITION;
                float2 texcoord:TEXCOORD;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                half4 uv:TEXCOORD0;
                half2 offset : TEXCOORD1;
            };
            //高斯模糊权重矩阵 
            static const half4 GaussWeight[7]={
                float4(0.0205,0.0205,0.0205,0),
                float4(0.0855,0.0855,0.0855,0),
                float4(0.232,0.232,0.232,0),
                float4(0.324,0.324,0.324,1),
                float4(0.232,0.232,0.232,0),
                float4(0.0855,0.0855,0.0855,0),
                float4(0.0205,0.0205,0.0205,0),
            };
            v2f vert_BlurHorizontle(a2v v){
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);
                f.uv = half4(v.texcoord.xy,1,1);
                f.offset= _MainTex_TexelSize.xy*half2(0.0,1.0)*_DownSampleValue;//坐标偏移

                return f;
            }
            float4 frag_Blur(v2f f):SV_TARGET0{
                half2 uv = f.uv.xy;

                half OffsetWidth= f.offset;
                //从中心点偏移3各间隔，从最左或最上开始加权累加
                half2 uv_withOffset = uv- OffsetWidth *3.0;

                half4 color = 0;
                for(int j=0;j<7;j++){
                //偏移后的像素纹理值
                    half4 texCol = tex2D(_MainTex,uv_withOffset);
                    //偏移后的纹理像素值*高斯权重
                    color +=texCol *GaussWeight[j];
                    //移到下一个像素处进行下一次循环加权
                    uv_withOffset +=OffsetWidth;
                }
                return color;
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
}
