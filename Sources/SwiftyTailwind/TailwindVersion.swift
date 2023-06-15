import Foundation

public enum TailwindVersion {
    /**
    It pulls the latest version.
     */
    case latest
    /**
    It pulls a fixed version.
     */
    case fixed(String)
}
