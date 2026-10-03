local LWSeasonVirusResearchLevelUpCtrl = BaseClass("LWSeasonVirusResearchLevelUpCtrl", UIBaseCtrl)

function LWSeasonVirusResearchLevelUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonVirusResearchLevelUp)
end

function LWSeasonVirusResearchLevelUpCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.SeasonResearchLevelUpEcs)
end

return LWSeasonVirusResearchLevelUpCtrl
