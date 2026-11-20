## 03/10/2026 heyy first real push to main 
### i've been working on the player base mouvement and the first basic enemy anim and deplacement system 
__but i also start the sprite as i will need tons of SPRITES but i want to make them all by miself!!__
### add for the future will be MORE SPRITES andding an obstacle thing like layer to the tiles with stairs or natural shape of field ect
#### for now it's only the begining so i just draw for the future and think for next updates
### see you next time!!!
## 06/10/2026 targeting the enemy intelligence and the obstacle system
#### some update and a lot of drawings made ouch

__yes in fact i pass a lot of hour on drawing the **sprite** ( a long task i struggle with)
today i learn the **LOS system** : it's use to encounter the fact that if you are in the enemy zone but behind an obstacle he will chase you and run face to face with the wall/obstacle so it use a system of a **raycast** to see if the player is visible or not it allow the obstacle problem but also like that the player can play by being discret.
and i finish by making a **bush** system that allow the player to hide in them and be **invisible** to the enemy.__
 ![nav illustation]("/git_assets/nav_agent.png") 

### i finish by telling the future update:
* maybe the player basic sprite 
* the start of the inv

# 11/10/2026 a lot of drawings again! and a new inventory system with litle thing add!
## in fact i pass like the most of the time making the sprite ( i want to make it all by myself) and learn to do shadow ect for the future
**but yeah i just finish the inventory with basic item made**
### BUT
#### i add a new type of item the "consumable one!!" with a bottle of water but i draw the future consumable even the FIRECRACKER a vogue object in france these day!!!
### i help myself with a tutorial but i modify thing for consumable object :
#### (here's the link to the tuto)[https://gameidea.org/2024/08/26/make-inventory-system-in-godot/]

### anyways the future update!:
* telling you a bit about the lore
* making object for food and equipement item
* making the the short inventory to the bottom of the screen
* the food thirst and temperature bar somewhere
*bye byee <3*

# 04/11/2026 heyyy i'm becoming a real pixel art drawer ehheh 
## i may have pass 10h or more on the draw of the game but i don't commit only because i draw but i guess next time i will do it ! 
*so from the last time i went though a lot of thing (in my actual country but also in coding and drawing)*
__so so so... hmm " telling you a bit about the lore" hmmm sorry i didn't work on this aghhh__
### for the rest
* i make and draw object for some food (modern one in france like "tasty crousty") and equiment only one (likely 10h of draws and 3h of coding or maybe 2h?)
* i make the short inv hehe the hotbar is work with using the item because yeah we can interact in inventory and hotbar the item (took like 3 or 2h of code)
* the food and the thirst bar hehe done it did it looking a bit like subnautica one! ...yeah i know i don't make the temperature one but it's for the comming commit hehe ( like 2h or 1h of draw and 1h of coding)
* other! ... i make the hand system !!! i just use this system to make the item equiped fit in the hand of the player depending the animation so i do not recreat sprite for each i use an animation play to make the item(sprite node2d) fit the hand (time estimated the long and despair and harsh hour of my life)*
* i pass 1h at school to simplify my code than thousand of if and 1H on my pc at home ( my code still veryyyy messy)
* i try to preshot the future equipment system while doing all that but one thing that lost me is that i can't found the way i want the 2d to look like

  anywayss these day France is kinda becoming something bad and i see it  as someone who participate to defend my right

  ## then the next imrpovement will be:
  * the first equipement item finish
  * maybe the first  animals
  * the object to screach ressources in
  * maybe a bit more about the lore!!
 
  # 20/11/2026 a lot of draw and the crew is growing up, the game is turning for big future!
  ### hellowww these recent day i was fighting again for my rights but during these i met a lot of great people and i told  the project i have of making a game. So they join me!  there is some people who want's to be the tester, one that want to help me drawing a few sprite and a friend who will help me with the music asset!!
__what i've done since 16days:__
* i participate to hackclub atlantis!!
* make the first equipement item! it's a *"taser*
* the first animals too! a __deer!!__ (a friend help me draw some sprite)
* draw a lot! i __totaly__ remake the main character the way i wanted to.
* didn't do the object to screach ressources in (like chest,bags ect...)
* wonder a lot about the lore i will make a days dedicate to.
* start the save manager and to optimise(explaination below) the code as a big game can __grow on solid bases__!
* rethink the animation_player on player and enemy (i will make a class for the comon function of living creature to optimize soon)


__i'm quite sad that to learn i use claude ia that explain me the key point of how to make a scalable game and how to make a save manager. Only a few lines are wrote by it, anyways even if i earn time by doing this than to watch for likely 2h different tuto and doc. i want to try my best to priorise human made explication and make this game the most vivid possible with the art(it's obvious) and also the code having a human spirit! This is so much important for me and i kinda feel guilty every time i open claude__

## for the optimise!
it can be seen as a basic coding thing but as a 1yrs game dev i'm learning a lot ( i will forever learn thing in game dev)
and sometimes my code look like a tons of 
~~~ 
if
elif
    if
elif
elif
elif
    if
    else
elif
elif
else
~~~~

so i optimize by making the animation pass from these if mountains to 
~~~
func animation_player(direction_x, direction_y):

	var dir_name = horizontal_direction
 if vertical_direction != null and (direction_y != 0 or direction_x == 0):
		   dir_name = vertical_direction  # "up" ou "down"

	var suffix = "_" + weapon_suffix if weapon_suffix != "" else ""
	
	var anim = str(state) + "_"  + str(dir_name) + str(suffix)
	
	animated_sprite_2d.play(anim)
	hand_anim.play(anim)
~~~~
and some little changes like these make me thinking on how can i optimize at maximum everytime i'm trying to develop the "how can i do better" 

anyways i'm going back to coding and fighting for rights!!
the next things i want to make are:
* finishing the save manager
* keep optimize and make it scalable
* start for real the lore writing
* make another enemy and items
* the bags and chest system
* if i have time the temperature bar
#### have a good day!!
