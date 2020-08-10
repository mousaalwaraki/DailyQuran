//
//  SpecialSoarViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/2/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class SpecialSoarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialSoarCell") as! SpecialSoarTableViewCell
        let item = sections[indexPath.section].1[indexPath.row]
        cell.setup(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.tintColor = .secondarySystemBackground
        
        let label = UILabel(frame: CGRect(x: 25, y: 10, width: view.frame.width - 32, height: 30))
        label.text = sections[section].0
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           switch sections[indexPath.section].1[indexPath.row] {
           case .Yasin:
            tappedYasin()
           case .Mulk:
            tappedMulk()
           case .Kahf:
            tappedKahf()
//           case .AyatKursi:
//            tappedAyatKursi()
           case .Waqiah:
            tappedWaqiah()
           case .lastPage:
            tappedLastPage()
        }
       }

    @IBOutlet weak var specialSoarTable: UITableView!
    
    
    var sections: [(String, [SpecialSoarItems])] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append(("Special Chapters", [.Kahf, .lastPage, .Mulk, .Waqiah, .Yasin]))
        
        specialSoarTable.dataSource = self
        specialSoarTable.delegate = self
        specialSoarTable.reloadData()
        specialSoarTable.tableFooterView = UIView()
    }
    
    func tappedYasin() {
        specialSooraChoice = .Yasin
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tappedMulk() {
        specialSooraChoice = .Mulk
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tappedKahf() {
        specialSooraChoice = .Kahf
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tappedAyatKursi() {
//        specialSooraChoice = .AyatKursi
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tappedWaqiah() {
        specialSooraChoice = .Waqiah
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tappedLastPage() {
        specialSooraChoice = .lastPage
        let  vc = storyboard?.instantiateViewController(identifier: "SoorahViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
}

enum SpecialSoarItems: CaseIterable {
    case Yasin
    case Mulk
    case Kahf
//    case AyatKursi
    case Waqiah
    case lastPage
}

extension SpecialSoarItems {
    var title:String {
        switch self {
        case .Yasin:
            return "Yasin"
        case .Mulk:
            return "Mulk"
        case .Kahf:
            return "Kahf"
//        case .AyatKursi:
//            return "Ayat Al Kursi"
        case .Waqiah:
            return "Waqiah"
        case .lastPage:
            return "Last Page"
        }
    }
    
    var pageNumber:Int {
        switch self {
        case .Yasin:
            return 440
        case .Mulk:
            return 562
        case .Kahf:
            return 293
//        case .AyatKursi:
//            <#code#>
        case .Waqiah:
            return 534
        case .lastPage:
            return 604
        }
    }
    
    var soorahNumber:Int {
        switch self {
        case .Yasin:
            return 36
        case .Mulk:
            return 67
        case .Kahf:
            return 18
        case .Waqiah:
            return 56
        case .lastPage:
            return 2
        }
    }
    
    var numberOfPages:Int {
        switch self {
        case .Yasin:
            return 6
        case .Mulk:
            return 3
        case .Kahf:
            return 12
        case .Waqiah:
            return 4
        case .lastPage:
            return 1
        }
    }
}

var specialSooraChoice: SpecialSoarItems?
