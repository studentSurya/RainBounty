//
//  SettingsView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/17/25.
//
import SwiftUI
import MapKit

struct SettingsView: View {
    @EnvironmentObject var gblHomeSettings: HomeSettings
    
    @AppStorage("uiStateWaterTankSizeStr") var uiStateWaterTankSizeStr: String = "100"
    @AppStorage("uiStateWaterCostUsdStr") var uiStateWaterCostUsdStr: String = "2.38"
    @AppStorage("uiharvestEfficiencyStr") var uiharvestEfficiencyStr: String = "0.75"
    
    @AppStorage("roofAreaInt") var roofAreaInt: Int = 0
    @AppStorage("gardenAreaInt") var gardenAreaInt: Int = 0
    @AppStorage("waterTankSizeInt") var waterTankSizeInt: Int = 100
    @AppStorage("waterCostUsdDouble") var waterCostUsdDouble: Double = 2.38
    
    @AppStorage("homeLatitude") var homeLatitude: Double = 0.0
    @AppStorage("homeLongitude") var homeLongitude: Double = 0.0
    
    
    @AppStorage("harvestEfficiencyDouble") var harvestEfficiencyDouble: Double = 0.75
    
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var mapSelection: MKMapItem? = nil
    @State private var searchText: String = ""
    @State private var searchResults = [MKMapItem]()
    @State private var selectedCoordinatesStr = ""
    
    var body: some View {
        Form{
            
            Section (header: Text("Home / Site location info"),
                     footer: Text("Location info allows us to get historical and forecast rain data for your area."))
            {
                
                //Map for taking user address
                Map (position: $cameraPosition, selection: $mapSelection) {

                    ForEach (searchResults, id: \.self) { item in
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        //MapPin(coordinate: placemark.coordinate)
                    }
                    
                }
                .frame(height: 300)
                .onAppear() {
                    // When the map first appears initialize it with either the current location
                    // or the previously set location
                    if (homeLatitude != 0.0 && homeLongitude != 0.0)
                    {
                        let homeCoordinate = CLLocationCoordinate2D(latitude: homeLatitude, longitude: homeLongitude)
                        cameraPosition = .region(MKCoordinateRegion(
                            center: homeCoordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))
                        selectedCoordinatesStr = "Latitude: \(homeLatitude), Longitude: \(homeLongitude)"
                        let homePlaceMark = MKPlacemark(coordinate: homeCoordinate)
                        mapSelection = MKMapItem(placemark: homePlaceMark)
                        searchResults.removeAll()
                        if (mapSelection != nil) {
                            searchResults.append(mapSelection!)
                        }
                    }
                    else {
                        mapSelection = MKMapItem.forCurrentLocation()
                        updateHomeCoordinatesWithMapSelection()
                        searchResults.removeAll()
                        if (mapSelection != nil) {
                            searchResults.append(mapSelection!)
                        }
                    }
                }
                .mapControls {
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                .overlay(alignment: .bottom) {
                    TextField("Enter Address...", text: $searchText)
                        .font(.subheadline)
                        .padding(12)
                        .background(.white)
                        .padding()
                        .shadow(radius: 10)
                }
                .onSubmit(of: .text) {
                    Task { await searchPlaces() }
                }
                .onChange(of: mapSelection, { oldValue, newValue in
                    updateHomeCoordinatesWithMapSelection()
                })
                Text("Selected coordinates: \(selectedCoordinatesStr)")

            }
            
            Section (header: Text("Home Info"),
                     footer: Text("This data allows us to simulate your rainfall based of your home and garden/lawn measurements."))
            {
                
                //Roof area settings navigation link
                NavigationLink(
                    destination:
                        RoofCalculatorView()
                        .environmentObject(gblHomeSettings),
                    label: {
                        HStack{
                            Text("Roof Area")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(roofAreaInt) sqft")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                )
                
                //Garden area settings navigation link
                NavigationLink(
                    destination:
                        GardenCalculatorView(),
                    label: {
                        HStack{
                            Text("Garden/Lawn Area")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(gardenAreaInt) sqft")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                )
                
                //Water tank size
                HStack{
                    Text("Water Tank Size")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    TextField("", text: $uiStateWaterTankSizeStr)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: nil, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: uiStateWaterTankSizeStr) {
                            waterTankSizeInt = Int(uiStateWaterTankSizeStr) ?? 0
                        }
                    
                    Text(" gal")
                        .frame(width:40, height:nil, alignment: .trailing)

                }
            } //end-Section
            
            /*Section (header: Text("City / Municipal info"),
                     footer: Text("This data allows us to simulate your water costs and potential savings."))
                {
                
                //Water Cost settings
                HStack{
                    Text("Water Cost")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    TextField("", text: $uiStateWaterCostUsdStr)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: nil, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: uiStateWaterCostUsdStr) {
                            waterCostUsdDouble = Double(uiStateWaterCostUsdStr) ?? 0.0
                        }
                    
                    Text(" usd")
                        .frame(width:40, height:nil, alignment: .trailing)
                }
            }*/
            
            Section (header: Text("Advanced settings"),
                     footer: Text("Use these settings to customize your water harvesting and usage simulation."))
                {
                
                //Water Cost settings
                HStack{
                    Text("Rainwater Harvest Efficiency")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    TextField("", text: $uiharvestEfficiencyStr)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: nil, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: uiharvestEfficiencyStr) {
                            harvestEfficiencyDouble = Double(uiharvestEfficiencyStr) ?? 0.75
                        }
                    
                }
            }
        
        }
        .navigationTitle(Text("Settings"))

    }
}

extension SettingsView {
    
    func updateHomeCoordinatesWithMapSelection() {
        homeLatitude = mapSelection.flatMap(\.placemark.coordinate.latitude) ?? 0.0
        homeLongitude = mapSelection.flatMap(\.placemark.coordinate.longitude) ?? 0.0
        selectedCoordinatesStr = "Latitude: \(homeLatitude), Longitude: \(homeLongitude)"
        print("Value changing \(selectedCoordinatesStr)")
    }
    
    func searchPlaces() async {
        print("Searching ... \(searchText)")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -121.8863), latitudinalMeters: 40000, longitudinalMeters: 40000)
        
        let search = MKLocalSearch(request: request)
        let results = try? await search.start()
        self.searchResults = results?.mapItems ?? []
        if (self.searchResults.count > 0)
        {
            mapSelection = self.searchResults[0]
            cameraPosition = .region(MKCoordinateRegion(center: (mapSelection?.placemark.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))
        }
        searchText = ""
        print("Found: \(self.searchResults.count)")
    }
}
