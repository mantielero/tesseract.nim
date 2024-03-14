# https://tesseract-ocr.github.io/tessdoc/APIExample.html

#[
Example to get HOCR output with alternative symbol choices per character (LSTM)
This is similar to running tesseract from commandline with -c lstm_choice_mode=2 hocr.

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
    Pix *image = pixRead("/tesseract/test/testing/trainingital.tif");
    api->SetImage(image);
    api->SetVariable("lstm_choice_mode", "2");
// Get HOCR result
    outText = api->GetHOCRText(0);
    printf("HOCR alternative symbol choices  per character :\n%s", outText);

// Destroy used object and release memory
    api->End();
    delete api;
    delete [] outText;
    pixDestroy(&image);

    return 0;
}
]#