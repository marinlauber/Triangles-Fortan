program write_vtu
  implicit none
  character(1),parameter :: lf=char(10)
  character(len=200)     :: buff
  character(9)           :: name
  integer                :: i,j,k,num,Nel,Np
  real                   :: tri(2,3,3)
  character(14)          :: prec='type="Float32"'
  character(12)          :: precI='type="Int32"'
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
! set precision
  ! prec(12:13) = '64'
  ! precI(10:11) = '64'
! -- write data
  write(buff,'(A)') name//'.vtu'
  open(newunit=num, file=trim(buff), status='replace')
  write(num,'(A)') '<?xml version="1.0"?>'
  write(num,'(A)') '<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian">'
  write(num,'(A)') '<UnstructuredGrid>'
  write(buff,'(A,I5,A,I5,A)') '<Piece NumberOfPoints="',Np,'" NumberOfCells="',Nel,'">'
  write(num,'(A)') trim(buff)
  write(num,'(A)') '<Points>'
  write(num,'(A)') '<DataArray '//prec//' NumberOfComponents="3" format="ascii">'
  write(num,*) ((((tri(i,j,k)),k=1,3),j=1,3),i=1,Nel)
  write(num,'(A)') '</DataArray>'//lf//'</Points>'
  ! write cell data
  write(num,'(A)') '<Cells>'
  write(num,'(A)') '<DataArray '//precI//' Name="connectivity" Format="ascii">'
  write(num,*) (i-1,i=1,Np)
  write(num,'(A)') '</DataArray>'
  write(num,'(A)') '<DataArray '//precI//' Name="offsets" Format="ascii">'
  write(num,*) (3*i,i=1,Nel)
  write(num,'(A)') '</DataArray>'
  write(num,'(A)') '<DataArray '//precI//' Name="types" Format="ascii">'
  write(num,*) (5,i=1,Nel)
  write(num,'(A)') '</DataArray>'//'</Cells>'
  ! scalar data
  write(num,'(A)') '<PointData Scalars="scalars">'
  write(num,'(A)') '<DataArray '//prec//' Name="pressure" Format="ascii">'
  write(num,*) ((float(i+j),j=1,3),i=1,Nel)
  write(num,'(A)') '</DataArray>'
  ! write vector data
  write(num,'(A)') '<DataArray '//prec//' Name="velocity" NumberOfComponents="3" Format="ascii">'
  write(num,*) (((float(i+j+k),k=1,3),j=1,3),i=1,Nel)
  write(num,'(A)') '</DataArray>'
  ! end file
  write(num,'(A)') '</PointData>'//lf//'</Piece>'
  write(num,'(A)')'</UnstructuredGrid>'//lf//'</VTKFile>'
  close(num)
end program write_vtu