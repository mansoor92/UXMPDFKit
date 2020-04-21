//
//  ExampleViewController.swift
//  UXMPDFKit
//
//  Created by Chris Anderson on 5/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import UXMPDFKit

class ExampleViewController: UIViewController {
    
    @IBAction func loadPDF() {

		let bundle = Bundle.main
		UIFont.registerFont(withFilenameString: "nationalPro-Bold.ttf", bundle: bundle)
		UIFont.registerFont(withFilenameString: "nationalPro-Regular.ttf", bundle: bundle)

		let font = UIFont(name: "MyriadPro-Bold", size: 20)
        let url = Bundle.main.path(forResource: "sample2", ofType: "pdf")!
		UXMPDFDocument.font = font
        let document = try! UXMPDFDocument.from(filePath: url)
        
        let pdf = UXMPDFViewController(document: document!)
        pdf.annotationController.annotationTypes = [
            PDFHighlighterAnnotation.self,
            PDFPenAnnotation.self,
            UXMTextAnnotation.self,
            UXMSignAnnotation.self,
        ]
        
        self.navigationController?.pushViewController(pdf, animated: true)
    }
}


public extension UIFont {

	static func registerFont(withFilenameString filenameString: String, bundle: Bundle) {

		guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
			print("UIFont+:  Failed to register font - path for resource not found.")
			return
		}

		guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
			print("UIFont+:  Failed to register font - font data could not be loaded.")
			return
		}

		guard let dataProvider = CGDataProvider(data: fontData) else {
			print("UIFont+:  Failed to register font - data provider could not be loaded.")
			return
		}

		guard let font = CGFont(dataProvider) else {
			print("UIFont+:  Failed to register font - font could not be loaded.")
			return
		}

		var errorRef: Unmanaged<CFError>? = nil
		if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
			print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
		}
	}

}
