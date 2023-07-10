import Foundation

public protocol ImageToImageRequest {
    /// An array of text prompts to use for generation.
    var text_prompts: [TextPrompt] { get }
    /// Image used to initialize the diffusion process, in lieu of random noise.
    var init_image: Data { get }
    /// Whether to use `IMAGE_STRENGTH` or `STEP_SCHEDULE` to control how much influence the `init_image` has on the result.
    var init_image_mode: String { get }
    /// How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt).
    /// Default: 7. Range: [ 0 .. 35 ]
    var cfg_scale: Int? { get set }
    /// CLIP Guidance is a technique that uses the CLIP neural network to guide the generation of images to be more in-line with your included prompt, which often results in improved coherency.
    /// Default: `none`
    var clip_guidance_preset: ClipGuidancePreset? { get set }
    /// Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
    var sampler: Sampler? { get set  }
    /// Number of images to generate.
    /// Default: 1. Range: [ 1 .. 10 ]
    var samples: Int? { get set  }
    /// Random noise seed (omit this option or use 0 for a random seed).
    /// Default: 0. Range: [ 0 .. 4294967295 ]
    var seed: Int? { get set  }
    /// Number of diffusion steps to run.
    /// Default: 50. Range: [ 10 .. 150 ]
    var steps: Int? { get set  }
    /// Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.
    var style_preset: StylePreset? { get set }
    /// Converts the request to a multipart body.
    func createMultipartBody(boundary: String) throws -> String
}

public extension ImageToImageRequest {
    /// Create image to image request with image strength.
    /// - Parameters:
    ///   - prompts: An array of text prompts to use for generation.
    ///   - initImage: Image used to initialize the diffusion process, in lieu of random noise.
    ///   - imageStrength: How much influence the `init_image` has on the diffusion process. Values close to `1` will yield images very similar to the `init_image` while values close to `0` will yield images wildly different than the `init_image`.
    /// - Returns: Image to Image request
    static func strength(
        prompts: [TextPrompt],
        initImage: Data,
        imageStrength: Float
    ) -> ImageToImageRequest {
        ImageToImageStrengthRequest(
            textPrompts: prompts,
            initImage: initImage,
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
    static func stepSchedule(
        prompts: [TextPrompt],
        initImage: Data,
        stepScheduleStart: Float,
        stepScheduleEnd: Float?
    ) -> ImageToImageRequest {
        ImageToImageStepScheduleRequest(
            textPrompts: prompts,
            initImage: initImage,
            stepScheduleStart: stepScheduleStart,
            stepScheduleEnd: stepScheduleEnd
        )
    }
    
    /// Set CFG Scale (how strictly the diffusion process adheres to the prompt text).
    mutating func setCfgScale(_ cfgScale: Int) -> ImageToImageRequest {
        self.cfg_scale = cfgScale
        return self
    }
    
    /// Set CLIP Guidance preset. CLIP Guidance is a technique that uses the CLIP neural network to guide the generation of images to be more in-line with your included prompt, which often results in improved coherency.
    mutating func setClipGuidancePreset(_ clipGuidancePreset: ClipGuidancePreset) -> ImageToImageRequest {
        self.clip_guidance_preset = clipGuidancePreset
        return self
    }
    
    /// Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
    mutating func setSampler(_ sampler: Sampler) -> ImageToImageRequest {
        self.sampler = sampler
        return self
    }
    
    /// Number of images to generate.
    mutating func setSamples(_ samples: Int) -> ImageToImageRequest {
        self.samples = samples
        return self
    }
    
    /// Random noise seed (omit this option or use 0 for a random seed).
    mutating func setSeed(_ seed: Int) -> ImageToImageRequest {
        self.seed = seed
        return self
    }
    
    /// Number of diffusion steps to run.
    mutating func setSteps(_ steps: Int) -> ImageToImageRequest {
        self.steps = steps
        return self
    }
    
    /// Pass in a style preset to guide the image model towards a particular style. This list of style presets is subject to change.
    mutating func setStylePreset(_ stylePreset: StylePreset) -> ImageToImageRequest {
        self.style_preset = stylePreset
        return self
    }
}

public struct ImageToImageStrengthRequest: ImageToImageRequest {
    public var text_prompts: [TextPrompt]
    public var init_image: Data
    public var init_image_mode: String = "IMAGE_STRENGTH"
    /// How much influence the `init_image` has on the diffusion process. Values close to `1` will yield images very similar to the `init_image` while values close to `0` will yield images wildly different than the `init_image`. The behavior of this is meant to mirror DreamStudio's "Image Strength" slider.
    ///
    /// This parameter is just an alternate way to set `step_schedule_start`, which is done via the calculation `1 - image_strength`. For example, passing in an Image Strength of 35% (`0.35`) would result in a `step_schedule_start` of `0.65`.
    public var image_strength: Float?
    public var cfg_scale: Int?
    public var clip_guidance_preset: ClipGuidancePreset?
    public var sampler: Sampler?
    public var samples: Int?
    public var seed: Int?
    public var steps: Int?
    public var style_preset: StylePreset?
    
    public init(
        textPrompts: [TextPrompt],
        initImage: Data,
        imageStrength: Float? = nil,
        cfgScale: Int? = nil,
        clipGuidancePreset: ClipGuidancePreset? = nil,
        sampler: Sampler? = nil,
        samples: Int? = nil,
        seed: Int? = nil,
        steps: Int? = nil,
        stylePreset: StylePreset? = nil) {
        self.text_prompts = textPrompts
        self.init_image = initImage
        self.image_strength = imageStrength
        self.cfg_scale = cfgScale
        self.clip_guidance_preset = clipGuidancePreset
        self.sampler = sampler
        self.samples = samples
        self.seed = seed
        self.steps = steps
        self.style_preset = stylePreset
    }
}

public struct ImageToImageStepScheduleRequest: ImageToImageRequest {
    public var text_prompts: [TextPrompt]
    public var init_image: Data
    public var init_image_mode: String = "STEP_SCHEDULE"
    /// Skips a proportion of the start of the diffusion steps, allowing the `init_image` to influence the final generated image. Lower values will result in more influence from the `init_image`, while higher values will result in more influence from the diffusion steps. (e.g. a value of `0` would simply return you the `init_image`, where a value of `1` would return you a completely different image.).
    /// Default: 0.65. Range: [ 0 .. 1 ]
    public var step_schedule_start: Float?
    /// Skips a proportion of the end of the diffusion steps, allowing the `init_image` to influence the final generated image. Lower values will result in more influence from the `init_image`, while higher values will result in more influence from the diffusion steps.
    /// Range: [ 0 .. 1 ]
    public var step_schedule_end: Float?
    public var cfg_scale: Int?
    public var clip_guidance_preset: ClipGuidancePreset?
    public var sampler: Sampler?
    public var samples: Int?
    public var seed: Int?
    public var steps: Int?
    public var style_preset: StylePreset?
    
    public init(textPrompts: [TextPrompt],
                  initImage: Data,
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

extension ImageToImageStrengthRequest {
    public func createMultipartBody(boundary: String) throws -> String {
        var body = try createBasicMultipartBody(boundary: boundary)
        image_strength.map { body += $0.createMultipartBody(boundary: boundary, key: "image_strength") }
        body += "--\(boundary)--\r\n";
        return body
    }
}

extension ImageToImageStepScheduleRequest {
    public func createMultipartBody(boundary: String) throws -> String {
        var body = try createBasicMultipartBody(boundary: boundary)
        step_schedule_start.map { body += $0.createMultipartBody(boundary: boundary, key: "step_schedule_start") }
        step_schedule_end.map { body += $0.createMultipartBody(boundary: boundary, key: "step_schedule_end") }
        body += "--\(boundary)--\r\n";
        return body
    }
}

private extension ImageToImageRequest {
    func createBasicMultipartBody(boundary: String) throws -> String {
        var body = ""
        body += text_prompts.createMultipartBody(boundary: boundary, key: "text_prompts")
        body += try init_image.createMultipartBody(boundary: boundary, key: "init_image")
        body += init_image_mode.createMultipartBody(boundary: boundary, key: "init_image_mode")
        cfg_scale.map { body += $0.createMultipartBody(boundary: boundary, key: "cfg_scale") }
        clip_guidance_preset.map { body += $0.createMultipartBody(boundary: boundary, key: "clip_guidance_preset") }
        sampler.map { body += $0.createMultipartBody(boundary: boundary, key: "sampler") }
        samples.map { body += $0.createMultipartBody(boundary: boundary, key: "samples") }
        seed.map { body += $0.createMultipartBody(boundary: boundary, key: "seed") }
        steps.map { body += $0.createMultipartBody(boundary: boundary, key: "steps") }
        style_preset.map { body += $0.createMultipartBody(boundary: boundary, key: "style_preset") }
        return body
    }
}

private extension Collection where Element == TextPrompt {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        for (offset, prompt) in enumerated() {
            let paramName = "\(key)[\(offset)]"
            body += prompt.text.createMultipartBody(boundary: boundary, key: "\(paramName)[text]")
            guard let weight = prompt.weight else { continue }
            body += weight.createMultipartBody(boundary: boundary, key: "\(paramName)[weight]")
        }
        return body
    }
}

private extension String {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self)\r\n"
        return body
    }
}

private extension Data {
    func createMultipartBody(boundary: String, key: String) throws -> String {
        guard let content = String(data: self, encoding: .utf8) else {
            throw StabilityError.cantConvertData
        }
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "; filename=\"\(key)\"\r\n"
        body += "Content-Type: \"content-type header\"\r\n\r\n\(content)\r\n"
        return body
    }
}

private extension Float {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self)\r\n"
        return body
    }
}

private extension Int {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self)\r\n"
        return body
    }
}


private extension ClipGuidancePreset {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self.rawValue)\r\n"
        return body
    }
}

private extension Sampler {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self.rawValue)\r\n"
        return body
    }
}

private extension StylePreset {
    func createMultipartBody(boundary: String, key: String) -> String {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(key)\""
        body += "\r\n\r\n\(self.rawValue)\r\n"
        return body
    }
}
