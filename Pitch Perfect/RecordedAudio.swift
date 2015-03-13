//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Matthias on 13/03/15.
//

import Foundation

class RecordedAudio: NSObject {

    let title: String
    let url: NSURL

    init(title: String, url: NSURL) {
        self.title = title
        self.url = url
    }
}