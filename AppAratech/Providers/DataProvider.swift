//
//  DataProvider.swift
//  AppAratech
//
//  Created by alvaro Landa Hidalgo on 7/8/21.
//

import Foundation
import Alamofire

public class DataProvider{
    
    static func getInhabitant(completion: @escaping ([Movie])-> Void){
//        url de la api
        let url =  "https://api.themoviedb.org/3/movie/popular?api_key=32abec43db256c3b771ac85e5866a2b8&language=en-US&page=1"
//        Uso de Alamofire para hacer la petición GET
        Alamofire.request(url, method: .get).responseJSON { response in
            print("result: \(response)")
//            guardamos el resultado de la peticion GET
            if let json = response.result.value{
//                Donde vamos a guardar los datos recopilados
                var totalMovies = [Movie]()
                
                if let object = json as? NSDictionary{
//                    recorremos el nuevo array y buscamos por etiquetas para obtener todas las peliculas con todos sus datos
                    if let moviesArray = object["results"] as! [Any]?{
                        for movies in moviesArray {
                            let singleMovie : [String: Any] = movies as! [String: Any]
                            let adult = singleMovie["adult"] as! Bool
                            let backdrop_path = singleMovie["backdrop_path"] as! String
                            let genresDict = singleMovie["genre_ids"] as! [Int]
                            var genresidsArray = [Int]()
                            for genresId in genresDict{
                                let Id = genresId
                                genresidsArray.append(Id)
                            }
                            let id = singleMovie["id"] as! Int
                            let original_language = singleMovie["original_language"] as! String
                            let original_title = singleMovie["original_title"] as! String
                            let overView = singleMovie["overview"] as! String
                            let popularity = (singleMovie["popularity"] as? NSNumber)?.intValue ?? 0
                            let poster_path = singleMovie["poster_path"] as! String
                            let release_date = singleMovie["release_date"] as! String

                            let title = singleMovie["title"] as! String
                            let video = singleMovie["video"] as! Bool
                            let vote_average = (singleMovie["vote_average"] as? NSNumber)?.intValue ?? 0
                            let vote_count = (singleMovie["vote_count"] as? NSNumber)?.intValue ?? 0

                            totalMovies.append(Movie(adult: adult, backdrop_path: backdrop_path, genre_ids: genresidsArray, id: id, original_language: original_language, original_title: original_title, overview: overView, popularity: popularity, poster_path: poster_path, release_date: release_date, title: title, video: video, vote_average: vote_average, vote_count: vote_count))
                            
                        }
                        OperationQueue.main.addOperation {
                            completion(totalMovies)
                            debugPrint("Operation Success")
                    }
                    }else{
                    OperationQueue.main.addOperation {
                        completion(totalMovies)
                        debugPrint("0 Inhabitants")
                    }
                }
                }else{
                print("BAD JSON")
                OperationQueue.main.addOperation {
                    completion(totalMovies)
                    }
                }
            }
        }
    }
    
}
