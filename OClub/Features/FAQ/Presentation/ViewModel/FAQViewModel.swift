//
//  ViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/17/25.
//

import SwiftUI

final class FAQViewModel: ObservableObject {
    @Published var mainItems: [MainFAQ] = []
    @Published var faqItems: [FAQItem] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        mainItems = [
            MainFAQ(imageName: "bell", backgroundColor: .lightBlue, foregroundColor: .accentColor, title: "동호회\n가입/탈퇴안내"),
            MainFAQ(imageName: "exclamationmark.circle", backgroundColor: .lightYellow, foregroundColor: .cjYellow, title: "동호회\n운영 지침"),
            MainFAQ(imageName: "dollarsign.circle", backgroundColor: .lightRed, foregroundColor: .cjRed, title: "활동비\n정산 가이드")
        ]
        
        faqItems = [
            FAQItem(question: "동호회 관련 문의 사항은 어떤 분께 문의 드려야 하나요?", answer: "사내 동호회 관련 문의는 담당자이신 조직문화 팀 윤병준님, 박지혜님께 문의 주시면 됩니다."),
            FAQItem(question: "동호회는 어떻게 개설하나요?", answer: "1. CJ World 화면에서 결재 창을 클릭합니다.\n2. 기안하기 클릭 > CJ올리브네트웍스 클릭 > 검색창에 동호회를 입력합니다.\n3.[CJ올리브네트웍스] 신규 동호회 개설 심의 요청 신청서 양식을 클릭합니다.\n4.전결라인\n-결재: 이용욱님(인사담당)\n-조정: 윤병준님(조직문화팀)\n-참조: 김성오님/박지혜님(조직문화팀)\n-기안: 신청자\n신규 동호회 개설 심의 요청서 작성 후 전결라인에 맞춰서 상신합니다."),
            FAQItem(question: "동호회 개설 시 주의사항은 무엇인가요?", answer: "신규 동호회 개설을 위해서는 발기인 10명(회장, 총무 포함)이상이 필요하며, 명단(성명, 사번, 소속부서) 제출이 필요합니다.\n신규 동호회 개설 전 사내 동호회 컨플루언스에서 초기 회원 모집을 위한 홍보 활동이 가능합니다."),
            FAQItem(question: "사내 동호회 회사 지원금 한도 조정 안내", answer: "2024년 3월부터 기존 인당 2만원/월에서 인당 3만원/월로 회사 지원금이 상향 조정 되었습니다."),
            FAQItem(question: "동호회 월별 활동 결과는 어떻게 보고하나요?", answer: "월별 활동 결과 보고서 같은 경우, 동호회 회장이 O'Club 앱(메인 > 활동보고서 작성하기)에서 정해진 양식에 따라 간편하게 작성이 가능합니다."),
            FAQItem(question: "매달 동호회 참여는 어떻게 정해지나요?", answer: "O'Club 앱 > 일정 탭에서 소속된 동호회의 모임을 확인한 후, 참석 여부를 체크하시면 모든 동호회원들의 참석 여부가 동호회 회장에게 보여집니다."),
            FAQItem(question: "전체 동호회를 한눈에 보고 싶으면 어떻게 해야하나요?", answer: "O'Club 앱 > 소개 탭에서 카테고리로 분류된 모든 사내 동호회를 한눈에 확인할 수 있습니다.\n특정 동호회 리스트를 클릭하면 상세 소개 내용을 확인할 수 있습니다."),
            FAQItem(question: "동호회 해산도 가능한가요?", answer: "특별한 사유 없이 2개월 내 1회 이상 활동하지 않았을 경우, 특별한 사유가 있는 경우를 제외하고 동호회 해산이 가능합니다.\n또한, 목적이 변질되어 불건전한 활동을 하거나 안전사고나 불화, 성희롱 사고, 부정 등이 발생하는 경우 동호회를 해산합니다.\n그 외 동호회 활동 운영지침을 준수하지 않거나 사내 규정을 위반한 경우 동호회를 해산할 수 있습니다."),
            FAQItem(question: "동호회 최대 가입 기준은 무엇인가요?", answer: "임직원은 최대 2개까지 동호회 가입이 가능합니다.")
            
        ]
    }
    
    func routeFor(item: MainFAQ) -> FAQDetailType? {
        switch item.title {
        case "동호회\n가입/탈퇴안내":
            return .joinAndLeave
        case "동호회\n운영 지침":
            return .operationGuide
        case "활동비\n정산 가이드":
            return .financeGuide
        default:
            return nil
        }
    }
}
