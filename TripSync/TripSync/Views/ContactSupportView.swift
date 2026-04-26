import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription", "Account", "Other"]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { Text($0) }
                }
            }

            Section("Contact Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 100)
            }

            Section {
                Button {
                    submitFeedback()
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage.contains("success") ? "Sent!" : "Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        isSubmitting = true

        let body: [String: Any] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "TripSync",
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]

        guard let url = URL(string: "https://formsubmit.co/ajax/iocompile67692@gmail.com") else {
            alertMessage = "Failed to submit. Please try again."
            showAlert = true
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to submit: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    alertMessage = "Your message has been sent successfully!"
                    message = ""
                } else {
                    alertMessage = "Failed to submit. Please try again."
                }
                showAlert = true
            }
        }.resume()
    }
}
