load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  fname1 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.pdf-omg.nc", \
             "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.pdf-omg.nc", \
             "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.pdf-omg.nc", \
             "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.pdf-omg.nc", \
	     "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.pdf-omg.nc", \
             "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.pdf-omg.nc"/)

  fname2 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.pdf-omg_ne120-scale.nc", \
             "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.pdf-omg_ne120-scale.nc", \
             "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.pdf-omg_ne120-scale.nc", \
             "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.pdf-omg_ne120-scale.nc", \
             "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.pdf-omg_ne120-scale.nc", \
             "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.pdf-omg.nc"/)

  fname3 = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.pdf-omg.nc", \
             "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.pdf-omg_ne20-remap.nc", \
             "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.pdf-omg_ne20-remap.nc", \
             "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.pdf-omg_ne20-remap.nc", \
             "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.pdf-omg_ne20-remap.nc", \
             "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.pdf-omg_ne20-remap.nc"/)

  ncase = dimsizes(fname1)
  nbins = 200

  colors = (/"blue","deepskyblue1","green","magenta","red","black"/)

  label = (/"  ne20  (166.8km)", \
            "  ne30  (111.2km)", \
            "  ne40  (  83.4km)", \
            "  ne60  (  55.6km)", \
            "  ne80  (  41.7km)", \
            "  ne120(  27.8km)"/)

  pltNam = "temp_2pdf"
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

  resf@tmBorderThicknessF = 2.
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

  resf@tmXMajorGrid= True
  resf@tmXMajorGridThicknessF      = 1.0
  resf@tmXMajorGridLineDashPattern = 2

  resf@tmYMajorGrid= True
  resf@tmYMajorGridThicknessF      = 1.0
  resf@tmYMajorGridLineDashPattern = 2

;;;;set up plots

;*****************************************************
; pdf plot
;*****************************************************

  resf@xyYStyle ="Log"
  resf@trXReverse            = True
  resf@gsnXYBarChart            = True
  resf@gsnXYBarChartOutlineOnly = True

  resf@tmXMajorGrid= False
  resf@tmYMajorGrid= False

  ;;add legend
  txres = True
  txres@txFontHeightF = 0.011
  txres@txJust = "CenterLeft"

  plres  = True                  ; polyline mods desired
  plres@gsLineDashPattern  = 0                    ; solid line
  plres@gsLineThicknessF  = 2.                   ; line thicker

  yy = (/ 0.66,0.645,0.63,0.615,0.60,0.585,0.57 /)+0.07
  xx = (/ 0.13,0.15 /)

  ;;switch order of files
  fname1 = fname1(::-1)
  fname2 = fname2(::-1)
  fname3 = fname3(::-1)
  colors= colors(::-1)
  yy = yy(::-1)
  label = label(::-1)

;;----------
;;begin loop
;;----------

do n = 0,ncase-1

  print("Plotting case "+n)

  ncdf = addfile("../data/pdfs/raw/" + fname1(n), "r")
  var1 = ncdf->pdfvar1
  delete(ncdf)

  ncdf = addfile("../data/pdfs/scale/" + fname2(n), "r")
  var2 = ncdf->pdfvar1
  delete(ncdf)

  ncdf = addfile("../data/pdfs/remap/" + fname3(n), "r")
  var3 = ncdf->pdfvar1
  delete(ncdf)

  pvals1 = ind(var1.gt.0.d0)
  x1 = var1@bin_bounds(0:nbins-1)

  pvals2 = ind(var2.gt.0.d0)
  x2 = var2@bin_bounds(0:nbins-1)

  pvals3 = ind(var3.gt.0.d0)
  x3 = var3@bin_bounds(0:nbins-1)

  resf@xyLineThicknessF   = 2.5
  resf@xyLineColors       = colors(n)
  if (n.eq.0) then
    resf@tiYAxisString          = "P (fraction)"
    resf@tiXAxisString          = "~F33~w~F21~ (Pa/s)"
    resf@trXMinF                = -20.
    resf@trXMaxF                = 0.2
    resf@trYMinF                = 4.e-11
    resf@trYMaxF                = 1.
    plot(0) = gsn_csm_xy(wks,x1(pvals1),var1(pvals1)/100.,resf)

    resf@tiYAxisString          = "~F33~a~F21~P (fraction)"
    resf@tiXAxisString          = "~F33~w~F21~/~F33~a~F21~ (Pa/s)"
    plot(1) = gsn_csm_xy(wks,x2(pvals2),var2(pvals2)/100.,resf)

    resf@xyLineThicknessF = 2.
    resf@xyDashPattern = 2
    resf@xyCurveDrawOrder = "PreDraw"
    tmp2 = gsn_csm_xy(wks,x3(pvals3),var3(pvals3)/100.,resf)
    overlay(plot(0),tmp2)
    delete([/tmp2,resf@xyDashPattern/])

  else
    tmp0 = gsn_csm_xy(wks,x1(pvals1),var1(pvals1)/100.,resf)
    overlay(plot(0),tmp0)

    tmp1 = gsn_csm_xy(wks,x2(pvals2),var2(pvals2)/100.,resf)
    overlay(plot(1),tmp1)

    resf@xyLineThicknessF = 2.
    resf@xyDashPattern = 2 
    resf@xyCurveDrawOrder = "PreDraw"
    tmp2 = gsn_csm_xy(wks,x3(pvals3),var3(pvals3)/100.,resf)
    overlay(plot(0),tmp2)

    delete([/tmp0,tmp1,tmp2,resf@xyDashPattern/])
  end if
  delete([/pvals1,x1,var1,pvals2,x2,var2,pvals3,x3,var3/])

  plres@gsLineColor       = colors(n)
  gsn_polyline_ndc(wks,xx,(/yy(n),yy(n)/),plres)
  gsn_text_ndc(wks,label(n),xx(1),yy(n),txres)

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
  resP@gsnPanelFigureStrings = (/"a.","b.","c."/)
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopRight"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/1,2/),resP)               ; now draw as one plot

frame(wks)

end

