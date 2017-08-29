* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
/* build table of all numeric variables used in modul 
define data global using anamod0g 
parameter 
1 #BEGIN-DEFINE-POS (i4) 
1 #END-DEFINE-POS (i4) 
local using anadataa 
local 
1 #i (i4) 
1 #i2 (i4) 
1 #i6 (i4) 
1 #i7 (i4) 
1 #found (l) 
1 #structure (a50) 
1 #viewmode (l) 
1 #viewname (a50) 
1 #da (a8) 
end-define 
define subroutine anavar0s 
for #i = #BEGIN-DEFINE-POS to #END-DEFINE-POS 
   /* all Variables 
   examine text(#i) for 'USING' with delimiters ' ' giving position #i2 
   if #i2 = 0 
      /* direct variable 
      perform anavar1s text(#i) #structure #viewmode #viewname OBJNAME #i #i 
   else 
      /* Data Area 
      /* get name of DataArea 
      reset #found #da 
      for #i6 = #i2 to 92 
         /* loop from act. statement to End of Line -1 
         if textarray(#i,#i6) = ' ' and textarray(#i,#i6 +1) <> ' ' 
            add 1 to #i6 /* start position of data area name found 
            #found := true 
            escape bottom 
         end-if 
      end-for 
      if #found 
        for #i7 = #i6 to 93 
            /* loop from start position of after token to end of line 
            if textarray(#i,#i7) = ' ' 
               escape bottom 
            else 
               compress #da textarray(#i,#i7) into #da leaving no 
            end-if 
        end-for 
      end-if 
      if #da <> ' ' 
         /* process data area 
         #anadata.#dataobject := #da 
         #anadata.#library := OBJLIBRARY 
         #anadata.#lineno := #i 
         perform anadatas #ANADATA 
      end-if 
   end-if 
end-for 
end-subroutine 
end 
