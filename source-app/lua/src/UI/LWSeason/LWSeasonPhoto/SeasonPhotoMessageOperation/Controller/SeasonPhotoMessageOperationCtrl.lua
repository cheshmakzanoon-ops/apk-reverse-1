local SeasonPhotoMessageOperationCtrl = BaseClass("UILWMummyHistoryCtrl", UIBaseCtrl)
local chatOperationCtrl = require("UI.LWUIChatOperation.Controller.LWUIChatOperationCtrl")

function SeasonPhotoMessageOperationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoMessageOperation)
end

local function GetEmojis()
  return chatOperationCtrl.GetEmojis()
end

SeasonPhotoMessageOperationCtrl.GetEmojis = GetEmojis
return SeasonPhotoMessageOperationCtrl
