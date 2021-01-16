Shader "Custom/depth"
{

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert noambient noshadow
        #pragma target 3.0

        sampler2D _CameraDepthTexture;

        struct Input
        {
            float4 screenPos;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
            float4 Depth = tex2D(_CameraDepthTexture, sPos);
            o.Emission = Depth.r;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack off
}
