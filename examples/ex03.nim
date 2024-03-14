# https://tesseract-ocr.github.io/tessdoc/APIExample.html
import tesseract
import leptonica


proc main =
  var api = newTesseract("eng")
  let image = pixRead("phototest.tif")
  api.setImage(image)
  var boxes:ptr Boxa = api.getComponentImages(RIL_TEXTLINE, true)
  #var tmp = boxes.getN #echo boxes[].n.int
  var tmp = boxes.boxaGetCount
  for i in 0..<tmp:
    var box = boxaGetBox(boxes, i, L_CLONE)
    var x,y,w,h:LInt32
    discard box.boxGetGeometry(x.unsafeAddr,y.unsafeAddr,w.unsafeAddr,h.unsafeAddr) 
    api.handle.tessBaseAPISetRectangle(x,y,w,h)
    var txt = api.getText()
    var confidence = api.handle.tessBaseAPIMeanTextConf()
    echo i, ": ", txt, "   confidence: ", confidence, " x:",x, " y:",y, " w:",w, " h:",h


main()


#[
    fprintf(stdout, "Box[%d]: x=%d, y=%d, w=%d, h=%d, confidence: %d, text: %s",
                    i, box->x, box->y, box->w, box->h, conf, ocrResult);
    boxDestroy(&box);

]#