local PushAllianceAlertInfoCreateMessage = BaseClass("PushAllianceAlertInfoCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
  else
    if not LuaEntry.Player:IsInAlliance() then
      return
    end
    local info = t.info
    local useCombineRefresh = LuaEntry.DataConfig:CheckSwitch("opt_push_alliance_alert")
    if not useCombineRefresh then
      if info then
        DataCenter.AllianceAlertDataManager:UpdateAllianceAlertList(info)
      end
      EventManager:GetInstance():BroadcastDeferred(EventId.UpdateAlertData)
    elseif info then
      DataCenter.AllianceAlertDataManager:AddAlertInfo(info)
    end
  end
end

PushAllianceAlertInfoCreateMessage.OnCreate = OnCreate
PushAllianceAlertInfoCreateMessage.HandleMessage = HandleMessage
return PushAllianceAlertInfoCreateMessage
