# https://tesseract-ocr.github.io/tessdoc/APIExample.html
# NOT WORKING
#[
Example to get confidence for alternative symbol choices per character for LSTM

  std::vector<std::vector<std::pair<const char*, float>>>* choiceMap = nullptr;



]#


import tesseract
import leptonica

proc main =
  var api = newTesseract("eng")
  let image = pixRead("trainingital.tif")
  api.setImage(image)

  # Set lstm_choice_mode to alternative symbol choices per character, bbox is at word level.
  var ok = api.handle.tessBaseAPISetVariable("lstm_choice_mode", "2")
  var res = api.handle.tessBaseAPIRecognize(nil)

  var ri = api.handle.tessBaseAPIGetIterator()
  var pi = ri.tessResultIteratorGetPageIterator()

  var level = RIL_WORD

  # Get confidence level for alternative symbol choices. Code is based on
  # https://github.com/tesseract-ocr/tesseract/blob/a7a729f6c315e751764b72ea945da961638effc5/src/api/hocrrenderer.cpp#L325-L344

  var flag = true
  while flag:
    var word = ri.tessResultIteratorGetUTF8Text(level)
    var conf = ri.tessResultIteratorConfidence(level)
    var x1,y1,x2,y2:cint
    var tmp = pi.tessPAgeIteratorBoundingBox(level, x1.unsafeAddr,y1.unsafeAddr, x2.unsafeAddr,y2.unsafeAddr)

    var 
      tcnt = 1
      gcnt = 1
      wcnt = 0

    var choiceMap = ri.GetBestLSTMSymbolChoices()


    for i in choiceMap:

#[
      for (auto timestep : *choiceMap) {
        if (timestep.size() > 0) {
          for (auto & j : timestep) {
            conf = int(j.second * 100);
            word =  j.first;
            printf("%d  symbol: '%s';  \tconf: %.2f; BoundingBox: %d,%d,%d,%d;\n",
                        wcnt, word, conf, x1, y1, x2, y2);
           gcnt++;
          }
          tcnt++;
        }
      wcnt++;
      printf("\n");
      }
]#

    flag =  ri.tessResultIteratorNext(level)

main()