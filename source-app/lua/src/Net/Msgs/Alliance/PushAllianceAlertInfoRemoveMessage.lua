local PushAllianceAlertInfoRemoveMessage = BaseClass("PushAllianceAlertInfoRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
  else
    local useCombineRefresh = LuaEntry.DataConfig:CheckSwitch("opt_push_alliance_alert")
    if not useCombineRefresh then
      DataCenter.AllianceAlertDataManager:RemoveAlertKey(t)
    else
      DataCenter.AllianceAlertDataManager:RemoveAlertInfo(t)
    end
  end
end

PushAllianceAlertInfoRemoveMessage.OnCreate = OnCreate
PushAllianceAlertInfoRemoveMessage.HandleMessage = HandleMessage
return PushAllianceAlertInfoRemoveMessage
