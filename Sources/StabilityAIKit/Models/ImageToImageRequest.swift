import Foundation

public class ImageToImageRequest {
    /// An array of text prompts to use for generation.
    public var text_prompts: [TextPrompt]
    /// Image used to initialize the diffusion process, in lieu of random noise.
    public var init_image: Data
    /// Whether to use `IMAGE_STRENGTH` or `STEP_SCHEDULE` to control how much influence the `init_image` has on the result.
    public var init_image_mode: String
    /// How much influence the `init_image` has on the diffusion process. Values close to `1` will yield images very similar to the `init_image` while values close to `0` will yield images wildly different than the `init_image`. The behavior of this is meant to mirror DreamStudio's "Image Strength" slider.
    ///
    /// This parameter is just an alternate way to set `step_schedule_start`, which is done via the calculation `1 - image_strength`. For example, passing in an Image Strength of 35% (`0.35`) would result in a `step_schedule_start` of `0.65`.
    public var image_strength: Float?
    /// Skips a proportion of the start of the diffusion steps, allowing the `init_image` to influence the final generated image. Lower values will result in more influence from the `init_image`, while higher values will result in more influence from the diffusion steps. (e.g. a value of `0` would simply return you the `init_image`, where a value of `1` would return you a completely different image.).
    /// Default: 0.65. Range: [ 0 .. 1 ]
    public var step_schedule_start: Float?
    /// Skips a proportion of the end of the diffusion steps, allowing the `init_image` to influence the final generated image. Lower values will result in more influence from the `init_image`, while higher values will result in more influence from the diffusion steps.
    /// Range: [ 0 .. 1 ]
    public var step_schedule_end: Float?
    /// How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt).
    /// Default: 7. Range: [ 0 .. 35 ]
    public var cfg_scale: Int?
    /// CLIP Guidance is a technique that uses the CLIP neural network to guide the generation of images to be more in-line with your included prompt, which often results in improved coherency.
    /// Default: `none`
    public var clip_guidance_preset: ClipGuidancePreset?
    /// Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
    public var sampler: Sampler?
    /// Number of images to generate.
    /// Default: 1. Range: [ 1 .. 10 ]
    public var samples: Int?
    /// Random noise seed (omit this option or use 0 for a random seed).
    /// Default: 0. Range: [ 0 .. 4294967295 ]
    public var seed: Int?
    /// Number of diffusion steps to run.
    /// Default: 50. Range: [ 10 .. 150 ]
    public var steps: Int?
    /// Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.
    public var style_preset: StylePreset?
    
    init(textPrompts: [TextPrompt],
         initImage: Data,
         initImageMode: String,
         imageStrength: Float? = nil,
         stepScheduleStart: Float? = nil,
         stepScheduleEnd: Float? = nil,
         cfgScale: Int? = nil,
         clipGuidancePreset: ClipGuidancePreset? = nil,
         sampler: Sampler? = nil,
         samples: Int? = nil,
         seed: Int? = nil,
         steps: Int? = nil,
         stylePreset: StylePreset? = nil) {
        self.text_prompts = textPrompts
        self.init_image = initImage
        self.init_image_mode = initImageMode
        self.image_strength = imageStrength
        self.step_schedule_start = stepScheduleStart
        self.step_schedule_end = stepScheduleEnd
        self.cfg_scale = cfgScale
        self.clip_guidance_preset = clipGuidancePreset
        self.sampler = sampler
        self.samples = samples
        self.seed = seed
        self.steps = steps
        self.style_preset = stylePreset
    }
}

public extension ImageToImageRequest {
    /// Create image to image request with image strength.
    /// - Parameters:
    ///   - prompts: An array of text prompts to use for generation.
    ///   - initImage: Image used to initialize the diffusion process, in lieu of random noise.
    ///   - imageStrength: How much influence the `init_image` has on the diffusion process. Values close to `1` will yield images very similar to the `init_image` while values close to `0` will yield images wildly different than the `init_image`.
    /// - Returns: Image to Image request
    public static func strength(
        prompts: [TextPrompt],
        initImage: Data,
        imageStrength: Float
    ) -> ImageToImageRequest {
        ImageToImageRequest(
            textPrompts: prompts,
            initImage: initImage,
            initImageMode: "IMAGE_STRENGTH",
            imageStrength: imageStrength
        )
    }
    
    ///  Create image to image request with step schedule.
    /// - Parameters:
    ///   - prompts: An array of text prompts to use for generation.
    ///   - initImage: Image used to initialize the diffusion process, in lieu of random noise.
    ///   - stepScheduleStart: Skips a proportion of the start of the diffusion steps, allowing the `init_image` to influence the final generated image.
    ///   - stepScheduleEnd: Skips a proportion of the end of the diffusion steps, allowing the `init_image` to influence the final generated image. Lower values will result in more influence from the `init_image`, while higher values will result in more influence from the diffusion steps.
    /// - Returns: Image to Image request
    public static func stepSchedule(
        prompts: [TextPrompt],
        initImage: Data,
        stepScheduleStart: Float,
        stepScheduleEnd: Float?
    ) -> ImageToImageRequest {
        ImageToImageRequest(
            textPrompts: prompts,
            initImage: initImage,
            initImageMode: "STEP_SCHEDULE",
            stepScheduleStart: stepScheduleStart,
            stepScheduleEnd: stepScheduleEnd
        )
    }
    
    /// Set CFG Scale (how strictly the diffusion process adheres to the prompt text).
    func setCfgScale(_ cfgScale: Int) -> ImageToImageRequest {
        self.cfg_scale = cfgScale
        return self
    }
    
    /// Set CLIP Guidance preset. CLIP Guidance is a technique that uses the CLIP neural network to guide the generation of images to be more in-line with your included prompt, which often results in improved coherency.
    func setClipGuidancePreset(_ clipGuidancePreset: ClipGuidancePreset) -> ImageToImageRequest {
        self.clip_guidance_preset = clipGuidancePreset
        return self
    }
    
    /// Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
    func setSampler(_ sampler: Sampler) -> ImageToImageRequest {
        self.sampler = sampler
        return self
    }
    
    /// Number of images to generate.
    func setSamples(_ samples: Int) -> ImageToImageRequest {
        self.samples = samples
        return self
    }
    
    /// Random noise seed (omit this option or use 0 for a random seed).
    func setSeed(_ seed: Int) -> ImageToImageRequest {
        self.seed = seed
        return self
    }
    
    /// Number of diffusion steps to run.
    func setSteps(_ steps: Int) -> ImageToImageRequest {
        self.steps = steps
        return self
    }
    
    /// Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.
    func setStylePreset(_ stylePreset: StylePreset?) -> ImageToImageRequest {
        self.style_preset = stylePreset
        return self
    }
}

extension ImageToImageRequest {
    func createMultipartBody(boundary: String) throws -> Data {
        var data = MultipartFormData(boundary: boundary)
        data.encode(prompts: text_prompts, name: "text_prompts")
        data.encode(data: init_image, name: "init_image", fileName: "init_image.png", mimeType: "image/png")
//        data.encode(string: init_image_mode, name: "init_image_mode")
        image_strength.map { data.encode(string: "\($0)", name: "image_strength") }
//        step_schedule_start.map { data.encode(string: "\($0)", name: "step_schedule_start") }
//        step_schedule_end.map { data.encode(string: "\($0)", name: "step_schedule_end") }
//        cfg_scale.map { data.encode(string: "\($0)", name: "cfg_scale") }
//        clip_guidance_preset.map { data.encode(string: "\($0.rawValue)", name: "clip_guidance_preset") }
//        sampler.map { data.encode(string: "\($0.rawValue)", name: "sampler") }
//        samples.map { data.encode(string: "\($0)", name: "samples") }
//        seed.map { data.encode(string: "\($0)", name: "seed") }
//        steps.map { data.encode(string: "\($0)", name: "steps") }
//        style_preset.map { data.encode(string: "\($0.rawValue)", name: "style_preset") }
        return data.getBody()
    }
}
