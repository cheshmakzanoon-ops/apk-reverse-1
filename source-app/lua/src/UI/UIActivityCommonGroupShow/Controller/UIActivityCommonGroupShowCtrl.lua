local UIActivityCenterTableCtrl = require("UI.UIActivityCenterTable.Controller.UIActivityCenterTableCtrl")
local UIActivityCommonGroupShowCtrl = BaseClass("UIActivityCommonGroupShowCtrl", UIActivityCenterTableCtrl)
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActivityCommonGroupShow)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

function UIActivityCommonGroupShowCtrl:SetDownloadingPageId(pageId)
  self.downloadingPageId = pageId
end

function UIActivityCommonGroupShowCtrl:GetDownloadingPageId()
  return self.downloadingPageId
end

UIActivityCommonGroupShowCtrl.CloseSelf = CloseSelf
UIActivityCommonGroupShowCtrl.Close = Close
return UIActivityCommonGroupShowCtrl
