# Final-Project-Game-3D - Gooch 3D

# Game Synopsis
You play as a Monglian Chef named Gooch. You must explore the land and fight off evil cheeseburgers to protect you're Mongolian grill from the tyranny of the fast food industry.

# Game Structure
This game is built using the GODOT open source game engine and the models are created using Blender. In GODOT, the game consists of the following scenes:
### The Map
The map is a Static Body physics object and has a Trimesh Collision Mesh. To create the map in Blender, I used the sculpting tools to sculpt a subdivided plane. I then used texture paint to create the texture of the grass and rock. The grass texture was from a grass PBR texture and the rock was just a noise texture. I also added some displacement shading to the map with a different displacement texture that I got from a road texture. I chose this because it looked like rock when I applied it to my map model. 
### The Player
The player is a CharacterBody3D and is made up of a few different object. The body is just a capsult shaped collision mesh. The Legs and hands are all models I built in blender and I added them as child scenes to the player object as Node3Ds. The player's head is made up of a Node3D that has a camera object as a child. This allows the head to be controlled seperately from the body
![image](https://user-images.githubusercontent.com/107002749/235007488-4bf108d0-6c6c-43ce-80c5-30c5cb2a62c3.png)

### The Enemy
The Enemy is a CharacterBody3D and is made up of 2 simplified convex collision mesh siblings that are modeled around the cheeseburger mesh. The mesh itself is made up of a cyclinder, a hollowed out torus, a partial sphere and the same leg mesh used for the player model.
![image](https://user-images.githubusercontent.com/107002749/235327087-03578212-c659-4b20-9dd5-34f2f1e7afae.png)

The enemy moves autonomously utilizing GODOT's NavigationAgent3D and NavigationRegion3D. It constantly moves towrds the player and rotates it's head so it will always be looking at the player. They spawn in from a random direction around the player at regular intervals and immediatly after spawning, that start pathfinding towards the player. 

### The HUD
This game has a very simple HUD. It displays the amount of health that the player has left. Every time the player gets hit by a cheeseburger, the health decreases by 5. Once the health reaches 0, the game ends with a freezeframe and the user is presented with "You Died" and a "Quit" button. 

