//
//  ColorWheelView.swift
//  academ
//
//  Created by Phyo Thet Pai on 11/4/26.
//

import SwiftUI
struct ColorPoint: Identifiable {
    var id = UUID()
    var angleOffset: CGFloat = 0
    var distanceRatio: CGFloat = 1
    func position(origin: CGPoint) -> CGPoint {
        let dx = origin.x - 100
        let dy = origin.y - 100
        let originAngle = atan2(dy, dx)           // correct quadrant-aware angle
        let newAngle = originAngle + angleOffset
        let distance = sqrt(dx * dx + dy * dy) * distanceRatio
        return CGPoint(
            x: cos(newAngle) * distance + 100,
            y: sin(newAngle) * distance + 100
        )
    }
}
enum ThemeType: String, Hashable, CaseIterable{
    case Analagous, Complementary, Triadic, Monochromatic
}
struct NewTheme: Identifiable{
    var id = UUID()
    var mainColor: [Color]
    var secondColor: Color
    var lightMode: Bool
}
struct ColorWheelView: View {
    @State private var position = CGPoint(x: 100, y: 100)
    func clippedPosition(newPos: DragGesture.Value)-> CGPoint {
        let distance = pow(newPos.location.x-100,2) + pow(newPos.location.y-100,2)
        if distance < 100*100 {
            return CGPoint(x: newPos.location.x, y: newPos.location.y)
        }
        return position
    }
    func color(from position: CGPoint)->Color{
        let dx = position.x - 100
        let dy = position.y - 100
        
        // Hue from angle (atan2 gives -pi to pi, normalize to 0–1)
        var angle = atan2(dy, dx)
        if angle < 0 { angle += 2 * .pi }
        let hue = angle / (2 * .pi)
        
        // Saturation from distance (0 at center, 1 at edge)
        let distance = sqrt(dx * dx + dy * dy)
        let radius = 150.0
        let variation = distance / radius
        return Color(hue: hue, saturation: colorScheme == .light ? variation : 1.0, brightness: colorScheme == .dark ? variation : 1.0)
    }
    func position(from color: Color)->CGPoint{
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Hue → angle (reverse of angle / 2π)
        let angle = hue * 2 * .pi
        
        // Saturation → distance (reverse of distance / radius)
        let distance = (colorScheme == .light ? saturation : brightness) * 150
        
        return CGPoint(
            x: 100 + cos(angle) * distance,
            y: 100 + sin(angle) * distance
        )
    }
    @State private var points: [ColorPoint] = [ColorPoint(angleOffset: 0)]
    @State private var type: ThemeType = .Analagous
    @Environment(\.colorScheme) var colorScheme
    @State private var themeOffset = 0.5
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [
                                .red, .yellow, .green, .cyan,
                                .blue, .purple, .red
                            ],
                            center: .center
                        )
                    )
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [colorScheme == .light ? .white : .black, .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 150
                                )
                            )
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                    position = clippedPosition(newPos: value)
                                    
                                
                            })
                    )
//                Circle()
//                    .frame(width: 60, height: 60)
//                    .foregroundStyle(colorScheme == .light ? .white : .black)
                ForEach(points){point in
                    Circle()
                        .frame(width: point.angleOffset + point.distanceRatio == 1 ? 30 : 20, height: point.angleOffset + point.distanceRatio == 1 ? 30 : 20)
                        .foregroundStyle(color(from: point.position(origin: position)))
                        .overlay(
                            Circle()
                                .stroke(.primary, lineWidth: 2)
                                .frame(width: point.angleOffset + point.distanceRatio == 1 ? 30 : 20, height: point.angleOffset + point.distanceRatio == 1 ? 30 : 20)
                        )
                        .position(point.position(origin: position))
                }
                    
            }
            .frame(width: 200, height: 200)
            Stepper("Colors:", value: Binding(get: {
                points.count
            }, set: {newValue in
                if newValue > points.count {
                    var offset: CGFloat = 0
                    var ratio: CGFloat = 1
                    switch type {
                    case .Analagous:
                        offset = .pi / 3 * 2 * (Double(points.count) - 1.5)
                    case .Complementary:
                        if points.count == 1 {
                            offset = .pi
                        }else{
                            withAnimation{
                                points[points.count - 1].angleOffset = .pi * -5 / 6
                            }
                            offset = .pi * 5 / 6
                        }
                    case .Triadic:
                        offset = .pi * 2 / 3 * 2 * (Double(points.count) - 1.5)
                    case .Monochromatic:
                        ratio = 1 - 0.5 * Double(points.count)
                    }
                    points.append(ColorPoint(angleOffset: offset, distanceRatio: ratio))
                }else if newValue < points.count {
                    _ = points.popLast()
                    if type == .Triadic{
                        type = .Analagous
                    }else if type == .Complementary && points.count == 2{
                        withAnimation{
                            points[1].angleOffset = .pi
                        }
                    }
                }
                
            }), in: 1...3)
            if points.count > 1{
                Picker("Type", selection: $type) {
                    ForEach(ThemeType.allCases, id: \.hashValue) { type in
                        if (points.count == 3) || (type != .Triadic) {
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: type) { oldValue, newValue in
                    withAnimation{
                        switch newValue{
                        case .Analagous:
                            for i in points.indices{
                                if i != 0{
                                    points[i].angleOffset = .pi / 3 * 2 * (Double(i) - 1.5)
                                    points[i].distanceRatio = 1
                                }
                            }
                        case .Complementary:
                            for i in points.indices{
                                if i != 0{
                                    points[i].distanceRatio = 1
                                    if points.count == 2 {
                                        points[i].angleOffset = .pi
                                    }else{
                                        points[i].angleOffset = .pi * 5 / 3 * (Double(i) - 1.5)
                                    }
                                }
                            }
                        case .Triadic:
                            for i in points.indices{
                                if i != 0{
                                    points[i].angleOffset = .pi * 2 / 3 * 2 * (Double(i) - 1.5)
                                    points[i].distanceRatio = 1
                                }
                            }
                        case .Monochromatic:
                            for i in points.indices{
                                if i != 0{
                                    points[i].angleOffset = 0
                                    points[i].distanceRatio = 1 - 0.5 * Double(i)
                                }
                            }
                        }
                    }
                }
            }
//            HStack{
//                Text("Presets:")
//                Circle()
//                    .frame(width: 20, height: 20)
////                    .foregroundStyle(color(from: point.position(origin: position)))
//                    .overlay(
//                        Circle()
//                            .stroke(.primary, lineWidth: 2)
//                            .frame(width: 20, height: 20)
//                    )
//            }
            if points.count == 2 || type == .Monochromatic{
                HStack{
                    Text("Ratio:")
                    Slider(value: $themeOffset, in: 0...1)
                    Button("Reset"){
                        themeOffset = 0.5
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            if points.count == 3 && type != .Monochromatic {
                AngularGradient(
                    stops: points.enumerated().map { index, point in
                            .init(
                                color: color(from: point.position(origin: position)),
                                location: Double(index) / Double(points.count)
                            )
                    } + [
                        .init(
                            color: color(from: points[0].position(origin: position)), // match first
                            location: 1.0
                        )
                    ],
                    center: .trailing,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 360+180)
                )
                .scaleEffect(1.1)
                .ignoresSafeArea()
            }else{
                LinearGradient(stops: points.enumerated().map{i, p in
                        .init(color: color(from: p.position(origin: position)), location: themeOffset/Double(points.count-i-1))
                }, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ColorWheelView()
}
