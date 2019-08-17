;**************************************
;moistflux plots
;**************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
;**************************************
begin
;****************************************
;****************************************
  fname_in = (/"physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.PRECL.moistflux.nc", \
	       "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.PRECC.moistflux.nc", \
	       "physgrid_180607_QPC6_ne30pg3_ne30pg3_mg17_180617.PRECT.moistflux.nc"/)

  nfiles = dimsizes(fname_in)
  varnams = (/"bin_centers","medians","upperQ","lowerQ","nnorm","globav","globavup","pdfprect","pdfmflux"/)

  xaxis = "-~F33~w~F21~*q/(g*rhow) at 850 hPa (mm/day)"
  xaxis = "-~F33~w~F21~~B~850~N~q~B~850~N~ / g~F33~r~F21~~B~w~N~ (mm/day)"
  yaxis = "Precipitation Rate (mm/day)"

  pltNam = "temp_mflux"

  label = (/"  Stratiform", \
	    "  Convective", \
	    "  Total"/)

  dopdfs = False
  donnorm = False
  dopdfo = False

  colors = (/"green","deepskyblue","magenta"/)
  colors4 = (/"green4","deepskyblue4","magenta4"/)

  ymax = 180.
  xmax = 180.
  xlim = (/300.,300.,300./)

;******************************************************
; plot options
;******************************************************
;---Start the graphics
  wks = gsn_open_wks("pdf",pltNam)
  plot = new( (/1/),"graphic")
  c = 0

  res                      = True         ; plot modifications desired
  res@gsnDraw              = False        ; don't draw plot
  res@gsnFrame             = False        ; don't advance frame
  ;res@gsnMaximize = True
  ;res@gsnPaperOrientation = "portrait"
  ;res@vpWidthF = 0.7
  ;res@vpHeightF = 0.35

  res@tmBorderThicknessF = 5 ;axes thickness
  res@tmXBMajorOutwardLengthF = 0.
  res@tmYLMajorOutwardLengthF = 0.
  res@tmXBMinorOutwardLengthF = 0.
  res@tmYLMinorOutwardLengthF = 0.
  res@tmXTMajorOutwardLengthF = 0.
  res@tmYRMajorOutwardLengthF = 0.
  res@tmXTMinorOutwardLengthF = 0.
  res@tmYRMinorOutwardLengthF = 0.

  res@xyMonoLineThickness = True
  res@xyLineThicknessF   = 5.

  resline = True
  resline@gsLineThicknessF = 2.
  resline@gsLineDashPattern = 1.

  gsres                = True
  gsres@gsFillOpacityF = 0.2;;;0.15
  gsres@tfPolyDrawOrder = "PreDraw"

  txres = True

  res_lines                   = True                  ; polyline mods desired
  res_lines@gsLineDashPattern = 0                    ; solid line
  res_lines@gsLineThicknessF  = 6.                   ; line thicker

do n = 0,nfiles-1

print("Begin case "+n)

   ncdf = addfile("../data/moistflux/" + fname_in(n) , "r")
   bin_centers = ncdf->$varnams(0)$
   medians = ncdf->$varnams(1)$
   upperQ = ncdf->$varnams(2)$
   lowerQ = ncdf->$varnams(3)$
   delete(ncdf)

   pvals = ind(bin_centers.le.xlim(n))
   nvals = dimsizes(pvals);;;(medians)
   res@trYMinF                = 0.
   res@trYMaxF                = ymax
   res@trXMinF                = 0.
   res@trXMaxF                = xmax

   res@xyLineColors       = colors4(n)
   if (n.eq.0) then
     res@tiYAxisString          = yaxis
     res@tiXAxisString          = xaxis
     plot(n)  = gsn_csm_xy(wks,bin_centers(pvals),medians(pvals),res)
     refline = gsn_add_polyline(wks,plot(0),(/res@trXMinF,res@trXMaxF/),(/res@trYMinF,res@trYMaxF/),resline)
   else 
     tmp = gsn_csm_xy(wks,bin_centers(pvals),medians(pvals),res)
     overlay(plot(0),tmp)
     delete(tmp)
   end if
   delete(pvals)

   ;;; transparent polygons
   np = 2*nvals+1
   xp = new((/np/),float)
   yp = new((/np/),float)

   xp(0) = bin_centers(0)
   xp(1:nvals) = bin_centers(0:nvals-1)
   xp(nvals+1:np-1) = bin_centers(nvals-1:0)

   yp(0) = upperQ(0)
   yp(1:nvals) = upperQ(0:nvals-1)
   yp(nvals+1:np-1) = (/lowerQ(nvals-1:0)/)

   gsres@gsFillColor    = colors(n)
   polystr = unique_string("hum")
   plot@$polystr$ = gsn_add_polygon(wks,plot(0),xp,yp,gsres)
   delete([/medians,upperQ,lowerQ,xp,yp,np/])

delete(bin_centers)
print("done with case " + n)

end do ;nfiles

;*****************************************************
; Manually create and attach legend
;*****************************************************
  res_text                    = True                  ; text mods desired
  res_text@txFontHeightF      = 0.018                 ; change text size
  res_text@txJust             = "CenterLeft"          ; text justification

  xx = (/10.,25./)
  yy = (/-10.,-20.,-30./) + ymax
  do n = 0,nfiles-1
    res_lines@gsLineColor       = colors(n)
    lstr = unique_string("rum")
    tstr = unique_string("hum")
    plot@$lstr$ = gsn_add_polyline(wks,plot(0),xx,(/yy(n),yy(n)/),res_lines)
    plot@$tstr$ = gsn_add_text(wks,plot(0),label(n),xx(1),yy(n),res_text)
  end do

;*****************************************************
; Panel Plot
;*****************************************************

  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnPaperOrientation = "portrait"
  resP@gsnPanelFigureStringsFontHeightF = 0.02
  ;resP@gsnPanelFigureStrings = (/ "a","b"/)
  resP@gsnPanelFigureStringsPerimOn     = False
  resP@amJust           = "TopRight"
  resP@gsnPanelYWhiteSpacePercent = 5.
  gsn_panel(wks,plot,(/1,1/),resP)               ; now draw as one plot
  ;;;drawNDCGrid(wks)
  frame(wks)

end

