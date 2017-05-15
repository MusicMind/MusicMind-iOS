//
//  UIApplication+isRunningOnSimulator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/11/17.
//  https://gist.github.com/wvdk/e3dd57620c53f338978e6d5d022d3672
//  Thanks to http://stackoverflow.com/a/30284266/6407050
//
import Foundation

extension UIApplication {
    
    static var isRunningOnSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
