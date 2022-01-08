// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/高光漫反射"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 200

        Pass{
        Tags{ "LightMode"="ForwardBase"}
        CGPROGRAM
        #pragma vertex vert 
        #pragma fragment frag 
        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        float4 _Color;
        float _Glossiness;

        struct a2v{
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float2 texcoord:TEXCOORD;
        };

        struct v2f{
            float4 pos : SV_POSITION;
            float4 worldPos:TEXCOORD1;
            float3 worldNormal : TEXCOORD0 ;
            float2 uv:TEXCOORD2;
        };

        v2f vert(a2v v){
            v2f f;
            f.pos = UnityObjectToClipPos(v.vertex);//这句必须写，把模型转换到裁剪坐标，不然shader显示不出来
            f.worldPos = mul(unity_WorldToObject,v.vertex);
            f.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
            f.uv=TRANSFORM_TEX(v.texcoord.xy,_MainTex);

            return f;
        }

        float4 frag(v2f f): SV_Target{
            
            float3 uvColor = tex2D(_MainTex,f.uv).rgb*_Color.rgb;
            float3 normalDir = normalize(f.worldNormal);
            float3 lightiDir = normalize(_WorldSpaceLightPos0.xyz);
            float3 viewDir = normalize(_WorldSpaceCameraPos-f.worldPos);
            //也可以这么写 ： float3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldPos));
            float3 halfDir = normalize(lightiDir+viewDir);
            //Phong或者Blinn Phong模型
            fixed3 specular = _LightColor0.rgb * pow(max(0,dot(normalDir,halfDir)),_Glossiness);
            float4 diffuse =float4(_LightColor0.rgb * uvColor.rgb,1) + UNITY_LIGHTMODEL_AMBIENT;
            return diffuse+float4(specular,1);
        }
        ENDCG
        }
    }
    FallBack "Diffuse"
}
