//
//  WelcomeResponse.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation
// MARK: - WelcomeResponse
struct WelcomeResponse: Codable {
    let meta: Meta
    let data: [WelcomeData]
}

// MARK: - WelcomeData
struct WelcomeData: Codable {
    let id, name: String
    let status: Bool
    let version: AppVersion
    let country: Country
}

// MARK: - AppVersion
enum AppVersion: String, Codable {
    case the121 = "1.2.1"
    case the206 = "2.0.6"
    case the208 = "2.0.8"
}

// MARK: - Country
enum Country: String, Codable {
    case afghanistan = "Afghanistan"
    case albania = "Albania"
    case algeria = "Algeria"
    case andorra = "Andorra"
    case angola = "Angola"
    case antiguaAndBarbuda = "Antigua and Barbuda"
    case argentina = "Argentina"
    case armenia = "Armenia"
    case australia = "Australia"
    case austria = "Austria"
    case azerbaijan = "Azerbaijan"
    case bahamas = "Bahamas"
    case bahrain = "Bahrain"
    case bangladesh = "Bangladesh"
    case barbados = "Barbados"
    case belarus = "Belarus"
    case belgium = "Belgium"
    case belize = "Belize"
    case benin = "Benin"
    case bhutan = "Bhutan"
    case bolivia = "Bolivia"
    case bosniaAndHerzegovina = "Bosnia and Herzegovina"
    case botswana = "Botswana"
    case brazil = "Brazil"
    case brunei = "Brunei"
    case bulgaria = "Bulgaria"
    case burkinaFaso = "Burkina Faso"
    case burundi = "Burundi"
    case caboVerde = "Cabo Verde"
    case cambodia = "Cambodia"
    case cameroon = "Cameroon"
    case canada = "Canada"
    case centralAfricanRepublic = "Central African Republic"
    case chad = "Chad"
    case chile = "Chile"
    case china = "China"
    case colombia = "Colombia"
    case comoros = "Comoros"
    case congo = "Congo"
    case costaRica = "Costa Rica"
    case croatia = "Croatia"
    case cuba = "Cuba"
    case cyprus = "Cyprus"
    case czechia = "Czechia"
    case denmark = "Denmark"
    case djibouti = "Djibouti"
    case dominica = "Dominica"
    case dominicanRepublic = "Dominican Republic"
    case eastTimor = "East Timor"
    case ecuador = "Ecuador"
    case egypt = "Egypt"
    case elSalvador = "El Salvador"
    case equatorialGuinea = "Equatorial Guinea"
    case eritrea = "Eritrea"
    case estonia = "Estonia"
    case eswatini = "Eswatini"
    case ethiopia = "Ethiopia"
    case fiji = "Fiji"
    case finland = "Finland"
    case france = "France"
    case gabon = "Gabon"
    case gambia = "Gambia"
    case georgia = "Georgia"
    case germany = "Germany"
    case ghana = "Ghana"
    case greece = "Greece"
    case grenada = "Grenada"
    case guatemala = "Guatemala"
    case guinea = "Guinea"
    case guineaBissau = "Guinea-Bissau"
    case guyana = "Guyana"
    case haiti = "Haiti"
    case honduras = "Honduras"
    case hungary = "Hungary"
    case iceland = "Iceland"
    case india = "India"
    case indonesia = "Indonesia"
    case iran = "Iran"
    case iraq = "Iraq"
    case ireland = "Ireland"
    case israel = "Israel"
    case italy = "Italy"
    case ivoryCoast = "Ivory Coast"
    case jamaica = "Jamaica"
    case japan = "Japan"
    case jordan = "Jordan"
    case kazakhstan = "Kazakhstan"
    case kenya = "Kenya"
    case kiribati = "Kiribati"
    case koreaNorth = "North Korea"
    case koreaSouth = "South Korea"
    case kosovo = "Kosovo"
    case kuwait = "Kuwait"
    case kyrgyzstan = "Kyrgyzstan"
    case laos = "Laos"
    case latvia = "Latvia"
    case lebanon = "Lebanon"
    case lesotho = "Lesotho"
    case liberia = "Liberia"
    case libya = "Libya"
    case liechtenstein = "Liechtenstein"
    case lithuania = "Lithuania"
    case luxembourg = "Luxembourg"
    case macedonia = "Macedonia"
    case madagascar = "Madagascar"
    case malawi = "Malawi"
    case malaysia = "Malaysia"
    case maldives = "Maldives"
    case mali = "Mali"
    case malta = "Malta"
    case marshallIslands = "Marshall Islands"
    case mauritania = "Mauritania"
    case mauritius = "Mauritius"
    case mexico = "Mexico"
    case micronesia = "Micronesia"
    case moldova = "Moldova"
    case monaco = "Monaco"
    case mongolia = "Mongolia"
    case montenegro = "Montenegro"
    case morocco = "Morocco"
    case mozambique = "Mozambique"
    case myanmar = "Myanmar"
    case namibia = "Namibia"
    case nauru = "Nauru"
    case nepal = "Nepal"
    case netherlands = "Netherlands"
    case newZealand = "New Zealand"
    case nicaragua = "Nicaragua"
    case niger = "Niger"
    case nigeria = "Nigeria"
    case norway = "Norway"
    case oman = "Oman"
    case pakistan = "Pakistan"
    case palau = "Palau"
    case palestine = "Palestine"
    case panama = "Panama"
    case papuaNewGuinea = "Papua New Guinea"
    case paraguay = "Paraguay"
    case peru = "Peru"
    case philippines = "Philippines"
    case poland = "Poland"
    case portugal = "Portugal"
    case qatar = "Qatar"
    case romania = "Romania"
    case russia = "Russia"
    case rwanda = "Rwanda"
    case saintKittsAndNevis = "Saint Kitts and Nevis"
    case saintLucia = "Saint Lucia"
    case saintVincentAndTheGrenadines = "Saint Vincent and the Grenadines"
    case samoa = "Samoa"
    case sanMarino = "San Marino"
    case saoTomeAndPrincipe = "Sao Tome and Principe"
    case saudiArabia = "Saudi Arabia"
    case senegal = "Senegal"
    case serbia = "Serbia"
    case seychelles = "Seychelles"
    case sierraLeone = "Sierra Leone"
    case singapore = "Singapore"
    case slovakia = "Slovakia"
    case slovenia = "Slovenia"
    case solomonIslands = "Solomon Islands"
    case somalia = "Somalia"
    case southAfrica = "South Africa"
    case southSudan = "South Sudan"
    case spain = "Spain"
    case sriLanka = "Sri Lanka"
    case sudan = "Sudan"
    case suriname = "Suriname"
    case sweden = "Sweden"
    case switzerland = "Switzerland"
    case syria = "Syria"
    case taiwan = "Taiwan"
    case tajikistan = "Tajikistan"
    case tanzania = "Tanzania"
    case thailand = "Thailand"
    case togo = "Togo"
    case tonga = "Tonga"
    case trinidadAndTobago = "Trinidad and Tobago"
    case tunisia = "Tunisia"
    case turkey = "Turkey"
    case turkmenistan = "Turkmenistan"
    case tuvalu = "Tuvalu"
    case uganda = "Uganda"
    case ukraine = "Ukraine"
    case unitedArabEmirates = "United Arab Emirates"
    case unitedKingdom = "United Kingdom"
    case unitedStates = "United States"
    case uruguay = "Uruguay"
    case uzbekistan = "Uzbekistan"
    case vanuatu = "Vanuatu"
    case vaticanCity = "Vatican City"
    case venezuela = "Venezuela"
    case vietnam = "Vietnam"
    case yemen = "Yemen"
    case zambia = "Zambia"
    case zimbabwe = "Zimbabwe"
    case empty = ""

    // Helper function to get an array of all countries
    static var allCases: [Country] {
        return [.afghanistan, .albania, .algeria, .andorra, .angola, .antiguaAndBarbuda, .argentina, .armenia, .australia, .austria,
                .azerbaijan, .bahamas, .bahrain, .bangladesh, .barbados, .belarus, .belgium, .belize, .benin, .bhutan,
                .bolivia, .bosniaAndHerzegovina, .botswana, .brazil, .brunei, .bulgaria, .burkinaFaso, .burundi, .caboVerde,
                .cambodia, .cameroon, .canada, .centralAfricanRepublic, .chad, .chile, .china, .colombia, .comoros, .congo,
                .costaRica, .croatia, .cuba, .cyprus, .czechia, .denmark, .djibouti, .dominica, .dominicanRepublic, .eastTimor,
                .ecuador, .egypt, .elSalvador, .equatorialGuinea, .eritrea, .estonia, .eswatini, .ethiopia, .fiji, .finland,
                .france, .gabon, .gambia, .georgia, .germany, .ghana, .greece, .grenada, .guatemala, .guinea, .guineaBissau,
                .guyana, .haiti, .honduras, .hungary, .iceland, .india, .indonesia, .iran, .iraq, .ireland, .israel, .italy,
                .ivoryCoast, .jamaica, .japan, .jordan, .kazakhstan, .kenya, .kiribati, .koreaNorth, .koreaSouth, .kosovo,
                .kuwait, .kyrgyzstan, .laos, .latvia, .lebanon, .lesotho, .liberia, .libya, .liechtenstein, .lithuania,
                .luxembourg, .macedonia, .madagascar, .malawi, .malaysia, .maldives, .mali, .malta, .marshallIslands,
                .mauritania, .mauritius, .mexico, .micronesia, .moldova, .monaco, .mongolia, .montenegro, .morocco, .mozambique,
                .myanmar, .namibia, .nauru, .nepal, .netherlands, .newZealand, .nicaragua, .niger, .nigeria, .norway, .oman,
                .pakistan, .palau, .palestine, .panama, .papuaNewGuinea, .paraguay, .peru, .philippines, .poland, .portugal,
                .qatar, .romania, .russia, .rwanda, .saintKittsAndNevis, .saintLucia, .saintVincentAndTheGrenadines, .samoa,
                .sanMarino, .saoTomeAndPrincipe, .saudiArabia, .senegal, .serbia, .seychelles, .sierraLeone, .singapore,
                .slovakia, .slovenia, .solomonIslands, .somalia, .southAfrica, .southSudan, .spain, .sriLanka, .sudan,
                .suriname, .sweden, .switzerland, .syria, .taiwan, .tajikistan, .tanzania, .thailand, .togo, .tonga,
                .trinidadAndTobago, .tunisia, .turkey, .turkmenistan, .tuvalu, .uganda, .ukraine, .unitedArabEmirates,
                .unitedKingdom, .unitedStates, .uruguay, .uzbekistan, .vanuatu, .vaticanCity, .venezuela, .vietnam, .yemen,
                .zambia, .zimbabwe, .empty]
    }
}
