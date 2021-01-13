Shader "Custom/FresnelToon"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("BumpMap (RGB)", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonLight 
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

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

        float4 LightingToonLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = saturate(dot(s.Normal, lightDir));
            if(ndotl > 0.7)
            {
                ndotl = 1;
            }
            else if(ndotl > 0.2)
            {
                ndotl = 0.5;
            }
            else ndotl = 0.2;

            float rim = abs(dot(s.Normal, viewDir));
            if (rim > 0.3)
                rim = 1;
            else rim = -1;


            float4 final;

            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * rim;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
