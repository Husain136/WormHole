Shader "TerrainForMobile/VegetationT4M" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	Alphatest Greater 0
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	ColorMask RGB
	Pass {
		Tags { "LightMode" = "Vertex" }
		Material {
			Diffuse [_Color]
			Ambient [_Color]
		}
		Lighting On
		SetTexture [_MainTex] {
			Combine texture * primary DOUBLE, texture * primary
		} 
	}
	
	Pass {
		Tags { "LightMode" = "VertexLM" }
		
		BindChannels {
			Bind "Vertex", vertex
			Bind "normal", normal
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord", texcoord1 // main uses 1st uv
		}
		SetTexture [unity_Lightmap] {
			matrix [unity_LightmapMatrix]
			constantColor [_Color]
			combine texture * constant
		}
		SetTexture [_MainTex] {
			combine texture * previous DOUBLE, texture * primary
		}
	}

	Pass {
		Tags { "LightMode" = "VertexLMRGBM" }
		
		BindChannels {
			Bind "Vertex", vertex
			Bind "normal", normal
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord1", texcoord1 // unused
			Bind "texcoord", texcoord2 // main uses 1st uv
		}
		
		SetTexture [unity_Lightmap] {
			matrix [unity_LightmapMatrix]
			combine texture * texture alpha DOUBLE
		}
		SetTexture [unity_Lightmap] {
			constantColor [_Color]
			combine previous * constant
		}
		SetTexture [_MainTex] {
			combine texture * previous QUAD, texture * primary
		}
	}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	Alphatest Greater 0
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	ColorMask RGB
		
	Pass {
		Tags { "LightMode" = "Always" }
		Material {
			Diffuse [_Color]
			Ambient [_Color]
		}
		Lighting On
		SetTexture [_MainTex] {
			Combine texture * primary DOUBLE, texture * primary
		} 
	}	
}
}