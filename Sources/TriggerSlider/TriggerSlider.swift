//
//  SlideToUnlock.swift
//  Progressive
//
//  Created by Dominik Butz on 6/11/2021.
//  Copyright © 2021 Duoyun. All rights reserved.
//

import SwiftUI

public struct TriggerSlider<SliderView: View, BackgroundView: View, TextView: View>: View {
    
    var sliderView: SliderView
    var textView: TextView
    var backgroundView: BackgroundView
    
    public var didSlideToEnd: ()->Void
    
    var settings: TriggerSliderSettings

    @Binding var offsetX: CGFloat
    
    /**
    Initializer
     - Parameter sliderView:  The slider view
     - Parameter textView: Text view that is located between the slider view and the background. Does not have to be a Text, can be any other view.
     - Parameter backgroundView: The background view of the slider.
     - Parameter offsetX: The horizontal offset of the slider view.  Should be set to 0 as initial value.  Value changes as the slider is moved by the user's drag gesture.
     - Parameter didSlideToEnd: Closure is called when the slider is moved to the end position. In your code, determine what should happend in that case.
    */
    public init(@ViewBuilder sliderView: ()->SliderView, textView: ()->TextView, backgroundView: ()->BackgroundView, offsetX: Binding<CGFloat>, didSlideToEnd: @escaping ()->Void, settings: TriggerSliderSettings = TriggerSliderSettings()) {
        self.sliderView = sliderView()
        self.backgroundView = backgroundView()
        self.textView = textView()
        self._offsetX = offsetX
        self.didSlideToEnd = didSlideToEnd
        self.settings = settings
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                backgroundView
                    .frame(height: settings.sliderViewHeight + settings.sliderViewVPadding)
                
                textView
                    .opacity(self.textLabelOpacity(totalWidth: proxy.size.width))
                
                HStack {
                    
                    if settings.slideDirection == .left {
                        Spacer()
                    }
                    
                    self.sliderView
                        .frame(width: settings.sliderViewWidth, height: settings.sliderViewHeight)
                        .padding(.horizontal, settings.sliderViewHPadding)
                        .padding(.vertical, settings.sliderViewVPadding)
                        .offset(x: self.offsetX, y: 0)
                        .gesture(DragGesture(coordinateSpace: .local).onChanged({ value in
                            
                            self.dragOnChanged(value: value, totalWidth: proxy.size.width)
                            
                    }).onEnded({ value in
                        self.dragOnEnded(value: value, totalWidth: proxy.size.width)
               
                    }))
                    
                    if settings.slideDirection == .right {
                        Spacer()
                    }
                }
  
            }
        }
    }
    
    func dragOnChanged(value: DragGesture.Value, totalWidth: CGFloat) {
        
        let rightSlidingChangeCondition = settings.slideDirection == .right && value.translation.width > 0 && offsetX <= totalWidth  - settings.sliderViewWidth - settings.sliderViewHPadding * 2
        let leftSlidingChangeCondition = settings.slideDirection == .left && value.translation.width < 0 && offsetX >= -totalWidth  + settings.sliderViewWidth + settings.sliderViewHPadding * 2
        
        if rightSlidingChangeCondition || leftSlidingChangeCondition  {
                self.offsetX = value.translation.width
        } 
    }
    
    func dragOnEnded(value: DragGesture.Value, totalWidth: CGFloat) {
        
        let resetConditionSlideRight = self.settings.slideDirection == .right && self.offsetX < totalWidth - settings.sliderViewWidth - settings.sliderViewHPadding * 2
        
        let resetConditionSlideLeft = self.settings.slideDirection == .left && self.offsetX > -(totalWidth - settings.sliderViewWidth - settings.sliderViewHPadding * 2)
        
        if resetConditionSlideRight || resetConditionSlideLeft {
            withAnimation {
                self.offsetX = 0
            }
        } else {
            self.didSlideToEnd()
        }
    }
    
    func textLabelOpacity(totalWidth: CGFloat)->CGFloat {
        let halfTotalWidth =  totalWidth / 2
        return (halfTotalWidth - abs(self.offsetX)) / halfTotalWidth
    }
}

struct TriggerSlider_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(0) {
            TriggerSlider(sliderView: {
                RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.orange)
                    .overlay(Image(systemName: "arrow.right").font(.system(size: 30)).foregroundColor(.white))
            }, textView: {
                Text("Slide to Unlock").foregroundColor(Color.orange)
            },
            backgroundView: {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.orange.opacity(0.5))
            }, offsetX: $0,
              didSlideToEnd: {
                print("trigger!")
            }, settings: TriggerSliderSettings(sliderViewVPadding: 5, slideDirection: .right)).padding(10).padding(.horizontal, 20)
        }
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
