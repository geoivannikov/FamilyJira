//
//  Combine+BaseAbstractions.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

// Base Abstraction Classes
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
protocol DownStreamHelperProtocol {
    /// Helper for handling backpressure
    /// DownstreamSubscription class use it as delegate for backpressure handling
    
    associatedtype Input
    associatedtype Failure: Error
    
    func request(_ demand: Subscribers.Demand) -> Subscribers.Demand
    func downstream(_ value: Input) -> Subscribers.Demand
    func downstream(_ completion: Subscribers.Completion<Failure>)
    func cancel()
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class DownstreamSubscription<Upstream: Publisher, Helper: DownStreamHelperProtocol>: Subscription, Subscriber where Upstream.Output == Helper.Input, Upstream.Failure == Helper.Failure {
    /// Serves as upstream subscriber and keeps it subscription.
    /// Also is a subscription for main operator publisher
    /// Delegates everything to helper for correct handling
    
    public typealias Failure = Upstream.Failure
    public typealias Input = Upstream.Output
    
    private let upstream: Upstream
    private let downStream: Helper
    private var upstreamSubscription: Subscription?
    private var mutex = pthread_mutex_t()
    
    init(upstream: Upstream, downStream: Helper) {
        pthread_mutex_init(&mutex, nil)
        self.upstream = upstream
        self.downStream = downStream
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard demand > .none else { return }
        
        if let upstreamSubscription = self.upstreamSubscription {
            let demandModified = downStream.request(demand)
            if demandModified > .none {
                upstreamSubscription.request(demandModified)
            }
        } else {
            // https://en.wikipedia.org/wiki/Double-checked_locking
            pthread_mutex_lock(&mutex)
            if upstreamSubscription == nil {
                upstream.subscribe(self) // this should call receive(subscription: Subscription)
                //upstreamSubscription should be not nil starting from here
            }
            pthread_mutex_unlock(&mutex)
            
            let demandModified = downStream.request(demand)
            if demandModified > .none {
                upstreamSubscription?.request(demandModified)
            }
        }
    }
    
    func cancel() {
        downStream.cancel()
        upstreamSubscription?.cancel()
        upstreamSubscription = nil
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        return self.downStream.downstream(input)
    }
    
    func receive(subscription: Subscription) {
        self.upstreamSubscription = subscription
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        self.downStream.downstream(completion)
    }
}
