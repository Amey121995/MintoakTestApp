//
//  FilterViewModel.swift
//  MintOakTest
//
//  Created by Amey Dalvi on 18/05/24.
//

import Foundation

//class FilterViewModel {
//    var filterResponse: FilterResponse?
//    var selectedAccounts = Set<String>()
//    var selectedBrands = Set<String>()
//    var selectedLocations = Set<String>()
//    var selectedCompanies: String = ""
//
//    var masterCompanyList: [String] = []
//    var masterAccountList: [String] = []
//    var masterBrandList: [String] = []
//    var masterLocationList: [String] = []
//
//    init(filterResponse: FilterResponse?) {
//        self.filterResponse = filterResponse
//        createMasterLists()
//    }
//
//    // Method to clear all selections
//    func clearSelections() {
//        selectedAccounts.removeAll()
//        selectedBrands.removeAll()
//        selectedLocations.removeAll()
//    }
//
//    // Method to apply filters and get the list of MID numbers
//    func applyFilters() -> [String] {
//        var midList = getAllMIDs()
//        midList = filterBasedOnSelections(midList: midList)
//        return midList
//    }
//
//    private func filterBasedOnSelections(midList: [String]) -> [String] {
//        return midList.filter { mid in
//            let companyMatch = selectedCompanies.isEmpty || filterResponse?.filterData?.contains { data in
//                data.companyName == selectedCompanies && data.hierarchy?.contains(where: { $0.brandNameList?.contains(where: { $0.locationNameList?.contains(where: { $0.merchantNumber?.contains(where: { $0.mid == mid }) ?? false }) ?? false }) ?? false }) ?? false
//            } ?? false
//
//            let accountMatch = selectedAccounts.isEmpty || filterResponse?.filterData?.contains(where: { data in
//                data.accountList?.contains { account in
//                    selectedAccounts.contains(account) && data.hierarchy?.contains(where: { $0.brandNameList?.contains(where: { $0.locationNameList?.contains(where: { $0.merchantNumber?.contains(where: { $0.mid == mid }) ?? false }) ?? false }) ?? false }) ?? false
//                } ?? false
//            }) ?? false
//
//            let brandMatch = selectedBrands.isEmpty || filterResponse?.filterData?.contains(where: { data in
//                data.brandList?.contains { brand in
//                    selectedBrands.contains(brand) && data.hierarchy?.contains(where: { $0.brandNameList?.contains(where: { $0.locationNameList?.contains(where: { $0.merchantNumber?.contains(where: { $0.mid == mid }) ?? false }) ?? false }) ?? false }) ?? false
//                } ?? false
//            }) ?? false
//
//            let locationMatch = selectedLocations.isEmpty || filterResponse?.filterData?.contains(where: { data in
//                data.locationList?.contains { location in
//                    selectedLocations.contains(location) && data.hierarchy?.contains(where: { $0.brandNameList?.contains(where: { $0.locationNameList?.contains(where: { $0.merchantNumber?.contains(where: { $0.mid == mid }) ?? false }) ?? false }) ?? false }) ?? false
//                } ?? false
//            }) ?? false
//
//            return companyMatch && accountMatch && brandMatch && locationMatch
//        }
//    }
//
//    private func getAllMIDs() -> [String] {
//        var allMIDs: [String] = []
//
//        filterResponse?.filterData?.forEach { data in
//            data.hierarchy?.forEach { account in
//                account.brandNameList?.forEach { brand in
//                    brand.locationNameList?.forEach { location in
//                        location.merchantNumber?.forEach { merchant in
//                            if let mid = merchant.mid {
//                                allMIDs.append(mid)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        return allMIDs
//    }
//
//    // Method to create master lists
//    private func createMasterLists() {
//        guard let filterData = filterResponse?.filterData else { return }
//
//        masterCompanyList = Array(Set(filterData.compactMap { $0.companyName })).sorted()
//        selectedCompanies = masterCompanyList.first ?? ""
//
//        masterAccountList = Array(Set(filterData.reduce([]) { result, data in
//            var result = result
//            result += data.accountList ?? []
//            if let hierarchy = data.hierarchy {
//                for account in hierarchy {
//                    if let accountNumber = account.accountNumber {
//                        result.append(accountNumber)
//                    }
//                }
//            }
//            return result
//        })).sorted()
//
//        masterBrandList = Array(Set(filterData.reduce([]) { result, data in
//            var result = result
//            result += data.brandList ?? []
//            if let hierarchy = data.hierarchy {
//                for account in hierarchy {
//                    if let brandNameList = account.brandNameList {
//                        for brand in brandNameList {
//                            if let brandName = brand.brandName {
//                                result.append(brandName)
//                            }
//                        }
//                    }
//                }
//            }
//            return result
//        })).sorted()
//
//        masterLocationList = Array(Set(filterData.reduce([]) { result, data in
//            var result = result
//            result += data.locationList ?? []
//            if let hierarchy = data.hierarchy {
//                for account in hierarchy {
//                    if let brandNameList = account.brandNameList {
//                        for brand in brandNameList {
//                            if let locationNameList = brand.locationNameList {
//                                for location in locationNameList {
//                                    if let locationName = location.locationName {
//                                        result.append(locationName)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            return result
//        })).sorted()
//    }
//
//    // Method to update filters based on selection
//    func updateFilter() {
//        updateMasterListsBasedOnSelection()
//        applyFilters()
//    }
//
//    private func updateMasterListsBasedOnSelection() {
//        masterAccountList = getAllAccounts()
//        masterBrandList = getAllBrands()
//        masterLocationList = getAllLocations()
//
//        // Apply selected company filter
//        if !selectedCompanies.isEmpty {
//            var filteredAccountList = [String]()
//            var filteredBrandList = [String]()
//            var filteredLocationList = [String]()
//
//            filterResponse?.filterData?.forEach { data in
//                if selectedCompanies.contains(data.companyName ?? "") {
//                    if let accountList = data.accountList {
//                        filteredAccountList.append(contentsOf: accountList)
//                    }
//                    if let brandList = data.brandList {
//                        filteredBrandList.append(contentsOf: brandList)
//                    }
//                    if let locationList = data.locationList {
//                        filteredLocationList.append(contentsOf: locationList)
//                    }
//                }
//            }
//            
//            masterAccountList = filteredAccountList
//            masterBrandList = filteredBrandList
//            masterLocationList = filteredLocationList
//            
//           
//        }
//
//        // Apply selected account filter
//        if !selectedAccounts.isEmpty {
//            var filteredBrandList = [String]()
//            var filteredLocationList = [String]()
//
//            filterResponse?.filterData?.forEach { data in
//                if let accountList = data.accountList, accountList.contains(where: selectedAccounts.contains) {
//                    if let brandList = data.brandList {
//                        filteredBrandList.append(contentsOf: brandList)
//                    }
//                    if let locationList = data.locationList {
//                        filteredLocationList.append(contentsOf: locationList)
//                    }
//                }
//            }
//
//            masterBrandList = masterBrandList.filter { filteredBrandList.contains($0) }
//            masterLocationList = masterLocationList.filter { filteredLocationList.contains($0) }
//        }
//
//        // Apply selected brand filter
//        if !selectedBrands.isEmpty {
//            var filteredAccountList = [String]()
//            var filteredLocationList = [String]()
//
//            filterResponse?.filterData?.forEach { data in
//                if let brandList = data.brandList, brandList.contains(where: selectedBrands.contains) {
//                    if let accountList = data.accountList {
//                        filteredAccountList.append(contentsOf: accountList)
//                    }
//                    if let locationList = data.locationList {
//                        filteredLocationList.append(contentsOf: locationList)
//                    }
//                }
//            }
//
//            masterLocationList = masterLocationList.filter { filteredLocationList.contains($0) }
//        }
//
////        // Apply selected location filter
////        if !selectedLocations.isEmpty {
////            var filteredAccountList = [String]()
////            var filteredBrandList = [String]()
////
////            filterResponse?.filterData?.forEach { data in
////                if let locationList = data.locationList, locationList.contains(where: selectedLocations.contains) {
////                    if let accountList = data.accountList {
////                        filteredAccountList.append(contentsOf: accountList)
////                    }
////                    if let brandList = data.brandList {
////                        filteredBrandList.append(contentsOf: brandList)
////                    }
////                }
////            }
////
////            masterAccountList = masterAccountList.filter { filteredAccountList.contains($0) }
////            masterBrandList = masterBrandList.filter { filteredBrandList.contains($0) }
////        }
//
//        // Remove duplicates and sort lists
//        masterAccountList = Array(Set(masterAccountList)).sorted()
//        masterBrandList = Array(Set(masterBrandList)).sorted()
//        masterLocationList = Array(Set(masterLocationList)).sorted()
//    }
//
//
//
//
//    private func getAllAccounts() -> [String] {
//        var accounts: [String] = []
//        filterResponse?.filterData?.forEach { data in
//            if let accountList = data.accountList {
//                accounts.append(contentsOf: accountList)
//            }
//        }
//        return Array(Set(accounts)).sorted()
//    }
//
//    private func getAllBrands() -> [String] {
//        var brands: [String] = []
//        filterResponse?.filterData?.forEach { data in
//            if let brandList = data.brandList {
//                brands.append(contentsOf: brandList)
//            }
//        }
//        return Array(Set(brands)).sorted()
//    }
//
//    private func getAllLocations() -> [String] {
//        var locations: [String] = []
//        filterResponse?.filterData?.forEach { data in
//            if let locationList = data.locationList {
//                locations.append(contentsOf: locationList)
//            }
//        }
//        return Array(Set(locations)).sorted()
//    }
//}


import Foundation

class FilterViewModel {
    var filterResponse: FilterResponse?
    var selectedAccounts = Set<String>()
    var selectedBrands = Set<String>()
    var selectedLocations = Set<String>()
    var selectedCompanies: String = ""

    var masterCompanyList: [String] = []
    var masterAccountList: [String] = []
    var masterBrandList: [String] = []
    var masterLocationList: [String] = []

    init(filterResponse: FilterResponse?) {
        self.filterResponse = filterResponse
        createMasterLists()
    }

    // Method to clear all selections
    func clearSelections() {
        selectedAccounts.removeAll()
        selectedBrands.removeAll()
        selectedLocations.removeAll()
        selectedCompanies = masterCompanyList[0]
    }

    // Method to apply filters and get the list of MID numbers
    func applyFilters() -> [String] {
        var midList = getAllMIDs()
        midList = filterBasedOnSelections(midList: midList)
        return midList
    }
    
    private func filterBasedOnSelections(midList: [String]) -> [String] {
        return midList.filter { mid in
            let matchesCompany = isCompanyMatch(mid: mid)
            let matchesAccount = isAccountMatch(mid: mid)
            let matchesBrand = isBrandMatch(mid: mid)
            let matchesLocation = isLocationMatch(mid: mid)
            
            return matchesCompany && matchesAccount && matchesBrand && matchesLocation
        }
    }

    private func isCompanyMatch(mid: String) -> Bool {
        guard !selectedCompanies.isEmpty else { return true }
        
        return filterResponse?.filterData?.contains { data in
            data.companyName == selectedCompanies && data.hierarchy?.contains(where: { account in
                account.brandNameList?.contains(where: { brand in
                    brand.locationNameList?.contains(where: { location in
                        location.merchantNumber?.contains(where: { merchant in
                            merchant.mid == mid
                        }) ?? false
                    }) ?? false
                }) ?? false
            }) ?? false
        } ?? false
    }

    private func isAccountMatch(mid: String) -> Bool {
        guard !selectedAccounts.isEmpty else { return true }
        
        return filterResponse?.filterData?.contains { data in
            data.hierarchy?.contains(where: { account in
                selectedAccounts.contains(account.accountNumber ?? "") && account.brandNameList?.contains(where: { brand in
                    brand.locationNameList?.contains(where: { location in
                        location.merchantNumber?.contains(where: { merchant in
                            merchant.mid == mid
                        }) ?? false
                    }) ?? false
                }) ?? false
            }) ?? false
        } ?? false
    }

    private func isBrandMatch(mid: String) -> Bool {
        guard !selectedBrands.isEmpty else { return true }
        
        return filterResponse?.filterData?.contains { data in
            data.hierarchy?.contains(where: { account in
                account.brandNameList?.contains(where: { brand in
                    selectedBrands.contains(brand.brandName ?? "") && brand.locationNameList?.contains(where: { location in
                        location.merchantNumber?.contains(where: { merchant in
                            merchant.mid == mid
                        }) ?? false
                    }) ?? false
                }) ?? false
            }) ?? false
        } ?? false
    }

    private func isLocationMatch(mid: String) -> Bool {
        guard !selectedLocations.isEmpty else { return true }
        
        return filterResponse?.filterData?.contains { data in
            data.hierarchy?.contains(where: { account in
                account.brandNameList?.contains(where: { brand in
                    brand.locationNameList?.contains(where: { location in
                        selectedLocations.contains(location.locationName ?? "") && location.merchantNumber?.contains(where: { merchant in
                            merchant.mid == mid
                        }) ?? false
                    }) ?? false
                }) ?? false
            }) ?? false
        } ?? false
    }


    private func getAllMIDs() -> [String] {
        var allMIDs: [String] = []

        filterResponse?.filterData?.forEach { data in
            data.hierarchy?.forEach { account in
                account.brandNameList?.forEach { brand in
                    brand.locationNameList?.forEach { location in
                        location.merchantNumber?.forEach { merchant in
                            if let mid = merchant.mid {
                                allMIDs.append(mid)
                            }
                        }
                    }
                }
            }
        }

        return allMIDs
    }

    // Method to create master lists
    private func createMasterLists() {
        guard let filterData = filterResponse?.filterData else { return }

        masterCompanyList = Array(Set(filterData.compactMap { $0.companyName })).sorted()
        selectedCompanies = masterCompanyList.first ?? ""

        masterAccountList = getAllAccounts()
        masterBrandList = getAllBrands()
        masterLocationList = getAllLocations()
    }

    // Method to update filters based on selection
    func updateFilter() {
        updateMasterListsBasedOnSelection()
//        applyFilters()
    }

    private func updateMasterListsBasedOnSelection() {
        masterAccountList = getAllAccounts()
        masterBrandList = getAllBrands()
        masterLocationList = getAllLocations()
        
        if !selectedCompanies.isEmpty {
            var filteredAccountList = [String]()
            var filteredBrandList = [String]()
            var filteredLocationList = [String]()

            filterResponse?.filterData?.forEach { data in
                if selectedCompanies.contains(data.companyName ?? "") {
                    if let hierarchy = data.hierarchy {
                        hierarchy.forEach { account in
                            if let accountNumber = account.accountNumber {
                                filteredAccountList.append(accountNumber)
                            }
                            account.brandNameList?.forEach { brand in
                                if let brandName = brand.brandName {
                                    filteredBrandList.append(brandName)
                                }
                                brand.locationNameList?.forEach { location in
                                    if let locationName = location.locationName {
                                        filteredLocationList.append(locationName)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            masterAccountList = filteredAccountList.isEmpty ? masterAccountList: filteredAccountList
            masterBrandList = filteredBrandList.isEmpty ? masterBrandList: filteredBrandList
            masterLocationList = filteredLocationList.isEmpty ? masterLocationList: filteredLocationList
        }
            
        if !selectedAccounts.isEmpty {
            var filteredBrandList = [String]()
            var filteredLocationList = [String]()

            filterResponse?.filterData?.forEach { data in
                data.hierarchy?.forEach { account in
                    if selectedAccounts.contains(account.accountNumber ?? "") {
                        account.brandNameList?.forEach { brand in
                            if let brandName = brand.brandName {
                                filteredBrandList.append(brandName)
                            }
                            brand.locationNameList?.forEach { location in
                                if let locationName = location.locationName {
                                    filteredLocationList.append(locationName)
                                }
                            }
                        }
                    }
                }
            }

            masterBrandList = filteredBrandList.isEmpty ? masterBrandList: filteredBrandList
            masterLocationList = filteredLocationList.isEmpty ? masterLocationList: filteredLocationList
        }
            
        if !selectedBrands.isEmpty {
            var filteredLocationList = [String]()

            filterResponse?.filterData?.forEach { data in
                data.hierarchy?.forEach { account in
                    account.brandNameList?.forEach { brand in
                        if selectedBrands.contains(brand.brandName ?? "") {
                            brand.locationNameList?.forEach { location in
                                if let locationName = location.locationName {
                                    filteredLocationList.append(locationName)
                                }
                            }
                        }
                    }
                }
            }

            masterLocationList = filteredLocationList.isEmpty ? masterLocationList: filteredLocationList
        }

        // Remove duplicates and sort lists
        masterAccountList = Array(Set(masterAccountList)).sorted()
        masterBrandList = Array(Set(masterBrandList)).sorted()
        masterLocationList = Array(Set(masterLocationList)).sorted()
    }

    private func getAllAccounts() -> [String] {
        var accounts: [String] = []
        filterResponse?.filterData?.forEach { data in
            data.hierarchy?.forEach { account in
                if let accountNumber = account.accountNumber {
                    accounts.append(accountNumber)
                }
            }
        }
        return Array(Set(accounts)).sorted()
    }

    private func getAllBrands() -> [String] {
        var brands: [String] = []
        filterResponse?.filterData?.forEach { data in
            data.hierarchy?.forEach { account in
                account.brandNameList?.forEach { brand in
                    if let brandName = brand.brandName {
                        brands.append(brandName)
                    }
                }
            }
        }
        return Array(Set(brands)).sorted()
    }

    private func getAllLocations() -> [String] {
        var locations: [String] = []
        filterResponse?.filterData?.forEach { data in
            data.hierarchy?.forEach { account in
                account.brandNameList?.forEach { brand in
                    brand.locationNameList?.forEach { location in
                        if let locationName = location.locationName {
                            locations.append(locationName)
                        }
                    }
                }
            }
        }
        return Array(Set(locations)).sorted()
    }
}
