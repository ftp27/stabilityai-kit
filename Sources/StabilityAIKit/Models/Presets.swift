import Foundation

/// CLIP Guidance is a technique that uses the CLIP neural network to guide the generation of images to be more in-line with your included prompt, which often results in improved coherency.
public enum ClipGuidancePreset: String, Codable {
    case `none` = "NONE"
    case fastBlue = "FAST_BLUE"
    case fastGreen = "FAST_GREEN"
    case simple = "SIMPLE"
    case slow = "SLOW"
    case slower = "SLOWER"
    case slowest = "SLOWEST"
}

/// Style presets are a way to apply pre-defined styles to your images.
public enum StylePreset: String, Codable {
    case model3D = "3d-model"
    case analogFilm = "analog-film"
    case anime = "anime"
    case cinematic = "cinematic"
    case comicBook = "comic-book"
    case digitalArt = "digital-art"
    case enhance = "enhance"
    case fantasyArt = "fantasy-art"
    case isometric = "isometric"
    case lineArt = "line-art"
    case lowPoly = "low-poly"
    case modelingCompound = "modeling-compound"
    case neonPunk = "neon-punk"
    case origami = "origami"
    case photographic = "photographic"
    case pixelArt = "pixel-art"
    case tileTexture = "tile-texture"
}
