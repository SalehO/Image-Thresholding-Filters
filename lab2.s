                        Data Section
.data

#
# Fill in your name, student ID in the designated sections.
#
student_name: .asciiz "Omar Saleh"
student_id: .asciiz "000000"

filter_blur: .word 1, 2, 1, 2, 4, 2, 1, 2, 1
filter_dilate: .word 0, 1, 0, 1, 1, 1, 0, 1, 0
filter_sharpening: .word 0, -1, 0, -1, 5, -1, 0, -1, 0
filter_sobel_x: .word 1, 0, -1, 2, 0, -2, 1, 0, -1
filter_no_change: .word 0, 0, 0, 0, 1, 0, 0, 0, 0

input_1: .byte 100, 60, 81, 2
input_2: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
input_3: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55

output_1: .space 4
output_2: .space 9
output_3: .space 16

# thresh value = 128
test_11_expected_output: .byte 0, 0, 0, 0
test_12_expected_output: .byte 0, 0, 0, 0, 0, 255, 255, 255, 255
test_13_expected_output: .byte 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0


# scale = 4
test_filter_1: .word 1, 2, 1, -1, -2, -1, 1, 2, 1
test_21_expected_output: .byte 100, 60, 81, 2
test_22_expected_output: .byte 10, 20, 30, 110, 116, 130, 210, 220, 230
test_23_expected_output: .byte 0, 10, 20, 30, 40, 108, 116, 130, 140, 150, 107, 230, 240, 250, 255, 55


new_line: .asciiz "\n"
space: .asciiz " "

i_str: .asciiz "Program input: " 
po_str: .asciiz "Program output: " 
eo_str: .asciiz "Expected output: " 
t1_str: .asciiz "Testing part 1: \n" 
t2_str: .asciiz "Testing part 2: \n" 

#
# Set these variables to point to the right files on your computer
#


fin: .asciiz "/Users/omarh/Downloads/lab2/lab2/lenna.pgm"
fout_thresh: .asciiz "/Users/omarh/Downloads/lab2/lab2/lenna_thresh.pgm"
fout_filter: .asciiz "/Users/omarh/Downloads/lab2/lab2/lenna_filtered.pgm"


.align 2
in_buffer: .space 400000
in_buffer_end:
.align 2
out_buffer: .space 400000
out_buffer_end:

###############################################################
#                           Text Section
.text
# Utility function to print byte arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lb $a0, ($t2)
andi $a0, $a0, 0xff
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1
addi $t1, $t1, 1
blt $t1, $a1, print



jr $ra
###############################################################
###############################################################
#                       PART 1 (Image thresholding)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension
#a3: threshold value
###############################################################
threshold:
############################## Part 1: your code begins here ###

mult	$a2, $a2			# $t0 * $t1 = Hi and Lo registers
mflo	$t1					# copy Lo to $t2

# t1 has end of loop value
li		$t3, 0xFF		# t3 = 
li      $t4, 0x00
li $t7,1
BeginingOfWhile:
blez $t1, EndOfWhile
lbu		$t2, 0($a0)		
blt		$t2, $a3, less	# if $t2 < $t1 then target
#li $a3,0xff
sb		$t3, 0($a1)		# 
b end

less:
#li $a3,0x00

sb		$t4, 0($a1)		# 
b end
sub		$t0, $t1, $t2		# $t0 = $t1 - $t2

end:
sub $t1, $t1 ,$t7
addi	$a0, $a0, 1	
addi	$a1, $a1, 1			# $a1 = a1, 1 0

b		BeginingOfWhile			# branch to BeginingOfWhile

EndOfWhile:







# 








############################## Part 1: your code ends here ###
jr $ra
###############################################################
###############################################################
#                           PART 2 (Filters)
#a0: input buffer address
#a1: output buffer address
#a2: kernel (3x3) address
#a3: scale
#s0: image dimension
###############################################################
conv_filter:
############################### Part 2: your code begins here ##

##reset registers from previous codeS
move $t0,$zero #reset 
move $t1,$zero #reset 
move $t7,$zero #reset 
move $s1,$zero #reset 
move $s2,$zero #reset 
move $s3,$zero #reset 
move $s4,$zero #reset 
move $s5,$zero #reset 
move $s6,$zero #reset 
move $s7,$zero #reset 
move $t5,$zero #reset 
move $t3,$zero #reset 
move $t6,$zero #reset
move $t2,$zero #reset 
move $t9,$zero #reset 
li $t4, 1

move $s4, $a3
addiu   $s2, $zero,0#col
addiu $s1, $zero,0 #row
move    $t1, $a1 # output
move    $t0, $a0 #input 
loop:

beqz     $s2, edge #check for edge cells
beqz    $s1, edge 
beq     $s2, $s3, edge 
beq     $s1, $s3, edge 
b new

body:
li $t4, 1
bgt    $t3, $t7 nextMove
sub    $s3, $s2, $t4 
mult   $t3, $s0 
mflo   $s5
addu  $s3, $s5, $s3 # offset 
addu   $s3, $a0, $s3 # element address

lbu    $s3, 0($s3) 

addiu $t5, $t5, 4 # filter address
lw   $s5, 0($t5) 
mult  $s5,  $s3 #repeat for the rest
mflo    $s5
addu    $t6, $t6, $s5 
sub     $s3,  $s2,  $t4 
addu  $s3, $s3, $t4 
mult    $t3, $s0 
mflo    $s5

li $t4, 1
add    $s3, $s5, $s3 
add   $s3,  $a0, $s3 
lbu $s3, 0($s3) 
addiu $t5, $t5, 4 
lw      $s5 0($t5) 
mult    $s5, $s3 
mflo    $s5

addu    $t6, $t6, $s5 
sub     $s3, $s2, $t4 #error from here
addi $s3, $s3, 2 
mult    $t3, $s0  
mflo    $s5 #   mflo
addu    $s3, $s5, $s3 
addu $s3, $a0, $s3

lbu     $s3, 0($s3) 
addi    $t5, $t5, 4 

lw      $s5 0($t5) 
mult    $s5, $s3 
mflo    $s5
li $t4, 1

addu    $t6, $t6, $s5 
addu    $t3, $t3, $t4 
b body

new:
li $t4, 1
sub $t3, $s1, $t4 
addu $t7, $s1, $t4 
b body

edge: 
li $t4,1
lbu     $s3, 0($t0)
sb $s3, 0($t1)
addu    $t1, $t1, $t4 
addu     $s2, $s2, $t4 
addu  $t0, $t0, $t4 
b target1
target1: 

li $t4, 1

sub     $s3, $s0, $t4 
bgt     $s1, $s3, endOfPixels 
addiu $t6,$zero,0 #reset t6
addi $t5, $a2, -4 
bgt $s2, $s3, target 
b loop
target:
li $t4,1
addu     $s1, $s1, $t4 
addiu  $s2, $zero, 0
b target1
nextMove:
div     $t6, $t6, $s4
sb      $t6, 0($t1)
li $t4,1
addu    $s2, $s2, $t4 
addu    $t1, $t1, $t4 
addu    $t0, $t0, $t4 
b target1




endOfPixels:

#calculate offset
############################### Part 2: your code ends here  ##
jr $ra
###############################################################
###############################################################
#                          Main Function
main:

.text

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall


# Test threshold function
li $v0, 4
la $a0, t1_str
syscall



la $a0, input_1
la $a1, output_1
li $a2, 2
li $a3, 128
jal threshold


la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall


la $a0, eo_str
syscall
la $a0, test_11_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_2
la $a1, output_2
li $a2, 3
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_12_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall



la $a0, input_3
la $a1, output_3
li $a2, 4
li $a3, 128
jal threshold


la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_13_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# Test filter function

li $v0, 4
la $a0, t2_str
syscall


li $s0, 2 # dim
la $a0, input_1
la $a1, output_1
la $a2, test_filter_1
li $a3, 16
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_21_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall



li $s0, 3 # dim
la $a0, input_2
la $a1, output_2
la $a2, test_filter_1
li $a3, 4
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_22_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall




li $s0, 4 # dim
la $a0, input_3
la $a1, output_3
la $a2, test_filter_1
li $a3, 4
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_23_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)



# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 512
li $a3, 40
jal threshold 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_thresh      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor


# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

# Test conv 1
li $s0, 512 # dim
la $a0, in_buffer
add $a0, $a0, 16
la $a1, out_buffer
add $a1, $a1, 16
la $a2, filter_dilate
li $a3, 5
jal conv_filter 



#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_filter      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor


# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file

_end:
# end program
li $v0, 10
syscall
