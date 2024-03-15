# https://tesseract-ocr.github.io/tessdoc/APIExample.html
#[
Result iterator example
-----------------------

It is possible to get confidence value and BoundingBox per word from a ResultIterator:

]#
import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("phototest.tif")
  api.setImage(image)
  var res = api.handle.tessBaseAPIRecognize(nil)

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


main()

