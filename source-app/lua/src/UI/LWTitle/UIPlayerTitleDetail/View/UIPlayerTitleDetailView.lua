local base = UIBaseView
local UIPlayerTitleDetail = BaseClass("UIPlayerTitleDetail", base)
local PlayerTitleDetailItem = require("UI.LWTitle.Component.PlayerTitleDetailItem")
local close_path = "Panel"
local scrollView_path = "Root/TitleScrollView"
local content_path = "Root/TitleScrollView/Viewport/Content"
local scrollbar_path = "Root/TitleScrollView/Scrollbar"
local bar_path = "Root/TitleScrollView/Scrollbar/bar"
local root_path = "Root/TitleScrollView"
local itemSize = 708

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData(self:GetUserData())
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
  self.close = self:AddComponent(UIButton, close_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollbar = self:AddComponent(UIBaseContainer, scrollbar_path)
  self.bar = self:AddComponent(UIBaseContainer, bar_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollView:AddComponent(PlayerTitleDetailItem, itemObj)
    local cfg = self.list[index]
    if cellItem and cfg then
      cellItem:ReInit(cfg, self.uid, self:GetDetailData(cfg.id))
      self.itemDic[cfg.id] = cellItem
    end
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self.scrollView:RemoveComponent(itemObj.name, PlayerTitleDetailItem)
  end)
  self.scrollView:SetOnBeginDrag(function(pointerEventData)
    self.beginDragPos = self.contentLayout:GetLocalPositionXYZ()
  end)
  self.scrollView:SetOnEndDrag(function(pointerEventData)
    local curPos = self.contentLayout:GetLocalPositionXYZ()
    if not self.beginDragPos or not curPos then
      return
    end
    local deltaX = curPos - self.beginDragPos
    if deltaX < -itemSize * 0.2 then
      self:MoveToByIndex(self.curIndex + 1, 0.3)
    elseif deltaX > itemSize * 0.2 then
      self:MoveToByIndex(self.curIndex - 1, 0.3)
    else
      self:MoveToByIndex(self.curIndex, 0.3)
    end
  end)
  self.scrollRect = self:AddComponent(UIScrollRect, scrollView_path)
  self.barObj = self.bar.gameObject
  self.barObj:GameObjectCreatePool()
  self.barObj:SetActive(false)
  self.contentLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, content_path)
  self.spacing = self.contentLayout:GetSpacing()
  local screenWidth = self.root:GetSizeDeltaXY()
  self.padding = (screenWidth - itemSize) * 0.5
  self.padding = toInt(self.padding)
  self.contentLayout:SetPaddingLeft(self.padding)
  self.contentLayout:SetPaddingRight(self.padding)
end

local function ComponentDestroy(self)
  self:Clear()
  self.close = nil
  self.scrollView = nil
  self.content = nil
  self.scrollbar = nil
  self.bar = nil
  self.root = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIPlayerTitleDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.GetNewUserInfoSucc)
  self:AddUIListener(EventId.UserTitleDetail, self.UserTitleDetail)
end

function UIPlayerTitleDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.GetNewUserInfoSucc)
  self:RemoveUIListener(EventId.UserTitleDetail, self.UserTitleDetail)
  base.OnRemoveListener(self)
end

function UIPlayerTitleDetail:Clear()
  self.scrollView:RemoveComponents(PlayerTitleDetailItem)
  self.scrollView:ClearCells()
  self.scrollbar:RemoveComponents(UIImage)
  self.scrollbar:RemoveComponents(UIButton)
  self.barObj:GameObjectRecycleAll()
  self.barList = nil
end

function UIPlayerTitleDetail:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:SetData(self:GetUserData())
end

function UIPlayerTitleDetail:SetData(uid, titleId, detailData)
  self.uid = uid or LuaEntry.Player:GetUid()
  self.titleId = titleId
  self.detailData = detailData
  self.detailDic = {}
  self.detailDic[titleId] = detailData
  self:RefreshView(titleId)
end

function UIPlayerTitleDetail:RefreshView(titleId)
  self:Clear()
  self.data = UIUtil.GetPlayerInfoShowByUid(self.uid)
  self.list = self:GetTitleWallList(self.data and self.data.titleWall)
  self.count = #self.list
  self.itemDic = {}
  self.scrollView:SetTotalCount(self.count)
  self.scrollView:RefillCells()
  if self.count <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  if self.count <= 1 then
    self:MoveToByIndex(1, 0)
    return
  end
  self.barList = {}
  for i = 1, self.count do
    local theItem = self.barObj:GameObjectSpawn(self.scrollbar.transform)
    theItem.name = string.format("BarItem_%d", i)
    theItem = self.scrollbar:AddComponent(UIButton, theItem.name)
    theItem:SetOnClick(function()
      self:MoveToByIndex(i, 0.3)
    end)
    self.barList[i] = theItem:AddComponent(UIImage, "icon")
  end
  local index = 1
  if titleId then
    for i, v in ipairs(self.list) do
      if v.id == titleId then
        index = i
        break
      end
    end
  end
  self:MoveToByIndex(index, 0)
end

function UIPlayerTitleDetail:MoveToByIndex(index, duration)
  index = Mathf.Clamp(index, 1, self.count)
  local value = 0
  if index <= 1 then
    value = 0
  elseif index >= self.count then
    value = 1
  else
    local count = math.max(self.count - 1, 0)
    local total = itemSize * count + self.spacing * count
    local curX = (index - 1) * (itemSize + self.spacing)
    value = curX / total
  end
  if not duration or duration <= 0 then
    self.scrollRect:AnimHorizontalNormalizedPos(value, 0.1)
  else
    self.scrollRect:AnimHorizontalNormalizedPos(value, duration)
  end
  self.curIndex = index
  if self.barList then
    for i, icon in ipairs(self.barList) do
      icon:SetActive(i == index)
    end
  end
end

function UIPlayerTitleDetail:GetTitleWallList(titleWall)
  local find, index, list = false, 0
  if not table.IsNullOrEmpty(titleWall) then
    list = {}
    for i = 1, TitleShowCount do
      local titleData = titleWall[i]
      if titleData and titleData.title and 0 < titleData.title then
        index = index + 1
        list[index] = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(titleData.title)
        if not find and self.detailData and self.detailData.cfgId == titleData.title then
          find = true
        end
      end
    end
  end
  if not find and self.detailData then
    list = {
      DataCenter.PlayerTitleTemplateManager:GetTitleInfo(self.detailData.cfgId)
    }
  end
  return list
end

function UIPlayerTitleDetail:GetDetailData(titleId)
  if not titleId or titleId <= 0 then
    return nil
  end
  local detail = self.detailDic[titleId]
  if not detail then
    SFSNetwork.SendMessage(MsgDefines.UserTitleGetDetail, titleId, self.uid)
  end
  return detail
end

function UIPlayerTitleDetail:GetNewUserInfoSucc(uid)
  if uid == self.uid then
    self:RefreshView(self.titleId)
  end
end

function UIPlayerTitleDetail:UserTitleDetail(data)
  if data and data.uid == self.uid then
    self.detailDic[data.cfgId] = data
    local item = self.itemDic and self.itemDic[data.cfgId]
    if item then
      item:RefreshDetail(data)
    end
  end
end

UIPlayerTitleDetail.OnCreate = OnCreate
UIPlayerTitleDetail.OnDestroy = OnDestroy
UIPlayerTitleDetail.OnEnable = OnEnable
UIPlayerTitleDetail.OnDisable = OnDisable
UIPlayerTitleDetail.ComponentDefine = ComponentDefine
UIPlayerTitleDetail.ComponentDestroy = ComponentDestroy
UIPlayerTitleDetail.DataDefine = DataDefine
UIPlayerTitleDetail.DataDestroy = DataDestroy
return UIPlayerTitleDetail
