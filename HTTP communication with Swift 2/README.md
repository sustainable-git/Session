# HTTP communication with Swift 2

- Contents
    - [API](#API)
    - [Entity](#Entity)
    - [Result type](#Result-type)
    - [Fetching data using HTTP get method](#Fetching-data-using-HTTP-get-method)
    - [Extra](#Extra)

<br>
<br>

## API

- API(Application programming interface)
    - APIs Connect computers and software
    - You can use some features using APIs

- Postech API
    - [[포스텍 복지회]](https://dining.postech.ac.kr/weekly-menu/)
    - ![](01)
    - ![](02)
    - ![](03)
    - ![](04)
    - ![](05)

<br>
<br>

## Entity

- Entity
    - An entity is any singular, identifiable and separate object.
    - We will put the unit data in the Entity

```swift
struct Menu: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let type: String
    let foods: [Food]
}

struct Food: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name_kor"
    }
}
```

<br>
<br>

## Result type

- Result type
    - A value that represents either a success or a failure, including an associated value in each case.
    - Declaration
        - ```swift
          @frozen enum Result<Success, Failure> where Failure : Error
          ```
          
```swift
enum isEvenError: Error {
    case notAnInteger
}

func isEven(number: Any, completion: @escaping (Result<Bool, Error>) -> Void) {
    guard let integer = number as? Int else {
        completion(.failure(isEvenError.notAnInteger))
        return
    }
    if integer % 2 == 0 {
        completion(.success(true))
    } else {
        completion(.success(false))
    }
}

func testFunction(value: Any) {
    isEven(number: value) { result in
        switch result {
        case .success(let bool):
            print(value, bool ? "is even" : "is odd")
        case .failure(let error):
            print(error)
        }
    }
}

testFunction(value: 1) // 1 is odd
testFunction(value: 2) // 2 is even
testFunction(value: "String") // notAnInteger
```

<br>
<br>

## Fetching data using HTTP get method

- HTTP status code
    - 100 ~ 199 : (Information)
    - 200 ~ 299 : (Success)
    - 300 ~ 399 : (Redirection)
    - 400 ~ 499 : (Client Error)
    - 500 ~ 599 : (Server Error)

```swift
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unsuccessfulResponse
    case invalidData
}

enum SerializationError: Error {
    case unavailable
}

func get(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("*/*", forHTTPHeaderField: "accept")
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.unsuccessfulResponse))
            return
        }
        guard let data = data else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        completion(.success(data))
    }.resume()
}

func fetchURL(_ urlString: String, completion: @escaping (Result<Menu, Error>) -> Void) {
    get(urlString) { result in
        switch result {
        case .success(let data):
            guard let meals = try? JSONDecoder().decode([Meal].self, from: data) else {
                completion(.failure(SerializationError.unavailable))
                return
            }
            completion(.success(Menu(meals: meals)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

fetchURL("https://food.podac.poapper.com/v1/menus/2022/05/16") { result in
    switch result {
    case .success(let menu):
        print(menu)
    case .failure(let error):
        print(error)
    }
}
RunLoop.current.run(until: .now + 1)
```

![](06)

<br>
<br>

## Extra

- CustonStringConvertable
    - A type with a customized textual representation
    - ![](07)

```swift
struct Menu: Codable, CustomStringConvertible {
    var description: String {
        return meals.reduce(""){ $0 + "\n\n" + $1.description}
    }
    
    let meals: [Meal]
}

struct Meal: Codable, CustomStringConvertible {
    var description: String {
        return type + foods.reduce(""){ $0 + "\n" + $1.description }
    }
    
    let type: String
    let foods: [Food]
}

struct Food: Codable, CustomStringConvertible {
    var description: String {
        return name
    }
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name_kor"
    }
}
```

- Run Swift app from terminal
    - ![](08)
    - ![](09)



- All codes of MenuToday
    - [[Github Link]](https://github.com/sustainable-git/Prototypes/tree/main/MenuToday)
