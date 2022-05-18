//
//  CoinCell.swift
//  CoinCaper
//
//  Created by Cem Kılıç on 15.03.2022.
//

import UIKit
import SDWebImageSVGCoder

class CoinCell: UITableViewCell {
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShortName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinDailyDiff: UILabel!
    @IBOutlet weak var coinCardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coinCardView.layer.cornerRadius = 15
        coinCardView.layer.cornerCurve = .continuous
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(coin: Coin){
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        coinIcon.sd_setImage(with: URL(string: coin.iconURL!))
        coinName.text = coin.name
        coinName.adjustsFontSizeToFitWidth = true
        coinPrice.text = coin.price!.valueFormatter() + "$"
        coinDailyDiff.text = coin.change! + "%" 
        if Double(coin.change!)! < 0 {
            coinDailyDiff.textColor = .red
        }
        else{
            coinDailyDiff.textColor = .systemGreen
        }
        coinPrice.adjustsFontSizeToFitWidth = true
        coinPrice.sizeToFit()
        coinShortName.text = coin.symbol
    }
    
}
