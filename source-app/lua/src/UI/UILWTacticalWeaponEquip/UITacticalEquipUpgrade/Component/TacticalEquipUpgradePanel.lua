local TacticalEquipUpgradePanel = BaseClass("TacticalEquipUpgradePanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalEquipUpgradeLevelStageItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipUpgradeLevelStageItem")
local TacticalEquipAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipAttriItem")
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")
local PROGRESS_DEFAULT_FILL = 642
local GREEN_NUM_FORMAT = " <color=#68F37F>+%s</color> "

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  DataCenter.CommonEquipDataManager:ClearEquipResearchCacheFeed()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compProgressPreview = self:AddComponent(UIBaseContainer, "progressNode/progressPreview")
  self.compProgressReal = self:AddComponent(UIBaseContainer, "progressNode/progressReal")
  self.compProgressBottomLine = self:AddComponent(UIBaseContainer, "progressNode/progressBottomLine")
  self.textCurPercent = self:AddComponent(UITextMeshProUGUIEx, "progressNode/progressUpgradeDescNode/curPercent")
  self.compNextPercentNode = self:AddComponent(UIBaseContainer, "progressNode/progressUpgradeDescNode/nextPercentNode")
  self.textNextPercent = self:AddComponent(UITextMeshProUGUIEx, "progressNode/progressUpgradeDescNode/nextPercentNode/nextPercentNode/nextPercent")
  self.textNoneUpgradeTips = self:AddComponent(UITextMeshProUGUIEx, "noneUpgradeTips")
  self.textFillProgress = self:AddComponent(UITextMeshProUGUIEx, "otherEquipFillNode/fillProgressText")
  self.textUseExpPropsTip = self:AddComponent(UITextMeshProUGUIEx, "otherEquipFillNode/fillNode/useExpPropsTip")
  self.btnAddExpProps = self:AddComponent(UIButton, "otherEquipFillNode/fillNode/addExpPropsBtn")
  self.btnAddExpProps:SetOnClick(function()
    self:OnBtnAddExpPropsClick()
  end)
  self.compTacticalEquipAttributeNode = self:AddComponent(UIBaseContainer, "TacticalEquipAttributeNode")
  self.compContent = self:AddComponent(UIBaseContainer, "otherEquipFillNode/fillNode/propsListScroll/Viewport/Content")
  self.compProgressArrow = self:AddComponent(UIBaseContainer, "progressNode/progressReal/progressArrow")
  self.loopGridViewPropsListScroll = self:AddComponent(UILoopListView2, "otherEquipFillNode/fillNode/propsListScroll")
  self.btnDetail = self:AddComponent(UIButton, "progressNode/detailBtn")
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.loopGridViewPropsListScroll:InitListView(0, function(loopScroll, index, item)
    return self:OnGetItemByIndex(loopScroll, index)
  end)
  self:InitProgressStatus()
end

local function ComponentDestroy(self)
  self.compContent:RemoveComponents(TacticalEquipItem)
  self.compTacticalEquipAttributeNode:RemoveComponents(TacticalEquipAttriItem)
  self.compProgressBottomLine:RemoveComponents(TacticalEquipUpgradeLevelStageItem)
  self.loopGridViewPropsListScroll:ClearAllItems()
  self.compProgressPreview = nil
  self.compProgressReal = nil
  self.compProgressBottomLine = nil
  self.textCurPercent = nil
  self.compNextPercentNode = nil
  self.textNextPercent = nil
  self.textNoneUpgradeTips = nil
  self.textFillProgress = nil
  self.textUseExpPropsTip = nil
  self.btnAddExpProps = nil
  self.compTacticalEquipAttributeNode = nil
  self.compContent = nil
  self.compProgressArrow = nil
  self.loopGridViewPropsListScroll = nil
  self.btnDetail = nil
end

local function DataDefine(self)
  self.attributeItemReqs = {}
  self.attributeCellList = {}
  self.feedList = {}
end

local function DataDestroy(self)
  self.cacheResideExp = nil
  self.progressStageItemList = nil
  for i, v in ipairs(self.attributeItemReqs) do
    if v then
      self:GameObjectDestroy(v)
    end
  end
  self.attributeItemReqs = nil
  self.attributeCellList = nil
  self.feedList = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalEquipSaveFeed, self.OnSelectFeedSave)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnDataRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalEquipSaveFeed, self.OnSelectFeedSave)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnDataRefresh)
  base.OnRemoveListener(self)
end

function TacticalEquipUpgradePanel:InitProgressStatus()
  local childCount = self.compProgressBottomLine.transform.childCount
  self.progressStageItemList = {}
  for i = 0, childCount - 1 do
    local child = self.compProgressBottomLine.transform:GetChild(i)
    if child then
      local item = self.compProgressBottomLine:AddComponent(TacticalEquipUpgradeLevelStageItem, child.gameObject.name)
      item:SetData(i, childCount - 1, function(eventData)
        self:OnProgressLevelStageClick(i, childCount - 1, eventData)
      end)
      item:SetActive(true)
      table.insert(self.progressStageItemList, item)
    end
  end
end

function TacticalEquipUpgradePanel:SetData(equipData, slot, isFromShortcutKey)
  self.curEquipData = equipData
  self.slot = slot
  self:RefreshStatus()
  self:RefreshFeedList(isFromShortcutKey)
  self:RefreshStage()
  self:CheckFirstEnterSystemGuide()
end

function TacticalEquipUpgradePanel:RefreshStatus()
  if self.holder == nil then
    return
  end
  self.holder:SetShowBtn({
    TacticalEquipBtnStatus.Fill,
    TacticalEquipBtnStatus.Research
  })
end

function TacticalEquipUpgradePanel:RefreshStage()
  if self.curEquipData == nil then
    return
  end
  for i, v in ipairs(self.progressStageItemList) do
    if v then
      v:Refresh(self.curEquipData.upgradePercent)
    end
  end
end

function TacticalEquipUpgradePanel:OnSelectFeedSave()
  self.feedList = DataCenter.CommonEquipDataManager:GetEquipResearchCacheFeed() or {}
  self:RefreshFeedList()
end

function TacticalEquipUpgradePanel:OnDataRefresh()
  DataCenter.CommonEquipDataManager:ClearEquipResearchCacheFeed()
  self.feedList = {}
  self:RefreshFeedList()
end

function TacticalEquipUpgradePanel:RefreshFeedList(isFromShortcutKey)
  if isFromShortcutKey then
    DataCenter.CommonEquipDataManager:ClearEquipResearchCacheFeed()
    self.feedList = {}
  end
  self.loopGridViewPropsListScroll:SetListItemCount(#self.feedList, false, false)
  self.loopGridViewPropsListScroll:RefreshAllShownItem()
  local hasFeed = not table.IsNullOrEmpty(self.feedList)
  self.loopGridViewPropsListScroll:SetActive(hasFeed)
  self.textUseExpPropsTip:SetActive(not hasFeed)
  self:RefreshPercentAndAttributes(isFromShortcutKey)
end

function TacticalEquipUpgradePanel:RefreshPercentAndAttributes(isFromShortcutKey)
  if self.curEquipData == nil then
    return
  end
  if self.curEquipData:IsMax() then
    return
  end
  local addExp = DataCenter.CommonEquipDataManager:GetCacheEquipResearchFeedExp()
  self:RefreshAddExpDesc(addExp)
  local nextAttributes
  local curAttributes, curPercent = DataCenter.CommonEquipDataManager:GetAttributeAndTotalPercent(self.curEquipData, self:GetCurExp())
  self:RefreshExpFill(self.compProgressPreview.rectTransform, 0)
  self:RefreshExpFill(self.compProgressReal.rectTransform, curPercent)
  self.textCurPercent:SetLocalText("squad_equip_research_desc_2", math.floor(curPercent * 100))
  self.compNextPercentNode:SetActive(false)
  if self:IsShowPre() then
    local next, pre, exp = DataCenter.CommonEquipDataManager:GetAttributeAndTotalPercent(self.curEquipData, self:GetCurExp() + addExp)
    nextAttributes = next
    local prePercent = pre
    self.cacheResideExp = exp
    self:RefreshExpFill(self.compProgressPreview.rectTransform, prePercent)
    self.textNextPercent:SetText(string.format("%s%%", math.floor(prePercent * 100)))
    self.compNextPercentNode:SetActive(true)
  end
  for i = #self.attributeItemReqs, 1, -1 do
    local req = self.attributeItemReqs[i]
    if req and not req.isDone then
      self:GameObjectDestroy(req)
      table.remove(self.attributeItemReqs, i)
    end
  end
  local effectList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(curAttributes, nextAttributes)
  local countDelta = #effectList - #self.attributeCellList
  if 0 <= countDelta then
    if 0 < countDelta then
      for i = 1, countDelta do
        local index = #self.attributeCellList + i
        if self.attributeItemReqs[index] == nil then
          table.insert(self.attributeItemReqs, self:CreateAttributeItem(effectList[index], index))
        end
      end
    end
    for i, v in ipairs(self.attributeCellList) do
      if v and effectList[i] then
        effectList[i].index = i
        effectList[i].isFromShortcutKey = isFromShortcutKey
        v:SetData(effectList[i])
      end
    end
  else
    self.compTacticalEquipAttributeNode:RemoveComponents(TacticalEquipAttriItem)
    if self.attributeItemReqs then
      for i, v in pairs(self.attributeItemReqs) do
        if v then
          self:GameObjectDestroy(v)
        end
      end
    end
    self.attributeItemReqs = {}
    self.attributeCellList = {}
    for index, v in ipairs(effectList) do
      table.insert(self.attributeItemReqs, self:CreateAttributeItem(v, index))
    end
  end
end

function TacticalEquipUpgradePanel:RefreshAddExpDesc(addExp)
  if 0 < addExp then
    local addExpStr = string.format(GREEN_NUM_FORMAT, addExp)
    self.textFillProgress:SetLocalText("squad_equip_research_desc_4", self:GetCurExp(), addExpStr, self:GetUpgradeNeedExp())
  else
    self.textFillProgress:SetLocalText("squad_equip_research_desc_4", self:GetCurExp(), "", self:GetUpgradeNeedExp())
  end
end

function TacticalEquipUpgradePanel:IsShowPre()
  local curPercentRecord = math.floor(self.curEquipData.upgradePercent * 100)
  local prePercentRecord = math.floor(self:GetPreExp() / self:GetUpgradeNeedExp() * 100)
  return curPercentRecord < prePercentRecord
end

function TacticalEquipUpgradePanel:GetCurExp()
  return self.curEquipData.exp
end

function TacticalEquipUpgradePanel:GetPreExp()
  local addExp = DataCenter.CommonEquipDataManager:GetCacheEquipResearchFeedExp()
  local preExp = addExp + self:GetCurExp()
  return preExp
end

function TacticalEquipUpgradePanel:GetUpgradeNeedExp()
  return self.curEquipData.config.upgrade_value
end

function TacticalEquipUpgradePanel:GetSelectFeedCache()
  local costList = {}
  local feed = DataCenter.CommonEquipDataManager:GetEquipResearchCacheFeed()
  if feed and 0 < #feed then
    for i, v in ipairs(feed) do
      if v then
        local costItem = {}
        costItem.uuid = v.equip.uuid
        costItem.num = v.useNum
        table.insert(costList, costItem)
      end
    end
  end
  return costList
end

function TacticalEquipUpgradePanel:RefreshExpFill(rectTrans, percent)
  percent = math.min(percent, 1)
  if percent < 0 then
    percent = 0
  end
  local sizeDelta = rectTrans.sizeDelta
  sizeDelta.x = PROGRESS_DEFAULT_FILL * percent
  rectTrans.sizeDelta = sizeDelta
  self.compProgressArrow:SetAnchoredPositionXY(percent * PROGRESS_DEFAULT_FILL, 0)
  return sizeDelta.x
end

function TacticalEquipUpgradePanel:CreateAttributeItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalEquipAttriItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compTacticalEquipAttributeNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    local name = "attribute_" .. tostring(index)
    go.name = name
    local cell = self.compTacticalEquipAttributeNode:AddComponent(TacticalEquipAttriItem, name)
    data.index = index
    cell:SetData(data)
    self.attributeCellList[index] = cell
  end)
end

function TacticalEquipUpgradePanel:OnGetItemByIndex(loopScroll, index)
  if not table.IsNullOrEmpty(self.feedList) then
    local count = #self.feedList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalEquipItem")
    local script = self.compContent:GetComponent(item.gameObject.name, TacticalEquipItem)
    if script == nil then
      NameCount = NameCount + 1
      local name = "feed_" .. NameCount
      item.gameObject.name = name
      script = self.compContent:AddComponent(TacticalEquipItem, name)
    end
    local data = self.feedList[index].equip
    script:SetLocalScaleXYZ(0.6, 0.6, 0.6)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      script:SetAnchorMinXY(1, 1)
      script:SetAnchorMaxXY(1, 1)
      script:SetPivotXY(1, 1)
    end
    script:SetData(data, self.slot)
    script:SetShowNum(self.feedList[index].useNum)
    script:SetBtnActive(false)
    script:SetActive(true)
    return item
  end
end

function TacticalEquipUpgradePanel:OnProgressLevelStageClick(index, total, eventData)
  local param = {}
  param.equipData = self.curEquipData
  param.width = 480
  param.screenPos = eventData.position
  param.percentValue = math.floor(index / total * 100 + 0.5)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipResearchStageTips, {anim = true}, param)
end

function TacticalEquipUpgradePanel:AutoFill()
  self.feedList = DataCenter.CommonEquipDataManager:QuickFillEquipResearchCacheFeed(self.slot) or {}
  self:RefreshFeedList()
  return not table.IsNullOrEmpty(self.feedList)
end

function TacticalEquipUpgradePanel:GetCacheResideExp()
  return self.cacheResideExp
end

local function OnBtnAddExpPropsClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipChooseFeed, {anim = true}, self.curEquipData, self.slot)
end

function TacticalEquipUpgradePanel:OnBtnDetailClick()
  UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString("squad_equip_info_1"))
end

function TacticalEquipUpgradePanel:CheckFirstEnterSystemGuide()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(5014) then
    DataCenter.LWGuideFlowManager.Runner:Run(5014)
  end
end

TacticalEquipUpgradePanel.OnCreate = OnCreate
TacticalEquipUpgradePanel.OnDestroy = OnDestroy
TacticalEquipUpgradePanel.OnEnable = OnEnable
TacticalEquipUpgradePanel.OnDisable = OnDisable
TacticalEquipUpgradePanel.ComponentDefine = ComponentDefine
TacticalEquipUpgradePanel.ComponentDestroy = ComponentDestroy
TacticalEquipUpgradePanel.DataDefine = DataDefine
TacticalEquipUpgradePanel.DataDestroy = DataDestroy
TacticalEquipUpgradePanel.OnAddListener = OnAddListener
TacticalEquipUpgradePanel.OnRemoveListener = OnRemoveListener
TacticalEquipUpgradePanel.OnBtnAddExpPropsClick = OnBtnAddExpPropsClick
return TacticalEquipUpgradePanel
