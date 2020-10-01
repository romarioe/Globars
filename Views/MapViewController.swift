//
//  MapViewController.swift
//  Globars
//
//  Created by Roman Efimov on 30.09.2020.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var token: String = ""
    var zoom: Float = 5
    var unitsModel: UnitsModel!
    var unit: UnitsData?
    var latitude: Double = 55.266933
    var longitude: Double = 52.556995
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSessionId()
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupCamera(latitude: latitude, longitude: longitude, zoom: zoom)
    }
    
    
    
    
    func setupUI(){
        zoomInButton.layer.cornerRadius = 25
        zoomOutButton.layer.cornerRadius = 25
        menuButton.layer.cornerRadius = 25
    }
    
    
    
    
    func getSessionId(){
        NetworkManager.shared.sessions(token: token) { (sessionId) in
            guard let sessionId = sessionId else {
                self.showAlert()
                return
            }
            self.getUnits(sessionId: sessionId)
        }
    }
    
    
    
    
    func getUnits(sessionId: String){
        NetworkManager.shared.units(token: token, sessionId: sessionId) { (unitsModel) in
            guard let unitsModel = unitsModel else {return}
            self.unitsModel = unitsModel
            self.setMarkers()
        }
    }
    
    
    
    func setMarkers(){
        
        for item in unitsModel.data{
            DispatchQueue.main.async
            {
                if item.checked
                {
                    let position = CLLocationCoordinate2DMake(item.position.lt, item.position.ln)
                    let marker = GMSMarker(position: position)
                    marker.title = item.name
                    let markerImage = UIImage(named: "marker.png")
                    let markerView = UIImageView(image: markerImage)
                    marker.iconView = markerView
                    
                    if !item.eye {
                        marker.iconView?.alpha = 0.5
                    }
                    
                    marker.map = self.mapView
                }
            }
        }
        zoom = 13
        setupCamera(latitude: unitsModel.data[0].position.lt, longitude: unitsModel.data[0].position.ln, zoom: zoom)
    }
    
    
    
    func setupCamera(latitude: Double, longitude: Double, zoom: Float){
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
            self.mapView.camera = camera
        }
    }
    
    
    
    @IBAction func zoomInButtonClick(_ sender: Any) {
        zoom += 1
        self.mapView.animate(toZoom: zoom)
    }
    

    
    @IBAction func zoomOutButtonClick(_ sender: Any) {
        zoom -= 1
        self.mapView.animate(toZoom: zoom)
    }
    
    
    @IBAction func menuButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowMenu", sender: self)
    }
    
    
    
    func showAlert(){
        let alert = UIAlertController(title: "", message: "Не удалось получить ID сессии для этого пользователя. \nПопробуйте войти под другим аккаунтом", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Выход", style: UIAlertAction.Style.default, handler: { action in
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MenuViewController
        destinationVC.unitsModel = unitsModel
    }
    
    
    
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source as? MenuViewController
        unit = sourceViewController!.unit
        guard let latitude = self.unit?.position.lt, let longitude = self.unit?.position.ln else {return}
        setupCamera(latitude: latitude, longitude: longitude, zoom: zoom)
    }
    

    
}
