//
//  RainwaterHarvestInstallationView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 3/2/25.
//

import SwiftUI


struct FAQView: View {
    
    fileprivate func AddQnASection(question: String, answer: String, optionalImage: String? = nil ) -> some View {
        return Section(header: HStack {
            Image(systemName: "questionmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .font(.title)
            
            Text(question)
                .font(.headline)
            .foregroundColor(.black) })  {
                
                //Section body starts
                if (optionalImage != nil) {
                    // Image placeholder for the system diagram
                    Image(optionalImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures the image occupies majority of space below
                        .background(Color.white) // White background for the image section
                }
                
                Text(.init(answer))
                    .font(.callout)
                    .foregroundColor(.black)
        } //Section
        .padding(.top, 10)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                               
                    AddQnASection(
                        question: "What are the benefits of Rainwater Collection?",
                        answer: """
    **Protects the environment** 
    • It is **free!**
    • Rainwater is always **better for plants than treated tap water**, due to its nitrogen content
    • Rainwater harvesting conserves water, one of the most precious natural resources.
    • By using the harvested water, you reduce the carbon footprint associated with manufacturing and transporting municipal water to your location instead.
    • It can also reduce the amount of stormwater runoff that can cause flooding and erosion.
    • Rainwater is great for watering lawns and gardens as it is free of chemicals and salts that are typical of any treated water. Additionally, rainwater has a balanced pH that is required by the plants.
    
    **Saves Money**
    • Rainwater harvesting can reduce the amount of water you need to buy from the municipality, which can lower your water bill.
    • It’s tax-exempt!  Rainwater harvesting components are tax-exempt in many states.
    
    **Provides an alternative source of water**
    • Rainwater can be used for irrigation, washing driveways/vehicles, flushing toilets, etc.
    • If a municipality can't provide water, people with rainwater harvesting systems may have a reliable water source.
    • Harvested rainwater can be used during drought restrictions in many states, as it's not subject to water restrictions.
    
    """,
                        optionalImage: "rainwater-harvesting-benefits")
/*
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
 */

                                AddQnASection(
                                    question:"Is it illegal to harvest rainwater?",
                                    answer:"""
                In the majority of cases, the answer is no and is actively encouraged by state governments and individual counties with rebates on equipment setup and tax incentives. So, if you are thinking about a rainwater harvesting solution, it is always best to check with your local authorities to ensure your system complies with local codes/regulations as well as learn about the rebates and tax incentives.
                
                """)
                                
                    AddQnASection(
                        question: "I live in an area with low rainfall, is rainwater harvesting right for me?",
                        answer: """
Rainwater harvesting may be appropriate for many areas across the U.S. even in areas of low rainfall
availability. Important considerations when planning for harvesting projects should include the
following:
• Size of catchment area (roof size): Larger roof area can capture significant precipitation even in
areas of low rainfall availability.
• Rainwater storage capacity: Areas with lower available precipitation may require larger tanks to
provide more storage capacity, and increased tank size will increase equipment cost.
• Water rates: Areas with more expensive water rates should also be considered when prioritizing
locations for rainwater harvesting projects.
• Permits: Rainwater harvesting permits may be required; check with local or state government.
• Turf replacement (irrigation): Consider replacing traditional turf with native landscaping that
requires significantly less water and can make rainwater harvesting a viable option in many
areas of the U.S.
                        
""")

                                
                                AddQnASection(
                                    question:"How much rainwater can I collect?",
                                    answer:"""
                You need to know your average annual rainfall data for your area, storage tank capacity and approximate collection surface area, like your roof, using either the length and width of your house or square footage. 
                
                Don't fret! To simplify this calculation, you can use our **Historical Rain Harvest Charts!!** to evaluate the rainwater harvesting potential.
                
                """)
                    
                    
                    
                } // VStack
                .padding()
                .background(Color.white.opacity(0.85))
            } //ScrollView
        }
    }
    
    
}

#Preview {
    return FAQView()
}

