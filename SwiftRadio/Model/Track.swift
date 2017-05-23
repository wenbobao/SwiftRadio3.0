//
//  Track.swift
//  SwiftRadio
//
//  Created by bob on 16/12/21.
//  Copyright © 2016年 wenbobao. All rights reserved.
//

import UIKit

struct Track {
    var title: String = ""
    var artist: String = ""
    var artworkURL: String = ""
    var artworkImage = UIImage(named: "albumArt")
    var artworkLoaded = false
    var isPlaying: Bool = false
}
