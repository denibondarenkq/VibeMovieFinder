import Foundation

class VibeSelectionViewModel {
    var buttonTitles: [String] = []

    func loadButtonTitles(completion: @escaping (Result<Void, Error>) -> Void) {
        let prompt = """
        Generate a list of 60-70 unique movie vibes, each represented by an emoji and a 1-2 word description. The vibes should correspond to specific movie genres, subgenres, studios, or well-known film themes, such as Teen, Old classic, A24 Studio, Cyberpunk,  Action-Comedy, Nordic, Marvel Studio, Indie, Dance, Oscar-Winning, Love & Passion, Vampire. Focus on creating vibes that reflect actual movie genres and moods, rather than abstract concepts like 'cold' or 'sea'. Format the output as a JSON array where each item is an object with keys 'emoji' and 'description'.
        """
        
        GeminiService.shared.generateContent(prompt: prompt) { (result: Result<[Vibe], Error>) in
            switch result {
            case .success(let vibes):
                self.buttonTitles = vibes.compactMap { vibe in
                    return "\(vibe.emoji) \(vibe.description)"
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSelectedVibes(filledButtons: [Bool]) -> [String] {
        return zip(buttonTitles, filledButtons).compactMap { $1 ? $0 : nil }
    }
}
