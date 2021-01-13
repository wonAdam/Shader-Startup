Shader "Custom/fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("BumpMap", 2D) = "bump" {}
        _RimColor ("RimColor", color) = (1,1,1,1)
        _RimPower ("RimPower", Range(0,10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_BumpMap;
            float2 uv_MainTex;
            float3 viewDir;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            float rim = saturate(dot(o.Normal, IN.viewDir));
            o.Emission = _RimColor.rgb * pow(1 - rim, _RimPower);
            
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
