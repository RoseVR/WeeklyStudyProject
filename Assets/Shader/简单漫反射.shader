// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/简单漫反射"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Tags{ "LightingMode" = "ForwardBase" }

        LOD 200

        Pass{
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma vertex vert 
        #pragma fragment frag 

        #include "Lighting.cginc"
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;

        struct a2v
        {
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float2 texcoord:TEXCOORD0;
        };

        struct v2f
        {
            float4 pos:SV_POSITION;
            float3 worldNormal:TEXCOORD0;
            float3 worldPos:TEXCOORD1;
            float2 uv:TEXCOORD2;
        };
        
        v2f vert(a2v v)
        {
            v2f f;
            f.pos = UnityObjectToClipPos(v.vertex);
            f.worldNormal = UnityObjectToWorldNormal(v.normal);
            f.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
            f.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

            return f;
        }
        float4 frag(v2f f):SV_TARGET0
        {
            float3 color=tex2D(_MainTex,f.uv).rgb*_Color.rgb;
            float3 normalDir=normalize(f.worldNormal);
            float3 lightDirection = normalize(UnityWorldSpaceLightDir(f.worldPos));
            float3 diffuse=_LightColor0.rgb*color*max(0,dot(normalDir,lightDirection));
            float4 finalColor=(float4(diffuse,1)+ UNITY_LIGHTMODEL_AMBIENT)*float4(color,1);
            return finalColor;
        }
        ENDCG
        }
        
    }
    FallBack "Diffuse"
}
