# Fishook

A 3D Platformer with a fishing hookshot.

## Tasks

- [x] In-Game Settings
- [x] Input Remapping
  - [x] Input remapping cleaner UI
- [x] Controller Support
  - [x] Fix DJ Bug
- [ ] Allow to shot hookshot from the ground and let the hookshot attached when landing.
- [x] Coyote Time
- [ ] More Levels !
- [ ] Fix bugs

## Playtest Alpha 0.0.1

Playtest subject : first playtest, 3D platforming only.

Commons feedback :

- Delay on hook activation is unintuitive and/or too long
  - Most people expect click -> attached
- Camera issue when going full up, can't see anything
- DJ input must release hookshot state instead of DJ
- Collectibles hitboxes are too small/feels like should be picked up
- Need to know where we are locked
- Using the grab is fun !!!!

Less Common Feeback :

- Feature to be able to reel out. (Reel In is cool already)
- Controller support please
- Accessibility : Aim assist for the hook
- Low-Poly is cute :D
- Everything should be grabbable.
- Allow to shot hookshot from the ground and let the hookshot attached when landing.
- Need more feedback when throwing the hook : rework animation, add SFX, VFX, UI Indicators

Unique Feedback  :

- No settings/pause in game ?
- Make out of range indicator clearer

Bugs :

- Running from a plat to the void locks you into running state without going to fall.

Personal Thoughts :

- Went well !
- Lots of work on
- Display the crosshair when jumping, fade it away when in idle for extended period of time
  -> this is about allowing 2 experiences to co-exist : both the speedrun enthusiast who want to schmoove and the chill panorama enjoyer.

## Playtest Alpha 0.0.2

### Dusk

- Grosse pyramide grabbable : pas intuitif
- Bon feeling sur la physique
- Bug sur l'orientation : pas bouger orientation si velocité < amount
- Envie de customisation de perso (long terme)
- Envie de voir LA PECHE

### Farl

- Beaucoup plus agréable/intuitif le grappin
- Sensi souris
- Inverser reel_in/reel_out
- bullet_time = bonne surprise & super pratique
- musique s'arrete au bout d'un moment :
  - passer à la suivante
- particules sur checkpoints
- mouvement :
  - petit dash vers l'avant ?
- bonus temporaire ?

### Neylax

- Sensi souris !!
- Peut pas grab au sol
- Relacher avec beaucoup de vélocité devrait envoyer + loin
  - Si input directionel quand avec velocité -> va moins loin
  - Si aucun input -> vélocité conservé
- Multiples Canne à peche avec effet différents
- Musique ne boucle pas
- BulletTime UI : limite infinie pas claire -> + de feedback
- Feedback sonore + visuel sur canne à peche

### Larenthios

- Settings : très éloigné sur grand écran
- Settings : save n quit
- Sound Effect très pop
- BulletTime devient tout noir -> Carte AMD ?
- Besoin de feedback quand hook est tenté mais rate
- Hitbox des collectibles pourraient etre + généreuse
- grounded hook intuitif
- feedback sur checkpoint
- quicker restart/death
- Dur mécaniquement à controller => bouger & viser dur
- QOL
- Peche
- Besoin de Vision Finale pour se projeter

### Syla

- Momentum en l'air compliqué
- Coyotte Time
- Inputs + Evident
- plus de maniabilité sans grappin
- Si rate la plateforme -> snap dessus
- Tutoriel ou Indicateur pour voir les touches
- Bouton reset pour speedrun

### BN

- Augmenter taille des collectibles
- dash/boost momentum/sprint

## Music

[HOME Tweet about his music](https://x.com/RNDYGFFE/status/1595515631020957703)
[Patricia Taxxon bandcamp](https://patriciataxxon.bandcamp.com/album/wavetable)
)

## Shaders

[Chromatic Aberation](https://godotshaders.com/shader/chromatic-abberation/)
