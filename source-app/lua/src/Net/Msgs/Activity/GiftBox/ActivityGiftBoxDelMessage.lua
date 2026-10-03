local ActivityGiftBoxDelMessage = BaseClass("ActivityGiftBoxDelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActGiftBoxData:DelGiftBoxHandle(t)
  end
end

ActivityGiftBoxDelMessage.OnCreate = OnCreate
ActivityGiftBoxDelMessage.HandleMessage = HandleMessage
return ActivityGiftBoxDelMessage
