;**************************************
;transect.ncl
;**************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "/glade/work/aherring/CESM2/arh-git-scripts/ncl/se_func_lib.ncl"
;**************************************
begin
;****************************************
  fincl1 = "h2"
  fincl2 = "h4"
  fdate1 = ".cam."+fincl1+"*"
  fdate2 = ".cam."+fincl2+"*"
  dir = "/glade/scratch/aherring/"
  fname = (/"physgrid_190201_QPC6_ne30pg2_ne30pg2_mg17_190204", \
	    "physgrid_190201_QPC6_ne30pg2_ne30pg2_mg17_190204"/)
  eq = (/154,154/)
  t0 = (/165,121/) 
  nstart = (/1,3/)
  nfinish = nstart + 1

  nfiles = dimsizes(fname)

  secpday = 60.*60.*24; 
  pi = 3.14159265358979
  g = 9.80616 ;m/s2
  p0 = 1.03e5 ;Pa
  cp = 1004.64 ;J/kg/K
  Rd = 287.0423 ;J/kg/K

  factor = 1.

  writencdf = False
  fname_out = "physres-gll-drizzle-3transect.nc"
  VAR1 = (/"OMG1","OMG2"/)
  VAR2 = (/"PTND1","PTND2"/)
  VAR3 = (/"CMF1","CMF2"/)

  loadncdf = True
  fname_in  = fname_out

  pltNam = "temp_trans"

;************** 
;graphics stuff
;**************
  wkstype = "pdf"
  wkstype@wkBackgroundOpacityF    = 0.
  wks = gsn_open_wks(wkstype,pltNam)
  gsn_define_colormap(wks,"BlAqGrYeOrRevi200");"MPL_jet";"WhBlGrYeRe")  ; choose color map
  gsn_reverse_colormap(wks)
  plot = new(nfiles,graphic)

   res             = True
   res@gsnMaximize = False
   res@gsnDraw     = False      ; Will draw later, after overlaying
   res@gsnFrame    = False      ; all plots

   res@vpXF      = 0.2
   res@vpYF      = 0.8
   res@vpWidthF  = 0.8
   res@vpHeightF = 0.2

   res@cnFillOn         = True               ; turn on color fill
   res@cnLinesOn        = False
   res@gsnSpreadColors  = True               ; use full range of color map

   res@cnLineLabelsOn       = False
   res@cnInfoLabelOn        = False
   res@lbLabelBarOn         = False

   res@cnLevelSelectionMode = "ManualLevels"     ; manually set the contour levels with the following 3 resources
   res@cnMinLevelValF  = -0.80
   res@cnMaxLevelValF  =  0.20
   res@cnLevelSpacingF =  0.025

   res@trYReverse            = True                 ; reverse y-axis
   res@gsnXAxisIrregular2Linear = True
   res@gsnYAxisIrregular2Linear = True
   res@tmBorderThicknessF = 4 ;axes thickness
   ;res@tmXBMajorOutwardLengthF = 0.
   ;res@tmYLMajorOutwardLengthF = 0.
   ;res@tmXBMinorOutwardLengthF = 0.
   ;res@tmYLMinorOutwardLengthF = 0.
   ;res@tmXTMajorOutwardLengthF = 0.
   ;res@tmYRMajorOutwardLengthF = 0.
   ;res@tmXTMinorOutwardLengthF = 0.
   ;res@tmYRMinorOutwardLengthF = 0.
   res@tmXTOn = False
   res@tmYROn = False

   res@tiXAxisFontHeightF = 0.014
   res@tiYAxisFontHeightF = 0.014
   res@tmXBLabelFontHeightF = 0.012
   res@tmYLLabelFontHeightF = 0.012

   res1                 = True
   res1                 = res
   res1@cnFillOn          = False
   res1@cnLinesOn         = True
   res1@cnMonoLineThickness = False
   res1@cnLineThicknesses = (/2,2,2/)
   res1@cnLineColor = "black"
   res1@cnLevelSelectionMode = "ExplicitLevels"
   res1@cnMaxLevelCount = 2
   res1@gsnContourNegLineDashPattern = 2
   res1@cnLevels = (/-15.,15./)

   res2 = True
   res2 = res1
   res2@gsnContourNegLineDashPattern = 2
   res2@cnLineThicknesses = (/3,3,3/)
   res2@cnLineColor = "black"
   res2@cnLevels = (/-1.,0.0075/)


;************
;Main Loop
;************
 do n = 0,nfiles-1

 if (.not.loadncdf) then

  print("loading files for case " + n)
  files = systemfunc ("ls " + dir + fname(n) + "/run/" + fname(n) + fdate1)
  nhist = dimsizes(files)

  print(": " + files(nstart(n):nfinish(n)))
  f1  = addfiles (files(nstart(n):nfinish(n)),"r")
  ListSetType(f1,"cat")
  delete(files)

  files = systemfunc ("ls " + dir + fname(n) + "/run/" + fname(n) + fdate2)
  print(": " + files(nstart(n):nfinish(n)))
  f2  = addfiles (files(nstart(n):nfinish(n)),"r")
  ListSetType(f2,"cat")
  delete(files)

  print("loading vars...")
  hyam = f1[0]->hyam
  hybm = f1[0]->hybm
  hyai = f1[0]->hyai
  hybi = f1[0]->hybi

  lev_p = (hyam + hybm)*p0
  lev_p!0         = "lev_p"                  ; variable/dim name
  lev_p&lev_p     =  lev_p                   ; create coordinate variable
  lev_p@long_name = "Pressure (Pa)"               ; attach some attributes
  lev_p@units     = "Pa"
  lev_p@positive  = "down"

  lev_pint = (hyai + hybi)*p0
  lev_pint!0         = "lev_pint"                  ; variable/dim name
  lev_pint&lev_pint     =  lev_pint                   ; create coordinate variable
  lev_pint@long_name = "Pressure (Pa)"               ; attach some attributes
  lev_pint@units     = "Pa"
  lev_pint@positive  = "down"

  ps   = f1[:]->PS(t0(n),:)
  cmf  = f2[:]->CMFMCDZM(t0(n),:,:)
  pt   = f2[:]->FT(t0(n),:,:)
  pt   = pt*secpday
  omg  = f1[:]->OMEGA_gll(t0(n),:,:)
  omg  = omg*factor

  dims = getfilevardimsizes(f1[0],"OMEGA")
  ncol = dims(2)
  delete(dims)

  dims = getfilevardimsizes(f1[0],"OMEGA_gll")
  ncol_d = dims(2)
  delete(dims)

  wgtpath = get_wgt_path(ncol,ncol_d,0)
  print("wgtpath: " + wgtpath)
  wgtpath_GLL = get_wgt_path(ncol_d,ncol_d,0)
  print("wgtpath_GLL: " + wgtpath_GLL)
  delete(f1)
  delete(f2)

  print("Done loading vars for case " + n)

  cmf_regrid  = ESMF_regrid_with_weights(cmf,wgtpath,False)
  ps_regrid   = ESMF_regrid_with_weights(ps,wgtpath,False)
  pt_regrid   = ESMF_regrid_with_weights(pt,wgtpath_GLL,False)
  omg_regrid  = ESMF_regrid_with_weights(omg,wgtpath_GLL,False)
  delete([/cmf,ps,pt,omg,wgtpath,wgtpath_GLL/])

  lon = omg_regrid&lon
  levs = omg_regrid&lev
  ilevs = cmf_regrid&ilev

  ;transect
  cmfx = cmf_regrid(:,eq(n),:)
  ptx  = pt_regrid(:,eq(n),:)
  omgx = omg_regrid(:,eq(n),:)

  ;interface pres for mass fluxes
  pint = pres_hybrid_ccm(ps_regrid,p0,hyai,hybi)
  pintx = pint(:,eq(n),:)
  pintx!0 = "ilevs"
  pintx&ilevs = ilevs
  pintx!1 = "lon"
  pintx&lon = lon
  delete(pint)

  ;mid-level pres
  pm = pres_hybrid_ccm(ps_regrid,p0,hyam,hybm)
  pmx = pm(:,eq(n),:)
  pmx!0 = "levs"
  pmx&levs = levs
  pmx!1 = "lon"
  pmx&lon = lon
  delete(pm)

  delete([/cmf_regrid,pt_regrid,omg_regrid,ps_regrid/])

  ;;Convert to Potential Temperature
  ;;ptx = ptx*(p0/pmx)^(Rd/cp) 

;*************************************************************
; remap to common pressure level
; *remember when using vinth2p:
; lev_p->hPa / ps->Pa / p0->hPa
;*************************************************************

  linlog = 2
  tmp = int2p_n(pmx(levs|:,lon|:),ptx,lev_p,linlog,0)
  delete(ptx)
  ptx = tmp
  delete(tmp)

  ptx!0 = "levs"
  ptx&levs = lev_p/100.
  ptx&levs@long_name = "Pressure (hPa)"
  ptx!1 = "lon"
  ptx&lon = lon

  tmp = int2p_n(pintx(ilevs|:,lon|:),cmfx,lev_pint,linlog,0)
  delete(cmfx)
  cmfx = tmp
  delete(tmp)

  cmfx!0 = "ilevs"
  cmfx&ilevs = lev_pint/100.
  cmfx&ilevs@long_name = "Pressure (hPa)"
  cmfx!1 = "lon"
  cmfx&lon = lon

  tmp = int2p_n(pmx(levs|:,lon|:),omgx,lev_p,linlog,0)
  delete(omgx)
  omgx = tmp
  delete(tmp)

  omgx!0 = "levs"
  omgx&levs = lev_p/100.
  omgx&levs@long_name = "Pressure (hPa)"
  omgx!1 = "lon"
  omgx&lon = lon

  if (n.eq.0) then
    omgx!1 = "lonlo"
    omgx&lonlo = lon
    cmfx!1 = "lonlo"
    cmfx&lonlo = lon
    ptx!1 = "lonlo"
    ptx&lonlo = lon
  end if

  delete([/pintx,pmx,levs,ilevs,lon/])

 else;;load from file
   print("Loading pdfvars from " + fname_in)
   if (n.eq.0) then
     ncdf = addfile("../data/transect/" + fname_in , "r")
   end if
   omgx = ncdf->$VAR1(n)$
   ptx  = ncdf->$VAR2(n)$
   cmfx = ncdf->$VAR3(n)$
 end if

  if (n.eq.nfiles-1) then
    res@tiXAxisString          = "Longitude"
  end if

  res@trYMinF                = 0.
  res@trYMaxF                = 1015.

  plot(n)  = gsn_csm_contour(wks,omgx,res)
  dum1 = gsn_csm_contour(wks,cmfx,res2)
  overlay(plot(n),dum1)
  delete(dum1)

  ;;dum1 = gsn_csm_contour(wks,ptx,res1)
  ;;overlay(plot(n),dum1)
  ;;delete(dum1)

  if (writencdf) then
    if (n.eq.0) then
      system("/bin/rm -f "+fname_out)
      ncdf = addfile(fname_out , "c")
    end if
    ncdf->$VAR1(n)$ = omgx
    ncdf->$VAR2(n)$ = ptx
    ncdf->$VAR3(n)$ = cmfx
  end if
  delete([/cmfx,ptx,omgx/])

end do ;nfiles

;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnMaximize      = False
  resP@gsnPaperOrientation = "portrait"
  resP@gsnPanelLabelBar = True                   ; add common colorbar

  resP@gsnPanelFigureStringsFontHeightF = 0.013
  resP@gsnPanelFigureStringsPerimOn     = True
  resP@gsnPanelFigureStringsBackgroundFillColor = "white"
  resP@amJust           = "TopLeft"

  resP@vpHeightF                  = 0.1     ; Height of labelbar
  resP@vpWidthF                   = 0.60      ; Width of labelbar

  resP@gsnPanelBottom   = 0.1
  resP@lbTitleString              = "~F33~w~F21~ (Pa/s)"
  resP@lbTitlePosition            = "Bottom"

  resP@vpHeightF                  = 0.1     ; Height of labelbar
  resP@vpWidthF                   = 0.60      ; Width of labelbar
  resP@lbLabelFontHeightF         = 0.015
  resP@lbLabelStride              = 1
  resP@lbTitleFontHeightF         = 20
  resP@lbBoxSeparatorLinesOn      = False

  gsn_panel(wks,plot,(/nfiles,1/),resP)               ; now draw as one plot
  frame(wks)

end



