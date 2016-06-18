#!/bin/bash
rm -R //home/yin/Desktop/Problema1/hojasDatos/full_datos
rm -R //home/yin/Desktop/Problema1/hojasDatos/datos_graf
rm -R //home/yin/Desktop/Problema1/hojasDatos/datos_csv
DATA=/home/yin/Desktop/Problema1/hojasDatos/
OUT_DATA=$DATA/datos_csv
GRAF_DATA=$DATA/datos_graf
FULL_DATA=$DATA/full_datos

mkdir $DATA/datos_csv
mkdir $GRAF_DATA
mkdir $FULL_DATA

m=0
for i in `find $DATA -name '*.xls' `
do
	echo "Procesando archivo $i"
	
	xls2csv $i > $OUT_DATA/data-$m.csv
	let m=m+1
done 2> error.log
m=0
for e in `find $OUT_DATA -name "*.csv"`
do
	echo "Dando formato de datos para graficar el archivo $e"
	cat $e |awk -F "\",\"" '{print $1"  "$2"  "$3"  "$4"  "$5}'|sed '1, $ s/"//g'|sed '1 s/date/#date/g' > $GRAF_DATA/graf-$m.dat
	let m=m+1
done 2> error2.log

#ESTE CONDICIONAL ELIMINA EL ARCHIVO FULL.DAT	ya q si corre varias veces
#entonces genera mas datos al archivo en ves de crearlo
# con los datos generados incialmente

if [ -a $FULL_DATA/full.dat ]
then
	rm $FULL_DATA/full.dat
	echo "archivo full.dat borrado"
fi 2> errorIF.log

m=0
for k in `find $GRAF_DATA -name "*.dat"`
do
	sed '1d' $k >> $FULL_DATA/full.dat
	let m=m+1
	echo "Procesando archivo $k"
done 2> error3.log

FMT_BEGIN='20110208 0204'
FMT_END='20110208 0208'
FMT_X_SHOW='%H : %M'
DATA_DONE=$FULL_DATA/full.dat

#la linea set xrange que esta comentada deja en manos de gnulop e1
#la seleccion del mejor ranfo en el eje x de forma q aparezcan todos los datos
#si la descomentan entonces se puede manejar el despliegue de estos a traves
#sw variables FMT_BEGIN y FMT_END

graficar()
{
	gnuplot << EOF 2> error.log
	set xdata time
	set timefmt "%Y%m%d %H%M"
	set xrange["$FMT_BEGIN" : "$FMT_END"]
	set format x "$FMT_X_SHOW"
	set terminal png
	set output 'fig4.png'
	plot "$DATA_DONE" using 1:3 with lines title "sensor1", "$DATA_DONE" using 1:4 with linespoints title "sensor2"
EOF

}

graficar
