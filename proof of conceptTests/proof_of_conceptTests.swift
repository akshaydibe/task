//
//  proof_of_conceptTests.swift
//  proof of conceptTests
//
//  Created by Amit Dhadse on 10/12/19.
//  Copyright © 2019 Akshay Dibe. All rights reserved.
//

import XCTest
@testable import proof_of_concept

class proof_of_conceptTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testViewModel(){
        
        let row = rows(title: "Beavers", description: "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony", imageHref: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg")
        let response = Response(title: "About Canada", rows: [row])
        
        XCTAssertEqual(response.title, "About Canada")
        XCTAssertTrue((response.rows != nil))
        
    }
    
    func testDecoding() throws {
        let jsonData = try Data(contentsOf: URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!)
        XCTAssertNoThrow(try JSONDecoder().decode(Response.self, from: Data(String(data: jsonData, encoding: .ascii)!.utf8)))
    }

}
