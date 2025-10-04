//
//  APIName.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 09/09/25.
//

import SwiftUI

public enum APIName: String {
    case barcodeScannerAPI = "https://world.openfoodfacts.org/api/v0/product/%@.json"
    case weatherAPI = "https://api.open-meteo.com/v1/forecast?latitude=%@&longitude=%@&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,weather_code,uv_index_max,sunrise,sunset&timezone=auto&forecast_days=6"
}
