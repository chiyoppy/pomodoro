// 色の管理クラス
import SwiftUI

struct PomodoroColorProvider {
    static let background = Color(red: 13.0 / 255.0, green: 4.0 / 255.0, blue: 4.0 / 255.0)
    static let focus = Color(red: 1.0, green: 76.0 / 255.0, blue: 76.0 / 255.0) // 赤系
    static let shortBreak = Color(red: 77.0 / 255.0, green: 218.0 / 255.0, blue: 110.0 / 255.0) // 緑系
    static let longBreak = Color(red: 76.0 / 255.0, green: 172.0 / 255.0, blue: 1.0) // 青系
    static let pause = Color.orange
    static let reset = Color.gray.opacity(0.5)
    static let timerText = Color.white
    static let timerSubText = Color.white.opacity(0.7)
}
