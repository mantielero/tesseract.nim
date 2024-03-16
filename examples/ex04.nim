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
  api.recognize()

  var level = RIL_WORD
  for ri in api.resultIterator(level):
    var word = ri.getText(level)
    var conf = ri.getConfidence(level)
    var bb   = ri.getBoundingBox(level)

    echo "word: ", word
    echo "  conf: ", conf
    echo "  bb: ", bb 

main()
