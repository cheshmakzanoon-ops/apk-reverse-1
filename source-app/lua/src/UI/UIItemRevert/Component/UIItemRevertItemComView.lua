local UIItemRevertItemComView = BaseClass("UIItemRevertItemComView", UIBaseContainer)
local base = UIBaseContainer
local UIItemRevertItemComAuto = require("UI.UIItemRevert.Auto.UIItemRevertItemComAuto")
local UIItemRevertResItemComView = require("UI.UIItemRevert.Component.UIItemRevertResItemComView")

function UIItemRevertItemComView:OnCreate()
  base.OnCreate(self)
  self.itemList = {}
  self.binder = UIItemRevertItemComAuto.New()
  self.binder:bind(self)
  self.revertItemPrefab:GameObjectCreatePool()
  self.btn_lw_btn_common_new:SetOnClick(function()
    if not self:IsEnough() then
      UIUtil.ShowTipsId("undo_system_toast_failed_desc001")
      return
    end
    if self:IsActivity2Timeout() then
      UIUtil.ShowTipsId("undo_system_toast_failed_desc003")
      return
    end
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert)
    if v18HistoryView and v18HistoryView.View then
      local remainingCount = v18HistoryView.View:GetRemainingCount()
      if remainingCount <= 0 then
        UIUtil.ShowTipsId("undo_system_toast_failed_desc002")
        return
      end
      local chipRemainingCount = v18HistoryView.View:GetChipRemainingCount()
      if self.hasChip and chipRemainingCount <= 0 then
        UIUtil.ShowTipsId("undo_system_toast_failed_desc004")
        return
      end
      local cardRemainingCount = v18HistoryView.View:GetCardRemainingCount()
      if self.hasCard and cardRemainingCount <= 0 then
        UIUtil.ShowTipsId("undo_system2_toast2")
        return
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemRevertConfirm, {anim = true}, self.data)
  end)
  self.hasChip = false
  self.hasCard = false
  self.resetTimer = TimerManager:GetInstance():GetTimer(1.0, self.UpdateResetTime, self, false, false, false)
  self.resetTimer:Start()
end

function UIItemRevertItemComView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.rtrancontent:RemoveComponents(UIItemRevertResItemComView)
  self.rtrancontent = nil
  self.revertItemPrefab:GameObjectRecycleAll()
  self.revertItemPrefab = nil
  if self.resetTimer then
    self.resetTimer:Stop()
    self.resetTimer = nil
  end
  self.itemList = nil
  base.OnDestroy(self)
end

function UIItemRevertItemComView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
end

function UIItemRevertItemComView:OnRemoveListener()
  self:RemoveUIListener(EventId.ItemRevertTimeTypeSwitch, self.UpdateTimeTypeText)
  base.OnRemoveListener(self)
end

function UIItemRevertItemComView:UpdateData(data)
  if not data then
    return
  end
  self.data = data
  local lData = data.leftItem[1]
  if lData ~= ni then
    if lData.type > 0 then
      local param = {
        rewardType = lData.type,
        itemId = lData.id,
        count = lData.num
      }
      self.bind_uicommonresitem:ReInit(param)
    else
      local rewardType1 = ResTypeToReward[lData.id]
      if rewardType1 ~= nil then
        local param = {
          rewardType = rewardType1,
          itemId = lData.id,
          count = lData.num
        }
        self.bind_uicommonresitem:ReInit(param)
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
    local cell = self.rtrancontent:AddComponent(UIItemRevertResItemComView, item.name)
    cell:SetData(data.rightItem[i])
    self.itemList[i] = cell
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rtrancontent.rectTransform)
  self.hasChip = false
  for _, item in ipairs(data.rightItem) do
    if item.type == RewardType.TWSkillChip then
      self.hasChip = true
      break
    end
  end
  if self.hasChip then
    self.con_chip:SetActive(true)
    local maxCount = LuaEntry.DataConfig:TryGetNum("undo_system", "k7")
    local chipRemainingCount = 0
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert)
    if v18HistoryView and v18HistoryView.View then
      chipRemainingCount = v18HistoryView.View:GetChipRemainingCount()
    end
    self.text_chip:SetLocalText("undo_system_chip_count", " " .. chipRemainingCount .. "/" .. maxCount)
  else
    self.con_chip:SetActive(false)
  end
  self.hasCard = false
  for _, item in ipairs(data.rightItem) do
    if item.type == RewardType.TACTICAL_CARD then
      self.hasCard = true
      break
    end
  end
  if self.hasCard then
    self.con_card:SetActive(true)
    local cardMaxCount = LuaEntry.DataConfig:TryGetNum("undo_system", "k9")
    local cardRemainingCount = 0
    local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert)
    if v18HistoryView and v18HistoryView.View then
      cardRemainingCount = v18HistoryView.View:GetCardRemainingCount()
    end
    self.text_card:SetLocalText("undo_system2_card_count", " " .. cardRemainingCount .. "/" .. cardMaxCount)
  else
    self.con_card:SetActive(false)
  end
  self:UpdateTimeTypeText()
  self:UpdateResetTime()
end

function UIItemRevertItemComView:UpdateTimeTypeText()
  if self.data == nil then
    return
  end
  local isLocalTime = CS.GameEntry.Setting:GetPrivateBool("ItemRevertTimeType_LocalTime", false)
  if isLocalTime then
    local remainingTime2 = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.data.operateDoneTime)
    self.txt_textitemtime:SetText(remainingTime2)
  else
    local remainingTime1 = UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.operateDoneTime)
    self.txt_textitemtime:SetText(remainingTime1)
  end
end

function UIItemRevertItemComView:IsEnough()
  if not self.data or not self.itemList then
    return false
  end
  for _, item in ipairs(self.itemList) do
    if not item.isEnough then
      return false
    end
  end
  return true
end

function UIItemRevertItemComView:IsActivity2Timeout()
  if not self.data then
    return false
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  return self.data.type == 2 and nowTime >= self.data.activityCloseTime
end

function UIItemRevertItemComView:UpdateResetTime()
  local data = self.data
  if not data then
    return
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = data.operateEndTime
  if nowTime >= endTime then
    self.txt_textremaining:SetLocalText("undo_system_count_down_001", "00:00:00")
  else
    local remainingTime = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - nowTime)
    self.txt_textremaining:SetLocalText("undo_system_count_down_001", remainingTime)
  end
  if data.type == 2 then
    self.con_activity:SetActive(true)
    local remainingTime2 = UITimeManager:GetInstance():MilliSecondToFmtString(data.activityCloseTime - nowTime)
    self.txt_closetime:SetLocalText("undo_system_count_down_002", remainingTime2)
  else
    self.con_activity:SetActive(false)
  end
  if data.isCanFallBackShopNum == 0 then
    self.con_shop:SetActive(true)
    self.text_shopnum:SetLocalText("undo_system_remind_new2_limit_15")
  elseif data.isCanFallBackShopNum == 1 then
    self.con_shop:SetActive(true)
    self.text_shopnum:SetLocalText("undo_system_remind_new3_limit_15")
  else
    self.con_shop:SetActive(false)
  end
  if self:IsEnough() and not self:IsActivity2Timeout() then
    CS.UIGray.SetGray(self.btn_lw_btn_common_new.transform, false, true)
  else
    CS.UIGray.SetGray(self.btn_lw_btn_common_new.transform, true, true)
  end
end

function UIItemRevertItemComView:ClearContent()
  self.itemList = {}
  self.rtrancontent:RemoveComponents(UIItemRevertResItemComView)
  self.revertItemPrefab:GameObjectRecycleAll()
end

return UIItemRevertItemComView
