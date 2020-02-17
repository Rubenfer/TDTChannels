import UIKit
import XMLTV

class ProgramacionMainViewController: UITableViewController {
    
    private var xmltv: XMLTV?
    
    private var data: [TVChannel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getProgramacion()
    }
    
    func getProgramacion() {
        guard let url = URL(string: "https://raw.githubusercontent.com/HelmerLuzo/TDTChannels_EPG/master/TDTChannels_EPG.xml") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.xmltv = XMLTV(data: data)
            self.data = self.xmltv!.getChannels()
        }.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Programación"
        #if !os(tvOS)
        tabBarController?.navigationItem.searchController = nil
        #endif
    }
    
}

// MARK: - TableView Delegate & Data Source
extension ProgramacionMainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let programacionCanalViewController = ProgramacionCanalViewController(style: .grouped)
        programacionCanalViewController.setData(for: data[indexPath.row], xml: xmltv!)
        present(UINavigationController(rootViewController: programacionCanalViewController), animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
