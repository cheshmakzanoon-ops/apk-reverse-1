local WorldTriggerGetUserListMessage = BaseClass("WorldTriggerGetUserListMessage", SFSBaseMessage)
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
    DataCenter.MasteryManager:HandleLandmineList(t)
  end
end

WorldTriggerGetUserListMessage.OnCreate = OnCreate
WorldTriggerGetUserListMessage.HandleMessage = HandleMessage
return WorldTriggerGetUserListMessage
