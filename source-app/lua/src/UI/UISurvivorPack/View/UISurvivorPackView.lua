local UISurvivorPackView = BaseClass("UISurvivorPackView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISurvivorPackListItem = require("UI.UISurvivorPack.Component.UISurvivorPackListItem")
local UISurvivorPackRewardItem = require("UI.UISurvivorPack.Component.UISurvivorPackRewardItem")

function UISurvivorPackView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  self:RefreshView()
end

function UISurvivorPackView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurvivorPackView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textRewardProgressTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.scrollRectSurvivorList = self.viewSkin:AddComponent(self, UIScrollRect, 6)
  self.loopGridViewSurvivorList = self.viewSkin:AddComponent(self, UILoopGridView, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.compScoreContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.loopListView2StagesScroll = self.viewSkin:AddComponent(self, UILoopListView2, 11)
  self.imgBackground = self.viewSkin:AddComponent(self, UIImage, 12)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 13)
  self.loopGridViewSurvivorList:InitGridView(0, function(loopScroll, index)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  if self.loopListView2StagesScroll then
    self.loopListView2StagesScroll:InitListView(0, function(loopView, index)
      return self:OnGetStageItemByIndex(loopView, index)
    end)
  end
end

function UISurvivorPackView:ComponentDestroy()
  if self.compContent then
    self.compContent:RemoveComponents(UISurvivorPackListItem)
  end
  if self.compScoreContent then
    self.compScoreContent:RemoveComponents(UISurvivorPackRewardItem)
  end
  if self.loopGridViewSurvivorList then
    self.loopGridViewSurvivorList:ClearAllItems()
  end
  if self.loopListView2StagesScroll then
    self.loopListView2StagesScroll:ClearAllItems()
  end
  self._rewardItemGos = nil
  self.viewSkin = nil
  self.btnInfo = nil
  self.textTitle = nil
  self.textRemainTime = nil
  self.textDes = nil
  self.textRewardProgressTxt = nil
  self.scrollRectSurvivorList = nil
  self.loopGridViewSurvivorList = nil
  self.compContent = nil
  self.imgIcon = nil
  self.compScoreContent = nil
  self.loopListView2StagesScroll = nil
  self.imgBackground = nil
  self.slider = nil
end

function UISurvivorPackView:DataDefine()
  self.showSurvivorArr = {}
  self._rewardItemGos = nil
  self._rewardStageCellWidth = nil
  self.survivorItemNameSeq = 0
  self._hasInitStageFocus = false
end

function UISurvivorPackView:DataDestroy()
  self.showSurvivorArr = nil
  self._rewardStageCellWidth = nil
  self.survivorItemNameSeq = nil
  self._hasInitStageFocus = nil
end

function UISurvivorPackView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurvivorPackInfoMsg, self.RefreshView)
end

function UISurvivorPackView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurvivorPackInfoMsg, self.RefreshView)
  base.OnRemoveListener(self)
end

function UISurvivorPackView:InitView()
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  if actData ~= nil then
    if self.textTitle ~= nil and not string.IsNullOrEmpty(actData.name) then
      self.textTitle:SetText(Localization:GetString(actData.name))
    end
    if self.textDes ~= nil and not string.IsNullOrEmpty(actData.desc_info) then
      self.textDes:SetText(Localization:GetString(actData.desc_info))
    end
  end
  local scoreItemId = DataCenter.SurvivorPackManager.score_item
  if not string.IsNullOrEmpty(scoreItemId) then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(scoreItemId)
    if goods ~= nil and not string.IsNullOrEmpty(goods.icon) then
      local iconPath = string.format(LoadPath.ItemPath, goods.icon)
      if self.imgIcon ~= nil and iconPath ~= nil and iconPath ~= "" then
        self.imgIcon:LoadSpriteAsync(iconPath)
      end
    end
  end
  self:RefreshRemainTime()
end

function UISurvivorPackView:RefreshRemainTime()
  if self.textRemainTime == nil then
    return
  end
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local endTime = actData and tonumber(actData.endTime) or nil
  if endTime == nil or endTime <= 0 then
    self.textRemainTime:SetText("")
    return
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local leftMs = endTime - nowTime
  if leftMs <= 0 then
    self.textRemainTime:SetText("00:00:00")
    return
  end
  self.textRemainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftMs))
end

function UISurvivorPackView:Update1000MS()
  self:RefreshRemainTime()
end

function UISurvivorPackView:RefreshRewardStageBackgroundWidth(totalCount)
  if self.imgBackground == nil or totalCount == nil or totalCount <= 0 then
    return
  end
  local cellW = self._rewardStageCellWidth
  if self.loopListView2StagesScroll ~= nil then
    local item0 = self.loopListView2StagesScroll:GetShownItemByItemIndex(0)
    if item0 ~= nil then
      local w = item0.ItemSizeWithPadding
      if w == nil or w <= 0 then
        local pad = item0.Padding or 0
        local rt = item0.CachedRectTransform
        if rt ~= nil then
          w = rt.rect.width + pad
        end
      end
      if w ~= nil and 0 < w then
        cellW = w
        self._rewardStageCellWidth = w
      end
    end
  end
  if cellW ~= nil and 0 < cellW then
    local bgWidth = math.max(0, cellW * (totalCount - 0.5))
    self.imgBackground:SetSizeDeltaX(bgWidth)
  end
end

function UISurvivorPackView:CalcStageProgressByScore(score, barReward)
  local totalCount = barReward and #barReward or 0
  if totalCount <= 0 then
    return 0, 1
  end
  local maxProgress = math.max(0.5, totalCount - 0.5)
  local curScore = math.max(0, tonumber(score) or 0)
  local prevScore = 0
  for i = 1, totalCount do
    local stageScore = tonumber(barReward[i].score) or prevScore
    if curScore <= stageScore then
      local seg = math.max(1, stageScore - prevScore)
      local ratio = math.min(1, math.max(0, (curScore - prevScore) / seg))
      if i == 1 then
        return 0.5 * ratio, maxProgress
      end
      return i - 1 - 0.5 + ratio, maxProgress
    end
    prevScore = stageScore
  end
  return maxProgress, maxProgress
end

function UISurvivorPackView:GetFirstUnreceivedScoreStageIndex0()
  local barReward = DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.bar_reward
  if barReward == nil or #barReward == 0 then
    return 0
  end
  local receiveScoreArr = DataCenter.SurvivorPackManager.receiveScoreArr
  
  local function isScoreRewardReceived(idx0)
    if receiveScoreArr == nil then
      return false
    end
    local idx = tonumber(idx0)
    if idx == nil then
      return false
    end
    for _, v in ipairs(receiveScoreArr) do
      if tonumber(v) == idx then
        return true
      end
    end
    return false
  end
  
  for i = 1, #barReward do
    local idx0 = i - 1
    if not isScoreRewardReceived(idx0) then
      return idx0
    end
  end
  return math.max(0, #barReward - 1)
end

function UISurvivorPackView:RefreshView()
  self.showSurvivorArr = DataCenter.SurvivorPackManager:GetShowSurvivorList()
  local scoreItemId = DataCenter.SurvivorPackManager.score_item
  local itemCount = 0
  if not string.IsNullOrEmpty(scoreItemId) then
    local itemInfo = DataCenter.ItemData:GetItemById(scoreItemId)
    if itemInfo ~= nil and itemInfo.count ~= nil then
      itemCount = tonumber(itemInfo.count) or 0
    end
  end
  local lastScore = 0
  local barReward = DataCenter.SurvivorPackManager.bar_reward
  if barReward ~= nil and 0 < #barReward then
    local last = barReward[#barReward]
    lastScore = tonumber(last.score) or 0
  end
  if self.textRewardProgressTxt ~= nil then
    self.textRewardProgressTxt:SetText(string.format("%d/%d", itemCount, lastScore))
  end
  if self.slider ~= nil then
    local stageProgress, stageMax = self:CalcStageProgressByScore(itemCount, barReward)
    self.slider:SetMin(0)
    self.slider:SetMax(stageMax)
    self.slider:SetValueWithoutNotify(stageProgress)
  end
  if self.imgBackground ~= nil then
    self.imgBackground:SetActive(barReward ~= nil and 0 < #barReward)
  end
  if self.loopGridViewSurvivorList then
    self.loopGridViewSurvivorList:SetListItemCount(#self.showSurvivorArr, false)
    self.loopGridViewSurvivorList:RefreshAllShownItem()
  end
  local totalCount = barReward and #barReward or 0
  if self.loopListView2StagesScroll then
    self.loopListView2StagesScroll:SetListItemCount(totalCount, false, false)
    self.loopListView2StagesScroll:RefreshAllShownItem()
  end
  self:RefreshRewardStageBackgroundWidth(totalCount)
  if self.loopListView2StagesScroll and 0 < totalCount and not self._hasInitStageFocus then
    local focusIdx = self:GetFirstUnreceivedScoreStageIndex0()
    self.loopListView2StagesScroll:MovePanelToItemIndex(focusIdx, 0)
    self._hasInitStageFocus = true
  end
end

function UISurvivorPackView:OnGetStageItemByIndex(loopView, index)
  local barReward = DataCenter.SurvivorPackManager.bar_reward
  if barReward == nil then
    return nil
  end
  local count = #barReward
  if index < 0 or index >= count then
    return nil
  end
  local data = barReward[index + 1]
  local item = loopView:NewListViewItem("UISurvivorPackRewardItem")
  local compName = item.gameObject.name
  local script = self.compScoreContent:GetComponent(compName, UISurvivorPackRewardItem)
  if script == nil then
    local name = "item_" .. UIUtil.GetLoopListItemIndex()
    item.gameObject.name = name
    script = self.compScoreContent:AddComponent(UISurvivorPackRewardItem, name)
  end
  script:SetActive(true)
  script:SetData(data, index)
  item.gameObject.transform:Set_localPosition(0, 0, 0)
  return item
end

function UISurvivorPackView:OnGetItemByRowColumn(loopScroll, index)
  local arr = self.showSurvivorArr
  if arr == nil then
    return nil
  end
  local count = #arr
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local survivorListId = arr[index]
  local item = loopScroll:NewListViewItem("UISurvivorPackListItem")
  local compName = item.gameObject.name
  local script = self.compContent:GetComponent(compName, UISurvivorPackListItem)
  if script == nil then
    local name = "item_" .. UIUtil.GetLoopListItemIndex()
    item.gameObject.name = name
    script = self.compContent:AddComponent(UISurvivorPackListItem, name)
  end
  script:SetActive(true)
  script:SetData(survivorListId)
  return item
end

function UISurvivorPackView:OnBtnInfoClick()
  if self.btnInfo == nil then
    return
  end
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData
  local descKey = actData and actData.story or ""
  if string.IsNullOrEmpty(descKey) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = Localization:GetString(descKey)
  param.alignObject = self.btnInfo.transform
  param.width = 400
  param.yPosFix = 11
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UISurvivorPackView
