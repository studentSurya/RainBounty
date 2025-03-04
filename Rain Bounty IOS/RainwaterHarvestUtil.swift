//
//  RainwaterHarvestUtil.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/19/25.
//
import SwiftUI

class RainwaterHarvestUtil {
    struct LocationRainfallData: Codable {
        let daily: Daily
    }

    struct Daily: Codable {
        let rain_sum: [Double]
    }

    enum ZCError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    struct WeeklyRainwaterCollectionData : Identifiable {
        var id: UUID
        var weekNumber : Int
        var rainFall : Double                // The value calculated using daily rain data.
        var rainCollection: Double      // In Gallons. NOTE (Hint): This value cannot exceed waterTankSize
        var rainOnGarden : Double
        var harvestedRainwaterUsedForIrrigation: Double  //In Gallons. NOTE (Hint): If it rains, then you can be smart and not water the garden. Again this value cannot be greater than tank capacity
        var overflowWaterAmount : Double
        var tankWater : Double
        var personalWaterUsage : Double
    }

    struct RainWaterCollectionSummary {
        var weeklyRainCollectionData : [WeeklyRainwaterCollectionData]
        var gardenSize: Double
        var weeklyWaterRequirement: Double
        var waterTankSize: Double
        var numberOfWeeksWateredByRainwater: Int
        var totalRainOnGarden : Double
        var totalPersonalWaterUsed : Double
        var totalHarvestedRainwaterUsed: Double
        var roofSize : Double
    }

    // MARK: - API Request
    static func getRain(latitude: Double, longitude: Double, getForecastData:Bool) async throws -> [Double] {
        //request one whole year's historical rainfall data
        //NOTE: The start_date and end_date is an year apart.
        var endpoint = getForecastData ?
        "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=rain_sum&timezone=GMT&forecast_days=14":
        "https://archive-api.open-meteo.com/v1/archive?latitude=\(latitude)&longitude=\(longitude)&start_date=2024-01-01&end_date=2024-12-31&daily=rain_sum&timezone=GMT"
        
        //NOTE: This method should return rain data in inches
        //      We do this by appending precipation unit as Inches
        //      By default, the API returns precipation data in mm (millimeters)
        endpoint += "&precipitation_unit=inch"
        
        print("Endpoint URL: \(endpoint)")
        
        guard let url = URL(string: endpoint) else { throw ZCError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ZCError.invalidResponse
        }
        // Print the response for debugging purposes.
        print(String(data: data, encoding: .utf8)!)
        
        let rainfallData: LocationRainfallData =  try JSONDecoder().decode(LocationRainfallData.self, from: data)
        return rainfallData.daily.rain_sum
    }
    
    static func calculateRainCollectionTrend(
        daily_rain_data: [Double],
        garden_size: Double,
        roof_size: Double,
        tank_size: Double,
        harvest_efficiency: Double,
        calculateWeeklyData: Bool,
        initialWaterCollectedInTank: Double = 0.0) -> RainWaterCollectionSummary {
            
        var tank_water = initialWaterCollectedInTank
        let chunk_size = calculateWeeklyData ? 7 : 1;
        let chunked_data = daily_rain_data.chunks(chunk_size)
        
        // 0.623 * garden_size formula is for weekly water needs (assuming 1 inch per sqft per week)
        // Divide garden water needs by 7, if we are calculating per day water needs.
            let water_needed_for_garden = garden_size * 0.623 * Double(chunk_size) / 7.0

        var rain_data = RainWaterCollectionSummary(
            weeklyRainCollectionData: [WeeklyRainwaterCollectionData](),
            gardenSize: garden_size,
            weeklyWaterRequirement: water_needed_for_garden,
            waterTankSize: tank_size,
            numberOfWeeksWateredByRainwater:0,
            totalRainOnGarden: 0.0,
            totalPersonalWaterUsed: 0.0,
            totalHarvestedRainwaterUsed:0.0,
            roofSize: roof_size)
            
        var chunk_rain = [Double]();

        for chunk in chunked_data
        {
            var rain_for_chunk = 0.0
            for daily_rain_value in chunk
            {
                rain_for_chunk = rain_for_chunk + daily_rain_value
            }
            chunk_rain.append(rain_for_chunk)
        }


        for i in stride(from: 0, to: chunk_rain.count, by: 1)
        {
            var harvested_water_used_for_irrigation = 0.0
            var self_water_usage = 0.0
            var overflow_water = 0.0

            let rain_on_garden = chunk_rain[i] * 0.623 * garden_size
            let rain_harvested_from_roof = chunk_rain[i] * roof_size * 0.623 * harvest_efficiency
            tank_water = tank_water + rain_harvested_from_roof
            if(tank_water > tank_size)
            {
                overflow_water = (tank_water - tank_size)
                tank_water = tank_size
            }
           
            if(rain_on_garden >= water_needed_for_garden)
            {
                //abundant of rain this week. No need of extra watering!!
            }
            else if(rain_on_garden < water_needed_for_garden)
            {
                if(tank_water < water_needed_for_garden - rain_on_garden)
                {
                    harvested_water_used_for_irrigation = tank_water
                    self_water_usage = (water_needed_for_garden - rain_on_garden - harvested_water_used_for_irrigation)
                    tank_water  = 0.0
                }
                else
                {
                    tank_water  = tank_water - (water_needed_for_garden - rain_on_garden)
                    harvested_water_used_for_irrigation = water_needed_for_garden - rain_on_garden
                }
            }

            rain_data.weeklyRainCollectionData.append(WeeklyRainwaterCollectionData(
                id:UUID(),
                weekNumber: i + 1,
                rainFall: chunk_rain[i],
                rainCollection: rain_harvested_from_roof,
                rainOnGarden: rain_on_garden,
                harvestedRainwaterUsedForIrrigation: harvested_water_used_for_irrigation,
                overflowWaterAmount: overflow_water,
                tankWater: tank_water,
                personalWaterUsage: self_water_usage))
        }

        
        for i in stride(from: 0, to: rain_data.weeklyRainCollectionData.count, by: 1)
        {
            rain_data.totalPersonalWaterUsed = rain_data.totalPersonalWaterUsed + rain_data.weeklyRainCollectionData[i].personalWaterUsage
            rain_data.totalHarvestedRainwaterUsed = rain_data.totalHarvestedRainwaterUsed + rain_data.weeklyRainCollectionData[i].harvestedRainwaterUsedForIrrigation
            rain_data.totalRainOnGarden = rain_data.totalRainOnGarden + rain_data.weeklyRainCollectionData[i].rainOnGarden
            
            if (rain_data.weeklyRainCollectionData[i].personalWaterUsage == 0) {
                rain_data.numberOfWeeksWateredByRainwater = rain_data.numberOfWeeksWateredByRainwater + 1;
            }
        }
        
        print("*******************************")
        print(" Chunk size: \(chunk_size)")
        print(" Garden size: \(rain_data.gardenSize)")
        print(" Weekly water requirement: \(rain_data.weeklyWaterRequirement)")
        print(" Water tank size: \(rain_data.waterTankSize)")
        print(" Number of weeks watered using harvested rainwater: \(rain_data.numberOfWeeksWateredByRainwater)")
        print(" Total Rain on Garden this year: \(rain_data.totalRainOnGarden)")
        print(" Total Harvested Water Used For Irrigation this year: \(rain_data.totalHarvestedRainwaterUsed)")
        print(" Total Water Personal water used this year: \(rain_data.totalPersonalWaterUsed)")
        print("*******************************")
        
        return rain_data
    }
}


extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

