//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import Foundation

/// This validator validates if a date falls within `after` & `before`.
public class DateValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    private let before: Date
    private let after: Date

    public init(before: Date, after: Date, message: @autoclosure @escaping StringProducerClosure) {
        self.before = before
        self.after = after
        self.message = message
    }

    public let message: StringProducerClosure

    public var value: Date = Date()

    public func validate() -> Validation {
        value < before && value > after ?
                Validation.success :
                Validation.failure(message: message())
    }

    public var isEmpty: Bool {
        false
    }
}
