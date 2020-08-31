//
//  DetailViewController.swift
//  RickAndMoryt2
//
//  Created by Anton Redkozubov on 31.08.2020.
//  Copyright © 2020 Anton Redkozubov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    public var character: Character?
    
    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func createUI(){
    
        self.heroImage.image = UIImage(named:"noimage")
        self.nameLabel.text = self.character?.name
        self.speciesLabel.text = self.character?.species
        self.statusLabel.text = self.character?.status
        self.typeLabel.text = self.character?.type
        self.genderLabel.text = self.character?.gender
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
