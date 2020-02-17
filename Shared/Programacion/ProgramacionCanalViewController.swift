import UIKit
import XMLTV

class ProgramacionCanalViewController: UITableViewController {
    
    private var data: [(dia: String, programas: [TVProgram])] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        tableView.allowsSelection = false
    }
    
    func setData(for channel: TVChannel, xml: XMLTV) {
        title = channel.name
        let programacion = xml.getPrograms(channel: channel)
        let data = Dictionary(grouping: programacion, by: { $0.start!.humanDate } )
        let keys = Array(data.keys).sorted { Date.parse(humanDate: $0)! < Date.parse(humanDate: $1)! }
        keys.forEach { key in
            self.data.append((dia: key, programas: data[key]!))
        }
    }
    
}

//MARK: - Table View Delegate & Data Source

extension ProgramacionCanalViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].dia
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].programas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "programaCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "programaCell")
        }
        let programa = data[indexPath.section].programas[indexPath.row]
        cell!.setImage(from: programa.icon)
        cell!.textLabel?.text = programa.title
        cell!.detailTextLabel?.text = "\(programa.start!.humanTime) - \(programa.stop!.humanTime)"
        return cell!
    }
    
}
