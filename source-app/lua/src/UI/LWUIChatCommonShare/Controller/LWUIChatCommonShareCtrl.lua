local LWUIChatCommonShareCtrl = BaseClass("LWUIChatCommonShareCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  DataCenter.AllianceCongratulationDataManager:SetPopInfo(nil)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIChatCommonShare, {anim = true})
  DataCenter.AllianceCongratulationDataManager:PlayGuide()
end

LWUIChatCommonShareCtrl.CloseSelf = CloseSelf
return LWUIChatCommonShareCtrl
