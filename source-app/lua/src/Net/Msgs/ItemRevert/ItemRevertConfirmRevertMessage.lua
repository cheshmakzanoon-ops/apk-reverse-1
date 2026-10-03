local ItemRevertConfirmRevertMessage = BaseClass("ItemRevertConfirmRevertMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ItemRevertConfirmRevertMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("id", param)
end

function ItemRevertConfirmRevertMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert).View
    if v18HistoryView then
      v18HistoryView:LoadInitialHistory()
    end
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    if not table.IsNullOrEmpty(t.fallBackDeletes) then
      for _, v in pairs(t.fallBackDeletes) do
        DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
      end
    end
    if not table.IsNullOrEmpty(t.fallBackChanges) then
      DataCenter.CommonEquipDataManager:UpdateEquipInfos(t.fallBackChanges, true)
    end
    if not table.IsNullOrEmpty(t.fallBackDeletes) or not table.IsNullOrEmpty(t.fallBackChanges) then
      EventManager:GetInstance():Broadcast(EventId.PutoffCommonEquip)
    end
  end
end

return ItemRevertConfirmRevertMessage
