###### push box game ######

### debug marco 
.macro debug
	li $v0, 10
	syscall
.end_macro


### push into stack
.macro push (%reg)
	addi $sp, $sp, -4
	sw %reg, ($sp)
.end_macro


### pop from stack
.macro pop (%reg)
	lw %reg, ($sp)
	addi $sp, $sp, 4
.end_macro


# ## use bgez to generate lt, gt, le, ge
# ### if %reg1 less than %reg2 then branch to %tag
# .macro lt (%reg1, %reg2, %tag)
# 	sub $s7, %reg1, %reg2
# 	sub $s7, $zero, $s7
# 	addi $s7, $s7, -1
# 	bgez $s7, %tag
# .end_macro


# ### if %reg1 greater than %reg2 then branch to %tag
# .macro gt (%reg1, %reg2, %tag)
# 	sub $s7, %reg1, %reg2
# 	addi $s7, $s7, -1
# 	bgez $s7, %tag
# .end_macro


# ### if %reg1 less than or equal to %reg2 then branch to %tag
# .macro le (%reg1, %reg2, %tag)
# 	sub $s7, %reg2, %reg1
# 	bgez $s7, %tag
# .end_macro


# ### if %reg1 greater than or equal to %reg2 then branch to %tag
# .macro ge (%reg1, %reg2, %tag)
# 	sub $s7, %reg1, %reg2
# 	bgez $s7, %tag
# .end_macro


### use blez to generate lt, gt, le, ge
### if %reg1 less than %reg2 then branch to %tag
.macro lt (%reg1, %reg2, %tag)
	sub $s7, %reg1, %reg2
	addi $s7, $s7, 1
	blez $s7, %tag
.end_macro


### if %reg1 greater than %reg2 then branch to %tag
.macro gt (%reg1, %reg2, %tag)
	sub $s7, %reg2, %reg1
	addi $s7, $s7, 1
	blez $s7, %tag
.end_macro


### if %reg1 less than or equal to %reg2 then branch to %tag
.macro le (%reg1, %reg2, %tag)
	sub $s7, %reg1, %reg2
	blez $s7, %tag
.end_macro


### if %reg1 greater than or equal to %reg2 then branch to %tag
.macro ge (%reg1, %reg2, %tag)
	sub $s7, %reg2, %reg1
	blez $s7, %tag
.end_macro


# ## use bgtz to generate lt, gt, le, ge
# ### if %reg1 less than %reg2 then branch to %tag
# .macro lt (%reg1, %reg2, %tag)
# 	sub $s7, %reg2, %reg1
# 	bgtz $s7, %tag
# .end_macro


# ### if %reg1 greater than %reg2 then branch to %tag
# .macro gt (%reg1, %reg2, %tag)
# 	sub $s7, %reg1, %reg2
# 	bgtz $s7, %tag
# .end_macro


# ### if %reg1 less than or equal to %reg2 then branch to %tag
# .macro le (%reg1, %reg2, %tag)
# 	sub $s7, %reg2, %reg1
# 	addi $s7, $s7, 1
# 	bgtz $s7, %tag
# .end_macro


# ### if %reg1 greater than or equal to %reg2 then branch to %tag
# .macro ge (%reg1, %reg2, %tag)
# 	sub $s7, %reg1, %reg2
# 	addi $s7, $s7, 1
# 	bgtz $s7, %tag
# .end_macro


### %regd <- %regs x %n (n must be greater than or equal to 0)
.macro multiply (%regd, %regs, %n)
		push $t8
		li %regd, 0
		add $t8, $zero, %n
		beq $t8, $zero, exit_loop
	mul_loop:
		add %regd, %regd, %regs
		addi $t8, $t8, -1
		bne $t8, $zero, mul_loop
	exit_loop:
		pop $t8
.end_macro

		
.data
############################### read only data #########################
### states
isempty:			.word 0
iswall:				.word 1
istarget:			.word 2
isplayer:			.word 3
isbox:				.word 4
box_target:			.word 5
player_target:		.word 6
### game maps
# level 1 map
map1:				.word 0 0 1 1 1 0 0 0 0
			      		  0 0 1 2 1 0 0 0 0
			      		  0 0 1 0 1 1 1 1 0
			      		  1 1 1 4 4 0 2 1 0
			      		  1 2 0 4 3 1 1 1 0
			      		  1 1 1 1 4 1 0 0 0
			    		  0 0 0 1 2 1 0 0 0
			    		  0 0 0 1 1 1 0 0 0
			    		  0 0 0 0 0 0 0 0 0	
map1_steps:			.word 12
map1_player_x:		.word 4
map1_player_y:		.word 4
map1_targets:		.word 4
# level 2 map	
map2:				.word 1 1 1 1 1 0 0 0 0
			    		  1 0 0 3 1 0 0 0 0
			    		  1 0 4 4 1 0 1 1 1
			    		  1 0 4 0 1 0 1 2 1
			    		  1 1 1 0 1 1 1 2 1
			    		  1 1 1 0 0 0 0 2 1
			    		  0 1 0 0 0 1 0 0 1
			    		  0 1 0 0 0 1 1 1 1
			    		  0 1 1 1 1 1 0 0 0
map2_steps:			.word 95
map2_player_x:		.word 1
map2_player_y:		.word 3
map2_targets:		.word 3
# level 3 map	
map3:				.word 0 0 1 1 1 1 1 0 0
			    		  0 1 1 0 0 0 1 1 0
			     		  0 1 0 0 4 2 2 1 1
			    		  1 1 4 0 1 2 4 2 1
			    		  1 0 0 0 1 2 2 2 1
			    	 	  1 0 4 1 1 1 4 0 1
			    		  1 0 0 4 0 4 0 1 1
			    		  1 1 3 0 0 0 0 1 0
			    		  0 1 1 1 1 1 1 1 0
map3_steps:			.word 900
map3_player_x:		.word 7
map3_player_y:		.word 2
map3_targets:		.word 7
# game map size
mapsize:			.word 9
### pages addr
start:				.word 0x10013000		# start page addr
select:				.word 0x10014000
help:				.word 0x10014800
level1:				.word 0x1001a400		# level page
level2: 			.word 0x10020400		
level3:				.word 0x10027800
level_win:			.word 0x1002f400
win:				.word 0x10030400		# win page
lose:				.word 0x10031400		# lose page
### components addr
box2:				.word 0x10032400
box1:          		.word 0x10032800
player:         	.word 0x10032c00
wall:		    	.word 0x10033000
target:         	.word 0x10033400
seltri:         	.word 0x10033800
zero:   			.word 0x10033c00
one:            	.word 0x10034000
two:				.word 0x10034400
three:          	.word 0x10034800
four:           	.word 0x10034c00
five:     			.word 0x10035000
six: 				.word 0x10035400
seven:          	.word 0x10035800
eight: 				.word 0x10035c00
nine:           	.word 0x10036000
mask:		  		.word 0x10036400
### control the position of the select triangle in start page, win page and lose page
seltri_x:			.word 40	# select triangle x pos
seltri_y: 			.word 53	# select triangle y pos 50
seltri_y_delta:		.word 16	# select triangle y delta
### control the position of the num
num_start_x:		.word 92
num_start_y:		.word 9
num_x_delta:		.word 4
num_y_delta:		.word 7
### control the position of the num mask
num_mask_x:			.word 92
num_mask_y:			.word 5
### control the position of the object in the game
object_start_x:		.word 10
object_start_y:		.word 21
object_x_delta:		.word 12
object_y_delta:		.word 12
### control the position of select page triangle
select_page_seltri_x:		.word 5
select_page_seltri_y:		.word 20
select_page_seltri_x_delta:	.word 32
### control the position of select page mask
select_page_mask_x:			.word 0
select_page_mask_y:			.word 17
select_page_mask_x_delta:	.word 33
############################################################################
### others
current_level:		.space 4
current_map:		.space 324
current_steps:		.space 4
current_player_x:	.space 4
current_player_y:	.space 4
current_targets:	.space 4

button_num:			.space 4
button_event:		.space 4

seltri_y_cnt: 		.space 4		# select triangle orginal y position

select_page_seltri_x_cnt:	.space 4


.text
.globl main
set_up_registers:
	li $sp, 0x10013000	# set the bottom of stack to 0x3000
	j main

### interrupt 1: up button
INT1:
	push $t0
	li $t0, 1
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret
	

### interrupt 2: down button
INT2:
	push $t0
	li $t0, 2
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret
	

### interrupt 3: left button
INT3:
	push $t0
	li $t0, 3
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret
	
	
### interrupt 4: right button
INT4:
	push $t0
	li $t0, 4
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret
	

### interrupt 5: enter button
INT5:
	push $t0
	li $t0, 5
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret
	
	
### interrupt 6: back button
INT6:
	push $t0
	li $t0, 6
	sw $t0, button_num
	li $t0, 1
	sw $t0, button_event
	pop $t0
	eret


### main program
main:
	jal clearscreen	# clear the screen when start the game or close the game

	# li $v0, 10		# push the go button to start game, this is not debug
	# syscall

	debug				# push the go button to start game, this is not debug, but we can use debug

	li $t9, 1
	sw $t9, current_level
	j start_page_action		# goto start page, start the game
	j main	# jump back to main
	
	
### actions on start page
start_page_action:
	jal clearscreen		# clear the screen to show the start page

	lw $a0, start
	jal showpage	# load start page
	
	li $t1, 0
	sw $t1, seltri_y_cnt	# set original seltri pos to the top
	
	lw $a0, seltri
	lw $a1, seltri_x
	lw $a2, seltri_y
	jal showcomponent	# load seltri component
	
	start_page_loop:	
		jal loopforever		# wait for input signal
		# mainly control the position of the triangle
		
		lw $t0, button_num
		start_page_check1:
			bne $t0, 1, start_page_check2	# up button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 0, start_page_loop		# seltri at the top, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, -1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j start_page_loop	# loop again
			
		start_page_check2:
			bne $t0, 2, start_page_check3	# down button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 2, start_page_loop		# seltri at the bottom, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, 1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place + 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j start_page_loop	# loop again
			
		start_page_check3:
			bne $t0, 5, start_page_check4	# enter button pressed
			
			lw $t1, seltri_y_cnt
			start_goto_select1:
				bne $t1, 0, start_goto_select2	# seltri at start option, goto level page
				li $t9, 1
				sw $t9, current_level
				j level_page_action
			
			start_goto_select2:
				bne $t1, 1, start_goto_select3	# seltri at help option, goto help page
				j help_page_action
			
			start_goto_select3:
				bne $t1, 2, start_page_loop
				j select_page_action			# seltri at select option, goto select page
		start_page_check4:
			bne $t0, 6, start_page_loop		# back button pressed, close the game
			j main
		j start_page_loop


### actions on select page
select_page_action:
	jal clearscreen

	lw $a0, select
	jal showpage

	sw $zero, select_page_seltri_x_cnt

	lw $a0, seltri
	lw $a1, select_page_seltri_x
	lw $a2, select_page_seltri_y
	jal showcomponent

	select_page_loop:
		jal loopforever		# wait for input signal
		# mainly control the position of the triangle
		
		lw $t0, button_num
		select_page_check1:
			bne $t0, 3, select_page_check2	# left button pressed
			
			lw $t1, select_page_seltri_x_cnt
			beq $t1, 0, select_page_loop		# seltri at the left, loop again

			lw $a0, mask
			lw $a1, select_page_mask_x
			lw $a2, select_page_mask_y
			lw $t2, select_page_mask_x_delta
			multiply $t3, $t2, $t1
			add $a1, $a1, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, -1
			sw $t1, select_page_seltri_x_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, select_page_seltri_x
			lw $a2, select_page_seltri_y
			lw $t2, select_page_seltri_x_delta
			multiply $t3, $t2, $t1
			add $a1, $a1, $t3
			jal showcomponent	# show seltri in new position
			
			j select_page_loop	# loop again
			
		select_page_check2:
			bne $t0, 4, select_page_check3	# right button pressed
			
			lw $t1, select_page_seltri_x_cnt
			beq $t1, 2, select_page_loop		# seltri at the right, loop again

			lw $a0, mask
			lw $a1, select_page_mask_x
			lw $a2, select_page_mask_y
			lw $t2, select_page_mask_x_delta
			multiply $t3, $t2, $t1
			add $a1, $a1, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, 1
			sw $t1, select_page_seltri_x_cnt	# change the seltri postion record to original place + 1
			
			lw $a0, seltri
			lw $a1, select_page_seltri_x
			lw $a2, select_page_seltri_y
			lw $t2, select_page_seltri_x_delta
			multiply $t3, $t2, $t1
			add $a1, $a1, $t3
			jal showcomponent	# show seltri in new position
			
			j select_page_loop	# loop again
			
		select_page_check3:
			bne $t0, 5, select_page_check4	# enter button pressed
			
			lw $t1, select_page_seltri_x_cnt
			# select_goto_select1:
			# 	bne $t1, 0, start_goto_select2	# seltri at level1 option, goto level page
			addi $t9, $t1, 1
			sw $t9, current_level
				# sw $t1, current_level
			j level_page_action
			
			# select_goto_select2:
			# 	bne $t1, 1, select_goto_select3	# seltri at level2 option, goto level page
				# sw $t1, current_level
				# j level_page_action
			
			# select_goto_select3:
			# 	bne $t1, 2, select_page_loop	# seltri at level3 option, goto level page
				# sw $t1, current_level
				# j level_page_action	# select level not implemented
		select_page_check4:
			bne $t0, 6, select_page_loop		# back button pressed, go back to start page
			j start_page_action
		j select_page_loop


### actions on level page
level_page_action:
	jal clearscreen
	
	jal map_get

	move $a0, $v1
	jal showpage
	
	jal showdigits
	
	level_page_loop:
		lw $t0, current_targets
		bne $t0, 0, level_check_steps		# if you win, goto the win page
		lw $t1, current_level
		beq $t1, 3, win_page_action
		j level_win_page_action

		level_check_steps:
			lw $t0, current_steps
			beq $t0, 0, lose_page_action	# if you lose, goto the lose page
		
		jal loopforever
		
		lw $t0, button_num
		level_page_check1:
			bne $t0, 1, level_page_check2	# up button pressed
				
			lw $t1, current_player_x
			lw $t2, current_player_y
			
			beq $t1, 0, level_page_loop	# player at the top, no action
			
			la $a0, current_map
			move $a1, $t1
			move $a2, $t2
			lw $s0, mapsize
			lw $s1, mapsize
			jal array_get
			move $t4, $v1 	# t4: current place
			
			addi $a1, $a1, -1
			jal array_get
			move $t5, $v1 	# t5: player goto place 
			
			beq $t5, 1, level_page_loop	# get a wall
			
			level_up_check1:
				bne $t5, 0, level_up_check2	# get empty

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_up_check1_player_check1:
					bne $t4, 3, level_up_check1_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t1, $t1, -1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
					
				level_up_check1_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t1, $t1, -1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
			
			level_up_check2:
				bne $t5, 4, level_up_check3	# get a box
				beq $a2, 0, level_page_loop	# box at the top, no action
				
				addi $a1, $a1, -1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_up_check2_box_check1:
					bne $t6, 0, level_up_check2_box_check2	# get empty
					level_up_check2_box_check1_player_check1:	
						bne $t4, 3, level_up_check2_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_up_check2_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $12, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_up_check2_box_check2:
					bne $t6, 2, level_page_loop	# get a target

					lw $t7, current_targets
					addi $t7, $t7, -1
					sw $t7, current_targets

					level_up_check2_box_check2_player_check1:	
						bne $t4, 3, level_up_check2_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_up_check2_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
			level_up_check3:
				bne $t5, 2, level_up_check4	# get a target

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_up_check3_player_check1:
					bne $t4, 3, level_up_check3_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t1, $t1, -1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
					
				level_up_check3_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t1, $t1, -1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
			
			level_up_check4:
				bne $t5, 5, level_page_loop	# get a box with target
				beq $a2, 0, level_page_loop	# box at the top, no action
				
				addi $a1, $a1, -1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_up_check4_box_check1:
					bne $t6, 0, level_up_check4_box_check2	# get empty

					lw $t7, current_targets
					addi $t7, $t7, 1
					sw $t7, current_targets

					level_up_check4_box_check1_player_check1:	
						bne $t4, 3, level_up_check4_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_up_check4_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_up_check4_box_check2:
					bne $t6, 2, level_page_loop	# get a target
					level_up_check4_box_check2_player_check1:	
						bne $t4, 3, level_up_check4_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_up_check4_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, -1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
		level_page_check2:
			bne $t0, 2, level_page_check3	# down button pressed
				
			lw $t1, current_player_x
			lw $t2, current_player_y

			lw $t7, mapsize
			addi $t7, $t7, -1
			beq $t1, $t7, level_page_loop	# player at the bottom, no action
			
			la $a0, current_map
			move $a1, $t1
			move $a2, $t2
			lw $s0, mapsize
			lw $s1, mapsize
			jal array_get
			move $t4, $v1	# t4: current place
			
			addi $a1, $a1, 1
			jal array_get
			move $t5, $v1 	# t5: player goto place 
			
			beq $t5, 1, level_page_loop	# get a wall
			
			level_down_check1:
				bne $t5, 0, level_down_check2	# get empty

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_down_check1_player_check1:
					bne $t4, 3, level_down_check1_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t1, $t1, 1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
					
				level_down_check1_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t1, $t1, 1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
			
			level_down_check2:
				bne $t5, 4, level_down_check3	# get a box

				lw $t7, mapsize
				addi $t7, $t7, -1
				beq $a1, $t7, level_page_loop	# box at the bottom, no action
				
				addi $a1, $a1, 1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_down_check2_box_check1:
					bne $t6, 0, level_down_check2_box_check2	# get empty
					level_down_check2_box_check1_player_check1:	
						bne $t4, 3, level_down_check2_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_down_check2_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_down_check2_box_check2:
					bne $t6, 2, level_page_loop	# get a target

					lw $t7, current_targets
					addi $t7, $t7, -1
					sw $t7, current_targets

					level_down_check2_box_check2_player_check1:	
						bne $t4, 3, level_down_check2_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_down_check2_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
			level_down_check3:
				bne $t5, 2, level_down_check4	# get a target

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_down_check3_player_check1:
					bne $t4, 3, level_down_check3_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t1, $t1, 1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
					
				level_down_check3_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t1, $t1, 1
					sw $t1, current_player_x

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
			
			level_down_check4:
				bne $t5, 5, level_page_loop	# get a box with target

				lw $t7, mapsize
				addi $t7, $t7, -1
				beq $a1, $t7, level_page_loop	# box at the bottom, no action
				
				addi $a1, $a1, 1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_down_check4_box_check1:
					bne $t6, 0, level_down_check4_box_check2	# get empty

					lw $t7, current_targets
					addi $t7, $t7, 1
					sw $t7, current_targets

					level_down_check4_box_check1_player_check1:	
						bne $t4, 3, level_down_check4_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_down_check4_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_down_check4_box_check2:
					bne $t6, 2, level_page_loop	# get a target
					level_down_check4_box_check2_player_check1:	
						bne $t4, 3, level_down_check4_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t1, $t1, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_down_check4_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t1, $t1, 1
						sw $t1, current_player_x

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
		level_page_check3:
			bne $t0, 3, level_page_check4

			lw $t1, current_player_x
			lw $t2, current_player_y
			
			beq $t2, 0, level_page_loop	# player at the left, no action
			
			la $a0, current_map
			move $a1, $t1
			move $a2, $t2
			lw $s0, mapsize
			lw $s1, mapsize
			jal array_get
			move $t4, $v1 	# t4: current place
			
			addi $a2, $a2, -1
			jal array_get
			move $t5, $v1 	# t5: player goto place 
			
			beq $t5, 1, level_page_loop	# get a wall
			
			level_left_check1:
				bne $t5, 0, level_left_check2	# get empty

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_left_check1_player_check1:
					bne $t4, 3, level_left_check1_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t2, $t2, -1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
					
				level_left_check1_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t2, $t2, -1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
			
			level_left_check2:
				bne $t5, 4, level_left_check3	# get a box

				beq $a1, 0, level_page_loop	# box at the left, no action
				
				addi $a2, $a2, -1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_left_check2_box_check1:
					bne $t6, 0, level_left_check2_box_check2	# get empty
					level_left_check2_box_check1_player_check1:	
						bne $t4, 3, level_left_check2_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_left_check2_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_left_check2_box_check2:
					bne $t6, 2, level_page_loop	# get a target

					lw $t7, current_targets
					addi $t7, $t7, -1
					sw $t7, current_targets

					level_left_check2_box_check2_player_check1:	
						bne $t4, 3, level_left_check2_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_left_check2_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
			level_left_check3:
				bne $t5, 2, level_left_check4	# get a target

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_left_check3_player_check1:
					bne $t4, 3, level_left_check3_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t2, $t2, -1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
					
				level_left_check3_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t2, $t2, -1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
			
			level_left_check4:
				bne $t5, 5, level_page_loop	# get a box with target

				beq $a1, 0, level_page_loop	# box at the left, no action
				
				addi $a2, $a2, -1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_left_check4_box_check1:
					bne $t6, 0, level_left_check4_box_check2	# get empty

					lw $t7, current_targets
					addi $t7, $t7, 1
					sw $t7, current_targets

					level_left_check4_box_check1_player_check1:	
						bne $t4, 3, level_left_check4_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y
						
						lw $a0, player
						li $s2, 6
						jal gamesetcomponent

						addi $t2, $t2, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_left_check4_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_left_check4_box_check2:
					bne $t6, 2, level_page_loop	# get a target
					level_left_check4_box_check2_player_check1:	
						bne $t4, 3, level_left_check4_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_left_check4_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, -1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, -1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
		level_page_check4:
			bne $t0, 4, level_page_check5

			lw $t1, current_player_x
			lw $t2, current_player_y
			lw $t3, current_steps
			
			lw $t7, mapsize
			addi $t7, $t7, -1
			beq $t2, $t7, level_page_loop	# player at the right, no action
			
			la $a0, current_map
			move $a1, $t1
			move $a2, $t2
			lw $s0, mapsize
			lw $s1, mapsize
			jal array_get
			move $t4, $v1	# t4: current place
			
			addi $a2, $a2, 1
			jal array_get
			move $t5, $v1 	# t5: player goto place 
			
			beq $t5, 1, level_page_loop	# get a wall
			
			level_right_check1:
				bne $t5, 0, level_right_check2	# get empty

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_right_check1_player_check1:
					bne $t4, 3, level_right_check1_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t2, $t2, 1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
					
				level_right_check1_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t2, $t2, 1
					sw $t2, current_player_y

					lw $a0, player
					li $s2, 3
					jal gamesetcomponent

					j level_page_loop
			
			level_right_check2:
				bne $t5, 4, level_right_check3	# get a box

				lw $t7, mapsize
				addi $t7, $t7, -1
				beq $a2, $t7, level_page_loop	# box at the right, no action
				
				addi $a2, $a2, 1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_right_check2_box_check1:
					bne $t6, 0, level_right_check2_box_check2	# get empty
					level_right_check2_box_check1_player_check1:	
						bne $t4, 3, level_right_check2_box_check1_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_right_check2_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, 1

						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_right_check2_box_check2:
					bne $t6, 2, level_page_loop	# get a target

					lw $t7, current_targets
					addi $t7, $t7, -1
					sw $t7, current_targets

					level_right_check2_box_check2_player_check1:	
						bne $t4, 3, level_right_check2_box_check2_player_check2	# current place is a player

						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_right_check2_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target

						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y
						
						lw $a0, player
						li $s2, 3
						jal gamesetcomponent
						
						addi $t2, $t2, 1
		
						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
			level_right_check3:
				bne $t5, 2, level_right_check4	# get a target

				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_right_check3_player_check1:
					bne $t4, 3, level_right_check3_player_check2	# current place is a player

					lw $a0, mask
					li $s2, 0
					jal gamesetcomponent
					
					addi $t2, $t2, 1
					sw $t2, current_player_y
					
					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
					
				level_right_check3_player_check2:
					bne $t4, 6, level_page_loop	# current place is a player and a target

					lw $a0, target
					li $s2, 2
					jal gamesetcomponent
					
					addi $t2, $t2, 1
					sw $t2, current_player_y
					
					lw $a0, player
					li $s2, 6
					jal gamesetcomponent

					j level_page_loop
			
			level_right_check4:
				bne $t5, 5, level_page_loop	# get a box with target

				lw $t7, mapsize
				addi $t7, $t7, -1
				beq $a2, $t7, level_page_loop	# box at the right, no action
				
				addi $a2, $a2, 1
				jal array_get
				move $t6, $v1  # $t6: box goto place
				
				beq $t6, 1, level_page_loop	# get a wall
				beq $t6, 4, level_page_loop	# get a box
				beq $t6, 5, level_page_loop	# get box + target
					
				lw $t3, current_steps
				addi $t3, $t3, -1
				sw $t3, current_steps
				jal showdigits

				level_right_check4_box_check1:
					bne $t6, 0, level_right_check4_box_check2	# get empty

					lw $t7, current_targets
					addi $t7, $t7, 1
					sw $t7, current_targets

					level_right_check4_box_check1_player_check1:	
						bne $t4, 3, level_right_check4_box_check1_player_check2	# current place is a player
						# show mask
						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y
						
						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						
						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
						
					level_right_check4_box_check1_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target
						
						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y
						
						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, 1
				
						lw $a0, box1
						li $s2, 4
						jal gamesetcomponent

						j level_page_loop
					
				level_right_check4_box_check2:
					bne $t6, 2, level_page_loop	# get a target
					level_right_check4_box_check2_player_check1:	
						bne $t4, 3, level_right_check4_box_check2_player_check2	# current place is a player
						
						lw $a0, mask
						li $s2, 0
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y
						
						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, 1

						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
						
					level_right_check4_box_check2_player_check2:	
						bne $t4, 6, level_page_loop	# current place is player + target
						
						lw $a0, target
						li $s2, 2
						jal gamesetcomponent
						
						addi $t2, $t2, 1
						sw $t2, current_player_y

						lw $a0, player
						li $s2, 6
						jal gamesetcomponent
						
						addi $t2, $t2, 1
					
						lw $a0, box2
						li $s2, 5
						jal gamesetcomponent

						j level_page_loop
			
		level_page_check5:
			bne $t0, 6, level_page_loop
			j start_page_action		# back button pushed, go back to start page
		
		j level_page_loop	


### actions on level win page
level_win_page_action:
	jal clearscreen
	
	lw $a0, level_win
	jal showpage	# load win page
	
	li $t1, 0
	sw $t1, seltri_y_cnt	# set original seltri pos to the top
	
	lw $a0, seltri
	lw $a1, seltri_x
	lw $a2, seltri_y
	jal showcomponent	# load seltri component
	
	level_win_page_loop:
		jal loopforever
		# mainly control the position of the triangle

		lw $t0, button_num
		level_win_page_check1:
			bne $t0, 1, level_win_page_check2	# up button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 0, level_win_page_loop	# seltri at the top, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, -1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j level_win_page_loop		# loop again
			
		level_win_page_check2:
			bne $t0, 2, level_win_page_check3	# down button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 3, level_win_page_loop	# seltri at the bottom, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, 1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j level_win_page_loop		# loop again
			
		level_win_page_check3:
			bne $t0, 5, level_win_page_check4	# enter button pressed
			
			lw $t1, seltri_y_cnt
			level_win_goto_select1:
				bne $t1, 0, level_win_goto_select2
				lw $t9, current_level
				addi $t9, $t9, 1
				sw $t9, current_level
				j level_page_action		# goto next option selected, goto level page
			
			level_win_goto_select2:
				bne $t1, 1, level_win_goto_select3
				j level_page_action		# replay option selected, goto level page
			
			level_win_goto_select3:
				bne $t1, 2, level_win_goto_select4
				j select_page_action	# select option selected, goto select page

			level_win_goto_select4:
				bne $t1, 3, level_win_page_loop
				j start_page_action		# goto main option selected, goto start page
		
		level_win_page_check4:
			bne $t0, 6, level_win_page_loop	# back button pressed, goto start page
			j start_page_action

		j level_win_page_loop

	
### actions on win page
win_page_action:
	jal clearscreen
	
	lw $a0, win
	jal showpage	# load win page
	
	li $t1, 0
	sw $t1, seltri_y_cnt	# set original seltri pos to the top
	
	lw $a0, seltri
	lw $a1, seltri_x
	lw $a2, seltri_y
	jal showcomponent	# load seltri component
	
	win_page_loop:
		jal loopforever
		# mainly control the position of the triangle

		lw $t0, button_num
		win_page_check1:
			bne $t0, 1, win_page_check2	# up button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 0, win_page_loop	# seltri at the top, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, -1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j win_page_loop		# loop again
			
		win_page_check2:
			bne $t0, 2, win_page_check3	# down button pressed
			
			lw $t1, seltri_y_cnt
			beq $t1, 2, win_page_loop	# seltri at the bottom, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, 1
			sw $t1, seltri_y_cnt	# change the seltri postion record to original place - 1
			
			lw $a0, seltri
			lw $a1, seltri_x
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j win_page_loop		# loop again
			
		win_page_check3:
			bne $t0, 5, win_page_check4	# enter button pressed
			
			lw $t1, seltri_y_cnt
			win_goto_select1:
				bne $t1, 0, win_goto_select2
				j start_page_action		# goto main option selected, goto start page
			
			win_goto_select2:
				bne $t1, 1, win_goto_select3
				j level_page_action		# replay option selected, goto level page
			
			win_goto_select3:
				bne $t1, 2, win_page_loop
				j select_page_action	# select level not implemented
		
		win_page_check4:
			bne $t0, 6, win_page_loop	# back button pressed, goto start page
			j start_page_action

		j win_page_loop
		
		
### actions on lose page
lose_page_action:
	jal clearscreen
	
	lw $a0, lose
	jal showpage	# load lose page
	
	li $t1, 0
	sw $t1, seltri_y_cnt
	
	lw $a0, seltri
	lw $a1, seltri_x
	lw $a2, seltri_y
	jal showcomponent	# load seltri component
	
	lose_page_loop:
		
		jal loopforever
		# mainly control the position of the triangle
		
		lw $t0, button_num
		lose_page_check1:
			bne $t0, 1, lose_page_check2	# up button pushed
			
			lw $t1, seltri_y_cnt
			beq $t1, 0, lose_page_loop	# seltri at the top, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, -1
			sw $t1, seltri_y_cnt
			
			lw $a0, seltri
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j lose_page_loop
			
		lose_page_check2:
			bne $t0, 2, lose_page_check3
			
			lw $t1, seltri_y_cnt
			beq $t1, 2, lose_page_loop	# seltri at the bottom, loop again

			lw $a0, mask
			lw $a1, seltri_x
			lw $a2, seltri_y
			lw $t2, seltri_y_delta
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# mask seltri
			
			addi $t1, $t1, 1
			sw $t1, seltri_y_cnt
			
			lw $a0, seltri
			lw $a2, seltri_y
			multiply $t3, $t2, $t1
			add $a2, $a2, $t3
			jal showcomponent	# show seltri in new position
			
			j lose_page_loop
			
		lose_page_check3:
			bne $t0, 5, lose_page_check4
			
			lw $t1, seltri_y_cnt
			lose_goto_select1:
				bne $t1, 0, lose_goto_select2
				j level_page_action
			
			lose_goto_select2:
				bne $t1, 1, lose_goto_select3
				j select_page_action	
			
			lose_goto_select3:
				bne $t1, 2, lose_page_loop
				j start_page_action
		
		lose_page_check4:
			bne $t0, 6, lose_page_loop
			j start_page_action

		j lose_page_loop
		
### actions on help page
help_page_action:
	jal clearscreen
	
	lw $a0, help
	jal showpage	# load help page
	
	help_page_loop:
		jal loopforever
		
		lw $t0, button_num
		help_page_check1:
			bne $t0, 5, help_page_check2	# enter button pushed
			j start_page_action
			
		help_page_check2:
			bne $t0, 6, help_page_loop		# back button pushed
			j start_page_action
		

### clear screen
clearscreen:
	li $v0, 0x22
	li $a0, 1
	sll $a0, $a0, 31
	syscall
	jr $ra
		

### show one page to the screen, args page addr
showpage:
		push $t0
		push $t1
		li $v0, 0x22
		move $t1, $a0
	show_page_loop:
		lw $a0, ($t1)
		addi $t1, $t1, 4
		beq $a0, $zero, show_page_exit
		syscall
		j show_page_loop
	show_page_exit:
		pop $t1
		pop $t0
		jr $ra
	
	
### show one component to the screen, args component a0: addr, a1: x_pos, a2: y_pos
showcomponent:
		push $t1
		push $a1
		push $a2
		li $v0, 0x22
		move $t1, $a0
		sll $a1, $a1, 23
		sll $a2, $a2, 16
	show_component_loop:
		lw $a0, ($t1)
		addi $t1, $t1, 4
		beq $a0, $zero, show_component_exit
		add $a0, $a0, $a1
		add $a0, $a0, $a2
		syscall
		j show_component_loop
	show_component_exit:
		pop $a2
		pop $a1
		pop $t1
		jr $ra
	

### show digits of numbers
showdigits:
		push $ra
		push $a1
		push $a2
		push $t0
		push $t1
		push $t2
		push $t3
		push $t4
		push $t5
		push $t6

		lw $a0, mask
		lw $a1, num_mask_x
		lw $a2, num_mask_y
		jal showcomponent		# first we mask the original digits

		li $t4, 0	# record number of digits in $t0
		li $t5, 0	# record the div of $t0
		lw $t0, current_steps

		bne $t0, 0, calc_steps
		push $zero
		addi $t4, $t4, 1
		j show_steps
	
	calc_steps:
		beq $t0, 0, show_steps
		andi $t1, $t0, 0xf 	# get the least digit
		lt $t1, 10, store_digit
		addi $t1, $t1, -10
	store_digit:
		push $t1
		addi $t4, $t4, 1	
	div_by_10:
		addi $t0, $t0, -10
		ge $t0, $zero, div_condition
		# sub $t3, $zero, $t0
		# blez $t3, div_condition
		add $t0, $zero, $t5
		li $t5, 0
		j calc_steps
	div_condition:
		addi $t5, $t5, 1
		j div_by_10
	
	show_steps:
		li $t5, 0	# counter
		li $t0, 0	# get the digit from stack
		la $t6, zero
		lw $t2, num_x_delta
		lw $a2, num_start_y
	show_one_digit:
		beq $t4, 0, show_digits_exit
		lw $a1, num_start_x
		pop $t0
		multiply $t1, $t0, 4
		add $t7, $t6, $t1	# get addr of digit
		lw $a0, ($t7)
		multiply $t3, $t2, $t5
		add $a1, $a1, $t3
		jal showcomponent	# show digt to screen
		addi $t4, $t4, -1
		addi $t5, $t5, 1
		j show_one_digit	
	show_digits_exit:
		pop $t6
		pop $t5
		pop $t4
		pop $t3
		pop $t2
		pop $t1
		pop $t0
		pop $a2
		pop $a1
		pop $ra
		jr $ra
		

### wait for user event
loopforever:
		push $t0
	loop:
		debug
		lw $t0, button_event	# check is button event shows
		beq $t0, $zero, loop	# button event shows, exit loop
	loopexit:
		li $t0, 0
		sw $t0, button_event
		pop $t0
		jr $ra
	

### get array element by index, a0: array_start_addr, a1: x_index, a2: y_index, s0: array_x_size, s1: array_y_size, v1(output): result
array_get:
		push $a0
		push $t0
		push $t1
		ge $a1, $s0, array_get_error	# x_index out of range
		ge $a2, $s1, array_get_error	# y_index out of range
		lt $a1, $zero, array_get_error	# x_index < 0
		lt $a2, $zero, array_get_error	# y_index < 0
		multiply $t0, $a1, $s1
		add $t0, $t0, $a2
		multiply $t1, $t0, 4
		add $a0, $a0, $t1
		lw $v1, ($a0)
		j array_get_exit
	array_get_error:
		debug
	array_get_exit:
		pop $t1
		pop $t0
		pop $a0
		jr $ra
	
	
### get array element by index, a0: array_start_addr, a1: x_index, a2: y_index, s0: array_x_size, s1: array_y_size, s2: data to set
array_set:
		push $t0
		push $t1
		ge $a1, $s0, array_set_error	# x_index out of range
		ge $a2, $s1, array_set_error	# y_index out of range
		lt $a1, $zero, array_set_error	# x_index < 0
		lt $a2, $zero, array_set_error	# y_index < 0
		multiply $t0, $a1, $s1
		add $t0, $t0, $a2
		multiply $t1, $t0, 4
		add $a0, $a0, $t1
		sw $s2, ($a0)
		j array_set_exit
	array_set_error:
		debug
	array_set_exit:
		pop $t1
		pop $t0
		jr $ra


### show component and set array in game, a0: addr, s2: number to set, t1: x_index, t2: y_index
gamesetcomponent:
	push $ra
	push $a1
	push $a2
	push $s0
	push $s1
	push $s3

	push $s2
	push $a0

	lw $a0, mask
	lw $a1, object_start_x
	lw $a2, object_start_y
	lw $s0, object_x_delta
	lw $s1, object_y_delta
	multiply $s2, $s0, $t2
	multiply $s3, $s1, $t1
	add $a1, $a1, $s2
	add $a2, $a2, $s3
	jal showcomponent		# first we mask the original component

	pop $a0

	jal showcomponent		# then we show the new component

	pop $s2

	la $a0, current_map
	move $a1, $t1
	move $a2, $t2
	lw $s0, mapsize
	lw $s1, mapsize
	jal array_set			# finally we set the array

	pop $s3
	pop $s1
	pop $s0
	pop $a2
	pop $a1
	pop $ra
	jr $ra

### get the detail of the current map, v1(output): addr of the current map
map_get:
	push $t0
	push $t1
	push $t2
	push $t3
	push $t4
	push $t5
	push $t6
	push $t7

	lw $t4, current_level
	level1_map_get:
		bne $t4, 1, level2_map_get
		lw $t0, map1_steps
		la $t1, map1
		lw $t5, map1_player_x
		lw $t6, map1_player_y
		lw $t7, map1_targets
		lw $v1, level1
		j map_setup

	level2_map_get:
		bne $t4, 2, level3_map_get
		lw $t0, map2_steps
		la $t1, map2
		lw $t5, map2_player_x
		lw $t6, map2_player_y
		lw $t7, map2_targets
		lw $v1, level2
		j map_setup

	level3_map_get:
		bne $t4, 3, map_get_exit
		lw $t0, map3_steps
		la $t1, map3
		lw $t5, map3_player_x
		lw $t6, map3_player_y
		lw $t7, map3_targets
		lw $v1, level3

	map_setup:
		sw $t0, current_steps  # set up level map steps
		sw $t5, current_player_x
		sw $t6, current_player_y
		sw $t7, current_targets	# set up level targets

		la $t2, current_map
		li $t3, 81
		copy_map:			   # copy level original map to current_map
			lw $t0, ($t1)
			sw $t0, ($t2)
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, -1
			bne $t3, $zero, copy_map

	map_get_exit:
		pop $t7
		pop $t6
		pop $t5
		pop $t4
		pop $t3
		pop $t2
		pop $t1
		pop $t0
		jr $ra
