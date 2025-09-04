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
	@State private var feedbackType = "General Feedback"
	@State private var feedbackMessage = ""
	@FocusState private var isTextEditorFocused: Bool
	@State private var shouldNavigateHome = false
	
	// Add this to manage alert priorities
	@State private var activeAlert: ActiveAlert? = nil
	
	enum ActiveAlert: Identifiable {
		case about, mailError, thankYou
		
		var id: Int {
			switch self {
				case .about: return 0
				case .mailError: return 1
				case .thankYou: return 2
			}
		}
	}
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(5)) {
		self._selectedTab = selectedTab
	}
	
	let feedbackTypes = ["General Feedback", "Feature Request", "Report a Bug"]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				// Add tap gesture to dismiss keyboard
				Color.black.opacity(0.001)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.onTapGesture {
						isTextEditorFocused = false
					}
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Banner at top
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70)
							
							VStack(spacing: 20) {
								
								// About button
								Button(action: {
									activeAlert = .about
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
									.background(Color.gray.opacity(0.2))
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
										
										// Custom segmented control with taller buttons
										HStack(spacing: 0) {
											ForEach(feedbackTypes, id: \.self) { type in
												Button(action: {
													feedbackType = type
												}) {
													VStack {
														Text(type)
															.font(.subheadline)
															.multilineTextAlignment(.center)
															.padding(.vertical, 8)
															.padding(.horizontal, 4)
															.minimumScaleFactor(0.8)
													}
													.frame(maxWidth: .infinity)
													.frame(height: 50) // Makes buttons taller
													.background(feedbackType == type ? Color.red.opacity(0.8) : Color.gray.opacity(0.3))
													.foregroundColor(.white)
												}
												.buttonStyle(PlainButtonStyle())
											}
										}
										.cornerRadius(8)
										.overlay(
											RoundedRectangle(cornerRadius: 8)
												.stroke(Color.white.opacity(0.2), lineWidth: 1)
										)
										.padding(.horizontal)
									}
									
									// Feedback message
									VStack(alignment: .leading) {
										Text("Your Message")
											.font(.subheadline)
											.foregroundColor(.white.opacity(0.8))
											.padding(.horizontal)
										
										// Update TextEditor to use focus state
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
											.focused($isTextEditorFocused)
											.toolbar {
												ToolbarItemGroup(placement: .keyboard) {
													Spacer()
													Button("Done") {
														isTextEditorFocused = false
													}
												}
											}
									}
									
									// Submit button
									Button(action: {
										if MFMailComposeViewController.canSendMail() {
											showingMailView = true
										} else {
											activeAlert = .mailError
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
			.alert(item: $activeAlert) { alertType in
				switch alertType {
					case .about:
						return Alert(
							title: Text("About HYF Parents"),
							message: Text("This app was made for Huntley Youth Football and for the Player Parents to put all resources in their hands."),
							version: Text("Version 1.03")
							dismissButton: .default(Text("OK"))
						)
					case .mailError:
						return Alert(
							title: Text("Cannot Send Email"),
							message: Text("Your device is not configured to send emails. Please check your email settings and try again."),
							dismissButton: .default(Text("OK"))
						)
					case .thankYou:
						return Alert(
							title: Text("Thank You!"),
							message: Text("Your feedback has been submitted. We appreciate your input."),
							dismissButton: .default(Text("Close")) {
								shouldNavigateHome = true
							}
						)
				}
			}
			.onChange(of: shouldNavigateHome) {
				if shouldNavigateHome {
					selectedTab = 0
					shouldNavigateHome = false
				}
			}
			.sheet(isPresented: $showingMailView) {
				MailView(
					result: { result in
						switch result {
							case .success:
								// Clear form first
								feedbackMessage = ""
								// Show thank you after a brief delay
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
									activeAlert = .thankYou
								}
							case .failure:
								break
						}
						showingMailView = false
					},
					feedbackType: feedbackType,
					message: feedbackMessage
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
		
		// Set recipient
		viewController.setToRecipients(["hyfredraiders@gmail.com"])
		
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
