# Stability.ai KIT

Stability.ai KIT implementation for Swift enables seamless integration of stability analysis and prediction capabilities into your Swift-based applications.

## Available Features

- [x] [Get account information](https://platform.stability.ai/rest-api#tag/v1user/operation/userAccount)
- [x] [Get balance information](https://platform.stability.ai/rest-api#tag/v1user/operation/userBalance)
- [x] [Get engines](https://platform.stability.ai/rest-api#tag/v1engines/operation/listEngines)
- [x] [Generate a new image from a text prompt](https://platform.stability.ai/rest-api#tag/v1generation/operation/textToImage)
- [x] [Modify an image based on a text prompt](https://platform.stability.ai/rest-api#tag/v1generation/operation/imageToImage)
- [ ] [Create a higher resolution version of an input image](https://platform.stability.ai/rest-api#tag/v1generation/operation/upscaleImage)
- [ ] [Selectively modify portions of an image using a mask](https://platform.stability.ai/rest-api#tag/v1generation/operation/masking)

## Installation

You can install the Stability.ai KIT package using Swift Package Manager. Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/ftp27/stabilityai-kit", from: "1.0.0")
]
```

## Usage

### Documentation

The framework is fully documented using Xcode's documentation system. You can also find the documentation online at [appledoc](https://ftp27.github.io/stabilityai-kit/appledoc/documentation/stabilityaikit/).

### Configuration

To use the framework, first create a `Configuration` instance with the necessary API key and optional client information:

```swift
let configuration = Configuration(apiKey: "YOUR_API_KEY")
```

You can also customize the `clientId`, `clientVersion`, `organization` properties of the configuration if needed.

### Proxy support

If you need to use a proxy to connect to the Stability AI API, you can set the `api` property of the configuration:

```swift
let configuration = Configuration(
    apiKey: "YOUR_API_KEY",
    api: .init(
        scheme: .https,
        host: "proxyhost.com"
    )
)
```

### Creating a Client

Once you have a configuration, create a `Client` instance:

```swift
let client = Client(configuration: configuration)
```

### Making API Requests

The framework provides methods to interact with the Stability AI API. Here are some example requests:

#### Get Account Information

```swift
do {
    let account = try await client.getAccount()
    // Use the account information
} catch {
    // Handle error
}
```

#### Get Balance Information

```swift
do {
    let balance = try await client.getBalance()
    // Use the balance information
} catch {
    // Handle error
}
```

#### Get Engines

```swift
do {
    let engines = try await client.getEngines()
    // Use the list of engines
} catch {
    // Handle error
}
```

#### Text to Image Conversion

```swift
let request = TextToImageRequest(textPrompts: [.init(text: "your prompt")])

do {
    let results = try await client.getImageFromText(request, engine: "ENGINE_ID")
    // Use the resulting images
} catch {
    // Handle error
}
```

#### Image to Image Conversion

```swift
let request = ImageToImageRequest
    .strength(
        textPrompts: [.init(text: "your prompt")]),
        initImage: image.pngData()!,
        strength: 0.5
    )
    .setStylePreset(.cinematic) // Optional
    .setSteps(40) // Optional

do {
    let results = try await client.getImageFromImage(request, engine: "ENGINE_ID")
    // Use the resulting images
} catch {
    // Handle error
}
```

## Contributing

Contributions are welcomed to the framework. If you have a feature request, bug report, or patch, please feel free to open an issue or pull request.

## License

This Swift package is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.