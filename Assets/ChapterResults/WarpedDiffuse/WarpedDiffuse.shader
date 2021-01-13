Shader "Custom/WarpedDiffuse"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("BumpMap", 2D) = "bump" {}
        _RampTex ("RampTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Warp noambient
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingWarp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            float4 ramp = tex2D(_RampTex, float2(ndotl, 0.5));

            float4 final;
            final.rgb = s.Albedo.rgb * ramp.rgb;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
