# https://tesseract-ocr.github.io/tessdoc/APIExample.html
import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("/home/jose/docs/scanned/salida.png")
  #api.setImage(image)
  var image270 = pixRotate90(image, -1)

  # image.rotate90()
  # image.rotate90()
  # image.rotate90()
  api.setImage(image270)
  api.setPPI(150)
  echo api.getText()

  #image.pixDestroy()
  #image270.pixDestroy()
main()


#[
#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>

int main()
{
    char *outText;

    tesseract::TessBaseAPI *api = new tesseract::TessBaseAPI();
    // Initialize tesseract-ocr with English, without specifying tessdata path
    if (api->Init(NULL, "eng")) {
        fprintf(stderr, "Could not initialize tesseract.\n");
        exit(1);
    }

    // Open input image with leptonica library
    Pix *image = pixRead("/usr/src/tesseract/testing/phototest.tif");
    api->SetImage(image);
    // Get OCR result
    outText = api->GetUTF8Text();
    printf("OCR output:\n%s", outText);

    // Destroy used object and release memory
    api->End();
    delete api;
    delete [] outText;
    pixDestroy(&image);

    return 0;
}
]#