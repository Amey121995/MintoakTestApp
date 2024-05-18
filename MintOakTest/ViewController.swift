//
//  ViewController.swift
//  MintOakTest
//
//  Created by Amey Dalvi on 18/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var midList = [String]()
    var viewModel :FilterViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "filterCategoryCell", bundle: nil), forCellReuseIdentifier: "filterCategoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        getFilterData()
        
    }

    @IBAction func onFilterPressed(_ sender: Any) {
        let destVC  = FilterVC()
        destVC.delegate = self
        destVC.viewModel = self.viewModel
        destVC.modalPresentationStyle = .overCurrentContext
        self.present(destVC, animated: true)
    }
    
    
    func getFilterData()
    {
        let decoder = JSONDecoder()
//        let json = try? self.loadJSONFromBundle(with: "JSONFilter.json")
//        print("json == \(json)")
        do {
            let data = try decoder.decode(FilterResponse.self, from: jsonData)
            // Access the data through pharmacyData object

            viewModel = FilterViewModel(filterResponse: data)
            viewModel!.selectedCompanies = viewModel!.masterCompanyList[0]
            viewModel!.updateFilter()
            self.midList = viewModel!.applyFilters()
            print("filteredMIDs == \(midList)")
            self.tableView.reloadData()
          } catch {
          print(error)
        }
        
       
    }
    
    func loadJSONFromBundle(with filename: String) throws -> Data {
      guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        throw NSError(domain: "MyErrorDomain", code: 1, userInfo: ["message": "Couldn't find file in bundle"])
      }
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      return data
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return midList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "filterCategoryCell", for: indexPath) as! filterCategoryCell
        cell.parentImageVw.isHidden = true
        cell.parentArrowImg.isHidden = true
        cell.mainView.backgroundColor = .clear
        cell.categoryTitle.textColor = .blue
        cell.categoryTitle.text = self.midList[indexPath.row]
        cell.categoryTitle.textColor = .black
        return cell
    }
    
    
}

extension ViewController: FilterDelelgate{
    func updatedMidList(midList: [String], viewModel: FilterViewModel?) {
        self.midList = midList
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
}
