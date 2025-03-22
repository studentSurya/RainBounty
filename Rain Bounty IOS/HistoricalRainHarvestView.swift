//
//  HistoricalRainHarvestView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/18/25.
//
import SwiftUI
import Charts

struct HistoricalRainHarvestView: View {
    @AppStorage("roofAreaInt") var roofAreaInt: Int = 0
    @AppStorage("gardenAreaInt") var gardenAreaInt: Int = 0
    @AppStorage("waterTankSizeInt") var waterTankSizeInt: Int = 100
    @AppStorage("waterCostUsdDouble") var waterCostUsdDouble: Double = 2.38
    
    @AppStorage("homeLatitude") var homeLatitude: Double = 0.0
    @AppStorage("homeLongitude") var homeLongitude: Double = 0.0
    
    
    @AppStorage("harvestEfficiencyDouble") var harvestEfficiencyDouble: Double = 0.75
    
    @State private var waterTankSize: Double = 0.0
    @State private var daily_rain_data: [Double] = []
    @State private var rain_water_collection_summary : RainwaterHarvestUtil.RainWaterCollectionSummary? = nil
    @State private var progressMessage: String = "Initializing..."
    
    var body: some View {
        ZStack {
            ScrollView (.vertical) {
                VStack {
                    let lastYear = Calendar.current.component(.year, from: Date()) - 1
                    Text("To help you plan your ideal rainwater harvesting tank size, we use previous year's rainfall data to simulate water collection and require you to first configure your home details and irrigation needs in the Settings page.")
                        .font(.caption)
                        .fontWeight(.thin)
                        .padding(.horizontal, 10)
                    Slider(
                        value: Binding(get: {
                            self.waterTankSize
                        }, set: { (newVal) in
                            self.waterTankSize = newVal
                            self.waterTankSliderChanged()
                        }),
                        in: 0...3000,
                        step: 50
                    ) {
                        Text("Tank size (gal)")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("3000")
                    }
                    .padding(.horizontal, 10)
                    
                    Text("Change tank size to see how much rain you can collect")
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .padding(.horizontal, 10)
                    

                    Text("Tank Size (gal) \(waterTankSize, specifier: "%.1f")")
                        .padding()
                    
                    
                    if (self.rain_water_collection_summary != nil) {
                        // Background Gradient
                        Chart {
                            let calendar = Calendar.autoupdatingCurrent
                            
                            //Tank water size Chart
                            ForEach(self.rain_water_collection_summary!.weeklyRainCollectionData) { dataPoint in
                                LineMark(
                                    x: .value("Week", calendar.date(from:DateComponents( weekOfYear: dataPoint.weekNumber, yearForWeekOfYear: lastYear))!, unit: .weekOfYear),
                                    y: .value("Tank water", dataPoint.tankWater)
                                )
                                .foregroundStyle(.blue)
                            }
                            
                            
                            ForEach(self.rain_water_collection_summary!.weeklyRainCollectionData) { dataPoint in
                                BarMark(
                                    x: .value("Week", calendar.date(from:DateComponents( weekOfYear: dataPoint.weekNumber, yearForWeekOfYear: lastYear))!, unit: .weekOfYear),
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
                            AxisMarks(values: .stride(by: .month, count: 2)) { value in
                                if let date = value.as(Date.self) {
                                    let month = Calendar.current.component(.month, from: date)
                                    switch month {
                                    default:
                                        AxisValueLabel(format: .dateTime.month())
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
                        
                        Text(verbatim: "Rain Collection and Storage trend in year \(lastYear)")
                            .padding()
                        VStack {
                            let valueWidth = 70.0 //.infinity
                            
                            HStack {
                                Text("Weeks watered with rain and harvested rainwater")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_summary!.numberOfWeeksWateredByRainwater)")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            /*
                             HStack {
                             Text("Rain collected on garden (gal)")
                             .frame(maxWidth: .infinity, alignment: .leading)

                             Text("\(self.rain_water_collection_data!.totalRainOnGarden, specifier: "%.0f")")
                             .frame(maxWidth: valueWidth, alignment: .trailing)
                             }
                             */

                            HStack {
                                Text("Harvested water used for irrigation (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_summary!.totalHarvestedRainwaterUsed, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Municipal Water used for irrigation (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_summary!.totalPersonalWaterUsed, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Weekly irrigation requirment (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_summary!.weeklyWaterRequirement, specifier: "%.0f")")
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
            self.waterTankSize = Double(self.waterTankSizeInt)
            runGetRainData()
        }
    }

    func runGetRainData() {
        Task {
            print("Fetch Rain data")
            do {
                self.daily_rain_data = try await RainwaterHarvestUtil.getRain(latitude: self.homeLatitude, longitude: self.homeLongitude, getForecastData: false)
                waterTankSliderChanged()
            } catch let error {
                print("Error fetching rain data! \(error)")
                self.rain_water_collection_summary = nil
                progressMessage = "Error fetching rain data! Sorry for the inconvenience. Please retry after some time"
            }
        }
    }
    
    func waterTankSliderChanged() {
        print("Slider value changed to \(waterTankSize)")
        self.rain_water_collection_summary = RainwaterHarvestUtil.calculateRainCollectionTrend(
            daily_rain_data: self.daily_rain_data,
            garden_size: Double(self.gardenAreaInt),
            roof_size: Double(self.roofAreaInt),
            tank_size: self.waterTankSize,
            harvest_efficiency: self.harvestEfficiencyDouble,
            calculateWeeklyData: true)
    }

}
