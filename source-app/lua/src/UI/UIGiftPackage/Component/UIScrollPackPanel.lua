local UIScrollPack = BaseClass("UIScrollPack", UIBaseView)
local base = UIBaseView
local UIScrollPackContent = require("UI.UIScrollPack.Component.UIScrollPackContent")
local ResourceManager = CS.GameEntry.Resource
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local point_area_path = "PointArea"
local select_path = "Select"
local CELL_WIDTH = 1334
local DEFAULT_SPACE = 180
local SPRING_BACK_SPEED = 8000
local IMMEDIATE_SPEED = 1000000
local SPRING_BACK_THRESHOLD = 0.05
local SCREEN_WIDTH = Screen.width / Screen.height * 750

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:ClearPoints()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, content_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, content_path)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.point_area_go = self:AddComponent(UIBaseContainer, point_area_path)
  self.select_go_list = {}
end

local function ComponentDestroy(self)
  self.scroll_view = nil
  self.content = nil
  self.event_trigger = nil
  self.point_area_go = nil
  self.select_go_list = nil
end

local function DataDefine(self)
  self.packs = nil
  self.view = nil
  self.pointReqDict = {}
  self.maxX = 0
  self.selectIndex = 1
  self.lastX = 0
end

local function DataDestroy(self)
  self.packs = nil
  self.view = nil
  self.pointReqDict = nil
  self.maxX = nil
  self.selectIndex = nil
  self.lastX = nil
  self.scollSpeed = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPoints(self)
  self:ClearPoints()
  for i = 1, #self.packs do
    local req = ResourceManager:InstantiateAsync(UIAssets.UIScrollPackPoint)
    req:completed("+", function()
      if req.isError then
        return
      end
      if self.pointReqDict[i] then
        self.pointReqDict[i]:Destroy()
      end
      self.pointReqDict[i] = req
      local go = req.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.point_area_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "Point" .. i
      local select_go = go.transform:Find(select_path).gameObject
      self.select_go_list[i] = select_go
      select_go:SetActive(i == self.selectIndex)
    end)
  end
end

local function ClearPoints(self)
  for _, req in pairs(self.pointReqDict) do
    req:Destroy()
  end
  self.select_go_list = {}
  self.pointReqDict = {}
end

local function SelectPoint(self, index)
  for i = 1, #self.packs do
    if self.select_go_list[i] ~= nil then
      self.select_go_list[i]:SetActive(i == index)
    end
  end
end

local function ShowCells(self)
  local count = table.count(self.packs)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIScrollPackContent)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIScrollPackContent, itemObj)
  item:SetData(self.packs[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnDrag(self, eventData)
  self.scroll_view:OnDrag(eventData)
end

local function OnBeginDrag(self, eventData)
  self.scroll_view:OnBeginDrag(eventData)
end

local function OnEndDrag(self, eventData)
  local firstIndex = self:GetFirstIndex()
  local frontX = self:IndexToX(firstIndex)
  local x = self.content.rectTransform.anchoredPosition.x - frontX
  local index = 1
  if x < 0 then
    x = math.abs(x)
    local lastSelectX = self:IndexToX(self.selectIndex)
    if x > lastSelectX + CELL_WIDTH * SPRING_BACK_THRESHOLD then
      index = math.min(self.selectIndex + 1, #self.packs)
    elseif x < lastSelectX - CELL_WIDTH * SPRING_BACK_THRESHOLD then
      index = math.max(self.selectIndex - 1, 1)
    else
      index = self.selectIndex
    end
  end
  self.scroll_view:OnEndDrag(eventData)
  self.selectIndex = index
  self:ScrollToCell(index, false)
end

local function ReInit(self, view, rechargeId, packId)
  self.rechargeId = rechargeId
  self.packs = GiftPackManager.getScrollPack(rechargeId)
  self.view = view
  if #self.packs == 0 then
    self.view.ctrl:CloseSelf()
    return
  end
  table.sort(self.packs, function(a, b)
    if packId ~= nil and a:getID() == packId then
      return true
    elseif packId ~= nil and b:getID() == packId then
      return false
    elseif a:getPopup() ~= b:getPopup() then
      return a:getPopup() > b:getPopup()
    else
      return a:getID() < b:getID()
    end
  end)
  local delta = (SCREEN_WIDTH - CELL_WIDTH) / 2
  self.scroll_view.rectTransform.anchoredPosition = Vector2.New(delta / 2, 0)
  self.content:SetSpacing(DEFAULT_SPACE + delta)
  self:ShowCells()
  self:ShowPoints()
  self.selectIndex = Mathf.Clamp(self.selectIndex, 1, #self.packs)
  self:ScrollToCell(self.selectIndex, true)
  local contentWidth = #self.packs * CELL_WIDTH + (#self.packs - 1) * (DEFAULT_SPACE + delta) + delta * 2
  self.maxX = contentWidth - SCREEN_WIDTH
end

local function ScrollToCell(self, index, immediate)
  self.scroll_view:StopMovement()
  local speed = immediate and IMMEDIATE_SPEED or SPRING_BACK_SPEED
  self.scroll_view:ScrollToCell(index, speed)
  self:SelectPoint(index)
  self.lastX = self:IndexToX(index)
end

local function XToIndex(self, x)
  local per = self.maxX / (#self.packs - 1)
  for i = 1, #self.packs do
    if x >= (i - 1.5) * per and x < (i - 0.5) * per then
      return i
    end
  end
end

local function IndexToX(self, index)
  local per = self.maxX / (#self.packs - 1)
  return (index - 1) * per
end

local function GetFirstIndex(self)
  local firstIndex = IntMaxValue
  for i = 1, self.content.transform.childCount do
    local tf = self.content.transform:GetChild(i - 1)
    firstIndex = math.min(firstIndex, tonumber(tf.name))
  end
  return firstIndex
end

UIScrollPack.OnCreate = OnCreate
UIScrollPack.OnDestroy = OnDestroy
UIScrollPack.OnEnable = OnEnable
UIScrollPack.OnDisable = OnDisable
UIScrollPack.ComponentDefine = ComponentDefine
UIScrollPack.ComponentDestroy = ComponentDestroy
UIScrollPack.DataDefine = DataDefine
UIScrollPack.DataDestroy = DataDestroy
UIScrollPack.OnAddListener = OnAddListener
UIScrollPack.OnRemoveListener = OnRemoveListener
UIScrollPack.ShowCells = ShowCells
UIScrollPack.ClearScroll = ClearScroll
UIScrollPack.OnCreateCell = OnCreateCell
UIScrollPack.OnDeleteCell = OnDeleteCell
UIScrollPack.OnDrag = OnDrag
UIScrollPack.OnBeginDrag = OnBeginDrag
UIScrollPack.OnEndDrag = OnEndDrag
UIScrollPack.ShowPoints = ShowPoints
UIScrollPack.ClearPoints = ClearPoints
UIScrollPack.SelectPoint = SelectPoint
UIScrollPack.ReInit = ReInit
UIScrollPack.ScrollToCell = ScrollToCell
UIScrollPack.XToIndex = XToIndex
UIScrollPack.IndexToX = IndexToX
UIScrollPack.GetFirstIndex = GetFirstIndex
return UIScrollPack
