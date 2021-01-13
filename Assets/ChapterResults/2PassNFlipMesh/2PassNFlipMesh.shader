Shader "Custom/2PassNFlipMesh"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        cull front
        // 1st pass
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient
        #pragma target 3.0

        sampler2D _MainTex;

        void vert(inout appdata_full v)
        {
            v.vertex.xyz += (v.normal.xyz * 0.005);
        }

        struct Input
        {
            float4 color:Color;
        };


        void surf (Input IN, inout SurfaceOutput o){ }

        float4 LightingNolight(SurfaceOutput s, float lightDir, float atten)
        {
            return float4(0,0,0,1);
        }

        ENDCG

        cull back
        // 2nd pass
        CGPROGRAM
        #pragma surface surf Toon
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = saturate(dot(s.Normal, lightDir));

            if(ndotl > 0.7)
            {
                ndotl = 1;
            }
            else if(ndotl > 0.3)
            {
                ndotl = 0.3;
            }
            else
            {
                ndotl = 0;
            }
            return  ndotl;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
