class ChannelModel {
  final String name;
  final String subtitle;
  final String emoji;
  final int badge;
  bool isFav;

  ChannelModel({
    required this.name,
    required this.subtitle,
    this.emoji = '📢',
    this.badge = 0,
    this.isFav = false,
  });
}