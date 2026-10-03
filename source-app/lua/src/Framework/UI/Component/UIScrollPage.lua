local UIScrollPage = BaseClass("UIScrollPage", UIBaseContainer)
local base = UIBaseContainer
local CSUIEventTrigger = typeof(CS.UIEventTrigger)
local UnityScrollRect = typeof(CS.UnityEngine.UI.ScrollRect)

function UIScrollPage:OnCreate()
  base.OnCreate(self)
  self.startDragHorizontal = 0
  self.isInDrag = false
  self.stopMove = true
  self.cell_count = 0
  self.currentPageIndex = 1
  self.unity_scroll_rect = self.gameObject:GetComponent(UnityScrollRect)
  self.unity_event_trigger = self.gameObject:GetComponent(CSUIEventTrigger)
  self.isHorizontal = self.unity_scroll_rect.horizontal
  self:SetNormalizedPosition(0)
  if self.unity_event_trigger ~= nil then
    function self.unity_event_trigger.onBeginDrag(eventData)
      self:DoBeginDrag()
    end
    
    function self.unity_event_trigger.onEndDrag(eventData)
      self:DoEndDrag()
    end
    
    function self.unity_event_trigger.onPointerClick()
      self:DoPointerClick()
    end
  end
end

function UIScrollPage:DoBeginDrag()
  self.isInDrag = true
  self.startDragHorizontal = self:GetNormalizedPosition()
end

function UIScrollPage:DoEndDrag()
  local pos = self:GetNormalizedPosition()
  if math.abs(pos - self.startDragHorizontal) < 1.0E-4 then
    self.isInDrag = false
    return
  end
  local index = 0
  local isRight = pos > self.startDragHorizontal
  if isRight then
    index = self.currentPageIndex + 1
    index = math.min(index, self.cell_count)
  else
    index = self.currentPageIndex - 1
    index = math.max(index, 1)
  end
  self.targetHorizontal = self:SetPageIndex(index)
  self.isInDrag = false
  self.stopMove = false
  self.startTime = 0
end

function UIScrollPage:DoPointerClick()
  if self.isInDrag == false and self.__onPageClick ~= nil and type(self.__onPageClick) == "function" then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    pcall(self.__onPageClick)
  end
end

function UIScrollPage:OnDestroy()
  self.__onPageChanged = nil
  self.__onPageClick = nil
  if self.unity_event_trigger ~= nil then
    self.unity_event_trigger.onBeginDrag = nil
    self.unity_event_trigger.onEndDrag = nil
    self.unity_event_trigger.onPointerClick = nil
    self.unity_event_trigger = nil
  end
  base.OnDestroy(self)
end

local function Lerp(start_v, end_v, percent)
  return start_v + (end_v - start_v) * percent
end

function UIScrollPage:Update()
  if self.startTime ~= nil and not self.isInDrag and not self.stopMove then
    self.startTime = self.startTime + Time.deltaTime
    local smoothing = 4
    local t = self.startTime * smoothing
    self:SetNormalizedPosition(Lerp(self:GetNormalizedPosition(), self.targetHorizontal, t))
    if 1 <= t then
      self.startTime = nil
      self.stopMove = true
    end
  end
end

function UIScrollPage:SetPageCount(pageCount)
  local posList = {}
  if 1 < pageCount then
    local step = 1 / (pageCount - 1)
    for i = 0, pageCount - 1 do
      table.insert(posList, step * i)
    end
  else
    table.insert(posList, 0)
  end
  table.insert(posList, 1)
  if pageCount < self.currentPageIndex then
    self.currentPageIndex = pageCount
  end
  self.cell_count = pageCount
  self.posList = posList
end

function UIScrollPage:SetPageChangedCallback(action)
  self.__onPageChanged = action
end

function UIScrollPage:PageTo(index, force)
  if force or 1 <= index and index <= self.cell_count and self.currentPageIndex ~= index then
    local pos = self.posList[index]
    self.currentPageIndex = index
    self:SetNormalizedPosition(pos)
  end
end

function UIScrollPage:SetPageIndex(index)
  if self.cell_count <= 0 then
    return 0
  end
  if 1 <= index and index <= self.cell_count and self.currentPageIndex ~= index then
    self.currentPageIndex = index
    if self.__onPageChanged ~= nil and type(self.__onPageChanged) == "function" then
      pcall(self.__onPageChanged, index)
    end
  end
  return self.posList[self.currentPageIndex]
end

function UIScrollPage:SetOnClick(action)
  self.__onPageClick = action
end

function UIScrollPage:ToNextPage()
  if self.currentPageIndex < self.cell_count then
    self:PageTo(self.currentPageIndex + 1)
  end
end

function UIScrollPage:ToPrevPage()
  if self.currentPageIndex > 1 then
    self:PageTo(self.currentPageIndex - 1)
  end
end

function UIScrollPage:GetNormalizedPosition()
  if self.isHorizontal then
    local ret = self.unity_scroll_rect:GetHorizontalNormalizedPosition()
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
      ret = 1 - ret
    end
    return ret
  else
    return 1 - self.unity_scroll_rect.verticalNormalizedPosition
  end
end

function UIScrollPage:SetNormalizedPosition(pos)
  if self.isHorizontal then
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
      pos = 1 - pos
    end
    self.unity_scroll_rect:SetHorizontalNormalizedPosition(pos)
  else
    self.unity_scroll_rect.verticalNormalizedPosition = 1 - pos
  end
end

function UIScrollPage:SmoothScrollToPage(index)
  self.targetHorizontal = self:SetPageIndex(index)
  self.isInDrag = false
  self.stopMove = false
  self.startTime = 0
end

function UIScrollPage:SetEnable(bool)
  self.unity_scroll_rect.enabled = bool
end

function UIScrollPage:PageToAndCallback(index)
  if 1 <= index and index <= self.cell_count then
    local pos = self.posList[index]
    self.currentPageIndex = index
    self:SetNormalizedPosition(pos)
    if self.__onPageChanged ~= nil and type(self.__onPageChanged) == "function" then
      pcall(self.__onPageChanged, index)
    end
  end
end

return UIScrollPage
