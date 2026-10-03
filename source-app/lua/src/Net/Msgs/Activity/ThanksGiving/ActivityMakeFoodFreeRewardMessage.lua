local ActivityMakeFoodFreeRewardMessage = BaseClass("ActivityMakeFoodFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCookingData:GetFreeRewardHandle(t)
  end
end

ActivityMakeFoodFreeRewardMessage.OnCreate = OnCreate
ActivityMakeFoodFreeRewardMessage.HandleMessage = HandleMessage
return ActivityMakeFoodFreeRewardMessage
