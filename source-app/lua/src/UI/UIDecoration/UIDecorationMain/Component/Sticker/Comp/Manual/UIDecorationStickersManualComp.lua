local itemNum = 6
local itemWidth = 172
local showContentWidth = 602
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local left_btn_path = "leftBtn"
local right_btn_path = "rightBtn"
local UIDecorationStickerCellNew = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickerCellNew")
local UIDecorationStickersManualCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Manual.UIDecorationStickersManualCell")
local base = UIBaseContainer
local UIDecorationStickersManualComp = BaseClass("UIDecorationStickersManualComp", UIBaseContainer)

function UIDecorationStickersManualComp:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_view:AddValueChangeListener(function()
    self:OnScrollDrag()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn:SetOnClick(BindCallback(self, self.OnLeftBtnClick))
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(BindCallback(self, self.OnRightBtnClick))
  for i = 1, 6 do
    local cell = self:AddComponent(UIDecorationStickersManualCell, "ScrollView/Viewport/Content/sticker" .. i)
    cell:SetData(self.SlotData[i], i, self, function(index)
      self:SelectSticker(index)
    end)
    cell:UnSelect()
    table.insert(self.CellList, cell)
  end
end

function UIDecorationStickersManualComp:ComponentDestroy()
  self.scroll_view:RemoveAllListeners()
  self.scroll_view = nil
  self.content = nil
  self.left_btn = nil
  self.right_btn = nil
end

function UIDecorationStickersManualComp:DataDefine()
end

function UIDecorationStickersManualComp:DataDestroy()
end

function UIDecorationStickersManualComp:OnCreate()
  base.OnCreate(self)
  self:InitStickerSlotData()
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersManualComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersManualComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
end

function UIDecorationStickersManualComp:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

function UIDecorationStickersManualComp:InitStickerSlotData()
  local prefs = DataCenter.DecorationDataManager:GetStickerData()
  self.CellList = {}
  self.SlotData = DataCenter.DecorationDataManager:GetMapStickerUIData()
  local defaultIndex = 1
  local index
  for i = 1, #prefs do
    index = prefs[i]
    self.SlotData[i].decorationId = index
    if defaultIndex < index then
      defaultIndex = i
    end
  end
  if self.CellList[self.SelectIndex] then
    self.CellList[self.SelectIndex]:Restore()
  end
end

function UIDecorationStickersManualComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
  self:SetPlaneIndex(DataCenter.DecorationDataManager:GetStickerPlaneIndex())
  if self.SelectIndex then
    self:FocusIndex(self.SelectIndex)
  end
end

function UIDecorationStickersManualComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIDecorationStickersManualComp:InitUi()
end

function UIDecorationStickersManualComp:SaveSticker()
  if self.SelectIndex then
    self.CellList[self.SelectIndex]:SaveStricker()
  end
  local count = #self.CellList
  local stickerStr = ""
  for i = 1, count do
    if i == 1 then
      stickerStr = self.CellList[i].initDecorationId
    else
      stickerStr = stickerStr .. "," .. self.CellList[i].initDecorationId
    end
  end
  DataCenter.DecorationDataManager:SaveStickerData(stickerStr)
end

function UIDecorationStickersManualComp:GetSelectStickerDecorationId()
  if self.CellList[self.SelectIndex] then
    return self.CellList[self.SelectIndex].initDecorationId
  end
end

function UIDecorationStickersManualComp:SetSticker(decorationId)
  if self.SelectIndex and self.CellList[self.SelectIndex] then
    self.CellList[self.SelectIndex]:UpdateSticker(decorationId)
  end
end

function UIDecorationStickersManualComp:SetPlaneIndex(index)
  if self.SelectIndex and self.CellList[self.SelectIndex] then
    self.CellList[self.SelectIndex]:Restore()
    self.CellList[self.SelectIndex]:UnSelect()
  end
  self.SelectIndex = index
  if self.CellList[index] then
    self.CellList[index]:Restore()
    self.CellList[index]:UnSelect(true)
    self.holder:RefreshIcons()
  end
end

function UIDecorationStickersManualComp:SelectSticker(index)
  if self.CellList[self.SelectIndex] then
    self.CellList[self.SelectIndex]:Restore()
    self.CellList[self.SelectIndex]:UnSelect()
  end
  self.SelectIndex = index
  self.holder:RefreshIcons()
  self:FocusIndex(index)
end

function UIDecorationStickersManualComp:FocusIndex(index)
  index = checknumber(index)
  local jumpPos = 0
  local maxPos = itemNum * itemWidth - showContentWidth
  jumpPos = math.max(0, (index - 1.5) * itemWidth)
  if maxPos < jumpPos then
    jumpPos = maxPos
  end
  self.content:SetAnchoredPositionXY(-1 * jumpPos, 0)
  self:OnScrollDrag()
end

function UIDecorationStickersManualComp:OnScrollDrag()
  local aPosX = self.content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth - showContentWidth
  local leftBtnShow = false
  local rightBtnShow = false
  local space = 10
  if aPosX < -1 * space then
    leftBtnShow = true
  end
  if aPosX > -1 * (maxPos - space) then
    rightBtnShow = true
  end
  self.left_btn:SetActive(leftBtnShow)
  self.right_btn:SetActive(rightBtnShow)
end

function UIDecorationStickersManualComp:OnLeftBtnClick()
  local aPosX = self.content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth - showContentWidth
  local leftItemNum = -1 * aPosX / itemWidth
  leftItemNum = math.floor(leftItemNum + 0.5)
  leftItemNum = leftItemNum - 1
  local jumpPos = leftItemNum * itemWidth
  if jumpPos < 0 then
    jumpPos = 0
  end
  if maxPos < jumpPos then
    jumpPos = maxPos
  end
  self.content:SetAnchoredPositionXY(-1 * jumpPos, 0)
  self:OnScrollDrag()
end

function UIDecorationStickersManualComp:OnRightBtnClick()
  local aPosX = self.content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth - showContentWidth
  local rightItemNum = (-1 * aPosX + showContentWidth) / itemWidth
  rightItemNum = math.floor(rightItemNum + 0.5)
  rightItemNum = rightItemNum + 1
  local jumpPos = rightItemNum * itemWidth - showContentWidth
  if maxPos < jumpPos then
    jumpPos = maxPos
  end
  self.content:SetAnchoredPositionXY(-1 * jumpPos, 0)
  self:OnScrollDrag()
end

function UIDecorationStickersManualComp:OnSelectEvent(decorationId)
  local curIndex = checknumber(self.SelectIndex)
  if curIndex < 1 or 6 < curIndex then
    return
  end
  local curDecorationId = self.CellList[curIndex].initDecorationId
  if curDecorationId == decorationId then
    return
  end
  local toChangeIndex = -1
  for i = 1, table.count(self.CellList) do
    if i ~= curIndex then
      local cell = self.CellList[i]
      if cell.initDecorationId == decorationId then
        cell:UpdateSticker(-1)
        cell:SaveStricker()
        if toChangeIndex == -1 then
          toChangeIndex = i
        end
      end
    end
  end
  if 0 < toChangeIndex then
    self.CellList[toChangeIndex]:UpdateSticker(curDecorationId)
    self.CellList[toChangeIndex]:SaveStricker()
  end
  self:SetSticker(decorationId)
  self:SaveSticker()
end

return UIDecorationStickersManualComp
