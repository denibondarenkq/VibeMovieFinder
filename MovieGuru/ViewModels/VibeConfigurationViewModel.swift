import Foundation

class VibeConfigurationViewModel {
    var buttonTitles: [String] = []

    func loadButtonTitles(completion: @escaping () -> Void) {
        buttonTitles = ["🤢 Action", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy", "🤲 Comedy", "💂‍♂️ Drama", "🤽 Horror", "🫏 Sci-Fi", "🐝 Documentary", "🦸‍♂️ Thriller", "👨‍🎨 Adventure", "🤷‍♀️ Fantasy"]
        completion()
    }
    
    func getSelectedVibes(filledButtons: [Bool]) -> [String] {
        return zip(buttonTitles, filledButtons).compactMap { $1 ? $0 : nil }
    }
}
