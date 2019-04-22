//
//  AppDelegate.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
//        //
//        DataBaseManager.shared.deleteAllMovieData()
//
//        // add movie base
//        var movies = [MovieBaseModel]()
//        let movie1 = MovieBaseModel(id: 1, title: "titleValue1", imagePath: "imagePathValue1", voteCount: 1000)
//        let movie2 = MovieBaseModel(id: 2, title: "titleValue2", imagePath: "imagePathValue2", voteCount: 2000)
//        movies.append(movie1)
//        movies.append(movie2)
//
//        DataBaseManager.shared.saveMoviesData(movies: movies)
//        var moviesDB = DataBaseManager.shared.loadMoviesData()
//
//        // add small images
//        DataBaseManager.shared.saveImageData(id: movie1.id, image: Data(), isSmall: true)
//        DataBaseManager.shared.saveImageData(id: movie2.id, image: Data(), isSmall: true)
//        let imageSmall1 = DataBaseManager.shared.loadImageData(id: movie1.id, isSmall: true)
//        let imageSmall2 = DataBaseManager.shared.loadImageData(id: movie2.id, isSmall: true)
//
//        // end movie catalog
//
//        // start details
//
//        // add details
//        let genre1 = GenreBaseModel(id: 1, name: "action")
//        let genre2 = GenreBaseModel(id: 2, name: "violence")
//        let genre3 = GenreBaseModel(id: 3, name: "horror")
//
//        var genresDetail1 = [GenreBaseModel]()
//        genresDetail1.append(genre1)
//        genresDetail1.append(genre2)
//        genresDetail1.append(genre3)
//
//        let details1 = MovieDetailBaseModel(id: movie1.id, title: movie1.title, imagePath: "imageBIGPathValue1", genres: genresDetail1, releaseDate: "11-1-11", overview: "overview text 1")
//
//        DataBaseManager.shared.saveMovieDataDetails(id: movie1.id, movieDetails: details1)
//        let detailsOne = DataBaseManager.shared.loadMovieDetailsData(id: movie1.id)
//
//
//        var genresDetail2 = [GenreBaseModel]()
//        genresDetail2.append(genre3)
//        let details2 = MovieDetailBaseModel(id: movie2.id, title: movie2.title, imagePath: "imageBIGPathValue2", genres: genresDetail2, releaseDate: "2-2-2", overview: "overview text 2")
//        DataBaseManager.shared.saveMovieDataDetails(id: movie2.id, movieDetails: details2)
//        let detailsTwo = DataBaseManager.shared.loadMovieDetailsData(id: movie2.id)
//
//
//
//        // add images
//        DataBaseManager.shared.saveImageData(id: movie1.id, image: Data(), isSmall: false)
//        DataBaseManager.shared.saveImageData(id: movie2.id, image: Data(), isSmall: false)
//        let imageBig1 = DataBaseManager.shared.loadImageData(id: movie1.id, isSmall: false)
//        let imageBig2 = DataBaseManager.shared.loadImageData(id: movie2.id, isSmall: false)
//
//        // add videos
//        let videoModel1 = VideoBaseModel(id: 123, key: "VideoKey", name: "VideoName", site: "Youtube", type: "1080p")
//        let videoModel2 = VideoBaseModel(id: 222, key: "VideoKey2", name: "VideoName2", site: "Youtube2", type: "1080p2")
//        var videos = [VideoBaseModel]()
//        videos.append(videoModel1)
//        videos.append(videoModel2)
//
//        DataBaseManager.shared.saveVideos(id: movie1.id, videos: videos)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController(rootViewController: MovieCatalogViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Movies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

