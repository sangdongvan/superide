//
//  Copyright (c) 2017. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Models
import NeedleFoundation
import RIBs
import RIBsExtension

public protocol RandomWinDependency: NeedleFoundation.Dependency {
    var mutableScoreStream: MutableScoreStream { get }
}

public final class RandomWinComponent: NeedleFoundation.Component<RandomWinDependency> {

    var player1Name: String
    var player2Name: String

    public init(parent: Scope, player1Name: String, player2Name: String) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(parent: parent)
    }

    var mutableScoreStream: MutableScoreStream {
        return dependency.mutableScoreStream
    }
}

// MARK: - Builder

protocol RandomWinBuildable: Buildable {
    func build(withListener listener: RandomWinListener) -> RandomWinRouting
}

public final class RandomWinBuilder: NeedleBuilder<RandomWinComponent>, RandomWinBuildable {

    public func build(withListener listener: RandomWinListener) -> RandomWinRouting {
        let component = componentBuilder()
        let viewController = RandomWinViewController(
            player1Name: component.player1Name,
            player2Name: component.player2Name)
        let interactor = RandomWinInteractor(
            presenter: viewController,
            mutableScoreStream: component.mutableScoreStream)
        interactor.listener = listener
        return RandomWinRouter(interactor: interactor, viewController: viewController)
    }
}