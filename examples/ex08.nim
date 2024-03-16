# https://tesseract-ocr.github.io/tessdoc/APIExample.html

#[
Example to get HOCR output with alternative symbol choices per character (LSTM)
This is similar to running tesseract from commandline with -c lstm_choice_mode=2 hocr.
]#

import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("trainingital.tif")
  api.setImage(image)

  # Set lstm_choice_mode to alternative symbol choices per character, bbox is at word level.
  api.setVariable("lstm_choice_mode", "2")

  # Get HOCR result
  var outText = api.getHOCRText(0)

  echo "HOCR alternative symbol choices  per character :\n", outText

main()