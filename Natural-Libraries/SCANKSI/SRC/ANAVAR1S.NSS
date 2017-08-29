* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
define data global using anamod0g 
parameter 
1 #text (a93) 
1 redefine #text 
  2 #textarray(a1/1:93) 
1 #structure (a50) 
1 #viewmode (l) 
1 #viewname (a50) 
1 #objmodul (a32) 
1 #lineno1 (i4) 
1 #lineno2 (i4) 
local using anadataa 
local 
1 #lineout (a5) 
1 #line2out (a5) 
1 #i2 (i4) 
1 #i6 (i4) 
1 #i7 (i4) 
1 #found (l) 
1 #level (a50) 
1 #levelend (i4) 
1 #variable (a50) 
1 redefine #variable 
  2 #varred (a8) 
  2 #varrem (a42) 
1 #format (a50) 
1 #state (a1) 
1 #i1 (i4) 
1 #basf (a50) 
1 #basl (a50) 
1 #basv (a50) 
1 #temp (a93) 
1 #formattemp (a1) 
end-define 
define subroutine anavar1s 
/* Get LEVEL of VAR 
if #text = ' ' 
  escape routine 
end-if 
move edited #lineno1 (em=99999) to #lineout 
move edited #lineno2 (em=99999) to #line2out 
reset #level #variable #format 
#state := 'L' 
for #i2 = 1 to 93 
  decide for every condition 
    when #state = 'L' and not #textarray(#i2) is (n10) 
      #state := 'V' 
    when #state = 'V' and  #textarray(#i2) = '(' 
      #state := 'F' 
    when #state = 'F' and #format = scan ')' 
      escape bottom 
    when #state = 'L' and #textarray(#i2) <> ' ' 
      compress #level #textarray(#i2) into #level leaving no 
    when #state = 'V' and #textarray(#i2) <> ' ' 
      compress #variable #textarray(#i2) into #variable leaving no 
    when #state = 'F' and #textarray(#i2) <> ' ' 
      compress #format #textarray(#i2) into #format leaving no 
    when none 
      ignore 
  end-decide 
end-for 
/* special Case REDEFINE (no Format is given) 
if #level <> ' ' and #varred = 'REDEFINE' and #format = ' ' 
  #format := #varrem 
  #variable := #varred 
end-if 
/* check for Hex-Value 
examine #text pattern '<*H''*''*>'  giving position #i1 
if #i1 <> 0 
  reset #temp 
  for #i6 = #i1 to 93 
    compress #temp #textarray(#i6) into #temp leaving no 
  end-for 
  examine #temp pattern 'H''FF''' giving position #i6 
  examine #temp pattern 'H''00''' giving position #i7 
  if #i6 = 0 and #i7 = 0 
    if #objmodul = objname 
      compress 'HEX' #lineout 'VARIABLE DEFINED :'  #text into COMMENT 
    else 
      compress 'HEX' #lineout 'IN' #objmodul  'LINE' #line2out '->' 'VARIABLE DEFINED :'  #text into COMMENT 
    end-if 
    add 1 to COUNTHEX 
    perform anaouts 
  end-if 
end-if 
if not #level is (n15) 
  if baselevel <> 0 and #variable = 'LOCAL' 
    reset basevar(*) redef 
  end-if 
  escape routine 
end-if 
/* 
if #format = 'VIEW' 
  #viewmode := true 
else 
  if #viewmode and val(#level) = 1 
    reset #viewmode #viewname 
  end-if 
end-if 
/* 
decide for first condition 
  when #viewmode 
    if val(#level) = 1 
/* View Name 
      #structure := #variable 
      reset #viewname #found 
      for #i2 = 93 to 1 step -1 
        if #found and #textarray(#i2) = ' ' 
          escape bottom 
        end-if 
        if #textarray(#i2) <> ' ' 
          compress #textarray(#i2) #viewname into #viewname leaving no 
          #found := true 
        end-if 
      end-for 
    else 
/* View Field 
      #anadata.#var1 := #variable 
      #anadata.#var2 := ' ' 
      #anadata.#dataobject := #viewname 
      #anadata.#library := OBJLIBRARY 
      #anadata.#var1only := true 
      callnat 'ANAVIEWN' #anadata 
      if #anadata.#isnumeric 
/* Field is numeric 
        add 1 to VARCOUNT 
        perform getformat 
        VARTYPE(VARCOUNT) := #formattemp 
        VARNAME(VARCOUNT) := #variable 
        compress #structure '.' #variable into FVARNAME(VARCOUNT) leaving no 
        VIEW(VARCOUNT) := 'V' 
      end-if 
    end-if 
  when #variable = 'REDEFINE' 
/* Redefine 
    if val(#level) = 1 
      #structure := #format 
    end-if 
    baselevel := val(#level) 
    basevar(baselevel) := lastvar 
    baselevel := val(#level) 
  when #format = ' ' and val(#level) = 1 
/* Structure 
    #structure := #variable 
  when  #format = scan 'I' or = scan 'P' or = scan 'N' or 
      = scan 'F' or = scan 'B'  or = scan 'D' or = scan 'T' or = 'C' 
/* numeric Variable -> put in Variable-Table 
    add 1 to VARCOUNT 
    perform getformat 
    VARTYPE(VARCOUNT) := #formattemp 
    VARNAME(VARCOUNT) := #variable 
    if val(#level) > 1 
      compress #structure '.' #variable into FVARNAME(VARCOUNT) leaving no 
    end-if 
  when  not (#format = scan 'I' or = scan 'P' or = scan 'N' or 
      = scan 'F' or = scan 'B' or = scan 'D' or = scan 'T' or = 'C') 
/* non numeric Variable 
    ignore 
  when any 
/* special Function to investigate format incompatible Redefines 
    if val(#level) <= baselevel and #variable <> 'REDEFINE' 
      if baselevel < 1 or baselevel > 10 
        ignore 
      else 
        if val(#level) = 1 
          reset redef 
        else 
          reset basevar(baselevel) 
        end-if 
      end-if 
      if baselevel > 1 
        baselevel := baselevel -1 
      end-if 
    end-if 
    if baselevel > 0 and basevar(baselevel) <> ' ' and #variable <> 'REDEFINE' 
/* Varaible is a Redefinition 
      separate basevar(baselevel) into #basl #basv #basf with delimiter ' ' 
      if (#basf = scan 'A' or = scan 'F' or = scan 'L' or = scan 'N' and 
          #format = scan 'I' or = scan 'P' or = scan 'B' or = scan 'D' or = scan 'T' or = scan 'C') 
          or 
          (#format = scan 'A' or = scan 'F' or = scan 'L' or = scan 'N' and 
          #basf = scan 'I' or = scan 'P' or = scan 'B' or = scan 'D' or = scan 'T' or = scan 'C') 
/* inkompatible 
        if #objmodul = objname 
          compress 'RED' #lineout #basv #basf 'REDEFINED BY' #variable #format into COMMENT 
        else 
          compress 'RED' #lineout 'IN' #objmodul 'LINE' #line2out '->' #basv #basf 'REDEFINED BY' #variable #format into COMMENT 
        end-if 
        add 1 to COUNTRED 
        perform anaouts 
      end-if 
    end-if 
  when none 
    ignore 
end-decide 
compress #level #variable #format into lastvar 
 
define subroutine getformat 
/* get 1 Byte Text Format of Variable in 
decide for first condition 
  when #format = scan 'I' 
    #formattemp := 'I' 
  when #format = scan 'P' 
    #formattemp := 'P' 
  when #format = scan 'N' 
    #formattemp := 'N' 
  when #format = scan 'F' 
    #formattemp := 'F' 
  when #format = scan 'B' 
    #formattemp := 'B' 
  when #format = scan 'D' 
    #formattemp := 'D' 
  when #format = scan 'T' 
    #formattemp := 'T' 
  when #format = scan 'C' 
    #formattemp := 'C' 
  when none 
    reset #formattemp 
end-decide 
end-subroutine 
 
end-subroutine 
end 
