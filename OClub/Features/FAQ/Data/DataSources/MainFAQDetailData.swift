//
//  RemoteFAQRepository.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import Foundation

protocol FAQRemoteDataSource {
    func fetchMainFAQDetail(type: FAQDetailType) async throws -> MainFAQDetailItem
}

final class MainFAQDummyDataSource: FAQRemoteDataSource {
    func fetchMainFAQDetail(type: FAQDetailType) async throws -> MainFAQDetailItem {
        switch type {
        case .joinAndLeave:
            return makeJoinAndLeaveDetail()
        case .operationGuide:
            return makeOperationGuideDetail()
        case .financeGuide:
            return makeFinanceGuideDetail()
        }
    }
    
    // MARK: – Builders
    
    private func makeJoinAndLeaveDetail() -> MainFAQDetailItem {
        MainFAQDetailItem(
            title: "동호회 가입/탈퇴 안내",
            author: "조직문화팀 윤병준님",
            blocks: [
                .text("1. CJ World 화면에서 왼쪽 중간에 결재 창을 클릭합니다."),
                .image("faq1_1"),
                .text("2. 기안하기 클릭 → CJ 올리브네트웍스 클릭 → 검색창에 '동호회'를 입력합니다."),
                .image("faq1_2"),
                .text("3. [CJ올리브네트웍스] 동호회 가입/탈퇴 신청서 양식을 클릭합니다."),
                .image("faq1_3"),
                .text("""
    4. 전결라인
    - 결재 : 윤병준님 (조직문화팀)
    - 조정 : 동호회 회장
    - 수신 : 김성오님 (조직문화팀), 박지혜님 (조직문화팀)
    - 기안 : 신청자
    ※ 동호회 가입/탈퇴 신청서 작성 후 전결라인에 맞춰서 상신합니다.
    """),
                .image("faq1_4")
            ]
        )
    }
    
    private func makeOperationGuideDetail() -> MainFAQDetailItem {
        MainFAQDetailItem(
            title: "동호회 운영 지침",
            author: "조직문화팀 윤병준님",
            blocks: [
                .image("faq2_1"),
                .image("faq2_2")
            ]
        )
    }
    
    private func makeFinanceGuideDetail() -> MainFAQDetailItem {
        MainFAQDetailItem(
            title: "활동비 정산 가이드",
            author: "조직문화팀 윤병준님",
            blocks: [
                .text("1. E-ACCOUNTING 법인카드 경비처리 내역을 체크하고 선택합니다."),
                .image("faq3_1"),
                .text("""
    2. ① 귀속구분 → 3000001(인사담당) 입력합니다 (*부서권한 신청 後 가능)
       - 부서권한 신청 : 이어카운팅 > 기준정보 > 사용자 권한 신청
    ② 부가증빙에 제출 서류를 첨부합니다 (P3 참조)
    ③ 계정코드 → 51030307(복리후생행사비-동호회활동비)를 선택합니다.
    ④ 적요 → ‘OO월 OO동호회 활동비 정산’ 내용을 입력합니다.
    ⑤ 저장 버튼 클릭합니다.
    """),
                .image("faq3_2"),
                .text("""
    3. ① 증빙유형에 기타서류를 선택합니다.
       ② 파일 추가 버튼을 클릭합니다.
       ③ 제출서류 추가한 후 저장 버튼을 누릅니다.
    ※ 제출서류
    - 동호회 활동보고서 (컨플루언스 URL 의견란에 공유)
    - 단체사진 (타임스탬프 앱 촬영, 마스크 벗고 얼굴보이게 촬영, 사진에 확정된 인원수 한해서 실비지급)
    - 영수증 (법카영수증/동호회비 영수증) 분리해서 첨부
    """),
                .image("faq3_3"),
                .text("""
    4. 전자 결재 버튼을 클릭한 후 전결라인 맞추어 25일 안으로 품의 상신 진행합니다.
    ※ 결재선
    - 결재  : 윤병준님 (조직문화팀)
    - 합의  : 박지혜님 (조직문화팀)
    - 조정  : 동호회 회장
    """),
                .image("faq3_4")
            ]
        )
    }
}
