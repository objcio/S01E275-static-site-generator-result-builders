//
//  File.swift
//  
//
//  Created by Chris Eidhof on 16.09.21.
//

import Foundation

protocol Rule {
    associatedtype Body: Rule
    @RuleBuilder var body: Body { get }
}

protocol BuiltinRule {
    func run(environment: EnvironmentValues) throws
}

extension BuiltinRule {
    var body: Never {
        fatalError()
    }
}

extension Never: Rule {
    var body: Never {
        fatalError()
    }
}

import Swim

struct Write: BuiltinRule, Rule {
    var contents: Node
    var to: String // relative path
    
    func run(environment: EnvironmentValues) throws {
        print(environment)
        var result = ""
        contents.write(to: &result)
        let dest = environment.outputDirectory.appendingPathComponent(to)
        let dir = dest.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try result.write(to: dest, atomically: false, encoding: .utf8)
    }
}

struct AnyBuiltinRule: BuiltinRule {
    let _run: (EnvironmentValues) throws -> ()
    init<R: Rule>(_ rule: R) {
        if let builtin = rule as? BuiltinRule {
            self._run = builtin.run
        } else {
            self._run = AnyBuiltinRule(rule.body).run
        }
    }
    
    func run(environment: EnvironmentValues) throws {
        try _run(environment)
    }
}

extension Rule {
    func execute(outputDirectory: URL) throws {
        let env = EnvironmentValues(outputDirectory: outputDirectory)
        try AnyBuiltinRule(self).run(environment: env)
    }
}
