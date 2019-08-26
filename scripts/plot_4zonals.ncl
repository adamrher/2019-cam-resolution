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

  dir1 = "../data/logistic/"
  fname1 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.pearsons-dwn-all.nc", \
             "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.pearsons-dwn-all.nc", \
             "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.pearsons-dwn-all.nc", \
             "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.pearsons-dwn-all.nc", \
             "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.pearsons-dwn-all.nc", \
             "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.pearsons-dwn-all.nc"/)

  nfiles = dimsizes(fname1)
  VAR1 = "Rlog"
  YMIN1 =0.
  YMAX1 =0.5
  yaxis1 = "~F10~R~F21~, Logistic Regression"
  stat95 = 3.841

  VAR2 = "Beta1"
  YMIN2 =-160.
  YMAX2 =  10.
  yaxis2 = "~F10~b~B~1~N~~F21~, slope (s/Pa)"

  dir2 = "/gpfs/fs1/work/aherring/matlab/logistic/"
  fname2 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-updwn.nc", \
             "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-updwn.nc", \
             "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-updwn.nc", \
             "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-updwn.nc", \
             "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-updwn.nc", \
             "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-updwn.nc"/)
  VAR3 = "FRACVDgl"
  YMIN3 = 0.6
  YMAX3 = 7.0
  yaxis3 = "~F34~a~F21~f~B~d~N~~F34~qa~F33~w~F21~~B~d~N~~F34~q~F21~ (~F34~4~F21~10~S~2~N~ Pa/s)"

  onemnth = False
  nstart = 0
  dir3 = "/glade/scratch/aherring/"
  fname3 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700", \
	     "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617", \
	     "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350", \
	     "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528", \
	     "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018", \
	     "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602"/)
  fdate3 = ".cam.h1.*"
  VAR4 = "FREQZM"
  YMIN4 = 0.1
  YMAX4 = 1.
  yaxis4 = "~F10~FREQZM"

  colors = (/"blue","deepskyblue1","green","magenta","red","black"/)

  writencdf = False
  fname_out = "QPC6_neXXpg3_FREQZM.nc"
  loadncdf = True
  fname_in = fname_out
  VARNAM1= (/"DFRAC1", \
	     "DFRAC2", \
             "DFRAC3", \
             "DFRAC4", \
             "DFRAC5", \
             "DFRAC6"/)
  VARNAM2= (/"FREQZM1", \
             "FREQZM2", \
             "FREQZM3", \
             "FREQZM4", \
             "FREQZM5", \
             "FREQZM6"/)
  LATNAM = (/"lat1", \
	     "lat2", \
	     "lat3", \
	     "lat4", \
	     "lat5", \
	     "lat6"/)

  genwgts = False
  wgtpathlog = "/glade/work/aherring/grids/grid_files/bilin/"
  griddir= "/gpfs/fs1/work/aherring/grids/"
  wgtNam = (/"ne20pg3_2_09375deg-bilin.nc", \ 
	     "ne30pg3_2_0703125deg-bilin.nc", \
	     "ne40pg3_2_046875deg-bilin.nc", \
	     "ne60pg3_2_03515625deg-bilin.nc", \
	     "ne80pg3_2_0234375deg-bilin.nc", \
	     "ne120pg3_2_017578125deg-bilin.nc"/)
  srcSCRIP = (/"ne20pg3_scrip_180605.nc", \
	     "ne30pg3_scrip_170611.nc", \
	     "ne40pg3_scrip_180605.nc", \
	     "ne60pg3_scrip_170611.nc", \
	     "ne80pg3_scrip_180608.nc", \
	     "ne120pg3_scrip_170628.nc"/)
  dstSCRIP = (/"09375deg-SCRIP.nc", \
	     "0703125deg-SCRIP.nc", \
	     "046875deg-SCRIP.nc", \
	     "03515625deg-SCRIP.nc", \
	     "0234375deg-SCRIP.nc", \
	     "017578125deg-SCRIP.nc"/)

  plotNam = "temp_4zonal"

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
  plot = new( (/4/), graphic)
  wkstype@wkBackgroundOpacityF    = 0.

  res             = True
  res@gsnMaximize = False
  res@gsnDraw     = False      ; Will draw later, after overlaying
  res@gsnFrame    = False      ; all plots

  res@xyLineThicknesses = 5
  res@vpWidthF    = 0.9        ; Make plots wider
  res@vpHeightF   = 0.4

  res@tmBorderThicknessF = 3 ;axes thickness
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
  txres@txFontHeightF = 0.013
  txres@txJust = "CenterLeft"

  plres  = True       
  plres@gsLineDashPattern  = 0
  plres@gsLineThicknessF  = res@xyLineThicknesses

  yy = (/ 0.70,0.68,0.66,0.64,0.62,0.60,0.58 /) - 0.43
  xx = (/ 0.37,0.39 /)

;************
;Main Loop
;************
 do n = 0,nfiles-1

 print(" ")
 print("-----") 
 print("begin case "+n)

 print("Grab vars 3,4...")

if (.not.loadncdf) then

;----------------------------------------------------------

 ;load all files
 files = systemfunc ("ls " + dir3 + fname3(n) + "/run/" + fname3(n) + fdate3)
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

 if (isfilevardim(f[0],VAR4,"ncol")) then
   print("*history fields are on unstructured grid1")
   latlon = False
   rank = 2

   dims = getfilevardimsizes(f[0],VAR4)
   ncol = dims(1)
   delete(dims)

   dims = getfilevardimsizes(f[0],"PSDRY_gll")
   ncol_d = dims(1)
   delete(dims)

   wgtpath = get_wgt_path(ncol,ncol_d,0)
 else
   print("*history fields are on lat-lon grid")
   latlon = True
   rank = 3
 end if

 var = f[:]->$VAR4$
 delete(f)

 print("Averaging...")
 bar = dim_avg_0_lowmem(var,rank)
 delete(var)

 print("Regrid...")
 bar_regrid = ESMF_regrid_with_weights(bar,wgtpath,False)
 lat = bar_regrid&lat
 delete(bar)

 zbar2 = dim_avg(bar_regrid)
 delete(bar_regrid)

;----------------------------------------------------------

 f  = addfile(dir2 + fname2(n),"r")

 print("file: " + fname2(n))
 var = f->VOMGD
 tmp = f->FRACD
 var = var*tmp
 delete(tmp)

 var = var*100.
 delete(f)

 bar = dim_avg_0_lowmem(var,2)
 delete(var)

 print("Regrid...")
 bar_regrid = ESMF_regrid_with_weights(bar,wgtpath,False)
 delete(bar)

 zbar1 = dim_avg(bar_regrid)
 delete(bar_regrid)

 print("max var3 " + max(zbar1))
 print("min var3 " + min(zbar1))

;----------------------------------------------------------
delete(wgtpath)

else
 ;;;load from netcdf
 if (n.eq.0) then
   ncdf = addfile("../data/logistic/" + fname_in,"r")
 end if
   zbar1 = ncdf->$VARNAM1(n)$
   zbar2 = ncdf->$VARNAM2(n)$
   lat  = ncdf->$LATNAM(n)$
end if

 print("Plotting...")
 print("max var4 " + max(zbar2))
 print("min var4 " + min(zbar2))

 res@xyLineColors           = colors(n)
 if (n.eq.0) then
   res@tiYAxisString          = yaxis3
   res@trYMinF     = YMIN3
   res@trYMaxF     = YMAX3
   plot(0) = gsn_csm_xy(wks,sin(lat*pi/180.),zbar1,res)

   res@tiYAxisString          = yaxis4
   res@trYMinF     = YMIN4
   res@trYMaxF     = YMAX4
   plot(1) = gsn_csm_xy(wks,sin(lat*pi/180.),zbar2,res)
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

 print("Grab var1,var2...")

 f  = addfile(dir1 + fname1(n),"r")
 var = f->$VAR1$
 LL  = f->Loglike1
 B1  = f->Beta1
 delete(f)

 print("max B1 src " + max(B1))
 print("min B1 src " + min(B1))

 var@_FillValue = default_fillvalue("double")
 replace_ieeenan(var,var@_FillValue,0)

 LL@_FillValue = default_fillvalue("double")
 replace_ieeenan(LL,LL@_FillValue,0)

 B1@_FillValue = default_fillvalue("double")
 replace_ieeenan(B1,B1@_FillValue,0)

 var = where(LL.ge.stat95,var,var@_FillValue)
 LL = where(LL.ge.stat95,LL,LL@_FillValue)
 B1 = where(LL.ge.stat95,B1,B1@_FillValue)

 print("max Loglike src " + max(LL))
 print("min Loglike src " + min(LL))

 dims = dimsizes(var)
 fracmiss = num(ismissing(var))/dims(0)
 print("missing src " + fracmiss )
 print("total src " + dims )
 print("fraction of missing src " + fracmiss )
 delete(dims)

 print("Regrid...")
 ;;;there are missing values, 
 ;;;generate new wgts
 print("number missing in src: " + num(ismissing(var)))

 if (genwgts) then
   srcFile = griddir + "SCRIP_files/" + srcSCRIP(n)
   dstFile = griddir + "grid_files/cnsrv/" + dstSCRIP(n)
   ;---Set up regridding options
      Opt                = True
      Opt@InterpMethod   = "bilinear"
      Opt@WgtFileName    = wgtNam(n)
      Opt@SrcRegional    = False
      Opt@ForceOverwrite = True
      Opt@Debug          = True
      Opt@PrintTimings   = True
      Opt@SrcMask2D      = where(ismissing(var),0,1)
      ESMF_regrid_gen_weights(srcFile,dstFile,wgtNam(n),Opt)
      delete(Opt)
   ;---done
 end if

 print("wgtpath: " + wgtpathlog + wgtNam(n))
 var_regrid = ESMF_regrid_with_weights(var,wgtpathlog + wgtNam(n),False)
 LL_regrid = ESMF_regrid_with_weights(LL,wgtpathlog + wgtNam(n),False)
 B1_regrid = ESMF_regrid_with_weights(B1,wgtpathlog + wgtNam(n),False)
 lat = var_regrid&lat
 delete([/var,LL,B1/])

 var_regrid = where(LL_regrid.ge.stat95,var_regrid,var_regrid@_FillValue)
 LL_regrid = where(LL_regrid.ge.stat95,LL_regrid,LL_regrid@_FillValue)
 B1_regrid = where(LL_regrid.ge.stat95,B1_regrid,B1_regrid@_FillValue)

 print("max B0 dst " + max(B1_regrid))
 print("min B1 dst " + min(B1_regrid))

 print("max Loglike dst " + max(LL_regrid))
 print("min Loglike dst " + min(LL_regrid))
 print("number missing in dst: " + num(ismissing(var_regrid)))

 zbar = dim_avg(var_regrid)
 LLbar= dim_avg(LL_regrid)
 B1bar = dim_avg(B1_regrid)
 delete([/var_regrid,LL_regrid,B1_regrid/])

 print("Plotting...")
 print("max var1 " + max(zbar))
 print("min var1 " + min(zbar))
 print("max Loglike " + max(LLbar))
 print("min Loglike " + min(LLbar))

 if (n.eq.0) then
   res@tiYAxisString          = yaxis1
   res@trYMinF     = YMIN1
   res@trYMaxF     = YMAX1
   plot(2) = gsn_csm_xy(wks,sin(lat*pi/180.),zbar,res)

   res@tiXAxisString          = "Latitude"
   res@gsnYRefLine = 0.
   res@tiYAxisString          = yaxis2
   res@trYMinF     = YMIN2
   res@trYMaxF     = YMAX2
   plot(3) = gsn_csm_xy(wks,sin(lat*pi/180.),B1bar,res)
   delete(res@gsnYRefLine)
   delete(res@tiXAxisString)
 else
   tmp = gsn_csm_xy(wks,sin(lat*pi/180.),zbar,res)
   overlay(plot(2),tmp)
   delete(tmp)

   tmp = gsn_csm_xy(wks,sin(lat*pi/180.),B1bar,res)
   overlay(plot(3),tmp)
   delete(tmp)
 end if
 delete([/zbar,LLbar,B1bar,lat/])

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

    resP@gsnPanelFigureStrings = (/"a.","b.","c.","d."/)
    resP@gsnPanelFigureStringsFontHeightF = 0.010
    resP@gsnPanelFigureStringsPerimOn     = True
    resP@gsnPanelFigureStringsBackgroundFillColor = "white"
    resP@amJust           = "TopRight"

  ;resP@gsnPanelTop        = 0.97
  resP@gsnPanelBottom     = 0.1
  ;resP@gsnPanelRight     = 0.9007;
  ;resP@gsnPanelLeft     = 0.40        ; position of left most plot
  gsn_panel(wks,plot,(/4,1/),resP)      

frame(wks)

end



