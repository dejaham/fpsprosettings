class Player {
  final String name;
  final String device; // "Mouse" ou "Controller"
  final String game;
  final double? sensitivityMouse; // Sensibilité de la souris
  final double?
      sensitivityControllerHorizontal; // Sensibilité manette horizontale
  final double? sensitivityControllerVertical; // Sensibilité manette verticale
  final int? dpi; // DPI de la souris

  Player({
    required this.name,
    required this.device,
    required this.game,
    this.sensitivityMouse,
    this.sensitivityControllerHorizontal,
    this.sensitivityControllerVertical,
    this.dpi,
  });
}
