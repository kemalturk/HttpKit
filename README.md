<p align="left">
  <img height="200" src="https://github.com/kemalturk/HttpKit/assets/22637561/59ceaa50-412d-498f-b022-8311a4bab4ce" />
</p>

# HttpKit

A lightweight, zero dependency Http Client and Network Abstraction Layer.

## Installation

To start using HttpKit in your Swift project, follow these installation instructions:

### 1. Swift Package Manager (SPM):

You can easily add HttpKit to your project by adding it as a dependency in your<br>
Package.swift file:
```swift
.package(url: "https://github.com/kemalturk/HttpKit.git", .upToNextMajor(from: "1.0.0"))
```

### 2. Import HttpKit:
In your Swift code, import the HttpKit module to start using it:
```swift
import HttpKit
```

## Usage

HttpKit is designed to simplify making HTTP requests. Here are some examples of how to use HttpKit in your Swift project:

### Setting Base URL

```swift
let BASE_URL = "127.0.0.1:3000"

extension Endpoint {
    var scheme: String { "http" }
    var host: String { BASE_URL }
}
```

In the code above, we set the base URL for our API requests.

### Defining Endpoints

HttpKit uses an `Endpoint` protocol to define API endpoints. Here's an example of how to define movie-related endpoints:

```swift
enum MovieEndpoint {
    case fetchMovies
    case likeMovie(id: String)
    case commentMovie(model: CommentMovieRequestModel)
}

extension MovieEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchMovies:
            return "/movies"
        case .likeMovie:
            return "/movie/like"
        case .commentMovie:
            return "/click-event"
        }
    }

    var method: RequestMethod {
        switch self {
        case .likeMovie, .commentMovie:
            return .post
        case .fetchMovies:
            return .get
        }
    }

    var body: [String : Any]? {
        switch self {
        case .likeMovie(let id):
            return ["id": id]
        case .commentMovie(let model):
            return model.toDict()
        default:
            return nil
        }
    }
}
```

### Implementing API Client

You can implement an API client using HttpKit to make API requests:


```swift
protocol ApiClient {
    func fetchMovies() async -> FetchState<[Movie]>
    func likeMovie(id: String) async -> FetchState<String>
    func commentMovie(model: CommentMovieRequestModel) async -> FetchState<String>
}

struct ApiHttpClient: HttpClient, ApiClient {
    func fetchMovies() async -> FetchState<[Movie]> {
        await sendRequest(endpoint: MovieEndpoint.fetchMovies).toFetchState()
    }

    func likeMovie(id: String) async -> FetchState<String> {
        await sendRequest(endpoint: MovieEndpoint.likeMovie(id: id)).toFetchState()
    }

    func commentMovie(model: CommentMovieRequestModel) async -> FetchState<String> {
        await sendRequest(endpoint: MovieEndpoint.commentMovie(model: model)).toFetchState()
    }
}
```

### Using the API Client

```swift
@MainActor
class MoviesViewModel: ObservableObject {

    @Published var fetchState: FetchState<[Movie]> = .initial

    let client: ApiClient
    init(client: ApiClient = ApiHttpClient()) {
        self.client = client
    }

    func fetchMovies() {
        Task {
            fetchState = .loading
            fetchState = await client.fetchMovies()
        }
    }

}
```

## Examples

Here are some practical examples of how to use HttpKit to interact with your API:

1. Fetch a list of movies:

```swift
let client = ApiHttpClient()
let fetchState = await client.fetchMovies()
print(fetchState)
```

2. Like a movie:

```swift
let client = ApiHttpClient()
let likeState = await client.likeMovie(id: "123")
print(likeState)
```

3. Comment on a movie:

```swift
let client = ApiHttpClient()
let commentModel = CommentMovieRequestModel(/* provide request data */)
let commentState = await client.commentMovie(model: commentModel)
print(commentState)
```

## Contributing

Contributions to HttpKit are welcome. If you have any suggestions, bug reports, or would like to contribute to the development of HttpKit, please follow the guidelines in the [Contributing.md](Contributing.md) file in the repository.


