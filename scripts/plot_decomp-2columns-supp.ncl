;**************************************
;plot_decomp.ncl
;**************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
;******************************************************
;
;******************************************************

  dir      = "../data/pdecomp/"
  fname_in = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc", \
	       "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc", \
	       "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc", \
	       "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc", \
	       "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc", \
	       "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.pdecomp.OMEGA850-Q850-PRECL-pm15deg.nc"/)

  nfiles   = dimsizes(fname_in)

  xtitle = "~F8~w~F10~~B~850~N~~F21~ (hPa/day)"
  ytitle = "~F10~q~B~850~N~~F21~ (g/kg)"

  xmin     = -12.
  xmax     =  5.
  ymin     =  0.
  ymax     = 17.

  pltName = "temp_pdecomp_supp"

  labels = new( (/2*nfiles/), "string") 
  dx    = (/"ne20", \
            "ne30", \
            "ne40", \
            "ne60", \
            "ne80", \
            "ne120"/)

;******************************************************
; create plot
;******************************************************
  wkstype = "pdf"
  wks = gsn_open_wks(wkstype,pltName)               ; open workstation
  ;gsn_define_colormap(wks,"BlAqGrYeOrReVi200")   ; choose colormap
  gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")
  ;wkstype@wkBackgroundOpacityF    = 0.
  gsn_reverse_colormap(wks)
  plot = new( (/2*nfiles/), "graphic")

  res                      = True
  res@gsnMaximize          = False
  res@gsnDraw              = False        ; don't draw plot
  res@gsnFrame             = False        

  res@cnFillOn          = True               ; turn on color fill
  res@cnLinesOn         = False
  res@gsnSpreadColors   = True               ; use full range of color map
  res@cnLineLabelsOn       = False
  res@cnInfoLabelOn        = False

  res@cnFillMode = "CellFill"

  res@tmBorderThicknessF = 1.5 ;axes thickness
  res@tmXBMajorOutwardLengthF = 0.
  res@tmYLMajorOutwardLengthF = 0.
  res@tmXBMinorOutwardLengthF = 0.
  res@tmYLMinorOutwardLengthF = 0.
  res@tmXTMajorOutwardLengthF = 0.
  res@tmYRMajorOutwardLengthF = 0.
  res@tmXTMinorOutwardLengthF = 0.
  res@tmYRMinorOutwardLengthF = 0.

  res@tmXTMajorThicknessF = 1.5
  res@tmXBMajorThicknessF = 1.5
  res@tmYLMajorThicknessF = 1.5
  res@tmYRMajorThicknessF = 1.5

  res@tiXAxisFontHeightF = 0.030
  res@tiYAxisFontHeightF = 0.030
  res@tmXBLabelFontHeightF = 0.022
  res@tmYLLabelFontHeightF = 0.022

  res@vpWidthF            = 0.5           ; change aspect ratio of plot
  res@vpHeightF           = 0.5

 do n = 0,nfiles-1

   print("begin case " + n)

   f  = addfile (dir+fname_in(n),"r")
   tmp0 = f->fbar
   tmp1 = f->Pbar
   Q    = f->q
   omg  = f->omega

   tmp2 = transpose(tmp0)
   Pbar = transpose(tmp1)

   fbar = tofloat(tmp2)
   fbar!0 = "q"
   fbar&q = Q
   fbar!1 = "omega"
   fbar&omega = omg

     fbar = where(fbar.eq.0.,fbar@_FillValue,fbar)
     fbar = log10(fbar)

     Pbar = where(Pbar.eq.0.,Pbar@_FillValue,Pbar)
     Pbar = log10(Pbar)

print("max Pbar" + max(Pbar))
print("min Pbar" + min(Pbar))

   res@lbLabelBarOn         = False
   if (n.eq.nfiles-1)
     ;;res@tmXBLabelsOn         = True
     res@lbLabelBarOn         = True
     res@lbBoxSeparatorLinesOn= False
     res@lbTitleString = xtitle
     res@lbTitlePosition      = "Top"
     res@lbTitleFontHeightF   = res@tiYAxisFontHeightF
   end if

   res@trXMinF                = xmin
   res@trXMaxF                = xmax

   res@tiYAxisString          = ytitle
   res@trYMinF                = ymin
   res@trYMaxF                = ymax

   labels(2*n) = "~F10~M~B~s~N~~F21~ (" + dx(n) + ")"


   ;;res@tmYLLabelsOn         = True
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMinLevelValF  =   -3.;;
   res@cnMaxLevelValF  =    3.;350.;;0.06
   res@cnLevelSpacingF =    0.1;;0.0005
   plot(2*n) = gsn_csm_contour(wks,Pbar,res)
   delete(res@tiYAxisString)

   Ptot = Pbar*fbar
   Ptot!0 = "q"
   Ptot&q = Q
   Ptot!1 = "omega"
   Ptot&omega = omg

   labels(2*n+1) = "~F10~f~B~s~N~~F21~ (" + dx(n) + ")"

   ;;res@tmYLLabelsOn         = False
   res@cnMinLevelValF  =   -9.
   res@cnMaxLevelValF  =   -1.;;0.045;
   res@cnLevelSpacingF =    0.1;;0.00025;
   plot(2*n+1) = gsn_csm_contour(wks,fbar,res)

   delete([/tmp0,tmp1,tmp2,Ptot/])
   delete([/Pbar,fbar,Q,omg/])

 end do

;*****************************************************
; Add label bar label
;*****************************************************
 txres = True
 txres@txFontHeightF = 0.007
 txres@txJust = "CenterCenter"

 lbtitle1 = "LOG(~F10~M~B~s~N~~F21~) (mm/day)"
 lbtitle2 = "LOG(~F10~f~B~s~N~~F21~) (unitless)"
 gsn_text_ndc(wks,lbtitle1,0.425,0.01,txres)
 gsn_text_ndc(wks,lbtitle2,0.61,0.01,txres)

 ;;drawNDCGrid(wks)

;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot

  resP@gsnPanelFigureStrings = labels
  resP@gsnPanelFigureStringsFontHeightF = 0.007
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "BottomLeft"

  resP@gsnPanelBottom   = 0.065
  resP@gsnPanelXWhiteSpacePercent = 1.
  resP@gsnPanelYWhiteSpacePercent = 1.
  gsn_panel(wks,plot,(/nfiles,2/),resP)               ; now draw as one plot

frame(wks) 

end

