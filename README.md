# Flutter Application - [Demo] (https://youtu.be/MthisxvBx5g)

## Installation

Make sure you have Flutter version 3.16.x installed. If not, you can install it by following the Flutter installation instructions at [Flutter Documentation](https://flutter.dev/docs/get-started/install).

After installing Flutter, run the following commands in your terminal:

```bash
flutter pub get
```

This will download the necessary libraries for the application.

## Running the Application

To start the application, use the following command:

```bash
flutter devices
flutter run -d macos # or other available devices such as windows and linux
```

This command will launch the application on macOS.

## Running Tests with Code Coverage

To run tests and generate code coverage, use the following command:

```bash
flutter test --coverage test
```

This will execute tests and generate coverage reports. You can view the coverage report by opening the generated `lcov` file.

## Third-Party Libraries

This application utilizes the following third-party libraries:

- [Riverpod](https://pub.dev/packages/riverpod) for state management and dependency injection
- [Dio](https://pub.dev/packages/dio) for HTTP client
- [Mocktail](https://pub.dev/packages/mocktail) for mock testing

## Architecture

The application follows the clean architecture with the following components:

### Client

- **Authentication Client:** Responsible for making HTTP calls to retrieve http response.
- **Daemon Client:** Interacts with the daemon process using sockets.

### Repository

- **Authentication Repository:** Retrieves authentication data for the application using the authentication client.
- **Daemon Repository:** Communicates with the daemon via the daemon client and returns the connection status of the daemon.

### Service

- **Connection Service:** Controls the lifecycle of the connection for authentication and daemon processes.

### Presenter

- **Connection Page:** Binds the connection status provided by the connection service with the UI Widget

