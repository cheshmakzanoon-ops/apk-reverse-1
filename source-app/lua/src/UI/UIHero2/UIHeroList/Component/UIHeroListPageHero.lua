local UIHeroListPageHero = BaseClass("UIHeroListPageHero", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIHeroInfoView = require("UI.UIHero2.UIHeroInfo.View.UIHeroInfoView")
local Localization = CS.GameEntry.Localization
local UIHeroListTitleLine = require("UI.UIHero2.UIHeroList.Component.UIHeroListTitleLine")
local UIHeroListRow = require("UI.UIHero2.UIHeroList.Component.UIHeroListRow")
local ArrowTypeHero = {HeroUid = 1, LvUpHero = 2}
local ColMax = 6
local itemNameSequence = 1

local function GetItemNameSequence(self)
  itemNameSequence = itemNameSequence + 1
  if 99999999 < itemNameSequence then
    itemNameSequence = 1
  end
  return tostring(itemNameSequence)
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.inited = false
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.nodeEmptyTip = self:AddComponent(UIBaseContainer, "NodeEmptyTip")
  self.textTipEmpty = self:AddComponent(UIText, "NodeEmptyTip/TextTipEmpty")
  self.content = self:AddComponent(UIBaseContainer, "LoopScroll/Viewport/Content")
  self.loopScroll = self:AddComponent(UILoopListView2, "LoopScroll")
  self.loopScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.textTipEmpty:SetLocalText(300540)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local dt = self.showDataList[index]
  if type(dt) == "number" then
    local item = loopScroll:NewListViewItem("TitleLine")
    local script = self.content:GetComponent(item.gameObject.name, UIHeroListTitleLine)
    if script == nil then
      local objectName = self:GetItemNameSequence()
      item.gameObject.name = objectName
      if not item.IsInitHandlerCalled then
        item.IsInitHandlerCalled = true
      end
      script = self.content:AddComponent(UIHeroListTitleLine, objectName)
    end
    script:SetActive(true)
    script:SetData(dt)
    return item
  end
  local item = loopScroll:NewListViewItem("HeroRow")
  local script = self.content:GetComponent(item.gameObject.name, UIHeroListRow)
  if script == nil then
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(UIHeroListRow, objectName)
  end
  script:SetActive(true)
  script:SetData(dt, BindCallback(self, self.OnCellClick))
  self.cells[index] = script
  return item
end

local function ShowCells(self, keepPos)
  self.showDataList, self.pureDataList = self.view.ctrl:GenerateHeroDataList(self.selectCamp, ColMax)
  local rowCount = table.count(self.showDataList)
  self.nodeEmptyTip:SetActive(rowCount == 0)
  self.loopScroll:SetListItemCount(rowCount, false, false)
  self.loopScroll:RefreshAllShownItem()
  if keepPos then
  end
  local isArrow = self.view.ctrl:GetArrow()
  if isArrow and isArrow == ArrowTypeHero.LvUpHero then
    self:ShowArrow()
  end
end

local function ComponentDestroy(self)
  self.bodeEmptyTip = nil
  self.textTipEmpty = nil
  self.tabCamps = nil
end

local function DataDefine(self)
  self.selectCamp = -1
  self.curSelectCell = 0
  self.cells = {}
end

local function DataDestroy(self)
  self.selectCamp = nil
  self.curSelectCell = nil
  self.cells = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.inited then
    self:ShowCells(self.inited)
  end
  self.inited = true
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroAdvanceSuccess, self.OnHeroDataChanged)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataChanged)
  self:AddUIListener(EventId.SkillUpgradeEnd, self.OnHeroSkillLvUp)
  self:AddUIListener(EventId.HeroMedalExchanged, self.OnHeroSkillLvUp)
  self:AddUIListener(EventId.HeroExChange, self.OnHeroDataChanged)
  self:AddUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  self:AddUIListener(EventId.OnRemoveNewHeroFlag, self.OnHeroDataChanged)
  self:AddUIListener(EventId.UIScrollToSomeWhere, self.MoveToHero)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIScrollToSomeWhere, self.MoveToHero)
  self:RemoveUIListener(EventId.HeroExChange, self.OnHeroDataChanged)
  self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.OnHeroDataChanged)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataChanged)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, self.OnHeroSkillLvUp)
  self:RemoveUIListener(EventId.HeroMedalExchanged, self.OnHeroSkillLvUp)
  self:RemoveUIListener(EventId.OnRemoveNewHeroFlag, self.OnHeroDataChanged)
  self:RemoveUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  base.OnRemoveListener(self)
end

local function OnSwitchCamp(self, camp)
  self.selectCamp = camp
  local active = self:GetActive()
  if not active then
    return
  end
  self:ShowCells()
end

local function ClearScroll(self)
  self.content:RemoveComponents(UIHeroListRow)
  self.content:RemoveComponents(UIHeroListTitleLine)
  self.loopScroll:ClearAllItems()
end

local function OnCellClick(self, trans, heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData == nil then
    local item = DataCenter.ItemData:GetItemById(heroUuid)
    if item ~= nil then
      local itemCount = item.count
      local itemNeed = HeroUtils.GetJigsawCost(heroUuid)
      if itemCount >= itemNeed then
        SFSNetwork.SendMessage(MsgDefines.HeroExchange, heroUuid, 1)
        return
      end
    end
    local itemConfig = DataCenter.ItemTemplateManager:GetItemTemplate(heroUuid)
    if itemConfig ~= nil and itemConfig.type == GOODS_TYPE.GOODS_TYPE_99 then
      local camp = GetTableData(HeroUtils.GetHeroXmlName(), toInt(itemConfig.para2), "camp")
      local rarity = GetTableData(HeroUtils.GetHeroXmlName(), toInt(itemConfig.para2), "rarity")
      local quality = HeroUtils.GetMaxStarLevel(toInt(itemConfig.para2))
      local fromType = UIHeroInfoView.FromType.HeroMap
      local heroMapData = {
        heroId = toInt(itemConfig.para2),
        camp = toInt(camp),
        rarity = toInt(rarity),
        quality = toInt(quality),
        level = 1
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, fromType, heroMapData, {heroMapData})
    end
    return
  end
  DataCenter.HeroDataManager:RemoveNewHeroTag(heroUuid)
  if not heroData.isMaster then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance)
    return
  end
  local fromType = UIHeroInfoView.FromType.HeroList
  local isArrow
  if self.view.ctrl:GetArrow() == ArrowTypeHero.LvUpHero then
    isArrow = 1
    self.view.ctrl:SetArrow()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, {anim = false}, fromType, heroUuid, self.pureDataList, BindCallback(self, self.OnHeroDataChanged), nil, isArrow)
end

local function ShowSelectHero(self, selectHeroUid)
  self.curSelectCell = selectHeroUid
  for k, dt in ipairs(self.showDataList) do
    if type(dt) ~= "number" and table.hasvalue(selectHeroUid) then
      local focusIdx = math.max(1, k - 1)
      self.loopScroll:MovePanelToItemIndex(focusIdx, 0)
      break
    end
  end
  self:ShowArrow()
end

local function DoShowArrow(self)
  if self.view.ctrl:GetArrow() == ArrowTypeHero.LvUpHero then
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.cells[2]:GetCellPos()
    param.position.y = param.position.y - self.cells[2]:GetCellSizeDelta().y * 0.4
    param.YisReversal = true
    DataCenter.ArrowManager:ShowArrow(param)
    return
  end
  if self.curSelectCell == nil then
    return
  end
  if self.curSelectCell ~= nil then
    for k, v in ipairs(self.pureDataList) do
      if v == self.curSelectCell and self.cells[k] ~= nil then
        local position = self.cells[k].gameObject.transform.position
        local param = {}
        param.arrowType = ArrowType.Capacity
        param.positionType = PositionType.Screen
        param.position = position
        param.position.x = param.position.x
        param.position.y = param.position.y + 25
        DataCenter.ArrowManager:ShowArrow(param)
      end
    end
  end
  self.curSelectCell = nil
end

local function ShowArrow(self)
  local delayTime = 0.4
  self:DelayInvoke(function()
    self:DoShowArrow()
  end, delayTime)
end

local function DelayInvoke(self, callback, delayTime)
  local param = {}
  param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
    if param.timer ~= nil then
      param.timer:Stop()
      param.timer = nil
    end
    param = nil
    callback()
  end, self, true, false, false)
  param.timer:Start()
end

local function OnHeroDataChanged(self)
  self:ShowCells(true)
end

local function OnHeroSkillLvUp(self)
  self:ShowCells(true)
end

local function OnMedalExchanged(self)
  self.loopScroll:RefreshAllShownItem()
end

local function OnHandleRankUpSuccess(self)
  self.loopScroll:RefreshAllShownItem()
end

local function GetHeroCellAdvanceGuideBtn(self)
  for _, v in pairs(self.cells) do
    local btn = v:GetHeroCellAdvanceGuideBtn()
    if btn ~= nil then
      return btn
    end
  end
  return nil
end

local function GetHeroCellStarGuideBtn(self)
  for _, v in pairs(self.cells) do
    local btn = v:GetHeroCellStarGuideBtn()
    if btn ~= nil then
      return btn
    end
  end
  return nil
end

local function MoveToHero(self, heroId)
  heroId = tonumber(heroId)
  local showIndex = 0
  local diffY = 0
  local find = false
  for k, v in ipairs(self.showDataList) do
    for _, heroUuid in ipairs(v) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil and heroId == heroData.heroId then
        showIndex = k - 1
        diffY = 70
        find = true
        goto lbl_34
      end
    end
  end
  ::lbl_34::
  if find == true then
    showIndex = math.max(0, showIndex)
    self.loopScroll:MovePanelToItemIndex(showIndex, math.abs(diffY))
  end
end

local function GetHeroItem(self, heroId)
  for _, v in pairs(self.cells) do
    local btn = v:GetHeroItem(heroId)
    if btn ~= nil then
      return btn
    end
  end
  return nil
end

UIHeroListPageHero.OnCreate = OnCreate
UIHeroListPageHero.OnDestroy = OnDestroy
UIHeroListPageHero.OnEnable = OnEnable
UIHeroListPageHero.OnDisable = OnDisable
UIHeroListPageHero.OnAddListener = OnAddListener
UIHeroListPageHero.OnRemoveListener = OnRemoveListener
UIHeroListPageHero.ComponentDefine = ComponentDefine
UIHeroListPageHero.ComponentDestroy = ComponentDestroy
UIHeroListPageHero.DataDefine = DataDefine
UIHeroListPageHero.DataDestroy = DataDestroy
UIHeroListPageHero.ShowCells = ShowCells
UIHeroListPageHero.ClearScroll = ClearScroll
UIHeroListPageHero.DelayInvoke = DelayInvoke
UIHeroListPageHero.ShowArrow = ShowArrow
UIHeroListPageHero.ShowSelectHero = ShowSelectHero
UIHeroListPageHero.OnSwitchCamp = OnSwitchCamp
UIHeroListPageHero.OnHeroDataChanged = OnHeroDataChanged
UIHeroListPageHero.OnHeroSkillLvUp = OnHeroSkillLvUp
UIHeroListPageHero.OnMedalExchanged = OnMedalExchanged
UIHeroListPageHero.OnCellClick = OnCellClick
UIHeroListPageHero.DoShowArrow = DoShowArrow
UIHeroListPageHero.OnHandleRankUpSuccess = OnHandleRankUpSuccess
UIHeroListPageHero.OnGetItemByIndex = OnGetItemByIndex
UIHeroListPageHero.GetItemNameSequence = GetItemNameSequence
UIHeroListPageHero.GetHeroCellAdvanceGuideBtn = GetHeroCellAdvanceGuideBtn
UIHeroListPageHero.GetHeroCellStarGuideBtn = GetHeroCellStarGuideBtn
UIHeroListPageHero.MoveToHero = MoveToHero
UIHeroListPageHero.GetHeroItem = GetHeroItem
return UIHeroListPageHero
