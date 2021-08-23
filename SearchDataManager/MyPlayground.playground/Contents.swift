import UIKit

struct RecentSearchWord {
    struct RecentSearchWord: Codable {
        let searchedWord: String
        let searchedStartDate: Date
        let searchedEndDate: Date
        let searchHeadCount: String
        let regionType: String?
        let regionId: String?
        let location: String?

        func isAllMatching(_ new: RecentSearchWord) -> Bool {
            return
                self.searchedWord == new.searchedWord &&
                self.searchedStartDate == new.searchedStartDate &&
                self.searchedEndDate == new.searchedEndDate &&
                self.searchHeadCount == new.searchHeadCount
        }
    }
}

class RecentlySearchManager {
    /// shared instance
    static let shared = RecentlySearchManager()
    /// typealias of RecentlySearchManagerSetCondition(enum case)
    typealias SetCondition = RecentlySearchManagerSetCondition
    /// cases of condition
    enum RecentlySearchManagerSetCondition {
        case removeAndInsert
        case insert
        case remove//(last)
    }
    /// 최근검색어를 저장 할 최대치
    private let MAX_COUNT = 20
    /// 최근 검색목록이 있는지 없는지를 판단하여 view에서 hidden 로직을 수행하기 위한 Relay
    lazy var nullRecentlySearched = PublishRelay<Bool>()
    /// DefaultsKey에 저장된 최근검색어를 가져옴
    private let list: () -> [RecentSearchWord] = { Defaults.shared.get(for: .recentlySearchWord) ?? [] }

    /// for return single item, null result trigger
    func getRecentSearchData() -> [RecentSearchWord] {
        let array = Defaults.shared.get(for: .recentlySearchWord)
        let arrayIsEmpty: ([RecentSearchWord]?) -> Bool = { $0?.count == 0 || $0 == nil }
        defer { arrayIsEmpty(array) ? nullRecentlySearched.accept(true) : nullRecentlySearched.accept(false) }
        return array ?? []
    }
    /// parameter로 전달된 검색데이터를 DefaultsKey에 저장합니다.
    func setRecentSearchData(_ word: [RecentSearchWord]) {
        Defaults.shared.set(word, for: .recentlySearchWord)
    }
    /// DefaultsKey에 저장된 최근검색어를 초기화 합니다.
    func resetRecentlySearched() {
        Defaults.shared.clear(.recentlySearchWord)
    }
    /// DefaultsKey에 저장된 최근검색어가 있는지 Bool 타입으로 반환합니다.
    func hasSearchData() -> Bool {
        return list().count > 0
    }
    /// DefaultsKey에 저장된 최근검색어의 개수가 MAX_COUNT프로퍼티보다 크거나 같은지 Bool 타입으로 반환합니다.
    func isMaximum() -> Bool {
        return list().count >= MAX_COUNT
    }
    /// parameter로 전달된 검색어와 완벽히 일치하는 검색어가 있을 경우 과거 검색어를 복제 후 삭제하고, DefaultsKey에 저장합니다.
    func removeAndSet(_ word: RecentSearchWord) {
        let matchIndex = hasSearchData() ? findAllMatchIndex(word) : nil
        guard let index = matchIndex else { return }
        var temp = list()
        temp.remove(at: index)
        setRecentSearchData(temp)
    }
    /// parameter로 전달된 index에 해당하는 최근검색어를 복제 후 삭제하고, 삭제된 최근검색어 배열을 반환합니다.
    func removeAndReturn(_ index: Int) -> [RecentSearchWord] {
        var temp = list()
        temp.remove(at: index)
        return temp
    }
    /// DefaultsKey에 저장된 가장 마지막 요소를 삭제하고, 전달된 parameter를 DefaultsKey에 insert합니다.
    func removeLastAndSet(_ data: RecentSearchWord) {
        var temp = list()
        temp.removeLast()
        temp.insert(data, at: temp.startIndex)
        setRecentSearchData(temp)
    }
    /// 전달된 parameter를 DefaultsKey에 insert합니다.
    func insertAndSet(_ data: RecentSearchWord) {
        var temp = list()
        temp.insert(data, at: temp.startIndex)
        setRecentSearchData(temp)
    }
    /// 전달된 array parameter에 word를 insert합니다.
    func insertAndSet(_ array: [RecentSearchWord], _ word: RecentSearchWord) {
        var temp = array
        temp.insert(word, at: temp.startIndex)
        setRecentSearchData(temp)
    }
    /// parameter로 전달된 검색어와 완전히 일치하는 데이터가 저장된 데이터 중에 있는지 확인하고, 있다면 해당 index/없다면 nil을 반환합니다.
    func findAllMatchIndex(_ word: RecentSearchWord) -> Int? {
        let matchIndex = list().enumerated().map { $1.isAllMatching(word) ? $0 : nil }.filter { $0 != nil }.first
        guard let index = matchIndex else { return nil }
        return index
    }
    /// array.removeLast()와 insert(,at:)를 합친 합성함수입니다.
    func compRemoveInsert(_ f1: @escaping (Int) -> [RecentSearchWord], _ f2: @escaping ([RecentSearchWord], RecentSearchWord) -> Void) -> (Int, RecentSearchWord) -> Void {
        return { index, word in
            return f2(f1(index), word)
        }
    }
    /// 검색어 저장을 위한 조건을 구하는 합성함수입니다.
    func compForGetCondition(_ f1: @escaping (RecentSearchWord) -> Int?, _ f2: @escaping (Int?) -> SetCondition) -> (RecentSearchWord) -> SetCondition {
        return { word in
            f2(f1(word))
        }
    }
    /// 검색어 저장을 위한 조건을 SetCondition 타입으로 반환합니다.
    func getConditionForSet(_ index: Int?) -> SetCondition {
        if index != nil {
            return .removeAndInsert
        } else if isMaximum() {
            return .remove
        } else {
            return .insert
        }
    }
    /// DefaultsKey에 저장된 최근 검색어 데이터를 관리합니다.
    func manageRecentlySearched(_ word: RecentSearchWord) {
        guard hasSearchData() else {
            // 저장되어 있는 기존 데이터 없음, 비교 없이 바로 저장
            insertAndSet(word)
            return
        }
        // parameter와 완벽히 일치하는 array의 index값
        let matchIndex = findAllMatchIndex(word)
        // 검색어 저장을 위한 조건
        let condition: SetCondition = compForGetCondition(findAllMatchIndex(_:), getConditionForSet(_:))(word)

        switch condition {
        case .removeAndInsert:
            compRemoveInsert(removeAndReturn(_:), insertAndSet(_:_:))(matchIndex ?? 0, word) // 기존 데이터 삭제, 새로 저장
        case .remove:
            removeLastAndSet(word)
        case .insert:
            insertAndSet(word)
        }
    }
}
