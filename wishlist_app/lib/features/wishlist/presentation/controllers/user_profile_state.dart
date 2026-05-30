
class UserProfileState {
  final int currentXp;
  final int currentLevel;
  final int virtualCoins;

  UserProfileState({
    required this.currentLevel,
    required this.currentXp,
    required this.virtualCoins,
  });

  UserProfileState copyWith({
    int? currentXp,
    int? currentLevel,
    int? virtualCoins,
  }) {
    return UserProfileState(
      currentLevel: currentLevel ?? this.currentLevel,
      currentXp: currentXp ?? this.currentXp,
      virtualCoins: virtualCoins ?? this.virtualCoins,
    );
  }
}
