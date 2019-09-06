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
import SwiftKueryORM
import SwiftKueryPostgreSQL

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
        //Database setup
        Persistence.setUp()
        do {
            try LoadLog.createTableSync()
        } catch {
            print(#line, #function, "WARNING: Table LoadLog already exist, \(error.localizedDescription)")
        }
        do {
            try Category.createTableSync()
        } catch {
            print(#line, #function, "WARNING: Table Category already exist, \(error.localizedDescription)")
        }
        do {
            try Quota.createTableSync()
        } catch {
            print(#line, #function, "WARNING: Table Quota already exist, \(error.localizedDescription)")
        }
        
        
        // Endpoints
        initializeHealthRoutes(app: self)
        KituraOpenAPI.addEndpoints(to: router)

        //KituraCORS
        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
        
        router.delete("/", handler: deleteAllHandler)
        router.delete("/", handler: deleteOneHandler)
        router.get("/", handler: getAllHandler)
        router.get("/", handler: getOneHandler)
        router.post("/", handler: storeHandler)
        router.patch("/", handler: updateHandler)
        
        router.get("/test", handler: testSourceConnection)
    }

    func testSourceConnection(completion: @escaping (LoadLog?, RequestError?) -> Void) {
        //        completion(categories, nil)
        let loadData = LoadDataProvider()
        let testResult = loadData.TestConnectAPI()
        print(testResult)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd h:mm a Z"
        let date = dateFormatter.string(from: Date())
        let loadLog = LoadLog.init(id: nil, date: date, name: "Connection test..", description: testResult, Value: 0, time: nil)
        completion(loadLog,nil)
    }
    
    func deleteAllHandler(completion: @escaping (RequestError?) -> Void) {
//        execute {
//            categories = []
//        }
//        completion(nil)
        Category.deleteAll(completion)
    }
    
    func deleteOneHandler(id: Int, completion: @escaping (RequestError?) -> Void) {
//        guard let index = categories.firstIndex(where: {$0.id == id}) else {
//            return completion(.notFound)
//        }
//
//        execute {
//            categories.remove(at: index)
//        }
//        completion(nil)
        Category.delete(id: id, completion)
    }


    func getAllHandler(completion: @escaping ([Category]?, RequestError?) -> Void) {
//        completion(categories, nil)
        Category.findAll(completion)
    }
    
    func getOneHandler(id: Int, completion: @escaping (Category?, RequestError?) -> Void) {
//        guard let category = categories.first(where: {$0.id == id}) else {
//            return completion(nil, .notFound)
//        }
//        completion(category, nil)
        Category.find(id: id, completion)
    }
    
    func updateHandler(id: Int, new: Category, completion: @escaping (Category?, RequestError?) -> Void) {
//        guard let index = categories.firstIndex(where: {$0.id == id}) else {
//            return completion(nil, .notFound)
//        }
//        var current = categories[index]
        
        Category.find(id: id) { current, error in
            guard error == nil else {
                return completion(nil, error)
            }
            guard var current = current else {
                return completion(nil, .notFound)
            }
            
            guard id == current.id else {
                return completion(nil, .internalServerError)
            }
            
            current.dataVersion = new.dataVersion ?? current.dataVersion
            current.guid = new.guid ?? current.guid
            current.name = new.name ?? current.name
            current.short = new.short ?? current.short
            
            current.update(id: id, completion)
        }
        
        
        
//        execute {
//            categories[index] = current
//        }
//        completion(current,nil)
    }

    func storeHandler(category: Category, completion: @escaping (Category?, RequestError?) -> Void) {
        var category = category
        category.id = nextCategoryId
        nextCategoryId += 1
//        execute {
//            categories.append(category)
//        }
//        completion(category, nil)
        category.save(completion)
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


