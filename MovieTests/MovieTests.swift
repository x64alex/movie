import XCTest
@testable import Movie

class MovieTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func fetchReadings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=22547df3e60a130ab6eb2cb6c2134881&language=en-US&page=1")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode(String.self, from: data)
            return "Found \(readings.count) readings"
        }
        let result = await fetchTask.result
        var output:String
        do {
            output = try result.get()
        } catch {
            output = "Error: \(error.localizedDescription)"
        }
        switch result {
            case .success(let str):
                output = str
            case .failure(let error):
                output = "Error: \(error.localizedDescription)"
        }
        
        print(output)
    }
    
    func testMovies() async  {

        await fetchReadings()
        
        //XCTAssertEqual(moviesArray[0].title, "Thor: Love and Thunder")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
