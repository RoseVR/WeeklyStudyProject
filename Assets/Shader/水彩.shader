Shader "Unlit/水彩"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Distortion("Distortion",Range(0.0,1.0))=0.3
        _ScreenResolution("_ScreenResolution", Vector) = (0.0, 0.0, 0.0, 0.0)
        _ResolutionValue("ResolutionValue",Range(0.0,5.0))=2.0
        _Radius("Radius",Range(0.0,5.0))=2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            ZTest Always

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma target 3.0
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Distortion;
            Vector _ScreenResolution;
            float _ResolutionValue;
            float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            //根据设置的分辨率比值计算图像的尺寸
                float2 src_size = float2(_ResolutionValue / _ScreenResolution.x, _ResolutionValue / _ScreenResolution.y);
                
                //获取坐标值
                float2 uv = i.uv.xy;

                //根据半径计算n的值
                float n = float((_Radius+1)*(_Radius+1));

                //定义一些参数
                float3 m0 = 0.0;
                float3 m1 = 0.0;
                float3 s0 = 0.0;
                float3 s1 = 0.0;
                float3 c;

                //按radius的值迭代计算m0和s0
                for(int j=-_Radius;j<=0;++j){
                    for(int i=-_Radius;i<=0;++i){
                        c=tex2D(_MainTex,uv+float2(i,j)*src_size).rgb;
                        m0+=c;
                        s0+=c*c;
                    }
                }
                //按radius的值迭代计算m1和s1
                for(int j=0;j<=_Radius;++j){
                    for(int i=0;i<=_Radius;++i){
                        c=tex2D(_MainTex,uv+float2(i,j)*src_size).rgb;
                        m1+=c;
                        s1+=c*c;
                    }
                }

                //定义参数准备计算最终颜色值
                float4 finalFragColor = 0.;
                float min_sigma2 = 1e+2;//==1*(10^2)

                //根据m0和s0 第一次计算finalFragColor
                m0/=n;
                s0=abs(s0/n-m0*m0);

                float sigma2 = s0.r+s0.g + s0.b;
                if(sigma2<min_sigma2){
                    min_sigma2=sigma2;
                    finalFragColor = float4(m0,1.0);
                }

                //根据m1和s1 第二次计算finalFragColor
                 m1/=n;
                s1=abs(s1/n-m1*m1);

                sigma2 = s1.r+s1.g + s1.b;
                if(sigma2<min_sigma2){
                    min_sigma2=sigma2;
                    finalFragColor = float4(m1,1.0);
                }

                //返回最终的颜色值
                return finalFragColor;
            }
            ENDCG
        }
    }
}
