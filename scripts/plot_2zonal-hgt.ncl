;**************************************
;zonal_hgt_isen.ncl
;**************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "/glade/work/aherring/CESM2/arh-git-scripts/ncl/se_func_lib.ncl"
;;load "se_func_lib.ncl"
;**************************************
begin

  lolat = -90.d0
  hilat =  90.d0

  VAR = "T"
  factor = 1.

  VAR1 = "STEND_CLUBB"
  factor1 = 1.
  xlabel1 = "STEND_CLUBB"

  fname_in = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700-2-physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.dzonal-hgt.STEND_CLUBB.nc", \
	       "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350-2-physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.dzonal-hgt.STEND_CLUBB.nc"/)

  ptrop_in = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700-2-physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.dzonal-hgt.T.nc", \
               "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350-2-physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.dzonal-hgt.T.nc"/)


  nfiles = dimsizes(fname_in)
  ZBAR  = (/"zbarup_diff","zbardn_diff"/)
  ZQBAR  = (/"zqbarup_diff","zqbardn_diff"/)
  PTROP = (/"PTROP2","PTROP2"/)

 ;;;labels and titles
 labels = (/"a.) ~F18~O~F33~w~F18~P~F21~ < 0", \
            "b.) ~F18~O~F33~w~F18~P~F21~ < 0", \
	    "c.) ~F18~O~F33~w~F18~P~F21~ > 0", \
            "d.) ~F18~O~F33~w~F18~P~F21~ > 0", \
	    "e.) ~F18~O~F33~w~F18~P~F21~ < 0", \
            "f.) ~F18~O~F33~w~F18~P~F21~ < 0", \
            "g.) ~F18~O~F33~w~F18~P~F21~ > 0", \
            "h.) ~F18~O~F33~w~F18~P~F21~ > 0"/)

 titles = (/"ne40pg3 - ne20pg3", \
	    "ne80pg3 - ne40pg3"/)

 lbarnams = (/"Temperature (K)", \
	      "CLUBB Temperature Tendency (K/s)"/)

 if (VAR.eq."RELHUM") then
	 vmin = (/0.,0.,-20./)
	 vmax = (/100.,100.,20./)
	 vspace = (/5.,5.,1.5/)
	 var = "Q"
 else if (VAR.eq."U") then
	 vmin = (/-10.,-10.,-5./)
	 vmax = (/60.,60.,5./)
	 vspace = (/2.5,2.5,0.5/)
 else if (VAR.eq."OMEGA") then
         vmin = (/-90.,-90.,-30./)
         vmax = (/30.,30.,30./)
         vspace = (/5.,5.,2./)
 else if (VAR.eq."VU") then
         vmin = (/-70.,-70.,-40./)
         vmax = (/ 70., 70., 40./)
         vspace =(/10., 10.,  4./)
 else if (VAR.eq."T") then
         vmin = -1.5
         vmax =  1.5
         vspace = 0.15
 end if
 end if
 end if
 end if
 end if

 if (VAR1.eq."PTEQ") then
   vminb = -2.e-5
   vmaxb =  2.e-5
   vspaceb = (vmaxb-vminb)/20.
 else if (VAR1.eq."STEND_CLUBB")
   vminb = -0.007
   vmaxb =  0.007
   vspaceb = (vmaxb-vminb)/20
 end if
 end if

 pi = 3.14159265358979
 p0 = 1.e5
 ps0= 1.015e5
 ilevfile = "ilevp.1015hPa.nc"

 pltnam = "temp_dhgt_panel."+VAR1

;*************************************************************
; Start graphics
;*************************************************************
  wks = gsn_open_wks("pdf",pltnam)
  gsn_define_colormap(wks,"MPL_jet")

  if (VAR.ne."T") then
    gsn_reverse_colormap(wks)
  end if

  plot = new(4*nfiles,graphic)                          ; create a plot array

;*************************************************************
; Graphics Options
;*************************************************************
   res1             = True
   res1@gsnMaximize = True
   res1@gsnPaperOrientation = "portrait"

   res1@gsnDraw     = False      ; Will draw later, after overlaying
   res1@gsnFrame    = False      ; all plots

   res1@vpWidthF    = 0.95        ; Make plots wider
   res1@vpHeightF   = 0.5
   res1@vpXF        = 0.025
   res1@vpYF        = 0.85

   res1@cnFillOn          = True               ; turn on color fill
   res1@cnLinesOn         = False
   res1@cnLineLabelsOn    = False
   res1@cnInfoLabelOn     = False

   res1@cnMonoLineThickness = True
   res1@cnLineThicknessF  = 2.
   res1@cnLevelSelectionMode = "ManualLevels"     ; manually set the contour levels with the following 3 resources
   res1@gsnSpreadColors  = True               ; use full range of color map
   res1@lbLabelStride     = 2                  ; every other color

   res1@tmBorderThicknessF = 4 ;axes thickness
   res1@tmXBMajorOutwardLengthF = 0.
   res1@tmYLMajorOutwardLengthF = 0.
   res1@tmXBMinorOutwardLengthF = 0.
   res1@tmYLMinorOutwardLengthF = 0.
   res1@tmXTMajorOutwardLengthF = 0.
   res1@tmYRMajorOutwardLengthF = 0.
   res1@tmXTMinorOutwardLengthF = 0.
   res1@tmYRMinorOutwardLengthF = 0.
   res1@tmXTOn               = False
   res1@tmYROn               = False

   res1@gsnXAxisIrregular2Linear = True
   res1@gsnYAxisIrregular2Linear = True
   res1@trYReverse            = True
   res1@trYMinF            = 0.
   res1@trYMaxF            = 1015.
   res1@trXMinF     = sin(lolat*pi/180.)
   res1@trXMaxF     = sin(hilat*pi/180.)
   res1@tmXBMode        = "Explicit"

   xticks = new((/19/),float)
   do i = 0,19-1
     tmp = (i-9)*10.
     xticks(i) = sin(tmp*pi/180.)
   end do
   delete(tmp)
   res1@tmXBValues      = xticks
   res1@tmXBLabels      = (/"","-80","","-60","","-40","","-20","","0","","20","","40","","60","","80",""/)

   res0 = True
   res0 = res1
   res0@cnLinesOn        = True
   res0@cnFillOn         = False
   res0@cnLineThicknessF = 2
   res0@cnLineColor = "black"
   res0@cnLevelSelectionMode = "ExplicitLevels"
   res0@cnMaxLevelCount = 2
   res0@gsnContourNegLineDashPattern = 2
   res0@cnLevels = (/-1000.,0./)

   txres = True
   txres@txFontHeightF = 0.016
   yy = (/0.95,0.51/)

   lnres             = True
   lnres             = True
   lnres@gsLineColor = "black"
   xx0 = 0.173
   xx1 = 0.39
   xx2 = 0.61
   xx3 = 0.878

;****************************************
; Begin Loop
;************************************************

do n = 0,nfiles-1

  ncdf = addfile("../data/zonal-hgt/" + fname_in(n),"r")
  lat = ncdf->lat
  zbarup_diff = ncdf->$ZBAR(0)$(0,:,:)
  zbardn_diff = ncdf->$ZBAR(1)$(0,:,:)
  zqbarup_diff= ncdf->$ZQBAR(0)$(0,:,:)
  zqbardn_diff= ncdf->$ZQBAR(1)$(0,:,:)
  delete(ncdf)

  ncdf = addfile("../data/zonal-hgt/" + ptrop_in(n),"r")
  ptrop = todouble(ncdf->$PTROP(n)$(0,:))
  ptrop = ptrop/100.
  delete(ncdf)

  print("Computing global means using: " + ilevfile)
  ncdf = addfile("../data/zonal-hgt/" + ilevfile,"r")
  ilev_p = ncdf->ILEV_P
  delete(ncdf)

  ilevs = dimsizes(ilev_p)
  dp = ilev_p(1:ilevs-1) - ilev_p(0:ilevs-2)
  dp2d = conform(zbarup_diff,dp,0)

  gmean_zbarup_diff = dim_avg(dim_sum_n(dp2d*zbarup_diff,0)/dim_sum_n(dp2d,0))
  gmean_zbardn_diff = dim_avg(dim_sum_n(dp2d*zbardn_diff,0)/dim_sum_n(dp2d,0))
  gmean_zqbarup_diff = dim_avg(dim_sum_n(dp2d*zqbarup_diff,0)/dim_sum_n(dp2d,0))
  gmean_zqbardn_diff = dim_avg(dim_sum_n(dp2d*zqbardn_diff,0)/dim_sum_n(dp2d,0))
  delete([/dp,dp2d/])

  print("gmean_zbarup_diff: " + gmean_zbarup_diff)
  print("gmean_zbardn_diff: " + gmean_zbardn_diff)
  print("gmean_zqbarup_diff: " + gmean_zqbarup_diff)
  print("gmean_zqbardn_diff: " + gmean_zqbardn_diff)

  zbarup_diff@long_name = "global mean = " + decimalPlaces(gmean_zbarup_diff,4,False) + " K"
  zbardn_diff@long_name = "global mean = " + decimalPlaces(gmean_zbardn_diff,4,False) + " K"
  zqbarup_diff@units = "global mean = " + decimalPlaces(gmean_zqbarup_diff,8,False) + " K/s"
  zqbardn_diff@units = "global mean = " + decimalPlaces(gmean_zqbardn_diff,8,False) + " K/s"

  print("max " + VAR1 + ": " + max(zqbardn_diff))
  print("max " + VAR1 + ": " + max(zqbarup_diff))
  print("min " + VAR1 + ": " + min(zqbardn_diff))
  print("min " + VAR1 + ": " + min(zqbarup_diff))

  print("Plotting...")

  ;;res1@tiMainString = ""

  res1@cnMinLevelValF  = vmin
  res1@cnMaxLevelValF  = vmax
  res1@cnLevelSpacingF = vspace

  res1@lbLabelBarOn        = False
  ;;res1@tiXAxisString = "Latitude"
  plot(4*n)  = gsn_csm_contour(wks,zbarup_diff,res1)
  tmp = gsn_csm_contour(wks,zbarup_diff,res0)
  overlay(plot(4*n),tmp)
  delete([/tmp,zbarup_diff/])

  if (n.eq.nfiles-1) then
    res1@lbLabelBarOn        = True
    res1@lbTitlePosition      = "Top"
    res1@lbTitleFontHeightF   = 0.03
    res1@lbTitleString = "Latitude"
  end if

  plot(4*n+2)  = gsn_csm_contour(wks,zbardn_diff,res1)
  tmp = gsn_csm_contour(wks,zbardn_diff,res0)
  overlay(plot(4*n+2),tmp)
  delete([/tmp,zbardn_diff/])

  res1@cnMinLevelValF  = vminb
  res1@cnMaxLevelValF  = vmaxb
  res1@cnLevelSpacingF = vspaceb

  res1@lbLabelBarOn        = False
  plot(4*n+1)  = gsn_csm_contour(wks,zqbarup_diff,res1)
  nlat = dimsizes(lat)
  do i = 0,nlat-1
    indk = ind(zqbarup_diff&levs.le.ptrop(i))
    zqbarup_diff(indk,i) = zqbarup_diff@_FillValue 
    delete(indk)
  end do
  tmp = gsn_csm_contour(wks,zqbarup_diff,res0)
  overlay(plot(4*n+1),tmp)
  delete([/tmp,zqbarup_diff/])

  if (n.eq.nfiles-1) then
    res1@lbLabelBarOn        = True
    res1@lbTitleString = "Latitude"
  end if

  plot(4*n+3)  = gsn_csm_contour(wks,zqbardn_diff,res1)
  do i = 0,nlat-1
    indk = ind(zqbardn_diff&levs.le.ptrop(i))
    zqbardn_diff(indk,i) = zqbardn_diff@_FillValue
    delete(indk)
  end do
  tmp = gsn_csm_contour(wks,zqbardn_diff,res0)
  overlay(plot(4*n+3),tmp)
  delete([/tmp,zqbardn_diff/])

  ;;;add titles
  gsn_text_ndc(wks,titles(n),0.5,yy(n),txres)
  lnres@gsLineThicknessF = 1.
  lnres@gsLineColor = "black"
  gsn_polyline_ndc(wks,(/0.173,xx1/),(/yy(n),yy(n)/)+0.005,lnres)
  gsn_polyline_ndc(wks,(/xx2,0.878/),(/yy(n),yy(n)/)+0.005,lnres)
  ;;drawNDCGrid(wks)

  if (n.eq.nfiles-1) then
    txres@txFontHeightF = 0.013
    gsn_text_ndc(wks,lbarnams(0),0.34,0.02,txres)
    gsn_text_ndc(wks,lbarnams(1),0.72,0.02,txres)
  end if

  ;;; Tropopause Line
  copy_VarCoords(lat,ptrop)
  lnres@gsLineThicknessF = 4.
  lnres@gsLineColor = "magenta"
  lstr = unique_string("dum")
  plot@$lstr$ = gsn_add_polyline(wks,plot(4*n+1),lat,ptrop,lnres)
  lstr = unique_string("dum")
  plot@$lstr$ = gsn_add_polyline(wks,plot(4*n+3),lat,ptrop,lnres)
  delete([/ptrop,lat/])

end do

;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnMaximize = False;True
  resP@gsnPaperOrientation = "portrait"
  resP@gsnPanelTop      = 0.95
  resP@gsnPanelBottom   = 0.07

  resP@gsnPanelFigureStrings = labels
  resP@gsnPanelFigureStringsFontHeightF = 0.009
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopLeft"

  gsn_panel(wks,plot,(/4,2/),resP)               ; now draw as one plot
  frame(wks)

end
