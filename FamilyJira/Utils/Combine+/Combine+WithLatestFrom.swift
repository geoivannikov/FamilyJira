//
//  Combine+WithLatestFrom.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

// MARK: - Operator methods
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    ///  Merges two publishers into a single publisher by combining each value
    ///  from self with the latest value from the second publisher, if any.
    ///
    ///  - parameter other: Second observable source.
    ///  - parameter resultSelector: Function to invoke for each value from the self combined
    ///                              with the latest value from the second source, if any.
    ///
    ///  - returns: A publisher containing the result of combining each value of the self
    ///             with the latest value from the second publisher, if any, using the
    ///             specified result selector function.
    func withLatestFrom<Other: Publisher, Result>(_ other: Other,
                                                  resultSelector: @escaping (Output, Other.Output) -> Result)
        -> Publishers.WithLatestFrom<Self, Other, Result> {
            return .init(upstream: self, other: other, resultSelector: resultSelector)
    }
    
    ///  Upon an emission from self, emit the latest value from the
    ///  second publisher, if any exists.
    ///
    ///  - parameter other: Second observable source.
    ///
    ///  - returns: A publisher containing the latest value from the second publisher, if any.
    func withLatestFrom<Other: Publisher>(_ other: Other)
        -> Publishers.WithLatestFrom<Self, Other, Other.Output> {
            return .init(upstream: self, other: other) { $1 }
    }
}

// MARK: - Publisher
extension Publishers {
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct WithLatestFrom<Upstream: Publisher,
        Other: Publisher,
    Output>: Publisher where Upstream.Failure == Other.Failure {
        public typealias Failure = Upstream.Failure
        public typealias ResultSelector = (Upstream.Output, Other.Output) -> Output
        
        private let upstream: Upstream
        private let other: Other
        private let resultSelector: ResultSelector
        private var latestValue: Other.Output?
        
        init(upstream: Upstream,
             other: Other,
             resultSelector: @escaping ResultSelector) {
            self.upstream = upstream
            self.other = other
            self.resultSelector = resultSelector
        }
        
        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let helper = DownStreamHelper(subscriber: subscriber,
                                          other: other,
                                          resultSelector: resultSelector)
            
            let sub = DownstreamSubscription(upstream: upstream, downStream: helper)
            subscriber.receive(subscription: sub)
        }
    }
}

// MARK: - Subscription
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.WithLatestFrom {
    private final class DownStreamHelper<S: Subscriber>: DownStreamHelperProtocol where S.Input == Output, S.Failure == Upstream.Failure {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure
        
        private var subscriber: S?
        private var resultSelector: ResultSelector?
        private var latestValue: Other.Output?
        private var otherCancelable: Cancellable?
        
        init(subscriber: S,
             other: Other,
             resultSelector: @escaping ResultSelector) {
            self.subscriber = subscriber
            self.resultSelector = resultSelector
            self.otherCancelable = other
                .sink(receiveCompletion: {_ in },
                      receiveValue: { [weak self] value in
                        self?.latestValue = value
                })
        }
        
        func request(_ demand: Subscribers.Demand) -> Subscribers.Demand {
            return demand
        }
        
        func downstream(_ value: Input) -> Subscribers.Demand {
            guard let resultSelector = self.resultSelector,
                let subscriber = self.subscriber else { return .none }
            guard let latest = self.latestValue else { return .max(1) }
            
            return subscriber.receive(resultSelector(value, latest))
        }
        
        func downstream(_ completion: Subscribers.Completion<Failure>) {
            self.subscriber?.receive(completion: completion)
            self.subscriber = nil
        }
        
        func cancel() {
            subscriber = nil
            resultSelector = nil
            latestValue = nil
            otherCancelable?.cancel()
            otherCancelable = nil
        }
    }
}
