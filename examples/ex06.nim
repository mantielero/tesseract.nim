# https://tesseract-ocr.github.io/tessdoc/APIExample.html

#[
Example of iterator over the classifier choices for a single symbol


]#


import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("phototest.tif")
  api.setImage(image)

  var ok = api.handle.tessBaseAPISetVariable("save_blob_choices", "T")
  api.handle.tessBaseAPISetRectangle(37, 228, 548, 31)
  var res = api.handle.tessBaseAPIRecognize(nil)

  var ri = api.handle.tessBaseAPIGetIterator()
  var pi = ri.tessResultIteratorGetPageIterator()

  var level = RIL_SYMBOL

  var flag = true
  while flag:
    var symbol = ri.tessResultIteratorGetUTF8Text(level)
    var conf = ri.tessResultIteratorConfidence(level)
    if symbol != nil:
      echo "Symbol: ", symbol, "  conf: ", conf
      var indent = false
      var ci = tessResultIteratorGetChoiceIterator(ri)
      while ci.tessChoiceIteratorNext():
        if indent:
          echo "\t\t "
          echo "\t- "
          var choice = ci.tessChoiceIteratorGetUTF8Text
          echo choice, " conf: ", ci.tessChoiceIteratorConfidence
          indent = true

    flag =  pi.tessPageIteratorNext(level)

main()