//
//  FilterModel.swift
//  MintOakTest
//
//  Created by Amey Dalvi on 18/05/24.
//

import Foundation

enum FilterType {
    case mAccount
    case mBrand
    case mLocation
    case mCompany
}

struct FilterResponse: Codable {
    var status: String?
    var message: String?
    var errorCode: String?
    var filterData: [FilterData]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case errorCode = "errorCode"
        case filterData = "filterData"
    }
}

// MARK: - FilterDatum
struct FilterData: Codable {
    var cif: String?
    var companyName: String?
    var accountList: [String]?
    var brandList: [String]?
    var locationList: [String]?
    var hierarchy: [mAccount]?

    enum CodingKeys: String, CodingKey {
        case cif = "Cif"
        case companyName = "companyName"
        case accountList = "accountList"
        case brandList = "brandList"
        case locationList = "locationList"
        case hierarchy = "hierarchy"
    }
}

// MARK: - Hierarchy
struct mAccount: Codable {
    var accountNumber: String?
    var brandNameList: [mBrand]?

    enum CodingKeys: String, CodingKey {
        case accountNumber = "accountNumber"
        case brandNameList = "brandNameList"
    }
}

// MARK: - BrandNameList
struct mBrand: Codable {
    var brandName: String?
    var locationNameList: [mLocation]?
    
    enum CodingKeys: String, CodingKey {
        case brandName = "brandName"
        case locationNameList = "locationNameList"
    }
}


// MARK: - LocationNameList
struct mLocation: Codable {
    var locationName: String?
    var merchantNumber: [MerchantNumber]?
    
    enum CodingKeys: String, CodingKey {
        case locationName = "locationName"
        case merchantNumber = "merchantNumber"
    }
}


// MARK: - MerchantNumber
struct MerchantNumber: Codable {
    var mid: String?
    var outletNumber: [String]?

    enum CodingKeys: String, CodingKey {
        case mid = "mid"
        case outletNumber = "outletNumber"
    }
}



let jsonData = """
{"status":"Success","message":"Data Available","errorCode":"L128","filterData":[{"Cif":"6221503","companyName":"CITY CENTRE COMMERCIAL CO.KSC","accountList":["023162215030014402006","023162215030014402004","023162215030014402005","023162215030014402002","023162215030014402003","023162215030014402001"],"brandList":["CITY CENTER ","CITY CENTRE","CITY CENTER- DHAJEEJ","CITY CENTER"],"locationList":["DASMAN","kuwait","SALMIYA","ALJAHRA","FARWANIYA","KUWAIT CITY"],"hierarchy":[{"accountNumber":"023162215030014402006","brandNameList":[{"brandName":"CITY CENTER ","locationNameList":[{"locationName":"DASMAN","merchantNumber":[{"mid":"916590028","outletNumber":["12754431","12754437","12754432","12754427","12754428","12754429","12754436","12754430","12754433","12754426","12754434","12754438","916590028"]}]}]}]},{"accountNumber":"023162215030014402004","brandNameList":[{"brandName":"CITY CENTER ","locationNameList":[{"locationName":"ALJAHRA","merchantNumber":[{"mid":"916590027","outletNumber":["29409041","29409067","29409073","29409083","29409048","29409074","12769697","29409036","29409061","29409035","29409056","12793494","29908423","29409049","29409051","29409042","29409050","29409081","29409084","12765092","29911185","29908424","29409064","12769695","29908422","29409038","29409044","29409053","12793497","29409055","916590027","29409039","29409040","29409045","29409070","29409080","29409037","29409072","29409069","29409052","29409043","29409046","29409075","12793492","12793498","29409054","29409047","29409057","29409058","12793493","29409059","29409068","29409082","29409071","29409077","12769696","12793495","29409060","29409065","29908425","29409076","29409066","29409078","29409062","29409063","29409079","12793496"]}]}]}]},{"accountNumber":"023162215030014402005","brandNameList":[{"brandName":"CITY CENTER ","locationNameList":[{"locationName":"DASMAN","merchantNumber":[{"mid":"916590029","outletNumber":["916590029","29909906","29606531"]},{"mid":"916590030","outletNumber":["29606530","916590030","29909905"]}]}]}]},{"accountNumber":"023162215030014402002","brandNameList":[{"brandName":"CITY CENTER ","locationNameList":[{"locationName":"SALMIYA","merchantNumber":[{"mid":"916589005","outletNumber":["29801527","916589005"]}]},{"locationName":"DASMAN","merchantNumber":[{"mid":"916589006","outletNumber":["916589006","29801529"]}]},{"locationName":"KUWAIT CITY","merchantNumber":[{"mid":"916589004","outletNumber":["916589004","12602782","28500083"]}]}]},{"brandName":"CITY CENTRE","locationNameList":[{"locationName":"SALMIYA","merchantNumber":[{"mid":"916589001","outletNumber":["28500040","29505540","12604500","12604534","28500088","29907799","12604505","28500101","29505559","29912259","12604535","28500105","29505532","29505545","29505557","12769641","29505555","12769465","12769460","12604504","12604521","28500094","29505531","12602623","12602624","12604512","12604519","28500043","28500047","28500033","29505530","12769466","12602622","12604533","29505533","29505552","12604509","28500097","29505551","12602620","12604528","28500090","28500085","28500041","29905361","916589001","12604532","12642063","12642064","29505556","29505558","12604517","12642066","28500045","28500091","28500093","28500103","29906696","29912260","12604507","12604520","28500096","28500099","29505527","12769462","29300730","29505537","29505539","12642067","28500038","12769463","12604508","28500049","28500098","29505546","12793605","29912261","12604501","12604515","29505536","12604524","12604530","28500048","29505529","28500086","12769461","12793604","12769459","12604503","28500092","28500087","29505547","29505549","29505550","12793601","12793603","12793607","29905362","29915517","12604502","12604510","28500039","28500037","29505553","12604506","28500102","29505705","12769464","29300729","12604514","12604518","12604526","12604531","28500046","28500034","28500089","29505534","29505554","29505541","29909140","12602621","28500084","29505543","12793606","28500042","29505528","29505560","29505542","29505548","12793602","12604513","28500036","28500044","28500104","29912258","29912255","12604516","12604522","12604523","12604525","12604529","28500095","28500106","28500035","29505535","29905360","12604511","12604527","12642065","29505544","29505538"]}]}]},{"brandName":"CITY CENTER","locationNameList":[{"locationName":"SALMIYA","merchantNumber":[{"mid":"916589008","outletNumber":["916589008"]},{"mid":"916589007","outletNumber":["916589007"]}]}]}]},{"accountNumber":"023162215030014402003","brandNameList":[{"brandName":"CITY CENTER ","locationNameList":[{"locationName":"FARWANIYA","merchantNumber":[{"mid":"916590021","outletNumber":["916590021","28402172","29604149"]},{"mid":"916590010","outletNumber":["29405262","12769643","916590010"]},{"mid":"916590020","outletNumber":["28402171","916590020","29604150"]},{"mid":"916590023","outletNumber":["29604147","916590023","28402174"]},{"mid":"916590012","outletNumber":["916590012","12791005","29405264"]},{"mid":"916590022","outletNumber":["916590022","28402173","29604148"]},{"mid":"916590025","outletNumber":["28402176","916590025","29604151"]},{"mid":"916590002","outletNumber":["29405254","916590002"]},{"mid":"916590016","outletNumber":["12791004","29405268","916590016"]},{"mid":"916590005","outletNumber":["916590005","29405257","12790675"]},{"mid":"916590004","outletNumber":["29405256","12790674","916590004"]},{"mid":"916590015","outletNumber":["29405267","916590015","12769642"]},{"mid":"916590026","outletNumber":["28402177","29604152","916590026"]},{"mid":"916590007","outletNumber":["916590007","12792156","29405259"]},{"mid":"916590008","outletNumber":["29405260","916590008"]},{"mid":"916590019","outletNumber":["916590019","29604145","28402170","12792155"]}]}]},{"brandName":"CITY CENTER- DHAJEEJ","locationNameList":[{"locationName":"FARWANIYA","merchantNumber":[{"mid":"916590011","outletNumber":["29405263","916590011"]},{"mid":"916590014","outletNumber":["916590014","29405266"]},{"mid":"916590003","outletNumber":["29405255","916590003"]},{"mid":"916590024","outletNumber":["28402175","916590024"]},{"mid":"916590013","outletNumber":["29405265","916590013"]},{"mid":"916590018","outletNumber":["28402169","916590018"]},{"mid":"916590006","outletNumber":["916590006","29405258"]},{"mid":"916590017","outletNumber":["28402168","916590017"]},{"mid":"916590009","outletNumber":["29405261","916590009"]}]}]},{"brandName":"CITY CENTER","locationNameList":[{"locationName":"kuwait","merchantNumber":[{"mid":"916589003","outletNumber":["916589003","12602615"]}]}]}]},{"accountNumber":"023162215030014402001","brandNameList":[{"brandName":"CITY CENTER","locationNameList":[{"locationName":"kuwait","merchantNumber":[{"mid":"916589002","outletNumber":["12602619","916589002","12602618","12602616","12602617"]}]}]}]}]},{"Cif":"7016360","companyName":"PHARMA ZONE GENERAL CO","accountList":["023170163600014402001"],"brandList":["SULIBIKHAT CO-OP","TAD KHAITAN PH","SHOHADA PH.","FARMA ZONE PHARMACY","CARE PH","CARE PH.","SHOHADA PH","DELTAMED KHAITAN PH","ALANDALUS PH."],"locationList":["SALMIYA","FAHAHEEL","ALJAHRA","DAHER","AHMADI","QIBLA","ALSALAM","HATEEN","FARWANIYA","ANDALOUS","ALRAI","KHAITAN","EQAILA","SULAIBIKHAT","MIDAN HAWALLY","HAWALLY","ALNAHDA","JABRIYA","SOUTH SURRA","JELEEB AL SHUYOUKH","MANGAF","RIQQA","GHERNATA","MAHBOULA"],"hierarchy":[{"accountNumber":"023170163600014402001","brandNameList":[{"brandName":"DELTAMED KHAITAN PH","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902077","outletNumber":["12764173","354902077"]},{"mid":"354902078","outletNumber":["354902078","12764174"]}]}]},{"brandName":"FARMA ZONE PHARMACY","locationNameList":[{"locationName":"HAWALLY","merchantNumber":[{"mid":"354902033","outletNumber":["29910294","354902033","29611893"]},{"mid":"354902066","outletNumber":["12764162","354902066"]},{"mid":"354902079","outletNumber":["354902079","12764543","28800053"]},{"mid":"354902068","outletNumber":["354902068","12764164"]},{"mid":"354902080","outletNumber":["12764923","354902080"]},{"mid":"354902114","outletNumber":["29904856","354902114"]},{"mid":"354902115","outletNumber":["354902115","29904857"]}]},{"locationName":"SALMIYA","merchantNumber":[{"mid":"354902098","outletNumber":["354902098","44000645"]},{"mid":"354902120","outletNumber":["354902120","29905829"]},{"mid":"354902099","outletNumber":["44000646","354902099"]},{"mid":"354902144","outletNumber":["29915094","354902144"]},{"mid":"354902100","outletNumber":["354902100","44000647"]},{"mid":"354902101","outletNumber":["44000652","354902101"]},{"mid":"354902035","outletNumber":["354902035","29611891"]},{"mid":"354902112","outletNumber":["354902112","29904854"]},{"mid":"354902050","outletNumber":["29806165","354902050"]},{"mid":"354902062","outletNumber":["354902062","12763651"]},{"mid":"354902063","outletNumber":["12763652","354902063"]},{"mid":"354902042","outletNumber":["354902042","29611884"]},{"mid":"354902053","outletNumber":["29814373","354902053"]},{"mid":"354902107","outletNumber":["354902107","29903656"]},{"mid":"354902108","outletNumber":["29903657","354902108"]},{"mid":"354902058","outletNumber":["29815752","354902058"]},{"mid":"354902113","outletNumber":["354902113","29904855"]},{"mid":"354902036","outletNumber":["29611890","354902036"]},{"mid":"354902059","outletNumber":["12763647","354902059"]},{"mid":"354902048","outletNumber":["29806163","354902048"]},{"mid":"354902103","outletNumber":["354902103","44000681"]},{"mid":"354902006","outletNumber":["29612528","354902006","12758184"]}]},{"locationName":"MIDAN HAWALLY","merchantNumber":[{"mid":"354902149","outletNumber":["29916071","354902149"]}]},{"locationName":"ALJAHRA","merchantNumber":[{"mid":"354902011","outletNumber":["12758192","29614041","354902011","29911084"]},{"mid":"354902012","outletNumber":["354902012","29800226","12758197"]},{"mid":"354902013","outletNumber":["354902013","29800236","12758195"]},{"mid":"354902134","outletNumber":["354902134","29911094"]},{"mid":"354902139","outletNumber":["354902139","29911262"]},{"mid":"354902119","outletNumber":["354902119","29905828"]},{"mid":"354902135","outletNumber":["354902135","29911095"]},{"mid":"354902037","outletNumber":["354902037","44000653","29611889"]},{"mid":"354902060","outletNumber":["354902060","12763649"]},{"mid":"354902044","outletNumber":["29804812","354902044"]},{"mid":"354902121","outletNumber":["29905884","354902121"]},{"mid":"354902122","outletNumber":["29906698","354902122"]},{"mid":"354902045","outletNumber":["354902045","29805253"]},{"mid":"354902046","outletNumber":["29805254","354902046"]},{"mid":"354902145","outletNumber":["354902145","29915095"]},{"mid":"354902061","outletNumber":["12763650","354902061"]},{"mid":"354902140","outletNumber":["354902140","29911263"]},{"mid":"354902124","outletNumber":["29907003","354902124"]},{"mid":"354902047","outletNumber":["29806162","354902047"]},{"mid":"354902026","outletNumber":["354902026","29800229","12758205"]},{"mid":"354902147","outletNumber":["29916069","354902147"]},{"mid":"354902125","outletNumber":["29907004","354902125"]},{"mid":"354902005","outletNumber":["12758185","354902005","29800224"]},{"mid":"354902126","outletNumber":["29907441","354902126"]},{"mid":"354902148","outletNumber":["29916070","354902148"]},{"mid":"354902027","outletNumber":["29614040","354902027","12758204"]}]},{"locationName":"JABRIYA","merchantNumber":[{"mid":"354902132","outletNumber":["354902132","29911092"]},{"mid":"354902133","outletNumber":["29911093","354902133"]},{"mid":"354902128","outletNumber":["29907443","354902128"]},{"mid":"354902127","outletNumber":["354902127","29907442"]}]},{"locationName":"ALSALAM","merchantNumber":[{"mid":"354902016","outletNumber":["12758193","29800218","354902016"]},{"mid":"354902017","outletNumber":["354902017","12758199","29800227"]}]},{"locationName":"HATEEN","merchantNumber":[{"mid":"354902043","outletNumber":["29804811","354902043"]},{"mid":"354902018","outletNumber":["354902018","12758198","29800220"]}]},{"locationName":"SOUTH SURRA","merchantNumber":[{"mid":"354902020","outletNumber":["12758211","354902020","29800216"]},{"mid":"354902019","outletNumber":["12758201","29800228","354902019"]}]},{"locationName":"QIBLA","merchantNumber":[{"mid":"354902130","outletNumber":["354902130","29908574"]},{"mid":"354902129","outletNumber":["29908317","354902129"]}]},{"locationName":"ALNAHDA","merchantNumber":[{"mid":"354902010","outletNumber":["29800219","12758190","354902010"]},{"mid":"354902051","outletNumber":["29813895","354902051"]},{"mid":"354902008","outletNumber":["354902008","29800225","12758189"]},{"mid":"354902009","outletNumber":["29800215","354902009","12758191"]}]},{"locationName":"DAHER","merchantNumber":[{"mid":"354902025","outletNumber":["12758206","29800234","354902025"]}]},{"locationName":"RIQQA","merchantNumber":[{"mid":"354902142","outletNumber":["354902142","29911505"]},{"mid":"354902143","outletNumber":["354902143","29911506"]},{"mid":"354902015","outletNumber":["12758194","29800237","354902015"]}]},{"locationName":"MANGAF","merchantNumber":[{"mid":"354902040","outletNumber":["29611886","354902040"]},{"mid":"354902096","outletNumber":["354902096","44000624"]},{"mid":"354902041","outletNumber":["29611885","354902041"]},{"mid":"354902097","outletNumber":["354902097","44000625"]}]},{"locationName":"FARWANIYA","merchantNumber":[{"mid":"354902065","outletNumber":["12764161","354902065"]},{"mid":"354902110","outletNumber":["354902110","29903659"]},{"mid":"354902111","outletNumber":["29904853","354902111"]},{"mid":"354902030","outletNumber":["29611896","354902030"]},{"mid":"354902031","outletNumber":["354902031","29611895"]},{"mid":"354902064","outletNumber":["354902064","12763669"]},{"mid":"354902007","outletNumber":["12758183","29800235","354902007"]},{"mid":"354902117","outletNumber":["29905814","354902117"]},{"mid":"354902118","outletNumber":["29905827","354902118"]}]},{"locationName":"JELEEB AL SHUYOUKH","merchantNumber":[{"mid":"354902029","outletNumber":["12758202","354902029","29800239"]},{"mid":"354902109","outletNumber":["29903658","354902109"]},{"mid":"354902136","outletNumber":["354902136","29911096"]}]},{"locationName":"FAHAHEEL","merchantNumber":[{"mid":"354902001","outletNumber":["29800223","354902001","12758181"]},{"mid":"354902056","outletNumber":["354902056","29815248"]},{"mid":"354902057","outletNumber":["29815751","354902057"]},{"mid":"354902004","outletNumber":["29800217","12758186","354902004"]}]},{"locationName":"MAHBOULA","merchantNumber":[{"mid":"354902023","outletNumber":["12758208","354902023"]},{"mid":"354902002","outletNumber":["354902002","12758188","29800240"]},{"mid":"354902141","outletNumber":["354902141","29911264"]},{"mid":"354902049","outletNumber":["29806164","354902049"]},{"mid":"354902039","outletNumber":["29611887","354902039"]},{"mid":"354902028","outletNumber":["12758203","354902028"]}]},{"locationName":"EQAILA","merchantNumber":[{"mid":"354902034","outletNumber":["354902034","29611892","29915021"]},{"mid":"354902052","outletNumber":["29814372","354902052"]},{"mid":"354902102","outletNumber":["354902102","44000680"]},{"mid":"354902014","outletNumber":["354902014","29800231","12758196"]},{"mid":"354902104","outletNumber":["354902104","29903604"]},{"mid":"354902105","outletNumber":["29903605","354902105"]}]},{"locationName":"GHERNATA","merchantNumber":[{"mid":"354902131","outletNumber":["354902131","29908575"]}]},{"locationName":"ALRAI","merchantNumber":[{"mid":"354902123","outletNumber":["29906699","354902123"]},{"mid":"354902116","outletNumber":["354902116","29905813"]}]},{"locationName":"ANDALOUS","merchantNumber":[{"mid":"354902021","outletNumber":["12758210","29800233","354902021"]},{"mid":"354902022","outletNumber":["354902022","12758209","29800230"]},{"mid":"354902106","outletNumber":["29903606","354902106"]}]},{"locationName":"AHMADI","merchantNumber":[{"mid":"354902003","outletNumber":["354902003","29800232","12758187"]}]},{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902032","outletNumber":["354902032","29611894"]},{"mid":"354902024","outletNumber":["12758207","354902024","29800238"]},{"mid":"354902094","outletNumber":["354902094","12768104"]},{"mid":"354902091","outletNumber":["12768101","354902091"]},{"mid":"354902081","outletNumber":["12766173","354902081"]},{"mid":"354902092","outletNumber":["12768102","354902092","44000657"]},{"mid":"354902093","outletNumber":["354902093","12768103","44000651"]},{"mid":"354902082","outletNumber":["12766174","354902082"]},{"mid":"354902146","outletNumber":["29916068","354902146"]},{"mid":"354902038","outletNumber":["354902038","29611888"]},{"mid":"354902137","outletNumber":["29911097","354902137"]},{"mid":"354902138","outletNumber":["354902138","29911261"]}]}]},{"brandName":"TAD KHAITAN PH","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902076","outletNumber":["12764172","354902076"]},{"mid":"354902075","outletNumber":["354902075","12764171"]}]}]},{"brandName":"SHOHADA PH","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902074","outletNumber":["12764170","354902074"]}]}]},{"brandName":"SHOHADA PH.","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902070","outletNumber":["12764166","354902070"]}]}]},{"brandName":"CARE PH.","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902073","outletNumber":["354902073","12764169"]}]}]},{"brandName":"CARE PH","locationNameList":[{"locationName":"KHAITAN","merchantNumber":[{"mid":"354902069","outletNumber":["354902069","12764165"]}]}]},{"brandName":"ALANDALUS PH.","locationNameList":[{"locationName":"ANDALOUS","merchantNumber":[{"mid":"354902072","outletNumber":["354902072","12764168"]},{"mid":"354902071","outletNumber":["354902071","44000658","12764167"]}]}]},{"brandName":"SULIBIKHAT CO-OP","locationNameList":[{"locationName":"SULAIBIKHAT","merchantNumber":[{"mid":"354902054","outletNumber":["29815246","354902054"]},{"mid":"354902055","outletNumber":["354902055","29815247"]}]}]}]}]}]}
""".data(using: .utf8)!


