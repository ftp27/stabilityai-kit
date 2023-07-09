import Foundation

public enum ClipGuidancePreset: String, Codable {
    case `none` = "NONE"
    case fastBlue = "FAST_BLUE"
    case fastGreen = "FAST_GREEN"
    case simple = "SIMPLE"
    case slow = "SLOW"
    case slower = "SLOWER"
    case slowest = "SLOWEST"
}

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
