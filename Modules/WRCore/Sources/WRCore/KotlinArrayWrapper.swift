import Foundation
import shared

public extension Array where Element: AnyObject {
    init(_ kotlinArray: KotlinArray<Element>) {
        self.init()
        let iterator = kotlinArray.iterator()
        while iterator.hasNext() {
            append(iterator.next() as! Element)
        }
    }
}
