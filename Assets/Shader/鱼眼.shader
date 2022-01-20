Shader "Unlit/鱼眼"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Environment ("Environment", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;//存储计算后的uv坐标放在第二套纹理中
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Environment;
            float4 _Environment_ST;

            //通过切线计算UV坐标
            float2 R_To_UV(float3 R)
            {
                float interim = 2 * sqrt(R.x * R.x + R.y * R.y + (R.z+1) * (R.z +1));
                return float2 (R.x/interim + 0.5, R.y/interim +0.5);
            }
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //入射光线
                float3 lightDir =normalize (_WorldSpaceLightPos0.xyz);
                //法线
                float3 normalDir =normalize( mul(v.normal, (float3x3)unity_WorldToObject));
                //反射方向
                float3 refectDir = reflect(lightDir,normalDir);
                o.uv2 = R_To_UV(refectDir);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 reflectCol = tex2D(_Environment,i.uv2);
                fixed4 baseCol = tex2D(_MainTex, i.uv2);
                
                //fixed4 col = lerp(baseCol,reflectCol,0.5);
                return baseCol;
            }
            ENDCG
        }
    }
}
