//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

// 1

class ExampleForm: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleNames: String = ""
    @Published var lastNames: String = ""
    @Published var birthday: Date = Date()
    @Published var street: String = ""
    @Published var firstLine: String = ""
    @Published var secondLine: String = ""
    @Published var country: String = ""

    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // 2
    @Published var form = FormValidation(validationType: .immediate, messages: ValidationMessages())

    // 3
    lazy var firstNameValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            CountValidator(count: 6, type: .greaterThanOrEquals),
            PrefixValidator(prefix: "st.")
        ]
        return $firstName.allValid(validators: validators, form: form)
    }()

    lazy var lastNamesValidation: ValidationContainer = {
        $lastNames.inlineValidator(form: form) { value in
            !value.isEmpty
        }
    }()

    lazy var birthdayValidation: ValidationContainer = {
        $birthday.dateValidator(form: form, before: Date(), errorMessage: "Date must be before today")
    }()

    lazy var streetValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            CountValidator(count: 6, type: .greaterThanOrEquals),
            PrefixValidator(prefix: "st.")
        ]
        return $street.allValid(validators: validators, form: form)
    }()

    lazy var firstLineValidation: ValidationContainer = {
        $firstLine.countValidator(
                form: form,
                count: 6,
                type: .greaterThanOrEquals,
                onValidate: { validation in
                    switch validation {
                    case .success:
                        print("Success")
                    case .failure(let error):
                        print("Failure: \(error)")
                    }
                })
    }()

    lazy var passwordValidation: ValidationContainer = {
        $password.passwordMatchValidator(
                form: form,
                firstPassword: self.password,
                secondPassword: self.confirmPassword,
                secondPasswordPublisher: self.$confirmPassword)
    }()

}

class ValidationMessages: DefaultValidationMessages {
    public override var required: String {
        "Required field"
    }
}
