{.passL:"-ltesseract".}
{.passC:"-I/usr/include/tesseract/" .}

import tesseract/[capi,helper]
export capi, helper