import javax.swing.JFrame;

public class App {
  public static void main(String[] args) throws Exception {
    JFrame frame = new JFrame("PacMan");
    frame.setSize(Consts.boardWidth, Consts.boardHeight + 100);
    frame.setLocationRelativeTo(null);
    frame.setResizable(false);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    // PacMan pacmanGame = new PacMan();
    // frame.add(pacmanGame);
    // frame.pack();
    // pacmanGame.requestFocus();
    frame.setVisible(true);
  }
}
