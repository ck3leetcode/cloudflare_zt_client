# Flutter Application

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

watch [Demo](https://youtu.be/MthisxvBx5g)

## Running Tests with Code Coverage

To run tests and generate code coverage, use the following command:

```bash
flutter test --coverage test
```

This will execute tests and generate coverage reports. You can view the coverage report by opening the generated `lcov` file or use third party [website](https://lcov-viewer.netlify.app) to view the report.

<img width="1300" alt="Screenshot 2023-12-28 at 11 47 35 AM" src="https://github.com/ck3leetcode/cloudflare_zt_client/assets/55478572/71f02fb7-f4de-4381-9873-1601d8688ca2">


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

