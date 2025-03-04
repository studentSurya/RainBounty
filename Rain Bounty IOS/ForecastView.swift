//
//  ForecastView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/23/25.
//
import SwiftUI
import Charts

struct ForecastView: View {
    @AppStorage("roofAreaInt") var roofAreaInt: Int = 0
    @AppStorage("gardenAreaInt") var gardenAreaInt: Int = 0
    @AppStorage("waterTankSizeInt") var waterTankSizeInt: Int = 100
    @AppStorage("waterCostUsdDouble") var waterCostUsdDouble: Double = 2.38
    
    @AppStorage("homeLatitude") var homeLatitude: Double = 0.0
    @AppStorage("homeLongitude") var homeLongitude: Double = 0.0
    
    
    @AppStorage("harvestEfficiencyDouble") var harvestEfficiencyDouble: Double = 0.75
    
    @State private var waterCollectedInTank: Double = 0.0
    @State private var daily_rain_data: [Double] = []
    @State private var rain_water_collection_data : RainwaterHarvestUtil.RainWaterCollectionSummary? = nil
    @State private var progressMessage: String = "Initializing..."
    
    
    let valueWidth = 70.0 //.infinity
    
    var body: some View {
        ZStack {
            ScrollView (.vertical) {
                VStack {
                    Slider(
                        value: Binding(get: {
                            self.waterCollectedInTank
                        }, set: { (newVal) in
                            self.waterCollectedInTank = newVal
                            self.waterCollectedInTankSliderChanged()
                        }),
                        in: 0...Double(waterTankSizeInt),
                        step: 10
                    ) {
                        Text("Initial Water Collected in Tank (gal)")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("\(waterTankSizeInt)")
                    }
                    .padding(.horizontal, 10)
                    
                    Text("Check the water level in your tank(s) and set the initial water collected value")
                        .font(.subheadline)
                        .italic()
                    
                    HStack {
                        Text("Initial Water Collected in Tank (gal)")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(waterCollectedInTank, specifier: "%.1f")")
                            .frame(maxWidth: valueWidth, alignment: .trailing)
                            .bold(true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    HStack {
                        Text("Tank Size (gal)")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(Double(waterTankSizeInt), specifier: "%.1f")")
                            .frame(maxWidth: valueWidth, alignment: .trailing)
                            .bold(true)
                    }
                    .padding(.horizontal, 20)

                    if (self.rain_water_collection_data != nil) {
                        // Background Gradient
                        Chart {
                            let calendar = Calendar.autoupdatingCurrent
                            
                            //Tank water size Chart
                            ForEach(self.rain_water_collection_data!.weeklyRainCollectionData) { dataPoint in
                                LineMark(
                                    x: .value("Day", Calendar.current.date(byAdding: .day, value: (dataPoint.weekNumber - 1), to: Date())!, unit: .day),
                                    y: .value("Tank water", dataPoint.tankWater)
                                )
                                .foregroundStyle(.blue)
                            }
                            
                            
                            ForEach(self.rain_water_collection_data!.weeklyRainCollectionData) { dataPoint in
                                BarMark(
                                    x: .value("Day", Calendar.current.date(byAdding: .day, value: (dataPoint.weekNumber - 1), to: Date())!, unit: .day),
                                    y: .value("Rain Collection", dataPoint.rainCollection)
                                )
                                .foregroundStyle(.green)
                                //.chartYAxis(axis: .hidden) // Hide the volume y-axis
                            }
                        }
                        .frame(width: .infinity, height: 400, alignment: .center )
                        .chartForegroundStyleScale(["Rain Collection": Color.green, "Tank water": Color.blue])
                        .chartLegend(.visible)
                        .chartLegend(position: .bottom, alignment: .bottomLeading)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 2)) { value in
                                if let date = value.as(Date.self) {
                                    let day = Calendar.current.component(.day, from: date)
                                    switch day {
                                    default:
                                        AxisValueLabel(format: .dateTime.day().month())
                                    }
                                }
                                AxisGridLine()
                                AxisTick()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 5))
                        }
                        .onAppear() {
                            // Do nothing
                        }
                        .padding()
                        
                        Text(verbatim: "Rain Collection and Storage trend in the next two weeks")
                            .padding()
                        VStack {
                            
                            HStack {
                                Text("# of Days watered with rain or harvested rainwater")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.numberOfWeeksWateredByRainwater)")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Harvested water used for irrigation (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.totalHarvestedRainwaterUsed, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Personal water used for irrigation (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.totalPersonalWaterUsed, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Daily water req (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.weeklyWaterRequirement, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        
                    } else {
                        Text(progressMessage)
                            .font(.title)
                    } //end if-else
                } //end VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            } //scroll view
        }//zstack
        .onAppear() {
            self.waterCollectedInTank = Double(self.waterTankSizeInt)
            runGetRainData()
        }
    }

    func runGetRainData() {
        Task {
            print("Fetch Rain data")
            do {
                self.daily_rain_data = try await RainwaterHarvestUtil.getRain(latitude: self.homeLatitude, longitude: self.homeLongitude, getForecastData: true)
                waterCollectedInTankSliderChanged()
            } catch let error {
                print("Error fetching rain data! \(error)")
                self.rain_water_collection_data = nil
                progressMessage = "Error fetching rain data! Sorry for the inconvenience. Please retry after some time"
            }
        }
    }
    
    func waterCollectedInTankSliderChanged() {
        print("Slider value changed to \(waterCollectedInTank)")
        self.rain_water_collection_data = RainwaterHarvestUtil.calculateRainCollectionTrend(
            daily_rain_data: self.daily_rain_data,
            garden_size: Double(self.gardenAreaInt),
            roof_size: Double(self.roofAreaInt),
            tank_size: Double(self.waterTankSizeInt),
            harvest_efficiency: self.harvestEfficiencyDouble,
            calculateWeeklyData: false,
            initialWaterCollectedInTank: waterCollectedInTank)
    }

}
