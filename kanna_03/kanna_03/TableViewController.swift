//
//  TableViewController.swift
//  kanna_03
//
//  Created by Jakob Tak on 2020/09/01.
//  Copyright © 2020 Jakob Tak. All rights reserved.
//

import UIKit
import Kanna

var titles : [String] = []
var movieLinks : [String] = []
let date = Date()
let calendar = Calendar.current
let now = Int(calendar.component(.year, from: date))
let years = Array<Int>(1950...now)

class TableViewController: UITableViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCrawling(year: now)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)

        cell.textLabel?.text = String(indexPath.row+1)
        cell.detailTextLabel?.text = titles[indexPath.row]
        return cell
    }

    @IBAction func refresh(_ sender: Any) {
        tvListView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController {
    func dataCrawling(year : Int){
        titles.removeAll()
        movieLinks.removeAll()
        let mainUrl = "https://www.rottentomatoes.com/top/bestofrt/?year=\(year)"
        guard let main = URL(string: mainUrl) else {
            print("Error, \(mainUrl) is not a valid URL")
            return
        }
        do{
            let htmlData = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: htmlData, encoding: .utf8)
            
            for title in doc.xpath("//*[@id='top_movies_main']/div/table/tr/td/a"){
                titles.append(title.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            for link in doc.xpath("//*[@id='top_movies_main']/div/table/tr/td/a"){
                movieLinks.append("https://www.rottentomatoes.com\(link["href"]!)")
            }
            
        }catch let error{
            print (error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItems(movieLinks[indexPath!.row])
        }
    }
}

extension TableViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataCrawling(year: years[row])
        tvListView.reloadData()
    }
}


