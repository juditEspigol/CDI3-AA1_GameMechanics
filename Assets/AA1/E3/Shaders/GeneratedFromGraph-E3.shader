Shader "Shader Graphs/E3-Compiled"
{
    Properties
    {
        [KeywordEnum(Disabled, Triplanar, Snow)]_DEBUG("Debug", Float) = 0
        _Blend("_Blend", Range(0, 150)) = 1
        _Tile("_Tile", Float) = 1
        _Color("_Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]_Albedo("_Albedo", 2D) = "white" {}
        [Normal][NoScaleOffset]_Normal("_Normal", 2D) = "bump" {}
        _NormalStrength("_NormalStrength", Float) = 1
        [NoScaleOffset]_Mask("_Mask", 2D) = "grey" {}
        _SnowStart("_SnowStart", Range(-1, 1)) = 0.5
        _SnowSoftness("_SnowSoftness", Range(0, 1)) = 1
        _SnowNormalScale("_SnowNormalScale", Float) = 50
        _SnowColor("_SnowColor", Color) = (0.9490196, 1, 1, 1)
        _SnowNormalStrength("_SnowNormalStrength", Float) = 1
        _SnowMetallic("_SnowMetallic", Range(0, 1)) = 0.1
        _SnowSmoothness("_SnowSmoothness", Range(0, 1)) = 0.9
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_SHADOW_COORD
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpacePosition;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 shadowCoord : INTERP3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 fogFactorAndVertexLight : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP7;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        struct Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float
        {
        };
        
        void SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(float4 _Color, UnityTexture2D _Albedo, UnityTexture2D _Normal, float _NormalStrength, UnityTexture2D _Mask, float2 _UV, Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float IN, out float4 Color_1, out float3 Normal_6, out float Metallic_2, out float AmbientOcclusion_4, out float Height_5, out float Smoothness_3)
        {
        float4 _Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4 = _Color;
        UnityTexture2D _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D = _Albedo;
        float2 _Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2 = _UV;
        float4 _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.tex, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.samplerstate, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_R_4_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.r;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_G_5_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.g;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_B_6_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.b;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_A_7_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.a;
        float4 _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4, _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4, _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4);
        UnityTexture2D _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D = _Normal;
        float4 _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.tex, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.samplerstate, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4);
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_R_4_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.r;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_G_5_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.g;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_B_6_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.b;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_A_7_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.a;
        float _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float = _NormalStrength;
        float3 _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Unity_NormalStrength_float((_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.xyz), _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float, _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3);
        UnityTexture2D _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D = _Mask;
        float4 _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.tex, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.samplerstate, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.r;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.g;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.b;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.a;
        Color_1 = _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Normal_6 = _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Metallic_2 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float;
        AmbientOcclusion_4 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float;
        Height_5 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float;
        Smoothness_3 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float
        {
        };
        
        void SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(float4 _X, float4 _Y, float4 _Z, float3 _Blend, int _Mode, Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float IN, out float4 Out_1)
        {
        float3 _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3 = _Blend;
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[0];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[1];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[2];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_A_4_Float = 0;
        float4 _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4 = _X;
        float4 _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float.xxxx), _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4, _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4);
        float4 _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4 = _Y;
        float4 _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float.xxxx), _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4);
        float4 _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4;
        Unity_Add_float4(_Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4, _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4);
        float4 _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4 = _Z;
        float4 _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float.xxxx), _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4);
        float4 _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        Unity_Add_float4(_Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4, _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4);
        float4 _Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4 = _Y;
        float4 _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4 = _X;
        float3 _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3 = _Blend;
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[0];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_G_2_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[1];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[2];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_A_4_Float = 0;
        float4 _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4;
        Unity_Lerp_float4(_Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4, _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float.xxxx), _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4);
        float4 _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4 = _Z;
        float4 _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        Unity_Lerp_float4(_Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4, _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float.xxxx), _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4);
        float4 _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        if (_Mode == 0)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        else if (_Mode == 1)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        }
        else
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        Out_1 = _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4 = _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float = _NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float = _Tile;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpacePosition, (_Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float.xxx), _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[0];
            float _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[1];
            float _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[2];
            float _Split_243e0fe5a44044899f7995feabca9d1b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d;
            float4 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4;
            float3 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb;
            float4 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4;
            float3 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757;
            float4 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4;
            float3 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float = _Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3;
            Unity_Power_float3(_Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3, (_Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float.xxx), _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float;
            Unity_DotProduct_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, float3(1, 1, 1), _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            Unity_Divide_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, (_DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float.xxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592;
            float4 _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4 = _SnowColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_053235ff80b74365998f5d8dd52ed309;
            float4 _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((float4(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, 1.0)), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4;
            Unity_Normalize_float4(_TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3 = TransformTangentToWorld((_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4.xyz).xyz, tangentTransform, true);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float;
            Unity_DotProduct_float3(_Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3, float3(0, 1, 0), _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float = _SnowStart;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float = _SnowSoftness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float;
            Unity_Add_float(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2 = float2(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float;
            Unity_Remap_float(_DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float, _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2, float2 (0, 1), _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float;
            Unity_Saturate_float(_Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float, _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4, _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4.xyz);
            #elif defined(_DEBUG_TRIPLANAR)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            #else
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxx);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            Unity_Lerp_float4(_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            #elif defined(_DEBUG_TRIPLANAR)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #else
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268;
            float4 _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268, _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_b6dd1bca0e37483f91dc85e133782ebb_Out_0_Float = _SnowMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4, (_Property_b6dd1bca0e37483f91dc85e133782ebb_Out_0_Float.xxxx), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5;
            float4 _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5, _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_520662d623b243f58bc9465339e842a3_Out_0_Float = _SnowSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4, (_Property_520662d623b243f58bc9465339e842a3_Out_0_Float.xxxx), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739;
            float4 _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739, _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4, float4(1, 1, 1, 1), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4);
            #endif
            surface.BaseColor = _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3;
            surface.NormalTS = (_Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = (_Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4).x;
            surface.Smoothness = (_Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4).x;
            surface.Occlusion = (_Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_SHADOW_COORD
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpacePosition;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 shadowCoord : INTERP3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 fogFactorAndVertexLight : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP7;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        struct Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float
        {
        };
        
        void SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(float4 _Color, UnityTexture2D _Albedo, UnityTexture2D _Normal, float _NormalStrength, UnityTexture2D _Mask, float2 _UV, Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float IN, out float4 Color_1, out float3 Normal_6, out float Metallic_2, out float AmbientOcclusion_4, out float Height_5, out float Smoothness_3)
        {
        float4 _Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4 = _Color;
        UnityTexture2D _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D = _Albedo;
        float2 _Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2 = _UV;
        float4 _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.tex, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.samplerstate, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_R_4_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.r;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_G_5_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.g;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_B_6_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.b;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_A_7_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.a;
        float4 _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4, _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4, _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4);
        UnityTexture2D _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D = _Normal;
        float4 _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.tex, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.samplerstate, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4);
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_R_4_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.r;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_G_5_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.g;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_B_6_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.b;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_A_7_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.a;
        float _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float = _NormalStrength;
        float3 _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Unity_NormalStrength_float((_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.xyz), _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float, _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3);
        UnityTexture2D _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D = _Mask;
        float4 _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.tex, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.samplerstate, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.r;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.g;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.b;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.a;
        Color_1 = _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Normal_6 = _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Metallic_2 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float;
        AmbientOcclusion_4 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float;
        Height_5 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float;
        Smoothness_3 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float
        {
        };
        
        void SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(float4 _X, float4 _Y, float4 _Z, float3 _Blend, int _Mode, Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float IN, out float4 Out_1)
        {
        float3 _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3 = _Blend;
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[0];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[1];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[2];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_A_4_Float = 0;
        float4 _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4 = _X;
        float4 _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float.xxxx), _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4, _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4);
        float4 _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4 = _Y;
        float4 _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float.xxxx), _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4);
        float4 _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4;
        Unity_Add_float4(_Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4, _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4);
        float4 _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4 = _Z;
        float4 _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float.xxxx), _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4);
        float4 _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        Unity_Add_float4(_Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4, _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4);
        float4 _Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4 = _Y;
        float4 _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4 = _X;
        float3 _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3 = _Blend;
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[0];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_G_2_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[1];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[2];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_A_4_Float = 0;
        float4 _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4;
        Unity_Lerp_float4(_Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4, _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float.xxxx), _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4);
        float4 _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4 = _Z;
        float4 _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        Unity_Lerp_float4(_Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4, _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float.xxxx), _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4);
        float4 _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        if (_Mode == 0)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        else if (_Mode == 1)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        }
        else
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        Out_1 = _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4 = _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float = _NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float = _Tile;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpacePosition, (_Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float.xxx), _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[0];
            float _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[1];
            float _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[2];
            float _Split_243e0fe5a44044899f7995feabca9d1b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d;
            float4 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4;
            float3 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb;
            float4 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4;
            float3 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757;
            float4 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4;
            float3 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float = _Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3;
            Unity_Power_float3(_Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3, (_Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float.xxx), _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float;
            Unity_DotProduct_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, float3(1, 1, 1), _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            Unity_Divide_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, (_DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float.xxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592;
            float4 _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4 = _SnowColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_053235ff80b74365998f5d8dd52ed309;
            float4 _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((float4(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, 1.0)), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4;
            Unity_Normalize_float4(_TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3 = TransformTangentToWorld((_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4.xyz).xyz, tangentTransform, true);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float;
            Unity_DotProduct_float3(_Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3, float3(0, 1, 0), _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float = _SnowStart;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float = _SnowSoftness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float;
            Unity_Add_float(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2 = float2(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float;
            Unity_Remap_float(_DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float, _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2, float2 (0, 1), _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float;
            Unity_Saturate_float(_Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float, _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4, _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4.xyz);
            #elif defined(_DEBUG_TRIPLANAR)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            #else
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxx);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            Unity_Lerp_float4(_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            #elif defined(_DEBUG_TRIPLANAR)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #else
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268;
            float4 _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268, _TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_b6dd1bca0e37483f91dc85e133782ebb_Out_0_Float = _SnowMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_b57f2ea3fa72450981e2f9a4e9f29268_Out_1_Vector4, (_Property_b6dd1bca0e37483f91dc85e133782ebb_Out_0_Float.xxxx), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5;
            float4 _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5, _TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_520662d623b243f58bc9465339e842a3_Out_0_Float = _SnowSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_b55cb9a09ede41f69c98c4ee5a930fa5_Out_1_Vector4, (_Property_520662d623b243f58bc9465339e842a3_Out_0_Float.xxxx), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739;
            float4 _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float.xxxx), (_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float.xxxx), (_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float.xxxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739, _TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_c0f66f9e1ce747cc95804cef11e98739_Out_1_Vector4, float4(1, 1, 1, 1), (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4);
            #endif
            surface.BaseColor = _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3;
            surface.NormalTS = (_Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = (_Lerp_2a4762882af04618bf8b60907ff0b1f0_Out_3_Vector4).x;
            surface.Smoothness = (_Lerp_8e7364c0cfda4af8b26ba0a4fa745edf_Out_3_Vector4).x;
            surface.Occlusion = (_Lerp_265983132fdb4748b47f8cc24d8aa736_Out_3_Vector4).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpacePosition;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        struct Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float
        {
        };
        
        void SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(float4 _Color, UnityTexture2D _Albedo, UnityTexture2D _Normal, float _NormalStrength, UnityTexture2D _Mask, float2 _UV, Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float IN, out float4 Color_1, out float3 Normal_6, out float Metallic_2, out float AmbientOcclusion_4, out float Height_5, out float Smoothness_3)
        {
        float4 _Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4 = _Color;
        UnityTexture2D _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D = _Albedo;
        float2 _Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2 = _UV;
        float4 _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.tex, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.samplerstate, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_R_4_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.r;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_G_5_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.g;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_B_6_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.b;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_A_7_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.a;
        float4 _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4, _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4, _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4);
        UnityTexture2D _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D = _Normal;
        float4 _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.tex, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.samplerstate, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4);
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_R_4_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.r;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_G_5_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.g;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_B_6_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.b;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_A_7_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.a;
        float _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float = _NormalStrength;
        float3 _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Unity_NormalStrength_float((_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.xyz), _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float, _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3);
        UnityTexture2D _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D = _Mask;
        float4 _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.tex, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.samplerstate, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.r;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.g;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.b;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.a;
        Color_1 = _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Normal_6 = _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Metallic_2 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float;
        AmbientOcclusion_4 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float;
        Height_5 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float;
        Smoothness_3 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float
        {
        };
        
        void SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(float4 _X, float4 _Y, float4 _Z, float3 _Blend, int _Mode, Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float IN, out float4 Out_1)
        {
        float3 _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3 = _Blend;
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[0];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[1];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[2];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_A_4_Float = 0;
        float4 _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4 = _X;
        float4 _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float.xxxx), _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4, _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4);
        float4 _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4 = _Y;
        float4 _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float.xxxx), _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4);
        float4 _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4;
        Unity_Add_float4(_Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4, _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4);
        float4 _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4 = _Z;
        float4 _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float.xxxx), _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4);
        float4 _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        Unity_Add_float4(_Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4, _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4);
        float4 _Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4 = _Y;
        float4 _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4 = _X;
        float3 _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3 = _Blend;
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[0];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_G_2_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[1];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[2];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_A_4_Float = 0;
        float4 _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4;
        Unity_Lerp_float4(_Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4, _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float.xxxx), _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4);
        float4 _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4 = _Z;
        float4 _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        Unity_Lerp_float4(_Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4, _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float.xxxx), _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4);
        float4 _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        if (_Mode == 0)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        else if (_Mode == 1)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        }
        else
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        Out_1 = _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4 = _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float = _NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float = _Tile;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpacePosition, (_Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float.xxx), _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[0];
            float _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[1];
            float _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[2];
            float _Split_243e0fe5a44044899f7995feabca9d1b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d;
            float4 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4;
            float3 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb;
            float4 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4;
            float3 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757;
            float4 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4;
            float3 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float = _Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3;
            Unity_Power_float3(_Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3, (_Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float.xxx), _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float;
            Unity_DotProduct_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, float3(1, 1, 1), _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            Unity_Divide_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, (_DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float.xxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_053235ff80b74365998f5d8dd52ed309;
            float4 _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((float4(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, 1.0)), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4;
            Unity_Normalize_float4(_TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3 = TransformTangentToWorld((_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4.xyz).xyz, tangentTransform, true);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float;
            Unity_DotProduct_float3(_Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3, float3(0, 1, 0), _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float = _SnowStart;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float = _SnowSoftness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float;
            Unity_Add_float(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2 = float2(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float;
            Unity_Remap_float(_DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float, _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2, float2 (0, 1), _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float;
            Unity_Saturate_float(_Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float, _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            Unity_Lerp_float4(_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = _Lerp_788140d9eb2141ffa4e5f9b392997a06_Out_3_Vector4;
            #elif defined(_DEBUG_TRIPLANAR)
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #else
            float4 _Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4 = float4(0, 0, 1, 0);
            #endif
            #endif
            surface.NormalTS = (_Debug_d473b8400a804b478986c871ba6a923e_Out_0_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpacePosition;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord1 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 texCoord2 : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        struct Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float
        {
        };
        
        void SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(float4 _Color, UnityTexture2D _Albedo, UnityTexture2D _Normal, float _NormalStrength, UnityTexture2D _Mask, float2 _UV, Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float IN, out float4 Color_1, out float3 Normal_6, out float Metallic_2, out float AmbientOcclusion_4, out float Height_5, out float Smoothness_3)
        {
        float4 _Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4 = _Color;
        UnityTexture2D _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D = _Albedo;
        float2 _Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2 = _UV;
        float4 _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.tex, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.samplerstate, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_R_4_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.r;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_G_5_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.g;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_B_6_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.b;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_A_7_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.a;
        float4 _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4, _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4, _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4);
        UnityTexture2D _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D = _Normal;
        float4 _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.tex, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.samplerstate, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4);
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_R_4_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.r;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_G_5_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.g;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_B_6_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.b;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_A_7_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.a;
        float _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float = _NormalStrength;
        float3 _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Unity_NormalStrength_float((_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.xyz), _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float, _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3);
        UnityTexture2D _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D = _Mask;
        float4 _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.tex, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.samplerstate, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.r;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.g;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.b;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.a;
        Color_1 = _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Normal_6 = _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Metallic_2 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float;
        AmbientOcclusion_4 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float;
        Height_5 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float;
        Smoothness_3 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float
        {
        };
        
        void SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(float4 _X, float4 _Y, float4 _Z, float3 _Blend, int _Mode, Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float IN, out float4 Out_1)
        {
        float3 _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3 = _Blend;
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[0];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[1];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[2];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_A_4_Float = 0;
        float4 _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4 = _X;
        float4 _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float.xxxx), _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4, _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4);
        float4 _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4 = _Y;
        float4 _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float.xxxx), _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4);
        float4 _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4;
        Unity_Add_float4(_Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4, _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4);
        float4 _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4 = _Z;
        float4 _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float.xxxx), _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4);
        float4 _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        Unity_Add_float4(_Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4, _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4);
        float4 _Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4 = _Y;
        float4 _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4 = _X;
        float3 _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3 = _Blend;
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[0];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_G_2_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[1];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[2];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_A_4_Float = 0;
        float4 _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4;
        Unity_Lerp_float4(_Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4, _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float.xxxx), _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4);
        float4 _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4 = _Z;
        float4 _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        Unity_Lerp_float4(_Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4, _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float.xxxx), _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4);
        float4 _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        if (_Mode == 0)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        else if (_Mode == 1)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        }
        else
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        Out_1 = _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4 = _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float = _NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float = _Tile;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpacePosition, (_Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float.xxx), _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[0];
            float _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[1];
            float _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[2];
            float _Split_243e0fe5a44044899f7995feabca9d1b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d;
            float4 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4;
            float3 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb;
            float4 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4;
            float3 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757;
            float4 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4;
            float3 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float = _Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3;
            Unity_Power_float3(_Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3, (_Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float.xxx), _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float;
            Unity_DotProduct_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, float3(1, 1, 1), _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            Unity_Divide_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, (_DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float.xxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592;
            float4 _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4 = _SnowColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_053235ff80b74365998f5d8dd52ed309;
            float4 _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((float4(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, 1.0)), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4;
            Unity_Normalize_float4(_TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3 = TransformTangentToWorld((_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4.xyz).xyz, tangentTransform, true);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float;
            Unity_DotProduct_float3(_Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3, float3(0, 1, 0), _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float = _SnowStart;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float = _SnowSoftness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float;
            Unity_Add_float(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2 = float2(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float;
            Unity_Remap_float(_DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float, _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2, float2 (0, 1), _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float;
            Unity_Saturate_float(_Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float, _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4, _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4.xyz);
            #elif defined(_DEBUG_TRIPLANAR)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            #else
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxx);
            #endif
            #endif
            surface.BaseColor = _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3;
            surface.Emission = float3(0, 0, 0);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TRIPLANAR _DEBUG_SNOW
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TRIPLANAR)
            #define KEYWORD_PERMUTATION_1
        #else
            #define KEYWORD_PERMUTATION_2
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 WorldSpacePosition;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        float4 _Albedo_TexelSize;
        float4 _Normal_TexelSize;
        float _SnowNormalStrength;
        float _NormalStrength;
        float _SnowSmoothness;
        float4 _Mask_TexelSize;
        float _SnowStart;
        float _SnowSoftness;
        float _SnowNormalScale;
        float4 _SnowColor;
        float _SnowMetallic;
        float _Tile;
        float _Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Mask);
        SAMPLER(sampler_Mask);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        struct Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float
        {
        };
        
        void SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(float4 _Color, UnityTexture2D _Albedo, UnityTexture2D _Normal, float _NormalStrength, UnityTexture2D _Mask, float2 _UV, Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float IN, out float4 Color_1, out float3 Normal_6, out float Metallic_2, out float AmbientOcclusion_4, out float Height_5, out float Smoothness_3)
        {
        float4 _Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4 = _Color;
        UnityTexture2D _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D = _Albedo;
        float2 _Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2 = _UV;
        float4 _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.tex, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.samplerstate, _Property_fe02ff46e0214b0b8cd36e9ed42221e7_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_R_4_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.r;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_G_5_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.g;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_B_6_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.b;
        float _SampleTexture2D_054b669442be414f9af568fa41d40bb3_A_7_Float = _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4.a;
        float4 _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Property_dfc13515d2f04ecaac0dbd3bd888c986_Out_0_Vector4, _SampleTexture2D_054b669442be414f9af568fa41d40bb3_RGBA_0_Vector4, _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4);
        UnityTexture2D _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D = _Normal;
        float4 _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.tex, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.samplerstate, _Property_174f3a1326084b4a8659c52e1ce7daff_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4);
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_R_4_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.r;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_G_5_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.g;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_B_6_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.b;
        float _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_A_7_Float = _SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.a;
        float _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float = _NormalStrength;
        float3 _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Unity_NormalStrength_float((_SampleTexture2D_531196f9fc764cd9830ef897198f64ea_RGBA_0_Vector4.xyz), _Property_d8ec09adf1eb47cd91ae7e6fa17a8c5d_Out_0_Float, _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3);
        UnityTexture2D _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D = _Mask;
        float4 _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.tex, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.samplerstate, _Property_c6e756e7f35648bda5dd6b48e8f6d63a_Out_0_Texture2D.GetTransformedUV(_Property_f62e5a25997d4dbe9104d7d55ec98cce_Out_0_Vector2) );
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.r;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.g;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.b;
        float _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_RGBA_0_Vector4.a;
        Color_1 = _Multiply_d5ec9a6f42f74fad8b29c44059610f13_Out_2_Vector4;
        Normal_6 = _NormalStrength_20786bfb6eb24948864cfe6f4eeb23df_Out_2_Vector3;
        Metallic_2 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_R_4_Float;
        AmbientOcclusion_4 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_G_5_Float;
        Height_5 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_B_6_Float;
        Smoothness_3 = _SampleTexture2D_06445dab261b41c197eeb0fcf7a92b32_A_7_Float;
        }
        
        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float
        {
        };
        
        void SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(float4 _X, float4 _Y, float4 _Z, float3 _Blend, int _Mode, Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float IN, out float4 Out_1)
        {
        float3 _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3 = _Blend;
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[0];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[1];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float = _Property_ba978a508b8149b282adf1cdde253d13_Out_0_Vector3[2];
        float _Split_b38f1e6d94e44f5bbb3a5c639379e438_A_4_Float = 0;
        float4 _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4 = _X;
        float4 _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_R_1_Float.xxxx), _Property_5cddb8ae0ef54f27bb5d4d49da1c5ee6_Out_0_Vector4, _Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4);
        float4 _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4 = _Y;
        float4 _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_G_2_Float.xxxx), _Property_d293e6c5c885481f8ee8f1c802c0f1da_Out_0_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4);
        float4 _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4;
        Unity_Add_float4(_Multiply_587c598a2b7742e58842b301aea0ca60_Out_2_Vector4, _Multiply_4511a17d0c9d47dfbaa20783b5b7808c_Out_2_Vector4, _Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4);
        float4 _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4 = _Z;
        float4 _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Split_b38f1e6d94e44f5bbb3a5c639379e438_B_3_Float.xxxx), _Property_2870add217c34a30bf0f1cd74bc32e55_Out_0_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4);
        float4 _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        Unity_Add_float4(_Add_9d599807a52444309870fb9a6cfc57e3_Out_2_Vector4, _Multiply_7b9888c94e4c4980bae59bb404e4ddf2_Out_2_Vector4, _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4);
        float4 _Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4 = _Y;
        float4 _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4 = _X;
        float3 _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3 = _Blend;
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[0];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_G_2_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[1];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float = _Property_c6db67a6585b48429bb16cc1a83e4ed3_Out_0_Vector3[2];
        float _Split_40ea6210faba41e1a9cac675b6f33b2f_A_4_Float = 0;
        float4 _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4;
        Unity_Lerp_float4(_Property_92819cd079e041308d8ffe206f54bb99_Out_0_Vector4, _Property_d1693a39adfb4277b0beca4307213b36_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_R_1_Float.xxxx), _Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4);
        float4 _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4 = _Z;
        float4 _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        Unity_Lerp_float4(_Lerp_d664f0e1c2954bf28f6590f34bfc4f3a_Out_3_Vector4, _Property_83f054522aa347bc863968cfe2965d05_Out_0_Vector4, (_Split_40ea6210faba41e1a9cac675b6f33b2f_B_3_Float.xxxx), _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4);
        float4 _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        if (_Mode == 0)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        else if (_Mode == 1)
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Lerp_a080ca905319484a8d6f4dbce7a41c2a_Out_3_Vector4;
        }
        else
        {
        _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4 = _Add_6ec495d6453a496cbb1978aa9c225031_Out_2_Vector4;
        }
        Out_1 = _Mode_055069bc84404dce849705d9d161fcc2_Out_0_Vector4;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4 = _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float = _NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            UnityTexture2D _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float = _Tile;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpacePosition, (_Property_c5bf9f7b094e4989ba1175df7cc88c1f_Out_0_Float.xxx), _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[0];
            float _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[1];
            float _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float = _Multiply_74b4b7506d264831a12362742b7d9676_Out_2_Vector3[2];
            float _Split_243e0fe5a44044899f7995feabca9d1b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d;
            float4 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4;
            float3 _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float;
            float _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_a3e46d6921fa4f3cafc18e0394931ecd_Out_0_Vector2, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Metallic_2_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_AmbientOcclusion_4_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Height_5_Float, _TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_B_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb;
            float4 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4;
            float3 _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float;
            float _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_354255f1dcd04040a889cc794c4034c2_Out_0_Vector2, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Metallic_2_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_AmbientOcclusion_4_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Height_5_Float, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2 = float2(_Split_243e0fe5a44044899f7995feabca9d1b_R_1_Float, _Split_243e0fe5a44044899f7995feabca9d1b_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757;
            float4 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4;
            float3 _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float;
            float _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_9d91c47ec7a04ac3abaf93d044936437_Out_0_Vector4, _Property_68e790bac67a48d689a93dd14df13abd_Out_0_Texture2D, _Property_402c8c966f3248adbb7160afd34cc97c_Out_0_Texture2D, _Property_fe8fafecb34e4a529426485abe1e4b7f_Out_0_Float, _Property_324203a5c18c4d43bdbd59f9d6684783_Out_0_Texture2D, _Vector2_feb9fda142a5442b9d89af232b537c4b_Out_0_Vector2, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Metallic_2_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_AmbientOcclusion_4_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Height_5_Float, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float = _Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3;
            Unity_Power_float3(_Absolute_e834620ec31e4096a407d983fa43a08f_Out_1_Vector3, (_Property_8f0327d28e98467ab05c592ec4a2275f_Out_0_Float.xxx), _Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float;
            Unity_DotProduct_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, float3(1, 1, 1), _DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            Unity_Divide_float3(_Power_638cbd13bab24b2f9eb4025b522c16a6_Out_2_Vector3, (_DotProduct_38bc100b03bb4c4582943bc4c2122fa7_Out_2_Float.xxx), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592;
            float4 _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Color_1_Vector4, _TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Color_1_Vector4, _TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Color_1_Vector4, _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592, _TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4 = _SnowColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            Bindings_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float _TriplanarBlending_053235ff80b74365998f5d8dd52ed309;
            float4 _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4;
            SG_TriplanarBlending_8bacb4f06062b8546a3d67083ca2bc45_float((float4(_TextureSetSample_fd3820a5b0ec4b19b486cae827be414d_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_4ad917639f9e49959872a280a26ff1cb_Normal_6_Vector3, 1.0)), (float4(_TextureSetSample_b5ca1f49e5724777b9eada8e6835d757_Normal_6_Vector3, 1.0)), _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3, 0, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309, _TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4;
            Unity_Normalize_float4(_TriplanarBlending_053235ff80b74365998f5d8dd52ed309_Out_1_Vector4, _Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float3 _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3 = TransformTangentToWorld((_Normalize_3a32df2a3ae64f1997e16b497e6dbb46_Out_1_Vector4.xyz).xyz, tangentTransform, true);
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float;
            Unity_DotProduct_float3(_Transform_43bc364ae04d4659a4591fe6e6f11647_Out_1_Vector3, float3(0, 1, 0), _DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float = _SnowStart;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float = _SnowSoftness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float;
            Unity_Add_float(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Property_bb98c4bee70c4c3f9d8abf5e45983877_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float2 _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2 = float2(_Property_1afa8f9b39d44c02b4d1604cc4d220f6_Out_0_Float, _Add_4fa1dd3bb94942a5a79544919f5c8da2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float;
            Unity_Remap_float(_DotProduct_1f365c094ddd409e9622461e997d241c_Out_2_Float, _Vector2_3e952a8baf9840b9a3d5d503207fd269_Out_0_Vector2, float2 (0, 1), _Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float;
            Unity_Saturate_float(_Remap_2cc6e46560e9475b9d9015b5cf6bb757_Out_3_Float, _Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            float4 _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4;
            Unity_Lerp_float4(_TriplanarBlending_1c5a09cf4cce44c2a6593445268ab592_Out_1_Vector4, _Property_f13f273c98944eddba5e356dda9a02e0_Out_0_Vector4, (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxxx), _Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Lerp_e40aa8a7a0e64224a8c6712e8bb1d0b8_Out_3_Vector4.xyz);
            #elif defined(_DEBUG_TRIPLANAR)
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = _Divide_83988153a7f942f7a20e76c419da85b3_Out_2_Vector3;
            #else
            float3 _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3 = (_Saturate_cd5a00a51fc544678e0b1942e02febba_Out_1_Float.xxx);
            #endif
            #endif
            surface.BaseColor = _Debug_546159afa54f4a28867a00d79f8eb9be_Out_0_Vector3;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}