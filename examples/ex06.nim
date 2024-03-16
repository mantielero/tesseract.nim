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

  api.setVariable("save_blob_choices", "T")  # <--- Not working

  api.setRectangle(37, 228, 548, 31)
  api.recognize()

  var level = RIL_SYMBOL
  for ri in api.resultIterator(level):
    var symbol = ri.getText(level)
    var conf = ri.getConfidence(level)

    echo "Symbol: ", symbol, "  conf: ", conf
    var indent = false
    for (choice, conf) in ri.choices():
      if indent:
        echo "\t\t ", choice, " conf: ", conf
      else:
        echo "\t- ", choice, " conf: ", conf
      indent = true

main()
