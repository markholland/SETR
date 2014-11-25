#!/usr/bin/wish

##  QUIVI
##
##  File: quivi
##
##  Copyright (C) 2001  Universidad Politecnica de Valencia, SPAIN
##
##  Author: Agustin Espinosa Minguet   aespinos@dsic.upv.es
##
##  QUIVI is free software;     you can  redistribute it and/or  modify it
##  under the terms of the GNU General Public License  as published by the
##  Free Software Foundation;  either  version 2, or (at  your option) any
##  later version.
##
##  QUIVI  is  distributed  in the  hope  that  it will  be   useful,  but
##  WITHOUT  ANY  WARRANTY;     without  even the   implied   warranty  of
##  MERCHANTABILITY  or  FITNESS FOR A  PARTICULAR PURPOSE.    See the GNU
##  General Public License for more details.
##
##  You should have received  a  copy of  the  GNU General Public  License
##  distributed with QUIVI;      see file COPYING.   If not,  write to the
##  Free Software  Foundation,  59 Temple Place  -  Suite 330,  Boston, MA
##  02111-1307, USA.


font create cuadriculafont -family helvetica -size 9


proc formatea {val posdec} {


    set len [string length $val]
    set last [expr $len - 1]

    set decimal [string range $val [expr $last - $posdec + 1] $last]
    set entera  [string range $val 0 [expr $last - $posdec] ]

    set len [string length $entera]
    if { $len > 0 } {
	set last [expr $len - 1]
	set res ""
	set dot "."
	set j 0
	for { set i $last } { $i >= 0 } { incr i -1 } {
	    set digit [string index $entera $i]
	    if { [expr $j % 3] == 0 && $i != $last } {
		set res $dot$res
	    }
	    set res $digit$res
	    incr j
	}
	
	set entera $res
    } else {
	set entera 0
    }

    if { $posdec > 0 } {
	set len [string length $decimal]
	while { $len < $posdec } {
	    set decimal 0$decimal
	    incr len
	}

	set last [expr $len - 1]
	set res ""
	set dot "_"
	for { set i 0 } { $i <= $last } { incr i } {
	    set digit [string index $decimal $i]
	    set res $res$digit
	    if { [expr [expr $i + 1] % 3] == 0 && $i != $last } {
		set res $res$dot
	    }
	}
	set dot ","
	set res $dot$res

	set decimal $res

    } else {
	set decimal ""
    }

    return $entera$decimal
}


###############################################
# proc cambiarEsquema
###############################################


proc cambiarEsquema {} {
    global quiv

    set quiv(parametrosIniciales) \
	    [lreplace $quiv(parametrosIniciales) end end $quiv(esquema)]
    saleDeBoton .botones.apariencia.esquema 
}


###############################################
# proc quivError
###############################################


proc quivError {s} {
    puts "\n $s"
    exit
}


###############################################
# proc hazRedibujar
###############################################


proc hazRedibujar {} {
    global quiv

    set primerTick [quivPrimerTick]
    set ultimoTick [quivUltimoTick]
    set medio [expr $primerTick - ($ultimoTick - $primerTick) / 2]
    
    botonesEnEjecucion .botones
    if { $quiv(parametroAnchoDeTick) > 0 } {
	set quiv(anchoDeTick) $quiv(parametroAnchoDeTick)
    } elseif { $quiv(parametroAnchoDeTick) == 0 } {
	set quiv(anchoDeTick) 1
    } elseif { $quiv(parametroAnchoDeTick) < 0 } {
	set quiv(anchoDeTick) \
		[expr 1.0 * pow(2,$quiv(parametroAnchoDeTick))]
    }

    set quiv(parametrosIniciales) \
	    [concat \
	    [lrange $quiv(parametrosIniciales) 0 0] \
	    $quiv(anchoDeTick) $quiv(altoDeTick) \
	    [lrange $quiv(parametrosIniciales) 3 end]]
    repetirVisualizar    
    quivIraltickIz $primerTick
}







###############################################
# proc reproducirTraza
###############################################

proc reproducirTraza {} {
    global quiv quivEsquemas quivEstado
    

    quivInfo "Leyendo fichero"
    set fd [open $quiv(ficheroDatos)]
    set quiv(parametrosIniciales) \
	    [gets $fd ]
    set quiv(parametroAnchoDeTick) \
	    [lindex $quiv(parametrosIniciales) 1]

    if { $quiv(parametroAnchoDeTick) > 0 } {
	set quiv(anchoDeTick) $quiv(parametroAnchoDeTick)
    } elseif { $quiv(parametroAnchoDeTick) == 0 } {
	set quiv(anchoDeTick) 1
    } elseif { $quiv(parametroAnchoDeTick) < 0 } {
	set quiv(anchoDeTick) \
		[expr 1.0 * pow(2,$quiv(parametroAnchoDeTick))]
    }

    set quiv(parametrosIniciales) \
	    [concat \
	    [lrange $quiv(parametrosIniciales) 0 0] \
	    $quiv(anchoDeTick)  \
	    [lrange $quiv(parametrosIniciales) 2 end]]
    

    set quiv(altoDeTick) \
	    [lindex $quiv(parametrosIniciales) 2]
    set quiv(esquema)  \
	    [lindex $quiv(parametrosIniciales) 8]


    if { $quiv(esquema) == "Personalizado" } {
	set quivEsquemas(Personalizado) {} 
	for {set i 0} {$i < 11 } {incr i} {
	    lappend quivEsquemas(Personalizado) [gets $fd]
	}
    }

    set i 0
    set quiv(trazaGuardada) {}
    while { ! [eof $fd ] } {
	set ev [gets $fd ]
	if { $ev != "" } {
	    lappend quiv(trazaGuardada) $ev
	    incr i
	}
    }
    set quiv(numeroDeEventos) $i

    repetirVisualizar
    close $fd
}





###############################################
# proc repetirVisualizar
###############################################

proc repetirVisualizar {} {
    global quiv quivEstado


    set quiv(hemosParado) 0
    botonesEnEjecucion .botones
    
    eval "quivInicializar .visor $quiv(parametrosIniciales) .estado.tickActual "

    foreach ev $quiv(trazaGuardada) {
	eval [concat quivMostrarEventos $ev]
	if {$quiv(hemosParado) } {
	    break
	}
    }
    botonesTrazaCargada .botones
    quivInfo ""
}





###############################################
# proc abrirFichero
###############################################

proc abrirFichero {} {
    global quiv

    cargarFichero [tk_getOpenFile -title "Abrir datos"  -filetypes { { Datos {.mod .tra}} { {Todos los ficheros} {*}} }  ]
}




###############################################
# proc cargarFichero
###############################################

proc cargarFichero {fichero} {
    global quiv

    if { $fichero != "" } {
	set quiv(ficheroDatos) $fichero
	.estado.fichero configure -text [file tail $fichero]
	botonesFicheroCargado .botones
    }
}




###############################################
# proc pararTraza
###############################################

proc pararTraza {} {
    global quiv
    set quiv(hemosParado) 1
    botonesTrazaCargada .botones
}





########################################################################
## Gestion de Botones
########################################################################

###############################################
# proc entraEnBoton
###############################################

proc entraEnBoton {w} {
    global quiv
    set estado [$w cget -state]
    if { $estado != "disabled" } {
	$w configure -image $quiv(iconoDe,$w) -relief raised
    }   
}




###############################################
# proc saleDeBoton
###############################################

proc saleDeBoton {w} {
    global quiv
    $w configure -image $quiv(icono2De,$w) -relief flat
}




###############################################
# proc iniBotones
###############################################

proc iniBotones {b} {

    global quiv

    iniImagenes

    set quiv(iconoDe,$b.abrir)     $quiv(imagen,abrir)
    set quiv(icono2De,$b.abrir)    $quiv(imagen,abrir2)
    set quiv(iconoDe,$b.apariencia.redibujar)      $quiv(imagen,pincel)
    set quiv(icono2De,$b.apariencia.redibujar)     $quiv(imagen,pincel2)
    set quiv(iconoDe,$b.apariencia.esquema)  $quiv(imagen,iris)
    set quiv(icono2De,$b.apariencia.esquema) $quiv(imagen,iris2)
    set quiv(iconoDe,$b.stop)      $quiv(imagen,stop)
    set quiv(icono2De,$b.stop)     $quiv(imagen,stop2)
    set quiv(iconoDe,$b.ejecutar)  $quiv(imagen,ejecutar)
    set quiv(icono2De,$b.ejecutar) $quiv(imagen,ejecutar2)


    set botones {abrir ejecutar stop}
    

    set j 0
    foreach i $botones {
	incr j
	button $b.$i -borderwidth 2 -width 24 -heigh 20 \
		-bg gray50 -activebackground gray50 -highlightthickness 0
	saleDeBoton $b.$i 
	grid $b.$i -row 1 -column $j -sticky nw -padx 3 -pady 5
	bind $b.$i <Enter> "entraEnBoton %W"
	bind $b.$i <Leave>  "saleDeBoton %W"
    }
    
    $b.abrir configure -command "abrirFichero"
    $b.ejecutar configure -command "reproducirTraza"
    $b.stop configure -command "pararTraza"
    

    label $b.ir -borderwidth 0  -width 3 \
	    -text Ir -bg gray50 \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-*


    incr j
    grid $b.ir -row 1 -column $j -sticky w -padx 2 -pady 5

    entry $b.iraltick -borderwidth 1 \
	    -bg gray60 -highlightthickness 0 -width 10 \
	    -textvariable quiv(iraltick) \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* 
    bind $b.iraltick <Return> "quivIr"

    incr j
    grid $b.iraltick -row 1 -column $j -sticky w -padx 2 -pady 5



    incr j
    grid columnconfigure $b $j  -weight 1

    frame $b.apariencia -bg gray50 -borderwidth 1 -relief groove
    grid $b.apariencia -row 1 -column [expr $j + 1] -sticky nw -padx 2 -pady 5
    incr j

    set quiv(altoDeTick) 12
    set quiv(parametroAnchoDeTick) 10
    set quiv(anchoDeTick) 10
 
    entry $b.apariencia.anchoDeTick -borderwidth 1 \
	    -bg gray60 -highlightthickness 0 -width 5 \
	    -textvariable quiv(parametroAnchoDeTick) \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* 
    bind $b.apariencia.anchoDeTick <Return> "hazRedibujar"


    entry $b.apariencia.altoDeTick -borderwidth 1 \
	    -bg gray60 -highlightthickness 0 -width 5 \
	    -textvariable quiv(altoDeTick) \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* 
    bind $b.apariencia.altoDeTick <Return> "hazRedibujar"

    scale $b.apariencia.horizontal -from -20 -to 40 \
	    -orient horizontal \
	    -showvalue no \
	    -width 6 \
	    -length 83 \
	    -borderwidth 1 \
	    -bg gray50 -activebackground blue -highlightthickness 0 -troughcolor gray60 \
	    -variable quiv(parametroAnchoDeTick)
    
    scale $b.apariencia.vertical -from 1 -to 48 \
	    -orient horizontal \
	    -showvalue no \
	    -width 6 \
	    -length 83 \
	    -borderwidth 1 \
	    -bg gray50 -activebackground blue \
	    -highlightthickness 0 -troughcolor gray60 \
	    -variable quiv(altoDeTick)
    
    button $b.apariencia.redibujar -borderwidth 2 -width 24 \
	    -heigh 20 -bg gray50 \
	    -activebackground gray50 -highlightthickness 0 \
	    -command "hazRedibujar"
    saleDeBoton $b.apariencia.redibujar 
    bind $b.apariencia.redibujar <Enter> "entraEnBoton %W"
    bind $b.apariencia.redibujar <Leave>  "saleDeBoton %W"

    menubutton $b.apariencia.esquema -borderwidth 2 -width 24 \
	    -heigh 20 -bg gray50 \
	    -activebackground gray50 -highlightthickness 0

    menu $b.apariencia.esquema.menu \
	    -bg gray50 -activebackground gray50 -tearoff false \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* \
	    -activebackground gray50\
	    -borderwidth 1
    
    set quiv(esquema) "Normal"
    $b.apariencia.esquema.menu add radiobutton \
	    -label "Normal" -command "cambiarEsquema" \
	    -variable quiv(esquema) -value "Normal"
    $b.apariencia.esquema.menu add radiobutton \
	    -label "Grises" -command "cambiarEsquema" \
	    -variable quiv(esquema) -value "Grises"
    $b.apariencia.esquema.menu add radiobutton \
	    -label "Aguamarina" -command "cambiarEsquema" \
	    -variable quiv(esquema) -value "Aguamarina"
    $b.apariencia.esquema.menu add radiobutton \
	    -label "Arcoiris" -command "cambiarEsquema" \
	    -variable quiv(esquema) -value "Arcoiris"
    $b.apariencia.esquema.menu add radiobutton \
	    -label "Personalizado" -command "cambiarEsquema" \
	    -variable quiv(esquema) -value "Personalizado"
    $b.apariencia.esquema configure -menu $b.apariencia.esquema.menu
    saleDeBoton $b.apariencia.esquema 
    bind $b.apariencia.esquema <Enter> "entraEnBoton %W"
    bind $b.apariencia.esquema <Leave>  "saleDeBoton %W"

    grid $b.apariencia.anchoDeTick -row 0 -column 0 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.altoDeTick -row 1 -column 0 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.horizontal -row 0 -column 1 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.vertical -row 1 -column 1 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.esquema -row 0 -column 2 -rowspan 2 \
	    -sticky ns -padx 3 -pady 1
    grid $b.apariencia.redibujar -row 0 -column 3 -rowspan 2 \
	    -sticky ns -padx 3 -pady 1

    botonesIniciales $b
}


###############################################
# proc botonesIniciales
###############################################

proc botonesIniciales { b } {
    global quiv
    $b.abrir configure -state normal
    $b.ejecutar configure -state disabled
    $b.stop configure -state disabled
    bind $b.iraltick <Return> ""
    $b.apariencia.redibujar configure -state disabled
    $b.apariencia.esquema configure -state disabled
}


###############################################
# proc botonesFicheroCargado
###############################################

proc botonesFicheroCargado { b } {
    global quiv
    $b.abrir configure -state normal
    $b.ejecutar configure -state normal
    bind $b.iraltick <Return> ""
    $b.stop configure -state disabled
    $b.apariencia.redibujar configure -state disabled
    $b.apariencia.esquema configure -state disabled
}



###############################################
# proc botonesEnEjecucion
###############################################

proc botonesEnEjecucion { b } {
    global quiv
    $b.abrir configure -state disabled
    $b.ejecutar configure -state disabled
    $b.stop configure -state normal
    bind $b.iraltick <Return> ""
    $b.apariencia.redibujar configure -state disabled
    $b.apariencia.esquema configure -state disabled
}




###############################################
# proc botonesTrazaCargada
###############################################

proc botonesTrazaCargada { b } {
    global quiv
    $b.abrir configure -state normal
    $b.ejecutar configure -state normal
    $b.stop configure -state disabled
    bind $b.iraltick <Return> "quivIr"
    $b.apariencia.redibujar configure -state normal
    $b.apariencia.esquema configure -state normal
}





###############################################
# proc iniBarraDeEstado
###############################################

proc iniBarraDeEstado {e} {
    global quiv

    label $e.tickActual -borderwidth 1 -relief sunken -width 20 \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-*
    label $e.fichero -borderwidth 1 -relief sunken -width 20\
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-*
    label $e.info -borderwidth 1 -relief sunken -width 40\
	    -justify left \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* 
    grid $e.info $e.tickActual $e.fichero -padx 3 -pady 3 -sticky nw
    grid columnconfigure $e 2 -weight 1
}


proc quivInfo {s} {

    .estado.info configure -text $s
}

###############################################
# proc iniInterfaz
###############################################

proc iniInterfaz {} {
    global quiv

    ## Asignamos el peso a cada una de las celdas
    ##
    
    wm title . "Quivi 2.3.1"
    grid rowconfigure . 0 -weight 0
    grid rowconfigure . 1 -weight 1 
    grid rowconfigure . 2 -weight 0
    grid columnconfigure . 0 -weight 1
    
    ## creamos los marcos principales
    ##
    catch {destroy .botones}
    catch {destroy .visor}
    catch {destroy .estado}
    set b .botones
    set v .visor
    set e .estado
    
    
    frame $b -borderwidth 2 -relief groove -bg gray50
    grid $b -row 0 -column 0 -sticky nwse
    
    frame $v -borderwidth 2 -relief groove
    grid $v -row 1 -column 0 -sticky nswe
    grid rowconfigure $v 0 -weight 1

    frame $e -borderwidth 2 -relief groove -bg gray50
    grid $e -row 2 -column 0 -sticky nwse

    quivEsquemasPredefinidos
    iniBotones .botones
    iniBarraDeEstado $e
    set quiv(parametrosIniciales) "2.3 8 16 200 0 4 {A B C D} 0 $quiv(esquema)"
    quivInicializar $v 2.3 8 16 200 0 4 {A B C D} 0 $quiv(esquema) .estado.tickActual  

}




########################################################
# Esquemas
########################################################



proc quivEsquemasPredefinidos {} {
    global quivEsquemas

    set quivEsquemas(Grises) {
	
	{ejecucion { gray70 }}
	{preparada { black }}
	{comienza { gray30 }}
	{termina { gray30 }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
    }	

    set quivEsquemas(Normal) {
	
	{ejecucion { gray50 }}
	{preparada { black }}
	{comienza { blue }}
	{termina {green  }}
	{plazo { red }}
	{entrasc { orange }}
	{salesc { orange }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
    }	

    set quivEsquemas(Aguamarina) {
	
	{ejecucion { aquamarine1 aquamarine3 aquamarine4 }}
	{preparada { aquamarine1 aquamarine3 aquamarine4 }}
	{comienza { aquamarine1 aquamarine3 aquamarine4 }}
	{termina { aquamarine1 aquamarine3 aquamarine4 }}
	{plazo { red }}
	{entrasc { blue }}
	{salesc { blue }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
    }	


    set quivEsquemas(Arcoiris) {
	
	{ejecucion { red orange yellow2 green2 blue #4b0082 violet  }}
	{preparada { red orange yellow2 green2 blue #4b0082 violet  }}
	{comienza { red orange yellow2 green2 blue #4b0082 violet  }}
	{termina { red orange yellow2 green2 blue #4b0082 violet }}
	{plazo { black }} 
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { red orange yellow2 green2 blue #4b0082 violet }}
	{eventoabajo { red orange yellow2 green2 blue #4b0082 violet }}
	{suspendida { black }}
	{cmodo { black }}
    }

    set quivEsquemas(Personalizado) {
	
	{ejecucion { white }}
	{preparada { black }}
	{comienza { white }}
	{termina { white }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
    }	

}

proc quivCargaEsquema { e } {
    global quivEsquemas quivColor quivEstado 


    foreach elemento $e { 
	set tipo [lindex $elemento 0]
	if { [lsearch {ejecucion preparada comienza termina plazo entrasc salesc eventoarriba eventoabajo suspendida cmodo}  $tipo] == -1} {
	    quivError "ERROR: tipo de esquema incorrecto en:\n$elemento"
	}
	set colores [lindex $elemento 1]
	set ncolores [llength $colores]
	set i 0
	for {set i 0} {$i < $quivEstado(numeroDeLineas) } {incr i} {
	    set quivColor($tipo,$i) \
		[lindex $colores [expr $i % $ncolores]]
	}
	incr i
    }
    
    
}




###############################################
# proc quivInicializar
###############################################

proc quivInicializar \
	{ventana \
	version \
	anchuraDeTick \
	alturaDeTick \
	duracion \
	desde \
	numeroDeLineas \
	nombresDeLineas \
	posDecimales\
	esquema \
	etiquetaDeTick} {
    
    global quivParametro quiTraza quivVentana quivEstado quivColor quivEsquemas \
	    ejecucionDesde preparadaDesde
    
    if { [string match {2.[0123]} $version] == 0} {
	puts "Version incorrecta: $version"
	exit 1
    }


    catch {unset quivParametro}
    catch {unset quivVentana}
    catch {unset quivEstado}

    set quivVentana(principal) $ventana

    set quivVentana(etiquetaDeTick) $etiquetaDeTick

    set quivEstado(duracion) \
	    $duracion

    set quivEstado(desde) \
	    $desde

    set quivEstado(numeroDeLineas) \
	    $numeroDeLineas

    set quivEstado(nombresDeLineas) \
	    $nombresDeLineas

    if {[string match {2.[01]} $version] == 1} { 
	set quivEstado(posDecimales) 0
    } else {
	set quivEstado(posDecimales) \
		$posDecimales
    }

    set quivEstado(cada) \
	    [quivCada  $anchuraDeTick]
    
    set quivEstado(umbral) 0


    for {set i 0} {$i < $numeroDeLineas} {incr i} {
	set ejecucionDesde($i) -1
	set preparadaDesde($i) -1
    }

    set quivColor(ejecucion) gray50
    set quivColor(preparada) black
    set quivColor(comienza) red
    set quivColor(termina) green


    quivIniParametros $anchuraDeTick $alturaDeTick $quivEstado(duracion)

    set w $ventana
    catch { destroy  $w.tareasVisor}
    catch { destroy  $w.modeloVisor}

    frame $w.tareasVisor -relief groove -borderwidth 2
    frame $w.modeloVisor -relief groove -borderwidth 2
    
    grid rowconfigure $w 0 -weight 1
    grid columnconfigure $w 0 -weight 1

    grid $w.tareasVisor     -row 0 -sticky wens -pady 1
    grid rowconfigure $w.tareasVisor 0 -weight 1
    grid columnconfigure $w.tareasVisor 0 -weight 1
    grid $w.modeloVisor     -row 1 -sticky wens -pady 1

    set existe [lsearch [array names quivEsquemas] $esquema ]
    if { $existe == -1 } {
	quivError "ERROR: No existe el esquema $esquema"
    }
    quivCargaEsquema $quivEsquemas($esquema)

    set quivVentana(tareasVisor) \
	    [quivCrearVisor $w.tareasVisor $quivEstado(numeroDeLineas)]
    bind $quivVentana(tareasVisor) \
	    <Motion> "quivMovimientoEnVisorDeTareas %x %y"
    bind $quivVentana(tareasVisor) \
	    <Double-Button-3> "quivDeleteDrag $quivVentana(tareasVisor)"
    bind $quivVentana(tareasVisor) \
	    <3> "quivStartDrag  $quivVentana(tareasVisor) %x %y"
    bind $quivVentana(tareasVisor) \
	    <B3-Motion> "quivDrag  $quivVentana(tareasVisor) %x %y"
    bind $quivVentana(tareasVisor) \
	    <ButtonRelease-3> "quivFinDrag $quivVentana(tareasVisor)"
    bind . <Left> ".visor.tareasVisor.c xview scroll -1 units"
    bind . <Right> ".visor.tareasVisor.c xview scroll 1 units"
    bind . <Up> ".visor.tareasVisor.c yview scroll -1 units"
    bind . <Down> ".visor.tareasVisor.c yview scroll 1 units"
    bind . <Next> ".visor.tareasVisor.c xview scroll 1 pages"
    bind . <Prior> ".visor.tareasVisor.c xview scroll -1 pages"
    bind . <Home> "quivIraltickIz $quivEstado(desde)"
    bind . <End> "quivIraltickIz [expr $quivEstado(desde) + $quivParametro(numeroDeTicks)]"


    quivInvisibles

    quivDibujaLineas \
	    $w.tareasVisor \
	    $quivEstado(numeroDeLineas) \
	    $quivEstado(nombresDeLineas) \
	    $quivEstado(desde) \
	    $quivEstado(posDecimales) \
	    $quivEstado(cada)

    quivDibujaCuadricula


    update
}




###############################################
# proc quivMostrarEventos
###############################################

proc quivMostrarEventos {t losEventos} {

    global ejecucionDesde preparadaDesde quivEstado quiv

    if {$t < $quivEstado(desde)} {
	quivError "ERROR: Tick $t fuera de rango en\n$t $losEventos"
    }
    if {$t > [expr $quivEstado(desde) + $quivEstado(duracion)]} {
	quivError "ERROR: Tick $t fuera de rango en\n$t $losEventos"
    }

    foreach ev $losEventos {
	set tipo [lindex $ev 0]
	if { $tipo == ""} {
	    quivError "ERROR en $t $losEventos"
	}
	set linea [lindex $ev 1]
	if { $linea == ""} {
	    quivError "ERROR en $t $losEventos"
	}

	set arg2 [lindex $ev 2]
	set arg3 [lindex $ev 3]
	switch -regexp $tipo {
	    ^0$|LLEGA { 
		quivHazComienza  $linea $t $arg2
	    }
	    ^1$|ACABA {
		quivHazTermina  $linea $t $arg2
	    }
	    ^2$|PLAZO {
		quivHazPlazo  $linea $t $arg2
	    }
	    ^3$|C-EJE {
		set ejecucionDesde($linea) $t
	    }
	    ^4$|T-EJE {
		quivHazEjecucion $linea $ejecucionDesde($linea) $t $arg2  
	    }
	    ^5$|C-PRE {
		set preparadaDesde($linea) $t
	    }
	    ^6$|T-PRE {
		quivHazPreparada $linea $preparadaDesde($linea) $t $arg2  
	    }
	    ^7$|ENTSC { 
		quivHazEntraSC  $linea $t $arg2 $arg3  
	    }
	    ^8$|SALSC { 
		quivHazSaleSC  $linea $t $arg2 $arg3 
	    }
	    ^9$|EV-AR { 
		quivHazEventoArriba  $linea $t $arg2 $arg3
	    }
	    ^10$|EV-AB { 
		quivHazEventoAbajo  $linea $t $arg2 $arg3  
	    }
	    ^11$|SUSPE { 
		quivHazSuspendida  $linea $t $arg2 $arg3  
	    }
	    ^12$|CMODO { 
		quivHazCambioDeModo  $t $linea $arg2 
	    }
	    default { 
		quivError "ERROR en $t $losEventos"
	    }
	}
	
    }

    ## Redibujamos de cuando en cuando
    incr quivEstado(umbral)
    if { [ expr $quivEstado(umbral) % 100 ] == 0 } {
	set porcen \
		[expr round(double($quivEstado(umbral)) / $quiv(numeroDeEventos) * 100)]
	quivInfo "$porcen% "
	update
    }
}



###############################################
# proc quivIniParametros
###############################################

proc quivIniParametros {anchuraDeTick alturaDeTick numeroDeTicks} {

    global quivParametro

    set quivParametro(anchuraDeTick) \
	    $anchuraDeTick
    set quivParametro(alturaDeTick) \
	    $alturaDeTick
    set quivParametro(separacionEntreLineas) \
	    [expr $alturaDeTick * 3]
    set quivParametro(numeroDeTicks) \
	    $numeroDeTicks
    set quivParametro(holguraHorizontal) \
	    10
    #	    [expr $quivParametro(anchuraDeTick) * 2 ]
    set quivParametro(holguraVertical) \
	    0
    set quivParametro(longitudDeLinea) \
	    [expr $numeroDeTicks * $anchuraDeTick]
    set quivParametro(mediaAltura) \
	    [expr int($alturaDeTick / 2) ]
    set quivParametro(cuartoDeAltura) \
	    [expr int($alturaDeTick / 4) ]
    set quivParametro(mediaAnchura) \
	    [expr int($anchuraDeTick / 2) ]
    if { $anchuraDeTick < 16 } {
	set quivParametro(tamannoSimbolo) 4
    } else {
	set quivParametro(tamannoSimbolo) [expr $anchuraDeTick / 4]
    }
	
    catch {font delete visorfont}
    font create visorfont -family helvetica -size [expr $quivParametro(mediaAltura) + $quivParametro(cuartoDeAltura)]


}





###############################################
# proc quivCoordenadasDeTick
###############################################

proc quivCoordenadasDeTick {linea tick} {
    global quivParametro quiTraza quivEstado

    set X1 \
	    [expr (($tick - $quivEstado(desde))* $quivParametro(anchuraDeTick)) + $quivParametro(holguraHorizontal)] 
    set Y2 \
	    [expr ( ($linea + 1) * $quivParametro(separacionEntreLineas) ) + \
	    $quivParametro(holguraVertical) - \
	    $quivParametro(alturaDeTick)
	    ]
    set X2 \
	    [expr $X1 + $quivParametro(anchuraDeTick)]
    set Y1 \
	    [expr $Y2 - $quivParametro(alturaDeTick)]
    return [list $X1 $Y1 $X2 $Y2]
}




###############################################
# proc quivIr
###############################################

proc quivIr { } {

    global quiv quivParametro quivEstado
    quivIraltick $quiv(iraltick)
    quivHazPosicionIr $quiv(iraltick)

}

###############################################
# proc quivIraltick
###############################################

proc quivIraltick {t} {
    global quiv quivParametro


    set anchura [lindex [.visor.tareasVisor.c cget -scrollregion] 2]
    set pixel [lindex [quivCoordenadasDeTick 0 $t] 0]
    set porcentaje [expr double($pixel) / double($anchura)]

    .visor.tareasVisor.c xview moveto $porcentaje
    .visor.tareasVisor.t xview moveto $porcentaje
    ## eval .visor.tareasVisor.hscroll set [.visor.tareasVisor.c xview]

    set primerTick [quivPrimerTick]
    set ultimoTick [quivUltimoTick]
    set t [expr $primerTick - ($ultimoTick - $primerTick) / 2]
    
    set pixel [lindex [quivCoordenadasDeTick 0 $t] 0]
    set porcentaje [expr double($pixel) / double($anchura)]

    .visor.tareasVisor.c xview moveto $porcentaje
    .visor.tareasVisor.t xview moveto $porcentaje
    eval .visor.tareasVisor.hscroll set [.visor.tareasVisor.c xview]

    
}

proc quivIraltickIz {t} {
    global quiv quivParametro


    set anchura [lindex [.visor.tareasVisor.c cget -scrollregion] 2]
    set pixel [lindex [quivCoordenadasDeTick 0 $t] 0]
    set porcentaje [expr double($pixel) / double($anchura)]

    .visor.tareasVisor.c xview moveto $porcentaje
    .visor.tareasVisor.t xview moveto $porcentaje
    eval .visor.tareasVisor.hscroll set [.visor.tareasVisor.c xview]

    
}





###############################################
# proc quivDoblexScroll
###############################################

proc quivDoblexScroll {s t b e} {
    set l [.visor.tareasVisor.c xview]
    $s set $b $e
    $t xview moveto $b
    set l [.visor.tareasVisor.c xview]
    set l [.visor.tareasVisor.t xview]
    quivDibujaCuadricula

}




###############################################
# proc quivDobleyScroll
###############################################

proc quivDobleyScroll {s t b e} {
    $s set $b $e
    $t yview moveto $b
}




###############################################
# proc quivUltimoTick
###############################################

proc quivUltimoTick {} {
    global quivParametro quivEstado

    set c .visor.tareasVisor.c

    set x2 [expr [$c canvasx [lindex [grid bbox .visor.tareasVisor 1 0] 2]] - 1]
    set ultimoTick \
	    [expr $quivEstado(desde) + int( ($x2 - $quivParametro(holguraHorizontal) )  / $quivParametro(anchuraDeTick))]


    set max [expr $quivEstado(duracion) + $quivEstado(desde)]
    if { $ultimoTick > $max } {
	set ultimoTick $max
    }

    return $ultimoTick
}





###############################################
# proc quivPrimerTick
###############################################

proc quivPrimerTick {} {
    global quivParametro quivEstado

    set c .visor.tareasVisor.c

    set x1  [$c canvasx 0]
    set primerTick \
	    [expr $quivEstado(desde) + int( ($x1 - $quivParametro(holguraHorizontal) )  / $quivParametro(anchuraDeTick))]

    if { $primerTick <0 } {
	set primerTick 0
    }

    return $primerTick

}



###############################################
# proc quivCrearVisor
###############################################


proc quivCrearVisor {f numeroDeLineasTemporales} {

    global quivParametro quivEstado quivVentana

    set anchuraVisor \
	    [ expr double($quivParametro(anchuraDeTick)) * double($quivParametro(numeroDeTicks)) + double(2 * $quivParametro(holguraHorizontal)) ]

    set alturaVisor \
	    [ expr $quivParametro(separacionEntreLineas) *  ($numeroDeLineasTemporales + 1) + 30]

    set c $f.c
    set p $f.p
    set n $f.n
    set t $f.t

    set quivVentana(postscript) $p
    set anchuraVentana \
	    [expr double(400) ]
    set alturaVentana \
	    [ expr int($quivParametro(separacionEntreLineas) * ($quivEstado(numeroDeLineas) + 1 ) ) + 30]




    set xscroll [expr [quivCada $quivParametro(anchuraDeTick)] * $quivParametro(anchuraDeTick)]

    canvas $c -scrollregion "0 0 $anchuraVisor $alturaVisor" \
	    -width $anchuraVentana -height $alturaVentana \
	    -borderwidth 2 -background white -highlightthickness 0\
	    -xscrollcommand "quivDoblexScroll $f.hscroll $t" \
	    -xscrollincrement $xscroll \
	    -yscrollcommand "quivDobleyScroll $f.vscroll $n" \
	    -yscrollincrement $quivParametro(separacionEntreLineas) \
	    -relief groove
    canvas $p -scrollregion "0 0 $anchuraVisor $alturaVisor" \
	    -width $anchuraVentana -height $alturaVentana \
	    -borderwidth 2 -background white -highlightthickness 0\
	    -relief groove
    canvas $n -scrollregion "0 0 80 $alturaVisor" \
	    -width 100 -height $alturaVentana \
	    -borderwidth 0 -highlightthickness 0 \
	    -yscrollincrement $quivParametro(separacionEntreLineas)
    canvas $t -scrollregion "0 0 $anchuraVisor 20" \
	    -width $anchuraVentana -height 20 \
	    -borderwidth 2 -highlightthickness 0 \
	    -xscrollincrement [expr double($quivParametro(anchuraDeTick))] \
	    -relief groove -background white
	    
    scrollbar $f.vscroll \
	    -command "$c yview" -borderwidth 1 -width 10
    scrollbar $f.hscroll \
	    -orient horiz -command "$c xview" -borderwidth 1 -width 10
    frame $f.rincon

    grid rowconfigure $f 0 -weight 1
    grid rowconfigure $f 1 -weight 0
    grid rowconfigure $f 2 -weight 0
    grid columnconfigure $f 0 -weight 0
    grid columnconfigure $f 1 -weight 1
    grid columnconfigure $f 2 -weight 0

    grid $n -row 0 -column 0 -sticky ns
    grid $c -row 0 -column 1 -sticky nwse
    ## grid $t -row 1 -column 1 -sticky we
    grid $f.vscroll -row 0 -column 2  -sticky ns
    grid $f.hscroll -row 2 -column 1  -sticky we
    grid $f.rincon -row 2 -column 2 -sticky nesw

    return $c
}




###############################################
# proc quivDibujaLineas
###############################################


proc quivDibujaLineas {f numeroDeLineasTemporales nombresDeLasLineas desde posDecimales cada} {

    global quivParametro quiTraza

    set c $f.c
    set n $f.n
    set t $f.t

    ##
    ## creamos las lineas temporales
    ##


    for {set i 0} {$i <= $numeroDeLineasTemporales } {incr i} {
	set Y \
		[expr [lindex [quivCoordenadasDeTick $i $desde] 3] + 1]
	set item [$c create line \
		$quivParametro(holguraHorizontal) $Y \
		[expr $quivParametro(longitudDeLinea) + $quivParametro(holguraHorizontal)] $Y \
		-width 1 -fill LightYellow2]
	$c lower $item cuadricula


	$n create text \
		10 \
		$Y \
		-anchor w -text [lindex $nombresDeLasLineas $i] \
		-font -Adobe-Helvetica-Medium-R-Normal--*-120-*-*-*-*-*-*
	
    }

    incr Y 20
    set item [$c create line \
	    $quivParametro(holguraHorizontal) $Y \
	    [expr $quivParametro(longitudDeLinea) + $quivParametro(holguraHorizontal)] $Y \
	    -width 1 -fill LightYellow2]
    $c lower $item cuadricula
    
}


###############################################
# proc quivDibujaCuadricula
###############################################


proc quivDibujaCuadricula {} {
    global quivVentana quivParametro quivEstado

    set cada $quivEstado(cada)
    set desde $quivEstado(desde)
    set posDecimales $quivEstado(posDecimales)

    set c $quivVentana(principal).tareasVisor.c
    set t $quivVentana(principal).tareasVisor.t

    $c delete cuadricula
    $t delete cuadricula

    set primerTick [quivPrimerTick]

    if { [expr $primerTick % $cada] != 0 } {
	set primerTick [expr $primerTick + $cada - $primerTick % $cada]
    }
    
    set ultimoTick [quivUltimoTick]


    set Y1 \
	    0
    set Y2 \
	    [expr [lindex [quivCoordenadasDeTick [expr $quivEstado(numeroDeLineas) ] $desde] 3]]
    for {set j $primerTick} {$j <= $ultimoTick } {incr j $cada} {
	set X \
		[lindex [quivCoordenadasDeTick 0 $j] 0]
	set item \
		[$c create line $X $Y1 $X $Y2 \
		-width 1 -fill LightYellow2 -tag cuadricula \
		]
	$c lower $item ejecucion
	#$c lower $item posicionir
    }

    
    set tick_cada $cada
    set temp $cada
    set i 5
    while { [expr $tick_cada * $quivParametro(anchuraDeTick)] < 70} {
	set tick_cada [expr $temp * $i]
	incr i 5
    }

    if { [expr $primerTick % $tick_cada] != 0 } {
	set primerTick [expr $primerTick + $tick_cada - $primerTick % $tick_cada]
    }
    
    set Y1 $Y2
    incr Y2 20

    for {set j $primerTick} {$j <= $ultimoTick} {incr j $tick_cada} {
	set X \
		[lindex [quivCoordenadasDeTick 0 [expr $j]] 0 ]
	$c create text \
		$X $Y2 \
		-anchor se -text [formatea [expr $j] $posDecimales] \
		-tag cuadricula \
		-font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-*
	
	set item \
		[$c create line $X $Y1 $X $Y2 \
		-width 1 -fill LightYellow2 -tag cuadricula \
		]
	$c lower $item ejecucion
	#$c lower $item posicionir
    }
    
    # Solo cuando altoDeTick >= 9

    set y1 [lindex [$c yview] 0]
    set y2 [lindex [$c yview] 1]

    set cadalineas [expr int( ($y2 - $y1) * ($quivEstado(numeroDeLineas) + 1)) ]
    if { $quivParametro(alturaDeTick) >= 9 && $cadalineas > 0} {
	for {set i 0} {$i <= $quivEstado(numeroDeLineas) } {incr i} {
	    if { [ expr $i % $cadalineas ] == 0 && $i != 0} {
		for {set j $primerTick} {$j <= $ultimoTick} {incr j $tick_cada} {
		    set X \
			    [lindex [quivCoordenadasDeTick $i $j] 0 ]
		    set Y \
			    [lindex [quivCoordenadasDeTick $i $j] 1 ]
		    set Y [expr $Y - $quivParametro(mediaAltura)]
		    
		    $c create text \
			    $X $Y \
			    -anchor se -text [formatea [expr $j] $posDecimales] \
			    -tag cuadricula \
			    -font cuadriculafont -fill LightYellow4
		    
		    $c lower $item ejecucion
		}
	    }
	}
    }
    

}



###############################################
# proc quivHazEjecucion
###############################################

proc quivHazEjecucion {linea tickInicio tickFinal  color} {
    global quivParametro quivVentana quivColor 

    if { $tickInicio == -1 } {
	return
    }
    set coords \
	    [quivCoordenadasDeTick $linea $tickInicio]
    set X1 [lindex $coords 0] 
    set Y1 [lindex $coords 1] 

    set coords \
	    [quivCoordenadasDeTick $linea [expr $tickFinal - 1]]
    set X2 [lindex $coords 2] 
    set Y2 [lindex $coords 3] 

    if {$color == ""} {
	set color $quivColor(ejecucion,$linea)
    }
    set item [$quivVentana(tareasVisor) create rect $X1 $Y1 $X2 $Y2 \
	    -fill $color -outline black  -tags ejecucion]
    $quivVentana(tareasVisor) raise $item preparada
}


###############################################
# proc quivHazDormida
###############################################

proc quivHazDormida {c linea tick borde color} {
    global quivParametro quivColor 

    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0] 
    set Y1 [lindex $coords 1] 
    set X2 [lindex $coords 2] 
    set Y2 [lindex $coords 3] 

    $c create rect $X1 $Y1 $X2 $Y2 \
	    -fill $color -outline $borde  -tags dormida

}

###############################################
# proc quivHazPreparada
###############################################

proc quivHazPreparada {linea tickInicial tickFinal  color} {
    global quivParametro quivVentana quivColor 


    if { $tickInicial == -1 } {
	return
    }
    set coords \
	    [quivCoordenadasDeTick $linea $tickInicial]
    set X1 [lindex $coords 0] 
    set coords \
	    [quivCoordenadasDeTick $linea [expr $tickFinal - 1]]
    set X2 [lindex $coords 2] 
    set Y [lindex $coords 3] 

    if {$color == ""} {
	set color $quivColor(preparada,$linea)
    }

    set item [$quivVentana(tareasVisor) create line $X1 $Y $X2 $Y \
	    -fill $color  -tags preparada]
    $quivVentana(tareasVisor) lower $item preparada

}

###############################################
# proc quivHazComienza
###############################################

proc quivHazComienza {linea tick color} {
    global quivParametro quivVentana quivColor

    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X [lindex $coords 0] 
    set X1 [expr $X - $quivParametro(tamannoSimbolo)] 
    set X2 [expr $X + $quivParametro(tamannoSimbolo) + 1] 
    set Y1 [expr [lindex $coords 3] - $quivParametro(tamannoSimbolo)]
    set Y2 [expr $Y1 + 2 * $quivParametro(tamannoSimbolo) + 1] 
 
    if {$color == ""} {
	set color $quivColor(comienza,$linea)
    }
    set item [$quivVentana(tareasVisor) create oval $X1 $Y1 $X2 $Y2 \
	    -fill $color -outline gray30 -tags comienza]
    $quivVentana(tareasVisor) raise $item ejecucion

}

###############################################
# proc quivHazTermina
###############################################

proc quivHazTermina {linea tick color} {
    global quivParametro quivVentana quivColor 


    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [lindex $coords 1]
    set X2 [expr $X1 - $quivParametro(tamannoSimbolo)]
    set Y2 [expr $Y1 - $quivParametro(tamannoSimbolo)]
    set X3 [expr $X1 + $quivParametro(tamannoSimbolo)]
    set Y3 $Y2

    if {$color == ""} {
	set color $quivColor(termina,$linea)
    }
    
    set item [$quivVentana(tareasVisor) create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $color -outline gray10 -tags termina]
    $quivVentana(tareasVisor) raise $item comienza
}

###############################################
# proc quivHazPlazo
###############################################

proc quivHazPlazo {linea tick color} {
    global quivParametro quivVentana quivColor 

    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [expr [lindex $coords 3] + $quivParametro(tamannoSimbolo) + 1]
    set X2 [expr $X1 - $quivParametro(tamannoSimbolo)]
    set Y2 [expr $Y1 + $quivParametro(tamannoSimbolo)]
    set X3 [expr $X1 + $quivParametro(tamannoSimbolo)]
    set Y3 $Y2
    
    if {$color == ""} {
	set color $quivColor(plazo,$linea)
    }

    $quivVentana(tareasVisor) create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $color -outline gray10 -tags plazo

    set X2 $X1
    set Y2 [ expr [lindex $coords 1] - $quivParametro(tamannoSimbolo) * 2 ]

    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2 \
	    -fill black -tags plazo]
    $quivVentana(tareasVisor) raise $item termina
}



###############################################
# proc quivHazEntraSC
###############################################

proc quivHazEntraSC {linea tick texto color} {
    global quivParametro quivVentana quivColor 


    set coords \
	    [quivCoordenadasDeTick $linea $tick]

    set X1 [expr [lindex $coords 0] + $quivParametro(tamannoSimbolo)]
    set Y1 [expr [lindex $coords 1] - $quivParametro(mediaAltura) ]
    set X2 [lindex $coords 0]
    set Y2 $Y1
    set X3 $X2
    set Y3 [expr [lindex $coords 3] + $quivParametro(mediaAltura) ]
    set X4 $X1
    set Y4 $Y3

    if {$color == ""} {
	set color $quivColor(entrasc,$linea)
    }
    
    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2 $X3 $Y3 $X4 $Y4  \
	    -fill $color -tags entrasc]
    $quivVentana(tareasVisor) raise $item ejecucion

    if {$texto != ""} {
	set item [$quivVentana(tareasVisor) create text $X2 $Y2 \
		-font visorfont -fill black -text $texto -anchor sw -tags texto ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }

}


###############################################
# proc quivHazSaleSC
###############################################

proc quivHazSaleSC {linea tick texto color} {
    global quivParametro quivVentana quivColor 

    set coords \
	    [quivCoordenadasDeTick $linea $tick]

    set X1 [expr [lindex $coords 0] - $quivParametro(tamannoSimbolo)]
    set Y1 [expr [lindex $coords 1] - $quivParametro(mediaAltura) ]
    set X2 [lindex $coords 0]
    set Y2 $Y1
    set X3 $X2
    set Y3 [expr [lindex $coords 3] + $quivParametro(mediaAltura) ]
    set X4 $X1
    set Y4 $Y3

    if {$color == ""} {
	set color $quivColor(salesc,$linea)
    }
 
   
    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2 $X3 $Y3 $X4 $Y4  \
	    -fill $color -tags salesc]

    $quivVentana(tareasVisor) raise $item ejecucion

    if {$texto != ""} {
	set item [$quivVentana(tareasVisor) create text $X2 $Y2 \
		-font visorfont -fill black -text $texto -anchor se -tags texto ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }
}


###############################################
# proc quivHazEventoArriba
###############################################

proc quivHazEventoArriba {linea tick texto color} {
    global quivParametro quivVentana quivColor 


    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [lindex $coords 1]
    set X2 $X1
    set Y2 [expr $Y1 - $quivParametro(alturaDeTick) + 1]


    if {$color == ""} {
	set color $quivColor(eventoarriba,$linea)
    }
    
    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2  \
	    -fill $color  -arrow first -tags eventoarriba]
    $quivVentana(tareasVisor) raise $item comienza

    if {$texto != ""} {
	set X2 [expr $X2 + 6]
	set item [$quivVentana(tareasVisor) create text $X2 $Y2 \
		-font visorfont -fill black -text $texto -anchor nw -tags texto ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }

}



###############################################
# proc quivHazEventoAbajo
###############################################

proc quivHazEventoAbajo {linea tick texto color} {
    global quivParametro quivVentana quivColor 


    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [lindex $coords 3]
    set X2 $X1
    set Y2 [expr $Y1 + $quivParametro(alturaDeTick) - 1]

    if {$color == ""} {
	set color $quivColor(eventoabajo,$linea)
    }
    
    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2  \
	    -fill $color  -arrow first -tags eventoarriba]
    $quivVentana(tareasVisor) raise $item comienza

    if {$texto != ""} {
	set X2 [expr $X2 + 6]
	set item [$quivVentana(tareasVisor) create text $X2 $Y2 \
		-font visorfont -fill black -text $texto -anchor sw -tags texto ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }
}


###############################################
# proc quivHazPosicionIr
###############################################

proc quivHazPosicionIr {tick} {
    global quivParametro quivVentana quivColor quivEstado 

    $quivVentana(tareasVisor) delete posicionir

    set linea 0

    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [lindex $coords 1]
    set X2 $X1

    set linea $quivEstado(numeroDeLineas)

    set coords \
	    [quivCoordenadasDeTick $linea $tick]
    set Y2 [lindex $coords 1]

    set color red
    
    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2  \
	    -fill $color  -arrow both -tags posicionir]
    $quivVentana(tareasVisor) raise $item cuadricula

    set texto $tick

    set item [$quivVentana(tareasVisor) create text $X1 $Y1 \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* \
	    -fill red -text $texto -anchor s -tags posicionir ]
    $quivVentana(tareasVisor) raise $item cuadricula


    set item [$quivVentana(tareasVisor) create text $X2 $Y2 \
	    -font -Adobe-Helvetica-Medium-R-Normal--10-*-*-*-*-*-*-* \
	    -fill red -text $texto -anchor n -tags posicionir ]
    $quivVentana(tareasVisor) raise $item cuadricula


}


###############################################
# proc quivHazSuspendida
###############################################

proc quivHazSuspendida {linea tick texto color} {
    global quivParametro quivVentana quivColor 

    set coords \
	    [quivCoordenadasDeTick $linea $tick]

    set X1 [lindex $coords 0]
    set Y1 [expr [lindex $coords 1] - $quivParametro(cuartoDeAltura) ]
    set X2 $X1
    set Y2 [expr [lindex $coords 3] + $quivParametro(cuartoDeAltura) ]

    if {$color == ""} {
	set color $quivColor(suspendida,$linea)
    }
 

    set item [$quivVentana(tareasVisor) create line $X1 $Y1 $X2 $Y2 \
	    -fill $color -tags suspendida]

    $quivVentana(tareasVisor) raise $item ejecucion

    set X3 [expr $X1 + $quivParametro(tamannoSimbolo)]
    set X4 $X3

    set item [$quivVentana(tareasVisor) create line $X3 $Y1 $X4 $Y2 \
	    -fill $color -tags suspendida]

    $quivVentana(tareasVisor) raise $item ejecucion


    if {$texto != ""} {
	set item [$quivVentana(tareasVisor) create text $X1 $Y1 \
		-font visorfont -fill black -text $texto -anchor sw -tags texto ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }
}




###############################################
# proc quivHazCambioDeModo
###############################################

proc quivHazCambioDeModo {tick texto color} {
    global quivParametro quivEstado quivColor quivVentana

    set coords \
	    [quivCoordenadasDeTick 0 $tick]
    set X \
	   [lindex $coords 0]
    set Y1 \
	    [expr [lindex $coords 1] - $quivParametro(mediaAltura)]
    set coords \
	    [quivCoordenadasDeTick [expr $quivEstado(numeroDeLineas)  ] $tick]
    set Y2 \
	    [expr [lindex $coords 3] ]
	   
    if {$color == ""} {
	set color $quivColor(cmodo,0)
    }

    set item \
	    [$quivVentana(tareasVisor) \
	    create line $X $Y1 $X $Y2 -fill $color -width 1 -tags cmodo]
    $quivVentana(tareasVisor) raise $item ejecucion

    if {$texto != ""} {
	set X [expr $X + 2]
	set item [$quivVentana(tareasVisor) create text $X $Y2 \
		-font visorfont -fill black -text $texto -anchor sw -tags cmodo ]
	
	$quivVentana(tareasVisor) raise $item ejecucion
    }

}
    




###############################################
# proc quivCada
###############################################

proc quivCada { i} {
    set r [expr 12.0 / $i]
    if {$r <= 1} {
	return 1
    }
    if {$r <= 10} {
	return 10
    }

    if {$r <= 100} {
	return 100
    }

    if {$r <= 1000} {
	return 1000
    }
    if {$r <= 10000} {
	return 10000
    }
    if {$r <= 100000} {
	return 100000
    }
    if {$r <= 1000000} {
	return 1000000
    }
    if {$r <= 10000000} {
	return 10000000
    }
    if {$r <= 100000000} {
	return 100000000
    }
    if {$r <= 1000000000} {
	return 1000000000
    }
}




###############################################
# proc quivInvisibles
###############################################

proc quivInvisibles {} {
    global quivVentana

    ## Creamos items invisibles para poder asi situar
    ## en capas los objetos de la representacion
    ##

    set c $quivVentana(tareasVisor)


    $c create rect -100 -100 -200 -200\
	    -tags cuadricula
    $c create rect -100 -100 -200 -200\
	    -tags ejecucion
    $c create rect -100 -100 -200 -200\
	    -tags preparada
    $c create rect -100 -100 -200 -200\
	    -tags comienza
    $c create rect -100 -100 -200 -200\
	    -tags termina
    $c create rect -100 -100 -200 -200\
	    -tags plazo
    $c create rect -100 -100 -200 -200\
	    -tags posicionir

}




###############################################
# proc quivMovimientoEnVisorDeTareas
###############################################

proc quivMovimientoEnVisorDeTareas {x y} {
    global quivParametro quivVentana quivEstado

    set c $quivVentana(tareasVisor)

    set x  [$c canvasx $x]

    set tick \
	    [expr $quivEstado(desde) + int( ($x - $quivParametro(holguraHorizontal) )  / $quivParametro(anchuraDeTick))]

    ##
    ## Hemos pulsado fuera de los lugares sensibles
    if { $tick < 0 } return
    if { $tick > [expr $quivEstado(duracion)+$quivEstado(desde)] } return

    $quivVentana(etiquetaDeTick) configure -text [formatea  $tick $quivEstado(posDecimales)]
}





###############################################
# proc iniImagenes
###############################################



proc iniImagenes {} {
    global quiv

set tablaDeImagenes {
    {
	guardar2 20 20 {
	    { #000000 -to  3  3 17  4 }
	    { #000000 -to  3  4  4 16}
	    { #000000 -to  3  4  4 16}
	    { #000000 -to  4 16 17 17}
	    { #000000 -to 16  4 17 16}
	    { #000000 -to  5  4  6 10}
	    { #000000 -to  6 10 14 11}
	    { #000000 -to 14  4 15 10}
	    { #000000 -to  6 12 15 13}
	    { #000000 -to 14 13 15 16}
	    { #000000 -to  6 13 12 16}
	    { #000000 -to 15  5}
	    { #007d00 -to  4  4  5 16}
	    { #007d00 -to  5 10  6 16}
	    { #007d00 -to  6 11 14 12}
	    { #007d00 -to 14 10 15 12}
	    { #007d00 -to 15  6 16 16}
	}
    }
    {
	guardar 20 20 {
	    { #000000 -to  3  3 17  4 }
	    { #000000 -to  3  4  4 16}
	    { #000000 -to  3  4  4 16}
	    { #000000 -to  4 16 17 17}
	    { #000000 -to 16  4 17 16}
	    { #000000 -to  5  4  6 10}
	    { #000000 -to  6 10 14 11}
	    { #000000 -to 14  4 15 10}
	    { #000000 -to  6 12 15 13}
	    { #000000 -to 14 13 15 16}
	    { #000000 -to  6 13 12 16}
	    { #000000 -to 15  5}
	    { #7dff00 -to  4  4  5 16}
	    { #7dff00 -to  5 10  6 16}
	    { #7dff00 -to  6 11 14 12}
	    { #7dff00 -to 14 10 15 12}
	    { #7dff00 -to 15  6 16 16}
	}
    }
    {
	motor2 18 18 {
	    { #000000 -to  1  6 17  7 }
	    { #000000 -to  1 10 17 11 }
	    { #000000 -to  1 14 17 15 }
	    { #00007d -to  1  4  4  6 }
	    { #00007d -to 10  4 13  6 }
	    { #7d0000 -to  4  8  7 10}
	    { #7d0000 -to  9  8 10 10}
	    { #7d0000 -to 13  8 15 10}
	    { #ffffff -to  7 12  9 14}
	    { #ffffff -to 15 12 17 14}
	}
    }
    {
	motor 18 18 {
	    { #000000 -to  1  6 17  7 }
	    { #000000 -to  1 10 17 11 }
	    { #000000 -to  1 14 17 15 }
	    { #00ffff -to  1  4  4  6 }
	    { #00ffff -to 10  4 13  6 }
	    { #ff0000 -to  4  8  7 10}
	    { #ff0000 -to  9  8 10 10}
	    { #ff0000 -to 13  8 15 10}
	    { #ffff00 -to  7 12  9 14}
	    { #ffff00 -to 15 12 17 14}
	}
    }
    {
	abrir2 20 20 {
	    { #000000 -to  3  6  3  7 }
	    { #000000 -to  2  7  3 16 }
 	    { #000000 -to  2 15 13 16 }
 	    { #000000 -to  7 10 18 11 }
 	    { #000000 -to 12  7 13 10 }
 	    { #000000 -to  3  7 13  8 }
 	    { #000000 -to  3  6  6  7 }
  	    { #000000 -to 15  5 17  7}
  	    { #000000 -to 12  3 14  4}
  	    { #000000 -to 11  4}
  	    { #000000 -to 14  4}
  	    { #000000 -to 14  6}
  	    { #000000 -to 16  4}
  	    { #000000 -to  6 11}
  	    { #000000 -to  5 12}
  	    { #000000 -to  4 13}
  	    { #000000 -to  3 14}
  	    { #000000 -to 16 11}
  	    { #000000 -to 15 12}
  	    { #000000 -to 14 13}
  	    { #000000 -to 13 14}
	    { #ffff7d -to  3  7  6 12}
	    { #ffff7d -to  6  8 12 10}
	    { #ffff7d -to  3 12  5 13}
	    { #7d7d00 -to  3 13}
	    { #7d7d00 -to  6 10}
	    { #7d7d00 -to  7 11 16 12}
	    { #7d7d00 -to  6 12 15 13}
	    { #7d7d00 -to  5 13 14 14}
	    { #7d7d00 -to  4 14 13 15}
	}
    }
    {
	abrir 20 20 {
	    { #000000 -to  3  6  3  7 }
	    { #000000 -to  2  7  3 16 }
 	    { #000000 -to  2 15 13 16 }
 	    { #000000 -to  7 10 18 11 }
 	    { #000000 -to 12  7 13 10 }
 	    { #000000 -to  3  7 13  8 }
 	    { #000000 -to  3  6  6  7 }
  	    { #000000 -to 15  5 17  7}
  	    { #000000 -to 12  3 14  4}
  	    { #000000 -to 11  4}
  	    { #000000 -to 14  4}
  	    { #000000 -to 14  6}
  	    { #000000 -to 16  4}
  	    { #000000 -to  6 11}
  	    { #000000 -to  5 12}
  	    { #000000 -to  4 13}
  	    { #000000 -to  3 14}
  	    { #000000 -to 16 11}
  	    { #000000 -to 15 12}
  	    { #000000 -to 14 13}
  	    { #000000 -to 13 14}
	    { #ffff7d -to  3  7  6 12}
	    { #ffff7d -to  6  8 12 10}
	    { #ffff7d -to  3 12  5 13}
	    { #007d00 -to  3 13}
	    { #007d00 -to  6 10}
	    { #007d00 -to  7 11 16 12}
	    { #007d00 -to  6 12 15 13}
	    { #007d00 -to  5 13 14 14}
	    { #007d00 -to  4 14 13 15}
	}
    }
    {
	stop2 18 18 {
	    { #00007d -to  9  9 17 17 }
	}
    }
    {
	stop 18 18 {
	    { #0000ff -to  9  9 17 17 }
	}
    }
    {
	zoom 19 19 {
	    { #000000 -to  6 10  7 14 }
	    { #000000 -to  5 12  6 15}
	    { #000000 -to  4 13  5 16}
	    { #000000 -to  3 14  4 17}
	    { #000000 -to  2 15  3 17}
	    { #000000 -to  7 12  9 13}
	    { #000000 -to  9 13 13 14}
	    { #000000 -to 13 12 15 13}
	    { #000000 -to 15 10 16 12}
	    { #000000 -to 16  6 17 10}
	    { #000000 -to 15  4 16  6}
	    { #000000 -to 13  3 15  4}
	    { #000000 -to  9  2 13  3}
	    { #000000 -to  7  3  9  4}
	    { #000000 -to  6  4  7  6}
	    { #000000 -to  5  6  6 10}
	    { #ffffff  -to  7  4 15 12}
	    { #ffffff  -to  6  6  7 10}
	    { #ffffff  -to  9 12 13 13}
	    { #ffffff  -to 15  6 16 10}
	    { #ffffff  -to  9  3 13  4}
	    { #7d7d7d -to  7  4}
	    { #7d7d7d -to  7 11}
	    { #7d7d7d -to 14 11}
	    { #7d7d7d -to 14  4}
	    { #7dffff -to  7  9}
	    { #7dffff -to  9 11}
	    { #7dffff -to  8 10  9 12}
	    { #7dffff -to 11  4 14  5}
	    { #7dffff -to 13  5 15  6}
	    { #7dffff -to 14  6 15  8}
	}
    }
    {
	zoom2 19 19 {
	    { #000000 -to  6 10  7 14 }
	    { #000000 -to  5 12  6 15}
	    { #000000 -to  4 13  5 16}
	    { #000000 -to  3 14  4 17}
	    { #000000 -to  2 15  3 17}
	    { #000000 -to  7 12  9 13}
	    { #000000 -to  9 13 13 14}
	    { #000000 -to 13 12 15 13}
	    { #000000 -to 15 10 16 12}
	    { #000000 -to 16  6 17 10}
	    { #000000 -to 15  4 16  6}
	    { #000000 -to 13  3 15  4}
	    { #000000 -to  9  2 13  3}
	    { #000000 -to  7  3  9  4}
	    { #000000 -to  6  4  7  6}
	    { #000000 -to  5  6  6 10}
	    { gray85  -to  7  4 15 12}
	    { gray85  -to  6  6  7 10}
	    { gray85  -to  9 12 13 13}
	    { gray85  -to 15  6 16 10}
	    { gray85  -to  9  3 13  4}
	    { #7d7d7d -to  7  4}
	    { #7d7d7d -to  7 11}
	    { #7d7d7d -to 14 11}
	    { #7d7d7d -to 14  4}
	    { #7dffff -to  7  9}
	    { #7dffff -to  9 11}
	    { #7dffff -to  8 10  9 12}
	    { #7dffff -to 11  4 14  5}
	    { #7dffff -to 13  5 15  6}
	    { #7dffff -to 14  6 15  8}
	}
    }
    {
	ejecutar2 18 18 {
	    {#00007d -to 12  8 12  9}
	    {#00007d -to 12  9 13 10}
	    {#00007d -to 12 10 14 11}
	    {#00007d -to 12 11 15 12}
	    {#00007d -to 12 12 16 13}
	    {#00007d -to 12 13 15 14}
	    {#00007d -to 12 14 14 15}
	    {#00007d -to 12 15 13 16}
	    {#00007d -to 12 16 12 17}
	}
    }
    {
	ejecutar 18 18 {
	    {#0000ff -to 12  8 12  9}
	    {#0000ff -to 12  9 13 10}
	    {#0000ff -to 12 10 14 11}
	    {#0000ff -to 12 11 15 12}
	    {#0000ff -to 12 12 16 13}
	    {#0000ff -to 12 13 15 14}
	    {#0000ff -to 12 14 14 15}
	    {#0000ff -to 12 15 13 16}
	    {#0000ff -to 12 16 12 17}
	}
    }

    {
	iris 18 18 {

	    { #0000ff -to  5  5  7  6 }
	    { #0000ff -to  7  4 11  5 }
	    { #0000ff -to 11  5 13  6 }
	    { #0000ff -to  2  8}
	    { #0000ff -to  3  7}
	    { #0000ff -to  4  6}
	    { #0000ff -to 13  6}
	    { #0000ff -to 14  7}
	    { #0000ff -to 15  8}

	    { #00ffff -to  5  6  7  7 }
	    { #00ffff -to  7  5 11  6 }
	    { #00ffff -to 11  6 13  7 }
	    { #00ffff -to  2  9}
	    { #00ffff -to  3  8}
	    { #00ffff -to  4  7}
	    { #00ffff -to 13  7}
	    { #00ffff -to 14  8}
	    { #00ffff -to 15  9}

	    { #00ff00 -to  5  7  7  8 }
	    { #00ff00 -to  7  6 11  7 }
	    { #00ff00 -to 11  7 13  8 }
	    { #00ff00 -to  2 10}
	    { #00ff00 -to  3  9}
	    { #00ff00 -to  4  8}
	    { #00ff00 -to 13  8}
	    { #00ff00 -to 14  9}
	    { #00ff00 -to 15 10}

	    { #ffff00 -to  5  8  7  9 }
	    { #ffff00 -to  7  7 11  8 }
	    { #ffff00 -to 11  8 13  9 }
	    { #ffff00 -to  2 11}
	    { #ffff00 -to  3 10}
	    { #ffff00 -to  4  9}
	    { #ffff00 -to 13  9}
	    { #ffff00 -to 14 10}
	    { #ffff00 -to 15 11}

            { #ff0000 -to  5  9  7 10 }
	    { #ff0000 -to  7  8 11  9 }
	    { #ff0000 -to 11  9 13 10 }
	    { #ff0000 -to  2 12}
	    { #ff0000 -to  3 11}
	    { #ff0000 -to  4 10}
	    { #ff0000 -to 13 10}
	    { #ff0000 -to 14 11}
	    { #ff0000 -to 15 12}

            { #ff00ff -to  5 10  7 11 }
	    { #ff00ff -to  7  9 11 10 }
	    { #ff00ff -to 11 10 13 11 }
	    { #ff00ff -to  2 13}
	    { #ff00ff -to  3 12}
	    { #ff00ff -to  4 11}
	    { #ff00ff -to 13 11}
	    { #ff00ff -to 14 12}
	    { #ff00ff -to 15 13}
	}
	
    }
    {
	iris2 18 18 {

	    { #0000ff -to  5  5  7  6 }
	    { #0000ff -to  7  4 11  5 }
	    { #0000ff -to 11  5 13  6 }
	    { #0000ff -to  2  8}
	    { #0000ff -to  3  7}
	    { #0000ff -to  4  6}
	    { #0000ff -to 13  6}
	    { #0000ff -to 14  7}
	    { #0000ff -to 15  8}

	    { #00ffff -to  5  6  7  7 }
	    { #00ffff -to  7  5 11  6 }
	    { #00ffff -to 11  6 13  7 }
	    { #00ffff -to  2  9}
	    { #00ffff -to  3  8}
	    { #00ffff -to  4  7}
	    { #00ffff -to 13  7}
	    { #00ffff -to 14  8}
	    { #00ffff -to 15  9}

	    { #00ff00 -to  5  7  7  8 }
	    { #00ff00 -to  7  6 11  7 }
	    { #00ff00 -to 11  7 13  8 }
	    { #00ff00 -to  2 10}
	    { #00ff00 -to  3  9}
	    { #00ff00 -to  4  8}
	    { #00ff00 -to 13  8}
	    { #00ff00 -to 14  9}
	    { #00ff00 -to 15 10}

	    { #7d7d00 -to  5  8  7  9 }
	    { #7d7d00 -to  7  7 11  8 }
	    { #7d7d00 -to 11  8 13  9 }
	    { #7d7d00 -to  2 11}
	    { #7d7d00 -to  3 10}
	    { #7d7d00 -to  4  9}
	    { #7d7d00 -to 13  9}
	    { #7d7d00 -to 14 10}
	    { #7d7d00 -to 15 11}

            { #7d0000 -to  5  9  7 10 }
	    { #7d0000 -to  7  8 11  9 }
	    { #7d0000 -to 11  9 13 10 }
	    { #7d0000 -to  2 12}
	    { #7d0000 -to  3 11}
	    { #7d0000 -to  4 10}
	    { #7d0000 -to 13 10}
	    { #7d0000 -to 14 11}
	    { #7d0000 -to 15 12}

            { #ff00ff -to  5 10  7 11 }
	    { #ff00ff -to  7  9 11 10 }
	    { #ff00ff -to 11 10 13 11 }
	    { #ff00ff -to  2 13}
	    { #ff00ff -to  3 12}
	    { #ff00ff -to  4 11}
	    { #ff00ff -to 13 11}
	    { #ff00ff -to 14 12}
	    { #ff00ff -to 15 13}
	}
	
    }
    {
	pincel 18 18 {
	    { #7d0000 -to 15  3 16  5}
	    { #7d0000 -to 14  4 15  6}
	    { #7d0000 -to 13  5 14  7}
	    { #7d0000 -to 12  6 13  8}
	    { #7d0000 -to 11  7 12  9}
	    { #7d0000 -to 10  8 }
	    { #7d0000 -to  9  9 }
	    { #7d0000 -to  8 10 }
	    { #7d0000 -to  7 11 }
	    
	    { #7d7d00 -to 14  3 }
	    { #7d7d00 -to 13  4 }
	    { #7d7d00 -to 12  5 }
	    { #7d7d00 -to 11  6 }
	    { #7d7d00 -to 10  7 }
	    { #7d7d00 -to  9  8 }
	    { #7d7d00 -to  8  9 }
	    { #7d7d00 -to  7 10 }
	    { #7d7d00 -to  6 11 }
	    



	    { #000000 -to 10  9 }
	    { #000000 -to  9 10 }
	    { #000000 -to  8 11 }
	    { #000000 -to  7 12 }
	    
	    { gray60  -to  5 12 }
	    
	    { gray30  -to  6 12 }
	    { gray30  -to  7 13 }
	    { gray30  -to  6 14 }
	    { gray30  -to  5 15 }
	    
	    { #0000ff -to  5 13 }
	    { #0000ff -to  3 14  5 15 }
	    
	    { #00ffff  -to  4 13 }
	    
	    { #00007d -to  6 13 }
	    { #00007d -to  5 14 }
	    { #00007d -to  2 15  5 16 }
	}
    }
    {
	pincel2 18 18 {
	    { #7d0000 -to 15  3 16  5}
	    { #7d0000 -to 14  4 15  6}
	    { #7d0000 -to 13  5 14  7}
	    { #7d0000 -to 12  6 13  8}
	    { #7d0000 -to 11  7 12  9}
	    { #7d0000 -to 10  8 }
	    { #7d0000 -to  9  9 }
	    { #7d0000 -to  8 10 }
	    { #7d0000 -to  7 11 }
	    
	    { #7d7d00 -to 14  3 }
	    { #7d7d00 -to 13  4 }
	    { #7d7d00 -to 12  5 }
	    { #7d7d00 -to 11  6 }
	    { #7d7d00 -to 10  7 }
	    { #7d7d00 -to  9  8 }
	    { #7d7d00 -to  8  9 }
	    { #7d7d00 -to  7 10 }
	    { #7d7d00 -to  6 11 }
	    



	    { #000000 -to 10  9 }
	    { #000000 -to  9 10 }
	    { #000000 -to  8 11 }
	    { #000000 -to  7 12 }
	    
	    { gray60  -to  5 12 }
	    
	    { gray30  -to  6 12 }
	    { gray30  -to  7 13 }
	    { gray30  -to  6 14 }
	    { gray30  -to  5 15 }
	    
	    { #0000ff -to  5 13 }
	    { #0000ff -to  3 14  5 15 }
	    
	    { #00007d  -to  4 13 }
	    
	    { #00007d -to  6 13 }
	    { #00007d -to  5 14 }
	    { #00007d -to  2 15  5 16 }
	}
    }
}

foreach i $tablaDeImagenes {
    set nombre [lindex $i 0]
    set im \
	    [ image create photo -width [lindex $i 1] -height [lindex $i 2]]
    foreach j [lindex $i 3] { 
	eval [concat $im put $j]
    }
    set quiv(imagen,$nombre)  $im
}

set quiv(imagem,iris2) $quiv(imagen,iris)

}

proc quivTickDeX {x} {
    global quivParametro quivVentana quivEstado
    
    set c $quivVentana(tareasVisor)
    
    set tick \
	    [expr $quivEstado(desde) + int( ($x - $quivParametro(holguraHorizontal) )  / $quivParametro(anchuraDeTick))]
    
    ##
    ## Hemos pulsado fuera de los lugares sensibles
    if { $tick < 0 } {
	return $quivEstado(desde)
    }
    if { $tick > [expr $quivEstado(duracion)+$quivEstado(desde)] } {
	return [expr $quivParametro(numeroDeTicks) + $quivEstado(desde)]
    }

    return $tick
}


proc quivStartDrag {c x y} {
    global quivDragValues quivEstado quivParametro

    set x [$c canvasx $x]
    set y [$c canvasy $y]
    set quivDragValues(primerTick) [quivTickDeX $x] 

    $c delete linedrag
    $c delete textdrag
    $c create line $x $y $x $y -tag linedrag -arrow both
    $c create text $x $y \
	    -text [formatea 0 $quivEstado(posDecimales)] \
	    -tag textdrag -anchor se -fill black 
}

proc quivDrag {c x y} {
    global quivDragValues quivEstado

    set x [$c canvasx $x]
    set y [$c canvasy $y]

    set coords [$c coords textdrag]
    set ytext [lindex $coords 1]
    $c coords textdrag $x $ytext
    set longitud [expr abs ($quivDragValues(primerTick) - [quivTickDeX $x])]
    $c itemconfigure textdrag \
	    -text [formatea $longitud $quivEstado(posDecimales)]

    set coords [$c coords linedrag]
    set x1line [lindex $coords 0]
    set y1line [lindex $coords 1]
    set y2line [lindex $coords 3]
    $c coords linedrag $x1line $y1line $x $y2line
}

proc quivDeleteDrag {c} {
    $c delete linedrag
    $c delete textdrag
    $c delete dragsaved
}

proc quivFinDrag {c} {
    $c itemconfigure linedrag -tag dragsaved
    $c itemconfigure textdrag -tag dragsaved
}



proc quivFiltrarTraza {} {
    global quiv quivFiltro
    
    set fd [open $quiv(fichero)]
    set quiv(parametrosIniciales) \
	    [gets $fd ]
    set quiv(trazaGuardada) {}
    set max $quivFiltro(primero)
    set min $quivFiltro(ultimo)
    while { ! [eof $fd ] } {
	set lin [gets $fd ]
	if { $lin != "" } {
	    lappend quiv(trazaGuardada) $lin
	    if { $quivFiltro(actualiza) } {
		set t [lindex $lin 0]
		if {$t < $min && $t >= $quivFiltro(primero) } {
		    set min $t
		}
		if {$t > $max  && $t <= $quivFiltro(ultimo)} {
		    set max $t
		}	    
	    }
	}
    }
    close $fd

    set quiv(parametrosIniciales) \
	    [lreplace $quiv(parametrosIniciales) 3 4 [expr $max - $min + 1] $min]
    puts $quiv(parametrosIniciales)
    foreach lin $quiv(trazaGuardada) {
	eval [concat quivFiltrarUnaLinea $lin]
    }
}


proc quivFiltrarUnaLinea {t losEventos} {
    global quiv quivFiltro

    if { $t < $quivFiltro(primero) } return
    if { $t > $quivFiltro(ultimo) } return
    foreach ev $losEventos {
	set tipo [lindex $ev 0]
	if { $tipo == ""} {
	    quivError "ERROR en $t $losEventos"
	}

	if { [lsearch $quivFiltro(tiposno) $tipo] != -1 } return
	if { [lsearch $quivFiltro(tiposno) $quivFiltro(pareja,$tipo)] != -1 } return

	set linea [lindex $ev 1]
	if { $linea == ""} {
	    quivError "ERROR en $t $losEventos"
	}
	set arg2 [lindex $ev 2]
	set arg3 [lindex $ev 3]

	puts [list $t [list [list $tipo $linea $arg2 $arg3]]]
    }
}



###############################################
# COMENZAMOS
###############################################

set quiv(hemosParado) 0
set quiv(ficheroDatos) ""
set quiv(trazaGuardada) {}	

if { $argc == 0 } {
    iniInterfaz
} elseif { $argc == 1 } {
    iniInterfaz
    cargarFichero [lindex $argv 0]
} else {

    set quiv(fichero) [lindex $argv 0]
    set quivFiltro(actualiza) 0
    set quivFiltro(primero) 0
    set quivFiltro(ultimo)  [expr int (pow(2,31) - 1)]
    set quivFiltro(tiposno) ""

    set quivFiltro(pareja,0) LLEGA
    set quivFiltro(pareja,1) ACABA
    set quivFiltro(pareja,2) PLAZO
    set quivFiltro(pareja,3) C-EJE
    set quivFiltro(pareja,4) T-EJE
    set quivFiltro(pareja,5) C-PRE
    set quivFiltro(pareja,6) T-PRE
    set quivFiltro(pareja,7) ENTSC
    set quivFiltro(pareja,8) SALSC
    set quivFiltro(pareja,9) EV-AR
    set quivFiltro(pareja,10) EV-AB
    set quivFiltro(pareja,11) SUSPE
    set quivFiltro(pareja,12) CMODO
    set quivFiltro(pareja,LLEGA)  0
    set quivFiltro(pareja,ACABA)  1
    set quivFiltro(pareja,PLAZO)  2
    set quivFiltro(pareja,C-EJE)  3
    set quivFiltro(pareja,T-EJE)  4
    set quivFiltro(pareja,C-PRE)  5
    set quivFiltro(pareja,T-PRE)  6
    set quivFiltro(pareja,ENTSC)  7
    set quivFiltro(pareja,SALSC)  8
    set quivFiltro(pareja,EV-AR)  9
    set quivFiltro(pareja,EV-AB) 10
    set quivFiltro(pareja,SUSPE) 11
    set quivFiltro(pareja,CMODO) 12
    
    set i 1
    while {$i < $argc} {
	set arg [lindex $argv $i]
	switch -regexp OP$arg {
	    OP-b|OP--begin {
		incr i
		set quivFiltro(primero) [lindex $argv $i]
	    }
	    OP-e|OP--end {
		incr i
		set quivFiltro(ultimo) [lindex $argv $i]
	    }
	    OP-x|OP--exclude {
		incr i
		set quivFiltro(tiposno) [lindex $argv $i]
	    }
	    OP-a|OP--adjust {
		set quivFiltro(actualiza) 1
	    }	
	    default { 
		puts "error en el argumento $arg"
		puts "quivi help"
		puts {usage quivi [ file [ options ]]}
		puts "options:"
		puts " -b|--begin tick"
		puts " -e|--end  tick"
		puts " -a|--adjust"
		puts { -x|--exclude "event_list"}
		exit
	    }
	}
	incr i
    }
    
    quivFiltrarTraza
    exit
}


