enum ConnectionStatusType {
  authenticated,
  connected,
  disconnected,
  error,
}

class ConnectionStatus {
  final ConnectionStatusType type;
  final String? errorMessage;
  ConnectionStatus({
    required this.type,
    this.errorMessage,
  });
}
