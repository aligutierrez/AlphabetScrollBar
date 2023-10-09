import Foundation


// Protocol for items that can be sorted alphabetically.
public protocol Alphabetizable: Identifiable {
  var  alphabetizableId: String { get }
  var alphabetizableName: String { get }
}
