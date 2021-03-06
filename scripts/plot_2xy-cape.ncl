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

  pltNam = "temp_cape-subtropics"

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

  resf@trYMinF =  10.
  resf@trYMaxF = 110.
  resf@tiYAxisString = "Dilute-CAPE (J/kg)"
  plot(0) = gsn_csm_blank_plot(wks,resf)

  if (senstest) then
    plot(2) = gsn_csm_blank_plot(wks,resf)
    plot(3) = gsn_csm_blank_plot(wks,resf)
  end if

;;;load files

   ;;10-30 deg latitude
   gtzero     = (/  54.4207,  52.8203,  50.6630,  46.3680,  42.5683,  32.5088/)
   alls       = (/  60.2494,  57.6075,  55.4193,  51.1499,  47.6363,  39.3129/)
   ltzero     = (/  81.0734,  69.8895,  67.5836,  63.1350,  59.4726,  53.5618/)

   ;;10-30 deg latitude fix to ne20 q profile
   fqgtz      = (/  54.4207,  47.6159,  47.9118,  42.7834,  41.1963,  38.3850/)
   fqalls     = (/  60.2494,  58.6018,  58.7836,  54.3978,  52.5390,  46.5009/)
   fqltz      = (/  81.0734,  90.9758,  89.8299,  85.1896,  82.5334,  66.8545/)

   ;;10-30 deg latitude fix to ne20 T profile
   ftgtz      = (/  54.4207,  59.7078,  57.2560,  58.0277,  55.7975,  48.3512/)
   ftalls     = (/  60.2494,  59.4268,  57.0559,  57.1198,  55.4486,  52.8894/)
   ftltz      = (/  81.0734,  59.8075,  57.2028,  55.1835,  54.0333,  60.5971/)

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

;*****************************************************
; Add legend
;*****************************************************
 txres = True
 txres@txFontHeightF = 0.0175
 txres@txJust = "CenterLeft"

 res@gsMarkerIndex = 2
 res@gsMarkerSizeF = 20;26
 res@gsMarkerThicknessF = 5;6
 label = (/"    Ascending Columns", \
           "    Descending Columns", \
           "    All Columns"/)
 nlabels = dimsizes(label)

 yy = 0.775
 xx = (/0.15,0.45,0.77/)
 colors = (/"red","blue","black"/)
 do n = 0,nlabels-1
   res@gsMarkerColor = colors(n)
   gsn_polymarker_ndc(wks,(/xx(n),xx(n)/),(/yy,yy/),res)
   gsn_text_ndc(wks,label(n),xx(n),yy,txres)
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

