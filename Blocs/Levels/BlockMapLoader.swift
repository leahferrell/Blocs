//
//  BlockMapLoader.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/11/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation

func blockCodesFromFileNamed(fileName: String) -> [String]? {
    // file must be in bundle
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)
    if path == nil {
        return nil
    }
    
    var error: NSError?
    let fileContents = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: &error)
    
    // if there was an error, there is nothing to be done.
    // Should never happen in properly configured system.
    if error != nil && fileContents == nil {
        return nil
    }
    
    // get the contents of the file, separated into lines
    let lines = Array<String>(fileContents!.componentsSeparatedByString("\n"))
    
    // first line contains the atlas name for this layer's tiles
    //let atlasName = lines[0]
    
    // second line contains tile size, in form width x height
    //let tileSizeComps = lines[1].componentsSeparatedByString("x")
    
    //var width = tileSizeComps[0].toInt()
    
    //var height = tileSizeComps[tileSizeComps.endIndex-1].toInt()

    return lines
}