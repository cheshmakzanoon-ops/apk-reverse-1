local UIScrollRectCenter = BaseClass("UIScrollRectCenter", UIBaseComponent)
local base = UIBaseComponent
local UnityScrollRect = typeof(CS.UnityEngine.UI.ScrollRect)
local horizontalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalLayoutGroup)
local bidirectionalHorizontalLayoutGroup = typeof(CS.BidirectionalHorizontalLayoutGroup)
local verticalLayoutGroup = typeof(CS.UnityEngine.UI.VerticalLayoutGroup)
local gridLayOutGroup = typeof(CS.UnityEngine.UI.GridLayoutGroup)
local CSUIEventTrigger = typeof(CS.UIEventTrigger)
ScrollDir = {Horizontal = 0, Vertical = 1}
ScrollType = {Normal = 0}

local function FindClosestChildPos(self, currentPos)
  local curCenterChildIndex = -1
  if currentPos - self.childrenPosList[self.curCenterChildIndex] > 50 then
    if self.curCenterChildIndex <= 1 then
      curCenterChildIndex = 1
    else
      curCenterChildIndex = self.curCenterChildIndex - 1
    end
    return self.childrenPosList[curCenterChildIndex], curCenterChildIndex
  elseif currentPos - self.childrenPosList[self.curCenterChildIndex] < -50 then
    if self.curCenterChildIndex >= #self.childrenPosList then
      curCenterChildIndex = #self.childrenPosList
    else
      curCenterChildIndex = self.curCenterChildIndex + 1
    end
    return self.childrenPosList[curCenterChildIndex], curCenterChildIndex
  else
    return self.childrenPosList[self.curCenterChildIndex], self.curCenterChildIndex
  end
end

local function Update(self)
  if self.isCentering and self.inited then
    local v = self.startPrefix
    self.tempTime = self.tempTime + self.moveToCenterSpeed * Time.deltaTime
    if self.dir == ScrollDir.Horizontal then
      v.x = Mathf.Lerp(v.x, self.targetPos, self.tempTime)
      self.content.localPosition = v
    else
    end
    Logger.Log("self.tempTime = " .. self.tempTime)
    if self.tempTime >= 1 then
      self.isCentering = false
      if self.onCenterCallBack ~= nil then
        self.onCenterCallBack(self.curCenterChildIndex)
      end
    end
  end
end

local function OnBeginDrag(self, onBeginDrag)
  self.isCentering = false
  self.tempTime = 0
  self.startPrefix = Vector3.zero
  self.startPos = onBeginDrag.position
end

local function OnEndDrag(self, onEndDrag)
  if not self.inited then
    return
  end
  if self.dir == ScrollDir.Horizontal then
    self.targetPos, self.curCenterChildIndex = FindClosestChildPos(self, self.content.localPosition.x)
  else
  end
  self.isCentering = true
  self.startPrefix = self.content.localPosition
end

local function DataDefine(self)
  self.dir = ScrollDir.Horizontal
  self.scrollType = ScrollType.Normal
  self.curCenterChildIndex = 0
  self.inited = false
  self.uiEventTrigger = nil
  self.content = nil
  self.spacing = nil
  self.isGridLayout = false
  self.childrenPosList = {}
  self.targetPos = 0
  self.tempTime = 0
  self.isCentering = false
  self.moveToCenterSpeed = 10
  self.startPos = Vector3.zero
  self.startPrefix = Vector3.zero
  self.onCenterCallBack = nil
  self.timer_action = BindCallback(self, Update)
end

local function DataDestroy(self)
  self.dir = nil
  self.scrollType = nil
  self.curCenterChildIndex = nil
  self.inited = nil
  self.uiEventTrigger = nil
  self.content = nil
  self.spacing = nil
  self.isGridLayout = nil
  self.childrenPosList = nil
  self.targetPos = nil
  self.tempTime = nil
  self.isCentering = nil
  self.moveToCenterSpeed = nil
  self.startPos = nil
  self.startPrefix = nil
  self.onCenterCallBack = nil
  self.timer_action = nil
end

local function AddUpdator(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, true, false)
    self.timer:Start()
  end
end

local function RemoveUpdator(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetChildItemWidth(self, index)
  local child = self.content:GetChild(index).gameObject
  if child.activeInHierarchy then
    local rect = child:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rect then
      return rect.sizeDelta.x
    end
  end
  return 0
end

local function Init(self, dir, type)
  if not (dir and type) or not self.uiEventTrigger then
    return
  end
  self.dir = dir
  self.scrollType = type
  self.childrenPosList = {}
  self.curCenterChildIndex = 0
  local spacing = 0
  if dir == ScrollDir.Horizontal and not self.isGridLayout then
    local childPosX = 0
    local itemIndex = 0
    local lastActiveItemIndex = 0
    for i = 0, self.content.childCount - 1 do
      local child = self.content:GetChild(i).gameObject
      if child.gameObject.activeInHierarchy then
        if itemIndex == 0 then
          childPosX = 0
        else
          childPosX = childPosX - (GetChildItemWidth(self, i) * 0.5 + GetChildItemWidth(self, lastActiveItemIndex) * 0.5 + self.spacing)
        end
        table.insert(self.childrenPosList, childPosX)
        lastActiveItemIndex = i
        itemIndex = itemIndex + 1
      end
    end
  else
  end
  goto lbl_68
  ::lbl_68::
  self.inited = true
  self.tempTime = 0
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  local scrollRect = self.gameObject:GetComponent(UnityScrollRect)
  if scrollRect ~= nil then
    self.content = scrollRect.content
    local contentLayoutGroup = self.content:GetComponent(horizontalLayoutGroup)
    if not contentLayoutGroup then
      contentLayoutGroup = self.content:GetComponent(bidirectionalHorizontalLayoutGroup)
      if not contentLayoutGroup then
        contentLayoutGroup = self.content:GetComponent(verticalLayoutGroup)
        if not contentLayoutGroup then
          contentLayoutGroup = self.content:GetComponent(gridLayOutGroup)
          if contentLayoutGroup then
            self.isGridLayout = true
          end
        end
      end
    end
    if not contentLayoutGroup then
      return
    end
    self.spacing = contentLayoutGroup.spacing
    local _UIEventTrigger = self.gameObject:GetComponent(CSUIEventTrigger)
    if not _UIEventTrigger then
      return
    else
      self.uiEventTrigger = _UIEventTrigger
    end
    self.uiEventTrigger.onBeginDrag = BindCallback(self, OnBeginDrag)
    self.uiEventTrigger.onEndDrag = BindCallback(self, OnEndDrag)
    AddUpdator(self)
  end
end

local function RemoveEvenTriggerCallBack(self)
  if self.uiEventTrigger then
    self.uiEventTrigger.onBeginDrag = nil
    self.uiEventTrigger.onEndDrag = nil
  end
end

local function OnDestroy(self)
  RemoveEvenTriggerCallBack(self)
  RemoveUpdator(self)
  DataDestroy(self)
  base.OnDestroy(self)
end

local function CenterOn(self, index)
  if not self.content then
    return
  end
  if index > #self.childrenPosList then
    index = #self.childrenPosList
  end
  if index < 1 then
    index = 1
  end
  local v = self.content.localPosition
  if self.dir == ScrollDir.Horizontal then
    v.x = self.childrenPosList[index]
    self.content.localPosition = v
  else
  end
  self.curCenterChildIndex = index
  if self.onCenterCallBack then
    self.onCenterCallBack(self.curCenterChildIndex)
  end
end

local function CenterOnAnim(self, index, time, callback)
  if not self.content then
    return
  end
  if index > #self.childrenPosList then
    index = #self.childrenPosList
  end
  if index < 1 then
    index = 1
  end
  if self.dir == ScrollDir.Horizontal then
    local x = self.childrenPosList[index]
    self.content.transform:DOLocalMoveX(x, time):OnComplete(function()
      self.curCenterChildIndex = index
      if self.onCenterCallBack then
        self.onCenterCallBack(self.curCenterChildIndex)
      end
      if callback then
        callback()
      end
    end)
  else
  end
end

local function OnCenterOnChild(self, callBack)
  self.onCenterCallBack = callBack
end

UIScrollRectCenter.OnCreate = OnCreate
UIScrollRectCenter.OnDestroy = OnDestroy
UIScrollRectCenter.Init = Init
UIScrollRectCenter.CenterOn = CenterOn
UIScrollRectCenter.CenterOnAnim = CenterOnAnim
UIScrollRectCenter.OnCenterOnChild = OnCenterOnChild
return UIScrollRectCenter
