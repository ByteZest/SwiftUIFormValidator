//
//  File.swift
//  
//
//  Created by Petyo Tsonev on 12.06.23.
//

import Foundation

public class ConditionValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []
    private let condition: (Value) -> String?

    public init(condition: @escaping (Value) -> String?) {
        self.condition = condition
    }

    public let message: StringProducerClosure = {
        ""
    }

    public var value: String? = ""

    public func validate() -> Validation {
        guard let value else {
            return .success
        }
        guard let error = condition(value) else {
            return .success
        }
        return .failure(message: error)
    }
}
