local PushNewRechargeMessage = BaseClass("PushNewRechargeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.CumulativeRechargeManager:PushNewRechargeHandle(t)
end

PushNewRechargeMessage.OnCreate = OnCreate
PushNewRechargeMessage.HandleMessage = HandleMessage
return PushNewRechargeMessage
