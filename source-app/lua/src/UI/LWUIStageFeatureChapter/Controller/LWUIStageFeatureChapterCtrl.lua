local LWUIStageFeatureChapterCtrl = BaseClass("LWUIStageFeatureChapterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIStageFeatureChapter)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentStageId(self)
  return DataCenter.LWStageFeatureChapterManager.curStageId
end

LWUIStageFeatureChapterCtrl.CloseSelf = CloseSelf
LWUIStageFeatureChapterCtrl.Close = Close
LWUIStageFeatureChapterCtrl.GetCurrentStageId = GetCurrentStageId
return LWUIStageFeatureChapterCtrl
