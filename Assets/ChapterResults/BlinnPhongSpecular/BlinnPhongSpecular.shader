Shader "Custom/BlinnPhongSpecular"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}  
        _BumpMap ("BumpMap", 2D) = "bump" {}
        _SpecCol ("Specular Color", Color) = (1,1,1,1)
        _SpecCol2 ("Specular Color2", Color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(0,100)) = 10
        _SpecPower2 ("Specular Power2", Range(0,100)) = 10
        _GlossTex ("Gloss Tex", 2D) = "white" {}
        _RimCol ("Rim Color", Color) = (1,1,1,1)
        _RimPow ("Rim Power", Range(0, 10)) = 6
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf CustomLambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _GlossTex;
        float4 _SpecCol;
        float4 _SpecCol2;
        float _SpecPower;
        float _SpecPower2;
        float4 _RimCol;
        float _RimPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 m = tex2D (_GlossTex, IN.uv_GlossTex);
            
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Gloss = m.a;
            o.Alpha = c.a;
        }

        float4 LightingCustomLambert (SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            // Lambert term
            float3 DiffColor;
            float ndotl = saturate(dot(s.Normal, lightDir));
            DiffColor = ndotl * s.Albedo * _LightColor0.rgb * atten;

            // Spec term
            float3 SpecColor;
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal,  H));
            spec = pow(spec, _SpecPower);
            SpecColor = _SpecCol.rgb * spec * s.Gloss;

            // Rim term
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invRim = 1-rim;
            rimColor = pow(invRim, _RimPow) * _RimCol;

            //Fake Spec term
            float3 SpecColor2;
            SpecColor2 = pow(rim, 50) * float3(0.2,0.2,0.2) * s.Gloss;


            // final term
            final.rgb = DiffColor.rgb + SpecColor.rgb + rimColor.rgb + SpecColor2.rgb;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
