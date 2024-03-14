# https://tesseract-ocr.github.io/tessdoc/APIExample.html
import tesseract
import leptonica


proc main =
  var api = newTesseract("eng")
  let image = pixRead("phototest.tif")
  api.setImage(image)
  var boxes:ptr Boxa = api.getComponentImages(RIL_TEXTLINE, true)
  #echo boxes[].n
  #var tmp = boxes.boxaGetCount
  for i in 0..<boxes[].n:
    var box = boxaGetBox(boxes, i, L_CLONE)
    var x,y,w,h:LInt32
    discard box.boxGetGeometry(x.unsafeAddr,y.unsafeAddr,w.unsafeAddr,h.unsafeAddr) 
    api.handle.tessBaseAPISetRectangle(x,y,w,h)
    var txt = api.getText()
    var confidence = api.handle.tessBaseAPIMeanTextConf()
    echo i, ": ", txt, "   confidence: ", confidence, " x:",x, " y:",y, " w:",w, " h:",h
    # boxDestroy(&box);

main()

