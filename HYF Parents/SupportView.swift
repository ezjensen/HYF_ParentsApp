//
//  SupportView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/25/25.
//

import SwiftUI
import MessageUI

struct SupportView: View {
	@Binding var selectedTab: Int
	@State private var showingAboutInfo = false
	@State private var showingMailView = false
	@State private var showingMailError = false
	@State private var showingThankYou = false
	@State private var feedbackType = "Feature Request"
	@State private var feedbackMessage = ""
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(5)) {
		self._selectedTab = selectedTab
	}
	
	let feedbackTypes = ["Feature Request", "Bug Report", "General Feedback"]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Banner at top
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70)
							
							VStack(spacing: 20) {
								// About button
								Button(action: {
									showingAboutInfo = true
								}) {
									HStack {
										Image(systemName: "info.circle.fill")
											.font(.title2)
										Text("About This App")
											.font(.headline)
										Spacer()
										Image(systemName: "chevron.right")
											.font(.subheadline)
									}
									.foregroundColor(.white)
									.padding()
									.background(Color.red.opacity(0.8))
									.cornerRadius(10)
								}
								.padding(.horizontal)
								.padding(.top, 30)
								
								// Feedback section
								VStack(alignment: .leading, spacing: 16) {
									Text("Send Feedback")
										.font(.headline)
										.foregroundColor(.white)
										.padding(.horizontal)
									
									// Feedback type picker
									VStack(alignment: .leading) {
										Text("Type of Feedback")
											.font(.subheadline)
											.foregroundColor(.white.opacity(0.8))
											.padding(.horizontal)
										
										Picker("Feedback Type", selection: $feedbackType) {
											ForEach(feedbackTypes, id: \.self) { type in
												Text(type).tag(type)
											}
										}
										.pickerStyle(SegmentedPickerStyle())
										.padding(.horizontal)
									}
									
									// Feedback message
									VStack(alignment: .leading) {
										Text("Your Message")
											.font(.subheadline)
											.foregroundColor(.white.opacity(0.8))
											.padding(.horizontal)
										
										TextEditor(text: $feedbackMessage)
											.frame(minHeight: 150)
											.padding(5)
											.background(Color.white.opacity(0.1))
											.cornerRadius(8)
											.foregroundColor(.white)
											.overlay(
												RoundedRectangle(cornerRadius: 8)
													.stroke(Color.white.opacity(0.3), lineWidth: 1)
											)
											.padding(.horizontal)
									}
									
									// Submit button
									Button(action: {
										if MFMailComposeViewController.canSendMail() {
											showingMailView = true
										} else {
											showingMailError = true
										}
									}) {
										Text("Submit Feedback")
											.foregroundColor(.white)
											.padding()
											.frame(maxWidth: .infinity)
											.background(Color.red.opacity(0.8))
											.cornerRadius(10)
									}
									.padding(.horizontal)
									.disabled(feedbackMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
									.opacity(feedbackMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
								}
								.padding(.vertical)
								.background(Color.gray.opacity(0.2))
								.cornerRadius(15)
								.padding(.horizontal)
								
								Spacer()
							}
							.padding(.bottom, geometry.safeAreaInsets.bottom)
						}
					}
					.ignoresSafeArea(edges: .top)
				}
			}
			.navigationBarHidden(true)
			.alert(isPresented: $showingAboutInfo) {
				Alert(
					title: Text("About HYF Parents"),
					message: Text("This app was made for Huntley Youth Football and for the Player Parents to put all resources in their hands."),
					dismissButton: .default(Text("OK"))
				)
			}
			.alert(isPresented: $showingMailError) {
				Alert(
					title: Text("Cannot Send Email"),
					message: Text("Your device is not configured to send emails. Please check your email settings and try again."),
					dismissButton: .default(Text("OK"))
				)
			}
			.sheet(isPresented: $showingMailView) {
				MailView(
					result: { result in
						switch result {
							case .success:
								showingThankYou = true
							case .failure:
								// Handle failure if needed
								break
						}
						showingMailView = false
					},
					feedbackType: feedbackType,
					message: feedbackMessage
				)
			}
			.alert(isPresented: $showingThankYou) {
				Alert(
					title: Text("Thank You!"),
					message: Text("Your feedback has been submitted. We appreciate your input."),
					dismissButton: .default(Text("Close")) {
						// Reset form and go to home tab
						feedbackMessage = ""
						selectedTab = 0 // Switch to home tab
					}
				)
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(.red)
	}
}

struct MailView: UIViewControllerRepresentable {
	typealias UIViewControllerType = MFMailComposeViewController
	
	@Environment(\.presentationMode) var presentationMode
	var result: (Result<MFMailComposeResult, Error>) -> Void
	var feedbackType: String
	var message: String
	
	func makeUIViewController(context: Context) -> MFMailComposeViewController {
		let viewController = MFMailComposeViewController()
		viewController.mailComposeDelegate = context.coordinator
		
		// Set hidden recipient
		viewController.setToRecipients(["ezjensen@gmail.com"])
		
		// Set subject based on feedback type
		viewController.setSubject("HYF Parents App: \(feedbackType)")
		
		// Set email body
		viewController.setMessageBody(message, isHTML: false)
		
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
		var parent: MailView
		
		init(_ parent: MailView) {
			self.parent = parent
		}
		
		func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
			if let error = error {
				parent.result(.failure(error))
			} else {
				parent.result(.success(result))
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}

struct SupportView_Previews: PreviewProvider {
	static var previews: some View {
		SupportView()
	}
}
