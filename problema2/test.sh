#!/bin/bash
rm -R /home/yin/Desktop/problema2/hojasDatos/full_datos
rm -R /home/yin/Desktop/problema2/hojasDatos/datos_graf
rm -R /home/yin/Desktop/problema2/hojasDatos/datos_csv
DATA=/home/yin/Desktop/problema2/hojasDatos/
OUT_DATA=$DATA/datos_csv
GRAF_DATA=$DATA/datos_graf
FULL_DATA=$DATA/full_datos

mkdir $DATA/datos_csv
mkdir $GRAF_DATA
mkdir $FULL_DATA

b=4
m=0
for i in `find $DATA -name '*01_2012.xls' ` `find $DATA -name '*02_2012.xls' ` `find $DATA -name '*03_2012.xls' `
do
        if [ $m -ne 3 ]; then
                echo "Procesando archivo $i"
                xls2csv $i > $OUT_DATA/data-$m.csv
                let m=m+1
        fi
done 2> error.log

