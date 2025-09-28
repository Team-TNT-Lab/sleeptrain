import Foundation

public enum DateFormatting {
    /// "M월 d일" 한국어 표기를 위한 포맷터
    static let monthDayKoreanFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    /// "HH:mm" 시간 포맷터
    public static let hourMinuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    /// 오늘 또는 지정한 날짜를 "M월 d일"로 반환
    public static func monthDayKoreanString(for date: Date = Date()) -> String {
        monthDayKoreanFormatter.string(from: date)
    }
    
    /// 시간을 "HH:mm" 형태로 반환
    public static func hourMinuteString(from date: Date) -> String {
        hourMinuteFormatter.string(from: date)
    }
    
    /// 시간을 받았을때 baseDate에 해당 시간을 합친 형태로 반환해줌
    public static func dateFromTimeString(_ timeString: String, baseDate: Date = Date()) -> Date {
        let calendar = Calendar.current
        
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1])
        else {
            // 에러대신 받은날짜 그대로 반환
            return baseDate
        }
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: baseDate) ?? baseDate
    }
    
    /// 해당날짜 요일 추출
    public static func extractDay(from date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    /// 시작날짜 반환
    public static func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    /// 날짜에 일수를 더한 날짜를 반환
    public static func addDays(_ days: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }

    /// 주어진 날짜가 오늘인지 확인
    public static func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    // MON,TUE 형태로 만들어주는 함수
    static func dayAbbrev(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    /// 오늘 요일의 인덱스를 반환 (월=0 ... 일=6)
    static func todayWeekdayIndex() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return (weekday + 5) % 7
    }
    
    // 양수(출발 전) 남은 시간 문자열
    static func remainingTimeString(until target: Date) -> String {
        let now = Date()
        let interval = max(0, Int(target.timeIntervalSince(now)))
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(minutes)분"
        }
    }
    
    // 음수(출발 후) 지연 시간 문자열
    static func delayString(since departure: Date) -> String {
        let now = Date()
        let delay = max(0, Int(now.timeIntervalSince(departure)))
        let hours = delay / 3600
        let minutes = (delay % 3600) / 60
        
        if hours > 0 && minutes > 0 {
            return "지연 \(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "지연 \(hours)시간"
        } else {
            return "지연 \(minutes)분"
        }
    }
    
    // 도착까지 남은 시간 계산(자정 넘김 고려)
    public static func remainingTimeToArrival(fromNow now: Date, endTimeText: String) -> String {
        let comps = endTimeText.split(separator: ":")
        guard comps.count == 2,
              let h = Int(comps[0]),
              let m = Int(comps[1])
        else {
            return ""
        }
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: now)
        var arrival = cal.date(bySettingHour: h, minute: m, second: 0, of: startOfToday) ?? now
        if arrival <= now {
            arrival = cal.date(byAdding: .day, value: 1, to: arrival) ?? arrival
        }
        let diff = cal.dateComponents([.hour, .minute], from: now, to: arrival)
        let hours = max(0, diff.hour ?? 0)
        let minutes = max(0, diff.minute ?? 0)
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(minutes)분"
        }
    }

    /// 취침 시간과 기상 시간 사이의 수면 시간을 분 단위로 계산 (자정 넘김 고려)
    public static func calculateSleepMinutes(bedTime: Date, wakeTime: Date) -> Int {
        let calendar = Calendar.current

        // 각 시간을 분 단위로 변환
        let bedMinutes = calendar.component(.hour, from: bedTime) * 60 + calendar.component(.minute, from: bedTime)
        let wakeMinutes = calendar.component(.hour, from: wakeTime) * 60 + calendar.component(.minute, from: wakeTime)
        
        // 자정을 넘겼는지 확인하고 수면 시간 계산
        return wakeMinutes >= bedMinutes ?
            wakeMinutes - bedMinutes :
            (24 * 60) - bedMinutes + wakeMinutes
    }

    /// 취침 시간 , 기상 시간 비교 수면 시간을 문자열로 계산
    public static func calculateSleepDuration(bedTime: Date, wakeTime: Date, isDetailFormat: Bool = true) -> String {
        let sleepMinutes = calculateSleepMinutes(bedTime: bedTime, wakeTime: wakeTime)
        let hours = sleepMinutes / 60
        let minutes = sleepMinutes % 60

        if isDetailFormat {
            return minutes > 0 ?
                "\(hours)시간 \(minutes)분 자게 돼요" :
                "\(hours)시간 자게 돼요"
        } else {
            return minutes > 0 ?
                "\(hours)시간 \(minutes)분" :
                "\(hours)시간"
        }
    }

    /// 주간 표시용 날짜 생성
    static func generateDateRange() -> [StreakDay] {
        let today = startOfDay(for: Date())
        let todayIndex = todayWeekdayIndex()
        
        let currentWeekMonday = addDays(-todayIndex, to: today)
        
        let startDate = addDays(-21, to: currentWeekMonday)
        let endDate = addDays(6, to: currentWeekMonday)
        
        var dates: [StreakDay] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(StreakDay(date: currentDate, isCompleted: false))
            currentDate = addDays(1, to: currentDate)
        }
        
        return dates
    }
}
