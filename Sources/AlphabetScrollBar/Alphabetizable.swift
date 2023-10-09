import Foundation


// Protocol for items that can be sorted alphabetically.
public protocol Alphabetizable: Identifiable {
  var Id: String { get }
  var alphabetizableName: String { get }
}
