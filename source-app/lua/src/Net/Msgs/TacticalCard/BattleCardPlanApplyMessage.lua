local BattleCardPlanApplyMessage = BaseClass("BattleCardPlanApplyMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function BattleCardPlanApplyMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function BattleCardPlanApplyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
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

return BattleCardPlanApplyMessage
