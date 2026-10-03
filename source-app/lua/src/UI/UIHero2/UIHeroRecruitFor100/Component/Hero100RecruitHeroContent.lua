local Hero100RecruitHeroContent = BaseClass("Hero100RecruitHeroContent", UIBaseContainer)
local HeroCardRowItem = require("UI.UIHero2.UIHeroRecruitFor100.Component.Hero100RecruitRowItem")
local Logger = require("Framework.Logger.Logger")
local rowItemPrefabNameStr = "HeroRecruitHeroAreaRowItem(Spawn)"
local row_item_path = "HeroRecruitHeroAreaRowItem"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rowItemObj = self:AddComponent(UIBaseContainer, row_item_path)
  self.rowItemObj.gameObject:GameObjectCreatePool()
  self.rowItemHeight = self.rowItemObj.rectTransform.rect.height
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.curAniRowItemData = nil
  self.allRowItemList = {}
  self.allRowItemDataList = {}
  self.rowItemShowScriptDic = {}
  self.usedRowItemGoPool = {}
  self.itemIndex = 0
  self.playStartAniFlag = true
end

local function DataDestroy(self)
  self:ClearAllItem()
  self.curAniRowItemData = nil
  self.allRowItemList = nil
  self.allRowItemDataList = nil
  self.rowItemShowScriptDic = nil
  self.usedRowItemGoPool = nil
  self.curPlayRowIndex = 1
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function Hero100RecruitHeroContent:Init(parentScrollView, parentViewPort, parentContent)
  self.parentScrollView = parentScrollView
  self.parentViewPort = parentViewPort
  self.parentContent = parentContent
end

function Hero100RecruitHeroContent:SetData(heroDataList, isHeroDraw, loadFinishCallback)
  self:ClearRowItems()
  self.isHeroDraw = isHeroDraw
  self.loadFinishCallback = loadFinishCallback
  self.rowItemLoadFinishCount = 0
  self.curPlayRowIndex = 1
  for _, v in ipairs(self.allRowItemList) do
    v:ResetState()
  end
  local heroCount = table.count(heroDataList)
  local cardCountPerRow = 3
  self.rowItemCount = math.ceil(heroCount / cardCountPerRow)
  self:UpdateContentHeight()
  self.allRowItemDataList = {}
  local prevRowItemData
  self.allInViewRowItemCount = 0
  for i = 1, self.rowItemCount do
    local rowHeroList = {}
    local startIndex = 1 + cardCountPerRow * (i - 1)
    for j = startIndex, startIndex + cardCountPerRow - 1 do
      if heroDataList[j] then
        table.insert(rowHeroList, {
          heroData = heroDataList[j],
          isFlipped = false,
          dataIndex = j
        })
      end
    end
    local rowItemData = {}
    rowItemData.rowHeroList = rowHeroList
    table.insert(self.allRowItemDataList, rowItemData)
    if not self.curAniRowItemData then
      self.curAniRowItemData = rowItemData
    end
    if prevRowItemData then
      prevRowItemData.nextRowItem = rowItemData
    end
    prevRowItemData = rowItemData
  end
  self.playStartAniFlag = true
  self:CheckCardItemGenOrDestroy()
end

function Hero100RecruitHeroContent:UpdateContentHeight()
  if not self.rectTransform then
    return
  end
  self.rectTransform:Set_sizeDelta(self.rectTransform.sizeDelta.x, self.rowItemHeight * self.rowItemCount)
end

function Hero100RecruitHeroContent:ClearAllItem()
  if self.rowItemShowScriptDic then
    for k, rowItem in pairs(self.rowItemShowScriptDic) do
      if rowItem then
        rowItem.gameObject.name = rowItemPrefabNameStr
        rowItem:ClearAllCardItem()
      end
    end
    self.rowItemShowScriptDic = {}
  end
  if self.usedRowItemGoPool then
    for k, go in pairs(self.usedRowItemGoPool) do
      if IsNotNull(go) then
        go.name = rowItemPrefabNameStr
      end
    end
    self.usedRowItemGoPool = {}
  end
  self.rowItemObj.gameObject:GameObjectRecycleAll()
  self.usedRowItemGoPool = {}
  self:RemoveAllComponentes()
  self.itemIndex = 0
  self.allRowItemList = {}
end

function Hero100RecruitHeroContent:ClearRowItems()
  if self.rowItemShowScriptDic then
    for k, rowItem in pairs(self.rowItemShowScriptDic) do
      if rowItem then
        rowItem.gameObject.name = rowItemPrefabNameStr
        rowItem:ClearAllCardItem()
      end
    end
    self.rowItemShowScriptDic = {}
  end
  if self.usedRowItemGoPool then
    for k, go in pairs(self.usedRowItemGoPool) do
      if IsNotNull(go) then
        go.name = rowItemPrefabNameStr
      end
    end
    self.usedRowItemGoPool = {}
  end
  self:RemoveComponents(HeroCardRowItem)
  self.rowItemObj.gameObject:GameObjectRecycleAll()
  self.usedRowItemGoPool = {}
  self.itemIndex = 0
  self.parentScrollView:StopMovement()
end

function Hero100RecruitHeroContent:ExecuteOneAniStep()
  if self:IsAniAllFinish() then
    return
  end
  local curRowItem = self:GetCurRowItem()
  if not curRowItem then
    return nil
  end
  local needTime, screenPos, isRepeatHeroChip = curRowItem:ExecuteOneAniStep()
  if curRowItem:IsAniAllFinish() then
    self.curPlayRowIndex = self.curPlayRowIndex + 1
  end
  return needTime, screenPos, isRepeatHeroChip
end

function Hero100RecruitHeroContent:GetCurRowItemData()
  return self.allRowItemDataList[self.curPlayRowIndex]
end

function Hero100RecruitHeroContent:GetCurRowItem()
  local curRowData = self:GetCurRowItemData()
  if not curRowData then
    return nil
  end
  local rowItem = self.rowItemShowScriptDic[curRowData]
  return rowItem
end

function Hero100RecruitHeroContent:IsAniAllFinish()
  return self.curPlayRowIndex > #self.allRowItemDataList
end

function Hero100RecruitHeroContent:GetAllHeroCardScreenPos()
  local ret = {}
  for _, j in ipairs(self.allRowItemList) do
    local posList = j:GetAllHeroCardScreenPos()
    for _, k in ipairs(posList) do
      table.insert(ret, k)
    end
  end
  return ret
end

function Hero100RecruitHeroContent:OnOneRowItemLoadFinish()
  if not self.playStartAniFlag then
    return
  end
  self.rowItemLoadFinishCount = self.rowItemLoadFinishCount + 1
  local curRowItemCountInView = self:GetCurRowItemCountInView()
  if self.rowItemLoadFinishCount == curRowItemCountInView then
    self.playStartAniFlag = false
    if self.loadFinishCallback then
      self.loadFinishCallback()
    end
  end
end

function Hero100RecruitHeroContent:GetCurRowItemCountInView()
  local ret = 0
  if not self.rowItemShowScriptDic then
    return ret
  end
  for _, v in pairs(self.rowItemShowScriptDic) do
    if v then
      ret = ret + 1
    end
  end
  return ret
end

function Hero100RecruitHeroContent:PlayCardFlyEff()
end

function Hero100RecruitHeroContent:ResetEffectState()
  if not self.allRowItemList then
    return
  end
  for _, v in ipairs(self.allRowItemList) do
    v:ResetState()
  end
end

function Hero100RecruitHeroContent:UpdateOnContentRoll()
  self:CheckCardItemGenOrDestroy()
end

function Hero100RecruitHeroContent:CheckCardItemGenOrDestroy()
  if not self.allRowItemDataList then
    return
  end
  for index, v in ipairs(self.allRowItemDataList) do
    local isInView = self:IsTargetRowItemInViewPort(index)
    local rowItem = self.rowItemShowScriptDic[v]
    if isInView then
      if rowItem == nil then
        local rowItemObj
        if #self.usedRowItemGoPool <= 0 then
          rowItemObj = self.rowItemObj.gameObject:GameObjectSpawn(self.transform)
          if rowItemObj.name ~= rowItemPrefabNameStr then
            Logger.LogError("\228\187\142\230\177\160\229\173\144\233\135\140\233\157\162\230\139\191\229\135\186\231\154\132\233\162\132\229\136\182\231\154\132\229\144\141\229\173\151\228\184\141\229\175\185\239\188\140\229\186\148\232\175\165\230\152\175\239\188\154" .. rowItemPrefabNameStr .. " \231\142\176\229\156\168\230\152\175\239\188\154" .. rowItemObj.name)
          end
          self.itemIndex = self.itemIndex + 1
          rowItemObj.name = "HeroRecruitHeroAreaRowItem" .. self.itemIndex
        else
          rowItemObj = self.usedRowItemGoPool[#self.usedRowItemGoPool]
          table.remove(self.usedRowItemGoPool, #self.usedRowItemGoPool)
        end
        local name = rowItemObj.name
        rowItem = self:GetComponent(rowItemObj.name, HeroCardRowItem)
        if rowItem == nil then
          rowItem = self:AddComponent(HeroCardRowItem, name)
        end
        self.rowItemShowScriptDic[v] = rowItem
        local offSetY = (index - 1) * self.rowItemHeight
        rowItem.transform:Set_localPosition(0, -offSetY, 0)
        local rowHeroList = v.rowHeroList
        rowItem:SetData(rowHeroList, self.isHeroDraw, function()
          self:OnOneRowItemLoadFinish()
        end)
        rowItem:SetActive(true)
      end
    elseif rowItem then
      rowItem:ResetState()
      table.insert(self.usedRowItemGoPool, rowItem.gameObject)
      rowItem:SetActive(false)
      self.rowItemShowScriptDic[v] = nil
    end
  end
end

function Hero100RecruitHeroContent:IsTargetRowItemInViewPort(index)
  local offSetY = (index - 1) * self.rowItemHeight
  local parentContentPosY = self.parentContent.transform.localPosition.y
  local viewPortHeight = self.parentViewPort.rectTransform.rect.height
  if parentContentPosY > offSetY + self.rowItemHeight + 50 then
    return false
  elseif parentContentPosY + viewPortHeight < offSetY - self.rowItemHeight - 20 then
    return false
  end
  return true
end

function Hero100RecruitHeroContent:SetCardIsFlippedState(index, state)
  if self.allRowItemDataList == nil then
    return
  end
  local rowIndex = math.ceil(index / 3)
  local cardIndexInRow = index - (rowIndex - 1) * 3
  local rowItemData = self.allRowItemDataList[rowIndex]
  if rowItemData and rowItemData.rowHeroList and rowItemData.rowHeroList[cardIndexInRow] then
    rowItemData.rowHeroList[cardIndexInRow].isFlipped = state
  else
    Logger.LogError("index:" .. index .. " \231\138\182\230\128\129\230\178\161\230\156\137\232\174\190\231\189\174\230\136\144\229\138\159  rowIndex\239\188\154" .. rowIndex .. " cardIndexInRow :" .. cardIndexInRow)
  end
end

Hero100RecruitHeroContent.OnCreate = OnCreate
Hero100RecruitHeroContent.OnDestroy = OnDestroy
Hero100RecruitHeroContent.OnEnable = OnEnable
Hero100RecruitHeroContent.OnDisable = OnDisable
Hero100RecruitHeroContent.ComponentDefine = ComponentDefine
Hero100RecruitHeroContent.ComponentDestroy = ComponentDestroy
Hero100RecruitHeroContent.DataDefine = DataDefine
Hero100RecruitHeroContent.DataDestroy = DataDestroy
Hero100RecruitHeroContent.OnAddListener = OnAddListener
Hero100RecruitHeroContent.OnRemoveListener = OnRemoveListener
return Hero100RecruitHeroContent
