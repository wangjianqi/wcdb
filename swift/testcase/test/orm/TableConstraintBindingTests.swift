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

import XCTest
import WCDBSwift

class TableConstraintBindingTests: BaseTestCase {

    class BaselineMultiPrimaryTestObject: TableCodable, Named {
        let variable1: Int = 0
        let variable2: Int = 0
        required init() {}
        static let constraintName = BaselineMultiPrimaryTestObject.name + "Constraint"
        enum CodingKeys: String, CodingTableKey {
            typealias Root = BaselineMultiPrimaryTestObject
            case variable1
            case variable2
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
                return [constraintName: MultiPrimaryBinding(indexesBy: variable1, variable2)]
            }
        }
    }

    class MultiPrimaryConflictTestObject: TableCodable, Named {
        let variable1: Int = 0
        let variable2: Int = 0
        required init() {}
        static let constraintName = MultiPrimaryConflictTestObject.name + "Constraint"
        enum CodingKeys: String, CodingTableKey {
            typealias Root = MultiPrimaryConflictTestObject
            case variable1
            case variable2
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
                return [constraintName: MultiPrimaryBinding(indexesBy: variable1, variable2, onConflict: .replace)]
            }
        }
    }

    func testMultiPrimaryBinding() {
        ORMColumnConstraintBindingAssertEqual(
            BaselineMultiPrimaryTestObject.self,
            """
            CREATE TABLE IF NOT EXISTS BaselineMultiPrimaryTestObject\
            (variable1 INTEGER, variable2 INTEGER, \
            CONSTRAINT BaselineMultiPrimaryTestObjectConstraint PRIMARY KEY(variable1, variable2))
            """
        )

        ORMColumnConstraintBindingAssertEqual(
            MultiPrimaryConflictTestObject.self,
            """
            CREATE TABLE IF NOT EXISTS MultiPrimaryConflictTestObject\
            (variable1 INTEGER, variable2 INTEGER, \
            CONSTRAINT MultiPrimaryConflictTestObjectConstraint \
            PRIMARY KEY(variable1, variable2) ON CONFLICT REPLACE)
            """
        )
    }

    class BaselineMultiUniqueTestObject: TableCodable, Named {
        let variable1: Int = 0
        let variable2: Int = 0
        required init() {}
        static let constraintName = BaselineMultiUniqueTestObject.name + "Constraint"
        enum CodingKeys: String, CodingTableKey {
            typealias Root = BaselineMultiUniqueTestObject
            case variable1
            case variable2
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
                return [constraintName: MultiUniqueBinding(indexesBy: variable1, variable2)]
            }
        }
    }

    class MultiUniqueConflictTestObject: TableCodable, Named {
        let variable1: Int = 0
        let variable2: Int = 0
        required init() {}
        static let constraintName = MultiUniqueConflictTestObject.name + "Constraint"
        enum CodingKeys: String, CodingTableKey {
            typealias Root = MultiUniqueConflictTestObject
            case variable1
            case variable2
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
                return [constraintName: MultiUniqueBinding(indexesBy: variable1, variable2,
                                                           onConflict: .replace)]
            }
        }
    }
    func testMultiUniqueBinding() {
        ORMColumnConstraintBindingAssertEqual(
            BaselineMultiUniqueTestObject.self,
            """
            CREATE TABLE IF NOT EXISTS BaselineMultiUniqueTestObject\
            (variable1 INTEGER, \
            variable2 INTEGER, \
            CONSTRAINT BaselineMultiUniqueTestObjectConstraint \
            UNIQUE(variable1, variable2))
            """
        )

        ORMColumnConstraintBindingAssertEqual(
            MultiUniqueConflictTestObject.self,
            """
            CREATE TABLE IF NOT EXISTS MultiUniqueConflictTestObject\
            (variable1 INTEGER, variable2 INTEGER, \
            CONSTRAINT MultiUniqueConflictTestObjectConstraint \
            UNIQUE(variable1, variable2) ON CONFLICT REPLACE)
            """
        )
    }
}
