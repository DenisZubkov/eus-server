//
//  LoadDataProvider.swift
//  Application
//
//  Created by Denis Zubkov on 06/09/2019.
//

import Foundation

class LoadDataProvider {
    
    var queriesTFS: [ODataQuery] = []
    let dataProvider = DataProvider()
    let globalSettings = GlobalSettings()
    var date = Date()
    var quotas: [Quota] = []
    var usersTeams: [String:String] = [:]
    let type = QueryResultFormat.json
    var dataDict: [String : Data] = [:]
    var flag: String = "Началось"
    
    func TestConnectAPI() -> String {
        let query = ODataQuery.init(server: self.globalSettings.serverTFS,
                                    table: "workitems",
                                    filter: "4644, 4642,5547, 4641, 4637, 4640, 5548, 4638, 4639, 4643",
                                    select: nil,
                                    orderBy: nil,
                                    id: 3717)
        var urlComponents = dataProvider.getUrlComponents(server: query.server, query: query, format: .tfs)
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        flag = "Begin..."
        //guard let url = urlComponents.url else { return "Bad url" }
        guard let url = URL(string: "http://zubkoff:!den20zu10@tfs1.tbm.ru:8080/tfs/DefaultCollection/_apis/wit/workitems?ids=4644,4642&$expand=relations&api-version=3.2") else { return "Bad url" }
        self.dataProvider.downloadDataNTLM(url: url) { data in
            guard let data = data else {
                self.flag = "Данных не получено"
                return
            }
            self.flag = String(data: data, encoding: .utf8)!
            return
        }
        while flag == "Begin..." {

        }
        return flag
    }
}
