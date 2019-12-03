public struct ParseError<T>: Error {
    public let text: String

    public init<S: StringProtocol>(_ text: S) {
        self.text = String(text)
    }
}
