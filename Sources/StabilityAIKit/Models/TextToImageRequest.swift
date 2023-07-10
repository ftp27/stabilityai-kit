import Foundation

public struct TextToImageRequest: Codable {
    /// Height of the image in pixels.
    ///
    /// Must be in increments of 64 and pass the following validation:
    /// - For 768 engines: 589,824 ≤ height \* width ≤ 1,048,576
    /// - All other engines: 262,144 ≤ height \* width ≤ 1,048,576
    ///
    /// - Important:
    ///     - multiple of 64 >= 128
    ///     - Default: 512
    public var height: Int?
    /// Width of the image in pixels.
    ///
    /// Must be in increments of 64 and pass the following validation:
    /// - For 768 engines: 589,824 ≤ height \* width ≤ 1,048,576
    /// - All other engines: 262,144 ≤ height \* width ≤ 1,048,576
    ///
    /// - Important:
    ///     - multiple of 64 >= 128
    ///     - Default: 512
    public var width: Int?
    /// An array of text prompts to use for generation.
    ///
    /// Given a text prompt with the text `"A lighthouse on a cliff"` and a weight of `0.5`, it would be represented as:
    /// ```
    /// "text_prompts": [
    ///   {
    ///     "text": "A lighthouse on a cliff",
    ///     "weight": 0.5
    ///   }
    /// ]
    /// ```
    public var text_prompts: [TextPrompt]
    /// How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt)
    ///
    /// - Important:
    ///     - Default: 7
    ///     - Range: [ 0 .. 35 ]
    public var cfg_scale: Int?
    /// Default: `none`
    public var clip_guidance_preset: ClipGuidancePreset?
    /// Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
    public var sampler: Sampler?
    /// Number of images to generate
    /// - Important:
    ///     - Default: 1
    ///     - Range: [ 1 .. 10 ]
    public var samples: Int?
    /// Random noise seed (omit this option or use 0 for a random seed)
    /// - Important:
    ///     - Default: 0
    ///     - Range: [ 0 .. 4294967295 ]
    public var seed: Int?
    /// Number of diffusion steps to run
    /// - Important:
    ///     - Default: 50
    ///     - Range: [ 10 .. 150 ]
    public var steps: Int?
    /// Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.
    public var style_preset: StylePreset?
    
    
    public init(height: Int? = nil,
                width: Int? = nil,
                textPrompts: [TextPrompt],
                cfgScale: Int? = nil,
                clipGuidancePreset: ClipGuidancePreset? = nil,
                sampler: Sampler? = nil,
                samples: Int? = nil,
                seed: Int? = nil,
                steps: Int? = nil,
                stylePreset: StylePreset? = nil) {
        self.height = height
        self.width = width
        self.text_prompts = textPrompts
        self.cfg_scale = cfgScale
        self.clip_guidance_preset = clipGuidancePreset
        self.sampler = sampler
        self.samples = samples
        self.seed = seed
        self.steps = steps
        self.style_preset = stylePreset
    }
}

/// Text prompt to use for generation.
public struct TextPrompt: Codable {
    public var text: String
    public var weight: Float?
    
    public init(text: String, weight: Float? = nil) {
        self.text = text
        self.weight = weight
    }
}
