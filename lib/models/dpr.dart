class Dpr {
  final String id;
  final String projectId;
  final DateTime date;
  final String weather; // Sunny, Cloudy, Rainy, Windy
  final String workDescription;
  final int workerCount;
  final List<String> imagePaths; // local paths from image_picker

  Dpr({
    required this.id,
    required this.projectId,
    required this.date,
    required this.weather,
    required this.workDescription,
    required this.workerCount,
    required this.imagePaths,
  });
}
