import '../models/player.dart';

// Liste des joueurs fictifs pour différents jeux
final List<Player> dummyPlayers = [
  Player(
    name: 'Player1',
    device: 'Controller', 
    game: 'Call of Duty', 
    sensitivityMouse: null, 
    sensitivityControllerHorizontal: 10, 
    sensitivityControllerVertical: 10
  ),
  Player(
    name: 'Player2',
    device: 'Mouse', 
    game: 'Call of Duty', 
    sensitivityMouse: 2.5, 
    sensitivityControllerHorizontal: null, 
    sensitivityControllerVertical: null
  ),
  Player(
    name: 'Player3',
    device: 'Mouse', 
    game: 'Apex Legends', 
    sensitivityMouse: 1.8, 
    sensitivityControllerHorizontal: null, 
    sensitivityControllerVertical: null
  ),
  Player(
    name: 'Player4',
    device: 'Controller', 
    game: 'Apex Legends', 
    sensitivityMouse: null, 
    sensitivityControllerHorizontal: 12, 
    sensitivityControllerVertical: 8
  ),
  Player(
    name: 'Player5',
    device: 'Mouse', 
    game: 'Valorant', 
    sensitivityMouse: 1.0, 
    sensitivityControllerHorizontal: null, 
    sensitivityControllerVertical: null
  ),
  Player(
    name: 'Player6',
    device: 'Controller', 
    game: 'Valorant', 
    sensitivityMouse: null, 
    sensitivityControllerHorizontal: 8, 
    sensitivityControllerVertical: 8
  ),
];

