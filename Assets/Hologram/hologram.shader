Shader "Custom/hologram"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimPower("RimPower", Range(0,5)) = 2
        _RimColor("RimColor (RGB)", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" } // "Queue" = "Transparent"
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        float _RimPower;
        float4 _RimColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            float rim = saturate(dot(o.Normal, IN.viewDir));
            o.Emission = pow(1-rim, _RimPower) * _RimColor;
            o.Alpha = pow(1-rim, _RimPower) * abs(sin(_Time.z)) + 0.2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
