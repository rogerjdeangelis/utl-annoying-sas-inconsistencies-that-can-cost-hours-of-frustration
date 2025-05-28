%let pgm=utl-annoying-sas-inconsistencies-that-can-cost-hours-of-frustration;

%stop_submission;

Annoying sas inconsistencies that can cost hours of frustration

github
https://tinyurl.com/2zcktxyh
https://github.com/rogerjdeangelis/utl-annoying-sas-inconsistencies-that-can-cost-hours-of-frustration

SOAPBOX ON

All of the information  below may not be correct. The information
was difficult to get. I tried to verify as I could.

Perhaps it would be better if sas added functionality to
proc sql instead of adding an entirely new version of sql.

   Usefull changes to proc sql

      1 support 128bit floats (helpd with bigint. Hote float math is faster than integer math?)
      2 row_number() OVER (PARTITION BY ID ) as partition from have )
      3 window extensions (works in viya but you have to use proc fedsql?)
        You lose too much other functionality with fedqql.

   Perhaps the Siemens SAS clone might consider enhancing classic SAS.
   Would be nice to get rid of FEDSQL?
   Would be nice to have the 1980's classic editor with command macros?


ISSUES
======

1 Prxmatch works with numerics in datastep but not in proc sql.
===============================================================

  This is useful when defaulting to a 1 result when
  the the second aargument is atring or number.

  There probably other places where the automatic conversio does not take place in proc sql.

  Prxmatch is always one in datastep

  data alwaysone;
    string="ROGER";
    matchc=prxmatch('/./',string);
    put matchc=;
    /*---- even works for a number ----*/
    number=99;
    matchn=prxmatch('/./',number);
    put matchn=;
  run;quit;

  MATCHC=1
  MATCHN=1

 But not in SQL

 proc sql;
   select
     prxmatch('/./',age) as not_1  /*---- worked in datastep ----*/
   from
     sashelp.class
 ;quit;

  ERROR: Function PRXMATCH requires a character expression as argument 2


2 WHY I USE RUN;QUIT;
=====================

   Procedures that are not always terminated with a single run statement
   I lost over two hours because of one of these, vowed never again.

   PROC DATASETS
   PROC CATALOG
   PROC PLOT
   PROC PMENU
   PROC TRANTAB
   PROC REG
   PROC GLM
   PROC GCHART
   PROC GMAP
   PROC GPLOT
   PROC GREPLAY
   PROC GSLIDE
   PROC GAREABAR
   PROC GBARLINE
   PROC GKPI
   PROC GRADAR
   PROC GTILE


3 SYMGET ONLY WORKS IN PROC SQL VIEWS AND DOES NOT WORK IN FEDSQL

4 WHICHC OR WHICHN NOT SUPPORTED IN PROC SQL OR FEDSQL

5 WHY I DON'T USE PROC FEDSQL

  I wish sas would provide a lst?

    a cannot create macro variables (into clause not supported in fedsql)
    b cannot access work or sashelp directly you need to create a libanme
    c cannot access macros like
      proc sql;
        select
          name
         ,sex
        from
          sashelp.class
        where name in (
           %utl_concat(        /*---- names that begin with A ----*/
              sashelp.class
             ,var=name
             ,unique=Y
             ,qstyle=DOUBLE
             ,od=%str(,)
             ,prx="/^A/") )
      ;quit;

      Which yeilds names that begin with "A"

      NAME      SEX
      -------------
      Alfred    M
      Alice     F
    d fedsql does not support the order by clause
    e Full SAS date/time functions not supported
    f Many String manipulation not supported
       input, put (some)  scan, substrn , whichc, whichn...
    g resolve is not supported in fedsql
    h try this with fedsql (create a simple clinical table)
      proc sql;
          select resolve(catx(" ",'%let',sex,'=',sex,'#(N=',put(Count(name),4.),');'))
               from sashelp.class group by sex
      ;quit;

      %put &=f;
      %put &=m;

      data have;
         major='Race'; minor="Black "; F= '4';M= '5';output;
         major='Race'; minor="White";  F= '5';M= '5';output;
      run;quit;

      proc report data=have split='#';
      columns major minor f m;
      define major / group width=6;
      define minor / display;
      define  f / %sysfunc(compress("&f")) width=9 center;
      define  m / %sysfunc(compress("&m")) width=9 center;
      run;quit;

                            F          M
        MAJOR   MINOR     (N=9)     (N=10)
        Race    Black       4          5
                White       5          5

SOAPBOX OFF

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
