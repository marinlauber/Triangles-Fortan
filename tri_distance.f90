program test_tri_distance
    implicit none
    call test_closest
    contains
  subroutine test_closest
    real :: a(3),b(3),c(3),p(3),n(3),d,f(3)
    call random_number(a)
    call random_number(b)
    call random_number(c)
    n = cross(a-c,b-c)
    n = n/norm2(n)
    print*,'a ',a
    print*,'b ',b
    print*,'c ',c
    print*, 'p = a'
    p = a + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = b'
    p = b + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = c'
    p = c + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = (a+b)/2'
    p = (a+b)/2 + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = (a+c)/2'
    p = (a+c)/2 + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = (c+b)/2'
    p = (c+b)/2 + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    print*, 'p = (a+b+c)/3'
    p = (a+b+c)/3 + 0.1*n
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    a = (/0.,0.,0./)
    b = (/1.,0.,0./)
    c = (/0.,1.,0./)
    p = (/1,1,1/)
    f = closest_point_to_tri(p,a,b,c)
    d = norm2(f-p)
    print*,'Point p:             ',p
    print*,'Closes point on tri: ',f
    print*,'Distance:            ',d
    end subroutine test_closest
  function cross(a,b) result(c)
    real,intent(in) :: a(3),b(3)
    real :: c(3)
    c(1) = a(2)*b(3) - a(3)*b(2)
    c(2) = a(3)*b(1) - a(1)*b(3)
    c(3) = a(1)*b(2) - a(2)*b(1)
  end function cross
  pure function closest_point_to_tri(p,a,b,c) result(x)
    real,intent(in) :: p(3),a(3),b(3),c(3)
    real :: x(3)
    real,dimension(3) :: ab,ac,ap,bp,cp,denom,v,w
    real:: vc,vb,va,d1,d2,d3,d4,d5,d6
! -- is point `a` closest?
    ab = b-a
    ac = c-a
    ap = p-a
    d1 = sum(ab*ap)
    d2 = sum(ac*ap)
    if( (d1.le.0) .AND. (d2.le.0) ) then
      x = a
      return
    end if
! -- is point `b` closest?
    bp = p-b
    d3 = sum(ab*bp)
    d4 = sum(ac*bp)
    if((d3.ge.0).and.(d4.le.d3)) then
      x = b
      return
    end if
! -- is point `c` closest?
    cp = p-c
    d5 = sum(ab*cp)
    d6 = sum(ac*cp)
    if((d6.ge.0).and.(d5.le.d6)) then
      x = c
      return
    end if
! -- is segment 'ab' closest?
    vc = d1*d4 - d3*d2
    if((vc.le.0).and.(d1.ge.0).and.(d3.le.0)) then
      x = a + ab*d1 / (d1 - d3)
      return
    end if
! -- is segment 'ac' closest?
    vb = d5*d2 - d1*d6
    if((vb.le.0).and.(d2.ge.0).and.(d6.le.0)) then
      x = a + ac*d2 / (d2 - d6)
      return
    end if
! -- is segment 'bc' closest?
    va = d3*d6 - d5*d4
    if((va.le.0).and.(d4.ge.d3).and.(d5.ge.d6)) then
      x = b + (c - b) * (d4 - d3) / ((d4 - d3) + (d5 - d6))
      return
    end if
! -- closest is interior to `abc`
    denom = 1 / (va + vb + vc)
    v= vb*denom
    w = vc*denom
    x =  a + ab * v + ac * w
  end function closest_point_to_tri
end program test_tri_distance