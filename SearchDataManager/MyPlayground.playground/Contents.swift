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
    static let shared = RecentlySearchManager()

    /// 최근검색어를 저장 할 최대치
    let MAX_COUNT = 20
    /// 모든 검색조건이 과거 검색조건과 완벽히 부합할 때, 그 index를 받아오기 위한 변수
    var equalToIndex: Int?
    ///
    var removeIndex: Int?
    /// 최근 검색목록이 있는지 없는지를 판단하여 view에서 hidden 로직을 수행하기 위한 Relay
    lazy var nullRecentlySearched = PublishRelay<Bool>()

    private let list = Defaults.shared.get(for: .recentlySearchWord) ?? []

    /// userDefaults에 저장된 데이터를 가져옴
    func getRecentSearchData() -> [RecentSearchWord] {
        let array = Defaults.shared.get(for: .recentlySearchWord)
        let arrayIsEmpty: ([RecentSearchWord]?) -> Bool = { $0?.count == 0 || $0 == nil }
        defer { arrayIsEmpty(array) ? nullRecentlySearched.accept(true) : nullRecentlySearched.accept(false) }
        return array ?? []
    }
    private func setRecentSearchData(_ data: [RecentSearchWord]) {
        Defaults.shared.set(data, for: .recentlySearchWord)
    }
    private func hasSearchData() -> Bool {
        return list.count > 0
    }
    private func isMaximum() -> Bool {
        return list.count == MAX_COUNT
    }

    func setRecentlySearched(_ word: RecentSearchWord) {
        guard hasSearchData() else {
            // 아무 데이터가 존재하지 않아 바로 저장
            insertAndSet(word)
            return
        }
        let matchIndex = findAllMatchIndex(word)
        guard isMaximum() else {
            if matchIndex != nil {
                let execute = comp(removeAndReturn(_:), insertAndSet(_:_:))
                execute(matchIndex ?? 0, word)
            } else {
                insertAndSet(word)
            }
            return
        }
        if matchIndex != nil {
            let execute = comp(removeAndReturn(_:), insertAndSet(_:_:))
            execute(matchIndex ?? 0, word)
        } else {
            removeLastAndSet(word)
        }
    }

    func insertAndSet(_ data: RecentSearchWord) {
        var temp = list
        temp.insert(data, at: temp.startIndex)
        setRecentSearchData(temp)
    }

    func insertAndSet(_ array: [RecentSearchWord], _ word: RecentSearchWord) {
        var temp = array
        temp.insert(word, at: temp.startIndex)
        setRecentSearchData(temp)
    }

    func removeAndReturn(_ index: Int) -> [RecentSearchWord] {
        var temp = list
        temp.remove(at: index)
        return temp
    }

    func removeLastAndSet(_ data: RecentSearchWord) {
        var temp = list
        temp.removeLast()
        temp.insert(data, at: temp.startIndex)
        setRecentSearchData(temp)
    }

    func comp(_ f1: @escaping (Int) -> [RecentSearchWord], _ f2: @escaping ([RecentSearchWord], RecentSearchWord) -> Void) -> (Int, RecentSearchWord) -> Void {
        return { index, word in
            return f2(f1(index), word)
        }
    }

    func findAllMatchIndex(_ word: RecentSearchWord) -> Int? {
        let matchIndex = list.enumerated().map { $1.isAllMatching(word) ? $0 : nil }
        return matchIndex.first ?? nil
    }

    func removeSearchData(_ word: RecentSearchWord) {
        let matchIndex = hasSearchData() ? findAllMatchIndex(word) : nil
        guard let index = matchIndex else { return }
        var temp = list
        temp.remove(at: index)
        setRecentSearchData(temp)
    }

    func resetRecentlySearched() {
        Defaults.shared.clear(.recentlySearchWord)
    }
}
