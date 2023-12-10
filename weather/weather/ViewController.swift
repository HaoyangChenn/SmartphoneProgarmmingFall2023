//
//  ViewController.swift
//  weather
//
//  Created by 陈浩扬 on 12/9/23.
//
import Foundation

class WeatherManager {
    func fetchWeatherData(completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let apiUrl = URL(string: "https://us-central1-fir-api-s-8d31b.cloudfunctions.net/app")!
        
        URLSession.shared.dataTask(with: apiUrl) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}



import UIKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var weatherData: WeatherData?
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchWeather()
    }
    
    func fetchWeather() {
        weatherManager.fetchWeatherData { result in
            switch result {
            case .success(let data):
                self.weatherData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        //
        return cell
    }
}

class ImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private let seattleImages = ["image1", "image2", "image3"] // 替换为你的图片名称
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seattleImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        cell.imageView?.image = UIImage(named: seattleImages[indexPath.row])
        //
        return cell
    }
}

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var infoArray = [(name: String, phoneNumber: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Add Info", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Phone Number"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let name = alertController.textFields?[0].text, let phoneNumber = alertController.textFields?[1].text {
                self?.infoArray.append((name: name, phoneNumber: phoneNumber))
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        let info = infoArray[indexPath.row]
        cell.textLabel?.text = "Name: \(info.name)"
        cell.detailTextLabel?.text = "Phone: \(info

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserInfoDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var infoArray = [(name: String, phoneNumber: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        // 跳转到第二个ViewController以收集用户信息
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        let info = infoArray[indexPath.row]
        cell.textLabel?.text = "Name: \(info.name)"
        cell.detailTextLabel?.text = "Phone: \(info.phoneNumber)"
        // 配置单元格以显示用户信息
        return cell
    }
    
    func didAddUserInfo(name: String, phoneNumber: String) {
        infoArray.append((name: name, phoneNumber: phoneNumber))
        tableView.reloadData()
    }
}
class SecondViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    weak var delegate: UserInfoDelegate?
    
    @IBAction func saveButtonTapped(_ sender:
