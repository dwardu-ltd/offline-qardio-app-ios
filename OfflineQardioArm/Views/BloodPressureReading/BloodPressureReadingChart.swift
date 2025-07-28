//
//  BloodPressureReadingChart\.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI
import Foundation
import Charts

struct BloodPressureReadingChart: View {
    
    let reading: BloodPressureReading
    
    var body: some View {
        //        This will draw a chart based on the reading, it will plot it on a graph with systolic and diastolic values on the y-axis and the date of the reading on the x-axis.
        VStack {
            Chart([reading]) {
                PointMark(
                    x: .value("Diastolic", $0.diastolic),
                    y: .value("Systolic", $0.systolic))
                .symbol(.circle)
                .foregroundStyle(Color.black)
                .zIndex(50)
                
                PointMark(
                    x: .value("Diastolic", 45),
                    y: .value("Systolic", 65))
                .annotation(position: .overlay, alignment: .leading) {
                    Text("Low")
                        .foregroundColor(Color.black)
                }
                .foregroundStyle(Color.mint)
                .opacity(0)
                .zIndex(41)
                
                RectangleMark(
                    xStart: .value("Diastolic",  40),
                    xEnd: .value("Positive",  60),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 90)
                )
                .foregroundStyle(Color.mint)
                .zIndex(40)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  60.5),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 90.5)
                )
                .foregroundStyle(Color.black)
                .zIndex(35)
                PointMark(
                    x: .value("Diastolic", 45),
                    y: .value("Systolic", 105))
                .annotation(position: .overlay, alignment: .leading) {
                    Text("Normal")
                        .foregroundColor(Color.black)
                }
                .foregroundStyle(Color.green)
                .opacity(0)
                .zIndex(31)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  80),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 120)
                )
                .foregroundStyle(Color.green)
                .zIndex(30)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  80.5),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 120.5)
                )
                .foregroundStyle(Color.black)
                .zIndex(25)
                PointMark(
                    x: .value("Diastolic", 45),
                    y: .value("Systolic", 130))
                .annotation(position: .overlay, alignment: .leading) {
                    Text("Prehypertension")
                        .foregroundColor(Color.black)
                }
                .foregroundStyle(Color.orange)
                .opacity(0)
                .zIndex(21)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  90),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 140)
                )
                .foregroundStyle(Color.orange)
                .zIndex(20)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  90.5),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 140.5)
                )
                .foregroundStyle(Color.black)
                .zIndex(15)
                PointMark(
                    x: .value("Diastolic", 45),
                    y: .value("Systolic", 150))
                .annotation(position: .overlay, alignment: .leading) {
                    Text("High: Stage 1 Hypertension")
                        .foregroundColor(Color.black)
                }
                .foregroundStyle(Color.pink)
                .opacity(0)
                .zIndex(11)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  100),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 160)
                )
                .foregroundStyle(Color.pink)
                .zIndex(10)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  100.5),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 160.5)
                )
                .foregroundStyle(Color.black)
                .zIndex(5)
                PointMark(
                    x: .value("Diastolic", 45),
                    y: .value("Systolic", 170))
                .annotation(position: .overlay, alignment: .leading) {
                    Text("High: Stage 2 Hypertension")
                        .foregroundColor(Color.black)
                }
                .foregroundStyle(Color.red)
                .opacity(0)
                .zIndex(3)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  120),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 180)
                )
                .foregroundStyle(Color.red)
                .zIndex(2)
                RectangleMark(
                    xStart: .value("Positive",  40),
                    xEnd: .value("Positive",  120.5),
                    yStart: .value("Negative", 40),
                    yEnd: .value("Negative", 180.5)
                )
                .foregroundStyle(Color.black)
                .zIndex(1)
            }
            .chartXAxis {
                AxisMarks(values: [40,60,80,90,100,120]) { _ in
                    AxisTick(stroke: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color.black)
                    AxisValueLabel()
                }
                
            }
            .chartYAxis {
                AxisMarks(values: [40,90,120,140,160,180]) { _ in

                    AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color.black)
                    AxisValueLabel()
                }
            }
            .chartXScale(domain: 40...120)
            .chartYScale(domain: 40...180)
        }
        .padding()
    }
}


#Preview {
    BloodPressureReadingChart(reading:
        BloodPressureReading(systolic: 120, diastolic: 80, atrialPressure: 0, pulseRate: 70, bloodPressureReadingProgress: .notStarted),
    ).frame(maxHeight: 300)
}
