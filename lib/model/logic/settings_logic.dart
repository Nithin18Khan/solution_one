import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/view_model/platform_info.dart';

class SettingsLogic extends StateNotifier<SettingsState> {
  SettingsLogic() : super(SettingsState());

  final bool useBlurs = !PlatformInfo.isAndroid;

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void dismissSearchMessage() {
    state = state.copyWith(hasDismissedSearchMessage: true);
  }

  void toggleSearchPanel(bool isOpen) {
    state = state.copyWith(isSearchPanelOpen: isOpen);
  }

  void changeLocale(Locale locale) {
    state = state.copyWith(currentLocale: locale.languageCode);
  }
}

// State class for SettingsLogic
class SettingsState {
  final bool hasCompletedOnboarding;
  final bool hasDismissedSearchMessage;
  final bool isSearchPanelOpen;
  final String? currentLocale;
  final int? prevWonderIndex;

  const SettingsState({
    this.hasCompletedOnboarding = false,
    this.hasDismissedSearchMessage = false,
    this.isSearchPanelOpen = true,
    this.currentLocale,
    this.prevWonderIndex,
  });

  SettingsState copyWith({
    bool? hasCompletedOnboarding,
    bool? hasDismissedSearchMessage,
    bool? isSearchPanelOpen,
    String? currentLocale,
    int? prevWonderIndex,
  }) {
    return SettingsState(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasDismissedSearchMessage:
          hasDismissedSearchMessage ?? this.hasDismissedSearchMessage,
      isSearchPanelOpen: isSearchPanelOpen ?? this.isSearchPanelOpen,
      currentLocale: currentLocale ?? this.currentLocale,
      prevWonderIndex: prevWonderIndex ?? this.prevWonderIndex,
    );
  }
}

// Create a Riverpod provider
final settingsProvider =
    StateNotifierProvider<SettingsLogic, SettingsState>((ref) {
  return SettingsLogic();
});
