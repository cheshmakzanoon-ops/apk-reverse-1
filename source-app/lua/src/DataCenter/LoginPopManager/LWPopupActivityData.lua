local base = require("DataCenter.LoginPopManager.LWPopupBaseData")
local LWPopupActivityData = BaseClass("LWPopupActivityData", base)

function LWPopupActivityData:__init()
  base.__init(self)
  self.activityCfg = nil
end

function LWPopupActivityData:__delete()
  self.activityCfg = nil
  base.__delete(self)
end

function LWPopupActivityData:InitData(type, popupParam, clearType, priority, icon, cfg)
  base.InitData(self, type, popupParam, clearType, priority, icon)
  self.activityCfg = cfg
end

function LWPopupActivityData:GetTitle()
  if self.activityCfg then
    return self.activityCfg.title
  end
  return ""
end

function LWPopupActivityData:GetDesc()
  if self.activityCfg then
    return self.activityCfg.desc
  end
  return ""
end

function LWPopupActivityData:MarkSuccessSeeData()
  if self.popupType == PopupActivityType.KingActivity then
    local count = toInt(Setting:GetPrivateInt(TodayNoSecondConfirmType.KingActivity, 0))
    Setting:SetPrivateInt(TodayNoSecondConfirmType.KingActivity, count + 1)
  elseif self.popupType == PopupActivityType.CrossKingActivity then
    UIUtil.GetWeekActiveCount("CrossKingBattlePopup", true)
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CrossKingActivity, false)
  elseif self.popupType == PopupActivityType.NewPeakArena then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.POP_NEWPEAKARENA_DIALOG, false)
  elseif self.popupType == PopupActivityType.NewGaleArena then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.POP_NEWGALEARENA_DIALOG, false)
  elseif self.popupType == PopupActivityType.ThreeVThreeArena then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    Setting:SetString(SettingKeys.LASTTIME_ARENA3V3_OPEN, tostring(curTime))
  elseif self.popupType == PopupActivityType.ChampionDuel then
    local now = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong(DataCenter.ChampionDuelManager:GetSignPrefsKey(), now)
  elseif self.popupType == PopupActivityType.ActDsbDuel then
    BattlefieldDsbDuelUtils.ActInfo:SetIsShownPopUp(true)
  end
end

return LWPopupActivityData
