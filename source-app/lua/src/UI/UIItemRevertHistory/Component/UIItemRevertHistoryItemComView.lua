local UIItemRevertHistoryItemComView = BaseClass("UIItemRevertHistoryItemComView", UIBaseContainer)
local base = UIBaseContainer
local UIItemRevertHistoryItemComAuto = require("UI.UIItemRevertHistory.Auto.UIItemRevertHistoryItemComAuto")

function UIItemRevertHistoryItemComView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertHistoryItemComAuto.New()
  self.binder:bind(self)
  self.revertItemPrefab:GameObjectCreatePool()
end

function UIItemRevertHistoryItemComView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.rtrancontent:RemoveComponents(UICommonResItem)
  self.rtrancontent = nil
  self.revertItemPrefab:GameObjectRecycleAll()
  self.revertItemPrefab = nil
  base.OnDestroy(self)
end

function UIItemRevertHistoryItemComView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
end

function UIItemRevertHistoryItemComView:OnRemoveListener()
  self:RemoveUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
  base.OnRemoveListener(self)
end

function UIItemRevertHistoryItemComView:UpdateData(data)
  if not data then
    return
  end
  self.data = data
  local lData = self.data.leftItem[1]
  if lData ~= ni then
    if lData.type > 0 then
      local param = {
        rewardType = lData.type,
        itemId = lData.id,
        count = lData.num
      }
      self.bind_UICommonResItem:ReInit(param)
    else
      local rewardType1 = ResTypeToReward[lData.id]
      if rewardType1 ~= nil then
        local param = {
          rewardType = rewardType1,
          itemId = lData.id,
          count = lData.num
        }
        self.bind_UICommonResItem:ReInit(param)
      else
        Logger.LogError(" UIItemRevertItemComView:UpdateData - leftItem rewardType is nil for id: " .. tostring(lData.id))
      end
    end
  else
    Logger.LogError(" UIItemRevertItemComView:UpdateData - leftItem is nil or empty")
  end
  self:ClearContent()
  for i = 1, #data.rightItem do
    local item = self.revertItemPrefab:GameObjectSpawn(self.rtrancontent.transform)
    item.name = "revert_item_" .. i
    local cell = self.rtrancontent:AddComponent(UICommonResItem, item.name)
    local rData = self.data.rightItem[i]
    if rData.type > 0 then
      local param = {
        rewardType = rData.type,
        itemId = rData.id,
        count = rData.num
      }
      cell:ReInit(param)
    else
      local rewardType1 = ResTypeToReward[rData.id]
      if rewardType1 ~= nil then
        local param = {
          rewardType = rewardType1,
          itemId = rData.id,
          count = rData.num
        }
        cell:ReInit(param)
      else
        Logger.LogError(" UIItemRevertConfirmView:OnCreate - rightItem rewardType is nil for id: " .. tostring(rData.id))
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rtrancontent.rectTransform)
  self:UpdateTimeTypeText()
end

function UIItemRevertHistoryItemComView:UpdateTimeTypeText()
  if self.data == nil then
    return
  end
  local isLocalTime = CS.GameEntry.Setting:GetPrivateBool("ItemRevertTimeType_LocalTime", false)
  if isLocalTime then
    local remainingTime2 = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.data.operateDoneTime)
    self.txt_TextRemaining:SetText(remainingTime2)
  else
    local remainingTime1 = UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.operateDoneTime)
    self.txt_TextRemaining:SetText(remainingTime1)
  end
end

function UIItemRevertHistoryItemComView:ClearContent()
  self.rtrancontent:RemoveComponents(UICommonResItem)
  self.revertItemPrefab:GameObjectRecycleAll()
end

return UIItemRevertHistoryItemComView
