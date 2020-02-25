.data
buffer1: .space 20
buffer2: .space 20
buffer3: .space 20
text1: .asciiz "Nhap ngay DAY: "
text2: .asciiz "Nhap thang MONTH: "
text3: .asciiz "Nhap nam YEAR: "
menu: .asciiz "----------Ban hay chon mot trong cac thao tac duoi day-----------\n1. Xuat chuoi Time theo dinh dang DD/MM/YYYY\n2. Chuyen chuoi Time thanh mot trong cac dinh dang:\n  A. MM/DD/YYYY\n  B. Month DD, YYYY\n  C. DD Month, YYYY\n3. Cho biet ngay vua nhap la thu may\n4. Kiem tra nam trong chuoi TIME co phai la nam nhuan\n5. Cho biet khoang thoi gian giua TIME_1 va TIME_2\n6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi TIME\n+ Lua chon: "
result: .asciiz "+ Ket qua : "
format: .asciiz "  Chon kieu dinh dang: "
timeConverted: .space 20
MON: .asciiz 	"Mon"
TUES: .asciiz	"Tues"
WED: .asciiz	"Wed"
THURS: .asciiz	"Thurs"
FRI: .asciiz	"Fri"
SAT: .asciiz	"Sat"
SUN: .asciiz	"Sun"
nLeap: .asciiz  "khong phai la nam nhuan\n"
yLeap: .asciiz  "la nam nhuan\n"
noti: .asciiz "Nhap TIME_2\n"
nam: .asciiz  " nam"
va: .asciiz  " va "
.text
main:
	input_loop:		
	jal input #input 3 strings from screen
	
	jal check_syntax #check syntax of strings inputed (day, month, year)
	beq $v0, $0, input_loop
	
	jal convertToNumber #convert a0, a1, a2 from char* to number
	
	jal check_time #check timing valid
	beq $v0, $0, input_loop
	
	#------------------------------------
	
	#SAVE a0, a1, a2 TO s0, s1, s2 =================
	add $s0, $a0, $0
	add $s1, $a1, $0
	add $s2, $a2, $0
			
	addi $v0, $0, 4 #print out menu
	la $a0, menu
	syscall
	
	#get user input
    	addi $v0, $0, 5
    	syscall
    	add $s3, $v0, $0 # SAVE OPTION TO s3 ================
	
	###create TIME string (example: "23/11/1999")	
	#initial string (char[12])
	addi $sp, $sp, -12
	add $s4, $sp, $0 #STORE ADDRESS OF TIME STRING TO s4 =================
	
	#load data to a0, a1, a2, a3
	add $a0, $s0, $0
	add $a1, $s1, $0
	add $a2, $s2, $0
	add $a3, $s4, $0
	
	jal Date #function to handle option 1
	add $s4, $v0, $0 #update s4
	
	#-------------------------------------
	
	#check option and step to suitable block
	addi $t0, $0, 1
	beq $s3, $t0, option1
	addi $t0, $0, 2
	beq $s3, $t0, option2
	addi $t0, $0, 3
	beq $s3, $t0, option3
	addi $t0, $0, 4
	beq $s3, $t0, option4
	addi $t0, $0, 5
	beq $s3, $t0, option5
	addi $t0, $0, 6
	beq $s3, $t0, option6
	
	#-------------------------------------
	
	####### handle option 1
	option1:
	#print out "+ Ket qua:"
	li $v0, 4
	la $a0, result
	syscall	
	
	#print out TIME string
	addi $v0, $0, 4 
	add $a0, $s4, $0 #copy s4 to a0
	syscall
	j exit
	
	####### handle option 2
	option2:
	#print out "Chon kieu dinh dang: "
	addi $v0, $0, 4
	la $a0, format
	syscall
	
	#get user input
    	addi $v0, $0, 12
    	syscall
    	add $s5, $v0, $0 # SAVE FORMAT OPTION TO s5 ================
    	addi $v0, $0, 12
    	syscall
    		
	#print out "+ Ket qua:"
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	add $a0, $s4, $0 #copy s4 to a0
	add $a1, $s5, $0 #copy s5 to a1
	jal Convert
	
	#print result
	add $a0, $v0, $0
	addi $v0, $0, 4
	syscall
	j exit
	
	####### handle option 3
	option3:
	add $a0, $s4, $0 #copy s4 to a0
	jal Weekday
	add $t0, $v0, $0 #save result
	
	#print out "+ Ket qua:"
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	#print result
	addi $v0, $0, 4
	add $a0, $t0, $0
	syscall
	j exit
	
	####### handle option 4
	option4:
	add $a0, $s4, $0 #copy s4 to a0
	jal LeapYear
	add $t0, $v0, $0 #save result
	
	#print out "+ Ket qua:"
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	#print result
	beq $t0, $0, printNoLeap
	la $a0, yLeap
	li $v0, 4
	syscall 
	j exit
	printNoLeap:
	la $a0, nLeap
	li $v0, 4
	syscall 
	j exit
	
	####### handle option 5
	option5:
	#print out "Nhap TIME_2"
	addi $v0, $0, 4
	la $a0, noti
	syscall
	
	input_loop2:		
	jal input #input 3 strings from screen
	
	jal check_syntax #check syntax of strings inputed (day, month, year)
	beq $v0, $0, input_loop2
	
	jal convertToNumber #convert a0, a1, a2 from char* to number
	
	jal check_time #check timing valid
	beq $v0, $0, input_loop2
	
	###create TIME string (example: "23/11/1999")	
	#initial string (char[12])
	addi $sp, $sp, -12
	add $s5, $sp, $0 #STORE ADDRESS OF TIME_2 STRING TO s5 =================
	
	#load data to a3
	add $a3, $s5, $0
	
	jal Date #function to handle option 1
	add $s5, $v0, $0 #update s5
	
	#print out "+ Ket qua:"
	addi $v0, $0, 4
	la $a0, result
	syscall	
	
	add $a0, $s4, $0
	add $a1, $s5, $0
	jal GetTime
	
	#print result
	add $a0, $v0, $0
	addi $v0, $0, 1
	syscall
	
	addi $v0, $0, 4
	la $a0, nam
	syscall
	
	addi $sp, $sp, 12 #restock the stack
	j exit
	
	####### handle option 6
	option6:
	add $a0, $s4, $0 #copy s4 to a0
	jal Year
	
	add $a0, $v0, $0 #copy result to a0
	jal TwoNearestLeapYear
	
	add $t0, $v0, $0 #first year
	add $t1, $v1, $0 #second year
	
	#print out "+ Ket qua:"
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	#print result
	addi $v0, $0, 1
	add $a0, $t0, $0
	syscall
	
	addi $v0, $0, 4 #print out " va "
	la $a0, va 
	syscall
	
	addi $v0, $0, 1
	add $a0, $t1, $0
	syscall
	j exit
	
	exit:
	addi $sp, $sp, 12 #restore the stack
	addi $v0, $0, 10 #End Program
	syscall

TwoNearestLeapYear:
	# Get two nearest leap year with year input
	# $a0 - year input
	# return: $v0, $v1
	# $v0 < $a0 < $v1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	add $t0, $a0, $zero # input = a0
	add $v0, $a0, $zero # x = a0
	add $v1, $a0, $zero # y = a0
	
	addi $t1, $zero, 1 # i = 1
	
	tnly_loop_1:
	beq $t1, 9, tnly_stop_1 # if (i != 9)
	bne $v0, $t0, tnly_stop_1 # if (x == input)

	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $v0, 8($sp)
	sw $v1, 12($sp)
	
	sub $a0, $t0, $t1 # a0 = input - i
	jal isLeapYear
	beq $v0, 0, tnly_endif_1 # if (LeapYear(input - i))
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	sub $v0, $t0, $t1 # x = input - i
	j tnly_endif_2
	
	tnly_endif_1:
	lw $v0, 8($sp)
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	
	tnly_endif_2:
	lw $v1, 12($sp)
	addi $sp, $sp, 16
	addi $t1, $t1, 1 # i = i + 1
	j tnly_loop_1
	
	tnly_stop_1:

	addi $t1, $zero, 1 # i = 1
	
	tnly_loop_2:
	beq $t1, 9, tnly_stop_2 # if (i != 9)
	bne $v1, $t0, tnly_stop_2 # if (y == input)
		
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $v0, 8($sp)
	sw $v1, 12($sp)
		
	add $a0, $t0, $t1 # a0 = input + i
	jal isLeapYear
	beq $v0, 0, tnly_endif_3 # if (LeapYear(input + i))
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	add $v1, $t0, $t1 # y = input + i
	j tnly_endif_4
	
	tnly_endif_3:
	lw $v1, 12($sp)
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	
	tnly_endif_4:
	lw $v0, 8($sp)
	addi $sp, $sp, 16
	addi $t1, $t1, 1 # i = i + 1
	j tnly_loop_2
	
	tnly_stop_2:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
#return year difference between 2 TIME string
GetTime:
	#Cat bien a0 vao stack vi minh gan a0 = a1 de goi ham
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	#Dung 6 o nho cua stack de luu 6 bien dd,mm,yy cua 2 chuoi TIME
	addi $sp, $sp, -24
	jal Day
	sw $v0, 0($sp)
	jal Month
	sw $v0, 4($sp)
	jal Year
	sw $v0, 8($sp)
	
	#Gan a0 = a1
	addi $a0, $a1, 0

	jal Day
	sw $v0, 12($sp)
	jal Month
	sw $v0, 16($sp)
	jal Year
	sw $v0, 20($sp)
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	
	addi $sp, $sp, 24
	
	#tra lai a0
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	
	sub $t6, $t2, $t5
	#Gan t5 = 1, vi khong dung den nam nua
	addi $t5, $0, 1
	
	#$t6 = hieu cua 2 nam  
	beq $t6, $0, return0
	addi $t7, $0, 0
	slt $t7, $t7, $t6 #if hieu duong
	beq $t7, $0, negative
	slt $t7, $t4, $t1 #if thang time2 < thang time1
	beq $t7, $t5, return0
	#thang time1 >= thang time2
	slt $t7, $t1, $t4 #if thang time1 < thang time2
	beq $t7, $t5, return_1
	#neu thang bang nhau 
	slt $t7, $t0, $t3 #if ngay time1 < ngay time2
	beq $t7, $t5, return_1
	jal return0
	
	negative:
	#lam nguoc lai 
	addi $t7, $0, -1
	mul $t6, $t6, $t7
	slt $t7, $t1, $t4 #if thang time1 < thang time2
	beq $t7, $t5, return0
	#thang 2 >= thang 1
	slt $t7, $t4, $t1 #if thang time2 < thang time1
	beq $t7, $t5, return_1
	#neu thang bang nhau 
	slt $t7, $t3, $t0 #if ngay time2 < ngay time1
	beq $t7, $t5, return_1
	jal return0

	return0:
	add $v0, $0, $t6
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	return_1:
	lw $ra, 0($sp)
	addi $sp, $sp, 4 
	addi $v0, $t6, -1
	jr $ra
	
LeapYear:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	jal Year
	
	addi $a0, $v0, 0
	addi $t0, $0, 400
	div $a0, $t0
	mfhi $t0
	#set Hi to ($s0)mod($s1)
	# and Lo to ($s0)/($s1)
	 
	beq $t0, $0, true
	# year % 4
	addi $t0, $0, 4
	div $a0, $t0
	mfhi $t0

	bne $t0, $0, false 
	# year % 100
	addi $t0, $0, 100
	div $a0, $t0
	mfhi $t0
	bne $t0, $0, true
	j false
	
	false:
	lw $a0, 0($sp)
	lw $ra, 4($sp) 
	addi $sp, $sp, 8 
	addi $v0, $0, 0
	jr $ra
	
	true:
	lw $a0, 0($sp)
	lw $ra, 4($sp) 
	addi $sp, $sp, 8 
	addi $v0, $0, 1
	jr $ra
	
Weekday:
	#tach chuoi date thanh ngay thang nam luu vao t0 t1 t2 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -12
	jal Day
	sw $v0, 0($sp)
	jal Month
	sw $v0, 4($sp)
	jal Year
	sw $v0, 8($sp)
	
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	
	addi $sp, $sp, 12
	
	#(day + ((153 * (month + 12 * ((14 - month) / 12) - 3) + 2) / 5)
	addi $t3, $0, 14 # s3 = 14
	addi $t4, $0, 0 # t4 = 0
	sub $t4, $t3, $t1 # t4 = 14 - month
	div $t4, $t4, 12 # t4 = (14 - month)/12
	addi $t3, $0, 12 
	mul $t5,$t4,$t3
	addi $t5, $t5, -3
	add $t5, $t5, $t1
	addi $t3, $0, 153
	mul $t5,$t5,$t3
	addi $t5, $t5, 2
	div $t5, $t5, 5
	add $t5, $t5, $t0
	#(365 * (year + 4800 - ((14 - month) / 12))) +
	addi $t6, $t2, 4800
	sub $t6, $t6, $t4
	addi $t3, $0, 365
	mul $t6, $t6, $t3
	add $t5, $t5, $t6
	#((year + 4800 - ((14 - month) / 12)) / 4) -
	addi $t6, $t2, 4800
	sub $t6, $t6, $t4
	div $t6, $t6, 4
	add $t5, $t5, $t6
	#((year + 4800 - ((14 - month) / 12)) / 100) + 
	addi $t6, $t2, 4800
	sub $t6, $t6, $t4
	div $t6, $t6, 100
	sub $t5, $t5, $t6
	#((year + 4800 - ((14 - month) / 12)) / 400)  - 32045) % 7
	addi $t6, $t2, 4800
	sub $t6, $t6, $t4
	div $t6, $t6, 400
	add $t5, $t5, $t6 
	subi $t5, $t5, 32045
	addi $t3, $0, 7
	#Lay ngay % 7
	div $t5, $t3
	mfhi $t5 #so du
	
	#So sanh va return
	addi $t3, $0, 0
	beq $t5,$t3, Mon
	addi $t3, $0, 1
	beq $t5,$t3, Tues
	addi $t3, $0, 2
	beq $t5,$t3, Wed
	addi $t3, $0, 3
	beq $t5,$t3, Thurs
	addi $t3, $0, 4
	beq $t5,$t3, Fri
	addi $t3, $0, 5
	beq $t5,$t3, Sat
	addi $t3, $0, 6
	beq $t5,$t3, Sun
	
	Mon:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, MON
	jr $ra
	
	Tues:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, TUES
	jr $ra
	
	Wed:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, WED
	jr $ra
	
	Thurs:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, THURS
	jr $ra
	
	Fri:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, FRI
	jr $ra
	
	Sat:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, SAT
	jr $ra
	
	Sun:
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	la $v0, SUN
	jr $ra

Convert:
	la $v0, timeConverted
	
	addi $t0, $0, 65
	beq $a1, $t0, convertA
	addi $t0, $0, 66
	beq $a1, $t0, convertB
	addi $t0, $0, 67
	beq $a1, $t0, convertC
	
	convertA:
	#save month
	lb $t0, 3($a0)
	lb $t1, 4($a0)
	lb $t2, 5($a0)	
	sb $t0, 0($v0)
	sb $t1, 1($v0)
	sb $t2, 2($v0)
	
	#save day
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	lb $t2, 2($a0)	
	sb $t0, 3($v0)
	sb $t1, 4($v0)
	sb $t2, 5($v0)
	
	#save year
	lb $t0, 6($a0)
	lb $t1, 7($a0)
	lb $t2, 8($a0)
	lb $t3, 9($a0)
	lb $t4, 10($a0)	
	sb $t0, 6($v0)
	sb $t1, 7($v0)
	sb $t2, 8($v0)
	sb $t3, 9($v0)
	sb $t4, 10($v0)
	jr $ra
	
	convertB:
	#save month
	lb $t0, 3($a0)
	lb $t1, 4($a0)
	sb $t0, 0($v0)
	sb $t1, 1($v0)

	addi $t2, $0, 32
	sb $t2, 2($v0)
	
	#save day
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	sb $t0, 3($v0)
	sb $t1, 4($v0)
	
	addi $t2, $0, 44
	sb $t2, 5($v0)
	addi $t3, $0, 32
	sb $t3, 6($v0)
	
	#save year
	lb $t0, 6($a0)
	lb $t1, 7($a0)
	lb $t2, 8($a0)
	lb $t3, 9($a0)
	lb $t4, 10($a0)	
	sb $t0, 7($v0)
	sb $t1, 8($v0)
	sb $t2, 9($v0)
	sb $t3, 10($v0)
	sb $t4, 11($v0)
	jr $ra
	
	convertC:
	#save day
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	sb $t0, 0($v0)
	sb $t1, 1($v0)

	addi $t2, $0, 32
	sb $t2, 2($v0)
	
	#save day
	lb $t0, 3($a0)
	lb $t1, 4($a0)
	sb $t0, 3($v0)
	sb $t1, 4($v0)
	
	addi $t2, $0, 44
	sb $t2, 5($v0)
	addi $t3, $0, 32
	sb $t3, 6($v0)
	
	#save year
	lb $t0, 6($a0)
	lb $t1, 7($a0)
	lb $t2, 8($a0)
	lb $t3, 9($a0)
	lb $t4, 10($a0)	
	sb $t0, 7($v0)
	sb $t1, 8($v0)
	sb $t2, 9($v0)
	sb $t3, 10($v0)
	sb $t4, 11($v0)
	jr $ra
	
#function to handle option 1
#input: a0, a1, a2 = day, month, year (in number). a3 stores address of TIME string
#output: v0 stores address of new TIME string
Date:
	#day to string
	addi $t0, $0, 10
	div $a0, $t0 # example a0 = 23
	mfhi $t2 #t2 = 3
	mflo $t1 #t1 = 2
	
	addi $t1, $t1, 48
	sb $t1, 0($a3) 
	addi $t2, $t2, 48
	sb $t2, 1($a3)
	  
	#add slash
	addi $t0, $0, 47
	sb $t0, 2($a3)
	
	#month to string
	addi $t0, $0, 10
	div $a1, $t0 # example a1 = 12
	mfhi $t2 #t2 = 2
	mflo $t1 #t1 = 1
	
	addi $t1, $t1, 48
	sb $t1, 3($a3) 
	addi $t2, $t2, 48
	sb $t2, 4($a3)
	
	#add slash
	addi $t0, $0, 47
	sb $t0, 5($a3)
	
	#year to string
	addi $t0, $0, 1000
	div $a2, $t0 # example: a2 = 1234
	mfhi $a2 #a2 = 234
	mflo $t1 #t1 = 1
	addi $t1, $t1, 48
	sb $t1, 6($a3)
	
	addi $t0, $0, 100
	div $a2, $t0 # a2 = 234
	mfhi $a2 #a2 = 34
	mflo $t1 #t1 = 2
	addi $t1, $t1, 48
	sb $t1, 7($a3)
	
	addi $t0, $0, 10
	div $a2, $t0 # a2 = 34
	mfhi $t2 #t2 = 4
	mflo $t1 #t1 = 3
	
	addi $t1, $t1, 48
	sb $t1, 8($a3) 
	addi $t2, $t2, 48
	sb $t2, 9($a3)
	
	sb $0, 10($a3) #end of string
	
	add $v0, $a3, $0
	jr $ra
	
Day:
	# extract day from TIME string
	# a0 stores TIME string inputed, v0 is result
	lb $v0, 0($a0)
	addi $v0, $v0, -48 # res = date[0] - 48
	
	lb $t0, 1($a0)
	addi $t0, $t0, -48
	mul $v0, $v0, 10
	add $v0, $v0, $t0 # res = res * 10 + date[1] - 48
	jr $ra
	
Month:
	# extract month from TIME string
	# a0 stores TIME string inputed, v0 is result
	lb $v0, 3($a0)
	addi $v0, $v0, -48 # res = date[3] - 48
	
	lb $t0, 4($a0)
	addi $t0, $t0, -48
	mul $v0, $v0, 10
	add $v0, $v0, $t0 # res = res * 10 + date[4] - 48
	jr $ra
	
Year:
	# extract year from TIME string
	# a0 stores TIME string inputed, v0 is result
	lb $v0, 6($a0)
	addi $v0, $v0, -48 # res = date[6] - 48
	
	lb $t0, 7($a0)
	addi $t0, $t0, -48
	mul $v0, $v0, 10
	add $v0, $v0, $t0 # res = res * 10 + date[7] - 48
	
	lb $t0, 8($a0)
	addi $t0, $t0, -48
	mul $v0, $v0, 10
	add $v0, $v0, $t0 # res = res * 10 + date[8] - 48
	
	lb $t0, 9($a0)
	addi $t0, $t0, -48
	mul $v0, $v0, 10
	add $v0, $v0, $t0 # res = res * 10 + date[9] - 48
	jr $ra

#convert a0, a1, a2 from char* to number
convertToNumber:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	
	jal toNumber #convert a0
	sw $v0, 4($sp)
	
	add $a0, $a1, $0
	jal toNumber #convert a1
	sw $v0, 8($sp)
	
	add $a0, $a2, $0
	jal toNumber #convert a2
	sw $v0, 12($sp)
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

#convert a0 from char* to number	
toNumber:
	addi $t0, $a0, -1 #t0 = a0 - 1, save address
	add $v0, $0, $0 #result
	
	loop_tonumber:
	addi $t0, $t0, 1 #increase t0, in primary t0 = a0
	lb $t1, 0($t0) #load byte to t1 
	 
	addi $t2, $0, 10
	beq $t1, $t2, end #if t1 == 10 (end of line) goto end
	
	mult $v0, $t2
	mflo $v0 #v0 = v0*10
	addi $t3, $t1, -48
	add $v0, $v0, $t3 #v0 = v0 + new number
	
	beq $0, $0, loop_tonumber #goto loop
	
	end:
	jr $ra

#check the valid of time, inputs are number (a0, a1, a2)
check_time:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t2, $0, 13 #check if month < 13
	slt $t3, $a1, $t2 #t3 = a1 < 13
	beq $t3, $0, false_checktime #if t3 == 0 goto false
	beq $a1, $0, false_checktime #if a1 == 0 goto false
	
	addi $t1, $0, 1
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 2
	beq $a1, $t1, check28_checkTime
	addi $t1, $0, 3
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 4
	beq $a1, $t1, check30_checkTime
	addi $t1, $0, 5
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 6
	beq $a1, $t1, check30_checkTime
	addi $t1, $0, 7
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 8
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 9
	beq $a1, $t1, check30_checkTime
	addi $t1, $0, 10
	beq $a1, $t1, check31_checkTime
	addi $t1, $0, 11
	beq $a1, $t1, check30_checkTime
	addi $t1, $0, 12
	beq $a1, $t1, check31_checkTime
	
	check31_checkTime:
	addi $t1, $0, 32
	slt $t2, $a0, $t1 #t2 = a0 (day) < 32
	bne $t2, $0, true_checktime #if a0 < 32 goto true_checktime
	j false_checktime
	
	check30_checkTime:
	addi $t1, $0, 31
	slt $t2, $a0, $t1 #t2 = a0 (day) < 31
	bne $t2, $0, true_checktime #if a0 < 31 goto true_checktime
	j false_checktime
	
	check28_checkTime:
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	move $a0, $a2
	jal isLeapYear
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	bne $v0, $0, check28_leapyear #if year is leap goto check28_leapyear
	
		check28_unleapyear:
		addi $t1, $0, 29
		slt $t2, $a0, $t1 #t2 = a0 (day) < 29
		bne $t2, $0, true_checktime #if a0 < 29 goto true_checktime
		j false_checktime
	
		check28_leapyear:
		addi $t1, $0, 30
		slt $t2, $a0, $t1 #t2 = a0 (day) < 30
		bne $t2, $0, true_checktime #if a0 < 30 goto true_checktime
		j false_checktime

	true_checktime:
	addi $v0, $0, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	false_checktime:
	add $v0, $0, $0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#check if this year (number) is a leapyear	
isLeapYear:
	addi $t0, $0, 400
	div $a0, $t0
	mfhi $t0 #set Hi to ($a0 mod $t0), set Lo to ($a0 / $t0) 
	beq $t0, $0, true_leapyear
	
	#year % 4
	addi $t0, $0, 4
	div $a0, $t0
	mfhi $t0
	bne $t0, $0, false_leapyear
	
	#year % 100
	addi $t0, $0, 100
	div $a0, $t0
	mfhi $t0
	bne $t0, $0, true_leapyear
	j false_leapyear
	
	false_leapyear:
	addi $v0, $0, 0
	jr $ra
	
	true_leapyear:
	addi $v0, $0, 1
	jr $ra
	
#check syntax of strings inputed (day, month, year)
check_syntax:
	addi $v0, $0, 1
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	#check $a0
	jal check_string
	
	#check $a1
	add $a0, $a1, $0
	jal check_string
	
	#check $a2
	add $a0, $a2, $0
	jal check_string
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

#check syntax of each string (example: '11' is valid, '1a' is invalid	
check_string:
	addi $t0, $a0, -1 #t0 = a0 - 1
	
	loop_checkstring:
	addi $t0, $t0, 1 #increase t0, in primary t0 = a0
	lb $t1, 0($t0) #load byte to t1 
	 
	addi $t2, $0, 10
	beq $t1, $t2, true_cs #if t1 == 10 (end of line) goto true
	
	addi $t2, $0, 48 
	slt $t3, $t1, $t2 #t3 = t1 < 48
	bne $t3, $0, false_cs #if t3 == 1 goto false
	
	addi $t2, $0, 58
	slt $t3, $t1, $t2 #t3 = t1 < 58
	beq $t3, $0, false_cs #if t3 == 0 goto false
	
	beq $0, $0, loop_checkstring #goto loop
	
	true_cs:
	jr $ra

	false_cs:
	add $v0, $0, $0
	jr $ra
	
#input 3 strings from screen
input:	
	addi $v0, $0, 4 #print out the text1
	la $a0, text1
	syscall
	
    	addi $v0, $0, 8 #Get user input
    	la $a0, buffer1  #load byte space into address
  	addi $a1, $0, 20     #allot the byte space for string

   	add $t0, $a0, $0   #save string to t0
    	syscall

	addi $v0, $0, 4 #print out the text2
	la $a0, text2
	syscall
	
    	addi $v0, $0, 8 #Get user input
    	la $a0, buffer2  #load byte space into address
  	addi $a1, $0, 20   #allot the byte space for string

   	add $t1, $a0, $0   #save string to t1
    	syscall
    	
    	addi $v0, $0, 4 #print out the text3
	la $a0, text3
	syscall
	
    	addi $v0, $0, 8 #Get user input
    	la $a0, buffer3  #load byte space into address
  	addi $a1, $0, 20     #allot the byte space for string
  	
   	add $t2, $a0, $0  #save string to t2
    	syscall

	#copy to $a0, $a1, $a2
	add $a0, $t0, $0
	add $a1, $t1, $0
	add $a2, $t2, $0
	
	jr $ra
