local ReceiveSevenDayActRewardMessage = BaseClass("ReceiveSevenDayActRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    DataCenter.ActSevenDayData:GetRewardState(t)
  end
end

ReceiveSevenDayActRewardMessage.OnCreate = OnCreate
ReceiveSevenDayActRewardMessage.HandleMessage = HandleMessage
return ReceiveSevenDayActRewardMessage
