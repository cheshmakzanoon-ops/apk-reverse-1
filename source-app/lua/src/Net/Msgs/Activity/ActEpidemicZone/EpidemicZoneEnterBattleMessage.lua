local EpidemicZoneEnterBattleMessage = BaseClass("EpidemicZoneEnterBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneEnterBattleMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneEnterBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "YiBianJinQu_battle_tips_5" then
      local cdTime = DataCenter.ActEpidemicZoneManager:GetLeaveCDLeft()
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, cdTime))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  DataCenter.ActEpidemicZoneManager:OnHandleEnterBattleMessage(t, false)
end

return EpidemicZoneEnterBattleMessage
