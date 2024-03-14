import capi
import pixie, leptonica

type
  TesserAct* = object
    handle*: ptr TessBaseAPI #= tessBaseAPICreate() #TessBaseAPIptr

proc `=destroy`*(self: TesserAct) =
  #if not isNil(self):
  tessBaseAPIDelete(self.handle)
  #self.handle = nil

proc newTesseract*(language:string = "eng"; dataPath:string = ""): TesserAct =
  result = TesserAct(handle: tessBaseAPICreate())
  
  var status = result.handle.tessBaseAPIInit3(datapath, language)
  if status == -1:
    raise newException(TesseractError, "Couldn't initialize tesseract")  




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