# CellSimulation
A simulated ecosystem for cells created in **Processing** for an assignment at The University of Waikato. This ecosystem consists of three different cell species - enemy, protector, and support cell - and simulates a predator-prey dynamic with an additional protector role. Additionally, there is the ability to change the temperature of the ecosystem and the reproduction rates of the enemy and protector cells to promote user interaction.

**NOTE:** This is not an accurate representation of a real cell simulation. This was to simulate an ecosystem and I happened to use cells as the species in my ecosystem.

## How It's Made:
**Created with:** Java

This was a university assignment, however the concepts and designs implemented were all different for each student, as our only task was to create a simulation for an ecosystem with no instructions on how it was to be designed. I started with finding inspiration and I had initially wanted to do a fish ecosystem. But I changed my mind soon after as I wanted to create something unique. I had weekly meetings with other students to iterate over my concepts and make changes if needed. All components in my simulation were designed by me on a pixel art platform, using common cell designs as inspiration.

In terms of code, I first implemented a movement that made cells follow their targets, along with the crowding behaviour. I then built on top of it to add collision for damages and support mechanisms. The support cells have a unique behaviour where they actively avoid enemy cells no matter if they're following protector cells or moving idly.

## Setup:
To run this project, Processing must be downloaded first.
1. Clone this repository:
   ```
   git clone https://github.com/ammicamia/cell-simulation.git
   ```
2. Open in Processing and run.

## Lessons Learned:
This assignment taught me a lot about movements in general and how to make it look natural. Admittedly, it was the most difficult part of the process but it felt rewarding seeing it come together. It also taught me how to make pixel art and make cohesive designs.
