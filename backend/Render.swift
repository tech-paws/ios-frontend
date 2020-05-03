import Foundation

enum RenderError: Error {
    case jsonError
}

enum RenderCommand {
    case pushColor(r: Float, g: Float, b: Float, a: Float)
    case pushPos2f(x: Float, y: Float)
    case drawLines
    case pushColorShader
    case setColorUniform
}

func rawBufferToData(buffer: RawBuffer) -> Data {
    let unsafe = UnsafeBufferPointer(start: buffer.data, count: Int(buffer.length))
    let bytes = Array(unsafe)

    return Data(bytes);
}

func getRenderCommands() -> [RenderCommand] {
    var commands: [RenderCommand] = []
    
    let buffer = get_render_commands()
    let jsonData = rawBufferToData(buffer: buffer)
    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
    
    let commandsJson = json as! [Any]
    
    for commandJson in commandsJson {
        let command = try! createRenderCommandFromJson(json: commandJson)
        commands.append(command)
    }

    return commands
}

private func createRenderCommandFromJson(json: Any) throws -> RenderCommand {
    switch json {
    case let type as String:
        return try createRenderCommandFromString(type: type)
    case let object as [String: Any]:
        return try createRenderCommandFromJsonObject(object: object)
    default:
        throw RenderError.jsonError
    }
}

private func createRenderCommandFromString(type: String) throws -> RenderCommand {
    switch type {
    case "PushColorShader":
        return .pushColorShader
    case "SetColorUniform":
        return .setColorUniform
    case "DrawLines":
        return .drawLines
    default:
        throw RenderError.jsonError
    }
}

private func createRenderCommandFromJsonObject(object: [String: Any]) throws -> RenderCommand {
    let type = object.keys.first!
    let data = object[type]! as! [String: Any]
    
    switch type {
    case "PushColor":
        return .pushColor(
            r: data["r"] as! Float,
            g: data["g"] as! Float,
            b: data["b"] as! Float,
            a: data["a"] as! Float
        )
    case "PushPos2f":
        return .pushPos2f(
            x: data["x"] as! Float,
            y: data["y"] as! Float
        )
    default:
        throw RenderError.jsonError
    }
}
