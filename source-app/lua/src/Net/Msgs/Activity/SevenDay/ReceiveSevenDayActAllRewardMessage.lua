local ReceiveSevenDayActAllRewardMessage = BaseClass("ReceiveSevenDayActAllRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    DataCenter.ActSevenDayData:GetAllRewardState(t)
  end
end

ReceiveSevenDayActAllRewardMessage.OnCreate = OnCreate
ReceiveSevenDayActAllRewardMessage.HandleMessage = HandleMessage
return ReceiveSevenDayActAllRewardMessage
