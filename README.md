# AllygatorShuttle

The app provide a solution users to be able to track the progress of their ride after they book it.

# Base tooling

- `TinyConstraints` for Auto Layout.
- `SwiftLint` a tool to enforce Swift style and conventions.
- `Starscream` is a conforming WebSocket library.
- `SwiftGen` is a tool to automatically generate Swift code for resources of your projects (like images, fonts, colors etc), to make them type-safe to use. 
- `lottie-ios` is a library that natively renders vector based animations and art in realtime with minimal code.


# Why Auto Layout Programmatically?

- No need to open different windows for storyboards, to understand what’s happening in a single module
- Everything is here, you can see very clearly what’s happening in the layout.
- Makes your compile-time stable, as the project grows.
- Easy to refactor.
- Easy to work in a team.
- Hard to review the code


# Why SwiftLint?

- Code review requires less time
- Compliance to the code style is verified objectively
- Project maintenance is easier
- The code is more readable by using unified code style


# Why SwiftGen?

- Avoid any risk of typo when using a String
- Free auto-completion
- Avoid the risk of using a non-existing asset name
- All this will be ensured by the compiler and thus avoid the risk of crashing at runtime.


# Usage

You can clone the repo or you can download as a ZIP file. You do not need to install pods, pods are already installed.
You just need to run the file with the .xworkspace extension


# Architecture

MVVM + R architecture was used in this project

## Models
The models won't store business logic. They will only act as data stores.

## Views
The `Views` (or `ViewControllers` in this case) only responsability will be displaying the data provided by its `ViewModel`, and forwarding all events to their respective `ViewModel`.

## ViewModel
The `ViewModel` is the component in charge of managing the state of each view, and any processing necesary of the data to be displayed.

## Router
The router is the component in charge of handling the navigation stack of your entire application. 

To keep things tidy and isolated, the router does not know how to instantiate the screens that it presents. This is defined separately using the `Route` protocol. A `Route` is a component that encapsulates all the necessary logic to instantiate a `view`, with it's corresponding `viewModel` and any other parameters forwarded from other routes.
Apart from the `Route`, you can set a `TransitionType` when you navigate to a route, this tells the navigator how the screen should be presenter (modally, pushed, resetting the stack, etc.).
