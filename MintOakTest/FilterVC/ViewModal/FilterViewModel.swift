//
//  FilterViewModel.swift
//  MintOakTest
//
//  Created by Amey Dalvi on 18/05/24.
//

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

    var categoryPriority: [FilterType] = []

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
        categoryPriority.removeAll()
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
        selectedCompanies = selectedCompanies.isEmpty ? masterCompanyList[0] : selectedCompanies
        
        masterAccountList = getAllAccounts()
        masterBrandList = getAllBrands()
        masterLocationList = getAllLocations()
    }

    // Method to update filters based on selection
    func updateFilter() {
        updateMasterListsBasedOnPriority()
        // applyFilters()  // If you want to apply filters immediately
    }

    private func updateMasterListsBasedOnPriority() {
        categoryPriority.forEach { category in
            switch category {
            case .mCompany:
                updateListsForCompany()
            case .mAccount:
                updateListsForAccount()
            case .mBrand:
                updateListsForBrand()
            case .mLocation:
                // No need to update for location as it's the last priority
                break
            }
        }

        // Remove duplicates and sort lists
        selectedAccounts = Set(masterAccountList.sorted())
        selectedBrands = Set(masterBrandList.sorted())
        selectedLocations = Set(masterLocationList.sorted())
    }

    public func updateListsForCompany() {
        
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

            self.selectedAccounts = filteredAccountList.isEmpty ? Set(self.selectedAccounts) : Set(filteredAccountList)
            self.selectedBrands = filteredBrandList.isEmpty ? Set(self.selectedBrands) : Set(filteredBrandList)
            self.selectedLocations = filteredLocationList.isEmpty ? Set(self.selectedLocations) : Set(filteredLocationList)
        }
    }

    private func updateListsForAccount() {
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
            
            self.selectedBrands = filteredBrandList.isEmpty ? Set(self.selectedBrands) : Set(filteredBrandList)
            self.selectedLocations = filteredLocationList.isEmpty ? Set(self.selectedLocations) : Set(filteredLocationList)
        }
    }

    private func updateListsForBrand() {
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

            self.selectedLocations = filteredLocationList.isEmpty ? Set(self.selectedLocations) : Set(filteredLocationList)
        }
    }

    private func getAllAccounts() -> [String] {
        var accounts: [String] = []
        filterResponse?.filterData?.forEach { data in
            if data.companyName == selectedCompanies {
                data.hierarchy?.forEach { account in
                    if let accountNumber = account.accountNumber {
                        accounts.append(accountNumber)
                    }
                }
            }
        }
        return Array(Set(accounts)).sorted()
    }

    private func getAllBrands() -> [String] {
        var brands: [String] = []
        filterResponse?.filterData?.forEach { data in
            if data.companyName == selectedCompanies {
                data.hierarchy?.forEach { account in
                    account.brandNameList?.forEach { brand in
                        if let brandName = brand.brandName {
                            brands.append(brandName)
                        }
                    }
                }
            }
        }
        return Array(Set(brands)).sorted()
    }

    private func getAllLocations() -> [String] {
        var locations: [String] = []
        filterResponse?.filterData?.forEach { data in
            if data.companyName == selectedCompanies {
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
        }
        return Array(Set(locations)).sorted()
    }
}
