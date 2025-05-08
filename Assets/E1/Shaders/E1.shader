Shader "AA2/E1"
{
    Properties // Variable en inspector
    {
        _MainTex ("Texture", 2D) = "white" {}

        [HDR] _Color ("Color", Color) = (0,1,0,1)
        _Texture_Speed ("Texture Speed", Float) = 1
        _Scanline_Speed ("Scanline Speed", Float) = -0.1
        _Texture_Tiling ("Texture Tiling", Vector) = (16,20,0,0)
        _Scanline_Density ("Scanline Density", Float) = 50
        _Fresnel_Power ("Fresnel Power", Float) = 5
        _Depth_Blend ("Depth Blend", Float) = 0.5
        _Scale ("Scale", Float) = 0.5

    }
    SubShader
    {
        Tags // Layers que se renderizan
        { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
        }
        LOD 100 // Level of detail

        Pass // Orden de ejecucción 
        {
            Blend SrcAlpha OneMinusSrcAlpha // Transparencia clásica
            ZWrite Off // Otros objetos detrás sean visibles

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata // variables del vertex shader
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenSpace : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
            };

            // Repetir variables
            sampler2D _MainTex; 
            float4 _MainTex_ST;

            // PUBLIC
            float4 _Color;
            float _Texture_Speed;
            float _Scanline_Speed;
            float4 _Texture_Tiling;
            float _Scanline_Density;
            float _Fresnel_Power;
            float _Depth_Blend;
            float _Scale;

            // PRIVATE
            sampler2D _CameraDepthTexture; // Necesario para samplear profundidad

            v2f vert (appdata v) // vertex shader
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                // Equivalente a la screen position raw
                o.screenSpace = ComputeScreenPos(o.vertex);

                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                return o;
            }

            //// FUNCTIONS ////
            float Remap(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            float Scanlines(float2 _screenSpaceUV, float _scanline_density, float _scanline_speed)
            {
                float a = frac(_scanline_speed * _Time.y);
                float b = _screenSpaceUV.g;

                float remap = Remap(frac(_scanline_density * (a + b)), float2(0, 1), float2(-0.5, 0.5));

                return abs(remap); 
            }

            float Intersection(v2f _i, float _depth, float _depth_blend)
            {
                // Calcular diferencia
                float depthDifference = _depth - (_i.screenSpace.a - _depth_blend);

                // Invertir y saturar
                return 1 - saturate(depthDifference);
            }

            float Fresnel(v2f _i, float _fresnel_power)
            {
               return pow((1.0 - saturate(dot(normalize(_i.normal), _i.viewDir))), _fresnel_power);
            }

            float BlendSoftLight(float _base, float _blend, float _opacity)
            {
                float result1 = ((_base * 2.f) * _blend) + ((1 - (_blend * 2.f)) * _base * _base);
                float result2 = (((_blend * 2) - 1) * sqrt(_base)) + ((_base * 2) * (1 - _blend));
                float binary = step(0.5, _blend); // if(blend >= 0.5 ? 1 : 0

                float finalResult = ((1- binary) * result1) + (result2 * binary);
            
                return lerp(_base, finalResult, _opacity);
            }

            float Hexagons(v2f _i)
            {
              float2 velocity = float2(0.0f, _Time.y * _Texture_Speed);
              float2 TilingAndOffset = _i.uv * _Texture_Tiling + velocity;

              float y = TilingAndOffset.y + (0.5f * fmod(floor(TilingAndOffset.x * 1.5f), 2));

              float2 result1 = float2(TilingAndOffset.x * 1.5f, y);

              float2 result2 = abs((fmod(result1, float2(1,1)) - float2(0.5f, 0.5f)));

              return 1 - saturate(smoothstep(0,0.5f,abs(max(((result2.x * 1.5f) + result2.y), result2.y * 2) - _Scale) * 2));
            }
            //// END FUNCTIONS ////
            
            fixed4 frag (v2f i) : SV_Target // fragment shader
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float2 screenSpaceUV = i.screenSpace.xy / i.screenSpace.w;
                float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screenSpaceUV));

                // Calculate base
                float intersection = Intersection(i, depth, _Depth_Blend);
                float fresnel = Fresnel(i, _Fresnel_Power);
                float base = intersection + fresnel;
                float hexagons = Hexagons(i);

                // Calculate blend
                float scanlines = Scanlines(screenSpaceUV, _Scanline_Density, _Scanline_Speed); 

                col.a = BlendSoftLight(fresnel + intersection ,  scanlines * hexagons, 1);
                
                col.xyz = _Color.xyz;

                return col ;
            }
            ENDCG
        }
    }
}
