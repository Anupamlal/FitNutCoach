//
//  NudgeRuleEngine.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 04/08/26.
//

import Foundation

enum NudgeRuleId: String, Codable, CaseIterable, Hashable {
    case hydrationLowIntake = "hydration_low_intake"
    case hydrationHotWeather = "hydration_hot_weather"
    case hydrationAfternoonGap = "hydration_afternoon_gap"
    case nutritionProteinGap = "nutrition_protein_gap"
    case nutritionLowCalories = "nutrition_low_calories"
    case activityLowSteps = "activity_low_steps"
    case activityEveningGoal = "activity_evening_goal"
    case activityInactivity = "activity_inactivity"
    case workoutReminder = "workout_reminder"
    case workoutRestDay = "workout_rest_day"
    case workoutCompleted = "workout_completed"
    case sleepBedtime = "sleep_bedtime"
    case sleepPoorTrend = "sleep_poor_trend"
    case weightMissingLog = "weight_missing_log"
    case recoveryConsecutiveWorkouts = "recovery_consecutive_workouts"
    case recoveryStretch = "recovery_stretch"
    case weatherRain = "weather_rain"
    case weatherCold = "weather_cold"
    case weatherHeat = "weather_heat"
    case mealMissingBreakfast = "meal_missing_breakfast"
    case mealMissingLunch = "meal_missing_lunch"
    case mealMissingDinner = "meal_missing_dinner"
    case achievementCalorieGoal = "achievement_calorie_goal"
    case achievementProteinGoal = "achievement_protein_goal"
    case achievementWaterGoal = "achievement_water_goal"
    case achievementStepsGoal = "achievement_steps_goal"
}

struct NudgeRuleContext {
    let profile: ProfileModel
    let dailyActivity: DailyActivityModel
    let weather: WeatherModel?
    let currentDate: Date
    
    init(profile: ProfileModel, dailyActivity: DailyActivityModel, weather: WeatherModel?, currentDate: Date = Date()) {
        self.profile = profile
        self.dailyActivity = dailyActivity
        self.weather = weather
        self.currentDate = currentDate
    }
}

final class NudgeRuleEngine {
    
    func generateNudges(context: NudgeRuleContext) -> [NudgeModel] {
        let today = context.currentDate.getStartOfDate()
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        
        var nudges: [NudgeModel] = []
        
        nudges.append(contentsOf: hydrationRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: nutritionRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: activityRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: workoutRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: sleepRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: weightRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: recoveryRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: weatherRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: mealLoggingRules(context: context, today: today, endOfDay: endOfDay))
        nudges.append(contentsOf: achievementRules(context: context, today: today, endOfDay: endOfDay))
        
        return nudges
    }
    
    // MARK: - Hydration
    
    private func hydrationRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let waterTarget = context.profile.waterTargetLiters
        let waterIntake = context.dailyActivity.waterLiters
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        
        if waterTarget > 0 && waterIntake < waterTarget * 0.5 && hour >= 10 {
            let remaining = max(0, waterTarget - waterIntake)
            results.append(NudgeModel(
                ruleId: NudgeRuleId.hydrationLowIntake.rawValue,
                title: AppTexts.nudgeHydrationLowTitleText,
                message: String(format: AppTexts.nudgeHydrationLowMessageText, remaining.formatToOneDecimalPlaces()),
                category: .hydration,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWaterTracker
            ))
        }
        
        if let weather = context.weather, let temp = parseTemperature(weather.temperature), temp >= 30 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.hydrationHotWeather.rawValue,
                title: AppTexts.nudgeHydrationHotTitleText,
                message: String(format: AppTexts.nudgeHydrationHotMessageText, weather.temperature),
                category: .hydration,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWaterTracker
            ))
        }
        
        if waterTarget > 0 && waterIntake < waterTarget * 0.75 && hour >= 14 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.hydrationAfternoonGap.rawValue,
                title: AppTexts.nudgeHydrationAfternoonTitleText,
                message: AppTexts.nudgeHydrationAfternoonMessageText,
                category: .hydration,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWaterTracker
            ))
        }
        
        return results
    }
    
    // MARK: - Nutrition
    
    private func nutritionRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let proteinTarget = context.profile.proteinTarget
        let proteinIntake = context.dailyActivity.protein
        let calorieTarget = context.profile.calorieTarget
        let calorieIntake = context.dailyActivity.calories
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        
        if proteinTarget > 0 {
            let proteinGap = proteinTarget - proteinIntake
            if proteinGap > 0 && proteinGap <= 30 && hour >= 12 {
                results.append(NudgeModel(
                    ruleId: NudgeRuleId.nutritionProteinGap.rawValue,
                    title: AppTexts.nudgeProteinGapTitleText,
                    message: String(format: AppTexts.nudgeProteinGapMessageText, proteinGap.formatToOneDecimalPlaces()),
                    category: .nutrition,
                    priority: .high,
                    date: today,
                    expiresAt: endOfDay,
                    actionType: .openFoodLogger
                ))
            }
        }
        
        if calorieTarget > 0 && calorieIntake < calorieTarget * 0.4 && hour >= 15 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.nutritionLowCalories.rawValue,
                title: AppTexts.nudgeLowCaloriesTitleText,
                message: AppTexts.nudgeLowCaloriesMessageText,
                category: .nutrition,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .openFoodLogger
            ))
        }
        
        return results
    }
    
    // MARK: - Activity
    
    private func activityRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let stepTarget = context.profile.stepTarget
        let steps = context.dailyActivity.steps
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        
        if stepTarget > 0 && Double(steps) < Double(stepTarget) * 0.4 && hour >= 12 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.activityLowSteps.rawValue,
                title: AppTexts.nudgeLowStepsTitleText,
                message: AppTexts.nudgeLowStepsMessageText,
                category: .activity,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .openActivity
            ))
        }
        
        if stepTarget > 0 && hour >= 18 && Double(steps) < Double(stepTarget) * 0.8 {
            let stepsRemaining = stepTarget - steps
            results.append(NudgeModel(
                ruleId: NudgeRuleId.activityEveningGoal.rawValue,
                title: AppTexts.nudgeEveningWalkTitleText,
                message: String(format: AppTexts.nudgeEveningWalkMessageText, "\(stepsRemaining)"),
                category: .activity,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openActivity
            ))
        }
        
        if context.dailyActivity.exerciseMinutes == 0 && hour >= 11 && hour < 14 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.activityInactivity.rawValue,
                title: AppTexts.nudgeInactivityTitleText,
                message: AppTexts.nudgeInactivityMessageText,
                category: .activity,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .openActivity
            ))
        }
        
        return results
    }
    
    // MARK: - Workout
    
    private func workoutRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let workouts = context.dailyActivity.workouts ?? []
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        
        if workouts.isEmpty && hour >= 7 && hour < 20 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.workoutReminder.rawValue,
                title: AppTexts.nudgeWorkoutReminderTitleText,
                message: AppTexts.nudgeWorkoutReminderMessageText,
                category: .workout,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWorkout
            ))
        }
        
        if workouts.count >= 2 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.workoutRestDay.rawValue,
                title: AppTexts.nudgeRestDayTitleText,
                message: AppTexts.nudgeRestDayMessageText,
                category: .workout,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if !workouts.isEmpty {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.workoutCompleted.rawValue,
                title: AppTexts.nudgeWorkoutDoneTitleText,
                message: AppTexts.nudgeWorkoutDoneMessageText,
                category: .workout,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        return results
    }
    
    // MARK: - Sleep
    
    private func sleepRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        let sleepMinutes = context.dailyActivity.sleepMinutes
        
        if hour >= 21 && sleepMinutes == 0 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.sleepBedtime.rawValue,
                title: AppTexts.nudgeBedtimeTitleText,
                message: AppTexts.nudgeBedtimeMessageText,
                category: .sleep,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if sleepMinutes > 0 && sleepMinutes < 360 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.sleepPoorTrend.rawValue,
                title: AppTexts.nudgePoorSleepTitleText,
                message: AppTexts.nudgePoorSleepMessageText,
                category: .sleep,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        return results
    }
    
    // MARK: - Weight
    
    private func weightRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        if context.profile.weightKg <= 0 {
            return [NudgeModel(
                ruleId: NudgeRuleId.weightMissingLog.rawValue,
                title: AppTexts.nudgeLogWeightTitleText,
                message: AppTexts.nudgeLogWeightMessageText,
                category: .weight,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWeight
            )]
        }
        return []
    }
    
    // MARK: - Recovery
    
    private func recoveryRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let workouts = context.dailyActivity.workouts ?? []
        
        if workouts.count >= 2 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.recoveryConsecutiveWorkouts.rawValue,
                title: AppTexts.nudgeRecoveryTitleText,
                message: AppTexts.nudgeRecoveryConsecutiveMessageText,
                category: .recovery,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if context.dailyActivity.exerciseMinutes >= 45 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.recoveryStretch.rawValue,
                title: AppTexts.nudgeStretchTitleText,
                message: AppTexts.nudgeStretchMessageText,
                category: .recovery,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        return results
    }
    
    // MARK: - Weather
    
    private func weatherRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        guard let weather = context.weather, weather.cityName != nil else { return [] }
        var results: [NudgeModel] = []
        
        switch weather.weatherCondition {
        case .rain, .drizzle, .thunderstorm:
            results.append(NudgeModel(
                ruleId: NudgeRuleId.weatherRain.rawValue,
                title: AppTexts.nudgeRainTitleText,
                message: AppTexts.nudgeRainMessageText,
                category: .weather,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        case .snow, .fog:
            results.append(NudgeModel(
                ruleId: NudgeRuleId.weatherCold.rawValue,
                title: AppTexts.nudgeColdTitleText,
                message: AppTexts.nudgeColdMessageText,
                category: .weather,
                priority: .medium,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        default:
            break
        }
        
        if let temp = parseTemperature(weather.temperature), temp >= 32 {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.weatherHeat.rawValue,
                title: AppTexts.nudgeHeatTitleText,
                message: String(format: AppTexts.nudgeHeatMessageText, weather.temperature),
                category: .weather,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openWaterTracker
            ))
        }
        
        return results
    }
    
    // MARK: - Meal Logging
    
    private func mealLoggingRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        let meals = context.dailyActivity.meals ?? []
        let hour = Calendar.current.component(.hour, from: context.currentDate)
        
        if hour >= 10 && !hasLoggedMeal(.breakfast, meals: meals) {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.mealMissingBreakfast.rawValue,
                title: AppTexts.nudgeMissingBreakfastTitleText,
                message: AppTexts.nudgeMissingBreakfastMessageText,
                category: .mealLogging,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openMealLog,
                actionValue: MealType.breakfast.rawValue
            ))
        }
        
        if hour >= 14 && !hasLoggedMeal(.lunch, meals: meals) {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.mealMissingLunch.rawValue,
                title: AppTexts.nudgeMissingLunchTitleText,
                message: AppTexts.nudgeMissingLunchMessageText,
                category: .mealLogging,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openMealLog,
                actionValue: MealType.lunch.rawValue
            ))
        }
        
        if hour >= 20 && !hasLoggedMeal(.dinner, meals: meals) {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.mealMissingDinner.rawValue,
                title: AppTexts.nudgeMissingDinnerTitleText,
                message: AppTexts.nudgeMissingDinnerMessageText,
                category: .mealLogging,
                priority: .high,
                date: today,
                expiresAt: endOfDay,
                actionType: .openMealLog,
                actionValue: MealType.dinner.rawValue
            ))
        }
        
        return results
    }
    
    // MARK: - Achievement
    
    private func achievementRules(context: NudgeRuleContext, today: Date, endOfDay: Date) -> [NudgeModel] {
        var results: [NudgeModel] = []
        
        if context.profile.calorieTarget > 0 && context.dailyActivity.calories >= context.profile.calorieTarget {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.achievementCalorieGoal.rawValue,
                title: AppTexts.nudgeCalorieGoalTitleText,
                message: AppTexts.nudgeCalorieGoalMessageText,
                category: .achievement,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if context.profile.proteinTarget > 0 && context.dailyActivity.protein >= context.profile.proteinTarget {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.achievementProteinGoal.rawValue,
                title: AppTexts.nudgeProteinGoalTitleText,
                message: AppTexts.nudgeProteinGoalMessageText,
                category: .achievement,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if context.profile.waterTargetLiters > 0 && context.dailyActivity.waterLiters >= context.profile.waterTargetLiters {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.achievementWaterGoal.rawValue,
                title: AppTexts.nudgeWaterGoalTitleText,
                message: AppTexts.nudgeWaterGoalMessageText,
                category: .achievement,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        if context.profile.stepTarget > 0 && context.dailyActivity.steps >= context.profile.stepTarget {
            results.append(NudgeModel(
                ruleId: NudgeRuleId.achievementStepsGoal.rawValue,
                title: AppTexts.nudgeStepsGoalTitleText,
                message: AppTexts.nudgeStepsGoalMessageText,
                category: .achievement,
                priority: .low,
                date: today,
                expiresAt: endOfDay,
                actionType: .viewDetails
            ))
        }
        
        return results
    }
    
    // MARK: - Helpers
    
    private func hasLoggedMeal(_ mealType: MealType, meals: [MealModel]) -> Bool {
        meals.contains { meal in
            meal.mealType == mealType && (meal.foodItems?.isEmpty == false)
        }
    }
    
    private func parseTemperature(_ value: String) -> Double? {
        let cleaned = value
            .replacingOccurrences(of: "°", with: "")
            .replacingOccurrences(of: "C", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleaned)
    }
}
