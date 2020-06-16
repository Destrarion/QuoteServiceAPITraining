//
//  ViewController.swift
//  Entrainement réseau et API
//
//  Created by Fabien Dietrich on 14/05/2020.
//  Copyright © 2020 Fabien Dietrich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newQuoteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToQuoteLabel()
        // Do any additional setup after loading the view.
    }

    private func addShadowToQuoteLabel() {
        quoteLabel.layer.shadowColor = UIColor.black.cgColor
        quoteLabel.layer.shadowOpacity = 0.9
        quoteLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    @IBAction func tappedNewQuoteButton() {
        toggleActivityIndicator(shown: true)
        QuoteService.shared.getQuote { (success, quote) in
            self.toggleActivityIndicator(shown: false)
            if success, let quote = quote {
                self.update(quote: quote)
            } else {
                self.presentAlert()
            }
        }
    }

    private func toggleActivityIndicator(shown: Bool){
        newQuoteButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(quote: Quote) {
        quoteLabel.text = quote.text
        imageView.image = UIImage(data: quote.imageData)
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
