enum PermStatus { initial, requesting, granted, denied }

/// Defines the state of the local permissions request process, including the current status and any error messages.
class LocalPermsState {
  final PermStatus status;
  final String? errorMsg;

  const LocalPermsState({this.status = PermStatus.initial, this.errorMsg});

  LocalPermsState copyWith({PermStatus? status, String? errorMsg}) {
    return LocalPermsState(status: status ?? this.status, errorMsg: errorMsg);
  }
}
