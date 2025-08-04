//
//  STBKeychainError.swift
//  SwiftToolbox
//

import Foundation

public enum STBKeychainError: Error {
	case unableToDecodeResult(msg: String = "The data from the keychain could not be decoded to a string.")
	case unhandledOSStatusError(msg: String)
	case itemNotFound(msg: String)
	case ioError(msg: String)
	case parameterError(msg: String)
	case duplicateItem(msg: String)
	case userCanceled(msg: String)
	init(_ status: OSStatus) {
		let msg = (SecCopyErrorMessageString(status, nil) as? String) ?? "An unknown error occured (OSStatus \(status))"
		switch status {
			case errSecItemNotFound: self = .itemNotFound(msg: msg)
			case errSecIO: self = .ioError(msg: msg)
			case errSecParam: self = .parameterError(msg: msg)
			case errSecDuplicateItem: self = .duplicateItem(msg: msg)
			case errSecUserCanceled: self = .userCanceled(msg: msg)
			default:
				NSLog("Unhandled OSStatus: \(status)")
				self = .unhandledOSStatusError(msg: msg)
		}
	}
	
	public var errorDescription: String? {
		switch self {
			case .unableToDecodeResult(msg: let msg):
				return msg
			case .unhandledOSStatusError(msg: let msg):
				return msg
			case .itemNotFound(msg: let msg):
				return msg
			case .ioError(msg: let msg):
				return msg
			case .parameterError(msg: let msg):
				return msg
			case .duplicateItem(msg: let msg):
				return msg
			case .userCanceled(msg: let msg):
				return msg
		}
	}
}
