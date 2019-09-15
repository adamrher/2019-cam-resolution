load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;******************************************************
;
;******************************************************

  fname = (/"physgrid_180607_QPC6_ne20pg3_ne20pg3_mg17_181020_dt2700.kespectra-lev200-onemnth.nc", \
	    "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.kespectra-lev200-onemnth.nc", \
	    "physgrid_180607_QPC6_ne40pg3_ne40pg3_mg17_181020_dt1350.kespectra-lev200-onemnth.nc", \
	    "physgrid_180515_QPC6_ne60pg3_ne60pg3_mg17_180528.kespectra-lev200-onemnth.nc", \
	    "physgrid_180607_QPC6_ne80pg3_ne80pg3_mg17_181018.kespectra-lev200-onemnth.nc", \
	    "physgrid_180515_QPC6_ne120pg3_ne120pg3_mg17_180602.kespectra-lev200-onemnth.nc"/)
  ncase = dimsizes(fname)

  VARX = "XBAR"
  VARY = "SPECBAR"

  colors = (/"blue","deepskyblue1","green","magenta","red","black"/)
  colors4 = (/"blue4","deepskyblue4","green4","magenta4","red4","grey56"/)

  label = (/"  ne20", \
            "  ne30", \
            "  ne40", \
            "  ne60", \
            "  ne80", \
            "  ne120"/)

  pltNam = "temp_kespectra"
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

  resf@xyYStyle ="Log"
  resf@xyXStyle ="Log"

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

  resf@tiXAxisFontHeightF = 0.02
  resf@tiYAxisFontHeightF = 0.02
  resf@tmXBLabelFontHeightF = 0.02
  resf@tmYLLabelFontHeightF = 0.02

  resf@tmXMajorGrid= False
  resf@tmXMajorGridThicknessF      = 1.0
  resf@tmXMajorGridLineDashPattern = 2

  resf@tmYMajorGrid= False
  resf@tmYMajorGridThicknessF      = 1.0
  resf@tmYMajorGridLineDashPattern = 2

  resf@tmXUseBottom  = False
  resf@tmXTLabelsOn  = True
  resf@tmXTOn        = True
  resf@tmXTMode      = "Explicit"

  Re = 6.37122e3 ;km
  pi = 3.14159265358979
  L = 2*pi*Re ;equatorial circumference
  dist = (/10000.,1000.,100./)
  distminor = (/40000.,20000.,8000.,6000.,4000.,2000.,800.,600.,400.,200.,80.,60.,40.,20./)
  nn = L/dist
  nnminor = L/distminor

  resf@tmXTValues    = nn
  resf@tmXTLabels    = (/"10~S~4~N~","10~S~3~N~","10~S~2~N~"/)
  resf@tmXTMinorValues = nnminor

  txres = True
  txres@txFontHeightF = 0.014
  txres@txJust = "CenterCenter"
  gsn_text_ndc(wks,"Wavelength (km)",0.285,0.8,txres)
  gsn_text_ndc(wks,"Wavelength (km)",0.785,0.8,txres)

  plres  = True                  ; polyline mods desired
  plres@gsLineDashPattern  = 0                    ; solid line
  plres@gsLineThicknessF  = 3.                   ; line thicker

  txres@txJust = "CenterLeft"
  yy = (/ 0.51,0.49,0.47,0.45,0.43,0.41,0.39 /) - 0.03
  xx = (/ 0.10,0.12 /)

  ;;switch order of files
  fname = fname(::-1)
  colors= colors(::-1)
  colors4= colors4(::-1)
  yy = yy(::-1)
  label = label(::-1)

;;----------
;;begin loop
;;----------

do n = 0,ncase-1

  print("Plotting case "+n)

  ncdf = addfile("../data/kespectra/" + fname(n), "r")
  varx = ncdf->$VARX$
  vary = ncdf->$VARY$
  delete(ncdf)

  varyy = vary*(varx^(5/3.)) 
  nx = dimsizes(varx)
  indx = minind(varyy(1:nx-10))
  nx = indx + 1

  resf@xyLineThicknessF   = 2.5
  resf@xyLineColors       = colors(n)
  if (n.eq.0) then
    resf@tiYAxisString          = "Kinetic Energy (m~S~2~N~/s~S~2~N~)"
    resf@tiXAxisString          = "Spherical Wavenumber"
    resf@trXMinF                = 1.
    resf@trXMaxF                = 1000.
    resf@trYMinF                = 2.e-6
    resf@trYMaxF                = 1.e3
    plot(0) = gsn_csm_xy(wks,varx(1:nx-1),vary(1:nx-1),resf)

    ;;overaly -3 slope
    xref = (/18.,60./)
    yref = 50.^3.*(xref)^(-3.)
    gsn_polyline(wks,plot(0),xref/15.,yref,plres)

    resf@tiYAxisString          = "Compensated Kinetic Energy (m~S~2~N~/s~S~2~N~)"
    resf@trYMinF                = 1.e-1
    resf@trYMaxF                = 6.e3
    plot(1) = gsn_csm_xy(wks,varx(1:nx-1),varyy(1:nx-1),resf)
  else
    tmp0 = gsn_csm_xy(wks,varx(1:nx-1),vary(1:nx-1),resf)
    overlay(plot(0),tmp0)

    vary = vary*(varx^(5/3.))

    tmp1 = gsn_csm_xy(wks,varx(1:nx-1),varyy(1:nx-1),resf)
    overlay(plot(1),tmp1)
  end if
  delete([/varx,vary,varyy/])

  plres@gsLineColor       = colors(n)
  gsn_polyline_ndc(wks,xx,(/yy(n),yy(n)/),plres)
  gsn_text_ndc(wks,label(n),xx(1),yy(n),txres)

end do

;*****************************************************
;Add Effective Resolution Shading
;*****************************************************

loedx = (/ 833.56795, 555.711967, 416.783975, 277.8559834, 208.3919875, 138.92799167/)
hiedx = (/1667.1359 ,1111.423934, 833.56795 , 555.711967 , 416.783975 , 277.8559834 /)

loedx = loedx(::-1)
hiedx = hiedx(::-1)

loen  = L/loedx
hien  = L/hiedx

dloen = round(loen,2)
dhien = round(hien,2)

do n = 0,ncase-1

   ncdf = addfile("../data/kespectra/" + fname(n), "r")
   varx = ncdf->$VARX$
   vary = ncdf->$VARY$
   delete(ncdf)

   varyy = vary*(varx^(5/3.))
   varyy@_FillValue = default_fillvalue("float")
   varyy = where(varx.ge.dhien(n) .and. varx.le.dloen(n),varyy,varyy@_FillValue)

   resf@xyCurveDrawOrder = "PreDraw"
   resf@xyLineColors           = colors4(n)
   resf@xyLineThicknesses = 20
   tmp1 = gsn_csm_xy(wks,varx,varyy,resf)
   overlay(plot(1),tmp1)
   delete([/tmp1,varx,vary,varyy/])

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
  resP@gsnPanelFigureStrings = (/"a.","b."/)
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopRight"
  ;resP@txString = pltTitle
  gsn_panel(wks,plot,(/1,2/),resP)               ; now draw as one plot

frame(wks)

end

