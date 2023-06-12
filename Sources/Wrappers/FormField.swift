//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine

@propertyWrapper
public class FormField<Value, Validator: Validatable> where Value == Validator.Value {
    @Published
    private var value: Value
    private let validator: Validator
    public let fieldName: String?

    public var projectedValue: AnyPublisher<Value, Never> {
        $value.eraseToAnyPublisher()
    }

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue value: Value, validator: () -> Validator, fieldName: String? = nil) {
        self.value = value
        self.validator = validator()
        self.fieldName = fieldName
    }

    public init(wrappedValue value: Value, validator: Validator, fieldName: String? = nil) {
        self.value = value
        self.validator = validator
        self.fieldName = fieldName
    }

    public init(initialValue value: Value, validator: () -> Validator, fieldName: String? = nil) {
        self.value = value
        self.validator = validator()
        self.fieldName = fieldName
    }

    public func validation(
            manager: FormManager,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil) -> ValidationContainer {
        let pub: AnyPublisher<Value, Never> = $value.eraseToAnyPublisher()
        return ValidationFactory.create(
                manager: manager,
                validator: validator,
                for: pub,
                disableValidation: disableValidation,
                onValidate: onValidate,
                fieldName: fieldName)
    }
}

public extension FormField where Validator == InlineValidator<Value> {

    convenience init(wrappedValue value: Value, inlineValidator: @escaping (Value) -> String?, fieldName: String? = nil) {
        self.init(wrappedValue: value, validator: InlineValidator(condition: inlineValidator), fieldName: fieldName)
    }

}
