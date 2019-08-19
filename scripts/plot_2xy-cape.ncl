load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  dir = "../data/vomg/ten-30deg/"
  fname_vomg= (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-diags.subt.nc", \
                "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-diags.subt.nc", \
                "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-diags.subt.nc", \
                "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-diags.subt.nc", \
                "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-diags.subt.nc", \
                "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-diags.subt.nc"/)
  dx   = (/166.8,111.2,83.4,55.6,41.7,27.8/)
  ndx  = dimsizes(dx)

;;;define VARS

  pltNam = "temp_cape"

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

  resf@tmBorderThicknessF = 4.
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

  resln		    = True
  resln@gsLineThicknessF = 4.
  resln@gsLineColor = "Black"
  ;resln@tfPolyDrawOrder  = "PreDraw"

;;;;set up plots

  ;resf@trXReverse = True
  resf@trXMinF = 10.
  resf@trXMaxF = 180.
  resf@tiXAxisString = "~F33~D~F21~x (km)"
  resf@trYMinF = 0.2 
  resf@trYMaxF = 0.8
  resf@tiYAxisString = "A~B~x~N~ (unitless)"
  plot(1) = gsn_csm_blank_plot(wks,resf)

  resf@trYMinF =   0.
  resf@trYMaxF = 120.
  resf@tiYAxisString = "Dilute-CAPE (J/kg)"
  plot(0) = gsn_csm_blank_plot(wks,resf)

;;;load files

   ;;10-20 deg latitude
   gtzero     = (/  64.0868,  61.3863,  58.6819,  54.6244,  50.4321,  41.9134/)
   alls       = (/  68.6206,  65.3849,  62.9348,  59.1431,  55.4684,  48.4211/)
   ltzero     = (/ 102.5884,  92.6241,  86.8097,  79.8579,  73.8665,  64.0278/)


   ;;10-30 deg latitude
   gtzero     = (/  54.4207,  52.8203,  50.6630,  46.3680,  42.5683,  32.5088/)
   alls       = (/  60.2494,  57.6075,  55.4193,  51.1499,  47.6363,  39.3129/)
   ltzero     = (/  81.0734,  69.8895,  67.5836,  63.1350,  59.4726,  53.5618/)

;;---begin loop----;;

   res@gsMarkerIndex = 2 
   res@gsMarkerSizeF = 26
   res@gsMarkerThicknessF = 6

   do n = 0,ndx-1

     fv  = addfile(dir + fname_vomg(n),"r")

     fd = fv->FRACVDtr
     fu = fv->FRACVUtr
     delete(fv)

;--------------------------------------------------------------------

     deriv = fu*ltzero(n) + fd*gtzero(n) 

     res@gsMarkerColor = "blue"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(1),dx(n),fd,res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),gtzero(n),res)

     res@gsMarkerColor = "grey"
     pNam = unique_string("grey")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),deriv,res)

     res@gsMarkerColor = "black"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),alls(n),res)

     res@gsMarkerColor = "red"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(1),dx(n),fu,res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(0),dx(n),ltzero(n),res)

;--------------------------------------------------------------------
   end do

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
  resP@gsnPanelFigureStrings = (/"a.","b.","c.","d."/)
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopLeft"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/1,2/),resP)               ; now draw as one plot

frame(wks)

end

