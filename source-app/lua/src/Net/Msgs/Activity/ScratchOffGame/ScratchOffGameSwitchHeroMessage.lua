local ScratchOffGameSwitchHeroMessage = BaseClass("ScratchOffGameSwitchHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, chooseIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tostring(activityId))
  self.sfsObj:PutInt("chooseIndex", tostring(chooseIndex))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ScratchOffGameManager:OnRecvSwitchHeroRes(t)
  end
end

ScratchOffGameSwitchHeroMessage.OnCreate = OnCreate
ScratchOffGameSwitchHeroMessage.HandleMessage = HandleMessage
return ScratchOffGameSwitchHeroMessage
