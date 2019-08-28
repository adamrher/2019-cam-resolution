load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  dir = "../data/vomg/global/"
  fname_vomg= (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-diags.nc"/)
  dx   = (/166.8,111.2,83.4,55.6,41.7,27.8/)
  ndx  = dimsizes(dx)

;;;define VARS

  pltNam = "temp_cape-global"

  secpday = 60.*60.*24.

  ;;do additional panels where T/q fixed to ne20
  senstest = False

;******************************************************
; create plot
;******************************************************
  wkstype = "pdf"
  wks = gsn_open_wks(wkstype,pltNam)               ; open workstation
  if (senstest) then
    plot = new( (/4/), "graphic")
  else
    plot = new( (/2/), "graphic")
  end if

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
  resf@trYMinF = 0.24
  resf@trYMaxF = 0.76
  resf@tiYAxisString = "A~B~x~N~ (unitless)"
  plot(1) = gsn_csm_blank_plot(wks,resf)

  resf@trYMinF =  80.
  resf@trYMaxF = 180.
  resf@tiYAxisString = "Dilute-CAPE (J/kg)"
  plot(0) = gsn_csm_blank_plot(wks,resf)

  if (senstest) then
    plot(2) = gsn_csm_blank_plot(wks,resf)
    plot(3) = gsn_csm_blank_plot(wks,resf)
  end if

;;;load files

   ;;Global
   gtzero     = (/ 115.4410, 107.0787, 105.2508, 103.9897, 102.3260,  96.8863/) 
   alls       = (/ 136.8129, 128.6919, 122.4316, 118.0736, 113.5634, 105.2225/)
   ltzero     = (/ 152.9946, 140.5817, 133.5915, 130.1699, 127.6181, 121.2224/)

   ;;Global fix to ne20 q profile
   fqgtz      = (/ 115.4410, 102.5552,  96.6254,  89.5074,  84.9700,  81.1945/)
   fqalls     = (/ 136.8129, 129.1042, 124.8481, 121.6074, 119.0617, 113.7587/)
   fqltz      = (/ 152.9946, 139.9395, 131.0080, 125.9432, 122.4036, 120.4127/)

   ;;Global fix to ne20 T profile
   ftgtz      = (/ 115.4410, 120.1555, 126.2949, 133.2078, 136.1240, 133.9282/)
   ftalls     = (/ 136.8129, 136.3942, 134.3806, 133.2513, 131.6211, 129.5828/)
   ftltz      = (/ 152.9946, 153.6650, 150.5478, 135.9981, 128.4808, 126.7252/)

;;---begin loop----;;

   res@gsMarkerIndex = 2 
   res@gsMarkerSizeF = 26
   res@gsMarkerThicknessF = 6

   do n = 0,ndx-1

     fv  = addfile(dir + fname_vomg(n),"r")

     fd = fv->FRACVDgl
     fu = fv->FRACVUgl
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

if (senstest) then

     deriv = fu*fqltz(n) + fd*fqgtz(n)

     res@gsMarkerColor = "blue"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),fqgtz(n),res)

     res@gsMarkerColor = "grey"
     pNam = unique_string("grey")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),deriv,res)

     res@gsMarkerColor = "black"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),fqalls(n),res)

     res@gsMarkerColor = "red"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),fqltz(n),res)

     deriv = fu*ftltz(n) + fd*ftgtz(n)

     res@gsMarkerColor = "blue"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),ftgtz(n),res)

     res@gsMarkerColor = "grey"
     pNam = unique_string("grey")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),deriv,res)

     res@gsMarkerColor = "black"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),ftalls(n),res)

     res@gsMarkerColor = "red"
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),ftltz(n),res)

end if
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

  if (senstest) then
    gsn_panel(wks,plot,(/2,2/),resP)
  else
    gsn_panel(wks,plot,(/1,2/),resP)               ; now draw as one plot
  end if

frame(wks)

end

