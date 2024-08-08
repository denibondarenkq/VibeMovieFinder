//
//  MovieDetailViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 04.08.2024.
//

import UIKit

protocol MovieDetailViewModelDelegate: AnyObject {
    func didFetchedMovieDetails()
}

class MovieDetailViewModel {
    private let movie: MovieSummary
        private var credits: [Cast] = []
        private var genres: [Genre] = []
        private var recommendations: [MovieSummary] = []
//        private var images: [Image] = []
    
    weak var delegate: MovieDetailViewModelDelegate?


    
    enum SectionType {
        case backdrop(viewModel: MovieBackdropCollectionCellViewModel)
        case overview
//        case images(viewModels: [ImageCellViewModel])
//        case genres(viewModels: [GenreCellViewModel])
        case cast(viewModels: [MovieCreditsCollectionViewCellViewModel])
        case recommendations(viewModels: [MovieTableCellViewModel])
    }
    public var sections: [SectionType] = []
    
    init(movie: MovieSummary) {
        self.movie = movie
    }
    
    private func setUpSections() {
        sections = [
            .backdrop(viewModel: MovieBackdropCollectionCellViewModel(imageUrl: movie.backdropPath)),
            .cast(viewModels: credits.compactMap({ cast in
                return MovieCreditsCollectionViewCellViewModel(
                    name: cast.name,
                    character: cast.character,
                    job: cast.job,
                    imageUrl: cast.profilePath
                )
            }))
//                        .recommendations(viewModels: recommendations.map { movie in
//                            return MovieTableCellViewModel(movie: movie, genres: <#[Genre]#>)
//                        })
        ]
        delegate?.didFetchedMovieDetails()
    }

    public func fetchContent() {
           let dispatchGroup = DispatchGroup()
           var fetchError: Error?

           dispatchGroup.enter()
           fetchCredits { result in
               switch result {
               case .success(let credits):
                   self.credits = credits.cast
               case .failure(let error):
                   fetchError = error
               }
               dispatchGroup.leave()
           }
           
//           dispatchGroup.enter()
//           fetchGenres { result in
//               switch result {
//               case .success(let genres):
//                   self.genres = genres.genres
//               case .failure(let error):
//                   fetchError = error
//               }
//               dispatchGroup.leave()
//           }
           
//           dispatchGroup.enter()
//           fetchImages { result in
//               switch result {
//               case .success(let images):
//                   self.images = images.backdrops
//               case .failure(let error):
//                   fetchError = error
//               }
//               dispatchGroup.leave()
//           }
//           
//           dispatchGroup.enter()
//           fetchRecommendations { result in
//               switch result {
//               case .success(let recommendations):
//                   self.recommendations = recommendations.results
//               case .failure(let error):
//                   fetchError = error
//               }
//               dispatchGroup.leave()
//           }

           dispatchGroup.notify(queue: .main) {
               guard fetchError == nil else {

                   return
               }

               self.setUpSections()
           }
       }

       private func fetchCredits(completion: @escaping (Result<MovieCredits, Error>) -> Void) {
           let endpoint = Endpoint.movieCredits(movieId: movie.id)
           NetworkService.shared.execute(endpoint: endpoint, expecting: MovieCredits.self, completion: completion)
       }

       private func fetchGenres(completion: @escaping (Result<Genres, Error>) -> Void) {
           NetworkService.shared.execute(endpoint: .genresMovieList, expecting: Genres.self, completion: completion)
       }

//       private func fetchImages(completion: @escaping (Result<ImagesResponse, Error>) -> Void) {
//           let endpoint = Endpoint.movieImages(movieId: movie.id)
//           NetworkService.shared.execute(endpoint: endpoint, expecting: ImagesResponse.self, completion: completion)
//       }

       private func fetchRecommendations(completion: @escaping (Result<MoviesSummaryPage, Error>) -> Void) {
//           let endpoint = Endpoint.movieRecommendations(movieId: movie.id)
//           NetworkService.shared.execute(endpoint: endpoint, expecting: MoviesSummaryPage.self, completion: completion)
       }

    public var title: String {
        movie.title
    }
}
