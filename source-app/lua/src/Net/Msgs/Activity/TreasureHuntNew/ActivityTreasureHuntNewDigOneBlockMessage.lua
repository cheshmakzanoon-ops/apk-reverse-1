local ActivityTreasureHuntNewDigOneBlockMessage = BaseClass("ActivityTreasureHuntNewDigOneBlockMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, digIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("digIndex", digIndex)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTreasureHuntNewManager:OnRecvDigResult(t)
  end
  DataCenter.ActivityTreasureHuntNewManager:ResetIsDigOneBlock()
end

ActivityTreasureHuntNewDigOneBlockMessage.OnCreate = OnCreate
ActivityTreasureHuntNewDigOneBlockMessage.HandleMessage = HandleMessage
return ActivityTreasureHuntNewDigOneBlockMessage
