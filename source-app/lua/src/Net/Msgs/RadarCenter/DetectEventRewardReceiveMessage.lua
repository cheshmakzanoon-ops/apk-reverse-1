local DetectEventRewardReceiveMessage = BaseClass("DetectEventRewardReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    EventManager:GetInstance():Broadcast(EventId.DetectEventRewardGet, t.uuid)
    DataCenter.RadarCenterDataManager:GetDetectEventRewardBack(t)
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  if t.firstKill == true then
    for _, v in ipairs(t.reward) do
      if v.type == RewardType.HERO then
        local heroUuid = v.value.uuid
        if DataCenter.HeroDataManager:NeedShowNewHeroWindow(heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
        end
        break
      end
    end
  end
end

DetectEventRewardReceiveMessage.OnCreate = OnCreate
DetectEventRewardReceiveMessage.HandleMessage = HandleMessage
return DetectEventRewardReceiveMessage
