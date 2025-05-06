Shader "Shader Graphs/E2-Compiled"
{
    Properties
    {
        [KeywordEnum(Disabled, Blend, VertexColor, VertexColorAndNoise)]_DEBUG("Debug", Float) = 0
        _Softness("_Softness", Range(0, 1)) = 0
        _NoiseScale("_NoiseScale", Float) = 1
        _NoiseStrength("_NoiseStrength", Range(0, 1)) = 0.5
        _A_Color("_A_Color", Color) = (1, 1, 1, 1)
        _A_Albedo("_A_Albedo", 2D) = "white" {}
        [Normal]_A_Normal("_A_Normal", 2D) = "bump" {}
        _A_NormalStrength("_A_NormalStrength", Float) = 1
        _A_Mask("_A_Mask", 2D) = "white" {}
        _B_Color("_B_Color", Color) = (1, 1, 1, 1)
        _B_Albedo("_B_Albedo", 2D) = "white" {}
        [Normal]_B_Normal("_B_Normal", 2D) = "bump" {}
        _B_NormalStrength("_B_NormalStrength", Float) = 1
        _B_Mask("_B_Mask", 2D) = "white" {}
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 shadowCoord : INTERP3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0 : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 fogFactorAndVertexLight : INTERP7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionWS : INTERP8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS : INTERP9;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
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
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_Overlay_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float result2 = 2.0 * Base * Blend;
            float zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float
        {
        };
        
        void SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(float _AH, float _BH, float _T, float _Blend, Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float IN, out float T_1)
        {
        float _Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float = _T;
        float _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float;
        Unity_OneMinus_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float);
        float _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float = _BH;
        float _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float;
        Unity_Add_float(_OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float, _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float, _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float);
        float _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float = _AH;
        float _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float;
        Unity_Add_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float);
        float _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float;
        Unity_Subtract_float(_Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float, _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float);
        float _Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float = _Blend;
        float _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float;
        Unity_Maximum_float(_Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float, 0.0001, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float);
        float _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float;
        Unity_Divide_float(_Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float, _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float);
        float _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float;
        Unity_Add_float(_Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float, 0.5, _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float);
        float _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        Unity_Saturate_float(_Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float, _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float);
        T_1 = _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float
        {
        };
        
        void SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(float _T, float4 _A_Color, float3 _A_Normal, float _A_Metallic, float _A_AO, float _A_Smoothness, float4 _B_Color, float3 _B_Normal, float _B_Metallic, float _B_AO, float _B_Smoothness, Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float IN, out float4 Color_1, out float3 Normal_2, out float Metallic_3, out float AO_4, out float Smoothness_5)
        {
        float4 _Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4 = _A_Color;
        float4 _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4 = _B_Color;
        float _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float = _T;
        float4 _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Unity_Lerp_float4(_Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4, _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxxx), _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4);
        float3 _Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3 = _A_Normal;
        float3 _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3 = _B_Normal;
        float3 _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Unity_Lerp_float3(_Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3, _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxx), _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3);
        float _Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float = _A_Metallic;
        float _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float = _B_Metallic;
        float _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        Unity_Lerp_float(_Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float, _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float);
        float _Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float = _A_AO;
        float _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float = _B_AO;
        float _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Unity_Lerp_float(_Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float, _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float);
        float _Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float = _A_Smoothness;
        float _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float = _B_Smoothness;
        float _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
        Unity_Lerp_float(_Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float, _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float);
        Color_1 = _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Normal_2 = _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Metallic_3 = _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        AO_4 = _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Smoothness_5 = _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f09a201765874490a237364f838131d2_Out_0_Vector4 = _A_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float = _A_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e;
            float4 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4;
            float3 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f09a201765874490a237364f838131d2_Out_0_Vector4, _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D, _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D, _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float, _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4 = _B_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float = _B_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2;
            float4 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4;
            float3 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4, _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D, _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D, _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float, _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Split_d82cd51480da4b718a048f502e999e2e_R_1_Float = IN.VertexColor[0];
            float _Split_d82cd51480da4b718a048f502e999e2e_G_2_Float = IN.VertexColor[1];
            float _Split_d82cd51480da4b718a048f502e999e2e_B_3_Float = IN.VertexColor[2];
            float _Split_d82cd51480da4b718a048f502e999e2e_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float = _NoiseScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(IN.uv0.xy, _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float, _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float, float2 (0, 1), float2 (0.1, 0.9), _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float = _NoiseStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float;
            Unity_Blend_Overlay_float(_Split_d82cd51480da4b718a048f502e999e2e_R_1_Float, _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float = _Softness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float _HeightBlend_81190b36918d4bf99f5176b783c52196;
            float _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float;
            SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(_TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float, _HeightBlend_81190b36918d4bf99f5176b783c52196, _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49;
            float4 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            float3 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            #elif defined(_DEBUG_BLEND)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float.xxxx);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = IN.VertexColor;
            #else
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float.xxxx);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            #elif defined(_DEBUG_BLEND)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #else
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #endif
            #endif
            surface.BaseColor = (_Debug_b164672404df4d84942f18527891a518_Out_0_Vector4.xyz);
            surface.NormalTS = _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            surface.Smoothness = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            surface.Occlusion = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        
            
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.VertexColor = input.color;
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 shadowCoord : INTERP3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0 : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 fogFactorAndVertexLight : INTERP7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionWS : INTERP8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS : INTERP9;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
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
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_Overlay_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float result2 = 2.0 * Base * Blend;
            float zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float
        {
        };
        
        void SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(float _AH, float _BH, float _T, float _Blend, Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float IN, out float T_1)
        {
        float _Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float = _T;
        float _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float;
        Unity_OneMinus_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float);
        float _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float = _BH;
        float _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float;
        Unity_Add_float(_OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float, _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float, _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float);
        float _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float = _AH;
        float _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float;
        Unity_Add_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float);
        float _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float;
        Unity_Subtract_float(_Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float, _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float);
        float _Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float = _Blend;
        float _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float;
        Unity_Maximum_float(_Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float, 0.0001, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float);
        float _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float;
        Unity_Divide_float(_Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float, _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float);
        float _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float;
        Unity_Add_float(_Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float, 0.5, _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float);
        float _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        Unity_Saturate_float(_Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float, _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float);
        T_1 = _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float
        {
        };
        
        void SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(float _T, float4 _A_Color, float3 _A_Normal, float _A_Metallic, float _A_AO, float _A_Smoothness, float4 _B_Color, float3 _B_Normal, float _B_Metallic, float _B_AO, float _B_Smoothness, Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float IN, out float4 Color_1, out float3 Normal_2, out float Metallic_3, out float AO_4, out float Smoothness_5)
        {
        float4 _Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4 = _A_Color;
        float4 _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4 = _B_Color;
        float _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float = _T;
        float4 _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Unity_Lerp_float4(_Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4, _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxxx), _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4);
        float3 _Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3 = _A_Normal;
        float3 _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3 = _B_Normal;
        float3 _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Unity_Lerp_float3(_Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3, _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxx), _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3);
        float _Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float = _A_Metallic;
        float _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float = _B_Metallic;
        float _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        Unity_Lerp_float(_Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float, _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float);
        float _Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float = _A_AO;
        float _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float = _B_AO;
        float _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Unity_Lerp_float(_Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float, _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float);
        float _Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float = _A_Smoothness;
        float _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float = _B_Smoothness;
        float _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
        Unity_Lerp_float(_Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float, _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float);
        Color_1 = _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Normal_2 = _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Metallic_3 = _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        AO_4 = _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Smoothness_5 = _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f09a201765874490a237364f838131d2_Out_0_Vector4 = _A_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float = _A_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e;
            float4 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4;
            float3 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f09a201765874490a237364f838131d2_Out_0_Vector4, _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D, _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D, _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float, _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4 = _B_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float = _B_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2;
            float4 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4;
            float3 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4, _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D, _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D, _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float, _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Split_d82cd51480da4b718a048f502e999e2e_R_1_Float = IN.VertexColor[0];
            float _Split_d82cd51480da4b718a048f502e999e2e_G_2_Float = IN.VertexColor[1];
            float _Split_d82cd51480da4b718a048f502e999e2e_B_3_Float = IN.VertexColor[2];
            float _Split_d82cd51480da4b718a048f502e999e2e_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float = _NoiseScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(IN.uv0.xy, _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float, _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float, float2 (0, 1), float2 (0.1, 0.9), _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float = _NoiseStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float;
            Unity_Blend_Overlay_float(_Split_d82cd51480da4b718a048f502e999e2e_R_1_Float, _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float = _Softness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float _HeightBlend_81190b36918d4bf99f5176b783c52196;
            float _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float;
            SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(_TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float, _HeightBlend_81190b36918d4bf99f5176b783c52196, _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49;
            float4 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            float3 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            #elif defined(_DEBUG_BLEND)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float.xxxx);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = IN.VertexColor;
            #else
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float.xxxx);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            #elif defined(_DEBUG_BLEND)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #else
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #endif
            #endif
            surface.BaseColor = (_Debug_b164672404df4d84942f18527891a518_Out_0_Vector4.xyz);
            surface.NormalTS = _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            surface.Smoothness = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            surface.Occlusion = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        
            
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.VertexColor = input.color;
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS : INTERP0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_COLOR
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalWS : INTERP3;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
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
            output.color = input.color.xyzw;
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
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
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_Overlay_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float result2 = 2.0 * Base * Blend;
            float zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float
        {
        };
        
        void SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(float _AH, float _BH, float _T, float _Blend, Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float IN, out float T_1)
        {
        float _Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float = _T;
        float _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float;
        Unity_OneMinus_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float);
        float _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float = _BH;
        float _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float;
        Unity_Add_float(_OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float, _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float, _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float);
        float _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float = _AH;
        float _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float;
        Unity_Add_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float);
        float _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float;
        Unity_Subtract_float(_Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float, _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float);
        float _Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float = _Blend;
        float _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float;
        Unity_Maximum_float(_Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float, 0.0001, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float);
        float _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float;
        Unity_Divide_float(_Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float, _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float);
        float _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float;
        Unity_Add_float(_Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float, 0.5, _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float);
        float _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        Unity_Saturate_float(_Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float, _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float);
        T_1 = _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float
        {
        };
        
        void SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(float _T, float4 _A_Color, float3 _A_Normal, float _A_Metallic, float _A_AO, float _A_Smoothness, float4 _B_Color, float3 _B_Normal, float _B_Metallic, float _B_AO, float _B_Smoothness, Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float IN, out float4 Color_1, out float3 Normal_2, out float Metallic_3, out float AO_4, out float Smoothness_5)
        {
        float4 _Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4 = _A_Color;
        float4 _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4 = _B_Color;
        float _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float = _T;
        float4 _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Unity_Lerp_float4(_Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4, _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxxx), _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4);
        float3 _Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3 = _A_Normal;
        float3 _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3 = _B_Normal;
        float3 _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Unity_Lerp_float3(_Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3, _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxx), _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3);
        float _Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float = _A_Metallic;
        float _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float = _B_Metallic;
        float _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        Unity_Lerp_float(_Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float, _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float);
        float _Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float = _A_AO;
        float _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float = _B_AO;
        float _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Unity_Lerp_float(_Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float, _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float);
        float _Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float = _A_Smoothness;
        float _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float = _B_Smoothness;
        float _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
        Unity_Lerp_float(_Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float, _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float);
        Color_1 = _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Normal_2 = _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Metallic_3 = _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        AO_4 = _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Smoothness_5 = _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f09a201765874490a237364f838131d2_Out_0_Vector4 = _A_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float = _A_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e;
            float4 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4;
            float3 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f09a201765874490a237364f838131d2_Out_0_Vector4, _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D, _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D, _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float, _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4 = _B_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float = _B_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2;
            float4 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4;
            float3 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4, _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D, _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D, _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float, _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Split_d82cd51480da4b718a048f502e999e2e_R_1_Float = IN.VertexColor[0];
            float _Split_d82cd51480da4b718a048f502e999e2e_G_2_Float = IN.VertexColor[1];
            float _Split_d82cd51480da4b718a048f502e999e2e_B_3_Float = IN.VertexColor[2];
            float _Split_d82cd51480da4b718a048f502e999e2e_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float = _NoiseScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(IN.uv0.xy, _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float, _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float, float2 (0, 1), float2 (0.1, 0.9), _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float = _NoiseStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float;
            Unity_Blend_Overlay_float(_Split_d82cd51480da4b718a048f502e999e2e_R_1_Float, _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float = _Softness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float _HeightBlend_81190b36918d4bf99f5176b783c52196;
            float _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float;
            SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(_TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float, _HeightBlend_81190b36918d4bf99f5176b783c52196, _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49;
            float4 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            float3 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            #elif defined(_DEBUG_BLEND)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #else
            float3 _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3 = float3(0, 0, 1);
            #endif
            #endif
            surface.NormalTS = _Debug_b000930126f64baaad7d29caee402bfd_Out_0_Vector3;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        
            
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.VertexColor = input.color;
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_COLOR
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord1 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord2 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : INTERP3;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
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
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_Overlay_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float result2 = 2.0 * Base * Blend;
            float zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float
        {
        };
        
        void SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(float _AH, float _BH, float _T, float _Blend, Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float IN, out float T_1)
        {
        float _Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float = _T;
        float _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float;
        Unity_OneMinus_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float);
        float _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float = _BH;
        float _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float;
        Unity_Add_float(_OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float, _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float, _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float);
        float _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float = _AH;
        float _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float;
        Unity_Add_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float);
        float _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float;
        Unity_Subtract_float(_Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float, _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float);
        float _Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float = _Blend;
        float _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float;
        Unity_Maximum_float(_Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float, 0.0001, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float);
        float _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float;
        Unity_Divide_float(_Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float, _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float);
        float _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float;
        Unity_Add_float(_Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float, 0.5, _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float);
        float _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        Unity_Saturate_float(_Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float, _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float);
        T_1 = _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float
        {
        };
        
        void SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(float _T, float4 _A_Color, float3 _A_Normal, float _A_Metallic, float _A_AO, float _A_Smoothness, float4 _B_Color, float3 _B_Normal, float _B_Metallic, float _B_AO, float _B_Smoothness, Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float IN, out float4 Color_1, out float3 Normal_2, out float Metallic_3, out float AO_4, out float Smoothness_5)
        {
        float4 _Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4 = _A_Color;
        float4 _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4 = _B_Color;
        float _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float = _T;
        float4 _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Unity_Lerp_float4(_Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4, _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxxx), _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4);
        float3 _Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3 = _A_Normal;
        float3 _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3 = _B_Normal;
        float3 _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Unity_Lerp_float3(_Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3, _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxx), _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3);
        float _Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float = _A_Metallic;
        float _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float = _B_Metallic;
        float _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        Unity_Lerp_float(_Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float, _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float);
        float _Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float = _A_AO;
        float _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float = _B_AO;
        float _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Unity_Lerp_float(_Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float, _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float);
        float _Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float = _A_Smoothness;
        float _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float = _B_Smoothness;
        float _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
        Unity_Lerp_float(_Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float, _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float);
        Color_1 = _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Normal_2 = _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Metallic_3 = _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        AO_4 = _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Smoothness_5 = _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f09a201765874490a237364f838131d2_Out_0_Vector4 = _A_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float = _A_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e;
            float4 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4;
            float3 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f09a201765874490a237364f838131d2_Out_0_Vector4, _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D, _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D, _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float, _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4 = _B_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float = _B_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2;
            float4 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4;
            float3 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4, _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D, _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D, _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float, _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Split_d82cd51480da4b718a048f502e999e2e_R_1_Float = IN.VertexColor[0];
            float _Split_d82cd51480da4b718a048f502e999e2e_G_2_Float = IN.VertexColor[1];
            float _Split_d82cd51480da4b718a048f502e999e2e_B_3_Float = IN.VertexColor[2];
            float _Split_d82cd51480da4b718a048f502e999e2e_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float = _NoiseScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(IN.uv0.xy, _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float, _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float, float2 (0, 1), float2 (0.1, 0.9), _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float = _NoiseStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float;
            Unity_Blend_Overlay_float(_Split_d82cd51480da4b718a048f502e999e2e_R_1_Float, _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float = _Softness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float _HeightBlend_81190b36918d4bf99f5176b783c52196;
            float _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float;
            SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(_TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float, _HeightBlend_81190b36918d4bf99f5176b783c52196, _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49;
            float4 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            float3 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            #elif defined(_DEBUG_BLEND)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float.xxxx);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = IN.VertexColor;
            #else
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float.xxxx);
            #endif
            #endif
            surface.BaseColor = (_Debug_b164672404df4d84942f18527891a518_Out_0_Vector4.xyz);
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.VertexColor = input.color;
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_BLEND _DEBUG_VERTEXCOLOR _DEBUG_VERTEXCOLORANDNOISE
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_BLEND)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_VERTEXCOLOR)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        #define VARYINGS_NEED_COLOR
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             float4 color : INTERP1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
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
        float4 _A_Albedo_TexelSize;
        float4 _A_Albedo_ST;
        float4 _A_Mask_TexelSize;
        float4 _A_Mask_ST;
        float4 _A_Normal_TexelSize;
        float4 _A_Normal_ST;
        float4 _A_Color;
        float _A_NormalStrength;
        float4 _B_Color;
        float4 _B_Albedo_TexelSize;
        float4 _B_Albedo_ST;
        float4 _B_Mask_TexelSize;
        float4 _B_Mask_ST;
        float _B_NormalStrength;
        float4 _B_Normal_TexelSize;
        float4 _B_Normal_ST;
        float _Softness;
        float _NoiseScale;
        float _NoiseStrength;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_A_Albedo);
        SAMPLER(sampler_A_Albedo);
        TEXTURE2D(_A_Mask);
        SAMPLER(sampler_A_Mask);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_B_Mask);
        SAMPLER(sampler_B_Mask);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
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
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_Overlay_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float result2 = 2.0 * Base * Blend;
            float zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float
        {
        };
        
        void SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(float _AH, float _BH, float _T, float _Blend, Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float IN, out float T_1)
        {
        float _Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float = _T;
        float _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float;
        Unity_OneMinus_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float);
        float _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float = _BH;
        float _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float;
        Unity_Add_float(_OneMinus_d5c05d9e78304d2e957c1995f8615156_Out_1_Float, _Property_9df02d7dd7084deead1b3527133581da_Out_0_Float, _Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float);
        float _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float = _AH;
        float _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float;
        Unity_Add_float(_Property_357911bc1be2454eb1daf1a7316f0a64_Out_0_Float, _Property_09bc7cfb3a8548089c0890696fdcfcff_Out_0_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float);
        float _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float;
        Unity_Subtract_float(_Add_9261f61a84d8489f9f25d76b6f1c85a9_Out_2_Float, _Add_3e56fe4ed198421bb7e2046f5cee1582_Out_2_Float, _Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float);
        float _Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float = _Blend;
        float _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float;
        Unity_Maximum_float(_Property_ac846d35d9824286b0e4e21b32f3b473_Out_0_Float, 0.0001, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float);
        float _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float;
        Unity_Divide_float(_Subtract_6015d4b01bf6484e91ffaab7e176222d_Out_2_Float, _Maximum_2f6e44a0b3f8483a917fda9a897a456c_Out_2_Float, _Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float);
        float _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float;
        Unity_Add_float(_Divide_e2ea8f1b48be4860947707f9cd3fb90a_Out_2_Float, 0.5, _Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float);
        float _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        Unity_Saturate_float(_Add_f82472c54bd146c88f71c41c5dac1517_Out_2_Float, _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float);
        T_1 = _Saturate_a0f36396c5d54291b52ccb6f17e2dbe5_Out_1_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float
        {
        };
        
        void SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(float _T, float4 _A_Color, float3 _A_Normal, float _A_Metallic, float _A_AO, float _A_Smoothness, float4 _B_Color, float3 _B_Normal, float _B_Metallic, float _B_AO, float _B_Smoothness, Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float IN, out float4 Color_1, out float3 Normal_2, out float Metallic_3, out float AO_4, out float Smoothness_5)
        {
        float4 _Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4 = _A_Color;
        float4 _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4 = _B_Color;
        float _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float = _T;
        float4 _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Unity_Lerp_float4(_Property_320aa7e43fd34389ab124a964fd97d28_Out_0_Vector4, _Property_08ebb556cfb94c7fa9dac66d67fe74d2_Out_0_Vector4, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxxx), _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4);
        float3 _Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3 = _A_Normal;
        float3 _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3 = _B_Normal;
        float3 _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Unity_Lerp_float3(_Property_bcd4e88850754f72a18e411e80c5b1b5_Out_0_Vector3, _Property_f541a7d31ab948dc81f2a3357979bbc3_Out_0_Vector3, (_Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float.xxx), _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3);
        float _Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float = _A_Metallic;
        float _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float = _B_Metallic;
        float _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        Unity_Lerp_float(_Property_0d25def475504b0a97eb27be82fc5925_Out_0_Float, _Property_b48ffb94a026416dbfd0e275b945365c_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float);
        float _Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float = _A_AO;
        float _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float = _B_AO;
        float _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Unity_Lerp_float(_Property_064ce6f134484946b1cac4b6aaedcb99_Out_0_Float, _Property_86997373ca5b45b2a7488bba2cee4de9_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float);
        float _Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float = _A_Smoothness;
        float _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float = _B_Smoothness;
        float _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
        Unity_Lerp_float(_Property_eab30ddb0ca145d0812220dffee9880e_Out_0_Float, _Property_fe5346b2a29046d39a90c9b3d490a386_Out_0_Float, _Property_d1b6ee815fa74eb6ace539492a5e799b_Out_0_Float, _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float);
        Color_1 = _Lerp_bbd5e666b2f44f65b48bc420121007e8_Out_3_Vector4;
        Normal_2 = _Lerp_5012d3bdbe3741c7b6e95fa8d0f2c820_Out_3_Vector3;
        Metallic_3 = _Lerp_fc63b32a34ec4d1d90d0687cdf56501f_Out_3_Float;
        AO_4 = _Lerp_cb79114e39aa46e0bd1617981f9434c2_Out_3_Float;
        Smoothness_5 = _Lerp_af5d59751dd641f69db385619564e461_Out_3_Float;
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f09a201765874490a237364f838131d2_Out_0_Vector4 = _A_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float = _A_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D = UnityBuildTexture2DStruct(_A_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e;
            float4 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4;
            float3 _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float;
            float _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f09a201765874490a237364f838131d2_Out_0_Vector4, _Property_3c803b6587a1451d89fc8bbc0e70533d_Out_0_Texture2D, _Property_a0b13264b72443c2901fe382603f978a_Out_0_Texture2D, _Property_b60f3935824b4bffa99ea4649c00cedb_Out_0_Float, _Property_20598cbb86414f048a97f4599edf7323_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float4 _Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4 = _B_Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Albedo);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Normal);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float = _B_NormalStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            UnityTexture2D _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D = UnityBuildTexture2DStruct(_B_Mask);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2;
            float4 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4;
            float3 _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float;
            float _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float;
            SG_TextureSetSample_512ec69e4bb8eb2468b87787b6808f9d_float(_Property_f69fa46575bb486cbe079dab8471720e_Out_0_Vector4, _Property_619b55fdf7cd4c2daae2085e2312104b_Out_0_Texture2D, _Property_8a7f0b7cec804966959ea63ce84de39f_Out_0_Texture2D, _Property_4b75eb3d52614743bc09357a3c928b0a_Out_0_Float, _Property_e49ef6ebc1534f05bc7d134edaf8f743_Out_0_Texture2D, (_UV_b5799b13a4b84894a484c9b7ca3625d3_Out_0_Vector4.xy), _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Split_d82cd51480da4b718a048f502e999e2e_R_1_Float = IN.VertexColor[0];
            float _Split_d82cd51480da4b718a048f502e999e2e_G_2_Float = IN.VertexColor[1];
            float _Split_d82cd51480da4b718a048f502e999e2e_B_3_Float = IN.VertexColor[2];
            float _Split_d82cd51480da4b718a048f502e999e2e_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float = _NoiseScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(IN.uv0.xy, _Property_281b0968ff214220a79f8dd9eec6bbd7_Out_0_Float, _SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float;
            Unity_Remap_float(_SimpleNoise_3173f4e9fb1b4cf9b3380c0dbbf6fb1e_Out_2_Float, float2 (0, 1), float2 (0.1, 0.9), _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float = _NoiseStrength;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float;
            Unity_Blend_Overlay_float(_Split_d82cd51480da4b718a048f502e999e2e_R_1_Float, _Remap_95274faec9344e7c953d1178b0732b26_Out_3_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_63be7d9f45b644e7a78ca4e376b89219_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            float _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float = _Softness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_HeightBlend_11ccc881c423579419598f74217b7e2a_float _HeightBlend_81190b36918d4bf99f5176b783c52196;
            float _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float;
            SG_HeightBlend_11ccc881c423579419598f74217b7e2a_float(_TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Height_5_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Height_5_Float, _Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float, _Property_cb3c7b06c2de4a0e8bd71b91625ce844_Out_0_Float, _HeightBlend_81190b36918d4bf99f5176b783c52196, _HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            Bindings_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49;
            float4 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            float3 _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float;
            float _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float;
            SG_TextureSetBlend_37c5103dc8d06c7418b6c4bf670bae1d_float(_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Color_1_Vector4, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Normal_6_Vector3, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Metallic_2_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_AmbientOcclusion_4_Float, _TextureSetSample_1e402cc2ea7143f8a69f6eedeb518c1e_Smoothness_3_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Color_1_Vector4, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Normal_6_Vector3, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Metallic_2_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_AmbientOcclusion_4_Float, _TextureSetSample_89aeffe08c8d4c6a9a66dabd552e68e2_Smoothness_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Normal_2_Vector3, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Metallic_3_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_AO_4_Float, _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Smoothness_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = _TextureSetBlend_01a9b9961ff045f29180e188c337ad49_Color_1_Vector4;
            #elif defined(_DEBUG_BLEND)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_HeightBlend_81190b36918d4bf99f5176b783c52196_T_1_Float.xxxx);
            #elif defined(_DEBUG_VERTEXCOLOR)
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = IN.VertexColor;
            #else
            float4 _Debug_b164672404df4d84942f18527891a518_Out_0_Vector4 = (_Blend_f1ce507c4d64425095af92c42a5c3094_Out_2_Float.xxxx);
            #endif
            #endif
            surface.BaseColor = (_Debug_b164672404df4d84942f18527891a518_Out_0_Vector4.xyz);
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
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
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
        output.VertexColor = input.color;
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