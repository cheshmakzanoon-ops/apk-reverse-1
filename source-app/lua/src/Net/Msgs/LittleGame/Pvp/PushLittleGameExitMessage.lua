local PushLittleGameExitMessage = BaseClass("PushLittleGameExitMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, speak, cost)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTips(Localization:GetString("season_s5_activity_1200045_desc55", t.username))
  end
end

PushLittleGameExitMessage.OnCreate = OnCreate
PushLittleGameExitMessage.HandleMessage = HandleMessage
return PushLittleGameExitMessage
