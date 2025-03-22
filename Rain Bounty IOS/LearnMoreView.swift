//
//  LearnMoreView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 3/2/25.
//

import SwiftUI


struct LearnMoreView: View {
    
    
    fileprivate func AddInfoSection(topicTitle: String, topicInfo: String, optionalImage: String? = nil ) -> some View {
        return Section(header: HStack {
            Image(systemName: "info.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .font(.title)
            
            Text(topicTitle)
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
                
                Text(.init(topicInfo))
                    .font(.callout)
                    .foregroundColor(.black)
        } //Section
        .padding(.top, 10)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                               
                    AddInfoSection(
                        topicTitle: "Rainwater Harvesting Basics",
                        topicInfo: """
                        Rainwater harvesting is an innovative alternative water supply approach anyone can use. Rainwater harvesting captures, diverts, and stores rainwater for later use.

                        Implementing rainwater harvesting is beneficial because it reduces demand on existing water supply, and reduces run-off, erosion, and contamination of surface water.

                        Rainwater can be used for nearly any purpose that requires water. These include landscape use, stormwater control, wildlife and livestock watering, in-home use, and fire protection.

                        A rainwater harvesting system can range in size and complexity. All systems have basics components, which include a catchment surface, conveyance system, storage, distribution, and treatment. 
                        
                        """)
                    
                    AddInfoSection(
                        topicTitle: "Rainwater Harvesting System Components",
                        topicInfo: """
    A typical domestic rainwater harvesting system comprises six basic components:
    1. **Catchment surface**: the collection surface from which rainfall runs off
    2. **Gutters and downspouts**: channel water from the roof to the tank
    3. **Leaf screens, first-flush diverters, and roof washers**: components which remove debris and dust from the captured rainwater before it goes to the storage tanks
    4. **Storage tanks**: One or more storage tanks, also called **cisterns**
    5. **Delivery system**: gravity-fed or pumped to the end use
    6. **Treatment/purification**: for potable systems, filters and other methods to make the water safe to drink
    
    """,
                        optionalImage: "info-rwh-typical-installation")
                    
                                AddInfoSection(
                                    topicTitle:"System Sizing",
                                    topicInfo:"""
                The basic rule for sizing any rainwater harvesting system is that the volume of water that can be captured and stored (the supply) must equal or exceed the volume of water used (the demand).
                
                However, if rainwater is to be used only for irrigation in a residential household, a rough estimate of demand, supply, and storage capacity may be sufficient. This is assuming that irrigation needs can be supplemented with municipal water.
                
                """)
                                

                                
                                AddInfoSection(
                                    topicTitle:"Collection Surface and Harvest Potential",
                                    topicInfo:"""
                The collection surface is the "footprint" of the roof. In other words, regardless of the pitch of the roof, the effective collection surface is the area covered by collection surface (Length **(L)** X Width **(W)** of the roof from eave to eave and front to rear). Obviously if only one side of the structure is guttered, only the area drained by the gutters should be considered for calculating rainwater harvest potential.
                
                Approximately **0.62 gallons** of rainwater can be harvested from **1 square foot** of collection surface for every inch of rainfall. In practice, however, some rainwater is lost to first flush, evaporation, splash-out or overshoot from the gutters in hard rains, and possibly leaks. 
                
                """,
                                    optionalImage: "info-rwh-roof-footprint")


                    AddInfoSection(
                        topicTitle:"More Resources",
                        topicInfo:"""
                        
                        • **Rainwater Harvesting System Planning**: [PDF](https://greywateraction.org/wp-content/uploads/2014/11/Rainwater-Harvesting-System-Practitioner-Manual.pdf)
                        
                        • **Rainwater Harvesting Training**: [PDF](https://greywateraction.org/wp-content/uploads/2014/11/rwh_training_draft_v3.pdf)
                        
                        • **USDA Conservation in Your Backyard**: [PDF](https://www.nrcs.usda.gov/sites/default/files/2022-09/Texas_Conservation_in_Your_Backyard_Rainwater_Harvesting.pdf)
                        
                        • **Rainwater Harvesting Tool Help Guide**: [PDF](https://www.energy.gov/sites/default/files/2023-12/rainwater-harvesting-tool-help-guide.pdf)
                        
                        • **The Texas Manual on Rainwater Harvesting**: [PDF](https://www.twdb.texas.gov/publications/brochures/conservation/doc/RainwaterHarvestingManual_3rdedition.pdf)
                        """)
                } // VStack
                .padding()
                .background(Color.white.opacity(0.85))
            } //ScrollView
        }
    }
}

#Preview {
    return LearnMoreView()
}
