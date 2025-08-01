//
//  STB.swift
//  SwiftToolbox
//

import Foundation

/// A general-purpose class for SwiftToolbox functions.
public class STB {
	/// An NSLog wrapper which prints the project-relative file path, calling function name, and line number of the line that calls this function as a prefix before the given message to log.
	/// - Parameters:
	///   - message: The message to log.
	/// ### Example Output
	/// `SwiftToolbox/STB.swift#log(_:file:function:line:):16`
	public static func log(_ message: String, file: String = #fileID, function: String = #function, line: Int = #line) {
		NSLog("\(file)#\(function):\(line): \(message)")
	}
	
	/// Returns a URL to a temporary filename in a temporary directory. The temporary directory exists, the file does not.
	/// - Returns: A URL to a nonexistant file in a temporary directory.
	public static func temporaryFilename() -> URL {
		let tempFile = "\(Bundle.main.bundleIdentifier ?? "temp").\(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))"
		if #available(macOS 10.12, *) {
			return FileManager.default.temporaryDirectory.appending(path: tempFile, isDirectory: false)
		} else {
			return URL(localPath: NSTemporaryDirectory()).appending(path: tempFile, isDirectory: false)
		}
	}
	
}
