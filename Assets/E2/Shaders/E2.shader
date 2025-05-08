Shader "AA2/E2"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _Blend ("Blend", Range(0, 150)) = 10
        _Tile ("Tile", Float) = 0.75
        _ColorStone ("Color Stone", Color) = (0.588, 0.388, 0.325, 1)
        _Albedo ("Albedo", 2D) = "Stone_BaseMap" {}
        _Normal ("Normal", 2D) = "Stone_Normal" {}
        _NormalStrength ("Normal Strength", Float) = 1
        _Mask ("Mask", 2D) = "Stone_MaskMap" {}
        _SnowStart ("Snow Start", Range(-1, 1)) = -0.04
        _SnowSoftness ("Snow Softness", Range(0, 1)) = 0
        _SnowNormalScale ("Snow Normal Scale", Float) = 99.1
        _SnowColor ("Snow Color", Color) = (1, 1, 1, 1)
        _SnowNormalStrength ("Snow Normal Strength", Float) = 4.26
        _SnowMetallic ("Snow Metallic", Range(0, 1)) = 0
        _SnowSmoothness ("Snow Smoothness", Range(0, 1)) = 0.241
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir; 
            float4 screenPos;
            float3 worldPos;
            float3 worldNormal;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Blend;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here

        UNITY_INSTANCING_BUFFER_END(Props)

        //// FUNCTIONS ////
        float3 Triplanar(float3 worldNormal, float _blend)
        {
            // Obtener valor absoluto de la normal del mundo
            float3 blendWeights = abs(worldNormal);
            // Aplicar la potencia con el valor de _Blend
            blendWeights = pow(blendWeights, _blend);
            // Normalizar (dividir por la suma para obtener pesos relativos)
            blendWeights /= dot(blendWeights, float3(1,1,1));

            return blendWeights;
        }
        /// END FUNCTIONS ////

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            //o.Albedo = c.rgb;

            // Triplanar
            float3 triplanar = Triplanar(IN.worldNormal, _Blend);
            o.Albedo = triplanar;

            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
