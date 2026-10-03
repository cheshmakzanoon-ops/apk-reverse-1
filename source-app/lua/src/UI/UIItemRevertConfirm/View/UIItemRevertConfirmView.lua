local UIItemRevertConfirmView = BaseClass("UIItemRevertConfirmView", UIBaseView)
local base = UIBaseView
local UIItemRevertConfirmAuto = require("UI.UIItemRevertConfirm.Auto.UIItemRevertConfirmAuto")
local Localization = CS.GameEntry.Localization

function UIItemRevertConfirmView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertConfirmAuto.New()
  self.binder:bind(self)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_LW_Btn_Close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_LW_Btn_Common_NewCancel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_LW_Btn_Common_NewConfirm:SetOnClick(function()
    if self.data then
      SFSNetwork.SendMessage(MsgDefines.ItemRevertConfirmRevert, self.data.id)
      self:ReqRefreshActivityCount(self.data)
    end
    self.ctrl:CloseSelf()
  end)
  self.revertItemPrefab:GameObjectCreatePool()
  self.data = self:GetUserData()
  if not self.data then
    Logger.Log(" UIItemRevertConfirmView:OnCreate() - No data found for item revert confirmation.")
    self.ctrl:CloseSelf()
    return
  end
  local v18HistoryView = UIManager:GetInstance():GetWindow(UIWindowNames.UIItemRevert)
  if v18HistoryView and v18HistoryView.View then
    local remainingCount = v18HistoryView.View:GetRemainingCount()
    self.txt_RemainingCount:SetLocalText("undo_system_confirmation_remaining", remainingCount)
  else
    self.txt_RemainingCount:SetLocalText("undo_system_confirmation_remaining", 0)
  end
  local maxChipNum = 0
  for _, item in ipairs(self.data.rightItem) do
    if item.type == RewardType.TWSkillChip and maxChipNum < item.num then
      maxChipNum = item.num
    end
  end
  local chipRemainingCount = 0
  if v18HistoryView and v18HistoryView.View then
    chipRemainingCount = v18HistoryView.View:GetChipRemainingCount()
  end
  local needConvert = false
  local ratio = 1
  if 0 < maxChipNum and maxChipNum > chipRemainingCount and 0 < chipRemainingCount then
    ratio = chipRemainingCount / maxChipNum
    needConvert = true
  end
  local maxCardNum = 0
  for _, item in ipairs(self.data.rightItem) do
    if item.type == RewardType.TACTICAL_CARD and maxCardNum < item.num then
      maxCardNum = item.num
    end
  end
  local cardRemainingCount = 0
  if v18HistoryView and v18HistoryView.View then
    cardRemainingCount = v18HistoryView.View:GetCardRemainingCount()
  end
  if 0 < maxCardNum and maxCardNum > cardRemainingCount and 0 < cardRemainingCount then
    local cardRatio = cardRemainingCount / maxCardNum
    if needConvert then
      ratio = math.min(ratio, cardRatio)
    else
      ratio = cardRatio
      needConvert = true
    end
  end
  local lData = self.data.leftItem[1]
  if lData ~= ni then
    if 0 < lData.type then
      local param = {
        rewardType = lData.type,
        itemId = lData.id,
        count = lData.num
      }
      if needConvert then
        param.count = math.floor(lData.num * ratio + 0.5)
      end
      self.bind_LeftUIItemRevertResItem:ReInit(param)
    else
      local rewardType1 = ResTypeToReward[lData.id]
      if rewardType1 ~= nil then
        local param = {
          rewardType = rewardType1,
          itemId = lData.id,
          count = lData.num
        }
        if needConvert then
          param.count = math.floor(lData.num * ratio + 0.5)
        end
        self.bind_LeftUIItemRevertResItem:ReInit(param)
      else
        Logger.LogError(" UIItemRevertItemComView:UpdateData - leftItem rewardType is nil for id: " .. tostring(lData.id))
      end
    end
  else
    Logger.LogError(" UIItemRevertItemComView:UpdateData - leftItem is nil or empty")
  end
  self:ClearContent()
  for i = 1, #self.data.rightItem do
    local item = self.revertItemPrefab:GameObjectSpawn(self.rTran_Content.transform)
    item.name = "revert_item_" .. i
    local cell = self.rTran_Content:AddComponent(UICommonResItem, item.name)
    local rData = self.data.rightItem[i]
    if 0 < rData.type then
      local param = {
        rewardType = rData.type,
        itemId = rData.id,
        count = rData.num
      }
      if needConvert then
        param.count = math.floor(rData.num * ratio + 0.5)
      end
      cell:ReInit(param)
    else
      local rewardType1 = ResTypeToReward[rData.id]
      if rewardType1 ~= nil then
        local param = {
          rewardType = rewardType1,
          itemId = rData.id,
          count = rData.num
        }
        if needConvert then
          param.count = math.floor(rData.num * ratio + 0.5)
        end
        cell:ReInit(param)
      else
        Logger.LogError(" UIItemRevertConfirmView:OnCreate - rightItem rewardType is nil for id: " .. tostring(rData.id))
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rTran_Content.rectTransform)
  if #self.data.rightItem < 1 then
    self.arrow_left1:SetActive(false)
    self.arrow_left2:SetActive(false)
    self.arrow_left3:SetActive(false)
  elseif #self.data.rightItem == 1 then
    self.arrow_left1:SetActive(true)
    self.arrow_left2:SetActive(false)
    self.arrow_left3:SetActive(false)
  elseif #self.data.rightItem == 2 then
    self.arrow_left1:SetActive(false)
    self.arrow_left2:SetActive(true)
    self.arrow_left3:SetActive(false)
  else
    self.arrow_left1:SetActive(false)
    self.arrow_left2:SetActive(false)
    self.arrow_left3:SetActive(true)
  end
  self.resetTimer = TimerManager:GetInstance():GetTimer(1.0, self.UpdateResetTime, self, false, false, false)
  self.resetTimer:Start()
  self:UpdateResetTime()
end

function UIItemRevertConfirmView:ClearContent()
  self.rTran_Content:RemoveComponents(UICommonResItem)
  self.revertItemPrefab:GameObjectRecycleAll()
end

function UIItemRevertConfirmView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.rTran_Content:RemoveComponents(UICommonResItem)
  self.rTran_Content = nil
  self.revertItemPrefab:GameObjectRecycleAll()
  self.revertItemPrefab = nil
  if self.resetTimer then
    self.resetTimer:Stop()
    self.resetTimer = nil
  end
  base.OnDestroy(self)
end

function UIItemRevertConfirmView:OnAddListener()
  base.OnAddListener(self)
end

function UIItemRevertConfirmView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIItemRevertConfirmView:UpdateResetTime()
  local data = self.data
  if not data then
    return
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = data.operateEndTime
  if nowTime >= endTime then
    self.txt_RemainingTime:SetLocalText("undo_system_count_down_001", "00:00:00")
  else
    local remainingTime = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - nowTime)
    self.txt_RemainingTime:SetLocalText("undo_system_count_down_001", remainingTime)
  end
end

function UIItemRevertConfirmView:ReqRefreshActivityCount(data)
  if data.isCanFallBackShopNum == nil or data.isCanFallBackShopNum == 0 then
    return
  end
  if string.IsNullOrEmpty(data.fallbackType) then
    return
  end
  if data.fallbackType == 4 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    end
  elseif data.fallbackType == 5 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    end
  elseif data.fallbackType == 6 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    end
  elseif data.fallbackType == 7 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    end
  elseif data.fallbackType == 8 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.SeasonDesertShopExchangeRecord, toInt(data.activityId))
    end
  elseif data.fallbackType == 10 then
  elseif data.fallbackType == 11 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.BountyHunterGetShopInfo, tostring(data.activityId))
    end
  elseif data.fallbackType == 12 then
  elseif data.fallbackType == 14 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.RichManShopList, toInt(data.activityId))
    end
  elseif data.fallbackType == 15 then
  elseif data.fallbackType == 16 then
    if not string.IsNullOrEmpty(data.activityId) then
      SFSNetwork.SendMessage(MsgDefines.RecycleShopInfo, toInt(data.activityId))
    end
  elseif data.fallbackType == 17 and not string.IsNullOrEmpty(data.activityId) then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
  end
end

return UIItemRevertConfirmView
