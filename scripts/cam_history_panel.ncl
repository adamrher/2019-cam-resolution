;*************************************************
; bar_10.ncl
;*************************************************
; This script requires NCL V6.4.0 or later to 
; run. See bar_old_10.ncl for an older way of
; creating this plot.
;*************************************************
begin

;;;----------------------------------------------------------------------------------------------------------------
;;; list of all grids
;;;----------------------------------------------------------------------------------------------------------------

;;;----------------------------------------------------------------------------------------------------------------
  eul     = (/  "R15" ,  "T21" ,  "T31" ,  "T42" ,  "T63" ,  "T85" ,  "T106",  "T170", "99999",  "T340", "99999" /)
  dxeq    = (/ "6.0"  , "5.6"  , "3.75" , "2.8"  , "1.9"  , "1.4"  , "1.1"  , "0.7"  , "99999", "0.35" , "99999" /)
  se      = (/ "99999", "99999", "99999", "99999", "ne15" , "ne20" , "ne30" , "ne40" , "ne60" , "ne80" , "ne120" /)
  dxeq    = (/ "99999", "99999", "99999", "99999", "2.0"  , "1.5"  , "1.0"  , "0.75" , "0.5"  , "0.375", "0.25"  /)
  mpas    = (/ "99999", "99999", "99999", "99999", "240km", "99999", "120km", "99999",  "60km", "99999",  "30km" /)
  dxeq    = (/ "99999", "99999", "99999", "99999", "2.0"  , "99999", "1.0"  , "99999", "0.5"  , "99999", "0.25"  /)
;;;----------------------------------------------------------------------------------------------------------------

;;;----------------------------------------------------------------------------------------------------------------
;;; define data and metadata
;;;----------------------------------------------------------------------------------------------------------------

 ngrids = dimsizes(dxeq)
 nstudy = 11

 version = new(nstudy, "string")
 config  = new(nstudy, "string")
 dtcnst  = new(nstudy,"logical")

;Keihl and Williamson 1991
  version(0) = "CCM1"
  config(0)  = "JAN"
  dtcnst(0)  = False
  dx0     = (/   "R15", "99999", "99999",   "T42",   "T63", "99999",  "T106", "99999", "99999", "99999", "99999" /)
  dtphys0 = (/1800.   ,   99999,   99999, 900.   , 600.   ,   99999, 360.   ,   99999,   99999,   99999,   99999 /)
  cldtot0 = (/   0.47 ,   99999,   99999,   0.36 ,   0.29 ,   99999,   0.26 ,   99999,   99999,   99999,   99999 /)
  tmq0    = (/ 21.1   ,   99999,   99999,  20.0  ,  18.9  ,   99999,  18.8  ,   99999,   99999,   99999,   99999 /)
  precc0  = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  precl0  = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  prect0  = (/  3.20  ,   99999,   99999,   3.30 ,   3.28 ,   99999,   3.34 ,   99999,   99999,   99999,   99999 /)

;Williamson etal. 1995
  version(1) = "CCM2"
  config(1)  = "JAN"
  dtcnst(1)  = True
  dx1     = (/ "99999", "99999",   "T31",   "T42",   "T63", "99999",  "T106", "99999", "99999", "99999", "99999" /)
  dtphys1 = (/   99999,   99999, 450.   , 450.   , 450.   ,   99999, 450.   ,   99999,   99999,   99999,   99999 /)
  cldtot1 = (/   99999,   99999,   0.56 ,   0.54 ,   0.52 ,   99999,   0.50 ,   99999,   99999,   99999,   99999 /)
  tmq1    = (/   99999,   99999,  24.3  ,  23.9  ,  22.6  ,   99999,  22.5  ,   99999,   99999,   99999,   99999 /)
  precc1  = (/   99999,   99999,   2.62 ,   2.58 ,   2.56 ,   99999,   2.55 ,   99999,   99999,   99999,   99999 /)
  precl1  = (/   99999,   99999,   0.83 ,   0.89 ,   0.93 ,   99999,   1.08 ,   99999,   99999,   99999,   99999 /)
  prect1  = precc1 + precl1

  version(2) = "CCM2*"
  config(2)  = "JAN"
  dtcnst(2)  = False
  dx2     = (/   "R15",   "T21",   "T31",   "T42",   "T63", "99999",  "T106", "99999", "99999", "99999", "99999" /)
  dtphys2 = (/1200.   ,1200.   ,1200.   ,1200.   , 720.   ,   99999, 450.   ,   99999,   99999,   99999,   99999 /)
  cldtot2 = (/   0.58 ,   0.56 ,   0.55 ,   0.55 ,   0.54 ,   99999,   0.55 ,   99999,   99999,   99999,   99999 /)
  tmq2    = (/  24.6  ,  24.3  ,  24.0  ,  23.6  ,  22.9  ,   99999,  22.4  ,   99999,   99999,   99999,   99999 /)
  precc2  = (/   2.63 ,   2.82 ,   2.66 ,   2.63 ,   2.65 ,   99999,   2.52 ,   99999,   99999,   99999,   99999 /)
  precl2  = (/   0.70 ,   0.59 ,   0.78 ,   0.85 ,   0.90 ,   99999,   1.04 ,   99999,   99999,   99999,   99999 /)
  prect2  = precc2 + precl2
  

;Williamson 2008
  version(3) = "CAM3"
  config(3)  = "CNTL"
  dtcnst(3)  = True
  dx3     = (/ "99999", "99999", "99999",   "T42", "99999",   "T85", "99999",  "T170", "99999",  "T340", "99999" /) 
  dtphys3 = (/   99999,   99999,   99999, 300.   ,   99999, 300.   ,   99999, 300.   ,   99999, 300.   ,   99999 /)
  cldtot3 = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  tmq3    = (/   99999,   99999,   99999,  20.21 ,   99999,  19.63 ,   99999,  19.13 ,   99999,  18.75 ,   99999 /)
  precc3  = (/   99999,   99999,   99999,   1.71 ,   99999,   1.59 ,   99999,   1.44 ,   99999,   1.36 ,   99999 /)
  precl3  = (/   99999,   99999,   99999,   1.11 ,   99999,   1.38 ,   99999,   1.62 ,   99999,   1.75 ,   99999 /)
  prect3  = precc3 + precl3

  version(4) = "CAM3"
  config(4)  = "CNTL"
  dtcnst(4)  = False
  dx4     = (/ "99999", "99999", "99999",   "T42", "99999",   "T85", "99999",  "T170", "99999",  "T340", "99999" /)
  dtphys4 = (/   99999,   99999,   99999,2400.   ,   99999,1200.   ,   99999, 600.   ,   99999, 300.   ,   99999 /)
  cldtot4 = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  tmq4    = (/   99999,   99999,   99999,  19.57 ,   99999,  19.39 ,   99999,  19.18 ,   99999,  18.75 ,   99999 /)
  precc4  = (/   99999,   99999,   99999,   1.85 ,   99999,   1.76 ,   99999,   1.55 ,   99999,   1.36 ,   99999 /)
  precl4  = (/   99999,   99999,   99999,   0.89 ,   99999,   1.17 ,   99999,   1.51 ,   99999,   1.75 ,   99999 /)
  prect4  = precc4 + precl4

;Rauscher etal. 2012
  version(5) = "CAM4"
  config(5)  = "QOBS"
  dtcnst(5)  = True
  dx5     = (/ "99999", "99999", "99999", "99999", "240km", "99999", "120km", "99999",  "60km", "99999",  "30km" /)
  dtphys5 = (/   99999,   99999,   99999,   99999, 600.   ,   99999, 600.   ,   99999, 600.   ,   99999, 600.    /)
  cldtot5 = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  tmq5    = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  precc5  = (/   99999,   99999,   99999,   99999,  1.40  ,   99999,   1.23 ,   99999,  1.06  ,   99999,   0.90  /)
  precl5  = (/   99999,   99999,   99999,   99999,  1.53  ,   99999,   1.81 ,   99999,  2.04  ,   99999,   2.29  /)
  prect5  = precc5 + precl5

  version(6) = "CAM4"
  config(6)  = "QOBS"
  dtcnst(6)  = True   
  dx6     = (/ "99999", "99999", "99999", "99999",   "f19", "99999",   "f09", "99999", "99999", "99999", "99999" /)
  dtphys6 = (/   99999,   99999,   99999,   99999, 600.   ,   99999, 600.   ,   99999,   99999,   99999,   99999 /)
  cldtot6 = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  tmq6    = (/   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999,   99999 /)
  precc6  = (/   99999,   99999,   99999,   99999,  1.56  ,   99999,   1.13 ,   99999,   99999,   99999,   99999 /)
  precl6  = (/   99999,   99999,   99999,   99999,  1.3   ,   99999,   1.94 ,   99999,   99999,   99999,   99999 /)
  prect6  = precc6 + precl6

;Herrington etal. 2017
  version(7) = "CAM4"
  config(7)  = "QOBS"
  dtcnst(7)  = True
  dx7     = (/ "99999", "99999", "99999", "99999", "ne16" , "99999", "ne30" , "99999", "ne60" , "99999", "ne120" /)
  dtphys7 = (/   99999,   99999,   99999,   99999, 600.   ,   99999, 600.   ,   99999, 600.   ,   99999, 600.    /)
  cldtot7 = (/   99999,   99999,   99999,   99999,   0.62 ,   99999,   0.57 ,   99999,   0.51 ,   99999,   0.42  /)
  tmq7    = (/   99999,   99999,   99999,   99999,  20.08 ,   99999,  19.65 ,   99999,  19.38 ,   99999,  19.10  /)
  precc7  = (/   99999,   99999,   99999,   99999,   1.38 ,   99999,   1.15 ,   99999,   0.97 ,   99999,   0.79  /)
  precl7  = (/   99999,   99999,   99999,   99999,   1.58 ,   99999,   1.90 ,   99999,   2.12 ,   99999,   2.29  /)
  prect7  = precc7 + precl7 

;Zarzycki etal 2014
  version(8) = "CAM4"
  config(8)  = "CNTL"
  dtcnst(8)  = True
  dx8     = (/ "99999", "99999", "99999", "99999", "ne15" , "99999", "99999", "99999", "99999", "99999", "ne120" /)
  dtphys8 = (/   99999,   99999,   99999,   99999,1800.   ,   99999,   99999,   99999,   99999,   99999,1800.    /)
  cldtot8 = (/   99999,   99999,   99999,   99999,   0.56 ,   99999,   99999,   99999,   99999,   99999,   0.36  /)
  tmq8    = (/   99999,   99999,   99999,   99999,  33.4  ,   99999,   99999,   99999,   99999,   99999,  32.1   /)
  precc8  = (/   99999,   99999,   99999,   99999,   2.18 ,   99999,   99999,   99999,   99999,   99999,   1.23  /)
  precl8  = (/   99999,   99999,   99999,   99999,   1.56 ,   99999,   99999,   99999,   99999,   99999,   3.04  /) 
  prect8  = precc8 + precl8

  version(9) = "CAM5"
  config(9)  = "CNTL"
  dtcnst(9)  = True
  dx9     = (/ "99999", "99999", "99999", "99999", "ne15" , "99999", "99999", "99999", "99999", "99999", "ne120" /)
  dtphys9 = (/   99999,   99999,   99999,   99999,1800.   ,   99999,   99999,   99999,   99999,   99999,1800.    /)
  cldtot9 = (/   99999,   99999,   99999,   99999,   0.63 ,   99999,   99999,   99999,   99999,   99999,   0.64  /)
  tmq9    = (/   99999,   99999,   99999,   99999,  32.8  ,   99999,   99999,   99999,   99999,   99999,  31.7   /)
  precc9  = (/   99999,   99999,   99999,   99999,   3.66 ,   99999,   99999,   99999,   99999,   99999,   2.25  /)
  precl9  = (/   99999,   99999,   99999,   99999,   0.49 ,   99999,   99999,   99999,   99999,   99999,   1.85  /)
  prect9  = precc9 + precl9

;Herrington etal 2019
  version(10)= "CAM6"
  config(10) = "QOBS"
  dtcnst(10) = False
  dx10    = (/ "99999", "99999", "99999", "99999", "99999", "ne20" , "ne30" , "ne40" , "ne60" , "ne80" , "ne120" /)
  dtphys10= (/   99999,   99999,   99999,   99999,   99999,2700.   ,1800.   ,1350.   , 900.   , 675.   , 450.    /)
  cldtot10= (/   99999,   99999,   99999,   99999,   99999,   0.844,   0.835,   0.824,   0.810,   0.804,   0.800 /)
  tmq10   = (/   99999,   99999,   99999,   99999,   99999,  23.31 ,  23.01 ,  22.62 ,  22.25 ,  21.93 ,  21.72  /)
  precc10 = (/   99999,   99999,   99999,   99999,   99999,   1.91 ,   1.83 ,   1.68 ,   1.47 ,   1.29 ,   1.08  /)
  precl10 = (/   99999,   99999,   99999,   99999,   99999,   1.26 ,   1.42 ,   1.60 ,   1.85 ,   2.05 ,   2.22  /)
  prect10 = precc10 + precl10

;;;----------------------------------------------------------------------------------------------------------------
;;; define master variable arrays
;;;----------------------------------------------------------------------------------------------------------------

  PRECC = new( (/nstudy,ngrids/), "float" )
  PRECC@_FillValue = default_fillvalue("float")
  PRECT = new( (/nstudy,ngrids/), "float" )
  PRECT@_FillValue = default_fillvalue("float")
  DX    = new( (/nstudy,ngrids/), "string")
  DX@_FillValue = default_fillvalue("string")


  PRECC(0,:) = prect0
  PRECC(1,:) = precc1
  PRECC(2,:) = precc2
  PRECC(3,:) = precc3
  PRECC(4,:) = precc4
  PRECC(5,:) = precc5
  PRECC(6,:) = precc6
  PRECC(7,:) = precc7
  PRECC(8,:) = precc8
  PRECC(9,:) = precc9
  PRECC(10,:)= precc10

  PRECT(0,:) = prect0
  PRECT(1,:) = prect1
  PRECT(2,:) = prect2
  PRECT(3,:) = prect3
  PRECT(4,:) = prect4
  PRECT(5,:) = prect5
  PRECT(6,:) = prect6
  PRECT(7,:) = prect7
  PRECT(8,:) = prect8
  PRECT(9,:) = prect9
  PRECT(10,:)= prect10

  DX(0,:) = dx0
  DX(1,:) = dx1
  DX(2,:) = dx2
  DX(3,:) = dx3
  DX(4,:) = dx4
  DX(5,:) = dx5
  DX(6,:) = dx6
  DX(7,:) = dx7
  DX(8,:) = dx8
  DX(9,:) = dx9
  DX(10,:)= dx10

  PRECC = where(PRECC.ge.99999,PRECC@_FillValue,PRECC)
  PRECT = where(PRECT.ge.99999,PRECT@_FillValue,PRECT)
  DX    = where(DX.eq."99999","",DX)

;;;----------------------------------------------------------------------------------------------------------------
;;; identify a subset (dtcnst v. dtvary)
;;;----------------------------------------------------------------------------------------------------------------
  indx1      = ind(dtcnst.eq.True)
  nx1        = dimsizes(indx1)
  x1         = ispan(1,nx1,1)
  xvalues1   = new( (/ngrids*nx1/), "float")
  xlabels1   = new( (/ngrids*nx1/),  "string")

  indx2      = ind(dtcnst.eq.False)
  nx2        = dimsizes(indx2)
  x2         = ispan(1,nx2,1)
  xvalues2   = new( (/ngrids*nx2/), "float")
  xlabels2   = new( (/ngrids*nx2/),  "string")

;*************************************************
; plot resources
;*************************************************

  wks = gsn_open_wks("pdf","bar")

  base_plot  = new( (/2/), "graphic")
  plot1      = new( (/nx1-1/), "graphic")
  plot2	     = new( (/nx1/), "graphic")
  plot3      = new( (/nx1/), "graphic")
  plot11     = new( (/nx2-1/), "graphic")
  plot22     = new( (/nx2/), "graphic")
  plot33     = new( (/nx2/), "graphic")

  res                          = True

  res@gsnMaximize              = False
  res@gsnDraw                  = False
  res@gsnFrame                 = False

  res@vpWidthF                 = 0.75
  res@vpHeightF                = 0.3

  res@trYMinF                  = 0.0
  res@trYMaxF                  = 5. 
  res@trXMinF                  = 0.5
  res@trXMaxF                  = nx1 + 0.5

  res@tiYAxisString	       = "Precipitation Rate (mm/day)"
  res@tiYAxisFontHeightF       = 0.017

  res@tmXBMode                 = "Explicit"
  res@tmXBLabelAngleF	       = 90.
  res@tmXBLabelJust            = "CenterRight"
  res@tmXBLabelFontHeightF     = 0.008

  res@tmXBMajorLengthF         = 0.01
  res@tmXBMajorOutwardLengthF  = 0.01  
  res@tmYLMajorLengthF         = 0.01
  res@tmYLMajorOutwardLengthF  = 0.01

  res@tmXTOn                   = False

  res@gsnXYBarChart               = True
  ;res@gsnXYBarChartBarWidth       = 0.1

  res@tmYMajorGrid                = True
  res@tmYMajorGridLineDashPattern = 2   
  res@tmYMajorGridThicknessF      = 1.0

  res_p		         = True
  res_p@gsLineThicknessF = 2.
  res_p@gsLineColor      = "black";;"DarkSlateGray";;"black";;"grey43"

  ;;add titles
  res_tx = True
  res_tx@txFontHeightF = 0.015
  res_tx@txJust = "CenterCenter"

;;;----------------------------------------------------------------------------------------------------------------
;;; Create base_plot1
;;;----------------------------------------------------------------------------------------------------------------

  do n = 0,nx1-1
    xx1 = fspan(x1(n)-0.45,x1(n)+0.45,11)
    xvalues1(n*ngrids:n*ngrids+ngrids-1) = xx1
    xlabels1(n*ngrids:n*ngrids+ngrids-1) = DX(indx1(n),:)
  end do
  
  res@tmXBValues               = xvalues1
  res@tmXBLabels               = xlabels1

  do n = 0,nx1-1

    res@gsnXYBarChartColors = "black"
    res@gsnXYBarChartOutlineThicknessF = 1.

    xx1 = xvalues1(n*ngrids:n*ngrids+ngrids-1)

    if (n.eq.0) then  
      base_plot(0) = gsn_csm_xy(wks,xx1,PRECT(indx1(n),:),res)
      ;delete([/res@tmYMajorGridLineDashPattern,res@tmYMajorGridThicknessF/])
    else
      plot1(n-1) = gsn_csm_xy(wks,xx1,PRECT(indx1(n),:),res)
      overlay(base_plot(0),plot1(n-1))
    end if

    if (config(indx1(n)).eq."JAN") then
      res@gsnXYBarChartColors = "grey43";"black"
    else if (config(indx1(n)).eq."CNTL") then
      res@gsnXYBarChartColors = "red"
    else if (config(indx1(n)).eq."QOBS") then
      res@gsnXYBarChartColors = "deepskyblue1"
    end if
    end if
    end if

    plot2(n) = gsn_csm_xy(wks,xx1,PRECC(indx1(n),:),res)

    res@gsnXYBarChartColors = "white"
    plot3(n) = gsn_csm_xy(wks,xx1,PRECT(indx1(n),:),res)

    overlay(base_plot(0),plot3(n))
    overlay(base_plot(0),plot2(n))

  end do

  xxx1 = 0.5
  do n = 0,nx1 

    if (n.ne.0) then
      xxx1 = xxx1 + 1
    end if
    
    str = unique_string("polyline")
    base_plot@$str$ = gsn_add_polyline(wks,base_plot(0),(/xxx1,xxx1/),(/0.,5./),res_p)
  end do

  xxx1 = 0.
  do n = 0,nx1-1

    xxx1 = xxx1 + 1
    str = unique_string("polytext")
    base_plot@$str$ = gsn_add_text(wks,base_plot(0),version(indx1(n)),xxx1,4.5,res_tx)
  end do

;;;----------------------------------------------------------------------------------------------------------------
;;; Create base_plot 2
;;;----------------------------------------------------------------------------------------------------------------

  do n = 0,nx2-1
    xx2 = fspan(x1(n)-0.45,x1(n)+0.45,11)
    xvalues2(n*ngrids:n*ngrids+ngrids-1) = xx2
    xlabels2(n*ngrids:n*ngrids+ngrids-1) = DX(indx2(n),:)
  end do

  delete([/res@tmXBValues,res@tmXBLabels/])
  res@tmXBValues               = xvalues2
  res@tmXBLabels               = xlabels2

  do n = 0,nx2-1

    res@gsnXYBarChartColors = "black"
    res@gsnXYBarChartOutlineThicknessF = 1.

    xx2 = xvalues2(n*ngrids:n*ngrids+ngrids-1)

    if (n.eq.0) then
      base_plot(1) = gsn_csm_xy(wks,xx2,PRECT(indx2(n),:),res)
      ;delete([/res@tmYMajorGridLineDashPattern,res@tmYMajorGridThicknessF/])
    else
      plot11(n-1) = gsn_csm_xy(wks,xx2,PRECT(indx2(n),:),res)
      overlay(base_plot(1),plot11(n-1))
    end if

    if (config(indx2(n)).eq."JAN") then
      res@gsnXYBarChartColors = "grey43";;"black"
    else if (config(indx2(n)).eq."CNTL") then
      res@gsnXYBarChartColors = "red"
    else if (config(indx2(n)).eq."QOBS") then
      res@gsnXYBarChartColors = "deepskyblue1"
    end if
    end if
    end if
    
    plot22(n) = gsn_csm_xy(wks,xx2,PRECC(indx2(n),:),res)
    
    res@gsnXYBarChartColors = "white"
    plot33(n) = gsn_csm_xy(wks,xx2,PRECT(indx2(n),:),res)
    
    overlay(base_plot(1),plot33(n))
    overlay(base_plot(1),plot22(n))
    
  end do

  xxx2 = 0.5
  do n = 0,nx2

    if (n.ne.0) then
      xxx2 = xxx2 + 1
    end if

    str = unique_string("polyline")
    base_plot@$str$ = gsn_add_polyline(wks,base_plot(1),(/xxx2,xxx2/),(/0.,5./),res_p)
  end do

  xxx2 = 0.
  do n = 0,nx2-1

    xxx2 = xxx2 + 1
    str = unique_string("polytext")
    base_plot@$str$ = gsn_add_text(wks,base_plot(1),version(indx2(n)),xxx2,4.5,res_tx)
  end do

;************************************************
; titles
;************************************************

  res_tx@txJust = "CenterLeft"
  res_tx@txFontHeightF = 0.018

  gsn_text_ndc(wks,"~F33~D~F21~t~B~phys~N~ fixed across resolutions",0.1,0.975,res_tx)
  gsn_text_ndc(wks,"~F33~D~F21~t~B~phys~N~ decreases across resolutions",0.1,0.505,res_tx)

;drawNDCGrid(wks)

;************************************************
; create panel
;************************************************
  resP                  = True
  resP@gsnFrame         = False

  ;resP@gsnPanelFigureStrings = labels
  resP@gsnPanelFigureStringsFontHeightF = 0.015
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopRight"

  ;resP@gsnPanelTop        = 0.97
  ;resP@gsnPanelBottom     = 0.1
  ;resP@gsnPanelRight     = 0.9007;
  ;resP@gsnPanelLeft     = 0.40        ; position of left most plot
  gsn_panel(wks,base_plot,(/2,1/),resP)

frame(wks)

end
