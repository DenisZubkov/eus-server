import Dispatch
import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraOpenAPI
import KituraCORS

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    private var categories: [Category] = []
    private var nextCategoryId: Int = 0
    private var workerQueue = DispatchQueue(label: "worker")
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        KituraOpenAPI.addEndpoints(to: router)

        //KituraCORS
        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
        router.delete("/", handler: deleteAllHandler)
        router.get("/", handler: getAllHandler)
        router.post("/", handler: storeHandler)
    }

    func deleteAllHandler(completion: (RequestError?) -> Void) {
        execute {
            categories = []
        }
        completion(nil)
    }


    func getAllHandler(completion: ([Category]?, RequestError?) -> Void) {
        completion(categories, nil)
    }

    func storeHandler(category: Category, completion: (Category?, RequestError?) -> Void) {
        var category = category
        category.id = nextCategoryId
        nextCategoryId += 1
        execute {
            categories.append(category)
        }
        completion(category, nil)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }

    func execute(_ block: () -> Void) {
        workerQueue.sync {
            block()
        }
    } 

}
