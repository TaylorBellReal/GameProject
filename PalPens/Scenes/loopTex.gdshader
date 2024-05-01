shader_type spatial;

// Uniforms
uniform float tiling_factor : hint_range(0.1, 10.0) = 1.0;

void vertex() {
    // Shrink and loop the texture by adjusting the UV coordinates
    UV *= tiling_factor;
    UV = fract(UV);
}
