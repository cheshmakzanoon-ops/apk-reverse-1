local RichManDiceMessage = BaseClass("RichManDiceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, diceType, isAuto)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("diceType", diceType)
  self.sfsObj:PutInt("isAuto", isAuto)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.isAuto > 0 then
      if t.startGridReward ~= nil and 0 < #t.startGridReward then
        local activityId = t.activityId
        local reward = t.startGridReward
        DataCenter.ActMonopolyDataManager:OnAddDamageReward(activityId, reward)
      end
      if t.gridReward ~= nil and 0 < #t.gridReward then
        local activityId = t.activityId
        local reward = t.gridReward
        DataCenter.ActMonopolyDataManager:OnAddDamageReward(activityId, reward)
      end
      if t.gridRet.eventId then
        local eventId = tonumber(t.gridRet.eventId) or 0
        if 0 < eventId then
          local line = LocalController:instance():getLine(TableName.RichManEvent, eventId)
          if line and DataCenter.ActMonopolyDataManager:EventTypeIsToAutoEventSave(line.event) then
            EventManager:GetInstance():Broadcast(EventId.ActMonopolyAutoEventDataAdd, eventId)
          end
        end
      end
    else
      if t.startGridReward ~= nil and 0 < #t.startGridReward then
        local reward = t.startGridReward
        DataCenter.RewardManager:AddRewards(reward)
      end
      if t.gridReward ~= nil and 0 < #t.gridReward then
        local reward = t.gridReward
        DataCenter.RewardManager:AddRewards(reward)
      end
    end
    if t.remainGold then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    DataCenter.ActMonopolyDataManager:RefreshActDetailData(t)
    EventManager:GetInstance():Broadcast(EventId.GetActMonopolyDiceResultMsg, t)
    if t.storeDetail ~= nil then
      DataCenter.ActMonopolyDataManager:AddShopData(t)
      EventManager:GetInstance():Broadcast(EventId.GetActMonopolyShoUpdatepMsg)
    end
  end
end

RichManDiceMessage.OnCreate = OnCreate
RichManDiceMessage.HandleMessage = HandleMessage
return RichManDiceMessage
