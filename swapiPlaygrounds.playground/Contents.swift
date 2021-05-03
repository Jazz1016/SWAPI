import UIKit

struct Person: Decodable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: URL
    let films: [URL]
}

struct Film: Decodable {
    let title: String
//    let opening_crawl: String
    let director: String
    let producer: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else
        {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        print(finalURL)
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // 3 - Handle errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else {return}
            
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                print(person)
                return completion(person)
            } catch {
                
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
                
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        //contatct server
        URLSession.shared.dataTask(with: url) { data, _, error in
            //HANDLE ERRORS
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            //CHECK FOR DATA
            guard let data = data else {return completion(nil)}
                do {
                    let decoder = JSONDecoder()
                    let film = try decoder.decode(Film.self, from: data)
                    print(film)
                    return completion(nil)
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(nil)
                }
        }.resume()
        }
    }//End of class

//SwapiService.fetchPerson(id: 4) { person in
//    if let person = person {
//        print(person)
//    }
//}

SwapiService.fetchPerson(id: 2) { person in
    if let person = person {
        print(person)
        for film in person.films{
            SwapiService.fetchFilm(url: film) { film in
                if let film = film{
                    print(film)
                }
            }
        }
    }
}
