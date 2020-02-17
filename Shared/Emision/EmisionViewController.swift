import UIKit
import AVKit
import M3UKit

class EmisionViewController: UITableViewController {
    
    private var canales: [(categoria: String, canales: [M3U.Channel])] = []
    
    private var canalesBusqueda: [(categoria: String, canales: [M3U.Channel])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let dataURL: String
    
    init(url: String) {
        self.dataURL = url
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        downloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = dataURL.contains("radio") ? "Radio" : "TDT"
        #if os(iOS)
        tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
        configureSearchBar()
        #endif
    }
    
    @available(tvOS, unavailable)
    func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tabBarController?.navigationItem.searchController = searchController
    }
    
    func downloadData() {
        guard let url = URL(string: dataURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let m3u = M3UDecoder().decode(data)
                else { return }
            let dictionary = Dictionary(grouping: m3u.channels) { $0.attributes["group-title"] ?? "" }
            var keys = Array(dictionary.keys).sorted { $0 < $1 }
            if let indexOfGeneralistas = keys.firstIndex(of: "Generalistas") {
                let generalistas = keys.remove(at: indexOfGeneralistas)
                keys.insert(generalistas, at: 0)
            }
            keys.forEach { key in
                self.canales.append((categoria: key, canales: dictionary[key]!))
            }
            self.canalesBusqueda = self.canales
        }.resume()
    }

}

// MARK: - UITableView

extension EmisionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return canalesBusqueda.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return canalesBusqueda[section].categoria
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canalesBusqueda[section].canales.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let canal = canalesBusqueda[indexPath.section].canales[indexPath.row]
        cell.textLabel?.text = canal.title
        cell.setImage(from: canal.attributes["tvg-logo"])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let canal = canalesBusqueda[indexPath.section].canales[indexPath.row]
        guard let channelURL = URL(string: canal.url) else { return }
        let player = AVPlayer(url: channelURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == tableView.numberOfSections - 1 {
            return "\nDatos obtenidos de tdtchannels.com"
        }
        return nil
    }
    
}

// MARK: - UISearchResultsUpdating

extension EmisionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        canalesBusqueda = canales
        if text != "" {
            var i = 0
            while i < canalesBusqueda.count {
                canalesBusqueda[i].canales = canalesBusqueda[i].canales.filter { $0.title.lowercased().contains(text.lowercased()) }
                if canalesBusqueda[i].canales.count == 0 {
                    canalesBusqueda.remove(at: i)
                } else {
                    i += 1
                }
            }
        }
    }
    
}
