local ReceiveSevenDayV2ActAllRewardMessage = BaseClass("ReceiveSevenDayV2ActAllRewardMessage", SFSBaseMessage)
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
    DataCenter.ActSevenDayV2Data:GetAllRewardState(t)
  end
end

ReceiveSevenDayV2ActAllRewardMessage.OnCreate = OnCreate
ReceiveSevenDayV2ActAllRewardMessage.HandleMessage = HandleMessage
return ReceiveSevenDayV2ActAllRewardMessage
