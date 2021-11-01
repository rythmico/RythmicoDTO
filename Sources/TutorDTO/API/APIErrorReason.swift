import Foundation

public enum APIErrorReason: String, CoreDTO.APIErrorReasonProtocol {
    case clientOutdated = "APP_OUTDATED" // TODO: update to "CLIENT_OUTDATED" after backend migration.
    case unauthorized = "UNAUTHORIZED"
    case tutorNotVerified = "TUTOR_NOT_VERIFIED"
}
