local UILostSoldierTipView = BaseClass("UILostSoldierTipView", UIBaseView)
local base = UIBaseView
local SoldierTipItem = require("UI.UILostSoldierTip.Component.UISoldierTipItem")
local content_path = "Tip/Bg"
local arrow_path = "Tip/Bg/Arrow"
local allCloseBtn_path = "Mask"
local topDesc_path = "Tip/Bg/DescRoot/DescText"
local scrollTopTextRoot_path = "Tip/Bg/TitleName"
local scorllTopRank_path = "Tip/Bg/TitleName/SoldierRank"
local scrollTopCount_path = "Tip/Bg/TitleName/SoldierCount"
local itemContent_path = "Tip/Bg/Item"
local itemRoot_path = "Tip/Bg/ItemRoot"

function UILostSoldierTipView:OnCreate()
  base.OnCreate(self)
  self:DefineComponent()
end

function UILostSoldierTipView:DefineComponent()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.imgArrow = self:AddComponent(UIBaseContainer, arrow_path)
  self.allCloseBtn = self:AddComponent(UIButton, allCloseBtn_path)
  self.allCloseBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.itemRoot = self:AddComponent(UIBaseContainer, itemRoot_path)
  self.topDesc = self:AddComponent(UIText, topDesc_path)
  self.scrollTopTextRoot = self.transform:Find(scrollTopTextRoot_path)
  self.scorllTopRank = self:AddComponent(UIText, scorllTopRank_path)
  self.scrollTopCount = self:AddComponent(UIText, scrollTopCount_path)
  self.itemGo = self.transform:Find(itemContent_path).gameObject
  self.itemGo:GameObjectCreatePool()
end

function UILostSoldierTipView:OnEnable()
  self.param = self:GetUserData()
  self.data = self.param.data.dataList
  self.soldierData = self.param.data.soldierData
  self.topDescValue = self.param.data.topDesc
  self:RefreshContent()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemRoot.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self:CheckAlign()
end

local ParamData = {
  position = Vector2.zero,
  deltaY = 0,
  data = nil,
  isPositive = false
}
UILostSoldierTipView.ParamDataClass = DataClass("ParamDataClass", ParamData)

function UILostSoldierTipView:RefreshContent()
  if self.topDescValue then
    self.topDesc:SetLocalText(self.topDescValue)
  elseif self.param.isPositive then
    self.topDesc:SetLocalText("battle_report_tips")
  else
    self.topDesc:SetLocalText("soldier_death_rule_panel_3")
  end
  self:GenerateSoldierListView()
end

function UILostSoldierTipView:GenerateSoldierListView()
  self.cellsGo = {}
  self.cellItem = {}
  self.itemRoot:RemoveComponents(SoldierTipItem)
  self.itemGo:GameObjectRecycleAll()
  local list = self.data
  local index = 1
  if list ~= nil then
    for k, v in pairs(list) do
      local item = self.itemGo:GameObjectSpawn(self.itemRoot.transform)
      item.name = tostring(index)
      table.insert(self.cellsGo, item)
      local cell = self.itemRoot:AddComponent(SoldierTipItem, item.name, v)
      cell:SetData(v, self.soldierData)
      index = index + 1
    end
  end
end

local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

function UILostSoldierTipView:CheckAlign()
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local widthScale = ScreenWidth / DefaultScreenWidth
  local heightScale = ScreenHeight / DefaultScreenHeight
  local _rect = self.content.rectTransform.rect
  local BgWidth = _rect.width * widthScale
  local BgHeight = _rect.height * heightScale
  local position = Vector3.zero
  local _screenPos = Vector3.zero
  local deltaY = self.param.deltaY or 0
  position = self.param.position
  if deltaY ~= 0 then
    local worldOffset = self.content.transform:TransformVector(Vector3.New(0, deltaY, 0))
    position.y = position.y + worldOffset.y
  end
  _screenPos = PosConverse.UIWorldToScreenPos(position)
  local targetScreenPos = _screenPos
  local pivot = Vector2.New(0.5, 0.5)
  local offsetX = 0
  if _screenPos.x - BgWidth / 2 < 10 then
    offsetX = BgWidth / 2 - _screenPos.x
  elseif _screenPos.x + BgWidth / 2 > ScreenWidth - 10 then
    offsetX = ScreenWidth - _screenPos.x - BgWidth / 2
  end
  targetScreenPos.x = targetScreenPos.x + offsetX
  pivot.x = Pivot_Mid
  _arrowX = -offsetX / widthScale
  if _screenPos.y + BgHeight < ScreenHeight - 10 or _screenPos.y - BgHeight > 10 then
    if _screenPos.y + BgHeight < ScreenHeight - 10 then
      pivot.y = Pivot_Min
      _arrowY = -BgHeight / heightScale * 0.5
    elseif _screenPos.y - BgHeight > 10 then
      pivot.y = Pivot_Max
      _arrowY = BgHeight / heightScale * 0.5
    end
  else
    pivot.y = Pivot_Mid
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 270
    _arrowX = _arrowX + 8
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 90
    _arrowX = _arrowX - 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Max then
    _rotation = 0
    _arrowY = _arrowY + 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Min then
    _rotation = 180
    _arrowY = _arrowY - 4
  else
    _rotation = 0
    _arrowX = 9999
    _arrowY = 9999
  end
  self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.imgArrow:SetActive(true)
  self.content.rectTransform.pivot = pivot
  local uiPos = PosConverse.ScreenToUIPos(self.transform, targetScreenPos)
  self.content.transform.anchoredPosition = uiPos
end

function UILostSoldierTipView:OnDestroy()
  self:ComponentDestroy()
  if self.cellsGo then
    for _, v in pairs(self.cellsGo) do
      v:GameObjectRecycle()
    end
  end
  self.cellsGo = nil
end

function UILostSoldierTipView:ComponentDestroy()
  self.content = nil
  self.imgArrow = nil
  self.allCloseBtn = nil
  self.topDesc = nil
  self.scorllTopRank = nil
  self.scrollTopCount = nil
  self.itemGo.gameObject:GameObjectRecycleAll()
  self.itemGo = nil
  self.scrollBottomCount = nil
end

return UILostSoldierTipView
