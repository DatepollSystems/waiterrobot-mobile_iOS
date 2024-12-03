import shared

public extension KermitLogger {
    func d(message: @escaping () -> String) {
        d(throwable: nil, tag: tag, message: message)
    }

    func w(message: @escaping () -> String) {
        w(throwable: nil, tag: tag, message: message)
    }

    func e(message: @escaping () -> String) {
        e(throwable: nil, tag: tag, message: message)
    }
}
