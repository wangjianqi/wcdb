/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import WCDBSwift
// 枚举
enum SampleORMType: Int, ColumnCodable {
    case type1 = 1
    case type2 = 2
    // ColumnCodableBase协议
    static var columnType: ColumnType {
        return .integer64
    }
    // ColumnDecodable协议
    init?(with value: FundamentalValue) {
        guard let object = SampleORMType(rawValue: Int(truncatingIfNeeded: value.int64Value)) else {
            return nil
        }
        self = object
    }
    // ColumnEncodable协议
    func archivedValue() -> FundamentalValue {
        return FundamentalValue(Int64(self.rawValue))
    }
}

// TableCodable: TableEncodable & TableDecodable
class SampleORM: TableCodable {
    var identifier: Int = 0
    var desc: String = "nil"
    var value: Double = 0
    var timestamp: String?
    var type: SampleORMType?

    // CodingKeys
    enum CodingKeys: String, CodingTableKey {
        // 关联类型
        typealias Root = SampleORM
        // CodingTableKey的
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case identifier
        case desc
        case value
        case timestamp
        case type

        // CodingTableKey的
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                // 主键
                .identifier: ColumnConstraintBinding(isPrimary: true),
                // 默认值
                .value: ColumnConstraintBinding(defaultTo: 1.0),
                // 时间戳，当前时间
                .timestamp: ColumnConstraintBinding(defaultTo: .currentTimestamp)
            ]
        }
    }
}
