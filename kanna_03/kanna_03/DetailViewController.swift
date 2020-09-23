//
//  DetailViewController.swift
//  kanna_03
//
//  Created by Jakob Tak on 2020/09/01.
//  Copyright © 2020 Jakob Tak. All rights reserved.
//
import Kanna
import UIKit

class DetailViewController: UIViewController {
    
    var getlink = ""
    var info : [String] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTomatoScore: UILabel!
    @IBOutlet weak var lblAudienceScore: UILabel!
    @IBOutlet weak var tfInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCrawling(link: getlink)
        // Do any additional setup after loading the view.
    }
    
    func dataCrawling(link : String){
        guard let main = URL(string: link) else {
            print("Error, \(link) is not a valid URL")
            return
        }
        do{
            let htmlData = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: htmlData, encoding: .utf8)
            
            for title in doc.xpath("//*[@id='topSection']/div[2]/div[1]/h1"){
                lblTitle.text = title.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            for tomato in doc.xpath("//*[@id='tomato_meter_link']/span[2]"){
                lblTomatoScore.text = tomato.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            for aud in doc.xpath("//*[@id='topSection']/div[2]/div[1]/section/section/div[2]/h2/a/span[2]"){
                lblAudienceScore.text = aud.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            for picture in doc.xpath("//*[@id='topSection']/div[1]/div/img"){
                let imgURL = URL(string: picture["data-src"]!)
                print(picture["data-src"]!)
                URLSession.shared.dataTask(with: imgURL!) { data, response, error in
                  guard let data = data else { return }
                  let image = UIImage(data: data)!
                  DispatchQueue.main.async {
                    self.imgView.image = image
                  }
                  }.resume()
            }
        
            for info in doc.xpath("//*[@id='movieSynopsis']"){
                tfInfo.text = info.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            
        }catch let error{
            print (error)
        }
    }
    
    
    func receiveItems(_ link : String){
        getlink = link
    }

}
