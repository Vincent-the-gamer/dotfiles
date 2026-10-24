#language slang 2026
// Fluorescent / neon text glow for kitty.
//
// Last pass of the effect: add the blurred emission (texture b) back on top of
// the frame, and optionally make the text itself a little punchier.
import kitty_custom_shader_types;

// How much of the blurred light is added back on top of the text. This is the
// main "how strong is the glow" knob. 0.3 = subtle, 0.8 = clearly neon,
// 2.0 = very strong.
static const float GLOW_INTENSITY = 0.8;

// Soft knee for the glow. Dense areas (a block of text, ASCII art) would
// otherwise add up into a flat wash that lifts the whole background. The glow
// is scaled by 1 / (1 + luminance * GLOW_ROLLOFF), so the more light there is
// the less each additional bit counts. Set to 0 for pure linear addition.
static const float GLOW_ROLLOFF = 1.0;

// Extra brightness for the text itself (fraction of its excess over the
// background). 0 disables it, try 0.1 - 0.5.
static const float TEXT_BOOST = 0.1;

// Must match the values in neon-blur.slang so that exactly the same pixels are
// boosted as are made to glow.
static const float GLOW_THRESHOLD = 0.12;
static const float GLOW_SOFTNESS = 0.25;

static float
luma(float3 c) {
    return dot(c, float3(0.2126, 0.7152, 0.0722));
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float3 glow = t.b.Sample(t.pos).rgb * GLOW_INTENSITY;
    // Hue preserving soft limit, see GLOW_ROLLOFF above.
    glow /= 1.0 + luma(glow) * GLOW_ROLLOFF;
    float3 excess = max(color.rgb - d.background.rgb, float3(0.0));
    float m = smoothstep(GLOW_THRESHOLD, GLOW_THRESHOLD + GLOW_SOFTNESS, luma(excess));
    color.rgb += glow + excess * m * TEXT_BOOST;
    // Keep the frame's alpha so background_opacity keeps working; the final
    // premultiply by kitty scales the added light with it.
    return color;
}
