#language slang 2026
// Fluorescent / neon text glow for kitty.
//
// Pass 1 of the effect: turn the rendered frame into an "emission" image (how
// much brighter than the background each pixel is, keeping its hue) and blur
// it along one axis. The pipeline file (neon-text.pipeline) runs this shader
// four times: horizontal + vertical with a small stride (tight core glow) and
// again with a large stride (wide halo), then composites the result.
//
// This shader is tuned via the pipeline, not by editing this file:
//     static const <type> <NAME> = <value>;
// is replaced by the pipeline's `var <type> <NAME> <value>` directive.
import kitty_custom_shader_types;

// Pixels whose colour is at least this much brighter than the background
// (linear RGB luminance) start to emit light. Raise this if dim text such as
// comments glows too much, lower it to make more of the screen neon.
static const float GLOW_THRESHOLD = 0.12;

// Width of the ramp above the threshold. Text this much brighter than the
// threshold glows at full strength.
static const float GLOW_SOFTNESS = 0.25;

// Ignore the tab bar and other window chrome (anything outside the central
// content area).
static const bool EXCLUDE_CHROME = false;

// Source texture for this pass:
//   0 = the rendered frame (extracts the emission, use for the first pass)
//   1 = named texture a
//   2 = named texture b
static const int SOURCE = 0;

// Blur direction: 0 = horizontal, 1 = vertical.
static const int AXIS = 0;

// Distance between taps, in device pixels. On a retina screen one logical
// point is two device pixels.
static const float STRIDE = 2.0;

// 7 tap Gaussian, sigma = 1.8 taps, normalised to sum to 1.
static const float WEIGHTS[7] = { 0.0581, 0.1257, 0.1998, 0.2330, 0.1998, 0.1257, 0.0581 };

static float
luma(float3 c) {
    return dot(c, float3(0.2126, 0.7152, 0.0722));
}

// How much light this pixel emits: its excess over the background colour,
// faded out for dim pixels so that the background itself stays dark.
// Antialiased glyph edges have less excess, which makes the glow fall off
// naturally around each character.
static float3
emission(float4 s, KittyCustomShaderData d, float chrome) {
    float3 e = max(s.rgb - d.background.rgb, float3(0.0));
    float m = smoothstep(GLOW_THRESHOLD, GLOW_THRESHOLD + GLOW_SOFTNESS, luma(e));
    return e * m * chrome;
}

// 1.0 inside the text area, 0.0 on the tab bar and window decorations.
static float
chrome_mask(KittyTextures t, KittyCustomShaderData d) {
    if (!EXCLUDE_CHROME) return 1.0;
    float2 lo = d.central_area.xy;
    float2 hi = lo + d.central_area.zw;
    return step(lo.x, t.pos.x) * step(t.pos.x, hi.x) * step(lo.y, t.pos.y) * step(t.pos.y, hi.y);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float2 dims = max(float2(d.viewport_size_pixels) * t.viewport.zw, float2(1.0));
    float2 texel = 1.0 / dims;
    float2 dir = (AXIS == 0) ? float2(1.0, 0.0) : float2(0.0, 1.0);
    float chrome = chrome_mask(t, d);
    float3 sum = float3(0.0);
    [ForceUnroll]
    for (int i = 0; i < 7; i++) {
        float offset = float(i - 3) * STRIDE;
        float2 pos = t.pos + dir * (texel * offset);
        float4 s;
        if (SOURCE == 0) s = t.backbuffer.Sample(pos);
        else if (SOURCE == 1) s = t.a.Sample(pos);
        else s = t.b.Sample(pos);
        // Only the first pass needs the emission extraction, later passes
        // blur the already extracted light.
        float3 e = (SOURCE == 0) ? emission(s, d, chrome) : s.rgb;
        sum += e * WEIGHTS[i];
    }
    // Alpha 1 keeps the value intact when the pipeline premultiplies it on the
    // way into the named texture.
    return float4(sum, 1.0);
}
