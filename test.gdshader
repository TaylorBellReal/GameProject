shader_type spatial;

// Uniforms
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform vec3 scroll_direction = vec3(1.0, 0.0, 0.0);

void vertex() {
    // Calculate the amount of movement based on the elapsed time and speed
    float movement = TIME * speed;

    // Manipulate the UV coordinates based on the scroll direction
    UV.xy += movement * scroll_direction.xy;
    UV.y += sin(UV.x * 10.0) * 0.1;
}