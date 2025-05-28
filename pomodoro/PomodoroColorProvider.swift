// 色の管理クラス
import SwiftUI

struct PomodoroColorProvider {
    static let background = Color(red: 13/255, green: 4/255, blue: 4/255)
    static let focus = Color(red: 1.0, green: 76/255, blue: 76/255) // 赤系
    static let shortBreak = Color(red: 77/255, green: 218/255, blue: 110/255) // 緑系
    static let longBreak = Color(red: 76/255, green: 172/255, blue: 1.0) // 青系
    static let pause = Color.orange
    static let reset = Color.gray.opacity(0.5)
    static let timerText = Color.white
    static let timerSubText = Color.white.opacity(0.7)
}
