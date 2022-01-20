Shader "Unlit/LoGoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Angle("Angle",Range(50,75)) = 75
        _LoopTime("LoopTime",Range(0,1))=0.8
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha 
      AlphaTest Greater 0.1

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
            float _Angle;
            float _LoopTime;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            //计算闪光的亮度值 需要输入uv、角度、闪光宽度、间隔、偏移、循环时间、开始时间
            float BrightnessCount(float2 uv,float angle,float xLength,float Interval,float offsetX,float loopTime, float beginTime)
            {
                float brightness = 0;

                //倾斜角
                float angleInRad = 0.0174444 * angle;
                //当前时间
                float currentTime = _Time.y;
                //当前起始时间
                int currentTimeInt = _Time.y/Interval;
                currentTimeInt *= Interval;

                float currentPassTime = currentTime - currentTimeInt;
                if(currentPassTime > beginTime)
                {
                    float x0 = currentPassTime-beginTime;
                    x0 /= loopTime;
                    float xLeftBottomEdge;//左边底部边界点
                    float xRightiBottomEdge;//右边底部边界点
                    xRightiBottomEdge = x0;
                    xLeftBottomEdge = x0 - xLength;

                    float proL;
                    proL = (uv.y)/tan(angleInRad);
                    float xLeftEdge;//左边边界点
                    xLeftEdge = xLeftBottomEdge - proL;
                    xLeftEdge += offsetX;
                    float xRightEdge;//右边边界点
                    xRightEdge = xRightiBottomEdge - proL;
                    xRightEdge += offsetX;
                    
                    if(uv.x>xLeftEdge&&uv.x<xRightEdge)
                    {
                        float centerX = (xRightEdge + xLeftEdge)/2;
                        float rate = (xLength-2*abs(uv.x-centerX))/xLength;
                        brightness = rate;
                    }
                }

                brightness = max(brightness,0);
                return brightness;
            }
            float4 frag (v2f i) : COLOR
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                float Brightness= BrightnessCount(i.uv,_Angle,0.5,5,0.15,_LoopTime,2);
                if(col.w>0.5)
                {
                    col =col + float4(1,1,1,1) * Brightness;
                }
                else
                {
                    col = float4(0,0,0,0);
                }
                return col;
            }
            ENDCG
        }
    }
}
