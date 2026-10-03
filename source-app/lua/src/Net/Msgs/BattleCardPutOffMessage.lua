local BattleCardPutOffMessage = BaseClass("BattleCardPutOffMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPutOffMessage:OnCreate(params)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("slots", params)
end

function BattleCardPutOffMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local redStateBeforeUpdate = TacticalCardUtil.IsExistAnySlotShowRedDot()
    DataCenter.TacticalCardDataManager:UpdateDataFromServerData(t, false)
    if t.userBattleCards then
      EventManager:GetInstance():Broadcast(EventId.TCCardUnEquipSuccess, t.userBattleCards)
      local redStateAfterUpdate = TacticalCardUtil.IsExistAnySlotShowRedDot()
      if redStateBeforeUpdate ~= redStateAfterUpdate then
        DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.LWMastery)
      end
    end
  end
end

return BattleCardPutOffMessage
