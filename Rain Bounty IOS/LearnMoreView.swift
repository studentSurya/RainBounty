//
//  LearnMoreView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 3/2/25.
//

import SwiftUI


struct LearnMoreView: View {
    
    fileprivate func AddQnASection(question: String, answer: String, optionalImage: String? = nil ) -> some View {
        return Section(header: HStack {
            Image(systemName: "questionmark.circle")
            Text(question)
                .font(.headline)
            .foregroundColor(.black) }) {
                if (optionalImage != nil) {
                    // Image placeholder for the system diagram
                    Image(optionalImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures the image occupies majority of space below
                        .background(Color.white) // White background for the image section
                }
                
                Text(.init(answer))
                .font(.body)
                .foregroundColor(.black)
            } //Section
            .padding()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                                
                                AddQnASection(
                                    question: "What does a typical rain water harvesting system look like?",
                                    answer: """
                The main purpose of the water collected using a Rain water harvesting system would be for outdoor uses that do not require potable water. A simple residential harvesting system comprises of the following components. 
                
                • **Catchment surface** - the collection surface from which rainfall runs off like your roof.
                • **Gutters and downspouts** – to channel water from the roof to the tank.
                • **Screens, first-flush diverters, and roof washers** - components which remove debris and dust from the captured rainwater before it goes to the tank.
                • **Storage system** – to store the collected rain water.
                • **Delivery system** - gravity-fed or pumped to the end use like watering your lawn and plants.
                
                """,
                                    optionalImage: "rainwater-harvesting-system")

                                AddQnASection(
                                    question:"Is it illegal to harvest rainwater?",
                                    answer:"""
                In the majority of cases, the answer is no and is actively encouraged by state governments and individual counties with rebates on equipment setup and tax incentives. So, if you are thinking about a rainwater harvesting solution, it is always best to check with your local authorities to ensure your system complies with local codes/regulations as well as learn about the rebates and tax incentives.
                
                """)
                                
                                AddQnASection(
                                    question: "What are the benefits of Rainwater Collection?",
                                    answer: """
                **Protects the environment** 
                • Rainwater harvesting conserves water, one of the most precious natural resources.
                • By using the harvested water, you reduce the carbon footprint associated with manufacturing and transporting municipal water to your location instead.
                • It can also reduce the amount of stormwater runoff that can cause flooding and erosion.
                • Rainwater is great for watering lawns and gardens as it is free of chemicals and salts that are typical of any treated water. Additionally, rainwater has a balanced pH that is required by the plants.
                
                **Saves Money**
                • Rainwater harvesting can reduce the amount of water you need to buy from the municipality, which can lower your water bill.
                
                **Provides an alternative source of water**
                • Rainwater can be used for irrigation, washing driveways/vehicles, flushing toilets, etc.
                • If a municipality can't provide water, people with rainwater harvesting systems may have a reliable water source.
                
                """)
                                
                                AddQnASection(
                                    question:"How much rainwater can I collect?",
                                    answer:"""
                You need to know your average annual rainfall data for your area and approximate collection surface area, like your roof, using either the length and width of your house or square footage. 
                
                Don't fret! To simplify this calculation, you can use our **Rain Water Calculator!!**.
                """)
                } // VStack
                .padding()
                .background(Color.white.opacity(0.85))
            } //ScrollView
        }
    }
}
