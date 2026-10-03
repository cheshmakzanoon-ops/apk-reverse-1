local PushAllBattlePassTaskMessage = BaseClass("PushAllBattlePassTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBattlePassData:GetTaskRewardHandle(t)
  end
end

PushAllBattlePassTaskMessage.OnCreate = OnCreate
PushAllBattlePassTaskMessage.HandleMessage = HandleMessage
return PushAllBattlePassTaskMessage
