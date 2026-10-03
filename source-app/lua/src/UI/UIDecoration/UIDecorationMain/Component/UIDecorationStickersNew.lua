local UIDecorationStickersNew = BaseClass("UIDecorationStickersNew", UIBaseContainer)
local UIDecorationStickerCellNew = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickerCellNew")
local base = UIBaseContainer
local itemWidth = 172
local showContentWidth = 690
local itemNum = 6
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local left_btn_path = "leftBtn"
local right_btn_path = "rightBtn"

function UIDecorationStickersNew:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:ComponentDefine()
  self:ReInit()
end

function UIDecorationStickersNew:InitData()
  local prefs = DataCenter.DecorationDataManager:GetStickerData()
  self.stickerList = {}
  self.data = DataCenter.DecorationDataManager:GetMapStickerUIData()
  local defaultIndex = 1
  local index
  for i = 1, #prefs do
    index = prefs[i]
    self.data[i].decorationId = index
    if defaultIndex < index then
      defaultIndex = i
    end
  end
  if self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
  end
  self.selectIndex = defaultIndex
end

function UIDecorationStickersNew:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersNew:ComponentDefine()
  local cell
  for i = 1, 6 do
    cell = self:AddComponent(UIDecorationStickerCellNew, "ScrollView/Viewport/Content/sticker" .. i)
    cell:SetData(self.data[i], i, self, function(index)
      self:SelectSticker(index)
    end)
    cell:UnSelect()
    table.insert(self.stickerList, cell)
  end
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.scroll_view:AddValueChangeListener(function()
    self:OnScrollDrag()
  end)
  self.left_btn:SetOnClick(function()
    self:OnLeftBtnClick()
  end)
  self.right_btn:SetOnClick(function()
    self:OnRightBtnClick()
  end)
end

function UIDecorationStickersNew:ComponentDestroy()
  self.scroll_view:RemoveAllListeners()
  self.scroll_view = nil
  self.content = nil
  self.left_btn = nil
  self.right_btn = nil
  self.stickerList = nil
end

function UIDecorationStickersNew:InitOpenView()
  local jumpPos = 0
  if self.selectIndex then
    local maxPos = itemNum * itemWidth - showContentWidth
    jumpPos = (self.selectIndex - 1) * itemWidth
    if maxPos < jumpPos then
      jumpPos = maxPos
    end
  end
  self.content:SetAnchoredPositionXY(-1 * jumpPos, 0)
  self:OnScrollDrag()
end

function UIDecorationStickersNew:ReInit(openType, backCallBack)
  self.openType = openType or MapStickerOpenType.Decoration
  self.backCallBack = backCallBack
  self:RefreshView()
end

function UIDecorationStickersNew:SetPlaneIndex(index)
  if self.selectIndex and self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
    self.stickerList[self.selectIndex]:UnSelect()
  end
  self.selectIndex = index
  if self.stickerList[index] then
    self.stickerList[index]:Restore()
    self.stickerList[index]:UnSelect(true)
    self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
  end
end

function UIDecorationStickersNew:SaveSticker()
  if self.selectIndex then
    self.stickerList[self.selectIndex]:SaveStricker()
  end
  local count = #self.stickerList
  local stickerStr = ""
  for i = 1, count do
    if i == 1 then
      stickerStr = self.stickerList[i].initDecorationId
    else
      stickerStr = stickerStr .. "," .. self.stickerList[i].initDecorationId
    end
  end
  DataCenter.DecorationDataManager:SaveStickerData(stickerStr)
end

function UIDecorationStickersNew:SetSticker(decorationId)
  if self.selectIndex and self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:UpdateSticker(decorationId)
  end
end

function UIDecorationStickersNew:GetSelectStickerDecorationId()
  if self.stickerList[self.selectIndex] then
    return self.stickerList[self.selectIndex].initDecorationId
  end
end

function UIDecorationStickersNew:GetSelectStickerTempId()
  if self.stickerList[self.selectIndex].data.decorationId then
    return self.stickerList[self.selectIndex].data.decorationId
  else
    return self.stickerList[self.selectIndex].initDecorationId
  end
end

function UIDecorationStickersNew:SelectSticker(index)
  if self.openType == MapStickerOpenType.Wrold then
    if self.view and self.view.ctrl then
      if self.data[index] and self.data[index].decorationId ~= -1 then
        if self.selectIndex and self.stickerList[self.selectIndex] then
          self.stickerList[self.selectIndex]:UnSelect()
        end
        self.selectIndex = index
        local temp = DataCenter.DecorationTemplateManager:GetTemplate(self.data[index].decorationId)
        local isSend = DataCenter.LWSticker3DManager:SendMapSticker(WorldStickerType.Build, nil, tonumber(temp.customVariable))
        if not isSend then
          return
        end
      end
      self.view.ctrl:CloseSelf()
    end
    return
  end
  if self.stickerList[self.selectIndex] then
    self.stickerList[self.selectIndex]:Restore()
    self.stickerList[self.selectIndex]:UnSelect()
  end
  self.selectIndex = index
  self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
end

function UIDecorationStickersNew:RefreshView()
  local cell
  for i = 1, #self.stickerList do
    cell = self.stickerList[i]
    cell:SetOpenType(self.openType)
  end
end

function UIDecorationStickersNew:OnScrollDrag()
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

function UIDecorationStickersNew:OnLeftBtnClick()
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

function UIDecorationStickersNew:OnRightBtnClick()
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

return UIDecorationStickersNew
