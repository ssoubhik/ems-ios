//
//  DateFieldComponent.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 14/09/23.
//

import SwiftUI

// MARK: - Date Field Component

struct DateFieldComponent: View {
    @Binding var date: String

    let placeHolder: String
    
    @State private var isFocused = false

    internal init(
        date: Binding<String>,
        placeHolder: String
    ) {
        _date = date
        self.placeHolder = placeHolder
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeHolder)
                .foregroundColor(isFocused ? .accentColor : .gray)
                .padding(.horizontal, isFocused || !date.isBlank ? 8 : 0)
                .background(.white)
                .offset(y: isFocused || !date.isBlank ? -25 : 0)
                .scaleEffect(isFocused || !date.isBlank ? 0.9 : 1, anchor: .leading)

            DatePickerTextField(
                date: $date,
                isEditing: $isFocused
            )
        }
        .frame(maxHeight: 50)
        .animation(.easeOut(duration: 0.2), value: isFocused)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.accentColor : Color.gray, lineWidth: isFocused ? 2 : 1)
        }
    }
}

// MARK: - Date Picker TextField

struct DatePickerTextField: UIViewRepresentable {
    @Binding var date: String
    @Binding var isEditing: Bool
    
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func makeUIView(context: Context) -> UITextField {
        // setup datepicker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)

        // setup toolbar for textfield
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: StaticText.done, style: .plain, target: helper, action: #selector(helper.doneButtonTapped))

        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, doneButton], animated: true)

        // setup textfield
        textField.inputView = datePicker
        textField.delegate = context.coordinator
        textField.inputAccessoryView = toolbar

        // set date
        helper.onDateValueChanged = {
            date = dateFormatter.string(from: datePicker.date)
        }

        // set date & close date picker
        helper.onDoneButtonTapped = {
            date = dateFormatter.string(from: datePicker.date)

            textField.resignFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        // update date
        uiView.text = date
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isEditing: $isEditing)
    }

    class Helper {
        public var onDateValueChanged: (() -> Void)?
        public var onDoneButtonTapped: (() -> Void)?

        @objc func dateValueChanged() {
            onDateValueChanged?()
        }

        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool

        init(isEditing: Binding<Bool>) {
            _isEditing = isEditing
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            if !isEditing {
                isEditing = true
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if isEditing {
                isEditing = false
            }
        }
    }
}
