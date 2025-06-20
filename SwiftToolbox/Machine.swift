//
//  Machine.swift
//  SwiftToolbox
//

import Foundation
import IOKit.ps


public class Machine {
	public static func isOnBattery() -> Bool {
		let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
		let list = IOPSCopyPowerSourcesList(info).takeRetainedValue() as Array
		
		for i in list {
			if let desc = IOPSGetPowerSourceDescription(info, i).takeUnretainedValue() as? [String: Any],
			   let isCharging = (desc[kIOPSIsChargingKey] as? Bool) {
				return !isCharging
			}
		}
		return false
	}
	
	func sysctlInt(_ name: String) -> Int? {
		var size = 0
		guard sysctlbyname(name, nil, &size, nil, 0) == 0 else {
			return nil
		}
		var result = 0
		guard sysctlbyname(name, &result, &size, nil, 0) == 0 else {
			return nil
		}
		return result
	}
	
	func sysctlString(_ name: String) -> String? {
		var size = 0
		guard sysctlbyname(name, nil, &size, nil, 0) == 0 else {
			return nil
		}
		var result = [CChar](repeating: 0,  count: size)
		guard sysctlbyname(name, &result, &size, nil, 0) == 0 else {
			return nil
		}
		return String(utf8String: result)
	}
	
	/// Gets the core counts of the two different types of cores in the M-series CPUs, if possible.
	/// - Returns: Efficiency core count, Performance core count.
	public static func getDifferentialCoreCount() -> (Int, Int)? {
		guard sysctlString("hw.perflevel0.name") == "Performance" && sysctlString("hw.perflevel1.name") == "Efficiency" else {
			return nil
		}
		if let eCores = sysctlInt("hw.perflevel1.logicalcpu"), let pCores = sysctlInt("hw.perflevel0.logicalcpu") {
			return (eCores, pCores)
		}
		return nil
	}

	
}
