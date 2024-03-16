import capi
import pixie, leptonica
import std/[strformat,strutils]

type
  TesserAct* = object
    handle*: ptr TessBaseAPI #= tessBaseAPICreate() #TessBaseAPIptr

proc `=destroy`*(self: TesserAct) =
  self.handle.tessBaseAPIEnd()
  #if not isNil(self):
  tessBaseAPIDelete(self.handle)
  #self.handle = nil

proc newTesseract*(language:string = "eng"; dataPath:string = ""): TesserAct =
  result = TesserAct(handle: tessBaseAPICreate())
  
  var status = result.handle.tessBaseAPIInit3(datapath, language)
  if status == -1:
    raise newException(TesseractError, "Couldn't initialize Tesseract")  




##  Base API

# https://github.com/DavideGalilei/nimtesseract/blob/a315d45e3ebb58214fbf07c49f58ea603de93e59/src/nimtesseract.nim#L60
proc setImage*( self: Tesseract;
                imagedata: pointer;
                width, height, bytesPerPixel: int;
                bytesPerLine: int = 0) =
    var
        # imagedata: cstring = cstring(imagedata)
        width: cint = cint(width)
        height: cint = cint(height)
        bytesPerPixel: cint = cint(bytesPerPixel)

        bytesPerLine: cint = if bytesPerLine != 0: cint(bytesPerLine)
            else: width * bytesPerPixel

    tessBaseAPISetImage(
        self.handle,
        cast[ptr cuchar](imagedata),
        width,
        height,
        bytesPerPixel,
        bytesPerLine,
    )

proc setImage*( self: Tesseract;
                image: Image) =
  self.setImage(
      imagedata = addr(image.data[0]), # https://github.com/Altabeh/tesseract-ocr-wrapper/blob/main/utils.py#L52
      image.width,
      image.height,
      4 # Pixie uses RGBA every time, 4 bytes each
  )

proc setImage*( self: Tesseract;
                image: ptr Pix) =
      self.handle.tessBaseAPISetImage2(image)

# https://github.com/DavideGalilei/nimtesseract/blob/a315d45e3ebb58214fbf07c49f58ea603de93e59/src/nimtesseract.nim#L80
proc setPPI*(self: Tesseract, ppi: int) =
  tessBaseAPISetSourceResolution(self.handle, cint(ppi))

# https://github.com/DavideGalilei/nimtesseract/blob/a315d45e3ebb58214fbf07c49f58ea603de93e59/src/nimtesseract.nim#L84
proc getText*(self: Tesseract): string =
    return $tessBaseAPIGetUTF8Text(handle = self.handle)


proc getComponentImages*(self:Tesseract;
                        level: TessPageIteratorLevel;
                        textOnly: bool; 
                        pixa: ptr ptr Pixa = nil;
                        blockids: ptr ptr cint = nil): ptr Boxa =
  self.handle.tessBaseAPIGetComponentImages(level, textOnly, pixa, blockids)

proc getConfidence*(self:Tesseract):int =
  self.handle.tessBaseAPIMeanTextConf()


proc setRectangle*(self:Tesseract; rect:tuple[x,y,w,h:int]) =
  self.handle.tessBaseAPISetRectangle(rect.x.cint,rect.y.cint,rect.w.cint,rect.h.cint)



proc recognize*(self:Tesseract; monitor: ptr Etext_Desc = nil) =
  var ok = self.handle.tessBaseAPIRecognize(monitor)
  
  if ok != 0:
    raise newException(ValueError, "failed to recognize the image")

proc setPageSegMode*(self:Tesseract; mode: TessPageSegMode) =
  self.handle.tessBaseAPISetPageSegMode(mode)

proc getPageSegMode*(self:Tesseract): TessPageSegMode =
  self.handle.tessBaseAPIGetPageSegMode


proc analyseLayout*(api:Tesseract): ptr TessPageIterator =
  api.handle.tessBaseAPIAnalyseLayout() 



proc setRectangle*(api:Tesseract;left,top,right,bottom:int) =
  api.handle.tessBaseAPISetRectangle(left.cint, top.cint, right.cint, bottom.cint)

proc setVariable*(api:Tesseract; variable,value:string) =
  # https://zdenop.github.io/tesseract-doc/classtesseract_1_1_tess_base_a_p_i.html#a2e09259c558c6d8e0f7e523cbaf5adf5
  var ok = api.handle.tessBaseAPISetVariable(variable, value)
  #echo ok
  #if not ok:
  #  raise newException(ValueError, "failed setting variable: " & variable & "=" & value)



proc getHOCRText*(api:Tesseract; pageNumber:int):string =
  $api.handle.tessBaseAPIGetHOCRText(pageNumber.cint)


## # Iterators

# RIL_BLOCK, RIL_PARA, RIL_TEXTLINE, RIL_WORD, RIL_SYMBOL
iterator blocks*(self:Tesseract; textOnly:bool = true):BoxItem =
  var boxes = self.getComponentImages(RIL_BLOCK, textOnly)
  for i in 0..<boxes[].n:
    yield newBoxItem( boxaGetBox(boxes, i, L_CLONE) )

iterator paragraphs*(self:Tesseract; textOnly:bool = true):BoxItem =
  var boxes = self.getComponentImages(RIL_PARA, textOnly)
  for i in 0..<boxes[].n:
    yield newBoxItem( boxaGetBox(boxes, i, L_CLONE) )

iterator textLines*(self:Tesseract; textOnly:bool = true): BoxItem =
  var boxes = self.getComponentImages(RIL_TEXTLINE, textOnly)
  for i in 0..<boxes[].n:
    yield newBoxItem( boxaGetBox(boxes, i, L_CLONE) )

iterator words*(self:Tesseract; textOnly:bool = true): BoxItem =
  var boxes = self.getComponentImages(RIL_WORD, textOnly)
  for i in 0..<boxes[].n:
    yield newBoxItem( boxaGetBox(boxes, i, L_CLONE) )

iterator symbols*(self:Tesseract; textOnly:bool = true): BoxItem =
  var boxes = self.getComponentImages(RIL_SYMBOL, textOnly)
  for i in 0..<boxes[].n:
    yield newBoxItem( boxaGetBox(boxes, i, L_CLONE) )


##[
# Page Iterator

El PageIterator es más amplio y se utiliza para recorrer las páginas de un documento multipágina.
Proporciona acceso a los resultados de reconocimiento de texto en cada página.
Puedes usarlo para iterar a través de las páginas de un archivo PDF o cualquier otro documento de varias páginas.
]##

# type
#   PageIterator* = object
#     handle: ptr TessPageIterator

# proc `=destroy`*(self: PageIterator) =
#   #if not isNil(self):
#   tessPageIteratorDelete(self.handle)
#   #self.handle = nil

# ## Converters
# # converter toPageIterator*(self:ResultIteratorObj): PageIterator =
# #   PageIterator(handle: self.handle.tessResultIteratorGetPageIterator)



# proc getBoundingBox*(self:PageIterator; level:TessPageIteratorLevel):tuple[left,top,right,bottom:int] =
#   # https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1lP6it4d7dq9Ij-ic4tvmcA4DOv_GpyajZS28CJgzKtFUYU83AfJVXBwMADvzFlSAvw&usqp=CAU
#   var left,top,right,bottom:cint
#   var ok = self.handle.tessPageIteratorBoundingBox(
#                           level, 
#                           left.unsafeAddr,
#                           top.unsafeAddr, 
#                           right.unsafeAddr,
#                           bottom.unsafeAddr)
#   if not ok:
#     raise newException(ValueError, "failed getting the Bounding Box")      
#   return (left.int,top.int,right.int,bottom.int)


proc getBoundingBox*(self:ptr TessPageIterator; level:TessPageIteratorLevel):tuple[left,top,right,bottom:int] =
  # https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1lP6it4d7dq9Ij-ic4tvmcA4DOv_GpyajZS28CJgzKtFUYU83AfJVXBwMADvzFlSAvw&usqp=CAU
  var left,top,right,bottom:cint
  var ok = self.tessPageIteratorBoundingBox(
                          level, 
                          left.unsafeAddr,
                          top.unsafeAddr, 
                          right.unsafeAddr,
                          bottom.unsafeAddr)
  if not ok:
    raise newException(ValueError, "failed getting the Bounding Box")      
  return (left.int,top.int,right.int,bottom.int)


proc getOrientation*(self:ptr TessPageIterator):tuple[pageOrientation:TessOrientation; 
                                                      writtingDirection:TessWritingDirection;
                                                      order:TessTextlineOrder;
                                                      deskewAngle:float] =
                                                      
  var orientation:TessOrientation
  var direction:TessWritingDirection
  var order:TessTextlineOrder
  var deskewAngle:cfloat
  self.tessPageIteratorOrientation(orientation.unsafeAddr, 
                                   direction.unsafeAddr, 
                                   order.unsafeAddr, 
                                   deskewAngle.unsafeAddr)
  return (orientation,direction,order, deskewAngle.float )




##[ 
# Result Iterator

It is use to iterate over the text recognition results.
- Proporciona acceso a información como el texto reconocido, las coordenadas de la caja delimitadora y las confidencias de reconocimiento.
- Puedes usarlo para extraer palabras, líneas o bloques de texto de una imagen procesada por Tesseract.

]##

# type
#   ResultIteratorObj* = object
#     handle: ptr TessResultIterator

# proc `=destroy`*(self: ResultIteratorObj) =
#   #if not isNil(self):
#   tessResultIteratorDelete(self.handle)
#   #self.handle = nil


# proc getText*(self:ResultIteratorObj; level:TessPageIteratorLevel):string =
#   $self.handle.tessResultIteratorGetUTF8Text(level)

# proc getConfidence*(self:ResultIteratorObj; level:TessPageIteratorLevel):string =
#   $self.handle.tessResultIteratorConfidence(level)


# iterator resultIterator*(self:Tesseract; level:TessPageIteratorLevel): ResultIteratorObj =
#   var ri = ResultIteratorObj(handle: self.handle.tessBaseAPIGetIterator() )
#   #echo &"{ri.handle}"
#   #echo repr cast[pointer](ri.handle)#.unsafeAddr
#   var flag = true
#   while flag:
#     echo repr cast[pointer](ri.handle)
#     yield ri
#     flag = ri.handle.tessResultIteratorNext(level)

iterator resultIterator*(self:Tesseract; level:TessPageIteratorLevel): ptr TessResultIterator =
  var ri = self.handle.tessBaseAPIGetIterator() 
  #echo &"{ri.handle}"
  #echo repr cast[pointer](ri.handle)#.unsafeAddr
  var flag = true
  while flag:
    yield ri
    flag = ri.tessResultIteratorNext(level)
  tessResultIteratorDelete(ri)

proc getText*(self:ptr TessResultIterator; level:TessPageIteratorLevel):string =
  $self.tessResultIteratorGetUTF8Text(level)

proc getConfidence*(self:ptr TessResultIterator; level:TessPageIteratorLevel):string =
  $self.tessResultIteratorConfidence(level)


converter toPageIterator*(val:ptr TessResultIterator):ptr TessPageIterator =
  val.tessResultIteratorGetPageIterator()

#[
  var ri = api.handle.tessBaseAPIGetIterator()
  var pi = ri.tessResultIteratorGetPageIterator()
  var level = RIL_WORD
  var flag = true
  while flag:
    var word = ri.tessResultIteratorGetUTF8Text(level)
    var conf = ri.tessResultIteratorConfidence(level)
    var x1,y1,x2,y2:cint
    var tmp = pi.tessPageIteratorBoundingBox(level, x1.unsafeAddr,y1.unsafeAddr, x2.unsafeAddr,y2.unsafeAddr)

    echo "word: ", word
    echo "  conf: ", conf
    echo "  bb: ", x1, " ", y1, " ", x2, " ", y2
    flag =  pi.tessPageIteratorNext(level)
]#

##[
# Choice iterator 

El ChoiceIterator se utiliza para recorrer las alternativas de reconocimiento para una palabra específica.
Cuando Tesseract encuentra una palabra ambigua, como una palabra que puede ser interpretada de diferentes maneras, el ChoiceIterator permite acceder a todas las posibles opciones.
Esto es útil para aplicaciones como corrección ortográfica o selección de la mejor opción de reconocimiento.

]##
converter toChoiceIterator*(val:ptr TessResultIterator):ptr TessChoiceIterator =
  val.tessResultIteratorGetChoiceIterator()

iterator choiceIterator*(self:ptr TessChoiceIterator): ptr TessChoiceIterator =
  var flag = true
  while flag:
    #echo repr cast[pointer](ri)
    yield self
    flag = self.tessChoiceIteratorNext()
  tessChoiceIteratorDelete(self)


proc getText*(self:ptr TessChoiceIterator):string =
  $self.tessChoiceIteratorGetUTF8Text()

proc getConfidence*(self:ptr TessChoiceIterator):float =
  self.tessChoiceIteratorConfidence.float  

iterator choices*(self:ptr TessChoiceIterator):tuple[txt:string; confidence:float] =
  for ci in self.choiceIterator():
    var choice = ci.getText
    var conf = ci.getConfidence
    yield (choice,conf)  