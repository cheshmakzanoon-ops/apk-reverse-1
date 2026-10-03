local GiftBoxReceiveMessage = BaseClass("GiftBoxReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActGiftBoxData:ReceiveGiftBoxScoreHandle(t)
  end
end

GiftBoxReceiveMessage.OnCreate = OnCreate
GiftBoxReceiveMessage.HandleMessage = HandleMessage
return GiftBoxReceiveMessage
