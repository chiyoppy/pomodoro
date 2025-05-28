//
//  ContentView.swift
//  pomodoro
//
//  Created by Hiroshi Chiyokawa on 2025/05/28.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PomodoroTimerViewModel()

    var body: some View {
        ZStack {
            PomodoroColorProvider.background.ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer(minLength: 40)
                Text(viewModel.label())
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.stateColor())
                    .padding(.bottom, 8)
                // 言語切替UI例（将来多言語拡張用）
                Picker(viewModel.t("language"), selection: $viewModel.language) {
                    Text("日本語").tag("ja")
                    Text("English").tag("en")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)

                VStack(spacing: 0) {
                    Text(String(format: "%02d", viewModel.timeRemaining / 60))
                        .font(.system(size: 96, weight: .thin, design: .monospaced))
                        .foregroundColor(PomodoroColorProvider.timerText)
                        .frame(maxWidth: .infinity)
                    Text(String(format: "%02d", viewModel.timeRemaining % 60))
                        .font(.system(size: 48, weight: .light, design: .monospaced))
                        .foregroundColor(PomodoroColorProvider.timerSubText)
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)

                VStack(spacing: 20) {
                    Button(action: {
                        if viewModel.isRunning {
                            viewModel.stopTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    }) {
                        Text(viewModel.isRunning ? viewModel.t("pause") : viewModel.t("start"))
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(viewModel.isRunning ? PomodoroColorProvider.pause : viewModel.stateColor())
                            .foregroundColor(.white)
                            .cornerRadius(28)
                    }

                    Button(action: viewModel.resetTimer) {
                        Text(viewModel.t("reset"))
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(PomodoroColorProvider.reset)
                            .foregroundColor(.white)
                            .cornerRadius(28)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
            }
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
