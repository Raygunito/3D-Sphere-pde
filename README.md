# 3D Gravity Simulation with Processing

This simple Processing sketch simulates a 3D gravity environment with a controllable orb interacting with the ground. The coordinates follow the system used by Processing: (x, y) for position and (z) for depth. Additionally, Processing uses the left-handed method, where Z is negative when moving away from the camera and positive when approaching the camera.

## How it works

- The ground is represented by a grid and is initially split into smaller sections.
- An orb is placed in the center of the window and responds to gravity.
- The user can navigate the scene using arrow keys, adjusting the viewpoint.

## Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/Raygunito/3D-Sphere-pde.git
   ```

2. Open the `main.pde` file in the Processing IDE.

3. Run the sketch (press the "Play" button).

4. Use the arrow keys to navigate the scene.

## Controls

- UP arrow key: Move the view upward.
- DOWN arrow key: Move the view downward.
- LEFT arrow key: Move the view to the left.
- RIGHT arrow key: Move the view to the right.
- MOUSE UP-DOWN: Adjust the viewpoint.

## Dependencies

- This sketch uses the [Processing](https://processing.org/) framework.

Feel free to explore and modify the code to suit your needs. Have fun simulating gravity in a 3D space!
