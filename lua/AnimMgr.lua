LuaQ                L      A@  @ 
   E  Z     
E   ΐ  \ €        €@     @ €      €ΐ     ΐ €       €@    @ €     €ΐ    ΐ €       €@    @ €     €ΐ    ΐ €       c   d@ 	@d 	@ dΐ 	@d  	@ d@     	@d 	@ dΐ 	@d  	@ d@ 	@d 	@ dΐ 	@          require    PiniAPI 
   OnPreview    plua.utils    FAL_REGIST    FAL_GETFRAME    FAL_GETVALUE    FAL_GETSTRVALUE    FAL_ISVALUE    FAL_DELETEFRAME    FAL_MAXFRAME    FAL_ISEXISTS    FAL_NUMNODE    FAL_REGISTSTRINGVALUE    FAL_REGISTNUMBERVALUE    FAL_DELETENODEVALUE    FAL_CLEARFRAME    init    clear    registAnimation    interpolation    run    adjustFrame 	   maxFrame    isAnim    numNode    stop    registArgument        
          D   F ΐ    ]  ^           FAL_registAnimation                            
   D  Fΐ  ΐ   @ ] ^          FAL_getFrame                                   @ΐ                 FAL_getNumberVal                                   @ΐ                 FAL_getStringVal                                   @ΐ                 FAL_isValue                               D   F ΐ    ]  ^           FAL_deleteFrame                                   @ΐ                 FAL_getMaxFrame                        !       D   F ΐ    ]  ^           FAL_isExists                     "   $       D   F ΐ    ]  ^           FAL_numNode                     %   '       Δ   Ζ ΐ   @  έ  ή           FAL_registStringValue                     (   *       Δ   Ζ ΐ   @  έ  ή           FAL_registNumberValue                     +   -       D   F ΐ    ]  ^           FAL_deleteNodeValue                     .   0            @              FAL_clearFrame                     B   D        	@         XVM                     F   H                                  J   L           Ζ@ΐ @         FAL_REGIST    json                     N   P        A  NΑ AAA             π?       @                    R   Ώ   	 n   Ϊ  Kΐ\Β B  G  J    IB  I ΐ@@Ε   @ ά   ΕB Ϊ  	Ε   @ ά  ΓA ΐ  A ΐ  B  C C B@  D  KΔΑΐ   @  ΐ @   \D !   όΓ FΓC @δ     
 	Γ	ΓC	C		FΓ	C	C		C 	E KCΖΖΓ Υ\Z  @ ΓΖC Κ  ΙΓCΙC  CGΖΓ ΥΔ @ Γ	  GC ΓΗ dD  C   !      x    y 	   position     FAL_MAXFRAME 
   OnPreview    FAL_MARKEDFRAMES    adjustFrame       π?   python 
   enumerate    FAL_DELETENODEVALUE    id 	   curFrame    delta            dt    i    max    nodeId    default    loopCnt    name    args    pini 
   FindTimer    _ATL_TIMER    stop 	   userdata    Timer    run    registOnExit    PINI_ANIM_MGR        l   ‘    j   D    ΐ  E@  Fΐ H   Aΐ   A @AΖ A ΖΑA ΑAFA FΒA ABΖA ΖΒΒ CA BCFA FΓA ΒCΖA ΖΔ @C FA FCΓC D C   B  WΐΔΐ O@@  Aΐ    E ΐ  @  ΐ B  C 	  E ΐ  AΔ   ΐ B C @Μΐΐΐΐ   Α@ΐD@C FA FCΓC D C Αΐ ΐ   E ΐ  AΔ   ΐ B C A 	A 	Γ A 	         _G    AnimMgr       π?	   userdata    delta 	   curFrame    loopCnt    dt    i    max    pini 	   FindNode    nodeId    default    name    args    FAL_DELETENODEVALUE    stop            adjustFrame                     Ά   Ό        E   K@ΐ Ζ@ Α  Υ \Z      Ζ@ @ @Α @         pini 
   FindTimer    id    _ATL_TIMER    FAL_DELETENODEVALUE    stop                                 Α      	 ΄   FΐZ      AB  @  MΒΐB ΐ   MΑΓΑΐ  B ΐ   @ΓΑΐ  B ΐ  B% Ε    ΐ# ΐΒΕ  @ά E  ΐ\Z   E  ΐ\ KDC ΐ   @\  Ε  @ά   @Β ΛΓΓFDLάC@Α ΛCΔFDLάCΐΔΐ ΛΕ@ άC ΐΐΐ ΛCΕ@ άCΕΐ ΛΓΕ@ άC  ΖΐΛCΖά Ζ ΖΔΔΕΐDΐΖΐΛCΖά ΖΑΐ ΕΐD  ΗΐΛCΖά ΖΑΖΔΔ  D@Ηΐ ΛΗ@ άC 
ΐΒ   	ΖΓG ΖΘΔΑΙΖΓG ΛΘ@   ΕΔ Σ	άΪ  ΐΖΓG ΛΙEΔ SάC@@Ι@ @Ε	 ΖάC @@ΐΐ @ΖΓΙ Κ ΛCΚ@ άCΪ  *      isDestroyed       &@      @   fd1    FAL_GETFRAME       π?   id    fd2            FAL_ISVALUE       "@   FAL_GETVALUE    interpolation    FAL_GETSTRVALUE    setPositionX    x    setPositionY    y        @
   setScaleX 
   setScaleY       @
   setRotate       @	   getColor 	   setColor       @      @       @   setOpacity    XVM 	   variable    FAL.λΈλμ΄λ¦    call 
   OnPreview    doNext       $@   _G    type    Sprite 
   setSprite                               Ε     @ έ ή           FAL_MAXFRAME                     "  $          ΐ               FAL_ISEXISTS                     &  (          ΐ               FAL_NUMNODE                     *  0          @@ΐ AΑ  A    Λ Aά@ Λ@Α A ά@        pini 
   FindTimer    id    _ATL_TIMER    stop    unregistOnExit    PINI_ANIM_MGR                     2  8         @ @@  @  ΐ   @Α  @  ΐ           type    number    FAL_REGISTNUMBERVALUE    FAL_REGISTSTRINGVALUE                             