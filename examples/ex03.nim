# https://tesseract-ocr.github.io/tessdoc/APIExample.html
import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("phototest.tif")
  api.setImage(image)

  var i = 0
  for box in api.textLines:
    var rect = box.getGeometry()
    api.setRectangle(rect)
    var txt = api.getText()
    var confidence = api.getConfidence()
    echo i, ": ", txt, "   confidence: ", confidence, " rect:", rect
    i += 1


main()
