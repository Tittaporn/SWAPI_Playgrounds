import UIKit


/* SWAPI_Playgrounds
    In this project students will send HTTP requests in Postman and then in Xcode Playgrounds. In the finished playground, they will perform a fetch for a Person and then a series of fetches for each Film in which the person appears.
 
 BaseURL = https://swapi.dev/api/
 
 fetchPersonURL = https://swapi.dev/api/people/1/
 
 */

// MARK: - Model
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
    let species: [URL]
    //let vehicles: [Vehicels]
    //let starships: [Startship]
    let created: String
    let edited: String
    let url: URL
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
    let director: String
    let producer: String
    let characters: [URL]
}

// MARK: - ModelController

class SwapiService {
    // MARK: -  BaseURL
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    // MARK: - FetchPerson Fuction
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // STEP 1: PREPARE URL
        guard let baseURL = baseURL else { return completion(nil) }
        
        // STEP 2: CONTACT SERVER
        let finalURL = baseURL.appendingPathComponent("people" + "/\(id)" + "/")
        //== >> https://swapi.dev/api/people/1/
        
        // STEP 3: HANDLE ERRORS
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            // STEP 4: CHECK OF DATA
            guard let data = data else { return }
            do {
                // STEP 5: DECODE PERSON FROM JSON
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
            }
        }.resume()
    } //END OF FUNCTION fetchPerson
    
    // MARK: - FetchFilm Function
    static func fetchFilm(url: URL, compltion: @escaping (Film?) -> Void) {
        // STEP 1: CONTACT SERVER
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            // STEP 2: HANDLE ERRORS
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                compltion(nil)
                return
            }
            
            // STEP 3: CHECK FOR DATA
            guard let data = data else { return compltion(nil) }
            
            // STEP 4: DECODE FILM FROM JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                compltion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                compltion(nil)
            }
        }.resume()
    } //END OF FUNCTION fetchFilm
    
    // MARK: - FetchCharacterByURL Function
    static func fetchCharacterByURL(url: URL, completion: @escaping (Person?) -> Void) {
        // STEP 1: CONTACT SERVER
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // STEP 2: HANDEL ERROR
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            // STEP 3: CHECK FOR DATA
            guard let data = data else { return completion(nil) }
            
            // STEP 4: DECODE FROM JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }.resume()
    } //END OF FUNCTION fetchCharacterByURL
    
} //END OF CLASS SwapiService

// MARK: - Mock ViewController

func fetchCharacter(url: URL) {
    SwapiService.fetchCharacterByURL(url: url) { (person) in
        if let person = person {
            print(person.name)
        }
    }
}


func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print("\n")
            print("===== Here is the film details. =======")
            print("\tFilm Title \t\t: \(film.title)")
            print("\tRelease Date \t: \(film.release_date)")
            print("\tFilm URL \t\t: \(url)")
            print("\tDirector \t\t: \(film.director)")
            print("\tProducer \t\t: \(film.producer)")
            print("\tCharacters URL \t: \(film.characters)")
            print("\tTotal Characters\t: \(film.characters.count)")
            
            let characterURLs = film.characters
            for characterURL in characterURLs {
                fetchCharacter(url: characterURL)
            }
            
            print("\tOpening Crawl \t: \(film.opening_crawl)")
            print("======================================")
        }
    }
} //END OF FUNCTION fetchFilm in MockVC


SwapiService.fetchPerson(id: 10) { (person) in
    guard let person = person else { return }
    print( "CHARACTER NAME : \(person.name)")
    print("\n")
    print("\(person.name) appears in \(person.films.count) films including...")
    let films = person.films
    for film in films {
        print("\t\t\(film)")
        fetchFilm(url: film)
    }
    print("\n ")
    print("\(person.name) Info :")
    print("\t\tHeight \t\t: \(person.height)")
    print("\t\tEye Color \t: \(person.eye_color)")
    print("\t\tHair Color \t: \(person.hair_color)")
    print("\t\tGender \t\t: \(person.gender)")
    print("\t\tBirth Year \t: \(person.birth_year)")
}

