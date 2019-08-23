;**************************************
;contour plots
;**************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "/glade/work/aherring/CESM2/arh-git-scripts/ncl/se_func_lib.ncl"
;;load "/home/aherring/arh-git-scripts/ncl/se_func_lib.ncl"
;**************************************
begin
;****************************************
  secpday = 60.*60.*24;
  pi = 3.14159265358979
  g = 9.80616 ;m/s2
  Re = 6371.22
  cp = 1004.
  Rd = 287.

  onemnth = False
  nstart = 0
  dir1 = "/glade/scratch/aherring/"
  fname1 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700", \
	     "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617", \
	     "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350", \
	     "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528", \
	     "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018", \
	     "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602"/)
  nfiles = dimsizes(fname1)
  fdate1 = (/".cam.h3.*", \
             ".cam.h4.*", \
             ".cam.h3.*", \
             ".cam.h4.*", \
             ".cam.h3.*", \
             ".cam.h4.*"/)
  VAR1 = "PRECC"
  YMIN1 = 0.0;;0.3
  YMAX1 = 1.0;
  yaxis1 = "Drizzle Fraction (~F34~#~F21~ 5 mm/day)"
  dlim = 5.

  dir2 = dir1
  fname2 = fname1
  fdate2 = ".cam.h1.*"
  VAR2 = "LHFLX"
  YMIN2 = 20.
  YMAX2 = 175.
  yaxis2 = "Latent Heat Flux (W/m~S~2~N~)"

  colors = (/"blue","deepskyblue1","green","magenta","red","black"/)

  writencdf = False
  fname_out = "QPC6_neXXpg3.zonal-drizzle-5mmd.nc"
  loadncdf = True
  fname_in = fname_out
  VARNAM1= (/"DFRAC1", \
             "DFRAC2", \
             "DFRAC3", \
             "DFRAC4", \
             "DFRAC5", \
             "DFRAC6"/)
  VARNAM2= (/"LHFLX1", \
             "LHFLX2", \
             "LHFLX3", \
             "LHFLX4", \
             "LHFLX5", \
             "LHFLX6"/)
  LATNAM = (/"lat1", \
	     "lat2", \
	     "lat3", \
	     "lat4", \
	     "lat5", \
	     "lat6"/)

  plotNam = "temp_2zonal"

  label = (/"  ne20", \
            "  ne30", \
            "  ne40", \
            "  ne60", \
            "  ne80", \
            "  ne120"/)

;************** 
;graphics stuff
;**************
  wkstype = "pdf"
  wks = gsn_open_wks(wkstype,plotNam)
  plot = new( (/2/), graphic)
  wkstype@wkBackgroundOpacityF    = 0.

  res             = True
  res@gsnMaximize = False
  res@gsnDraw     = False      ; Will draw later, after overlaying
  res@gsnFrame    = False      ; all plots

  res@xyLineThicknesses = 6
  res@vpWidthF    = 0.8        ; Make plots wider
  res@vpHeightF   = 0.5

  res@tmBorderThicknessF = 4 ;axes thickness
  res@tmXBMajorOutwardLengthF = 0.
  res@tmYLMajorOutwardLengthF = 0.
  res@tmXBMinorOutwardLengthF = 0.
  res@tmYLMinorOutwardLengthF = 0.
  res@tmXTMajorOutwardLengthF = 0.
  res@tmYRMajorOutwardLengthF = 0.
  res@tmXTMinorOutwardLengthF = 0.
  res@tmYRMinorOutwardLengthF = 0.

  res@trXMinF     = -1.
  res@trXMaxF     = 1.
  res@tmXBMode        = "Explicit"
  xticks = new((/19/),float)
  do i = 0,19-1
    tmp = (i-9)*10.
    xticks(i) = sin(tmp*pi/180.)
  end do
  res@tmXBValues      = xticks
  res@tmXBLabels      = (/"","-80","","-60","","-40","","-20","","0","","20","","40","","60","","80",""/)
  delete(tmp)

  ;;add legend
  txres = True
  txres@txFontHeightF = 0.016
  txres@txJust = "CenterLeft"

  plres  = True       
  plres@gsLineDashPattern  = 0
  plres@gsLineThicknessF  = res@xyLineThicknesses

  yy = (/ 0.70,0.68,0.66,0.64,0.62,0.60,0.58 /) - 0.19
  xx = (/ 0.27,0.29 /)

;************
;Main Loop
;************
 do n = 0,nfiles-1

 print(" ")
 print("-----") 
 print("begin case "+n)

 print("Grab vars 1,2...")

if (.not.loadncdf) then

;----------------------------------------------------------

 ;load all files
 files = systemfunc ("ls " + dir1 + fname1(n) + "/run/" + fname1(n) + fdate1(n))
 nf = dimsizes(files)
 if (onemnth) then
   nfinish = nstart
 else
   nfinish = nf-1
 end if

 print("load files...")
 print(""+files(nstart:nfinish))

 f  = addfiles (files(nstart:nfinish),"r")
 ListSetType(f,"cat")
 delete(files)

 if (isfilevardim(f[0],VAR1,"ncol")) then
   print("*history fields are on unstructured grid1")
   latlon = False
   rank = 2

   dims = getfilevardimsizes(f[0],VAR1)
   ncol = dims(1)
   delete(dims)

   dims = getfilevardimsizes(f[0],"FT")
   ncol_d = dims(2)
   delete(dims)

   wgtpath = get_wgt_path(ncol,ncol_d,0)
   delete(ncol_d)
 else
   print("*history fields are on lat-lon grid")
   latlon = True
   rank = 3
 end if

 var = f[:]->$VAR1$
 var = var*secpday*1000.
 delete(f)

 print("Compute Drizzel Fraction...")
 bar = var(0,:);
 do i = 0,ncol-1
   print("i = "+i+"/"+(ncol-1))
   indx = ind(var(:,i).gt.0. .and. var(:,i).le.dlim)
   bar(i) = sum(var(indx,i))/sum(var(:,i))
   delete(indx)
 end do
 delete(var)

 print("Regrid...")
 bar_regrid = ESMF_regrid_with_weights(bar,wgtpath,False)
 lat = bar_regrid&lat
 delete(bar)

 zbar1 = dim_avg(bar_regrid)
 delete(bar_regrid)

 print("max var1 " + max(zbar1))
 print("min var1 " + min(zbar1))

;----------------------------------------------------------

 ;load all files
 files = systemfunc ("ls " + dir2 + fname2(n) + "/run/" + fname2(n) + fdate2)
 nf = dimsizes(files)
 if (onemnth) then
   nfinish = nstart
 else
   nfinish = nf-1
 end if

 print("load files...")
 print(""+files(nstart:nfinish))

 f  = addfiles (files(nstart:nfinish),"r")
 ListSetType(f,"cat")
 delete(files)

 var = f[:]->$VAR2$
 delete(f)

 bar = dim_avg_0_lowmem(var,2)
 delete(var)

 print("Regrid...")
 bar_regrid = ESMF_regrid_with_weights(bar,wgtpath,False)
 delete(bar)

 zbar2 = dim_avg(bar_regrid)
 delete(bar_regrid)

 print("max var2 " + max(zbar2))
 print("min var2 " + min(zbar2))

;----------------------------------------------------------

else
 ;;;load from netcdf
 if (n.eq.0) then
   ncdf = addfile("../data/drizzle/" + fname_in,"r")
 end if
 zbar1 = ncdf->$VARNAM1(n)$
 zbar2 = ncdf->$VARNAM2(n)$
 lat  = ncdf->$LATNAM(n)$

 print("max var1 " + max(zbar1))
 print("min var1 " + min(zbar1))
 print("max var2 " + max(zbar2))
 print("min var2 " + min(zbar2))
end if

 print("Plotting...")

 res@xyLineColors           = colors(n)
 if (n.eq.0) then
   res@tiYAxisString          = yaxis1
   res@trYMinF     = YMIN1
   res@trYMaxF     = YMAX1
   plot(0) = gsn_csm_xy(wks,sin(lat*pi/180.),zbar1,res)

   res@tiYAxisString          = yaxis2
   res@tiXAxisString          = "Latitude"
   res@trYMinF     = YMIN2
   res@trYMaxF     = YMAX2
   plot(1) = gsn_csm_xy(wks,sin(lat*pi/180.),zbar2,res)
   delete(res@tiXAxisString)
 else
   tmp = gsn_csm_xy(wks,sin(lat*pi/180.),zbar1,res)
   overlay(plot(0),tmp)
   delete(tmp)

   tmp = gsn_csm_xy(wks,sin(lat*pi/180.),zbar2,res)
   overlay(plot(1),tmp)
   delete(tmp)
 end if

 if (writencdf) then
   if (n.eq.0) then
     system("/bin/rm -f "+fname_out)
     ncdf = addfile(fname_out,"c")
   end if
   zbar1!0 = LATNAM(n)
   zbar2!0 = LATNAM(n)
   zbar1&$LATNAM(n)$ = lat
   zbar2&$LATNAM(n)$ = lat
   ncdf->$VARNAM1(n)$ = zbar1
   ncdf->$VARNAM2(n)$ = zbar2
 end if
 delete([/zbar1,zbar2,lat/])

 plres@gsLineColor       = colors(n)
 gsn_polyline_ndc(wks,xx,(/yy(n),yy(n)/),plres)
 gsn_text_ndc(wks,label(n),xx(1),yy(n),txres)

end do ;nfiles

;;drawNDCGrid(wks)
;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot

  resP@gsnPanelFigureStrings = (/"a.","b."/)
  resP@gsnPanelFigureStringsFontHeightF = 0.018
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopRight"

  resP@gsnPanelBottom     = 0.1
  gsn_panel(wks,plot,(/2,1/),resP)      

frame(wks)

end



