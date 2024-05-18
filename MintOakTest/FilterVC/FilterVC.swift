//
//  FilterVC.swift
//  MintOakTest
//
//  Created by Amey Dalvi on 18/05/24.
//

import UIKit
protocol FilterDelelgate{
    func updatedMidList(midList: [String],viewModel: FilterViewModel?)
    
}
class FilterVC: UIViewController {

    @IBOutlet weak var categoryTableVw: UITableView!
    
    @IBOutlet weak var subcategoryTableVw: UITableView!
    @IBOutlet weak var subCatpaddingView: UIView!
    
    @IBOutlet weak var clearAllBtn: UIButton!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    
    @IBOutlet weak var customLoader: SpinnerView!
    
    @IBOutlet weak var applyBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var blueTick: UIImageView!
    @IBOutlet weak var loaderParent: UIView!
    
    @IBOutlet weak var clrcustomLoader: SpinnerView!
    
    @IBOutlet weak var clrBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var clrblueTick: UIImageView!
    @IBOutlet weak var clrloaderParent: UIView!
    
    
    var mainCategories = [("Company Name", FilterType.mCompany),
                          ("Account Number",FilterType.mAccount),
                          ("Brand",FilterType.mBrand),
                          ("Locations",FilterType.mLocation)]
    
    var selectedCategory = ("Company Name", FilterType.mCompany)
    
    var companyNameList : [String] = []
    var accountNameList : [String] = []
    var brandNameList : [String] = []
    var locationNameList : [String] = []
    
    
    var isCompanySelected = true
    var isAccountNumberSelected = false
    var isBrandSelected = false
    var isLocationSelected = false

    var viewModel : FilterViewModel?
    
    var delegate: FilterDelelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTableView()
        self.getFilterData()
    }
    
    
    func getFilterData()
    {
        if viewModel == nil{
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(FilterResponse.self, from: jsonData)
                viewModel = FilterViewModel(filterResponse: data)
                // Access master lists
                self.companyNameList = viewModel!.masterCompanyList
                self.accountNameList = viewModel!.masterAccountList
                self.brandNameList = viewModel!.masterBrandList
                self.locationNameList = viewModel!.masterLocationList
                viewModel!.selectedCompanies = viewModel!.masterCompanyList[0]
                viewModel!.updateFilter()
                // Loop through filterData, brands, locations, etc. to access specific information
              } catch {
              print(error)
            }
        }
        else{
            self.companyNameList = viewModel!.masterCompanyList
            self.accountNameList = viewModel!.masterAccountList
            self.brandNameList = viewModel!.masterBrandList
            self.locationNameList = viewModel!.masterLocationList
            viewModel!.updateFilter()
        }
        
        self.catTableReload()
        self.subCatTableReload()
       
    }
    
    func loadJSONFromBundle(with filename: String) throws -> Data {
      guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        throw NSError(domain: "MyErrorDomain", code: 1, userInfo: ["message": "Couldn't find file in bundle"])
      }
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      return data
    }
    
    func setTableView(){
        categoryTableVw.register(UINib(nibName: "filterCategoryCell", bundle: nil), forCellReuseIdentifier: "filterCategoryCell")
        subcategoryTableVw.register(UINib(nibName: "filterCategoryCell", bundle: nil), forCellReuseIdentifier: "filterCategoryCell")
        
        categoryTableVw.delegate = self
        categoryTableVw.dataSource = self
        subcategoryTableVw.delegate = self
        subcategoryTableVw.dataSource = self
        
        self.clearAllBtn.layer.cornerRadius = self.clearAllBtn.frame.size.height / 2.1
        self.clearAllBtn.layer.borderWidth = 1.5
        //self.clearAllBtn.layer.borderColor = .
        self.applyBtn.layer.cornerRadius = self.applyBtn.frame.size.height / 2.1
        self.subcategoryTableVw.backgroundColor = .blue.withAlphaComponent(0.08)
        self.subCatpaddingView.backgroundColor = UIColor.white
    }
    
    func catTableReload()
    {
        let catRange = NSMakeRange(0, self.categoryTableVw.numberOfSections)
        let catSections = NSIndexSet(indexesIn: catRange)
        self.categoryTableVw.reloadSections(catSections as IndexSet, with: .automatic)
    }
    func subCatTableReload()
    {
        let subCatRange = NSMakeRange(0, self.subcategoryTableVw.numberOfSections)
        let subCatSections = NSIndexSet(indexesIn: subCatRange)
        self.subcategoryTableVw.reloadSections(subCatSections as IndexSet, with: .automatic)
    }
    
    func resetFilter (){
        self.clrblueTick.isHidden = true
        self.clrloaderParent.isHidden = true
        self.clrBtnWidth.constant = 120
        self.view.layoutIfNeeded()
        self.isCompanySelected = true
        self.isAccountNumberSelected = false
        self.isBrandSelected = false
        self.isLocationSelected = false
        self.selectedCategory = ("Company Name", FilterType.mCompany)
        viewModel?.clearSelections()
        viewModel!.selectedCompanies = viewModel!.masterCompanyList[0]
        viewModel?.updateFilter()
        self.companyNameList = viewModel!.masterCompanyList
        self.accountNameList = viewModel!.masterAccountList
        self.brandNameList = viewModel!.masterBrandList
        self.locationNameList = viewModel!.masterLocationList
       
        
        
        self.catTableReload()
        self.subCatTableReload()
    }
    
    @IBAction func exitFilter(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func resetPressed(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            self.clrBtnWidth.constant = 0
            self.view.layoutIfNeeded()
        } completion: { value in
            self.clrloaderParent.isHidden = false
            self.clrcustomLoader.isHidden = false
            
            // hide the Loader and animate tick button
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Put your code which should be executed with a delay here
                self.clrcustomLoader.isHidden = true
                UIView.animate(withDuration: 0.5,
                               animations: {
                    self.clrblueTick.isHidden = false
                    self.clrblueTick.transform = CGAffineTransform(scaleX: 0, y: 0)
                },
                               completion: { _ in
                    UIView.animate(withDuration: 0.6) {
                        self.clrblueTick.transform = CGAffineTransform.identity
                        
                    }
                    // hide the tick and loader button and animate button to normal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                            self.resetFilter()
                            //self.dismiss(animated: true)
                        } completion: { value in
                            
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func applyPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            self.applyBtnWidth.constant = 0
            self.view.layoutIfNeeded()
        } completion: { value in
            self.loaderParent.isHidden = false
            self.customLoader.isHidden = false
            
            // hide the Loader and animate tick button
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Put your code which should be executed with a delay here
                self.customLoader.isHidden = true
                UIView.animate(withDuration: 0.5,
                               animations: {
                    self.blueTick.isHidden = false
                    self.blueTick.transform = CGAffineTransform(scaleX: 0, y: 0)
                },
                               completion: { _ in
                    UIView.animate(withDuration: 0.6) {
                        self.blueTick.transform = CGAffineTransform.identity
                        
                    }
                    // hide the tick and loader button and animate button to normal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                            self.dismiss(animated: true) {
                                
                                self.blueTick.isHidden = true
                                self.loaderParent.isHidden = true
                                self.applyBtnWidth.constant = 120
                                self.view.layoutIfNeeded()
                                let midList = self.viewModel!.applyFilters()
                                self.delegate?.updatedMidList(midList: midList, viewModel: self.viewModel)
                            }
                            
                        } completion: { value in
                          
                            
                        }
                    }
                })
            }
        }
    }
    
}


extension FilterVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTableVw{
            return mainCategories.count
        }
        else
        {
            if isCompanySelected{
                return companyNameList.count
            }
            if isAccountNumberSelected{
                return accountNameList.count
            }
            if isBrandSelected{
                return brandNameList.count
            }
            if isLocationSelected{
                return locationNameList.count
            }
            else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "filterCategoryCell", for: indexPath) as! filterCategoryCell
        if tableView == categoryTableVw{
            cell.parentImageVw.isHidden = true
            cell.parentArrowImg.isHidden = true
            cell.mainView.backgroundColor = .clear
            cell.categoryTitle.textColor = .blue
            
            switch mainCategories[indexPath.row].1
            {
                
            case .mAccount:
                cell.categoryTitle.text = "\(mainCategories[indexPath.row].0) (\(viewModel!.selectedAccounts.count))"
            case .mBrand:
                cell.categoryTitle.text = "\(mainCategories[indexPath.row].0) (\(viewModel!.selectedBrands.count))"
            case .mLocation:
                cell.categoryTitle.text = "\(mainCategories[indexPath.row].0) (\(viewModel!.selectedLocations.count))"
            case .mCompany:
                cell.categoryTitle.text = "\(mainCategories[indexPath.row].0)"
            }
            
            
            if self.selectedCategory.1 == mainCategories[indexPath.row].1{
                cell.backgroundColor = .blue.withAlphaComponent(0.08)
            }else{
                cell.backgroundColor = UIColor.white
            }
            cell.categoryTitle.textColor = .black
        }
        else{
            
            if isCompanySelected{
                let item = self.companyNameList[indexPath.row]
                if item == viewModel?.selectedCompanies{
                    let image = UIImage(named: "check2")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }else{
                    let image = UIImage(named: "uncheck2")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }
                cell.categoryTitle.text = companyNameList[indexPath.row]
                cell.checkBoxImg.tintColor = .blue
                cell.parentArrowImg.isHidden = true
            }
            else if isAccountNumberSelected{
                if viewModel!.selectedAccounts.contains(accountNameList[indexPath.row]){
                    let image = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }else{
                    let image = UIImage(named: "blank-check-box")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }
                cell.categoryTitle.text = accountNameList[indexPath.row]
                cell.checkBoxImg.tintColor = .blue
                cell.parentArrowImg.isHidden = true
            }
            else if isBrandSelected{
                if viewModel!.selectedBrands.contains(brandNameList[indexPath.row]){
                    let image = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }else{
                    let image = UIImage(named: "blank-check-box")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }
                cell.categoryTitle.text = brandNameList[indexPath.row]
                cell.checkBoxImg.tintColor = .blue
                cell.parentArrowImg.isHidden = true
            }
            else if isLocationSelected{
                if viewModel!.selectedLocations.contains(locationNameList[indexPath.row]){
                    let image = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }else{
                    let image = UIImage(named: "blank-check-box")?.withRenderingMode(.alwaysTemplate)
                    cell.checkBoxImg.image = image
                }
                cell.categoryTitle.text = locationNameList[indexPath.row]
                cell.checkBoxImg.tintColor = .blue
                cell.parentArrowImg.isHidden = true
            }
            else {
                return UITableViewCell()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == categoryTableVw{
            self.selectedCategory = self.mainCategories[indexPath.row]
            let selectedOption = mainCategories[indexPath.row]
            // For location
            isCompanySelected = false
            isAccountNumberSelected = false
            isBrandSelected = false
            isLocationSelected = false

            switch selectedOption.1{
            case .mAccount:
                isAccountNumberSelected = true
                break
            case .mBrand:
                isBrandSelected = true
                break
            case .mLocation:
                isLocationSelected = true
                break
            case .mCompany:
                isCompanySelected = true
                break
            }
            
    
        }else{
            //HANDLE SUB CATEGORY SELECTION HERE
            
            switch self.selectedCategory.1{
                
            case .mAccount:
                if viewModel!.selectedAccounts.contains(accountNameList[indexPath.row]){
                    viewModel!.selectedAccounts.remove(accountNameList[indexPath.row])
                }else{
                    viewModel!.selectedAccounts.insert(accountNameList[indexPath.row])
                }
               
            case .mBrand:
                if viewModel!.selectedBrands.contains(brandNameList[indexPath.row]){
                    viewModel!.selectedBrands.remove(brandNameList[indexPath.row])
                }else{
                    viewModel!.selectedBrands.insert(brandNameList[indexPath.row])
                }
                

                
            case .mLocation:
                if viewModel!.selectedLocations.contains(locationNameList[indexPath.row]) {
                    viewModel!.selectedLocations.remove(locationNameList[indexPath.row])
                } else {
                    viewModel!.selectedLocations.insert(locationNameList[indexPath.row])
                }
                
            case .mCompany:
                viewModel!.selectedCompanies = self.companyNameList[indexPath.row]
                viewModel!.updateListsForCompany()
            }
    
        }
        
        self.companyNameList = viewModel!.masterCompanyList
        self.accountNameList = viewModel!.masterAccountList
        self.brandNameList = viewModel!.masterBrandList
        self.locationNameList = viewModel!.masterLocationList
    
        self.catTableReload()
        self.subCatTableReload()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
