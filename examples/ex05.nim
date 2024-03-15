# https://tesseract-ocr.github.io/tessdoc/APIExample.html

#[
Orientation and script detection (OSD) example

]#

import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("eurotext.tif")

  api.handle.tessBaseAPISetPageSegMode(PSM_AUTO_OSD)
  echo api.handle.tessBaseAPIGetPageSegMode
  api.setImage(image)
  var res = api.handle.tessBaseAPIRecognize(nil)

  var it = api.handle.tessBaseAPIAnalyseLayout()

  var orientation:TessOrientation
  var direction:TessWritingDirection
  var order:TessTextlineOrder
  var deskewAngle:cfloat

  var ri = api.handle.tessBaseAPIGetIterator()
  var pi = ri.tessResultIteratorGetPageIterator()
  pi.tessPageIteratorOrientation(orientation.unsafeAddr, direction.unsafeAddr, order.unsafeAddr, deskewAngle.unsafeAddr)

  echo "deskew angle: ", deskewAngle
  echo "page orientation: ", orientation
  echo "writting direction: ", direction
  echo "order: ", order

main()