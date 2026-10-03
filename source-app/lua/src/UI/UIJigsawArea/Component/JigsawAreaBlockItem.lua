local JigsawAreaBlockItem = BaseClass("JigsawAreaBlockItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local eventTrigger_path = ""
local blockImg_path = "Img"
local completeEff_path = "Img/eff"
local blockName_path = "Text"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.blockImgN = self:AddComponent(UIImage, blockImg_path)
  self.completeEffN = self:AddComponent(UIBaseContainer, completeEff_path)
  self.completeEffN:SetActive(false)
  self.blockNameN = self:AddComponent(UIText, blockName_path)
  self.blockNameN:SetActive(false)
  self.tweenImgN = self.blockImgN.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.eventTriggerN = self:AddComponent(UIEventTrigger, eventTrigger_path)
  self.eventTriggerN:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.eventTriggerN:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.eventTriggerN:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.blockImgN = nil
  self.blockNameN = nil
  self.eventTriggerN = nil
end

local function DataDefine(self)
  self.blockIndex = nil
  self.cachePos = nil
  self.curPointIndex = nil
end

local function DataDestroy(self)
  self.blockIndex = nil
  self.cachePos = nil
  self.curPointIndex = nil
end

local function SetItem(self, blockIndex, tempPath)
  self.blockIndex = blockIndex
  self.blockNameN:SetText(blockIndex)
  local rowNum = 6 - math.ceil(blockIndex / 7)
  local columnNum = blockIndex % 7
  columnNum = columnNum == 0 and 7 or columnNum
  local fullPath = string.format(tempPath, columnNum, rowNum)
  self.blockImgN:LoadSprite(fullPath)
end

local function OnDrag(self, eventData)
  if self.curPointIndex == self.blockIndex then
    return
  end
  local isInPlayArea = self.curPointIndex
  if not isInPlayArea then
    local offsetX = math.abs(eventData.position.x - self.cachePos.x)
    local offsetY = math.abs(eventData.position.y - self.cachePos.y)
    if offsetX > offsetY then
      isInPlayArea = true
    elseif offsetX < offsetY then
      isInPlayArea = false
    end
  end
  if isInPlayArea then
    self.view:SetDragingBlockIndex(self.blockIndex)
  end
  self.view:OnDragItem(eventData)
end

local function OnBeginDrag(self, eventData)
  if self.curPointIndex == self.blockIndex then
    return
  end
  self.cachePos = eventData.position
  self.view:OnBeginDragItem(eventData)
end

local function OnEndDrag(self, eventData)
  if self.curPointIndex == self.blockIndex then
    return
  end
  self.view:OnEndDragItem(eventData)
end

local function SetPosIndex(self, posIndex)
  self.curPointIndex = posIndex
end

local function GetCurPointIndex(self)
  return self.curPointIndex
end

local function GetBlockIndex(self)
  return self.blockIndex
end

local function TweenColor(self)
  self.tweenImgN:DOColor(Color.New(0.6, 0.6, 0.6), 0.2):OnComplete(function()
    self.tweenImgN:DOColor(WhiteColor, 0.2)
  end)
end

local function PlayCompleteEff(self)
  self.completeEffN:SetActive(false)
  self.completeEffN:SetActive(true)
end

JigsawAreaBlockItem.OnCreate = OnCreate
JigsawAreaBlockItem.OnDestroy = OnDestroy
JigsawAreaBlockItem.ComponentDefine = ComponentDefine
JigsawAreaBlockItem.ComponentDestroy = ComponentDestroy
JigsawAreaBlockItem.DataDefine = DataDefine
JigsawAreaBlockItem.DataDestroy = DataDestroy
JigsawAreaBlockItem.SetItem = SetItem
JigsawAreaBlockItem.OnDrag = OnDrag
JigsawAreaBlockItem.OnBeginDrag = OnBeginDrag
JigsawAreaBlockItem.OnEndDrag = OnEndDrag
JigsawAreaBlockItem.SetPosIndex = SetPosIndex
JigsawAreaBlockItem.GetCurPointIndex = GetCurPointIndex
JigsawAreaBlockItem.GetBlockIndex = GetBlockIndex
JigsawAreaBlockItem.TweenColor = TweenColor
JigsawAreaBlockItem.PlayCompleteEff = PlayCompleteEff
return JigsawAreaBlockItem
