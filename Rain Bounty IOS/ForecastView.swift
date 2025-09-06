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
        if(roofAreaInt == 0 || gardenAreaInt == 0)
        {
            ZStack {
                VStack {
                    Text("To get the most accurate rainwater collection data, please configure your rainwater collection location, roof and garden/lawn area using the settings link below:")
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    NavigationLink(destination: SettingsView()){
                        Text (" Settings ")
                            .font(.callout)
                        Image(systemName: "gear")
                            //.frame(width: 50, height: 50)
                    }
                }
            }
        }
        else
        {
        ZStack {
            ScrollView (.vertical) {
                VStack {
                    Text("To help you optimize your harvested rainwater, we use a 14-day rain forecast to simulate water collection and usage.")
                        .font(.caption)
                        .fontWeight(.thin)
                        .padding(.horizontal, 10)
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
                    
                    Text("Set the water level in your tank(s) to see how many days you can irrigate using rainwater")
                        .font(.subheadline)
                        .fontWeight(.thin)
                        .padding(.horizontal, 10)
                    
                    
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
                            }
                        }
                        .frame(width: .infinity, height: 400, alignment: .center )
                        .chartForegroundStyleScale(["Rain Collection": Color.green, "Tank water": Color.blue])
                        .chartLegend(.visible)
                        .chartLegend(position: .bottom, alignment: .bottomLeading)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 2)) { value in
                                if let date = value.as(Date.self) {
                                    AxisValueLabel {
                                        Text(date, format: Date.FormatStyle()
                                            .day().month())
                                          //  .calendar(.current)          // force local calendar
                                          //  .timeZone(.current))        // force local timezone
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
                        
                        Text(verbatim: "Rain Collection and Storage trend in the next 14 days")
                            .padding()
                        VStack {
                            
                            HStack {
                                Text("Days watered with rain and harvested rainwater")
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
                                Text("Overflow Rainwater (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.totalOverflowWaterAmount, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Municipal water used for irrigation (gal)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(self.rain_water_collection_data!.totalPersonalWaterUsed, specifier: "%.0f")")
                                    .frame(maxWidth: valueWidth, alignment: .trailing)
                                    .bold(true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)

                            HStack {
                                Text("Daily irrigation requirement (gal)")
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
