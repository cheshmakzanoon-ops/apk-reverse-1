local CallChallengeActBossMessage = BaseClass("CallChallengeActBossMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMonsterTowerData:CallBossHandle(t)
  end
end

CallChallengeActBossMessage.OnCreate = OnCreate
CallChallengeActBossMessage.HandleMessage = HandleMessage
return CallChallengeActBossMessage
