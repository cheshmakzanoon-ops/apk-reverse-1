local base = UIBaseView
local UIRewardContentTipView = BaseClass("UIRewardContentTipView", base)
local Localization = CS.GameEntry.Localization
local UIRewardContentItem = require("UI.UIRewardContentTip.Component.UIRewardContentItem")
local bgMaskPath = "Mask"
local itemScrollContentPath = "Tip/Bg/ItemScroll/Viewport/Content"
local arrowPath = "Tip/Bg/Arrow"
local bgPath = "Tip/Bg"
local itemTempPath = "Tip/Bg/ItemScroll/Item"
local lineTempPath = "Tip/Bg/ItemScroll/Line"

local function OnCreate(self)
  base.OnCreate(self)
  self.alignObject, self.rewardList, self.offsetX, self.offsetY, self.preferUp, self.autoAdapt = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self.rewardList = self.rewardList or {}
  if self.alignObject == nil or IsNull(self.alignObject.transform) then
    self.ctrl:CloseSelf()
    return
  end
  self:Refresh()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function RefreshReward(self)
  self.itemScrollContent:RemoveComponents(UIRewardContentItem)
  self.itemTemp.gameObject:GameObjectRecycleAll()
  self.lineTemp:GameObjectRecycleAll()
  local list = self.rewardList
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.itemTemp:GameObjectSpawn(self.itemScrollContent.transform)
      item.name = tostring(i)
      local cell = self.itemScrollContent:AddComponent(UIRewardContentItem, item.name, list[i])
      cell:SetData(list[i])
      if i ~= table.length(list) then
        local line = self.lineTemp:GameObjectSpawn(self.itemScrollContent.transform)
        line.name = tostring(string.format("line%d", i))
      end
    end
  end
end

local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

local function SetPos(self)
  local height = 40
  if self.rewardList then
    height = height + 86 * table.length(self.rewardList) + 22 * (table.length(self.rewardList) - 1)
  end
  if 720 < height then
    height = 720
  end
  self.bg.rectTransform:Set_sizeDelta(478, height)
  self.itemScrollContent.rectTransform:Set_anchoredPosition(0, 0)
  if not self.alignObject then
    return
  end
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local uiScale = UIManager:GetInstance():GetScaleFactor()
  local _rect = self.bg.rectTransform.rect
  local bgWidthInScreen = _rect.width * uiScale
  local bgHeightInScreen = _rect.height * uiScale
  local bgWidth = _rect.width
  local bgHeight = _rect.height
  local alignObject = self.alignObject
  local pos = alignObject.transform.position
  if self.offsetX then
    pos.x = pos.x + self.offsetX
  end
  if not self.autoAdapt and self.offsetY then
    pos.y = pos.y + self.offsetY
  end
  local _screenPos = PosConverse.UIWorldToScreenPos(pos)
  local targetScreenPos = _screenPos
  local pivot = Vector2.New(0.5, 0.5)
  local offsetX = 0
  local minX = _screenPos.x - bgWidthInScreen / 2
  local maxX = _screenPos.x + bgWidthInScreen / 2
  if minX < 10 then
    offsetX = bgWidthInScreen / 2 - _screenPos.x
  elseif maxX > ScreenWidth - 10 then
    offsetX = ScreenWidth - _screenPos.x - bgWidthInScreen / 2
  end
  targetScreenPos.x = targetScreenPos.x + offsetX
  pivot.x = Pivot_Mid
  _arrowX = -offsetX / uiScale
  local adapt = false
  if _screenPos.y + bgHeightInScreen < ScreenHeight - 10 or _screenPos.y - bgHeightInScreen > 10 then
    local canUpPivot = false
    local canDownPivot = false
    if _screenPos.y - bgHeightInScreen > 10 then
      canUpPivot = true
    end
    if _screenPos.y + bgHeightInScreen < ScreenHeight - 10 then
      canDownPivot = true
    end
    local isUpPivot = false
    if canUpPivot and canDownPivot then
      if self.preferUp then
        isUpPivot = false
      else
        isUpPivot = true
      end
    elseif canUpPivot then
      isUpPivot = true
    elseif canDownPivot then
      isUpPivot = false
    end
    if isUpPivot then
      _arrowY = bgHeight * 0.5
      pivot.y = Pivot_Max
      adapt = true
    else
      _arrowY = -bgHeight * 0.5
      pivot.y = Pivot_Min
    end
  else
    pivot.y = Pivot_Mid
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 90
    _arrowX = _arrowX + 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 90
    _arrowX = _arrowX + 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 90
    _arrowX = _arrowX + 8
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 270
    _arrowX = _arrowX - 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 270
    _arrowX = _arrowX - 8
    _arrowY = _arrowY - 1
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 270
    _arrowX = _arrowX - 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Max then
    _rotation = 180
    _arrowY = _arrowY + 11
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Min then
    _rotation = 0
    _arrowY = _arrowY - 8
  else
    _rotation = 0
    _arrowX = 9999
    _arrowY = 9999
  end
  self.arrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.arrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.arrow:SetActive(true)
  self.bg.rectTransform.pivot = pivot
  if self.autoAdapt and self.offsetY then
    local offsetY = self.offsetY
    if adapt then
      offsetY = -offsetY
    end
    pos.y = pos.y + offsetY
    _screenPos = PosConverse.UIWorldToScreenPos(pos)
    targetScreenPos.y = _screenPos.y
  end
  local uiPos = PosConverse.ScreenToUIPos(self.transform, targetScreenPos)
  self.bg.transform.anchoredPosition = uiPos
end

local function Refresh(self)
  SetPos(self)
  RefreshReward(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.bgMask = self:AddComponent(UIButton, bgMaskPath)
  self.bgMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemScrollContent = self:AddComponent(UIBaseContainer, itemScrollContentPath)
  self.arrow = self:AddComponent(UIImage, arrowPath)
  self.bg = self:AddComponent(UIImage, bgPath)
  self.itemTemp = self.transform:Find(itemTempPath).gameObject
  self.itemTemp:GameObjectCreatePool()
  self.itemTemp:SetActive(false)
  self.lineTemp = self.transform:Find(lineTempPath).gameObject
  self.lineTemp:GameObjectCreatePool()
  self.lineTemp:SetActive(false)
end

local function ComponentDestroy(self)
  self.bgMask = nil
  self.itemScrollContent:RemoveComponents(UIRewardContentItem)
  self.itemScrollContent = nil
  self.arrow = nil
  self.bg = nil
  self.itemTemp:GameObjectRecycleAll()
  self.itemTemp = nil
  self.lineTemp:GameObjectRecycleAll()
  self.lineTemp = nil
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.screenPos = nil
  self.rewardList = nil
end

UIRewardContentTipView.OnCreate = OnCreate
UIRewardContentTipView.OnDestroy = OnDestroy
UIRewardContentTipView.OnAddListener = OnAddListener
UIRewardContentTipView.OnRemoveListener = OnRemoveListener
UIRewardContentTipView.ComponentDefine = ComponentDefine
UIRewardContentTipView.ComponentDestroy = ComponentDestroy
UIRewardContentTipView.DataDefine = DataDefine
UIRewardContentTipView.DataDestroy = DataDestroy
UIRewardContentTipView.Refresh = Refresh
return UIRewardContentTipView
