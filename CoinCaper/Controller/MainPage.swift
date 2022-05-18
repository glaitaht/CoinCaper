
import UIKit
import SDWebImageSVGCoder
import Charts

final class MainPage: UIViewController  {
    //p
    @IBOutlet weak var coinTableView : UITableView!
    
    @IBOutlet weak var detailerView: UIView!
    @IBOutlet weak var detailViewCoinIcon: UIImageView!
    @IBOutlet weak var detailViewCoinName: UILabel!
    @IBOutlet weak var detailViewShortName: UILabel!
    @IBOutlet weak var detailViewPrice: UILabel!
    @IBOutlet weak var detailViewDiff: UILabel!
    @IBOutlet weak var detailViewChartView: UIView!
    
    @IBOutlet weak var filters: UIButton!
    
    private var isFiltered: Bool = false
    private var filteredCoins : [Coin]?
    
    private var selectedCurrency: Filters =  .Diff24Desc {
        didSet {
            if filters.currentTitle == selectedCurrency.rawValue{
                filters.setTitle("Filters", for: .normal)
                isFiltered = false
                coinTableView.reloadData()
            }
            else{
                filters.setTitle(selectedCurrency.rawValue, for: .normal)
                isFiltered = true
                filter()
                coinTableView.reloadData()
                
            }
        }
    }
    
    enum Filters: String, CaseIterable {
        case Diff24Asc = "24 Vol ⤴"
        case Diff24Desc = "24 Vol ⤵"
        case PriceAsc = "Price ⤴"
        case PriceDesc = "Price ⤵"
        //sonr
        static let allValues = [Diff24Asc, Diff24Desc, PriceAsc, PriceDesc]
    }
    
    private var activeDetail: Int = 0
    private var serviceResult: RequestClass? {
        didSet{
            if serviceResult?.status == "success"{
                //
                loadToDetail(coin: (serviceResult?.data!.coins![self.activeDetail])!)
                coinTableView.reloadData()
            }
            else{
                //alert
            }
        }
    }
    
    //corner func
    
    override func viewDidLoad() {
        coinTableView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.5).isActive = true
        coinTableView.layer.cornerCurve = .continuous
        coinTableView.layer.cornerRadius = 25
        
        detailerView.layer.cornerCurve = .continuous
        detailerView.layer.cornerRadius = 15
        
        var menuItems: [UIAction] = []
        for filter in Filters.allValues{
            let menuItem = UIAction(title: filter.rawValue) { [weak self] _ in
                self?.selectedCurrency = filter
            }
            menuItems.append(menuItem)
        }
        let menu = UIMenu(title: "Filters", children: menuItems)
        filters.showsMenuAsPrimaryAction = true
        filters.menu = menu
        
        filters.layer.cornerRadius = 15
        filters.layer.cornerCurve = .continuous
        
        serviceRequest.getPage(query: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins", type: serviceResult) { Result in
            switch Result{
            case .success(let serviceResultFromService):
                self.serviceResult = serviceResultFromService
            case .failure(let failier):
                print(failier)
            }
        }
        
        coinTableView.dataSource = self
        coinTableView.delegate = self
        
        coinTableView.register(UINib(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        coinTableView.frame = coinTableView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
    
    func filter(){
        switch selectedCurrency{
        case .Diff24Asc:
            filteredCoins = serviceResult?.data?.coins?.sorted {
                Double($0.change!)! < Double($1.change!)!
            }
        case .Diff24Desc:
            filteredCoins = serviceResult?.data?.coins?.sorted {
                Double($0.change!)! > Double($1.change!)!
            }
        case .PriceAsc:
            filteredCoins = serviceResult?.data?.coins?.sorted {
                Double($0.price!)! < Double($1.price!)!
            }
        case .PriceDesc:
            filteredCoins = serviceResult?.data?.coins?.sorted {
                Double($0.price!)! > Double($1.price!)!
            }
        }
        coinTableView.setContentOffset(.zero, animated: true)
    }
    
    func loadToDetail(coin: Coin){
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        detailViewCoinIcon.sd_setImage(with: URL(string: coin.iconURL!))
        detailViewCoinName.text = coin.name
        detailViewCoinName.adjustsFontSizeToFitWidth = true
        detailViewPrice.text =  coin.price!.valueFormatter() + "$"
        detailViewDiff.text = coin.change! + "%"
        if Double(coin.change!)! < 0 {
            detailViewDiff.textColor = .red
        }
        else{
            detailViewDiff.textColor = .systemGreen
        }
        detailViewPrice.adjustsFontSizeToFitWidth = true
        detailViewPrice.sizeToFit()
        detailViewShortName.text = coin.symbol
        var valuesForChart : [ChartDataEntry] = [ChartDataEntry]()
        let doubles = coin.sparkline!.compactMap(Double.init)
        for (index,value) in doubles.enumerated(){
            valuesForChart.append(ChartDataEntry(x: Double(index), y: value))
        }
        let chart = createChart(valuesForChart)
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
            detailViewChartView.addSubview(chart)
        }
        else{
            detailViewChartView.addSubview(chart)
        }
    }
    
    func createChart(_ valuesForChart : [ChartDataEntry]) -> LineChartView {
        let chart = LineChartView()
        let chartDataSet = LineChartDataSet(entries: valuesForChart, label: "Price")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 3
        chartDataSet.setColor(.systemIndigo)
        chart.data = LineChartData(dataSet: chartDataSet)
        chart.data!.setDrawValues(false)
        chart.frame = CGRect(x: 0, y: 0, width: detailViewChartView.frame.size.width, height: detailViewChartView.frame.size.height )
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        chart.xAxis.labelPosition = .top
        chart.tag = 100
        let yAxisLabel = chart.leftAxis
        yAxisLabel.setLabelCount(6, force: false)
        yAxisLabel.drawGridLinesEnabled = false
        yAxisLabel.labelFont = .boldSystemFont(ofSize: 12)
        yAxisLabel.labelTextColor = .systemIndigo
        yAxisLabel.axisLineColor = .systemIndigo
        chart.animate(xAxisDuration: 1.5)
        return chart
    }
}

extension MainPage: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered{
            return filteredCoins?.count ?? 0
        }
        else{
            return self.serviceResult?.data?.coins!.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as? CoinCell else {
            return UITableViewCell()
        }
        if isFiltered{
            cell.configure(coin: (self.filteredCoins![indexPath.row]))
        }
        else{
            cell.configure(coin: (self.serviceResult!.data!.coins?[indexPath.row])!)
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeDetail = indexPath.row
        if isFiltered{
            loadToDetail(coin: (self.filteredCoins![indexPath.row]))
        }
        else{
            loadToDetail(coin: (serviceResult?.data!.coins![self.activeDetail])!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
