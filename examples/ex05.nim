# https://tesseract-ocr.github.io/tessdoc/APIExample.html

#[
Orientation and script detection (OSD) example

]#

import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("eurotext.tif")

  api.setPageSegMode(PSM_AUTO_OSD)

  api.setImage(image)
  api.recognize()

  var it = api.analyseLayout()

  var ri = api.handle.tessBaseAPIGetIterator()
  var pi = ri.tessResultIteratorGetPageIterator()
  var val = pi.getOrientation()
  echo "deskew angle: ", val.deskewAngle
  echo "page orientation: ", val.pageOrientation
  echo "writting direction: ", val.writtingDirection
  echo "order: ", val.order

main()
