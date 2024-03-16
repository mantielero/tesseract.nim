import tesseract
import pixie

proc main =
  echo tessVersion()
  var tesseract = newTesseract("eng")

  # Using pixie
  let image = readImage("/home/jose/docs/scanned/salida.png")
  image.rotate90()
  image.rotate90()
  image.rotate90()

  tesseract.setImage(image)
  tesseract.setPPI(150)
  echo tesseract.getText()

main()