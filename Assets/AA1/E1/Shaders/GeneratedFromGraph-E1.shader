Shader "Shader Graphs/E1-Compiled"
{
    Properties
    {
        [KeywordEnum(Disabled, Texture, Scanlines, Fresnel, Intersection)]_DEBUG("Debug", Float) = 0
        [HDR]_Color("_Color", Color) = (0, 6.933769, 23.96863, 1)
        _Texture_Speed("_Texture_Speed", Float) = 1
        _Texture_Tiling("_Texture_Tiling", Vector) = (16, 20, 0, 0)
        _Scanline_Speed("_Scanline_Speed", Float) = -0.1
        _Scanline_Density("_Scanline_Density", Float) = 50
        _Fresnel_Power("_Fresnel_Power", Float) = 5
        _Depth_Blend("_Depth_Blend", Float) = 0.5
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
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
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
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TEXTURE _DEBUG_SCANLINES _DEBUG_FRESNEL _DEBUG_INTERSECTION
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TEXTURE)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_SCANLINES)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_DEBUG_FRESNEL)
            #define KEYWORD_PERMUTATION_3
        #else
            #define KEYWORD_PERMUTATION_4
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 TimeParameters;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Scanline_Density;
        float _Texture_Speed;
        float _Scanline_Speed;
        float2 _Texture_Tiling;
        float _Fresnel_Power;
        float _Depth_Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Modulo_float2(float2 A, float2 B, out float2 Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        struct Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float
        {
        };
        
        void SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(float2 _tiling, float _scale, float _edge, float2 _Vector2, Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float IN, out float Out_1)
        {
        float _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float = _edge;
        float2 _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2 = _tiling;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[0];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[1];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_B_3_Float = 0;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_A_4_Float = 0;
        float _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float, _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float);
        float _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float;
        Unity_Floor_float(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float);
        float _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float;
        Unity_Modulo_float(_Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float, 2, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float);
        float _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float;
        Unity_Multiply_float_float(0.5, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float);
        float _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float;
        Unity_Add_float(_Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2 = float2(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2;
        Unity_Modulo_float2(_Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2, float2(1, 1), _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2);
        float2 _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2;
        Unity_Subtract_float2(_Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2, float2(0.5, 0.5), _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2);
        float2 _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2;
        Unity_Absolute_float2(_Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2, _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2);
        float _Split_a67e597f5f79af8da6821647925258c4_R_1_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[0];
        float _Split_a67e597f5f79af8da6821647925258c4_G_2_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[1];
        float _Split_a67e597f5f79af8da6821647925258c4_B_3_Float = 0;
        float _Split_a67e597f5f79af8da6821647925258c4_A_4_Float = 0;
        float _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_a67e597f5f79af8da6821647925258c4_R_1_Float, _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float);
        float _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float;
        Unity_Add_float(_Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float, _Split_a67e597f5f79af8da6821647925258c4_G_2_Float, _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float);
        float _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float;
        Unity_Multiply_float_float(_Split_a67e597f5f79af8da6821647925258c4_G_2_Float, 2, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float);
        float _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float;
        Unity_Maximum_float(_Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float, _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float);
        float _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float = _scale;
        float _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float;
        Unity_Subtract_float(_Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float, _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float, _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float);
        float _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float;
        Unity_Absolute_float(_Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float, _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float);
        float _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float;
        Unity_Multiply_float_float(_Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float, 2, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float);
        float _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        Unity_Smoothstep_float(0, _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float, _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float);
        Out_1 = _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Blend_SoftLight_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 2.0 * Base * Blend + Base * Base * (1.0 - 2.0 * Blend);
            float result2 = sqrt(Base) * (2.0 * Blend - 1.0) + 2.0 * Base * (1.0 - Blend);
            float zeroOrOne = step(0.5, Blend);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _Property_6de9077b80524cbfb80d74dfaada2668_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2 = _Texture_Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_f660484577a94e1f98265f3d770d275d_Out_0_Float = _Texture_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float;
            Unity_Multiply_float_float(_Property_f660484577a94e1f98265f3d770d275d_Out_0_Float, IN.TimeParameters.x, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2 = float2(0, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2, _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2, _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34;
            float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float;
            SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(_TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2, 1, 0.5, float2 (0, 0), _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34, _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float;
            Unity_Saturate_float(_HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float, _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float;
            Unity_OneMinus_float(_Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float, _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float = _Scanline_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float;
            Unity_Multiply_float_float(_Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float, IN.TimeParameters.x, _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float;
            Unity_Fraction_float(_Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float, _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_28c75ce5becb463b92cb27ab67c718e9_R_1_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[0];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[1];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_B_3_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[2];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_A_4_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float;
            Unity_Add_float(_Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float, _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float, _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_5db063efb11646dda6d366be7f577813_Out_0_Float = _Scanline_Density;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float;
            Unity_Multiply_float_float(_Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float, _Property_5db063efb11646dda6d366be7f577813_Out_0_Float, _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float;
            Unity_Fraction_float(_Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float, _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float;
            Unity_Remap_float(_Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float, float2 (0, 1), float2 (-0.5, 0.5), _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float;
            Unity_Absolute_float(_Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float = _Fresnel_Power;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_8a50cc6697d548bdb48f7c117d322da2_R_1_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[0];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_G_2_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[1];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_B_3_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[2];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float = _Depth_Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float;
            Unity_Subtract_float(_Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float, _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float, _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float;
            Unity_Saturate_float(_Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float, _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float;
            Unity_OneMinus_float(_Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float, _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float4 _Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4 = _Property_6de9077b80524cbfb80d74dfaada2668_Out_0_Vector4;
            #elif defined(_DEBUG_TEXTURE)
            float4 _Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4 = (_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float.xxxx);
            #elif defined(_DEBUG_SCANLINES)
            float4 _Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4 = (_Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float.xxxx);
            #elif defined(_DEBUG_FRESNEL)
            float4 _Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4 = (_FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float.xxxx);
            #else
            float4 _Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4 = (_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float.xxxx);
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float;
            Unity_Add_float(_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float, _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            Unity_Blend_SoftLight_float(_Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float, _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float, 1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            #elif defined(_DEBUG_TEXTURE)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_SCANLINES)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_FRESNEL)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #else
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #endif
            #endif
            surface.BaseColor = (_Debug_c158d20c12ec4654a84f4bc3fa3a97f5_Out_0_Vector4.xyz);
            surface.Alpha = _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
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
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
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
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TEXTURE _DEBUG_SCANLINES _DEBUG_FRESNEL _DEBUG_INTERSECTION
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TEXTURE)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_SCANLINES)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_DEBUG_FRESNEL)
            #define KEYWORD_PERMUTATION_3
        #else
            #define KEYWORD_PERMUTATION_4
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 TimeParameters;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Scanline_Density;
        float _Texture_Speed;
        float _Scanline_Speed;
        float2 _Texture_Tiling;
        float _Fresnel_Power;
        float _Depth_Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Modulo_float2(float2 A, float2 B, out float2 Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        struct Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float
        {
        };
        
        void SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(float2 _tiling, float _scale, float _edge, float2 _Vector2, Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float IN, out float Out_1)
        {
        float _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float = _edge;
        float2 _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2 = _tiling;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[0];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[1];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_B_3_Float = 0;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_A_4_Float = 0;
        float _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float, _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float);
        float _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float;
        Unity_Floor_float(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float);
        float _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float;
        Unity_Modulo_float(_Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float, 2, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float);
        float _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float;
        Unity_Multiply_float_float(0.5, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float);
        float _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float;
        Unity_Add_float(_Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2 = float2(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2;
        Unity_Modulo_float2(_Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2, float2(1, 1), _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2);
        float2 _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2;
        Unity_Subtract_float2(_Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2, float2(0.5, 0.5), _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2);
        float2 _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2;
        Unity_Absolute_float2(_Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2, _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2);
        float _Split_a67e597f5f79af8da6821647925258c4_R_1_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[0];
        float _Split_a67e597f5f79af8da6821647925258c4_G_2_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[1];
        float _Split_a67e597f5f79af8da6821647925258c4_B_3_Float = 0;
        float _Split_a67e597f5f79af8da6821647925258c4_A_4_Float = 0;
        float _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_a67e597f5f79af8da6821647925258c4_R_1_Float, _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float);
        float _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float;
        Unity_Add_float(_Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float, _Split_a67e597f5f79af8da6821647925258c4_G_2_Float, _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float);
        float _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float;
        Unity_Multiply_float_float(_Split_a67e597f5f79af8da6821647925258c4_G_2_Float, 2, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float);
        float _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float;
        Unity_Maximum_float(_Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float, _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float);
        float _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float = _scale;
        float _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float;
        Unity_Subtract_float(_Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float, _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float, _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float);
        float _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float;
        Unity_Absolute_float(_Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float, _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float);
        float _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float;
        Unity_Multiply_float_float(_Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float, 2, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float);
        float _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        Unity_Smoothstep_float(0, _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float, _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float);
        Out_1 = _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_SoftLight_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 2.0 * Base * Blend + Base * Base * (1.0 - 2.0 * Blend);
            float result2 = sqrt(Base) * (2.0 * Blend - 1.0) + 2.0 * Base * (1.0 - Blend);
            float zeroOrOne = step(0.5, Blend);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_8a50cc6697d548bdb48f7c117d322da2_R_1_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[0];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_G_2_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[1];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_B_3_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[2];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float = _Depth_Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float;
            Unity_Subtract_float(_Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float, _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float, _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float;
            Unity_Saturate_float(_Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float, _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float;
            Unity_OneMinus_float(_Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float, _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float = _Fresnel_Power;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float;
            Unity_Add_float(_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float, _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2 = _Texture_Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_f660484577a94e1f98265f3d770d275d_Out_0_Float = _Texture_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float;
            Unity_Multiply_float_float(_Property_f660484577a94e1f98265f3d770d275d_Out_0_Float, IN.TimeParameters.x, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2 = float2(0, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2, _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2, _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34;
            float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float;
            SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(_TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2, 1, 0.5, float2 (0, 0), _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34, _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float;
            Unity_Saturate_float(_HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float, _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float;
            Unity_OneMinus_float(_Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float, _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float = _Scanline_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float;
            Unity_Multiply_float_float(_Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float, IN.TimeParameters.x, _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float;
            Unity_Fraction_float(_Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float, _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_28c75ce5becb463b92cb27ab67c718e9_R_1_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[0];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[1];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_B_3_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[2];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_A_4_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float;
            Unity_Add_float(_Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float, _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float, _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_5db063efb11646dda6d366be7f577813_Out_0_Float = _Scanline_Density;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float;
            Unity_Multiply_float_float(_Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float, _Property_5db063efb11646dda6d366be7f577813_Out_0_Float, _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float;
            Unity_Fraction_float(_Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float, _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float;
            Unity_Remap_float(_Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float, float2 (0, 1), float2 (-0.5, 0.5), _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float;
            Unity_Absolute_float(_Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            Unity_Blend_SoftLight_float(_Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float, _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float, 1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            #elif defined(_DEBUG_TEXTURE)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_SCANLINES)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_FRESNEL)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #else
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #endif
            #endif
            surface.Alpha = _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
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
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TEXTURE _DEBUG_SCANLINES _DEBUG_FRESNEL _DEBUG_INTERSECTION
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TEXTURE)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_SCANLINES)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_DEBUG_FRESNEL)
            #define KEYWORD_PERMUTATION_3
        #else
            #define KEYWORD_PERMUTATION_4
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 TimeParameters;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Scanline_Density;
        float _Texture_Speed;
        float _Scanline_Speed;
        float2 _Texture_Tiling;
        float _Fresnel_Power;
        float _Depth_Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Modulo_float2(float2 A, float2 B, out float2 Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        struct Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float
        {
        };
        
        void SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(float2 _tiling, float _scale, float _edge, float2 _Vector2, Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float IN, out float Out_1)
        {
        float _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float = _edge;
        float2 _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2 = _tiling;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[0];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[1];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_B_3_Float = 0;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_A_4_Float = 0;
        float _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float, _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float);
        float _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float;
        Unity_Floor_float(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float);
        float _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float;
        Unity_Modulo_float(_Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float, 2, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float);
        float _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float;
        Unity_Multiply_float_float(0.5, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float);
        float _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float;
        Unity_Add_float(_Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2 = float2(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2;
        Unity_Modulo_float2(_Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2, float2(1, 1), _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2);
        float2 _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2;
        Unity_Subtract_float2(_Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2, float2(0.5, 0.5), _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2);
        float2 _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2;
        Unity_Absolute_float2(_Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2, _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2);
        float _Split_a67e597f5f79af8da6821647925258c4_R_1_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[0];
        float _Split_a67e597f5f79af8da6821647925258c4_G_2_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[1];
        float _Split_a67e597f5f79af8da6821647925258c4_B_3_Float = 0;
        float _Split_a67e597f5f79af8da6821647925258c4_A_4_Float = 0;
        float _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_a67e597f5f79af8da6821647925258c4_R_1_Float, _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float);
        float _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float;
        Unity_Add_float(_Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float, _Split_a67e597f5f79af8da6821647925258c4_G_2_Float, _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float);
        float _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float;
        Unity_Multiply_float_float(_Split_a67e597f5f79af8da6821647925258c4_G_2_Float, 2, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float);
        float _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float;
        Unity_Maximum_float(_Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float, _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float);
        float _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float = _scale;
        float _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float;
        Unity_Subtract_float(_Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float, _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float, _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float);
        float _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float;
        Unity_Absolute_float(_Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float, _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float);
        float _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float;
        Unity_Multiply_float_float(_Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float, 2, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float);
        float _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        Unity_Smoothstep_float(0, _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float, _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float);
        Out_1 = _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_SoftLight_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 2.0 * Base * Blend + Base * Base * (1.0 - 2.0 * Blend);
            float result2 = sqrt(Base) * (2.0 * Blend - 1.0) + 2.0 * Base * (1.0 - Blend);
            float zeroOrOne = step(0.5, Blend);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_8a50cc6697d548bdb48f7c117d322da2_R_1_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[0];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_G_2_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[1];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_B_3_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[2];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float = _Depth_Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float;
            Unity_Subtract_float(_Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float, _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float, _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float;
            Unity_Saturate_float(_Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float, _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float;
            Unity_OneMinus_float(_Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float, _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float = _Fresnel_Power;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float;
            Unity_Add_float(_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float, _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2 = _Texture_Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_f660484577a94e1f98265f3d770d275d_Out_0_Float = _Texture_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float;
            Unity_Multiply_float_float(_Property_f660484577a94e1f98265f3d770d275d_Out_0_Float, IN.TimeParameters.x, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2 = float2(0, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2, _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2, _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34;
            float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float;
            SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(_TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2, 1, 0.5, float2 (0, 0), _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34, _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float;
            Unity_Saturate_float(_HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float, _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float;
            Unity_OneMinus_float(_Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float, _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float = _Scanline_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float;
            Unity_Multiply_float_float(_Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float, IN.TimeParameters.x, _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float;
            Unity_Fraction_float(_Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float, _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_28c75ce5becb463b92cb27ab67c718e9_R_1_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[0];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[1];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_B_3_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[2];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_A_4_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float;
            Unity_Add_float(_Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float, _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float, _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_5db063efb11646dda6d366be7f577813_Out_0_Float = _Scanline_Density;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float;
            Unity_Multiply_float_float(_Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float, _Property_5db063efb11646dda6d366be7f577813_Out_0_Float, _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float;
            Unity_Fraction_float(_Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float, _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float;
            Unity_Remap_float(_Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float, float2 (0, 1), float2 (-0.5, 0.5), _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float;
            Unity_Absolute_float(_Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            Unity_Blend_SoftLight_float(_Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float, _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float, 1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            #elif defined(_DEBUG_TEXTURE)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_SCANLINES)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_FRESNEL)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #else
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #endif
            #endif
            surface.Alpha = _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
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
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TEXTURE _DEBUG_SCANLINES _DEBUG_FRESNEL _DEBUG_INTERSECTION
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TEXTURE)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_SCANLINES)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_DEBUG_FRESNEL)
            #define KEYWORD_PERMUTATION_3
        #else
            #define KEYWORD_PERMUTATION_4
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 TimeParameters;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Scanline_Density;
        float _Texture_Speed;
        float _Scanline_Speed;
        float2 _Texture_Tiling;
        float _Fresnel_Power;
        float _Depth_Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Modulo_float2(float2 A, float2 B, out float2 Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        struct Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float
        {
        };
        
        void SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(float2 _tiling, float _scale, float _edge, float2 _Vector2, Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float IN, out float Out_1)
        {
        float _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float = _edge;
        float2 _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2 = _tiling;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[0];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[1];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_B_3_Float = 0;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_A_4_Float = 0;
        float _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float, _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float);
        float _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float;
        Unity_Floor_float(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float);
        float _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float;
        Unity_Modulo_float(_Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float, 2, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float);
        float _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float;
        Unity_Multiply_float_float(0.5, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float);
        float _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float;
        Unity_Add_float(_Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2 = float2(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2;
        Unity_Modulo_float2(_Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2, float2(1, 1), _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2);
        float2 _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2;
        Unity_Subtract_float2(_Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2, float2(0.5, 0.5), _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2);
        float2 _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2;
        Unity_Absolute_float2(_Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2, _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2);
        float _Split_a67e597f5f79af8da6821647925258c4_R_1_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[0];
        float _Split_a67e597f5f79af8da6821647925258c4_G_2_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[1];
        float _Split_a67e597f5f79af8da6821647925258c4_B_3_Float = 0;
        float _Split_a67e597f5f79af8da6821647925258c4_A_4_Float = 0;
        float _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_a67e597f5f79af8da6821647925258c4_R_1_Float, _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float);
        float _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float;
        Unity_Add_float(_Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float, _Split_a67e597f5f79af8da6821647925258c4_G_2_Float, _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float);
        float _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float;
        Unity_Multiply_float_float(_Split_a67e597f5f79af8da6821647925258c4_G_2_Float, 2, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float);
        float _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float;
        Unity_Maximum_float(_Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float, _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float);
        float _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float = _scale;
        float _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float;
        Unity_Subtract_float(_Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float, _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float, _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float);
        float _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float;
        Unity_Absolute_float(_Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float, _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float);
        float _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float;
        Unity_Multiply_float_float(_Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float, 2, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float);
        float _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        Unity_Smoothstep_float(0, _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float, _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float);
        Out_1 = _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_SoftLight_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 2.0 * Base * Blend + Base * Base * (1.0 - 2.0 * Blend);
            float result2 = sqrt(Base) * (2.0 * Blend - 1.0) + 2.0 * Base * (1.0 - Blend);
            float zeroOrOne = step(0.5, Blend);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_8a50cc6697d548bdb48f7c117d322da2_R_1_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[0];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_G_2_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[1];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_B_3_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[2];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float = _Depth_Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float;
            Unity_Subtract_float(_Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float, _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float, _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float;
            Unity_Saturate_float(_Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float, _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float;
            Unity_OneMinus_float(_Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float, _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float = _Fresnel_Power;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float;
            Unity_Add_float(_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float, _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2 = _Texture_Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_f660484577a94e1f98265f3d770d275d_Out_0_Float = _Texture_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float;
            Unity_Multiply_float_float(_Property_f660484577a94e1f98265f3d770d275d_Out_0_Float, IN.TimeParameters.x, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2 = float2(0, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2, _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2, _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34;
            float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float;
            SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(_TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2, 1, 0.5, float2 (0, 0), _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34, _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float;
            Unity_Saturate_float(_HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float, _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float;
            Unity_OneMinus_float(_Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float, _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float = _Scanline_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float;
            Unity_Multiply_float_float(_Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float, IN.TimeParameters.x, _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float;
            Unity_Fraction_float(_Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float, _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_28c75ce5becb463b92cb27ab67c718e9_R_1_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[0];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[1];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_B_3_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[2];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_A_4_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float;
            Unity_Add_float(_Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float, _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float, _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_5db063efb11646dda6d366be7f577813_Out_0_Float = _Scanline_Density;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float;
            Unity_Multiply_float_float(_Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float, _Property_5db063efb11646dda6d366be7f577813_Out_0_Float, _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float;
            Unity_Fraction_float(_Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float, _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float;
            Unity_Remap_float(_Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float, float2 (0, 1), float2 (-0.5, 0.5), _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float;
            Unity_Absolute_float(_Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            Unity_Blend_SoftLight_float(_Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float, _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float, 1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            #elif defined(_DEBUG_TEXTURE)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_SCANLINES)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_FRESNEL)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #else
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #endif
            #endif
            surface.Alpha = _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
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
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #pragma shader_feature_local _DEBUG_DISABLED _DEBUG_TEXTURE _DEBUG_SCANLINES _DEBUG_FRESNEL _DEBUG_INTERSECTION
        
        #if defined(_DEBUG_DISABLED)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_DEBUG_TEXTURE)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_DEBUG_SCANLINES)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_DEBUG_FRESNEL)
            #define KEYWORD_PERMUTATION_3
        #else
            #define KEYWORD_PERMUTATION_4
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        #define REQUIRE_DEPTH_TEXTURE
        #endif
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
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 NDCPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float2 PixelPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 TimeParameters;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 positionWS : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             float3 normalWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Scanline_Density;
        float _Texture_Speed;
        float _Scanline_Speed;
        float2 _Texture_Tiling;
        float _Fresnel_Power;
        float _Depth_Blend;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Modulo_float2(float2 A, float2 B, out float2 Out)
        {
            Out = fmod(A, B);
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        struct Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float
        {
        };
        
        void SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(float2 _tiling, float _scale, float _edge, float2 _Vector2, Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float IN, out float Out_1)
        {
        float _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float = _edge;
        float2 _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2 = _tiling;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[0];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float = _Property_3c37fdea2f2393849f42e2ab1c17d623_Out_0_Vector2[1];
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_B_3_Float = 0;
        float _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_A_4_Float = 0;
        float _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_ec4d176bb7c0888aaa50d9d2141f8ab2_R_1_Float, _Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float);
        float _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float;
        Unity_Floor_float(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float);
        float _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float;
        Unity_Modulo_float(_Floor_fda6e33420cb098bbc4e4348442b564d_Out_1_Float, 2, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float);
        float _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float;
        Unity_Multiply_float_float(0.5, _Modulo_5dedbffee9d5af839b1ae7631799e4b3_Out_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float);
        float _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float;
        Unity_Add_float(_Split_ec4d176bb7c0888aaa50d9d2141f8ab2_G_2_Float, _Multiply_81429557179b168ebee15641f7a6f012_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2 = float2(_Multiply_e1c38402c4e27a829eb8a879a85946f6_Out_2_Float, _Add_011d279ae54bd5898c3ffb1a7d4c108b_Out_2_Float);
        float2 _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2;
        Unity_Modulo_float2(_Vector2_c37863a01c2a6e83b8b8f0564aced3b9_Out_0_Vector2, float2(1, 1), _Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2);
        float2 _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2;
        Unity_Subtract_float2(_Modulo_4a298f0a5349bb81aa2648907b930be4_Out_2_Vector2, float2(0.5, 0.5), _Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2);
        float2 _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2;
        Unity_Absolute_float2(_Subtract_620c7f298c4db9859ff68f1b681d3d33_Out_2_Vector2, _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2);
        float _Split_a67e597f5f79af8da6821647925258c4_R_1_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[0];
        float _Split_a67e597f5f79af8da6821647925258c4_G_2_Float = _Absolute_82fa645a6d76768e81b16c1264b2ebab_Out_1_Vector2[1];
        float _Split_a67e597f5f79af8da6821647925258c4_B_3_Float = 0;
        float _Split_a67e597f5f79af8da6821647925258c4_A_4_Float = 0;
        float _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float;
        Unity_Multiply_float_float(1.5, _Split_a67e597f5f79af8da6821647925258c4_R_1_Float, _Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float);
        float _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float;
        Unity_Add_float(_Multiply_d6b75e862a379b868c8a7574e3ead437_Out_2_Float, _Split_a67e597f5f79af8da6821647925258c4_G_2_Float, _Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float);
        float _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float;
        Unity_Multiply_float_float(_Split_a67e597f5f79af8da6821647925258c4_G_2_Float, 2, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float);
        float _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float;
        Unity_Maximum_float(_Add_8eb27aba22a3128da5476346686c30e0_Out_2_Float, _Multiply_2e68df5428e25e8498465a3dbb50a936_Out_2_Float, _Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float);
        float _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float = _scale;
        float _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float;
        Unity_Subtract_float(_Maximum_f88e9595003eea8fa653d97f727e2a91_Out_2_Float, _Property_7ccb379b6695758eaded473f165e48cf_Out_0_Float, _Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float);
        float _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float;
        Unity_Absolute_float(_Subtract_428b6ff76803e18d825a2d88fb2a686f_Out_2_Float, _Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float);
        float _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float;
        Unity_Multiply_float_float(_Absolute_321aa5642a4a1a8fb3b1a54ceca808f6_Out_1_Float, 2, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float);
        float _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        Unity_Smoothstep_float(0, _Property_ad523d03d9c557848bd05c6d29e4f76f_Out_0_Float, _Multiply_835acd47380f758b982a50a8064ea46d_Out_2_Float, _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float);
        Out_1 = _Smoothstep_0cd10edc36bef589a04ab9b5be10c276_Out_3_Float;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Blend_SoftLight_float(float Base, float Blend, out float Out, float Opacity)
        {
            float result1 = 2.0 * Base * Blend + Base * Base * (1.0 - 2.0 * Blend);
            float result2 = sqrt(Base) * (2.0 * Blend - 1.0) + 2.0 * Base * (1.0 - Blend);
            float zeroOrOne = step(0.5, Blend);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4 = IN.ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_8a50cc6697d548bdb48f7c117d322da2_R_1_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[0];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_G_2_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[1];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_B_3_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[2];
            float _Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float = _ScreenPosition_a5f010caac954fdf82a24fc7c390dffa_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float = _Depth_Blend;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float;
            Unity_Subtract_float(_Split_8a50cc6697d548bdb48f7c117d322da2_A_4_Float, _Property_59f9eb1491d540e3a9ace4e39af54a15_Out_0_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1ca2a186d6ce4ee5939b55a55a7c7193_Out_1_Float, _Subtract_2d812940ea3e485ab7d9ec3f5348da61_Out_2_Float, _Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float;
            Unity_Saturate_float(_Subtract_c31f9c07ffcf4b3daec4ccf90ae386f9_Out_2_Float, _Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float;
            Unity_OneMinus_float(_Saturate_2cbcb89e382846bc98b728bb80c751e6_Out_1_Float, _OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float = _Fresnel_Power;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_d4cfb106563644648fc50ba280a6f8fd_Out_0_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float;
            Unity_Add_float(_OneMinus_3eb0ac18daac49bf84f4ee01ee5b9f56_Out_1_Float, _FresnelEffect_dd57db66cb20412ab23bed6dcf73d2b9_Out_3_Float, _Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2 = _Texture_Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_f660484577a94e1f98265f3d770d275d_Out_0_Float = _Texture_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float;
            Unity_Multiply_float_float(_Property_f660484577a94e1f98265f3d770d275d_Out_0_Float, IN.TimeParameters.x, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2 = float2(0, _Multiply_35bba425c0c24ce181cd7c44967c5de7_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float2 _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_b315b54597384264a6ae54e31af765d5_Out_0_Vector2, _Vector2_93bde2961bae432882b18e124a8f0182_Out_0_Vector2, _TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            Bindings_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34;
            float _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float;
            SG_HexLattice_ae6f2edd46e88d5459d149f7a35446e1_float(_TilingAndOffset_eb0b8b859ed946368999120eec8bd1e4_Out_3_Vector2, 1, 0.5, float2 (0, 0), _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34, _HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float;
            Unity_Saturate_float(_HexLattice_fbc1c8cc59af40b3b77349598f6c6e34_Out_1_Float, _Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float;
            Unity_OneMinus_float(_Saturate_a4cc68d5553044f0a1365683158b04cf_Out_1_Float, _OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float = _Scanline_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float;
            Unity_Multiply_float_float(_Property_82806e1c395d4b6890e0ff3aec8be707_Out_0_Float, IN.TimeParameters.x, _Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float;
            Unity_Fraction_float(_Multiply_427abf82bae847579265a47f37d1e3df_Out_2_Float, _Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float4 _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Split_28c75ce5becb463b92cb27ab67c718e9_R_1_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[0];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[1];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_B_3_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[2];
            float _Split_28c75ce5becb463b92cb27ab67c718e9_A_4_Float = _ScreenPosition_1cab876f2d6d40148ef6a0720bcc86cc_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float;
            Unity_Add_float(_Fraction_ff456065006a41db8f2ad9d0ca4f3833_Out_1_Float, _Split_28c75ce5becb463b92cb27ab67c718e9_G_2_Float, _Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Property_5db063efb11646dda6d366be7f577813_Out_0_Float = _Scanline_Density;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float;
            Unity_Multiply_float_float(_Add_56fe0423b3434762b72ca6ad66be0155_Out_2_Float, _Property_5db063efb11646dda6d366be7f577813_Out_0_Float, _Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float;
            Unity_Fraction_float(_Multiply_5f617f99ed8c4765bd36f11b7a16f6f2_Out_2_Float, _Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float;
            Unity_Remap_float(_Fraction_e2f8613bee69478b81bfb813f4411620_Out_1_Float, float2 (0, 1), float2 (-0.5, 0.5), _Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float;
            Unity_Absolute_float(_Remap_b0e913aea2144156ba39609d7f073aa9_Out_3_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_3fcd28249dc343cdaa7498b90b99642a_Out_1_Float, _Absolute_4b5b616173cc45d0b9454fc4dbbcd53e_Out_1_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            float _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            Unity_Blend_SoftLight_float(_Add_7a5cabaebb5847c1b93e0fae681e7e32_Out_2_Float, _Multiply_d7904eae20b24ab3ae93fb8e357f4e9b_Out_2_Float, _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float, 1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
            #if defined(_DEBUG_DISABLED)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = _Blend_d860ceee8f9843aebbe44e59345b1467_Out_2_Float;
            #elif defined(_DEBUG_TEXTURE)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_SCANLINES)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #elif defined(_DEBUG_FRESNEL)
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #else
            float _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float = 1;
            #endif
            #endif
            surface.Alpha = _Debug_12787e0c3f6c4e65a354962ceda29b51_Out_0_Float;
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
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
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
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.WorldSpacePosition = input.positionWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #else
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
        #endif
        
            #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4)
        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}