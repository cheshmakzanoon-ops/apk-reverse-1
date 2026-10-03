local AllianceChallengeNewBuildToWorldUpdateMessage = BaseClass("AllianceChallengeNewBuildToWorldUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, configId, planTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
  self.sfsObj:PutLong("planTime", planTime)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

AllianceChallengeNewBuildToWorldUpdateMessage.OnCreate = OnCreate
AllianceChallengeNewBuildToWorldUpdateMessage.HandleMessage = HandleMessage
return AllianceChallengeNewBuildToWorldUpdateMessage
