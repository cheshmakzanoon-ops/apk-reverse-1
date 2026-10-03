local ClaimSeasonPassTaskRewardMessage = BaseClass("ClaimSeasonPassTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPassManager:OnRecvTaskRewardResp(t)
  end
end

ClaimSeasonPassTaskRewardMessage.OnCreate = OnCreate
ClaimSeasonPassTaskRewardMessage.HandleMessage = HandleMessage
return ClaimSeasonPassTaskRewardMessage
