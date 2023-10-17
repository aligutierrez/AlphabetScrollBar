import SwiftUI


public struct AlphabetScrollView<Element: Alphabetizable, Cell: View>: View {
  
  let collectionDisplayMode: CollectionDisplayMode // Display mode for the collection (List or Grid).
  let collection: [Element] // The collection of alphabetizable elements.
  let sectionHeaderFont: Font // Font for the section header (alphabet headers).
  let sectionHeaderForegroundColor: Color // Color for the section header (alphabet headers).
  let resultAnchor: UnitPoint // The anchor point for scrolling to the selected letter.
  let cell: (Element) -> Cell // The cell view for each element in the collection.
  
  // Initialization of AlphabetizedList.
  public init(collectionDisplayMode: CollectionDisplayMode,
       collection: [Element],
       sectionHeaderFont: Font,
       sectionHeaderForegroundColor: Color,
       resultAnchor: UnitPoint,
       @ViewBuilder cell: @escaping (Element) -> Cell) {
    self.collectionDisplayMode = collectionDisplayMode
    self.collection = collection
    self.sectionHeaderFont = sectionHeaderFont
    self.sectionHeaderForegroundColor = sectionHeaderForegroundColor
    self.cell = cell
    self.resultAnchor = resultAnchor
  }
  
  // Grouping the collection based on the first letter of each item.
  private var groupedCollection: [(String, [Element])] {
    let sortedItems = collection.sorted { $0.alphabetizableName < $1.alphabetizableName }
    let grouped = Dictionary(grouping: sortedItems) { String($0.alphabetizableName.prefix(1)) }
    
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  // Extracting the alphabet (section headers) from the grouped collection.
  private var alphabet: [String] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }

  // {
  //   var a: [String] = []
  //   for groupedCollection in groupedCollection {
  //     a.append(groupedCollection.0)
  //   }
  //   return a
  // }
  
  // State to store the selected letter from the section index.
  @State private var selectedLetter = ""
  
  // Main body of the view.
public var body: some View {
    ScrollViewReader { pageScroller in
        GeometryReader { geometry in
            ZStack {
                Group {
                    // Show the collection as a List.
                    if collectionDisplayMode == .asList {
                        asList
                    }
                    // Show the collection as a Grid.
                    else if collectionDisplayMode == .asGrid {
                        asGrid
                    }
                }
                
                VStack {
                    Spacer()
                    SectionIndexTitles(alphabet: alphabet, selectedLetter: $selectedLetter, pageScroller: pageScroller, anchor: resultAnchor)
                        .frame(maxWidth: 40,
                               maxHeight: .infinity,
                               alignment: .trailing)
                }
                .offset(x: geometry.size.width / 2 - 20, y: 0)
                
            }
        }
    }
}
  
  // View for displaying the collection as a List.
    @ViewBuilder
  private var asList: some View {
    List(groupedCollection, id: \.0) { section in
      HStack {
        Text(section.0)
        .id(section.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(sectionHeaderFont)
        .foregroundColor(sectionHeaderForegroundColor)
        
        Divider()
                .background(Color.clear)
                .frame(height: 2)
                .padding(.vertical)
      }
                
      ForEach(section.1) { element in
        cell(element)
      }
    }
    .listStyle(.plain)
  }
  
  // View for displaying the collection as a Grid.
  @ViewBuilder
  private var asGrid: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
      ForEach(groupedCollection, id: \.0) { section in
        Text(section.0)
          .id(section.0)
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(sectionHeaderFont)
          .foregroundColor(sectionHeaderForegroundColor)
        
        ForEach(section.1) { element in
          cell(element)
        }
      }
    }
  }
}
