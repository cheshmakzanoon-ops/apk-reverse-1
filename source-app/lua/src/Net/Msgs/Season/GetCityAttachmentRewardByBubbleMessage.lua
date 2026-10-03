local GetCityAttachmentRewardByBubbleMessage = BaseClass("GetCityAttachmentRewardByBubbleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentRewardByBubbleMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function GetCityAttachmentRewardByBubbleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.uuid then
    local Player
    if CS.GameEntry.Data ~= nil then
      Player = CS.GameEntry.Data.Player
    end
    if Player ~= nil then
      Player:SetData(t.uuid .. "_record_cab", tostring(t.uuid))
    end
  end
  if t.count then
    local keyDay = "ClickCityAttachmentBubbleDay"
    local keyCount = "ClickCityAttachmentBubbleCount"
    local todayCount = toInt(t.count)
    local todayZeroTime = UITimeManager:GetInstance():TodayZero()
    Setting:SetPrivateInt(keyCount, todayCount)
    Setting:SetPrivateString(keyDay, tostring(todayZeroTime))
    DataCenter.SeasonFarmerManager:SyncBubbleData()
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.CityAttachmentOneRewardFinish, t)
end

return GetCityAttachmentRewardByBubbleMessage
