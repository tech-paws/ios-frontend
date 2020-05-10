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

enum ExecCommand {
    case pushPos2f(x: Float, y: Float)
    case updateCameraPosition
}

enum RequestCommand {
    case setViewportSize(width: Int, height: Int)
    case onTouchStart(x: Float, y: Float)
    case onTouchEnd(x: Float, y: Float)
    case onTouchMove(x: Float, y: Float)
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

func sendRequestCommand(_ command: RequestCommand) {
    sendRequestCommands([command])
}

func sendRequestCommands(_ commands: [RequestCommand]) {
    var arr: [[String: Any]] = [];

    for command in commands {
        arr.append(try! serializeRequestCommand(command))
    }
    
    let json = try! JSONSerialization.data(withJSONObject: arr, options: [])
    let buffer = json.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> RawBuffer in
        RawBuffer(data: ptr.baseAddress!.assumingMemoryBound(to: UInt8.self), length: UInt(ptr.count))
    }
    send_request_commands(buffer)
}

private func serializeRequestCommand(_ command: RequestCommand) throws -> [String: Any] {
    switch command {
    case .setViewportSize(let width, let height):
        return [
            "SetViewportSize": [
                "width": width,
                "height": height,
            ]
        ]
    case .onTouchStart(let x, let y):
        return [
            "OnTouchStart": [
                "x": x,
                "y": y,
            ]
        ]
    case .onTouchEnd(let x, let y):
        return [
            "OnTouchEnd": [
                "x": x,
                "y": y,
            ]
        ]
    case .onTouchMove(let x, let y):
        return [
            "OnTouchMove": [
                "x": x,
                "y": y,
            ]
        ]
    }
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
            r: (data["r"] as! NSNumber).floatValue,
            g: (data["g"] as! NSNumber).floatValue,
            b: (data["b"] as! NSNumber).floatValue,
            a: (data["a"] as! NSNumber).floatValue
        )
    case "PushPos2f":
        return .pushPos2f(
            x: (data["x"] as! NSNumber).floatValue,
            y: (data["y"] as! NSNumber).floatValue
        )
    default:
        throw RenderError.jsonError
    }
}

///

func getExecCommands() -> [ExecCommand] {
    var commands: [ExecCommand] = []
    
    let buffer = get_exec_commands()
    let jsonData = rawBufferToData(buffer: buffer)
    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
    
    let commandsJson = json as! [Any]
    
    for commandJson in commandsJson {
        let command = try! createExecCommandFromJson(json: commandJson)
        commands.append(command)
    }

    return commands
}

private func createExecCommandFromJson(json: Any) throws -> ExecCommand {
    switch json {
    case let type as String:
        return try createExecCommandFromString(type: type)
    case let object as [String: Any]:
        return try createExecCommandFromJsonObject(object: object)
    default:
        throw RenderError.jsonError
    }
}

private func createExecCommandFromString(type: String) throws -> ExecCommand {
    switch type {
    case "UpdateCameraPosition":
        return .updateCameraPosition
    default:
        throw RenderError.jsonError
    }
}

private func createExecCommandFromJsonObject(object: [String: Any]) throws -> ExecCommand {
    let type = object.keys.first!
    let data = object[type]! as! [String: Any]
    
    switch type {
    case "PushPos2f":
        return .pushPos2f(
            x: (data["x"] as! NSNumber).floatValue,
            y: (data["y"] as! NSNumber).floatValue
        )
    default:
        throw RenderError.jsonError
    }
}

