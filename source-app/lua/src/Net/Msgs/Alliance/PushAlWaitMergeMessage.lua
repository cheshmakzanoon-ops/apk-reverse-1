local PushAlWaitMergeMessage = BaseClass("PushAlWaitMergeMessage", SFSBaseMessage)
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
  elseif t.waitMerge then
    DataCenter.AllianceBaseDataManager:UpdateAlWaitMergeStatus(t.waitMerge)
  end
end

PushAlWaitMergeMessage.OnCreate = OnCreate
PushAlWaitMergeMessage.HandleMessage = HandleMessage
return PushAlWaitMergeMessage
