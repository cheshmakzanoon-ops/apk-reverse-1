local ActivityMakeFoodCookingMessage = BaseClass("ActivityMakeFoodCookingMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.activityId)
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("num", param.num)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCookingData:GetCookingRewardHandle(t)
  end
end

ActivityMakeFoodCookingMessage.OnCreate = OnCreate
ActivityMakeFoodCookingMessage.HandleMessage = HandleMessage
return ActivityMakeFoodCookingMessage
