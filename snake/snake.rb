class Snake
  DEFAULT_LENGTH = 5
  
  attr_reader :head, :tail, :hex_color, :id, :direction, :outbound


  private final WsOutbound outbound;

  private Direction direction;
  private int length = DEFAULT_LENGTH;
  private Location head;
  private final Deque<Location> tail = new ArrayDeque<>();
  private final String hexColor;
  
  def initialize(id, outbound)
    self.id = id
    self.outbound = outbound
    self.hex_color = SnakeWebSocketServlet.getRandomHexColor()
    length = DEFAULT_LENGTH
    reset_state
  end

  def reset_state
    direction = :none
    head = SnakeWebSocketServlet.getRandomLocation(); ?????
    tail.clear
    length = DEFAULT_LENGTH
  end

  def kill
    reset_state
    outbound << {:type => 'dead'}.as_json
  end
  
  def reward
    length++
    outbound << {:type => 'kill'}.as_json
  end


  public synchronized void update(Collection<Snake> snakes) {
      Location nextLocation = head.getAdjacentLocation(direction);
      if (nextLocation.x >= SnakeWebSocketServlet.PLAYFIELD_WIDTH) {
          nextLocation.x = 0;
      }
      if (nextLocation.y >= SnakeWebSocketServlet.PLAYFIELD_HEIGHT) {
          nextLocation.y = 0;
      }
      if (nextLocation.x < 0) {
          nextLocation.x = SnakeWebSocketServlet.PLAYFIELD_WIDTH;
      }
      if (nextLocation.y < 0) {
          nextLocation.y = SnakeWebSocketServlet.PLAYFIELD_HEIGHT;
      }
      if (direction != Direction.NONE) {
          tail.addFirst(head);
          if (tail.size() > length) {
              tail.removeLast();
          }
          head = nextLocation;
      }

      handleCollisions(snakes);
  }

  private void handleCollisions(Collection<Snake> snakes) {
      for (Snake snake : snakes) {
          boolean headCollision = id != snake.id && snake.getHead().equals(head);
          boolean tailCollision = snake.getTail().contains(head);
          if (headCollision || tailCollision) {
              kill();
              if (id != snake.id) {
                  snake.reward();
              }
          }
      }
  }

  public synchronized Location getHead() {
      return head;
  }

  public synchronized Collection<Location> getTail() {
      return tail;
  }

  public synchronized void setDirection(Direction direction) {
      this.direction = direction;
  }

  public synchronized String getLocationsJson() {
      StringBuilder sb = new StringBuilder();
      sb.append(String.format("{x: %d, y: %d}",
              Integer.valueOf(head.x), Integer.valueOf(head.y)));
      for (Location location : tail) {
          sb.append(',');
          sb.append(String.format("{x: %d, y: %d}",
                  Integer.valueOf(location.x), Integer.valueOf(location.y)));
      }
      return String.format("{'id':%d,'body':[%s]}",
              Integer.valueOf(id), sb.toString());
  }

end