import leptonica
##  SPDX-License-Identifier: Apache-2.0
##  File:        capi.h
##  Description: C-API TessBaseAPI
##
##  (C) Copyright 2012, Google Inc.
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  http://www.apache.org/licenses/LICENSE-2.0
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

# import
#   `export`

# when not defined(bool):
#   const
#     bool* = int
#     TRUE* = 1
#     FALSE* = 0

type
  TesseractError* = object of Exception    


type
  TessBaseAPI* {.importc:"struct TessBaseAPI", incompleteStruct.}  = object
  TessBaseAPIptr* = ptr TessBaseAPI
  #TessBaseAPIptr* = ptr TessBaseAPI
  Etext_Desc* {.importc:"struct ETEXT_DESC".} = object
  TessResultIterator* {.importc:"struct TessResultIterator".} = object
  TessPageIterator* {.importc:"struct TessPageIterator".} = object
  TessChoiceIterator* {.importc:"struct TessChoiceIterator".} = object

proc `$`*(self:TessResultIterator):string =
  "struct TessResultIterator"

{.push header: "capi.h".}
type
  TessOcrEngineMode* = enum
    OEM_TESSERACT_ONLY, OEM_LSTM_ONLY, OEM_TESSERACT_LSTM_COMBINED, OEM_DEFAULT
  TessPageSegMode* = enum
    PSM_OSD_ONLY, PSM_AUTO_OSD, PSM_AUTO_ONLY, PSM_AUTO, PSM_SINGLE_COLUMN,
    PSM_SINGLE_BLOCK_VERT_TEXT, PSM_SINGLE_BLOCK, PSM_SINGLE_LINE,
    PSM_SINGLE_WORD, PSM_CIRCLE_WORD, PSM_SINGLE_CHAR, PSM_SPARSE_TEXT,
    PSM_SPARSE_TEXT_OSD, PSM_RAW_LINE, PSM_COUNT
  TessPageIteratorLevel* = enum
    RIL_BLOCK, RIL_PARA, RIL_TEXTLINE, RIL_WORD, RIL_SYMBOL
  TessPolyBlockType* = enum
    PT_UNKNOWN, PT_FLOWING_TEXT, PT_HEADING_TEXT, PT_PULLOUT_TEXT, PT_EQUATION,
    PT_INLINE_EQUATION, PT_TABLE, PT_VERTICAL_TEXT, PT_CAPTION_TEXT,
    PT_FLOWING_IMAGE, PT_HEADING_IMAGE, PT_PULLOUT_IMAGE, PT_HORZ_LINE,
    PT_VERT_LINE, PT_NOISE, PT_COUNT
  TessOrientation* = enum
    ORIENTATION_PAGE_UP, ORIENTATION_PAGE_RIGHT, ORIENTATION_PAGE_DOWN,
    ORIENTATION_PAGE_LEFT
  TessParagraphJustification* = enum
    JUSTIFICATION_UNKNOWN, JUSTIFICATION_LEFT, JUSTIFICATION_CENTER,
    JUSTIFICATION_RIGHT
  TessWritingDirection* = enum
    WRITING_DIRECTION_LEFT_TO_RIGHT, WRITING_DIRECTION_RIGHT_TO_LEFT,
    WRITING_DIRECTION_TOP_TO_BOTTOM
  TessTextlineOrder* = enum
    TEXTLINE_ORDER_LEFT_TO_RIGHT, TEXTLINE_ORDER_RIGHT_TO_LEFT,
    TEXTLINE_ORDER_TOP_TO_BOTTOM
# type
#   TessCancelFunc* = proc (cancelThis: pointer; words: cint): bool
#   TessProgressFunc* = proc (ths: ptr Etext_Desc; left: cint; right: cint;
#                             top: cint; bottom: cint): bool

 

proc tessVersion*(): cstring {.importc: "TessVersion".}

#[
proc tessDeleteText*(text: cstring) {.importc: "TessDeleteText".}
proc tessDeleteTextArray*(arr: cstringArray) {.importc: "TessDeleteTextArray".}
proc tessDeleteIntArray*(arr: ptr cint) {.importc: "TessDeleteIntArray".}
]#

##  Renderer API
#[
proc tessTextRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessTextRendererCreate".}
proc tessHOcrRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessHOcrRendererCreate".}
proc tessHOcrRendererCreate2*(outputbase: cstring; fontInfo: bool): ptr TessResultRenderer {.
    importc: "TessHOcrRendererCreate2".}
proc tessAltoRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessAltoRendererCreate".}
proc tessTsvRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessTsvRendererCreate".}
proc tessPDFRendererCreate*(outputbase: cstring; datadir: cstring;
                            textonly: bool): ptr TessResultRenderer {.
    importc: "TessPDFRendererCreate".}
proc tessUnlvRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessUnlvRendererCreate".}
proc tessBoxTextRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessBoxTextRendererCreate".}
proc tessLSTMBoxRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessLSTMBoxRendererCreate".}
proc tessWordStrBoxRendererCreate*(outputbase: cstring): ptr TessResultRenderer {.
    importc: "TessWordStrBoxRendererCreate".}
proc tessDeleteResultRenderer*(renderer: ptr TessResultRenderer) {.
    importc: "TessDeleteResultRenderer".}
proc tessResultRendererInsert*(renderer: ptr TessResultRenderer;
                               next: ptr TessResultRenderer) {.
    importc: "TessResultRendererInsert".}
proc tessResultRendererNext*(renderer: ptr TessResultRenderer): ptr TessResultRenderer {.
    importc: "TessResultRendererNext".}
proc tessResultRendererBeginDocument*(renderer: ptr TessResultRenderer;
                                      title: cstring): bool {.
    importc: "TessResultRendererBeginDocument".}
proc tessResultRendererAddImage*(renderer: ptr TessResultRenderer;
                                 api: ptr TessBaseAPI): bool {.
    importc: "TessResultRendererAddImage".}
proc tessResultRendererEndDocument*(renderer: ptr TessResultRenderer): bool {.
    importc: "TessResultRendererEndDocument".}
proc tessResultRendererExtention*(renderer: ptr TessResultRenderer): cstring {.
    importc: "TessResultRendererExtention".}
proc tessResultRendererTitle*(renderer: ptr TessResultRenderer): cstring {.
    importc: "TessResultRendererTitle".}
proc tessResultRendererImageNum*(renderer: ptr TessResultRenderer): cint {.
    importc: "TessResultRendererImageNum".}
]#

##  Base API
proc tessBaseAPICreate*(): ptr TessBaseAPI {.importc: "TessBaseAPICreate".}

proc tessBaseAPIDelete*(handle: ptr TessBaseAPI) {.importc: "TessBaseAPIDelete".}


#[
proc tessBaseAPIGetOpenCLDevice*(handle: ptr TessBaseAPI; device: ptr pointer): csize_t {.
    importc: "TessBaseAPIGetOpenCLDevice".}


proc tessBaseAPISetInputName*(handle: ptr TessBaseAPI; name: cstring) {.
    importc: "TessBaseAPISetInputName".}
proc tessBaseAPIGetInputName*(handle: ptr TessBaseAPI): cstring {.
    importc: "TessBaseAPIGetInputName".}


proc tessBaseAPISetInputImage*(handle: ptr TessBaseAPI; pix: ptr Pix) {.
    importc: "TessBaseAPISetInputImage".}
proc tessBaseAPIGetInputImage*(handle: ptr TessBaseAPI): ptr Pix {.
    importc: "TessBaseAPIGetInputImage".}


proc tessBaseAPIGetSourceYResolution*(handle: ptr TessBaseAPI): cint {.
    importc: "TessBaseAPIGetSourceYResolution".}


proc tessBaseAPIGetDatapath*(handle: ptr TessBaseAPI): cstring {.
    importc: "TessBaseAPIGetDatapath".}
proc tessBaseAPISetOutputName*(handle: ptr TessBaseAPI; name: cstring) {.
    importc: "TessBaseAPISetOutputName".}
]#

proc tessBaseAPISetVariable*(handle: ptr TessBaseAPI; name: cstring;
                             value: cstring): bool {.
    importc: "TessBaseAPISetVariable".}

#[
proc tessBaseAPISetDebugVariable*(handle: ptr TessBaseAPI; name: cstring;
                                  value: cstring): bool {.
    importc: "TessBaseAPISetDebugVariable".}
proc tessBaseAPIGetIntVariable*(handle: ptr TessBaseAPI; name: cstring;
                                value: ptr cint): bool {.
    importc: "TessBaseAPIGetIntVariable".}
proc tessBaseAPIGetboolVariable*(handle: ptr TessBaseAPI; name: cstring;
                                 value: ptr bool): bool {.
    importc: "TessBaseAPIGetboolVariable".}
proc tessBaseAPIGetDoubleVariable*(handle: ptr TessBaseAPI; name: cstring;
                                   value: ptr cdouble): bool {.
    importc: "TessBaseAPIGetDoubleVariable".}
proc tessBaseAPIGetStringVariable*(handle: ptr TessBaseAPI; name: cstring): cstring {.
    importc: "TessBaseAPIGetStringVariable".}

proc tessBaseAPIPrintVariables*(handle: ptr TessBaseAPI; fp: ptr File) {.
    importc: "TessBaseAPIPrintVariables".}

proc tessBaseAPIPrintVariablesToFile*(handle: ptr TessBaseAPI; filename: cstring): bool {.
    importc: "TessBaseAPIPrintVariablesToFile".}
]#


proc tessBaseAPIInit1*(handle: ptr TessBaseAPI; datapath: cstring;
                       language: cstring; oem: TessOcrEngineMode;
                       configs: cstringArray; configsSize: cint): cint {.
    importc: "TessBaseAPIInit1".}

proc tessBaseAPIInit2*(handle: ptr TessBaseAPI; datapath: cstring;
                       language: cstring; oem: TessOcrEngineMode): cint {.
    importc: "TessBaseAPIInit2".}

proc tessBaseAPIInit3*(handle: ptr TessBaseAPI; datapath: cstring;
                       language: cstring): cint {.importc: "TessBaseAPIInit3".}

proc tessBaseAPIInit4*(handle: ptr TessBaseAPI; datapath: cstring;
                       language: cstring; mode: TessOcrEngineMode;
                       configs: cstringArray; configsSize: cint;
                       varsVec: cstringArray; varsValues: cstringArray;
                       varsVecSize: csize_t; setOnlyNonDebugParams: bool): cint {.
    importc: "TessBaseAPIInit4".}

proc tessBaseAPIInit5*(handle: ptr TessBaseAPI; data: cstring; dataSize: cint;
                       language: cstring; mode: TessOcrEngineMode;
                       configs: cstringArray; configsSize: cint;
                       varsVec: cstringArray; varsValues: cstringArray;
                       varsVecSize: csize_t; setOnlyNonDebugParams: bool): cint {.
    importc: "TessBaseAPIInit5".}



#[
proc tessBaseAPIGetInitLanguagesAsString*(handle: ptr TessBaseAPI): cstring {.
    importc: "TessBaseAPIGetInitLanguagesAsString".}
proc tessBaseAPIGetLoadedLanguagesAsVector*(handle: ptr TessBaseAPI): cstringArray {.
    importc: "TessBaseAPIGetLoadedLanguagesAsVector".}
proc tessBaseAPIGetAvailableLanguagesAsVector*(handle: ptr TessBaseAPI): cstringArray {.
    importc: "TessBaseAPIGetAvailableLanguagesAsVector".}
proc tessBaseAPIInitForAnalysePage*(handle: ptr TessBaseAPI) {.
    importc: "TessBaseAPIInitForAnalysePage".}
proc tessBaseAPIReadConfigFile*(handle: ptr TessBaseAPI; filename: cstring) {.
    importc: "TessBaseAPIReadConfigFile".}
proc tessBaseAPIReadDebugConfigFile*(handle: ptr TessBaseAPI; filename: cstring) {.
    importc: "TessBaseAPIReadDebugConfigFile".}
]#
proc tessBaseAPISetPageSegMode*(handle: ptr TessBaseAPI; mode: TessPageSegMode) {.
    importc: "TessBaseAPISetPageSegMode".}

proc tessBaseAPIGetPageSegMode*(handle: ptr TessBaseAPI): TessPageSegMode {.
    importc: "TessBaseAPIGetPageSegMode".}

#[
proc tessBaseAPIRect*(handle: ptr TessBaseAPI; imagedata: ptr cuchar;
                      bytesPerPixel: cint; bytesPerLine: cint; left: cint;
                      top: cint; width: cint; height: cint): cstring {.
    importc: "TessBaseAPIRect".}
proc tessBaseAPIClearAdaptiveClassifier*(handle: ptr TessBaseAPI) {.
    importc: "TessBaseAPIClearAdaptiveClassifier".}
]#
proc tessBaseAPISetImage*(handle: ptr TessBaseAPI; imagedata: ptr cuchar;
                          width: cint; height: cint; bytesPerPixel: cint;
                          bytesPerLine: cint) {.importc: "TessBaseAPISetImage".}

proc tessBaseAPISetImage2*(handle: ptr TessBaseAPI; pix: ptr Pix) {.
    importc: "TessBaseAPISetImage2".}

proc tessBaseAPISetSourceResolution*(handle: ptr TessBaseAPI; ppi: cint) {.
    importc: "TessBaseAPISetSourceResolution".}


proc tessBaseAPISetRectangle*(handle: ptr TessBaseAPI; left: cint; top: cint;
                              width: cint; height: cint) {.
    importc: "TessBaseAPISetRectangle".}
#[
proc tessBaseAPIGetThresholdedImage*(handle: ptr TessBaseAPI): ptr Pix {.
    importc: "TessBaseAPIGetThresholdedImage".}
proc tessBaseAPIGetRegions*(handle: ptr TessBaseAPI; pixa: ptr ptr Pixa): ptr Boxa {.
    importc: "TessBaseAPIGetRegions".}
proc tessBaseAPIGetTextlines*(handle: ptr TessBaseAPI; pixa: ptr ptr Pixa;
                              blockids: ptr ptr cint): ptr Boxa {.
    importc: "TessBaseAPIGetTextlines".}
proc tessBaseAPIGetTextlines1*(handle: ptr TessBaseAPI; rawImage: bool;
                               rawPadding: cint; pixa: ptr ptr Pixa;
                               blockids: ptr ptr cint; paraids: ptr ptr cint): ptr Boxa {.
    importc: "TessBaseAPIGetTextlines1".}
proc tessBaseAPIGetStrips*(handle: ptr TessBaseAPI; pixa: ptr ptr Pixa;
                           blockids: ptr ptr cint): ptr Boxa {.
    importc: "TessBaseAPIGetStrips".}
proc tessBaseAPIGetWords*(handle: ptr TessBaseAPI; pixa: ptr ptr Pixa): ptr Boxa {.
    importc: "TessBaseAPIGetWords".}
proc tessBaseAPIGetConnectedComponents*(handle: ptr TessBaseAPI;
                                        cc: ptr ptr Pixa): ptr Boxa {.
    importc: "TessBaseAPIGetConnectedComponents".}
]#

proc tessBaseAPIGetComponentImages*(handle: ptr TessBaseAPI;
                                    level: TessPageIteratorLevel;
                                    textOnly: bool; pixa: ptr ptr Pixa;
                                    blockids: ptr ptr cint): ptr Boxa {.
    importc: "TessBaseAPIGetComponentImages".}

#[
proc tessBaseAPIGetComponentImages1*(handle: ptr TessBaseAPI;
                                     level: TessPageIteratorLevel;
                                     textOnly: bool; rawImage: bool;
                                     rawPadding: cint; pixa: ptr ptr Pixa;
                                     blockids: ptr ptr cint;
                                     paraids: ptr ptr cint): ptr Boxa {.
    importc: "TessBaseAPIGetComponentImages1".}
proc tessBaseAPIGetThresholdedImageScaleFactor*(handle: ptr TessBaseAPI): cint {.
    importc: "TessBaseAPIGetThresholdedImageScaleFactor".}
]#
proc tessBaseAPIAnalyseLayout*(handle: ptr TessBaseAPI): ptr TessPageIterator {.
    importc: "TessBaseAPIAnalyseLayout".}

proc tessBaseAPIRecognize*(handle: ptr TessBaseAPI; monitor: ptr Etext_Desc): cint {.
    importc: "TessBaseAPIRecognize".}

#[
proc tessBaseAPIProcessPages*(handle: ptr TessBaseAPI; filename: cstring;
                              retryConfig: cstring; timeoutMillisec: cint;
                              renderer: ptr TessResultRenderer): bool {.
    importc: "TessBaseAPIProcessPages".}
proc tessBaseAPIProcessPage*(handle: ptr TessBaseAPI; pix: ptr Pix;
                             pageIndex: cint; filename: cstring;
                             retryConfig: cstring; timeoutMillisec: cint;
                             renderer: ptr TessResultRenderer): bool {.
    importc: "TessBaseAPIProcessPage".}
]#

proc tessBaseAPIGetIterator*(handle: ptr TessBaseAPI): ptr TessResultIterator {.
    importc: "TessBaseAPIGetIterator".}

#[
proc tessBaseAPIGetMutableIterator*(handle: ptr TessBaseAPI): ptr TessMutableIterator {.
    importc: "TessBaseAPIGetMutableIterator".}
    ]#
proc tessBaseAPIGetUTF8Text*(handle: ptr TessBaseAPI): cstring {.
    importc: "TessBaseAPIGetUTF8Text".}

proc tessBaseAPIGetHOCRText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetHOCRText".}

#[
proc tessBaseAPIGetAltoText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetAltoText".}
proc tessBaseAPIGetTsvText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetTsvText".}
proc tessBaseAPIGetBoxText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetBoxText".}
proc tessBaseAPIGetLSTMBoxText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetLSTMBoxText".}
proc tessBaseAPIGetWordStrBoxText*(handle: ptr TessBaseAPI; pageNumber: cint): cstring {.
    importc: "TessBaseAPIGetWordStrBoxText".}
proc tessBaseAPIGetUNLVText*(handle: ptr TessBaseAPI): cstring {.
    importc: "TessBaseAPIGetUNLVText".}
]#


proc tessBaseAPIMeanTextConf*(handle: ptr TessBaseAPI): cint {.
    importc: "TessBaseAPIMeanTextConf".}
#[
proc tessBaseAPIAllWordConfidences*(handle: ptr TessBaseAPI): ptr cint {.
    importc: "TessBaseAPIAllWordConfidences".}
when not defined(DISABLED_LEGACY_ENGINE):
  proc tessBaseAPIAdaptToWordStr*(handle: ptr TessBaseAPI;
                                  mode: TessPageSegMode; wordstr: cstring): bool {.
      importc: "TessBaseAPIAdaptToWordStr".}
proc tessBaseAPIClear*(handle: ptr TessBaseAPI) {.importc: "TessBaseAPIClear".}
]#
proc tessBaseAPIEnd*(handle: ptr TessBaseAPI) {.importc: "TessBaseAPIEnd".}

#[
proc tessBaseAPIIsValidWord*(handle: ptr TessBaseAPI; word: cstring): cint {.
    importc: "TessBaseAPIIsValidWord".}
proc tessBaseAPIGetTextDirection*(handle: ptr TessBaseAPI; outOffset: ptr cint;
                                  outSlope: ptr cfloat): bool {.
    importc: "TessBaseAPIGetTextDirection".}
proc tessBaseAPIGetUnichar*(handle: ptr TessBaseAPI; unicharId: cint): cstring {.
    importc: "TessBaseAPIGetUnichar".}
proc tessBaseAPIClearPersistentCache*(handle: ptr TessBaseAPI) {.
    importc: "TessBaseAPIClearPersistentCache".}
when not defined(DISABLED_LEGACY_ENGINE):
  ##  Call TessDeleteText(*best_script_name) to free memory allocated by this
  ##  function
  proc tessBaseAPIDetectOrientationScript*(handle: ptr TessBaseAPI;
      orientDeg: ptr cint; orientConf: ptr cfloat; scriptName: cstringArray;
      scriptConf: ptr cfloat): bool {.importc: "TessBaseAPIDetectOrientationScript".}
proc tessBaseAPISetMinOrientationMargin*(handle: ptr TessBaseAPI;
    margin: cdouble) {.importc: "TessBaseAPISetMinOrientationMargin".}
proc tessBaseAPINumDawgs*(handle: ptr TessBaseAPI): cint {.
    importc: "TessBaseAPINumDawgs".}
proc tessBaseAPIOem*(handle: ptr TessBaseAPI): TessOcrEngineMode {.
    importc: "TessBaseAPIOem".}
proc tessBaseGetBlockTextOrientations*(handle: ptr TessBaseAPI;
                                       blockOrientation: ptr ptr cint;
                                       verticalWriting: ptr ptr bool) {.
    importc: "TessBaseGetBlockTextOrientations".}
]#

##  Page iterator

proc tessPageIteratorDelete*(handle: ptr TessPageIterator) {.
    importc: "TessPageIteratorDelete".}

#[
proc tessPageIteratorCopy*(handle: ptr TessPageIterator): ptr TessPageIterator {.
    importc: "TessPageIteratorCopy".}
proc tessPageIteratorBegin*(handle: ptr TessPageIterator) {.
    importc: "TessPageIteratorBegin".}
]#
proc tessPageIteratorNext*(handle: ptr TessPageIterator;
                           level: TessPageIteratorLevel): bool {.
    importc: "TessPageIteratorNext".}

#[
proc tessPageIteratorIsAtBeginningOf*(handle: ptr TessPageIterator;
                                      level: TessPageIteratorLevel): bool {.
    importc: "TessPageIteratorIsAtBeginningOf".}
proc tessPageIteratorIsAtFinalElement*(handle: ptr TessPageIterator;
                                       level: TessPageIteratorLevel;
                                       element: TessPageIteratorLevel): bool {.
    importc: "TessPageIteratorIsAtFinalElement".}
]#
proc tessPageIteratorBoundingBox*(handle: ptr TessPageIterator;
                                  level: TessPageIteratorLevel; left: ptr cint;
                                  top: ptr cint; right: ptr cint;
                                  bottom: ptr cint): bool {.
    importc: "TessPageIteratorBoundingBox".}
#[
proc tessPageIteratorBlockType*(handle: ptr TessPageIterator): TessPolyBlockType {.
    importc: "TessPageIteratorBlockType".}
proc tessPageIteratorGetBinaryImage*(handle: ptr TessPageIterator;
                                     level: TessPageIteratorLevel): ptr Pix {.
    importc: "TessPageIteratorGetBinaryImage".}
proc tessPageIteratorGetImage*(handle: ptr TessPageIterator;
                               level: TessPageIteratorLevel; padding: cint;
                               originalImage: ptr Pix; left: ptr cint;
                               top: ptr cint): ptr Pix {.
    importc: "TessPageIteratorGetImage".}
proc tessPageIteratorBaseline*(handle: ptr TessPageIterator;
                               level: TessPageIteratorLevel; x1: ptr cint;
                               y1: ptr cint; x2: ptr cint; y2: ptr cint): bool {.
    importc: "TessPageIteratorBaseline".}
]#
proc tessPageIteratorOrientation*(handle: ptr TessPageIterator;
                                  orientation: ptr TessOrientation;
                                  writingDirection: ptr TessWritingDirection;
                                  textlineOrder: ptr TessTextlineOrder;
                                  deskewAngle: ptr cfloat) {.
    importc: "TessPageIteratorOrientation".}
#[
proc tessPageIteratorParagraphInfo*(handle: ptr TessPageIterator; justification: ptr TessParagraphJustification;
                                    isListItem: ptr bool; isCrown: ptr bool;
                                    firstLineIndent: ptr cint) {.
    importc: "TessPageIteratorParagraphInfo".}
]#

##  Result iterator

proc tessResultIteratorDelete*(handle: ptr TessResultIterator) {.
    importc: "TessResultIteratorDelete".}
#[
proc tessResultIteratorCopy*(handle: ptr TessResultIterator): ptr TessResultIterator {.
    importc: "TessResultIteratorCopy".}
]#
proc tessResultIteratorGetPageIterator*(handle: ptr TessResultIterator): ptr TessPageIterator {.
    importc: "TessResultIteratorGetPageIterator".}

#[
proc tessResultIteratorGetPageIteratorConst*(handle: ptr TessResultIterator): ptr TessPageIterator {.
    importc: "TessResultIteratorGetPageIteratorConst".}
]#
proc tessResultIteratorGetChoiceIterator*(handle: ptr TessResultIterator): ptr TessChoiceIterator {.
    importc: "TessResultIteratorGetChoiceIterator".}


proc tessResultIteratorNext*(handle: ptr TessResultIterator;
                             level: TessPageIteratorLevel): bool {.
    importc: "TessResultIteratorNext".}

proc tessResultIteratorGetUTF8Text*(handle: ptr TessResultIterator;
                                    level: TessPageIteratorLevel): cstring {.
    importc: "TessResultIteratorGetUTF8Text".}

proc tessResultIteratorConfidence*(handle: ptr TessResultIterator;
                                   level: TessPageIteratorLevel): cfloat {.
    importc: "TessResultIteratorConfidence".}

#[
proc tessResultIteratorWordRecognitionLanguage*(handle: ptr TessResultIterator): cstring {.
    importc: "TessResultIteratorWordRecognitionLanguage".}
proc tessResultIteratorWordFontAttributes*(handle: ptr TessResultIterator;
    isBold: ptr bool; isItalic: ptr bool; isUnderlined: ptr bool;
    isMonospace: ptr bool; isSerif: ptr bool; isSmallcaps: ptr bool;
    pointsize: ptr cint; fontId: ptr cint): cstring {.
    importc: "TessResultIteratorWordFontAttributes".}
proc tessResultIteratorWordIsFromDictionary*(handle: ptr TessResultIterator): bool {.
    importc: "TessResultIteratorWordIsFromDictionary".}
proc tessResultIteratorWordIsNumeric*(handle: ptr TessResultIterator): bool {.
    importc: "TessResultIteratorWordIsNumeric".}
proc tessResultIteratorSymbolIsSuperscript*(handle: ptr TessResultIterator): bool {.
    importc: "TessResultIteratorSymbolIsSuperscript".}
proc tessResultIteratorSymbolIsSubscript*(handle: ptr TessResultIterator): bool {.
    importc: "TessResultIteratorSymbolIsSubscript".}
proc tessResultIteratorSymbolIsDropcap*(handle: ptr TessResultIterator): bool {.
    importc: "TessResultIteratorSymbolIsDropcap".}

## Choice Iterator
proc tessChoiceIteratorDelete*(handle: ptr TessChoiceIterator) {.
    importc: "TessChoiceIteratorDelete".}
]#
proc tessChoiceIteratorNext*(handle: ptr TessChoiceIterator): bool {.
    importc: "TessChoiceIteratorNext".}

proc tessChoiceIteratorGetUTF8Text*(handle: ptr TessChoiceIterator): cstring {.
    importc: "TessChoiceIteratorGetUTF8Text".}


proc tessChoiceIteratorConfidence*(handle: ptr TessChoiceIterator): cfloat {.
    importc: "TessChoiceIteratorConfidence".}


##  Progress monitor
#[
proc tessMonitorCreate*(): ptr Etext_Desc {.importc: "TessMonitorCreate".}
proc tessMonitorDelete*(monitor: ptr Etext_Desc) {.importc: "TessMonitorDelete".}
proc tessMonitorSetCancelFunc*(monitor: ptr Etext_Desc;
                               cancelFunc: TessCancelFunc) {.
    importc: "TessMonitorSetCancelFunc".}
proc tessMonitorSetCancelThis*(monitor: ptr Etext_Desc; cancelThis: pointer) {.
    importc: "TessMonitorSetCancelThis".}
proc tessMonitorGetCancelThis*(monitor: ptr Etext_Desc): pointer {.
    importc: "TessMonitorGetCancelThis".}
proc tessMonitorSetProgressFunc*(monitor: ptr Etext_Desc;
                                 progressFunc: TessProgressFunc) {.
    importc: "TessMonitorSetProgressFunc".}
proc tessMonitorGetProgress*(monitor: ptr Etext_Desc): cint {.
    importc: "TessMonitorGetProgress".}
proc tessMonitorSetDeadlineMSecs*(monitor: ptr Etext_Desc; deadline: cint) {.
    importc: "TessMonitorSetDeadlineMSecs".}
]#

{.pop.}

