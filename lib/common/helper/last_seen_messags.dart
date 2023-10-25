String lastSeenMessags(lastseen) {
  DateTime now = DateTime.now();
  Duration differenceDuration =
      now.difference(DateTime.fromMillisecondsSinceEpoch(lastseen));
  String finelMessage = differenceDuration.inSeconds > 59
      ? differenceDuration.inMinutes > 59
          ? differenceDuration.inHours > 23
              ? "${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}"
              : "${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'Hour' : 'Hours'}"
          : "${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}"
      : 'few moments';
  return finelMessage;
}
