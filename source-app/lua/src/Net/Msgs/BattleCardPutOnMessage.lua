local BattleCardPutOnMessage = BaseClass("BattleCardPutOnMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function BattleCardPutOnMessage:OnCreate(params, isOneKey)
  base.OnCreate(self)
  local equipCardList = SFSArray.New()
  table.walk(params, function(k, v)
    local obj = SFSObject.New()
    obj:PutLong("uuid", v.uuid)
    obj:PutInt("slot", v.slotId)
    equipCardList:AddSFSObject(obj)
  end)
  self.sfsObj:PutSFSArray("slot2Uuid", equipCardList)
  self.sfsObj:PutBool("isOneKey", isOneKey)
end

function BattleCardPutOnMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local redStateBeforeUpdate = TacticalCardUtil.IsExistAnySlotShowRedDot()
    DataCenter.TacticalCardDataManager:UpdateDataFromServerData(t, false)
    if t.userBattleCards then
      EventManager:GetInstance():Broadcast(EventId.TCCardEquipSuccess, t.userBattleCards)
      local redStateAfterUpdate = TacticalCardUtil.IsExistAnySlotShowRedDot()
      if redStateBeforeUpdate ~= redStateAfterUpdate then
        DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.LWMastery)
      end
      if t.isOneKey then
        UIUtil.ShowTips(Localization:GetString("battle_card_recommend_ok"))
      end
    end
  end
end

return BattleCardPutOnMessage
