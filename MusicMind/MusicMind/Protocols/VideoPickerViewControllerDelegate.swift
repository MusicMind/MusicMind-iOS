//
//  VideoPickerViewControllerDelegate.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/21/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

protocol VideoPickerViewControllerDelegate: class {
    func didFinishPickingVideoWith(url: URL)
}
