//
//  ViewController.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAPI()
    }


}

extension ViewController {
    
    func requestAPI() {
        let parm = ["order_type" : 1]
        AF.request("https://connect-boxoffice.run.goorm.io/movies/", method: .get, parameters: parm).responseJSON(completionHandler: {
            response in
            print(response)
            
            do {
                let dataJSON = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let data = try JSONDecoder().decode(MovieResponse.self, from: dataJSON)
                self.movies = data.movies
            } catch (let error) {
                print(error)
            }
            
        })
    }
    
}

