local ActivityMakeFoodScoreRewardMessage = BaseClass("ActivityMakeFoodScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("score", param.score)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCookingData:GetScoreRewardHandle(t)
  end
end

ActivityMakeFoodScoreRewardMessage.OnCreate = OnCreate
ActivityMakeFoodScoreRewardMessage.HandleMessage = HandleMessage
return ActivityMakeFoodScoreRewardMessage
