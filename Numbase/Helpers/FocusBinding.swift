import struct SwiftUI.FocusState

typealias FocusBinding<Value> = FocusState<Value>.Binding where Value: Hashable
