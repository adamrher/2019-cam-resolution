load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  dir = "pm10deg/"
  fname_vomg= (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-diags.nc"/)
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
  plot = new( (/4/), "graphic")

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

  resln		    = True
  resln@gsLineThicknessF = 4.
  resln@gsLineColor = "Black"
  ;resln@tfPolyDrawOrder  = "PreDraw"

;;;;set up plots

  ;resf@trXReverse = True
  resf@trXMinF = 10.
  resf@trXMaxF = 180.
  resf@trYMinF = 0.28;1 
  resf@trYMaxF = 0.72
  resf@tiYAxisString = "A~B~x~N~ (unitless)"
  plot(1) = gsn_csm_blank_plot(wks,resf)

  resf@trYMinF = 60.
  resf@trYMaxF = 260.
  resf@tiYAxisString = "Dilute-CAPE (J/kg)"
  plot(0) = gsn_csm_blank_plot(wks,resf)

  resf@tiXAxisString = "~F33~D~F21~x (km)"
  plot(2) = gsn_csm_blank_plot(wks,resf)
  plot(3) = gsn_csm_blank_plot(wks,resf)

;;;load files

;  ;;+/- 15 deg latitude
;  gtzero      = (/  82.8044,  73.8467,  70.1072,  67.9489,  64.6134,  58.7798 /)
;  nodil       = (/ 1.0932e3, 889.1695, 891.9638, 971.2632, 971.8218, 1.1282e3 /)
;  alls        = (/ 131.5053, 118.3354, 103.9578,  94.1275,  86.3432,  78.9989 /)
;  ltzero      = (/ 223.5365, 220.5897, 209.3761, 191.1044, 165.8117, 136.5833 /)
;
;  ;;+/- 15 deg latitude - fix to ne20  
;  ftgtz      = (/  82.8044,  85.4996,  86.1298,  92.3453,  94.2358,  93.2553/)
;  ftall      = (/ 131.5053, 138.1280, 128.4237, 124.1420, 117.7241, 108.3097/)
;  ftltz      = (/ 223.5365, 249.1192, 243.3280, 233.7283, 220.9310, 185.0471/)
;  
;  fqgtz      = (/  82.8044,  71.5088,  66.8382,  58.9639,  53.5157,  47.2261/)
;  fqall      = (/ 131.5053, 112.0894, 106.3998,  99.1142,  91.0941,  92.4220/)
;  fqltz      = (/ 223.5365, 195.2198, 189.9501, 181.2188, 168.7774, 175.3694/)
;
  ;;+/- 10 deg latitude
  gtbar      = (/  82.8211,  74.5845,  68.6843,  65.2479,  61.4963,  59.4162/)
  gtzero     = (/ 105.1276,  97.0794,  87.6346,  81.5092,  74.5918,  71.9455/)
  nodil      = (/ 1.7502e3, 1.5816e3, 1.5649e3, 1.6197e3, 1.5897e3, 1.7374e3/)  
  alls       = (/ 197.4628, 193.2785, 176.008 , 156.9239, 133.04  , 122.3409/)
  ltzero     = (/ 239.7089, 243.0824, 237.629 , 225.455 , 209.1903, 187.4387/)

  ;;+/- 10 deg latitude - fix to ne20
  ftgtz      = (/ 105.1276, 115.2960, 112.9126, 116.6751, 115.3201, 113.1966/)
  ftall      = (/ 197.4628, 219.1645, 208.9318, 199.8531, 189.1317, 172.4771/)
  ftltz      = (/ 239.7089, 268.7620, 269.2932, 267.0015, 263.7162, 237.3953/)

  fqgtz      = (/ 105.1276,  87.3774,  80.4520,  70.4554,  62.4172,  61.9254/)
  fqall      = (/ 197.4628, 171.8863, 165.0107, 154.9017, 141.7121, 147.4342/)
  fqltz      = (/ 239.7089, 214.2533, 208.4047, 198.4378, 185.4481, 189.8350/)

;  ;;+/- 10 deg latitude - fix to ne30
;  ftgtz      = (/  86.9240,  97.0794,  94.7078,  98.4681,  97.1202,  94.9993/)
;  ftall      = (/ 171.6148, 193.2785, 183.0654, 174.0148, 163.3255, 146.7128/)
;  ftltz      = (/ 214.0988, 243.0824, 243.6147, 241.3324, 238.0589, 211.8067/)
;
;  fqgtz      = (/ 114.8394,  97.0794,  90.1529,  80.1515,  70.8340,  71.6163/) 
;  fqall      = (/ 218.8903, 193.2785, 186.3937, 176.2634, 163.0533, 168.7717/)
;  fqltz      = (/ 268.6044, 243.0824, 237.2185, 228.0795, 214.3127, 227.1629/)

   ;;+/- 10 deg latitude - moisture/temperature with mean swap

   mtgtz      = (/ 117.3641, 100.0977,  90.3692,  83.5074,  72.5883,  71.1939/)
   mtltz      = (/ 233.6848, 236.7795, 230.2356, 217.8735, 201.3416, 180.9860/)

   mqgtz      = (/ 184.5795, 180.4862, 164.4374, 147.6592, 125.2140, 116.3727/)
   mqltz      = (/ 222.2921, 199.3760, 183.1405, 164.2170, 140.5762, 128.5355/)

;;---begin loop----;;

   res@gsMarkerIndex = 2 
   res@gsMarkerSizeF = 26
   res@gsMarkerThicknessF = 6

   do n = 0,ndx-1

     fv  = addfile("../data/vomg/" + dir + fname_vomg(n),"r")

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

     res@gsMarkerColor = "red"

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),mtltz(n),res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),mqltz(n),res)

     res@gsMarkerColor = "blue"
     
     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(2),dx(n),mtgtz(n),res)

     pNam = unique_string("tmp")
     plot@$pNam$ = gsn_add_polymarker(wks,plot(3),dx(n),mqgtz(n),res)

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
  gsn_panel(wks,plot,(/2,2/),resP)               ; now draw as one plot

frame(wks)

end

