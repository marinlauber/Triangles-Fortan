program write_vtu_raw
  implicit none
  character(1),parameter :: lf=char(10)
  character(len=200)     :: buff
  character(9)           :: name
  integer                :: int,i,j,k,num,Nel,Np
  integer                :: off,vsize,psize,csize,psizeI
  real                   :: r,tri(2,3,3)
  character(14)          :: prec='type="Float32"'
  logical                :: old

  ! two triangles
  tri(1,1,:) = (/0.0,0.0,0.0/)
  tri(1,2,:) = (/1.0,0.0,0.0/)
  tri(1,3,:) = (/0.0,1.0,0.0/)
  tri(2,1,:) = (/1.0,0.0,0.0/)
  tri(2,2,:) = (/0.0,1.0,0.0/)
  tri(2,3,:) = (/1.0,1.0,0.0/)

! give it a name
  name = 'triangles'
! -- number of points to write, and number of elements
  Nel=2; Np=3*Nel 
  psize=sizeof(r)*Np; vsize=3*psize
  csize=sizeof(int)*Nel; psizeI=3*csize
! set precision, needs to compile with: -DDUBON -fdefault-real-8
  prec(12:13) = '64'
! -- write data
  write(buff,'(A)') name//'.vtu'
  open(newunit=num,file=trim(buff), status='replace',form='unformatted',access='stream')
  write(num) '<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian">'//lf
  write(num) '<UnstructuredGrid>'
  write(buff,'(A,I5,A,I5,A)') '<Piece NumberOfPoints="',Np,'" NumberOfCells="',Nel,'">'
  write(num) trim(buff)//lf
  write(num) '<Points>'//lf
  write(num) '<DataArray '//prec//' NumberOfComponents="3" format="appended" offset="0">'//lf
  off = vsize+sizeof(vsize)
  write(num) '</DataArray>'//lf//'</Points>'//lf
  ! write cell data
  write(num) '<Cells>'//lf
  write(buff,'(A,i10,A)') '<DataArray type="Int32" Name="connectivity" Format="appended" offset="',off,'"/>'
  write(num) trim(buff)//lf
  off=off+psizeI+sizeof(psizeI)
  write(buff,'(A,i10,A)') '<DataArray type="Int32" Name="offsets" Format="appended" offset="',off,'"/>'
  write(num) trim(buff)//lf
  off = off+csize+sizeof(csize)
  write(buff,'(A,i10,A)') '<DataArray type="Int32" Name="types" Format="appended" offset="',off,'"/>'
  write(num) trim(buff)//lf
  off = off+csize+sizeof(csize)
  write(num) '</Cells>'//lf
  ! scalar data
  write(num) '<PointData Vectors="Velocity" Scalars="Pressure">'//lf
  write(buff,'(A,i10,A)') '<DataArray '//prec//' Name="Pressure" Format="appended" offset="',off,'"/>'
  write(num) trim(buff)//lf
  off = off+psize+sizeof(psize)
  ! write vector data
  write(buff,'(A,i10,A)') '<DataArray '//prec//' Name="Velocity" NumberOfComponents="3" Format="appended" offset="',off,'"/>'
  write(num) trim(buff)//lf
  ! end file
  write(num) '</PointData>'//lf//'</Piece>'//lf//'</UnstructuredGrid>'//lf
  write(num) '<AppendedData encoding="raw">'//lf
  write(num) '_'
  write(num) vsize,((( tri(i,j,k),k=1,3),j=1,3),i=1,Nel )
  write(num) psizeI,( i-1,i=1,Np )
  write(num) csize,( 3*i,i=1,Nel)
  write(num) csize,( 5,i=1,Nel)
  write(num) psize,(( float(i+j),j=1,3),i=1,Nel )
  write(num) vsize,((( float(i+j+k),k=1,3),j=1,3),i=1,Nel )
  write(num) lf//'</AppendedData>'//lf//'</VTKFile>'//lf
  close(num)
end program write_vtu_raw
