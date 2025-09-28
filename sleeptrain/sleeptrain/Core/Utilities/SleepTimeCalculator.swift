//
//  SleepTimeCalculator.swift
//  sleeptrain
//
//  Created by bishoe01 on 9/23/25.
//

import Foundation

enum SleepTimeCalculator {
    static func isValidSleepDuration(bedTime: Date, wakeTime: Date, minimumHours: Int = 4) -> Bool {
        // 테스트용 임시 코드 - 테스트 완료 후 아래 주석 해제 및 리턴 트루 삭제
        return true

        // 기존 코드 (테스트 완료 후 주석 해제)
        // let sleepMinutes = calculateSleepMinutes(bedTime: bedTime, wakeTime: wakeTime)
        // return sleepMinutes >= (minimumHours * 60)
    }

    static func isTimeInBedTimeRange(_ time: Date) -> Bool {
        // 테스트용 임시 코드 - 테스트 완료 후 아래 주석 해제 및 리턴 트루 삭제
        return true

        // 기존 코드 (테스트 완료 후 주석 해제)
        // let calendar = Calendar.current
        // let hour = calendar.component(.hour, from: time)
        // // 8PM ~ 2AM
        // return hour >= 20 || hour <= 2
    }

    static func isTimeInWakeTimeRange(_ time: Date) -> Bool {
        // 테스트용 임시 코드 - 테스트 완료 후 아래 주석 해제 및 리턴 트루 삭제
        return true

        // 기존 코드 (테스트 완료 후 주석 해제)
        // let calendar = Calendar.current
        // let hour = calendar.component(.hour, from: time)
        // // 3AM ~ 2PM
        // return hour >= 3 && hour <= 14
    }
}
