Shader "Custom Shaders/GoodLooking Seethrough Walls Shader"
{
    Properties
    {
        [NoScaleOffset] Texture2D_35753c71f66b4b10bf764888c4f49d0e("Main Texture", 2D) = "white" {}
        Color_8cf524c62ca64cee9cd5f2d96f5e7287("Tint", Color) = (0, 0, 0, 0)
        _position("Player Position", Vector) = (0.5, 0.5, 0, 0)
        _size("Size", Float) = 0
        Vector1_b6a3a8da3e4447a9a46978910b414061("Smoothness", Range(0, 1)) = 0.5
        Vector1_85bec0fa64f0435991ef6d5f6d316e1e("Opacity", Range(0, 1)) = 1
        [NoScaleOffset]Texture2D_c3706140d10e4417b7f838f3bbc48cc8("Metallic Roughness", 2D) = "white" {}
        [NoScaleOffset]Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3("Normal", 2D) = "white" {}
        [NoScaleOffset]Texture2D_40264a56a84f42608e4f5149e5e0bb1c("Height", 2D) = "white" {}
        [NoScaleOffset]Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb("Occlusion", 2D) = "white" {}
        Vector2_b3c73e416eda49ba8354297887ad9424("Tiling", Vector) = (1, 1, 0, 0)
        Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc("Smoothness (1)", Range(0, 1)) = 0.7
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Transparent"
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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
    #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
    #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    UnityTexture2D _Property_7f12d27696814ceab41f702faf481490_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
    float4 _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f12d27696814ceab41f702faf481490_Out_0.tex, _Property_7f12d27696814ceab41f702faf481490_Out_0.samplerstate, IN.uv0.xy);
    _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0);
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_R_4 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.r;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_G_5 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.g;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_B_6 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.b;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_A_7 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.a;
    UnityTexture2D _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
    float4 _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.tex, _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.r;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.g;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_B_6 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.b;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_A_7 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.a;
    float _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0 = Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.NormalTS = (_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4;
    surface.Smoothness = _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0;
    surface.Occlusion = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5;
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

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
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
    #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    UnityTexture2D _Property_7f12d27696814ceab41f702faf481490_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
    float4 _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f12d27696814ceab41f702faf481490_Out_0.tex, _Property_7f12d27696814ceab41f702faf481490_Out_0.samplerstate, IN.uv0.xy);
    _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0);
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_R_4 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.r;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_G_5 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.g;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_B_6 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.b;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_A_7 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.a;
    UnityTexture2D _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
    float4 _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.tex, _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.r;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.g;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_B_6 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.b;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_A_7 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.a;
    float _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0 = Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.NormalTS = (_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4;
    surface.Smoothness = _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0;
    surface.Occlusion = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5;
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 NormalTS;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_7f12d27696814ceab41f702faf481490_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
    float4 _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f12d27696814ceab41f702faf481490_Out_0.tex, _Property_7f12d27696814ceab41f702faf481490_Out_0.samplerstate, IN.uv0.xy);
    _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0);
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_R_4 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.r;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_G_5 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.g;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_B_6 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.b;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_A_7 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.a;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.NormalTS = (_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.xyz);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

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
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 uv2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 Emission;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

    ENDHLSL
}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Transparent"
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
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
    #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
    #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        float3 viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        float2 lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 sh;
        #endif
        float4 fogFactorAndVertexLight;
        float4 shadowCoord;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        float3 interp4 : TEXCOORD4;
        #if defined(LIGHTMAP_ON)
        float2 interp5 : TEXCOORD5;
        #endif
        #if !defined(LIGHTMAP_ON)
        float3 interp6 : TEXCOORD6;
        #endif
        float4 interp7 : TEXCOORD7;
        float4 interp8 : TEXCOORD8;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
        output.interp4.xyz = input.viewDirectionWS;
        #if defined(LIGHTMAP_ON)
        output.interp5.xy = input.lightmapUV;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.interp6.xyz = input.sh;
        #endif
        output.interp7.xyzw = input.fogFactorAndVertexLight;
        output.interp8.xyzw = input.shadowCoord;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
        output.viewDirectionWS = input.interp4.xyz;
        #if defined(LIGHTMAP_ON)
        output.lightmapUV = input.interp5.xy;
        #endif
        #if !defined(LIGHTMAP_ON)
        output.sh = input.interp6.xyz;
        #endif
        output.fogFactorAndVertexLight = input.interp7.xyzw;
        output.shadowCoord = input.interp8.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 NormalTS;
    float3 Emission;
    float Metallic;
    float Smoothness;
    float Occlusion;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    UnityTexture2D _Property_7f12d27696814ceab41f702faf481490_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
    float4 _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f12d27696814ceab41f702faf481490_Out_0.tex, _Property_7f12d27696814ceab41f702faf481490_Out_0.samplerstate, IN.uv0.xy);
    _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0);
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_R_4 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.r;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_G_5 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.g;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_B_6 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.b;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_A_7 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.a;
    UnityTexture2D _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
    float4 _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.tex, _Property_4f51d4a534ad4d92accfcd2bc1b81a0d_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.r;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.g;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_B_6 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.b;
    float _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_A_7 = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_RGBA_0.a;
    float _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0 = Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.NormalTS = (_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Metallic = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_R_4;
    surface.Smoothness = _Property_8e6330f3db714dab835925d2ebcb0c59_Out_0;
    surface.Occlusion = _SampleTexture2D_7dd4ba3b6d324e72a9d659d6b09e7865_G_5;
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

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
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite On

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        float4 interp3 : TEXCOORD3;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        output.interp3.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        output.texCoord0 = input.interp3.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 NormalTS;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_7f12d27696814ceab41f702faf481490_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
    float4 _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f12d27696814ceab41f702faf481490_Out_0.tex, _Property_7f12d27696814ceab41f702faf481490_Out_0.samplerstate, IN.uv0.xy);
    _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0);
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_R_4 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.r;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_G_5 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.g;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_B_6 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.b;
    float _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_A_7 = _SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.a;
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.NormalTS = (_SampleTexture2D_1d8ace84c10f4c58a19749452aff97b3_RGBA_0.xyz);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

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
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 uv1 : TEXCOORD1;
        float4 uv2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float3 Emission;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.Emission = float3(0, 0, 0);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

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
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float4 texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyzw = input.texCoord0;
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
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.texCoord0 = input.interp1.xyzw;
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

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Texture2D_35753c71f66b4b10bf764888c4f49d0e_TexelSize;
float4 Color_8cf524c62ca64cee9cd5f2d96f5e7287;
float2 _position;
float _size;
float Vector1_b6a3a8da3e4447a9a46978910b414061;
float Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
float4 Texture2D_c3706140d10e4417b7f838f3bbc48cc8_TexelSize;
float4 Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3_TexelSize;
float4 Texture2D_40264a56a84f42608e4f5149e5e0bb1c_TexelSize;
float4 Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb_TexelSize;
float2 Vector2_b3c73e416eda49ba8354297887ad9424;
float Vector1_e70cd453bb0a43adbdcfc7cde2cdf1fc;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
SAMPLER(samplerTexture2D_35753c71f66b4b10bf764888c4f49d0e);
TEXTURE2D(Texture2D_c3706140d10e4417b7f838f3bbc48cc8);
SAMPLER(samplerTexture2D_c3706140d10e4417b7f838f3bbc48cc8);
TEXTURE2D(Texture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
SAMPLER(samplerTexture2D_c4cbc3ace2fb4d1b8fc9cdc465e55de3);
TEXTURE2D(Texture2D_40264a56a84f42608e4f5149e5e0bb1c);
SAMPLER(samplerTexture2D_40264a56a84f42608e4f5149e5e0bb1c);
TEXTURE2D(Texture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);
SAMPLER(samplerTexture2D_9dd65aa7bc3a4279a36b139e55ddf0fb);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
{
    Out = A * B;
}

void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
{
    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
{
    Out = A * B;
}

void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
{
    Out = A - B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
{
    Out = A / B;
}

void Unity_Length_float2(float2 In, out float Out)
{
    Out = length(In);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

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

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_f331019c42b94baba428224d541b9301_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_35753c71f66b4b10bf764888c4f49d0e);
    float2 _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0 = Vector2_b3c73e416eda49ba8354297887ad9424;
    float2 _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_29f8cc30bd794cc0b96484162de37a9b_Out_0, float2 (0, 0), _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float4 _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f331019c42b94baba428224d541b9301_Out_0.tex, _Property_f331019c42b94baba428224d541b9301_Out_0.samplerstate, _TilingAndOffset_fb8bb336e5374440ab0c9bc8138e64e7_Out_3);
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_R_4 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.r;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_G_5 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.g;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_B_6 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.b;
    float _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_A_7 = _SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0.a;
    float4 _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0 = Color_8cf524c62ca64cee9cd5f2d96f5e7287;
    float4 _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2;
    Unity_Multiply_float(_SampleTexture2D_82a8408bd94a4101a0fc04f4410b0c37_RGBA_0, _Property_d081ecd8d8784e23907ccc783d2af3f1_Out_0, _Multiply_5c4a64350f9e43e491781964f59496c0_Out_2);
    float _Property_b8645e0432dd4f6daf419c566114ed16_Out_0 = Vector1_b6a3a8da3e4447a9a46978910b414061;
    float4 _ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float2 _Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0 = _position;
    float2 _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3;
    Unity_Remap_float2(_Property_ddc7c7e670f94c7894434789ef4f2a8f_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3);
    float2 _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2;
    Unity_Add_float2((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), _Remap_f449dbfc57b74d62a6cc181c80bc8bfc_Out_3, _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2);
    float2 _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3;
    Unity_TilingAndOffset_float((_ScreenPosition_c4643b10b2ea4724b26ec8902000b776_Out_0.xy), float2 (1, 1), _Add_72c53675dd9c4c2498f4260515cc2d5d_Out_2, _TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3);
    float2 _Multiply_850628d1be91418e85aaabfa47490841_Out_2;
    Unity_Multiply_float(_TilingAndOffset_459e8faef62b49faabe3b84995cb3146_Out_3, float2(2, 2), _Multiply_850628d1be91418e85aaabfa47490841_Out_2);
    float2 _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2;
    Unity_Subtract_float2(_Multiply_850628d1be91418e85aaabfa47490841_Out_2, float2(1, 1), _Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2);
    float _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2;
    Unity_Divide_float(_ScreenParams.y, _ScreenParams.x, _Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2);
    float _Property_80ccd9c34eee456ca61d066472907ba3_Out_0 = _size;
    float _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2;
    Unity_Multiply_float(_Divide_e9db1993a068485a97dd52a9044d8fa7_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0, _Multiply_459446da27a14c8b9033c8539ee378ee_Out_2);
    float2 _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0 = float2(_Multiply_459446da27a14c8b9033c8539ee378ee_Out_2, _Property_80ccd9c34eee456ca61d066472907ba3_Out_0);
    float2 _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2;
    Unity_Divide_float2(_Subtract_499f204f9bbd4c19a6b363e4f165f41f_Out_2, _Vector2_d10d7e3498ee438e979356d00780a0b6_Out_0, _Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2);
    float _Length_4927b5d81004416a8f6987860042a9fa_Out_1;
    Unity_Length_float2(_Divide_72607ddcf37a465a9cf203f7d2aed4ef_Out_2, _Length_4927b5d81004416a8f6987860042a9fa_Out_1);
    float _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1;
    Unity_OneMinus_float(_Length_4927b5d81004416a8f6987860042a9fa_Out_1, _OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1);
    float _Saturate_4252338091344da7b15eb08f2d99887d_Out_1;
    Unity_Saturate_float(_OneMinus_bffcdbfe326b46b2832f6bf85af2ae21_Out_1, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1);
    float _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3;
    Unity_Smoothstep_float(0, _Property_b8645e0432dd4f6daf419c566114ed16_Out_0, _Saturate_4252338091344da7b15eb08f2d99887d_Out_1, _Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3);
    float _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0 = Vector1_85bec0fa64f0435991ef6d5f6d316e1e;
    float _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2;
    Unity_Multiply_float(_Smoothstep_490fbcd7f72f41f0a2c7fd863295fdde_Out_3, _Property_a89b9e1ef59a49639e013bdd67d2f520_Out_0, _Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2);
    float _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    Unity_OneMinus_float(_Multiply_0b66c17fb9984da7a02a749c0d07f23e_Out_2, _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1);
    surface.BaseColor = (_Multiply_5c4a64350f9e43e491781964f59496c0_Out_2.xyz);
    surface.Alpha = _OneMinus_ab5dd0fcfb8243ef9b016c1c62851005_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
    output.uv0 = input.texCoord0;
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

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

    ENDHLSL
}
    }
        CustomEditor "ShaderGraph.PBRMasterGUI"
        FallBack "Hidden/Shader Graph/FallbackError"
}