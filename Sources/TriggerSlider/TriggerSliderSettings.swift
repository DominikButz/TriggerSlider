//
//  File.swift
//  
//
//  Created by Dominik Butz on 7/11/2021.
//

import Foundation
import SwiftUI

public struct TriggerSliderSettings {

    /**
    Initializer
     - Parameter sliderViewHeight:  height of the slider. Default is 40
     - Parameter sliderViewWidth: width of the slider. Default is 40.
     - Parameter sliderViewHPadding: horizontal padding of the sliderView relative to the background edges. Default 0.
     - Parameter sliderViewVPadding: vertical padding of the sliderView relative to the background edges. Default 0.
     - Parameter slideDirection: slide direction of the slider (left or right). Default:  right.
    */
    public init(sliderViewHeight: CGFloat = 40, sliderViewWidth: CGFloat = 40, sliderViewHPadding: CGFloat = 0, sliderViewVPadding:CGFloat = 0, slideDirection: SlideDirection = .right) {
        self.sliderViewWidth = sliderViewWidth
        self.sliderViewHeight = sliderViewHeight
        self.sliderViewHPadding = sliderViewHPadding
        self.sliderViewVPadding = sliderViewVPadding
        self.slideDirection = slideDirection
    }

    var sliderViewHeight: CGFloat
    var sliderViewWidth: CGFloat
    var sliderViewHPadding: CGFloat
    var sliderViewVPadding: CGFloat
    var slideDirection: SlideDirection

}

public enum SlideDirection {
    case left, right
}
