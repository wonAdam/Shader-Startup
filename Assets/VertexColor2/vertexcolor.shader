Shader "Custom/vertexcolor"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex4 ("Albedo (RGB)", 2D) = "white" {}

        _Metallic("Metallic", Range(0,1)) = 0
        _Smoothness("Smoothness", Range(0,1)) = 0


        _BumpMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard noambient
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;

        sampler2D _BumpMap;

        float _Metallic;
        float _Smoothness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float2 uv_MainTex4;

            float2 uv_BumpMap;

            float4 color:Color;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D (_MainTex2, IN.uv_MainTex2);
            fixed4 e = tex2D (_MainTex3, IN.uv_MainTex3);
            fixed4 f = tex2D (_MainTex4, IN.uv_MainTex4);

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            o.Albedo = d.rgb*IN.color.r + c.rgb * IN.color.g + e.rgb*IN.color.b + f.rgb * (1-(IN.color.r + IN.color.g + IN.color.b));

            o.Metallic = _Metallic;
            // 4번째 Texture는 b채널이니깐 4번째 텍스쳐부분만 젖게 해보자
            o.Smoothness = _Smoothness*(IN.color.g*2) + 0.3;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
