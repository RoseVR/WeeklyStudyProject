Shader "Custom/Snow"
{
    Properties
    {
        _SnowColor("SnowColor",COLOR)=(1,1,1,1)
        _SnowTexture("SnowTexture",2D)="white"{}
        _TrackTextrue("TrackTexture",2D)="black"{}
        _GroundTexture("GroundTextrue",2D)="white"{}
        _GroundColor("GroundColor",COLOR)=(1,1,1,1)
        _Depth("Depth",Range(0,10))=3
        _Tess("Tessellation",Range(1,128))=5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //tessellate:tessDistance  ----！！！曲面细分
        #pragma surface surf Standard fullforwardshadows tessellate:tessDistance
        #pragma vertex vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 4.6
        #include "Tessellation.cginc"

        float4 _SnowColor;
        sampler2D _SnowTexture;
        sampler2D _TrackTextrue;
        sampler2D _GroundTexture;
        float4 _GroundColor;
        float _Depth;
        float _Tess;

        struct appdata{
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float3 tangent:TANGENT;
            float2 texcoord:TEXCOORD;
        };

        //进行曲面细分
        float4 tessDistance(appdata v0, appdata v1, appdata v2) {
            float minDist = 100.0;
            float maxDist = 250.0;
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
        }

        struct Input
        {
            float2 uv_SnowTexture;
            float2 uv_TrackTextrue;
            float2 uv_GroundTexture;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        //顶点偏移
        void vert(inout appdata v)
        {
            //获取积雪痕迹深度， 有红色的地方-=d 无红色的地方-=0  然后再统一加上雪的厚度
            float d=tex2Dlod(_TrackTextrue,float4(v.texcoord.xy,0,0)).r*_Depth;
            v.vertex.xyz -= v.normal * d;
            v.vertex.xyz += v.normal * _Depth;
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            //根据痕迹的r值来进行插值
            float amount=tex2Dlod(_TrackTextrue,fixed4(IN.uv_TrackTextrue,0,0)).r;
            fixed4 c =lerp(tex2D (_SnowTexture, IN.uv_SnowTexture) * _SnowColor,
            tex2D(_GroundTexture,IN.uv_GroundTexture)* _GroundColor,amount);
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
