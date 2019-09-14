load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  fname_glob= (/"physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.all-diags.nc", \
		"physgrid_180515_QPC6_ne30pg3_ne30pg3_mg17_180528.all-diags.nc", \
		"physgrid_180515_QPC6_ne30pg3_ne30pg3_mg17_180601-zmcin1.all-diags.nc", \
		"physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.all-diags.nc", \
		"physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180604-zmcin1.all-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_180608.all-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_180616-zmcin1.all-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_181023_ne80visc-loworder-dt675.all-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_181106_dt675.all-diags.nc", \
		"physgrid_180607_QPC6_ne120pg3_ne120pg3_mg17_180609_zmcin1.all-diags.nc", \
		"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180608.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180615-iwidth1.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180616-iwidth1-PCoM.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180617_bilin-ne20visc.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180617_ne20visc.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181008_skip-ho.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181020_ne20visc-loworder-dt2700.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181106_dt2700.all-diags.nc", \
		"physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.all-diags.nc", \
		"physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.all-diags.nc", \
		"physgrid_180607_QPC6_ne60pg2_ne60pg2_mg17_180608.all-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_180615-zmcin1.all-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.all-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181020_dt450.all-diags.nc", \
		"physgrid_180607_QPC6zmcin5_ne20pg3_ne20pg3_mg17_180607.all-diags.nc", \
		"physgrid_180607_QPC6zmcin5_ne40pg3_ne40pg3_mg17_180607.all-diags.nc"/)

  fname_omg = (/"physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.omg-diags.nc", \
		"physgrid_180515_QPC6_ne30pg3_ne30pg3_mg17_180528.omg-diags.nc", \
		"physgrid_180515_QPC6_ne30pg3_ne30pg3_mg17_180601-zmcin1.omg-diags.nc", \
		"physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.omg-diags.nc", \
		"physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180604-zmcin1.omg-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_180608.omg-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_180616-zmcin1.omg-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_181023_ne80visc-loworder-dt675.omg-diags.nc", \
		"physgrid_180607_QPC6_ne120pg2_ne120pg2_mg17_181106_dt675.omg-diags.nc", \
		"physgrid_180607_QPC6_ne120pg3_ne120pg3_mg17_180609_zmcin1.omg-diags.nc", \
		"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180608.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180615-iwidth1.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180616-iwidth1-PCoM.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180617_bilin-ne20visc.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_180617_ne20visc.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181008_skip-ho.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181020_ne20visc-loworder-dt2700.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg2_ne30pg2_mg17_181106_dt2700.omg-diags.nc", \
		"physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.omg-diags.nc", \
		"physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.omg-diags.nc", \
		"physgrid_180607_QPC6_ne60pg2_ne60pg2_mg17_180608.omg-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_180615-zmcin1.omg-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.omg-diags.nc", \
		"physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181020_dt450.omg-diags.nc", \
		"physgrid_180607_QPC6zmcin5_ne20pg3_ne20pg3_mg17_180607.omg-diags.nc", \
		"physgrid_180607_QPC6zmcin5_ne40pg3_ne40pg3_mg17_180607.omg-diags.nc"/)

  type = (/ 6, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 5, 0, 0, 0/)
  dx   = (/27.8,111.2,111.2,55.6,55.6,27.8,27.8,27.8,27.8,27.8,166.8,111.2,111.2,111.2, \
           111.2,111.2,111.2,111.2,111.2,111.2,83.4,55.6,41.7,41.7,41.7,166.8,83.4/)
  ndx  = dimsizes(dx)
  nfn  = dimsizes(type)
  print("ndx: "+ ndx)
  print("nfn: "+ nfn)

  colors = (/"gray60","blue","deepskyblue1","green","magenta","red","black"/)

;;;define VARS

  VARS1 = "FRACDgl*OMGDgl"
  MIN1  = 2.8
  MAX1  = 5.1
  nams1 = "~F34~a~F21~f~B~d~N~~F34~qa~F33~w~F21~~B~d~N~~F34~q~F21~ (~F34~4~F21~10~S~2~N~ Pa/s)"

  VARS2 = "FREQZMgl"
  MIN2 = 0.31
  MAX2 = 0.58
  nams2 = "~F14~FREQZM"

  OMGD  = "OMGDgl"
  FRACD = "FRACDgl"


  pltNam = "temp_diags_corr"

  VARS = (/VARS1,VARS2/)
  MAX =  (/ MAX1, MAX2/)
  MIN =  (/ MIN1, MIN2/)
  nams = (/nams1,nams2/)

  nvars = dimsizes(VARS)
  xall = new( (/nvars,nfn/), "double")
  omg = new( (/nfn/), "double")
  secpday = 60.*60.*24.

;******************************************************
; create plot
;******************************************************
  wkstype = "pdf"
  wks = gsn_open_wks(wkstype,pltNam)               ; open workstation
  plot = new( (/1/), "graphic")

  resf                        = True

  resf@gsnMaximize      = False
  resf@gsnDraw          = False        ; don't draw plot
  resf@gsnFrame         = False        ; don't advance frame

  resf@tmXUseBottom = True

  resf@tmXMajorGridThicknessF = 3.
  resf@tmYMajorGridThicknessF = 3.
  resf@tmXMinorGridThicknessF = 1.
  resf@tmYMinorGridThicknessF = 1.

  resf@tmXBMajorThicknessF = 3.
  resf@tmYRMajorThicknessF = 3.
  resf@tmXTMajorThicknessF = 3.
  resf@tmYLMajorThicknessF = 3.

  resf@tmBorderThicknessF = 6.
  resf@tmXBMajorOutwardLengthF = 0.
  resf@tmYLMajorOutwardLengthF = 0.
  resf@tmXBMinorOutwardLengthF = 0.
  resf@tmYLMinorOutwardLengthF = 0.
  resf@tmXTMajorOutwardLengthF = 0.
  resf@tmYRMajorOutwardLengthF = 0.
  resf@tmXTMinorOutwardLengthF = 0.
  resf@tmYRMinorOutwardLengthF = 0.

  resf@tiXAxisFontHeightF = 0.03
  resf@tiYAxisFontHeightF = 0.03
  resf@tmXBLabelFontHeightF = 0.025
  resf@tmYLLabelFontHeightF = 0.025

  ;resf@vpWidthF            = 0.5           ; change aspect ratio of plot
  ;resf@vpHeightF           = 0.5
  ;resf@vpXF                = 0.4
  ;resf@vpYF                = 0.4

  resf@tmXMajorGrid= True
  resf@tmXMajorGridThicknessF      = 3.
  resf@tmXMajorGridLineDashPattern = 2

  resf@tmYMajorGrid= True
  resf@tmYMajorGridThicknessF      = 3.
  resf@tmYMajorGridLineDashPattern = 2

  res                      = True         ; plot modifications desired
  res@gsMarkerIndex = 2

  resln		    = True
  resln@gsLineThicknessF = 6.
  resln@gsLineColor = "Black"
  resln@tfPolyDrawOrder  = "PreDraw"

;;;;set up plots

   resf@trYMinF = MIN(1)
   resf@trYMaxF = MAX(1)
   resf@tiYAxisString = nams(1)

   resf@tiXAxisString = nams(0)
   resf@trXMinF                = MIN(0)
   resf@trXMaxF                = MAX(0)

   plot(0) = gsn_csm_blank_plot(wks,resf)

;;;load files

;;---begin loop----;;

 do n = 0,nfn-1
 
   print("Begin case " + n)

   fg  = addfile("../data/globalav/" + fname_glob(n),"r")
   fo  = addfile("../data/globalav/" + fname_omg(n),"r")

   omgd = fo->$OMGD$
   omgd = omgd*100./secpday
   omgd = omgd*100.
   fracd = fo->$FRACD$
   var1 = omgd*fracd

   var2 = fg->$VARS(1)$
   delete([/fo,fg/])

   xall(0,n) = var1
   xall(1,n) = var2

   res@gsMarkerColor = colors(type(n))
   if (type(n).ne.0) then
     res@gsMarkerSizeF = 90
     res@gsMarkerThicknessF = 28
   else
     res@gsMarkerSizeF = 50
     res@gsMarkerThicknessF = 12
   end if

   pNam = unique_string("tmp")
   plot@$pNam$ = gsn_add_polymarker(wks,plot(0),var1,var2,res)

   delete([/var1,var2,omgd,fracd/])

 end do

 coef = regline(xall(0,:),xall(1,:))
 a0 = coef@yintercept
 a1 = coef
 print("a0: " + a0)
 print("a1: " + a1)
 xx = (/MIN1,MAX1/)
 yy = a0 + a1*xx
 pNam = unique_string("tmp")
 plot@$pNam$ = gsn_add_polyline(wks,plot(0),xx,yy,resln)

 print("stderr: " + coef@rstd)
 print("Pearson:" + escorc(xall(0,:),xall(1,:)))
 print("")

 print("max1: "+max(xall(0,:)))
 print("min1: "+min(xall(0,:)))

 print("max2: "+max(xall(1,:)))
 print("min2: "+min(xall(1,:)))

 delete([/xx,yy/])
;*****************************************************
; Add legend
;*****************************************************
 txres = True
 txres@txFontHeightF = 0.03
 txres@txJust = "CenterLeft"

 res@gsMarkerSizeF = 30
 res@gsMarkerThicknessF = 6
 label = (/"   ne20", \
           "   ne30", \
           "   ne40", \
           "   ne60", \
           "   ne80", \
           "   ne120"/)
 nlabels = dimsizes(label)

 yy = (/0.95,0.91,0.87,0.83,0.79,0.75,0.71/) - 0.03
 xx = 0.817;65
 do n = 0,nlabels-1
   res@gsMarkerColor = colors(n+1)
   gsn_polymarker_ndc(wks,(/xx,xx/),(/yy(n),yy(n)/),res)
   gsn_text_ndc(wks,label(n),xx,yy(n),txres)
 end do

;;drawNDCGrid(wks)
;*****************************************************
; Plot panel
;*****************************************************

  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  ;resP@gsnPaperOrientation = "portrait"
  resP@gsnPanelBottom   = 0.05
  resP@gsnPanelFigureStringsFontHeightF = 0.02
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "BottomLeft"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/1,1/),resP)               ; now draw as one plot

frame(wks)

end

