Shader "Unlit/车漆"
{
    Properties
    {
        _MainColor("主颜色",COLOR)=(1,1,1,1)
        _DetailColor("细节颜色",COLOR)=(1,1,1,1)
        _DetailTex("细节贴图",2D)="white"{}
        _DetailDepthOffset("细节纹理深度偏移",float)=1.0
        _DiffuseColor("漫反射颜色",COLOR)=(1,1,1,1)
        _DiffuseTex("漫反射贴图",2D)="white"{}
        _MatCap("车漆贴图",2D)="white"{}
        _ReflectColor("反射颜色",COLOR)=(1,1,1,1)
        _ReflectTex("反射贴图",CUBE)=""{}
        _ReflectStrenth("反射强度",Range(0,1))=0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
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
                float3 normal : NORMAL;
                float2 UVCoordsChannel1: TEXCOORD0;
            };

            struct v2f
            {
                float3 detailUVCoordsAndDepth : TEXCOORD0;
				float4 diffuseUVAndMatCapCoords : TEXCOORD1;
				float4 position : SV_POSITION;
				float3 worldSpaceReflectionVector : TEXCOORD2;
            };

            float4 _MainColor;
            float4 _DetailColor;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _DetailDepthOffset;
            float4 _DiffuseColor;
            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;
            sampler2D _MatCap;
            float4 _ReflectColor;
            samplerCUBE _ReflectTex;
            float _ReflectStrenth;

            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                
                //漫反射UV坐标，存在TEXCOORD1的xy里
                o.diffuseUVAndMatCapCoords.xy = TRANSFORM_TEX(v.UVCoordsChannel1,_DiffuseTex);
                //matcap坐标准备，将法线从模型空间切换到裁剪空间中
                o.diffuseUVAndMatCapCoords.z = dot(normalize(UNITY_MATRIX_IT_MV[0].xyz),normalize(v.normal));
                o.diffuseUVAndMatCapCoords.w = dot(normalize(UNITY_MATRIX_IT_MV[1].xyz),normalize(v.normal));
                //归一化，法线原值范围在[-1,1],将其转换为[0,1]
                o.diffuseUVAndMatCapCoords.zw = o.diffuseUVAndMatCapCoords.zw * 0.5 + 0.5;

                //细节纹理准备，存储在前两个里
                o.detailUVCoordsAndDepth.xy = TRANSFORM_TEX(v.UVCoordsChannel1,_DetailTex);
                //深度信息存储在第三个坐标中
                o.detailUVCoordsAndDepth.z = o.position.z;

                float3 worldPosition = mul(unity_ObjectToWorld,v.vertex).xyz;
                float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld,v.normal));

                //世界空间反射向量
                o.worldSpaceReflectionVector = reflect(worldPosition - _WorldSpaceCameraPos.xyz , worldNormal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //镜面反射的颜色  
                float3 reflectionColor = texCUBE(_ReflectTex, i.worldSpaceReflectionVector).rgb * _ReflectColor.rgb;
                //漫反射颜色
                float4 diffuseColor = tex2D(_DiffuseTex,i.diffuseUVAndMatCapCoords.xy) * _DiffuseColor;
                //主颜色
                float3 mainColor = lerp(lerp(_MainColor.rgb,diffuseColor.rgb,diffuseColor.a),reflectionColor,_ReflectStrenth);
                //细节纹理颜色
                float3 detailMask = tex2D(_DetailTex,i.detailUVCoordsAndDepth.xy).rgb;
                float3 detailColor = lerp(_DetailColor.rgb,mainColor,detailMask);

                //细节颜色与主颜色插值成为新的主颜色
                mainColor = lerp(detailColor,mainColor,saturate(i.detailUVCoordsAndDepth.z * _DetailDepthOffset));

                float3 matColor = tex2D(_MatCap,i.diffuseUVAndMatCapCoords.zw).rgb;
                float4 col = float4(mainColor * matColor * 2.0,_MainColor.a);

                return col;
            }
            ENDCG
        }
    }
    FallBack "VertexLit"
}
