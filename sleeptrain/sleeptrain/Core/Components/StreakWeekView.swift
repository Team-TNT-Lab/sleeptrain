//
//  StreakWeekView.swift
//  sleeptrain
//
//  Created by Dean_SSONG on 9/24/25.
//

import SwiftUI

struct StreakWeekView: View {
    let days: [StreakDay]

    @State private var currentWeekOffset = 0
    
    // 오늘 요일 인덱스 (월=0 ... 일=6) - 헤더 강조는 현재 페이지와 무관하게 유지
    private var todayWeekdayHeaderIndex: Int {
        return DateFormatting.todayWeekdayIndex()
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // 요일 헤더: 오늘 요일에 회색 원 강조 (페이징과 무관하게 항상 같은 요일에 표시)
            HStack(spacing: 0) {
                let weekdays = ["M", "T", "W", "T", "F", "S", "S"]
                ForEach(Array(weekdays.enumerated()), id: \.offset) { index, weekday in
                    let isToday = index == todayWeekdayHeaderIndex
                    ZStack {
                        if isToday {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 22, height: 22)
                        }
                        Text(weekday)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(isToday ? .white : .white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                }
            }
            
            // 스크롤 가능한 날짜와 상태 (주 단위 페이징)
            TabView(selection: $currentWeekOffset) {
                ForEach(Array(visibleWeekGroups.enumerated()), id: \.offset) { weekIndex, week in
                    HStack(spacing: 0) {
                        ForEach(week) { day in
                            DayCellView(day: day)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .tag(weekIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)
            .onAppear {
                currentWeekOffset = todayWeekIndex
            }
        }
    }
    
    private var todayWeekIndex: Int {
        weekGroups.firstIndex { week in
            week.contains { $0.isToday }
        } ?? 0
    }
    
    private var weekGroups: [[StreakDay]] {
        stride(from: 0, to: days.count, by: 7).map { startIndex in
            let endIndex = min(startIndex + 7, days.count)
            var week = Array(days[startIndex ..< endIndex])
            
            while week.count < 7 {
                week.append(StreakDay(date: Date.distantPast, isCompleted: false))
            }
            return week
        }
    }
    
    // 이번주까지만 표시
    private var visibleWeekGroups: [[StreakDay]] {
        return Array(weekGroups.prefix(through: todayWeekIndex))
    }
}
