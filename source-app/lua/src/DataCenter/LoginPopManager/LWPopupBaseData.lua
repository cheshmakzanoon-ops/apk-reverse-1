local LWPopupBaseData = BaseClass("LWPopupBaseData")

function LWPopupBaseData:__init()
  self.popupType = 0
  self.clearType = {}
  self.priority = 0
  self.icon = ""
  self.popupParam = nil
end

function LWPopupBaseData:__delete()
  self.popupType = 0
  self.clearType = 0
  self.priority = 0
  self.icon = ""
  self.popupParam = nil
end

function LWPopupBaseData:InitData(type, popupParam, clearType, priority, icon)
  self.popupType = type
  self.clearType = clearType
  self.priority = priority
  self.icon = icon
  self.popupParam = popupParam
end

function LWPopupBaseData:CheckCanClear(clearType)
  for i, v in ipairs(self.clearType) do
    if v == clearType then
      return true
    end
  end
  return false
end

function LWPopupBaseData:MarkSuccessSeeData()
  if self.popupType == PopupNotificationType.SeasonSettleTime then
    UIUtil.GetMonthActiveCount("SeasonSettleTips", true)
  elseif self.popupType == PopupNotificationType.NineNationKingBattle then
    if self.popupParam and self.popupParam.fightEndTime then
      UIUtil.GetMonthActiveCount(string.format("%s_%s_%s", "9king_", self.popupParam.fightEndTime, LuaEntry.Player.uid), true)
    end
  elseif self.popupType == PopupNotificationType.DawnPopup then
    Setting:SetPrivateBool("NightOverDawnStartPopup", false)
  end
end

return LWPopupBaseData
