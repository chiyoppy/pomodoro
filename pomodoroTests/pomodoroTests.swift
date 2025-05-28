//
//  pomodoroTests.swift
//  pomodoroTests
//
//  Created by Hiroshi Chiyokawa on 2025/05/28.
//

import SwiftUI
import Testing

@testable import pomodoro

struct PomodoroTimerViewModelTests {

    // MARK: - Initialization Tests

    @Test("初期状態の確認")
    func initialState() {
        let viewModel = PomodoroTimerViewModel()

        #expect(viewModel.timerState == .focus)
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.pomodoroCount == 0)
        #expect(viewModel.isRunning == false)
    }

    @Test("TimerState duration プロパティの確認")
    func timerStateDuration() {
        #expect(PomodoroTimerViewModel.TimerState.focus.duration == 25 * 60)
        #expect(PomodoroTimerViewModel.TimerState.shortBreak.duration == 5 * 60)
        #expect(PomodoroTimerViewModel.TimerState.longBreak.duration == 15 * 60)
    }

    // MARK: - Timer Control Tests

    @Test("タイマー開始と停止")
    func timerStartStop() {
        let viewModel = PomodoroTimerViewModel()

        // 開始
        viewModel.startTimer()
        #expect(viewModel.isRunning == true)

        // 停止
        viewModel.stopTimer()
        #expect(viewModel.isRunning == false)
    }

    @Test("タイマーリセット")
    func timerReset() {
        let viewModel = PomodoroTimerViewModel()

        // 状態を変更してからリセット
        viewModel.timerState = .shortBreak
        viewModel.timeRemaining = 100
        viewModel.pomodoroCount = 2
        viewModel.startTimer()

        viewModel.resetTimer()

        #expect(viewModel.timerState == .focus)
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.pomodoroCount == 0)
        #expect(viewModel.isRunning == false)
    }

    // MARK: - State Transition Tests

    @Test("フォーカス完了後のショートブレーク遷移")
    func focusToShortBreakTransition() {
        let viewModel = PomodoroTimerViewModel()

        // フォーカス状態から次の状態へ（1回目）
        viewModel.nextState()

        #expect(viewModel.timerState == .shortBreak)
        #expect(viewModel.timeRemaining == 5 * 60)
        #expect(viewModel.pomodoroCount == 1)
    }

    @Test("ショートブレーク完了後のフォーカス遷移")
    func shortBreakToFocusTransition() {
        let viewModel = PomodoroTimerViewModel()
        viewModel.timerState = .shortBreak
        viewModel.pomodoroCount = 1

        viewModel.nextState()

        #expect(viewModel.timerState == .focus)
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.pomodoroCount == 1)
    }

    @Test("4回目フォーカス完了後のロングブレーク遷移")
    func focusToLongBreakTransition() {
        let viewModel = PomodoroTimerViewModel()
        viewModel.pomodoroCount = 3  // 3回完了した状態

        viewModel.nextState()

        #expect(viewModel.timerState == .longBreak)
        #expect(viewModel.timeRemaining == 15 * 60)
        #expect(viewModel.pomodoroCount == 4)
    }

    @Test("ロングブレーク完了後のフォーカス遷移とカウントリセット")
    func longBreakToFocusTransition() {
        let viewModel = PomodoroTimerViewModel()
        viewModel.timerState = .longBreak
        viewModel.pomodoroCount = 4

        viewModel.nextState()

        #expect(viewModel.timerState == .focus)
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.pomodoroCount == 0)
    }

    // MARK: - Pomodoro Cycle Tests

    @Test("完全なポモドーロサイクル")
    func completePomodorooCycle() {
        let viewModel = PomodoroTimerViewModel()

        // 1回目: フォーカス → ショートブレーク
        viewModel.nextState()
        #expect(viewModel.timerState == .shortBreak)
        #expect(viewModel.pomodoroCount == 1)

        // ショートブレーク → フォーカス
        viewModel.nextState()
        #expect(viewModel.timerState == .focus)
        #expect(viewModel.pomodoroCount == 1)

        // 2回目: フォーカス → ショートブレーク
        viewModel.nextState()
        #expect(viewModel.timerState == .shortBreak)
        #expect(viewModel.pomodoroCount == 2)

        // ショートブレーク → フォーカス
        viewModel.nextState()
        #expect(viewModel.timerState == .focus)
        #expect(viewModel.pomodoroCount == 2)

        // 3回目: フォーカス → ショートブレーク
        viewModel.nextState()
        #expect(viewModel.timerState == .shortBreak)
        #expect(viewModel.pomodoroCount == 3)

        // ショートブレーク → フォーカス
        viewModel.nextState()
        #expect(viewModel.timerState == .focus)
        #expect(viewModel.pomodoroCount == 3)

        // 4回目: フォーカス → ロングブレーク
        viewModel.nextState()
        #expect(viewModel.timerState == .longBreak)
        #expect(viewModel.pomodoroCount == 4)

        // ロングブレーク → フォーカス（カウントリセット）
        viewModel.nextState()
        #expect(viewModel.timerState == .focus)
        #expect(viewModel.pomodoroCount == 0)
    }

    // MARK: - Color Tests

    @Test("状態別カラー確認")
    func stateColors() {
        let viewModel = PomodoroTimerViewModel()

        viewModel.timerState = .focus
        #expect(viewModel.stateColor() == PomodoroColorProvider.focus)

        viewModel.timerState = .shortBreak
        #expect(viewModel.stateColor() == PomodoroColorProvider.shortBreak)

        viewModel.timerState = .longBreak
        #expect(viewModel.stateColor() == PomodoroColorProvider.longBreak)
    }

    // MARK: - Label Tests

    @Test("状態ラベル確認")
    func stateLabels() {
        let viewModel = PomodoroTimerViewModel()

        viewModel.timerState = .focus
        #expect(viewModel.label() == viewModel.t("focus"))

        viewModel.timerState = .shortBreak
        #expect(viewModel.label() == viewModel.t("shortBreak"))

        viewModel.timerState = .longBreak
        #expect(viewModel.label() == viewModel.t("longBreak"))
    }

    @Test("特定状態のラベル確認")
    func specificStateLabels() {
        let viewModel = PomodoroTimerViewModel()

        #expect(viewModel.label(for: .focus) == viewModel.t("focus"))
        #expect(viewModel.label(for: .shortBreak) == viewModel.t("shortBreak"))
        #expect(viewModel.label(for: .longBreak) == viewModel.t("longBreak"))
    }

    // MARK: - Internationalization Tests

    @Test("多言語サポート - 英語")
    func englishTranslations() {
        let viewModel = PomodoroTimerViewModel()
        viewModel.language = "en"

        // 基本的な翻訳がfallbackとして動作することを確認
        #expect(!viewModel.t("focus").isEmpty)
        #expect(!viewModel.t("shortBreak").isEmpty)
        #expect(!viewModel.t("longBreak").isEmpty)
        #expect(!viewModel.t("start").isEmpty)
        #expect(!viewModel.t("pause").isEmpty)
        #expect(!viewModel.t("reset").isEmpty)
    }

    @Test("多言語サポート - 日本語")
    func japaneseTranslations() {
        let viewModel = PomodoroTimerViewModel()
        viewModel.language = "ja"

        // 基本的な翻訳がfallbackとして動作することを確認
        #expect(!viewModel.t("focus").isEmpty)
        #expect(!viewModel.t("shortBreak").isEmpty)
        #expect(!viewModel.t("longBreak").isEmpty)
        #expect(!viewModel.t("start").isEmpty)
        #expect(!viewModel.t("pause").isEmpty)
        #expect(!viewModel.t("reset").isEmpty)
    }

    @Test("存在しないキーのフォールバック")
    func nonExistentKeyFallback() {
        let viewModel = PomodoroTimerViewModel()
        let nonExistentKey = "nonExistentKey"

        #expect(viewModel.t(nonExistentKey) == nonExistentKey)
    }
}

// MARK: - Color Provider Tests

struct PomodoroColorProviderTests {

    @Test("カラープロバイダーの定数確認")
    func colorConstants() {
        // カラーが適切に定義されていることを確認
        #expect(PomodoroColorProvider.background != nil)
        #expect(PomodoroColorProvider.focus != nil)
        #expect(PomodoroColorProvider.shortBreak != nil)
        #expect(PomodoroColorProvider.longBreak != nil)
        #expect(PomodoroColorProvider.pause != nil)
        #expect(PomodoroColorProvider.reset != nil)
        #expect(PomodoroColorProvider.timerText != nil)
        #expect(PomodoroColorProvider.timerSubText != nil)
    }

    @Test("各状態の色が異なることを確認")
    func uniqueStateColors() {
        #expect(PomodoroColorProvider.focus != PomodoroColorProvider.shortBreak)
        #expect(PomodoroColorProvider.focus != PomodoroColorProvider.longBreak)
        #expect(PomodoroColorProvider.shortBreak != PomodoroColorProvider.longBreak)
    }
}
