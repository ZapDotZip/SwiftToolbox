//
//  KeychainInterface.swift
//  ResticGUI
//

import Foundation

public class STBKeychain {
	
	static let service = Bundle.main.bundleIdentifier ?? "unknown bundle identifier"
	
	public static func add(path: String, password: String) throws(STBKeychainError) {
		let dict = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: path,
			kSecValueData: password
		] as CFDictionary
		let status = SecItemAdd(dict, nil)
		if status != errSecSuccess {
			throw STBKeychainError(status)
		}
	}
	
	public static func load(path: String) throws(STBKeychainError) -> String {
		let dict = [
			kSecMatchLimit: kSecMatchLimitOne,
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: path,
			kSecReturnData: true
		] as CFDictionary
		var result: AnyObject?
		
		let status = SecItemCopyMatching(dict, &result)
		if status != errSecSuccess {
			NSLog("Unable to get keychain item: \(status)")
			throw STBKeychainError(status)
		}
		if let data = result as? Data, let str = String.init(data: data, encoding: .utf8) {
			return str
		} else {
			throw STBKeychainError.unableToDecodeResult()
		}
	}
	
	public static func update(path: String, password: String) throws(STBKeychainError) {
		let dict = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: path
		] as CFDictionary
		let update = [kSecValueData: password.data(using: .utf8)!] as CFDictionary
		
		let status = SecItemUpdate(dict, update)
		if status != errSecSuccess {
			throw STBKeychainError(status)
		}
	}
	
	public static func update(path: String) throws(STBKeychainError) {
		let dict = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: path
		] as CFDictionary
		let update = [
			kSecAttrAccount: path
		] as CFDictionary
		
		let status = SecItemUpdate(dict, update)
		if status != errSecSuccess {
			throw STBKeychainError(status)
		}
	}
	
	public static func updateOrAdd(path: String, password: String) throws(STBKeychainError) {
		do {
			try update(path: path, password: password)
		} catch {
			switch error {
				case .itemNotFound:
					do {
						try add(path: path, password: password)
					} catch {
						throw error
					}
				default:
					throw error
			}
		}
	}
	
	public static func delete(path: String) throws(STBKeychainError) {
		let dict = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: path
		] as CFDictionary
		
		let status = SecItemDelete(dict)
		if status != errSecSuccess {
			throw STBKeychainError(status)
		}
	}
	
}
