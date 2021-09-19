import XCTJSONKit

final class XCTAssertJSONTests: XCTestCase {
    func testXCTAssertJSONCoding() throws {
        struct Empty: Codable, Equatable {}
        XCTAssertJSONCoding(Empty())

        enum GoodSingleValue: String, Codable, CaseIterable, Equatable {
            case one, two, three
        }
        XCTAssertJSONCoding(GoodSingleValue.one)

        enum BadSingleValue: String, Codable, CaseIterable, Equatable {
            case one, two, three

            init(from decoder: Decoder) throws {
                self = .two
            }
        }
        XCTExpectFailure(strict: true)
        XCTAssertJSONCoding(BadSingleValue.one)

        struct GoodMultipleValue: Codable, Equatable {
            var string: String
            var int: Int
        }
        XCTAssertJSONCoding(GoodMultipleValue(string: "a", int: 3))

        struct BadMultipleValue: Codable, Equatable {
            var string: String
            var int: Int

            private enum CodingKeys: String, CodingKey { case string, int }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(string, forKey: .int)
                try container.encode(int, forKey: .string)
            }
        }
        XCTExpectFailure(strict: true)
        XCTAssertJSONCoding(BadMultipleValue(string: "a", int: 3))
    }

    func testXCTAssertJSONCoding_enum() throws {
        enum GoodEnum: String, Codable, CaseIterable {
            case one, two, three
        }
        XCTAssertJSONCoding(GoodEnum.self)

        enum BadEnum: String, Codable, CaseIterable {
            case one, two, three

            init(from decoder: Decoder) throws {
                self = .two
            }
        }
        XCTExpectFailure(strict: true)
        XCTAssertJSONCoding(BadEnum.self)
    }

    func testXCTAssertJSONEncoding() throws {
        struct Empty: Encodable {}
        try XCTAssertJSONEncoding(Empty(), JSON(raw: #"{}"#))
        XCTExpectFailure(strict: true)
        try XCTAssertJSONEncoding(Empty(), JSON(raw: #"[]"#))

        enum SingleValue: String, Encodable, CaseIterable {
            case one, two, three
        }
        try XCTAssertJSONEncoding(SingleValue.one, JSON("one"))
        try XCTAssertJSONEncoding(SingleValue.allCases, JSON(["one", "two", "three"]))
        XCTExpectFailure(strict: true)
        try XCTAssertJSONEncoding(SingleValue.two, JSON("one"))
        XCTExpectFailure(strict: true)
        try XCTAssertJSONEncoding(SingleValue.allCases.reversed(), JSON(["one", "two", "three"]))

        struct MultipleValue: Encodable {
            var string: String
            var int: Int
        }
        try XCTAssertJSONEncoding(
            MultipleValue(string: "a", int: 3),
            JSON(["string": "a", "int": 3] as [String: AnyHashable])
        )
        XCTExpectFailure(strict: true)
        try XCTAssertJSONEncoding(
            MultipleValue(string: "b", int: 4),
            JSON(["string": "a", "int": 3] as [String: AnyHashable])
        )
    }

    func testXCTAssertJSONDecoding() throws {
        struct Empty: Decodable, Equatable {}
        try XCTAssertJSONDecoding(JSON(raw: #"{}"#), Empty())

        enum SingleValue: String, Decodable, CaseIterable, Equatable {
            case one, two, three
        }
        try XCTAssertJSONDecoding(JSON("one"), SingleValue.one)
        try XCTAssertJSONDecoding(JSON(["one", "two", "three"]), SingleValue.allCases)
        XCTExpectFailure(strict: true)
        try XCTAssertJSONDecoding(JSON("two"), SingleValue.one)
        XCTExpectFailure(strict: true)
        try XCTAssertJSONDecoding(JSON(["two", "one", "three"]), SingleValue.allCases)

        struct MultipleValue: Decodable, Equatable {
            var string: String
            var int: Int
        }
        try XCTAssertJSONDecoding(
            JSON(["string": "a", "int": 3] as [String: AnyHashable]),
            MultipleValue(string: "a", int: 3)
        )
        XCTExpectFailure(strict: true)
        try XCTAssertJSONDecoding(
            JSON(["string": "a", "int": 3] as [String: AnyHashable]),
            MultipleValue(string: "b", int: 4)
        )
    }
}

