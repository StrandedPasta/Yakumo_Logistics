# Yakumo Logistics (v0.6)
A Factory Manager for Computercraft

# How to Download Main program
-Go into your computer in CC

-Copy the following: pastebin get https://pastebin.com/itBCZwA2 startup

-Type in: edit template.txt

-Save the file

-Restart the computer

-You are set!

# How to Download Turtle program
-Go into your Turtle

-Copy the following: pastebin get https://pastebin.com/LXmjm2WS startup

-Restart the turtle

-Done!

# Basic Manual (Under Develoment)
Welcome! Idk how you got here, but you are here. This is Yakumo Logistics, a program made to grow with your factory.
How it works is very simple. It takes Items that you want, transfers it into a machine, and takes the output back into your storage.
It's just like AE2 in a sense, except you can't craft on demand (yet). Hopefully with this manual, you can understand what everything does to make your factory ever more efficent!

**Table of Context:**

-Chapter 1: Peripherals

-Chapter 2: Chains

-Chapter 3: Backup and Errorlog

**Chapter 1: Peripherals**

There are 4 menus inside the program to know about. Peripherals are the most important one. It sets up peripheral groups and, more importantly, drives for your system.
In order to start your factory managing, you need to hook the system up to a driver with a disk inside it. But first, peripherals.

- Add Group: Adds a "Group" to a peripheral. Usually CC sets peripherals automatically. But if you want to use multiple machines in the same craft, grouping them would be ideal. The top half is mainly related to these groups.
- List Periphs: Lists all the grouped up peripherals into a single readable page or few. This is the only way to access it in multiplayer
- Del Periph: Deletes a single peripheral in the group. You can delete as much as you want here.
- Link Disk: This takes any avaiable disk and shows it onto a list for you to select. Disks are what stores your recipies, so its best to set this up first! Disks are also grouped up this way when more then one is chosen.
- Unlink Disk: This removes the disk from the system. Do not do this with one disk left inside the system. Might cause the whole system to shut down, or may lead to bugs.

**Chapter 2: Chains**

Chains are the backbone of your factory. They essencially allow you to transfer, craft, and mix all sorts of stuff together. There are four modes for you to remember. .Mix, .FluidMix, .Craft, and .Transfer. You can find it in the factory menu.

.Mix and .FluidMix do the same thing, they take the input of a machine, and drain/push the results out. If you want to make Builder's tea from create, use .FluidMix since it takes both items and fluids. .Mix only takes items in comparison.

.Craft needs a turtle with the turtle program to function. It crafts whatever you want from it. Want to craft a door, set up the pattern and material and you are good. A crafting bench, same here! 

.Transfer is a simple mode that allows you to move one set of items or fluids to another. Useful for furnaces or fuel for machines. 

- Add Chain: Adds a Chain to your network. It'll guide you through making the recipe with any of the modes you choose. Make sure you chose the right one for the job!
- List Chains: Allows you to read the recipies and see the recipies in a list It'll help a lot when finding errors. Sadly you cant edit them at all...
- Del Chain: Deletes a chain from the drive. So you can try again or just to remove one from the network.
- Add Sub: This adds a submode to your system. Due to limitations, the modes have to be done one at a time. So if you have two diffrent machines, it'll go through them one at a time. This is where the submode comes in. It allows you to run multiple machines at once!
- Del Sub: This deletes a submode of your choosing.

**Chapter 3: Backup and Errorlog**

Grouping these two since one of them is just its own command. Backup and Errerlog deal with errors or problems in your network. Backup sets a backup storage for all the recipies when the system shutsdown. Its not perfect, but it'll do.

As for Error logs, they are self explanitory. They show errors of your recipies. Rather no peripherals or invalid recipies. It has it all! (In theory).

- Backup: Chooses a Backup for both item and fluid variaties. You can use peripheral groups for this! Perferably into storage.
- Add BList: Not all mods are created equal. By default, items take from anything other then chests and barrels and puts them in storage. Not ideal! This sets up other storage containers the backup won't touch.
- Del BList: Add one that shouldnt be there? Yoou can remove it at any time by deleting it entirely!
- Error Log: Shows a list of error logs, organized by #error then time. They do delete over time to save on space...
