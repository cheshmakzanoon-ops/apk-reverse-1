local UIActivityCenterTableCtrl = require("UI.UIActivityCenterTable.Controller.UIActivityCenterTableCtrl")
local UIFestivalActivityCommonGroupShowCtrl = BaseClass("UIFestivalActivityCommonGroupShowCtrl", UIActivityCenterTableCtrl)
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFestivalActivityCommonGroupShow)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

function UIFestivalActivityCommonGroupShowCtrl:SetDownloadingPageId(pageId)
  self.downloadingPageId = pageId
end

function UIFestivalActivityCommonGroupShowCtrl:GetDownloadingPageId()
  return self.downloadingPageId
end

UIFestivalActivityCommonGroupShowCtrl.CloseSelf = CloseSelf
UIFestivalActivityCommonGroupShowCtrl.Close = Close
return UIFestivalActivityCommonGroupShowCtrl
