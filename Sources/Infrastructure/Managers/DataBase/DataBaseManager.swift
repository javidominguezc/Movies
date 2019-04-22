//
//  DataBaseManager.swift
//  Movies
//
//  Created by Javier Dominguez on 21/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBaseManager {
    
    //MARK: Private
    private let context: NSManagedObjectContext
    
    //MARK: - Shared Instance
    static let shared: DataBaseManager = DataBaseManager()
    
    private init() {
        
        // get the container
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // get the context
        context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Movie methods
    
    // MARK: - Load methods
    private func loadMovieData(id: Int) -> MovieBaseModel? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return nil
            }
            
            let data = result[0] as! Movies
            let movie = MovieBaseModel(id: Int(data.id), title: data.title, imagePath: data.imageSmallPath, voteCount: Int(data.voteCount))
            return movie
        } catch {
            
            DLog("DB: Failed Loading")
            return nil
        }
    }
    
    func loadMoviesData() -> [MovieBaseModel]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        do {
            
            var movies = [MovieBaseModel]()
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return nil
            }
            
            let moviesDB = result as! [Movies]
            for movieDb in moviesDB {
                
                let movie = MovieBaseModel(id: Int(movieDb.id), title: movieDb.title, imagePath: movieDb.imageSmallPath, voteCount: Int(movieDb.voteCount))
                movies.append(movie)
            }
            
            return movies
        } catch {
            
            DLog("DB: Failed Loading")
            return nil
        }
    }
    
    func loadImageData(id: Int, isSmall: Bool) -> Data? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return nil
            }
            
            let movie = result[0] as! Movies
            if isSmall {
                return movie.imageSmall
            } else {
                
                return movie.imageBig
            }
        } catch {
            
            DLog("DB: Failed Loading")
            return nil
        }
    }
    
    func loadVideos(id: Int) -> [VideoBaseModel]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return nil
            }
            
            let movie = result[0] as! Movies
            
            // create video to return
            var videos: [VideoBaseModel]?
            if let videosDB = movie.videos, videosDB.count > 0 {
                
                videos = []
                for case let videoDB as Videos in videosDB {
                    
                    let video = VideoBaseModel(id: Int(videoDB.id), key: videoDB.key, name: videoDB.name, site: videoDB.site, type: videoDB.type)
                    videos?.append(video)
                }
            }
            
            return videos
        } catch {
            
            DLog("DB: Failed Loading")
            return nil
        }
    }
    
    func loadMovieDetailsData(id: Int) -> MovieDetailBaseModel? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return nil
            }
            
            let data = result[0] as! Movies
            
            // create genres to return
            var genres: [GenreBaseModel]?
            if let genresDB = data.genres, genresDB.count > 0 {
                
                genres = []
                for case let genreDB as Genres in genresDB {
                    
                    let genre = GenreBaseModel(id: Int(genreDB.id), name: genreDB.name)
                    genres?.append(genre)
                }
            }
            let movieDetails = MovieDetailBaseModel(id: Int(data.id), title: data.title, imagePath: data.imageBigPath, genres: genres, releaseDate: data.releaseDate, overview: data.overview)
            return movieDetails
        } catch {
            
            DLog("DB: Failed Loading")
            return nil
        }
    }
    
    // MARK: - Save methods
    
    private func createMovieData(_ movie: MovieBaseModel) {
        
        let movieDb = Movies(context: context)
        
        // add data to the record
        movieDb.id = Int32(movie.id)
        movieDb.title = movie.title
        movieDb.imageSmallPath = movie.imagePath
        movieDb.voteCount = Int32(movie.voteCount)
        
        saveContext()
    }
    
    func saveMoviesData(movies: [MovieBaseModel]) {
        
        // find data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        
        for movie in movies {
            
            request.predicate = NSPredicate(format: "id = %d", movie.id)
            do {
                
                let result = try context.fetch(request)
                if result.isEmpty {
                    
                    // data doesn't exist
                    // CREATE MOVIE
                    createMovieData(movie)
                } else {
                    
                    // data exist
                    // UPDATE MOVIE
                    let movieDB = result[0] as! Movies
                    movieDB.title = movie.title
                    movieDB.imageSmallPath = movie.imagePath
                    movieDB.voteCount = Int32(movie.voteCount)
                }
            } catch {
                
                DLog("DB: Failed Loading")
            }
        }
        
        saveContext()
    }
    
    func saveMovieDataDetails(id: Int, movieDetails: MovieDetailBaseModel) {
        
        // find data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                // data doesn't exist
                
                // CREATE DETAILS
            } else {
                
                // UPDATE DETAILS
                let movieDB = result[0] as! Movies
                movieDB.imageBigPath = movieDetails.imagePath
                movieDB.releaseDate = movieDetails.releaseDate
                movieDB.overview = movieDetails.overview
                
                // remove all genres
                if let genres = movieDB.genres {
                    
                    for case let genre as Genres in genres {
                        
                        context.delete(genre)
                    }
                    movieDB.removeFromGenres(genres)
                }
                saveContext()
                
                // create genres
                if let genres = movieDetails.genres {
                    
                    saveGenres(id: id, genres: genres)
                }
            }
        } catch {
            
            DLog("DB: Failed Loading")
        }
    }
    
    private func saveGenres(id: Int, genres: [GenreBaseModel]) {
        
        // find data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                // data doesn't exist
                DLog("DB: Unknown id")
            } else {
                
                let movie = result[0] as! Movies
                for genre in genres {
                    
                    let genreDB = Genres(context: context)
                    genreDB.id = Int32(genre.id)
                    genreDB.name = genre.name
                    movie.addToGenres(genreDB)
                }
                
                saveContext()
            }
        } catch {
            
            DLog("DB: Failed Loading")
        }
    }
    
    func saveImageData(id: Int, image: Data, isSmall: Bool) {
        
        // find data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                // data doesn't exist
                DLog("DB: Unknown id")
            } else {
                
                let movie = result[0] as! Movies
                if isSmall {
                    
                    movie.imageSmall = image
                } else {
                    
                    movie.imageBig = image
                }
                saveContext()
            }
        } catch {
            
            DLog("DB: Failed Loading")
        }
    }
    
    func saveVideos(id: Int, videos: [VideoBaseModel]) {
        
        // find data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                // data doesn't exist
                DLog("DB: Unknown id")
            } else {
                
                // remove all videos
                let movieDB = result[0] as! Movies
                if let videosDB = movieDB.videos {
                    
                    for case let video as Videos in videosDB {
                        
                        context.delete(video)
                    }
                    movieDB.removeFromVideos(videosDB)
                }
                saveContext()
                
                // save new videos
                for video in videos {
                    
                    let videoDB = Videos(context: context)
                    videoDB.id = Int32(video.id)
                    videoDB.key = video.key
                    videoDB.name = video.name
                    videoDB.site = video.site
                    videoDB.type = video.type
                    movieDB.addToVideos(videoDB)
                }
                
                saveContext()
            }
        } catch {
            
            DLog("DB: Failed Loading")
        }
    }
    
    private func saveContext() {
        
        do {
            
            try context.save()
            DLog("DB: Data saved!")
        } catch {
            
            DLog("DB: Failed saving")
        }
    }
    
    // MARK: - Delete methods
    
    func deleteAllMovieData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return
            }
            
            for movie in result as! [Movies] {
                
                deleteMovie(movie: movie)
            }
            
            saveContext()
        } catch {
            
            DLog("DB: Failed Deleting all data")
        }
    }
    
    func deleteMovieData(id: Int) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                
                return
            }
            
            let movieDB = result[0] as! Movies
            deleteMovie(movie: movieDB)
            saveContext()
            
        } catch {
            
            DLog("DB: Failed Deleting data")
        }
    }
    
    private func deleteMovie(movie: Movies) {
        
        let genresDB = movie.genres
        let videosDB = movie.videos
        
        if let genres = genresDB {
            
            // remove all genres for the movie
            for case let genre as Genres in genres {
                
                context.delete(genre)
            }
            movie.removeFromGenres(genres)
        }

        if let videos = videosDB {
            
            // remove all videos for the movie
            for case let video as Videos in videos {
                
                context.delete(video)
            }
            movie.removeFromVideos(videos)
        }
        
        context.delete(movie)
    }
}
