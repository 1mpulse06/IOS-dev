//
//  ViewController.swift
//  GamesNavigator
//
//  Created by Alikhan on 12.11.2026.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let items = GameData.items

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = makeHeader()
    }

    private func makeHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ALL GAMES (\(items.count))"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(named: "SecondaryText")
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -4)
        ])
        return header
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                detailVC.item = items[indexPath.row]
            }
        }
    }

}
