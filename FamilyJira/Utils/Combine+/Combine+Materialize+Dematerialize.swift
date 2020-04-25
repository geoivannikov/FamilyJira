//
//  Combine+Materialize+Dematerialize.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

// swiftlint:disable all

// MARK: - Event enum
public enum Event<Value, Failure: Error> {
    case value(Value)
    case completion(Subscribers.Completion<Failure>)
}

// MARK: - Operator methods
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    ///  Convert any Publisher into an Publisher of its Events.
    ///
    ///  - parameter forceRecieveCompletion: If Event.completion should be delivered
    ///                                      when subscriber asks for .none elements
    ///  - returns: A publisher of Events
    func materialize(forceRecieveCompletion: Bool = true)
        -> Publishers.Materialize<Self> {
            .init(upstream: self, forceRecieveCompletion: forceRecieveCompletion)
    }

    ///  Convert Publisher of Events into Publisher.
    ///
    ///  - returns: A publisher from events
    func dematerialize<Value, Failure: Error>()
        -> Publishers.Dematerialize<Self, Value, Failure> where Self.Output == Event<Value, Failure>, Self.Failure == Never {
            .init(upstream: self)
    }
}

// MARK: - Publisher
extension Publishers {
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct Materialize<Upstream: Publisher>: Publisher {
        public typealias Output = Event<Upstream.Output, Upstream.Failure>
        public typealias Failure = Never

        private let forceRecieveCompletion: Bool
        private let upstream: Upstream

        init(upstream: Upstream, forceRecieveCompletion: Bool) {
            self.upstream = upstream
            self.forceRecieveCompletion = forceRecieveCompletion
        }

        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            var sub: Subscription!

            if forceRecieveCompletion {
                let helper = DownStreamHelperForceReceive(subscriber: subscriber)
                sub = DownstreamSubscription(upstream: upstream, downStream: helper)
            } else {
                let helper = DownStreamHelperWaitReceive(subscriber: subscriber)
                sub = DownstreamSubscription(upstream: upstream, downStream: helper)
            }

            subscriber.receive(subscription: sub)
        }
    }

    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct Dematerialize<Upstream: Publisher, Value, Failure: Error>: Publisher where Upstream.Output == Event<Value, Failure>, Upstream.Failure == Never {
        public typealias Output = Value

        private let upstream: Upstream

        init(upstream: Upstream) {
            self.upstream = upstream
        }

        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let helper = DownStreamHelper<S>(subscriber: subscriber)

            let sub = DownstreamSubscription(upstream: upstream, downStream: helper)
            subscriber.receive(subscription: sub)
        }
    }
}

// MARK: - Subscription
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Materialize {
    private final class DownStreamHelperForceReceive<S: Subscriber>: DownStreamHelperProtocol where S.Input == Event<Upstream.Output, Upstream.Failure>, S.Failure == Never {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure

        private var subscriber: S?

        init(subscriber: S) {
            self.subscriber = subscriber
        }

        func request(_ demand: Subscribers.Demand) -> Subscribers.Demand {
            demand
        }

        func downstream(_ value: Input) -> Subscribers.Demand {
            self.subscriber?.receive(Event.value(value)) ?? .none
        }

        func downstream(_ completion: Subscribers.Completion<Failure>) {
            _ = self.subscriber?.receive(Event.completion(completion))
            self.subscriber?.receive(completion: .finished)
            self.subscriber = nil
        }

        func cancel() {
            subscriber = nil
        }
    }

    private final class DownStreamHelperWaitReceive<S: Subscriber>: DownStreamHelperProtocol where S.Input == Event<Upstream.Output, Upstream.Failure>, S.Failure == Never {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure

        private var subscriber: S?

        private var demand: Subscribers.Demand = .none
        private var completion: Subscribers.Completion<Upstream.Failure>?

        private var mutex = pthread_mutex_t()

        init(subscriber: S) {
            pthread_mutex_init(&mutex, nil)
            self.subscriber = subscriber
        }

        func request(_ demand: Subscribers.Demand) -> Subscribers.Demand {
            pthread_mutex_lock(&mutex)
            if let completion = self.completion {
                _ = self.subscriber?.receive(Event.completion(completion))
                self.subscriber?.receive(completion: .finished)
                self.subscriber = nil
                self.demand = .none
                pthread_mutex_unlock(&mutex)

                return .none
            }

            self.demand += demand
            pthread_mutex_unlock(&mutex)

            return demand
        }

        func downstream(_ value: Input) -> Subscribers.Demand {
            pthread_mutex_lock(&mutex)
            guard let subscriber = self.subscriber,
                self.demand > .none else {
                    pthread_mutex_unlock(&mutex)
                    return .none
            }

            let adjust = subscriber.receive(Event.value(value))
            self.demand = self.demand - 1 + adjust
            pthread_mutex_unlock(&mutex)

            return adjust
        }

        func downstream(_ completion: Subscribers.Completion<Failure>) {
            pthread_mutex_lock(&mutex)
            if self.demand > .none {
                _ = self.subscriber?.receive(Event.completion(completion))
                self.subscriber?.receive(completion: .finished)
                self.subscriber = nil
            } else {
                self.completion = completion
            }
            pthread_mutex_unlock(&mutex)
        }

        func cancel() {
            subscriber = nil
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Dematerialize {
    private final class DownStreamHelper<S: Subscriber>: DownStreamHelperProtocol where S.Input == Output, S.Failure == Failure {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure

        private var subscriber: S?

        init(subscriber: S) {
            self.subscriber = subscriber
        }

        func request(_ demand: Subscribers.Demand) -> Subscribers.Demand {
            demand
        }

        func downstream(_ event: Input) -> Subscribers.Demand {
            switch event {
            case let .value(inputValue):
                return self.subscriber?.receive(inputValue) ?? .none
            case let .completion(inputCompletetion):
                self.subscriber?.receive(completion: inputCompletetion)
                self.subscriber = nil
                return .none
            }
        }

        func downstream(_ completion: Subscribers.Completion<Failure>) {
            self.subscriber?.receive(completion: .finished)
            self.subscriber = nil
        }

        func cancel() {
            subscriber = nil
        }
    }
}
