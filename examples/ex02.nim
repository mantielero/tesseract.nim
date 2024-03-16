# https://tesseract-ocr.github.io/tessdoc/APIExample.html
import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")

  # Using leptonica
  let image = pixRead("/home/jose/docs/scanned/salida.png")
  var image270 = pixRotate90(image, -1)

  api.setImage(image270)
  api.setPPI(150)
  echo api.getText() # Get OCR

  #image.pixDestroy()
  #image270.pixDestroy()
main()
