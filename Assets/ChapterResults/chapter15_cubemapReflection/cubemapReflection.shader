Shader "Custom/cubemapReflection"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("BumpMap", 2D) = "bump" {}
        _Cube("Cubemap", Cube) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldRefl;
            INTERNAL_DATA
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            o.Albedo = c.rgb * 0;
            o.Emission = re.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
