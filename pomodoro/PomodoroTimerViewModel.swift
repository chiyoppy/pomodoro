import Foundation
// ViewModel for Pomodoro Timer
import SwiftUI

public class PomodoroTimerViewModel: ObservableObject {
    enum TimerState: String, CaseIterable {
        case focus
        case shortBreak
        case longBreak
    }

    @Published var language: String = Locale.current.language.languageCode?.identifier ?? "ja"  // デフォルト:システム言語

    @Published var isRunning = false
    @Published var timerState: TimerState = .focus
    @Published var timeRemaining = 25 * 60
    @Published var pomodoroCount = 0

    private var translations: [String: [String: String]] = [:]

    init() {
        loadTranslations()
    }

    private func loadTranslations() {
        guard let url = Bundle.main.url(forResource: "Localizable.strings", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let dict = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]]
        else {
            return
        }
        translations = dict
    }

    func t(_ key: String) -> String {
        let lang = translations[language] != nil ? language : "en"
        return translations[lang]?[key] ?? key
    }

    private var timer: Timer? = nil

    // ラベル取得
    func label(for state: TimerState? = nil) -> String {
        let key: String
        switch state ?? timerState {
        case .focus: key = "focus"
        case .shortBreak: key = "shortBreak"
        case .longBreak: key = "longBreak"
        }
        return t(key)
    }

    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.isRunning = false
                    self.nextState()
                }
            }
            isRunning = true
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func resetTimer() {
        stopTimer()
        timerState = .focus
        timeRemaining = 25 * 60
        pomodoroCount = 0
    }

    func nextState() {
        switch timerState {
        case .focus:
            pomodoroCount += 1
            if pomodoroCount % 4 == 0 {
                timerState = .longBreak
                timeRemaining = 15 * 60
            } else {
                timerState = .shortBreak
                timeRemaining = 5 * 60
            }
        case .shortBreak:
            timerState = .focus
            timeRemaining = 25 * 60
        case .longBreak:
            timerState = .focus
            timeRemaining = 25 * 60
            pomodoroCount = 0
        }
    }

    func stateColor() -> Color {
        switch timerState {
        case .focus:
            return Color(red: 1.0, green: 76 / 255, blue: 76 / 255)  // 赤系
        case .shortBreak:
            return Color(red: 77 / 255, green: 218 / 255, blue: 110 / 255)  // 緑系
        case .longBreak:
            return Color(red: 76 / 255, green: 172 / 255, blue: 1.0)  // 青系
        }
    }
}
