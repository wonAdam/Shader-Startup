Shader "Custom/Surface"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("NormalMap", 2D) = "bump" {}
        _Metallic ("Metallic", Range(0,1)) = 0
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _Occlusion("Occlusion", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Occlusion;

        float _Metallic;
        float _Smoothness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };



        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Occlusion = tex2D(_Occlusion, IN.uv_MainTex).r;

            fixed3 n = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            // fixed3 n = tex2D (_BumpMap, IN.uv_BumpMap);
            o.Normal = n;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness  = _Smoothness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
