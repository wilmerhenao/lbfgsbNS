!                                                                                      
!  L-BFGS-B is released under the “New BSD License” (aka “Modified BSD License”        
!  or “3-clause license”)                                                              
!  Please read attached file License.txt                                               
!                                        
!                             DRIVER 3  in Fortran 90
!     --------------------------------------------------------------
!            TIME-CONTROLLED DRIVER FOR L-BFGS-B 
!     --------------------------------------------------------------
!
!        L-BFGS-B is a code for solving large nonlinear optimization
!             problems with simple bounds on the variables.
!
!        The code can also be used for unconstrained problems and is
!        as efficient for these problems as the earlier limited memory
!                          code L-BFGS.
!
!        This driver shows how to terminate a run after some prescribed
!        CPU time has elapsed, and how to print the desired information 
!        before exiting.
!
!     References:
!
!        [1] R. H. Byrd, P. Lu, J. Nocedal and C. Zhu, ``A limited
!        memory algorithm for bound constrained optimization'',
!        SIAM J. Scientific Computing 16 (1995), no. 5, pp. 1190--1208.
!
!        [2] C. Zhu, R.H. Byrd, P. Lu, J. Nocedal, ``L-BFGS-B: FORTRAN
!        Subroutines for Large Scale Bound Constrained Optimization''
!        Tech. Report, NAM-11, EECS Department, Northwestern University,
!        1994.
!
!
!          (Postscript files of these papers are available via anonymous
!           ftp to eecs.nwu.edu in the directory pub/lbfgs/lbfgs_bcm.)
!
!                              *  *  *
!
!         February 2011   (latest revision)
!         Optimization Center at Northwestern University
!         Instituto Tecnologico Autonomo de Mexico
!
!         Jorge Nocedal and Jose Luis Morales
!
!     **************

program driver

  !     This time-controlled driver shows that it is possible to terminate
  !     a run by elapsed CPU time, and yet be able to print all desired
  !     information. This driver also illustrates the use of two
  !     stopping criteria that may be used in conjunction with a limit
  !     on execution time.

  implicit none

  !     We specify a limit on the CPU time (tlimit = 10 seconds)
  !
  !     We suppress the default output (iprint = -1). The user could 
  !       also elect to use the default output by choosing iprint >= 0.)
  !     We suppress the code-supplied stopping tests because we will
  !       provide our own termination conditions
  !     We specify the dimension n of the sample problem and the number
  !        m of limited memory corrections stored. 
  
  integer,  parameter    :: n = 10, m = 7, iprint = -1
  integer,  parameter    :: dp = kind(1.0d0)
  real(dp), parameter    :: factr  = 0.0d0, pgtol  = 0.0d0, &
       tlimit = 10.0d0
  !
  character(len=60)      :: task, csave
  logical                :: lsave(4)
  integer                :: isave(46)
  real(dp)               :: f, r
  real(dp)               :: dsave(29)
  integer,  allocatable  :: nbd(:), iwa(:)
  real(dp), allocatable  :: x(:), l(:), u(:), g(:), wa(:)
  !
  real(dp)               :: t1, t2, time1, time2, a, b, c, d, p, q, y, tt2, tt3
  integer                :: i, j
  
  allocate ( nbd(n), x(n), l(n), u(n), g(n) )
  allocate ( iwa(3*n) )
  allocate ( wa(4*m*n + 5*n + 11*m*m + 8*m) )
  
  !     This time-controlled driver shows that it is possible to terminate
  !     a run by elapsed CPU time, and yet be able to print all desired
  !     information. This driver also illustrates the use of two
  !     stopping criteria that may be used in conjunction with a limit
  !     on execution time. The sample problem used here is the same as in 
  !     driver1 and driver2 (the extended Rosenbrock function with bounds 
  !     on the variables).
  
  !     We now specify nbd which defines the bounds on the variables:
  !                    l   specifies the lower bounds,
  !                    u   specifies the upper bounds. 
  
  !     First set bounds on the odd-numbered variables.
  
  do 10 i=1, n,2
     nbd(i)=2
     l(i)=-1.0d2
     u(i)=1.0d2
10   continue
     
     !     Next set bounds on the even-numbered variables.
     
     do 12 i=2, n,2
        nbd(i)=2
        l(i)=0d0
        u(i)=0.5d0
12      continue
        
        !     We now define the starting point.

        do 14 i=1, n
           x(i)=0.4d0
14         continue
!        x(1) = 0.5d0
!x(2) = 0.6d0
!x(3) = 0.7d0
           !     We now write the heading of the output.

     write (6,16)
16   format(/,5x, 'Solving sample problem.',&
          /,5x, ' (f = 0.0 at the optimal solution.)',/) 

     !     We start the iteration by initializing task.

     task = 'START'
     
     !        ------- the beginning of the loop ----------

     !     We begin counting the CPU time.

     call timer(time1)

     do while( task(1:2).eq.'FG'.or.task.eq.'NEW_X'.or. &
          task.eq.'START')

        !     This is the call to the L-BFGS-B code.

        call setulb(n,m,x,l,u,nbd,f,g,factr,pgtol,wa,iwa, &
             task,iprint, csave,lsave,isave,dsave)
        if (task(1:2) .eq. 'FG') then

                 !        the minimization routine has returned to request the
                 !        function f and gradient g values at the current x.
                 !        Before evaluating f and g we check the CPU time spent.

           call timer(time2)
           if (time2-time1 .gt. tlimit) then
              task='STOP: CPU EXCEEDING THE TIME LIMIT.'

              !          Note: Assigning task(1:4)='STOP' will terminate the run;
              !          setting task(7:9)='CPU' will restore the information at
              !          the latest iterate generated by the code so that it can
              !          be correctly printed by the driver.
              
              !          In this driver we have chosen to disable the
              !          printing options of the code (we set iprint=-1);
              !          instead we are using customized output: we print the
              !          latest value of x, the corresponding function value f and
              !          the norm of the projected gradient |proj g|.
              
              !          We print out the information contained in task.
              
              write (6,*) task
              
              !          We print the latest iterate contained in wa(j+1:j+n), where
              
              j = 3*n+2*m*n+11*m**2
              write (6,*) 'Latest iterate X ='
              write (6,'((1x,1p, 6(1x,d11.4)))') (wa(i),i = j+1,j+n) 
              
              !          We print the function value f and the norm of the projected
              !          gradient |proj g| at the last iterate; they are stored in
              !          dsave(2) and dsave(13) respectively.
              
              write (6,'(a,1p,d12.5,4x,a,1p,d12.5)') &
                   'At latest iterate   f =',dsave(2),'|proj g| =',dsave(13)
           else
              
              !          The time limit has not been reached and we compute
              !          the function value f for the sample problem.
              
              f=0.0D+00
              do 1823 i =1, n
                 g(i) = 0d0
1823          continue

              do 1844 i=1, n-1
                 a=abs(x(i))
                 b=abs(x(i+1))
                 c=x(i)**2+1d0
                 d=x(i+1)**2+1d0
                 f=f+b**c+a**d
                 p=0d0
                 q=0d0
                 if(x(i).lt.0d0) then
                    if(b.gt.p) then
                       p=log(b)
                    endif
                    g(i)=g(i)-d*a**(d-1d0)+2d0*x(i)*p*b**c
                 else
                    if(b.gt.p) then
                       p=log(b)
                    endif
                    g(i)=g(i)+d*a**(d-1d0)+2d0*x(i)*p*b**c
                 endif
                 if(x(i+1).eq.0d0) then
                    g(i+1)=0d0
                 else if(x(i+1).lt.0d0) then
                    if(a.gt.q) then
                       q=log(a)
                    endif
                    g(i+1)=-c*b**(c-1d0)+2d0*x(i+1)*q*a**d
                 else
                    if(a.gt.q) then
                       q=log(a)
                    endif
                    g(i+1)=c*b**(c-1)+2*x(i+1)*q*a**d
                 endif
1844          continue

              

                 !        Write (6,*) 'Current X for debugging ='
                 !                 write (6,'((1x,1p, 6(1x,d11.4)))') (x(i),i = 1,n)
                 !                 write (6,*) 'Current g for debugging ='
                 !                 write (6,'((1x,1p, 6(1x,d11.4)))') (g(i),i = 1,n)
                 !                 write (6,*) 'Current f value ='
                 !                 write (*,'(A, F8.3)') 'f=', f
           endif
                 
                 !          go back to the minimization routine.
        else
                 
           if (task(1:5) .eq. 'NEW_X') then
              
              !        the minimization routine has returned with a new iterate.
              !        The time limit has not been reached, and we test whether
              !        the following two stopping tests are satisfied:
              
              !        1) Terminate if the total number of f and g evaluations
              !             exceeds 900.
              
              if (isave(34) .ge. 90000) &
                   task='STOP: TOTAL NO. of f AND g EVALUATIONS EXCEEDS LIMIT'
              
              !        2) Terminate if  |proj g|/(1+|f|) < 1.0d-10.
              
              if (dsave(13) .le. 1.d-10*(1.0d0 + abs(f))) &
                   task='STOP: THE PROJECTED GRADIENT IS SUFFICIENTLY SMALL'
              
              !        We wish to print the following information at each iteration:
              !          1) the current iteration number, isave(30),
              !          2) the total number of f and g evaluations, isave(34),
              !          3) the value of the objective function f,
                          !          4) the norm of the projected gradient,  dsve(13)
              !
              !        See the comments at the end of driver1 for a description
              !        of the variables isave and dsave.
              
              write (6,'(2(a,i5,4x),a,1p,d12.5,4x,a,1p,d12.5)') 'Iterate' &
                   ,isave(30),'nfg =',isave(34),'f =',f,'|proj g| =',dsave(13)
              
              !        If the run is to be terminated, we print also the information
              !        contained in task as well as the final value of x.
              
              if (task(1:4) .eq. 'STOP') then
                 write (6,*) task  
                 write (6,*) 'Final X='
                 write (6,'((1x,1p, 6(1x,d11.4)))') (x(i),i = 1,n)
              endif
              
           endif
        end if 
     end do
     
     !     If task is neither FG nor NEW_X we terminate execution.
     write (6,*) task  
     write (6,*) 'Final X='
     write (6,'((1x,1p, 6(1x,d11.4)))') (x(i),i = 1,n)
   end program driver
   
   !======================= The end of driver3 ============================
   
   
