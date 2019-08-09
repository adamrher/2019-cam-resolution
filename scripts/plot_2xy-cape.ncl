load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  fname_vomg= (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-diags.tol.nc", \
                "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-diags.tol.nc", \
                "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-diags.tol.nc", \
                "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-diags.tol.nc", \
                "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-diags.tol.nc", \
                "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-diags.tol.nc"/)

  dx   = (/166.8,111.2,83.4,55.6,41.7,27.8/)
  ndx  = dimsizes(dx)

;;;define VARS

  pltNam = "temp_cape"

  xall = new( (/4,ndx/), "double")

  secpday = 60.*60.*24.

;******************************************************
; create plot
;******************************************************
  wkstype = "pdf"
  wks = gsn_open_wks(wkstype,pltNam)               ; open workstation
  plot = new( (/2/), "graphic")

  resf                        = True

  resf@gsnMaximize      = False
  resf@gsnDraw          = False        ; don't draw plot
  resf@gsnFrame         = False        ; don't advance frame

  resf@tmXUseBottom = True

  resf@tmXMajorGridThicknessF = 1.
  resf@tmYMajorGridThicknessF = 1.
  resf@tmXMinorGridThicknessF = 0.5
  resf@tmYMinorGridThicknessF = 0.5

  resf@tmXBMajorThicknessF = 1.
  resf@tmYRMajorThicknessF = 1.
  resf@tmXTMajorThicknessF = 1.
  resf@tmYLMajorThicknessF = 1.

  resf@tmBorderThicknessF = 3.
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
  resf@tmXMajorGridThicknessF      = 1.0
  resf@tmXMajorGridLineDashPattern = 2

  resf@tmYMajorGrid= True
  resf@tmYMajorGridThicknessF      = 1.0
  resf@tmYMajorGridLineDashPattern = 2

  res                      = True         ; plot modifications desired
  res@gsMarkerIndex = 2
  res@gsMarkerSizeF = 22
  res@gsMarkerThicknessF = 6

  resln		    = True
  resln@gsLineThicknessF = 4.
  resln@gsLineColor = "Black"
  ;resln@tfPolyDrawOrder  = "PreDraw"

;;;;set up plots

  ;resf@trXReverse = True
  resf@trXMinF = 10.
  resf@trXMaxF = 180.
  resf@tiXAxisString = "~F33~D~F21~x~B~dyn~N~ (km)"
  resf@trYMinF = 0.28;1 
  resf@trYMaxF = 0.72
  resf@tiYAxisString = "A~B~x~N~ (unitless)"
  plot(1) = gsn_csm_blank_plot(wks,resf)

  resf@trYMinF = 50.
  resf@trYMaxF = 250.
  resf@tiYAxisString = "Dilute-CAPE (J/kg)"
  plot(0) = gsn_csm_blank_plot(wks,resf)

;;;load files

  gtbar = (/82.8211,74.5845,68.6843,65.2479,61.4963,59.4162/)
  gtzero= (/105.1276,97.0794,87.6346,81.5092,74.5918,71.9455/)
  alls   = (/197.4628,193.2785,176.008,156.9239,133.04,122.3409/)
  ltzero= (/239.7089,243.0824,237.629,225.455,209.1903,187.4387/)

;;---begin loop----;;

   res@gsMarkerIndex = 2

   do n = 0,ndx-1

     fv  = addfile("../data/vomg/" + fname_vomg(n),"r")

     fdtol = fv->FRACVDtol
     fd = fv->FRACVDtr
     fu = fv->FRACVUtr
     delete(fv)

     xall(0,n) = fdtol
     xall(1,n) = fd
     xall(2,n) = fu

     guss = fu*ltzero(n) + fd*gtzero(n)

     res@gsMarkerColor = "blue"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),fdtol,res)

     pNam = unique_string("tmp")
     ;plot@$pNam$ = gsn_add_polymarker(wks,plot(1),dx(n),gtbar(n),res)

     res@gsMarkerColor = "deepskyblue1"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(1),dx(n),fd,res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),gtzero(n),res)

     res@gsMarkerColor = "grey"
     pNam = unique_string("grey")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),guss,res)

     res@gsMarkerColor = "black"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),alls(n),res)

     res@gsMarkerColor = "red"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(1),dx(n),fu,res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),ltzero(n),res)
   end do

   ;;;tmp = gsn_add_polyline(wks,plot(1),(/0.,200./), (/70.,70./), resln)

   print("max1: "+max(xall(0,:)))
   print("min1: "+min(xall(0,:)))

   print("max2: "+max(xall(1,:)))
   print("min2: "+min(xall(1,:)))

   print("max3: "+max(xall(2,:)))
   print("min3: "+min(xall(2,:)))

;;drawNDCGrid(wks)
;*****************************************************
; Plot panel
;*****************************************************

  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  ;resP@gsnPaperOrientation = "portrait"
  resP@gsnPanelBottom   = 0.05
  resPgsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelFigureStringsFontHeightF = 0.015
  ;resP@gsnPanelFigureStrings = (/"a.","b.","c."/)
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopRight"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/1,2/),resP)               ; now draw as one plot

frame(wks)

end

