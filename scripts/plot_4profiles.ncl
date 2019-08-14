load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************
  tropics = True

  dir = (/"pm10deg/","pm15deg/"/)
  fname_vomg= (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.vomg-diags.nc", \
                "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.vomg-diags.nc", \
                "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.vomg-diags.nc"/)
  nfiles = dimsizes(fname_vomg)

  label = (/"  ne20", \
  	    "  ne30", \
	    "  ne40", \
	    "  ne60", \
	    "  ne80", \
	    "  ne120"/)

  colors = (/"blue","deepskyblue1","green","magenta","red","black"/)
  title = (/"~F34~1~F21~10~F135~G~F21~ latitude", \
	    "~F34~1~F21~15~F135~G~F21~ latitude"/)

;;;define VARS

  pltNam = "temp_profiles"

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

  resf@tiXAxisFontHeightF = 0.02
  resf@tiYAxisFontHeightF = 0.02
  resf@tmXBLabelFontHeightF = 0.02
  resf@tmYLLabelFontHeightF = 0.02

  ;resf@vpWidthF            = 0.5           ; change aspect ratio of plot
  ;resf@vpHeightF           = 0.5
  ;resf@vpXF                = 0.4
  ;resf@vpYF                = 0.4

  resf@tiYAxisString = "Pressure (hPa)"
  resf@trYMinF                = 0.
  resf@trYMaxF                = 1010.
  resf@trYReverse             = True

  resf@tmXMajorGrid= True
  resf@tmXMajorGridThicknessF      = 1.0
  resf@tmXMajorGridLineDashPattern = 2

  resf@tmYMajorGrid= True
  resf@tmYMajorGridThicknessF      = 1.0
  resf@tmYMajorGridLineDashPattern = 2

  ;;add legend
  txres = True
  txres@txFontHeightF = 0.015
  txres@txJust = "CenterLeft"

  plres  = True                  ; polyline mods desired
  plres@gsLineDashPattern  = 0                    ; solid line
  plres@gsLineThicknessF  = 4.                   ; line thicker

  yy = (/ 0.72,0.70,0.68,0.66,0.64,0.62,0.60 /) + 0.2355
  xx = (/ 0.60,0.64 /)


;;;;set up plots

 resf@trXMinF =-0.7
 resf@trXMaxF = 0.7
 plot(0) = gsn_csm_blank_plot(wks,resf)
 resf@tiXAxisString = "T(descending) minus Tbar (K)"
 plot(2) = gsn_csm_blank_plot(wks,resf)
 delete(resf@tiXAxisString)

 resf@trXMinF =-1.4;-0.0006;;-0.0012
 resf@trXMaxF = 0.01
 plot(1) = gsn_csm_blank_plot(wks,resf)
 resf@tiXAxisString = "Q(descending) minus Qbar (g/kg)"
 plot(3) = gsn_csm_blank_plot(wks,resf)

;;;;;;;;;;need to generalize this to grab hyam,hybm from somewhere else
 vname = "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617"
 vdate = ".cam.h0.0001-01.nc"
 f = addfile("/glade/scratch/aherring/" + vname + "/run/" + vname + vdate,"r")
 hyam = f->hyam
 hybm = f->hybm
 delete(f)
;;;;;;;;;;

 cpd = 1.00464d3
 Rd = 2.870423d2 ;J/kg/K
 p0 = 1000.d2
 nlevs = dimsizes(hyam)
 linlog = 2
;;---begin loop----;;

do m = 0,1

 do n = 0,nfiles-1
 
   print("Begin case " + n)
   fv  = addfile("../data/vomg/" + dir(m) + fname_vomg(n),"r")

   fd = fv->FRACVDtr
   ta = fv->TAtr
   td = fv->TDtr
   qa = fv->QAtr
   qd = fv->QDtr
   psa= fv->PSAtr
   psd= fv->PSDtr

   fu = fv->FRACVUtr
   tu = fv->TUtr
   qu = fv->QUtr
   delete(fv)

   print("check weights")
   tderiv = fu*tu + fd*td
   qderiv = fu*qu + fd*qd
   tdiff = ta - tderiv
   qdiff = qa - qderiv
   print("max abs(tdiff) " + max(abs(tdiff)))
   print("max abs(qdiff) " + max(abs(qdiff)))

   ta = ta
   td = td
   qa = qa*1000.
   qd = qd*1000.

   pmd = hyam*p0 + hybm*psd
   pma = hyam*p0 + hybm*psa

   td_a = int2p(pmd,td,pma,linlog)
   qd_a = int2p(pmd,qd,pma,linlog)

   resf@xyLineThicknessF = 5.
   resf@xyLineColors = colors(n)
   resf@xyDashPatterns = 0

   tdiff = td_a-ta
   qdiff = qd_a-qa
   tdiff@long_name = title(m)
   qdiff@long_name = title(m)

   pNam = gsn_csm_xy(wks,tdiff,pma/100.,resf)
   overlay(plot(2*m),pNam)
   delete(pNam)

   pNam = gsn_csm_xy(wks,qdiff,pma/100.,resf)
   overlay(plot(2*m+1),pNam)
   delete(pNam)

   plres@gsLineColor       = colors(n)
   gsn_polyline_ndc(wks,xx,(/yy(n),yy(n)/),plres)
   gsn_text_ndc(wks,label(n),xx(1),yy(n),txres)

 end do

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
  resP@gsnPanelFigureStrings = (/ "a.","b.","c.","d." /)
  ;resP@gsnPanelFigureStringsPerimOn     = True
  ;resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  ;resP@amJust           = "TopRight"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/2,2/),resP)               ; now draw as one plot

frame(wks)

end

