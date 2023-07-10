import Foundation

/// The Sampler enum is responsible for determining the calculation process of an image within latent diffusion models. It acts as an intermediary between the input prompt and the resulting image, influencing the subsequent steps without exposing the underlying mathematical operations.
public enum Sampler: String, Codable {
    /// Denoising Diffusion Implicit Model
    case ddim = "DDIM"
    /// Denoising Diffusion Probabilistic Models
    case ddpm = "DDPM"
    /// DPM++ 2M Karras
    case kDpmpp2m = "K_DPMPP_2M"
    /// Ancestral DPM++ 2S Karras
    case kDpmpp2sAncestral = "K_DPMPP_2S_ANCESTRAL"
    /// DPM 2 Karras
    case kDpm2 = "K_DPM_2"
    /// Ancestral DPM 2 Karras
    case kDpm2Ancestral = "K_DPM_2_ANCESTRAL"
    /// Implements Algorithm 2 (Euler steps) from Karras et al. (2022).
    case kEuler = "K_EULER"
    /// Ancestral sampling with Euler method steps.
    case kEulerAncestral = "K_EULER_ANCESTRAL"
    /// Implements Algorithm 2 (Heun steps) from Karras et al. (2022).
    case kHeun = "K_HEUN"
    /// Kernel Least Mean Square
    case kLms = "K_LMS"
}
