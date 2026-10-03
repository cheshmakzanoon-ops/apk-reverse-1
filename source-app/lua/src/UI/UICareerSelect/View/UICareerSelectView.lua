local UICareerSelect = BaseClass("UICareerSelect", UIBaseView)
local base = UIBaseView
local UICareerPortrait = require("UI.UIPlayerLevel.Component.UICareerPortrait")
local back_path = "safeArea/Back"
local title_path = "safeArea/Title"
local desc_path = "DescBg/Desc"
local scroll_view_path = "ScrollView"

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
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    if self.onClose then
      self.onClose()
    end
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_text.transform)
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.title_text = nil
  self.desc_text = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.careerTypeList = {}
  self.itemList = {}
  self.onClose = nil
end

local function DataDestroy(self)
  self.careerTypeList = nil
  self.itemList = nil
  self.onClose = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  self:ClearScroll()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerCareerSelect, self.OnCareerSelect)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerCareerSelect, self.OnCareerSelect)
  base.OnRemoveListener(self)
end

local function OnCellMoveIn(self, itemObj, index)
  local careerType = self.careerTypeList[index]
  itemObj.name = tostring(careerType)
  local item = self.scroll_view:AddComponent(UICareerPortrait, itemObj)
  item:SetData(careerType)
  item:SetOnClick(function()
    self:PreviewCareerType(item.careerType)
  end)
  item:SetActive(true)
  local free = DataCenter.PlayerCareerManager:HaveFreeChangeForCareer(careerType)
  item:ShowFree(free)
  self.itemList[careerType] = item
end

local function OnCellMoveOut(self, itemObj, index)
  item:SetActive(false)
  self.scroll_view:RemoveComponent(itemObj.name, UICareerPortrait)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = #self.careerTypeList
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICareerPortrait)
end

local function ReInit(self)
  self.onClose = self:GetUserData()
  local list = DataCenter.PlayerCareerManager:GetCareerTypeList()
  self.careerTypeList = {}
  for _, t in ipairs(list) do
    local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(t, 1)
    if careerTemplate.showType == 0 then
      table.insert(self.careerTypeList, t)
    end
  end
  if DataCenter.PlayerCareerManager:Enabled() then
    self.desc_text:SetLocalText(395001)
  else
    self.desc_text:SetLocalText(159001)
  end
  if DataCenter.PlayerCareerManager:GetCareerType() == CareerType.None then
    self.title_text:SetLocalText(395000)
  else
    self.title_text:SetLocalText(110126)
  end
  self:ShowCells()
end

local function PreviewCareerType(self, careerType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICareerPreview, careerType)
end

local function OnCareerSelect(self)
  self.ctrl:CloseSelf()
end

UICareerSelect.OnCreate = OnCreate
UICareerSelect.OnDestroy = OnDestroy
UICareerSelect.ComponentDefine = ComponentDefine
UICareerSelect.ComponentDestroy = ComponentDestroy
UICareerSelect.DataDefine = DataDefine
UICareerSelect.DataDestroy = DataDestroy
UICareerSelect.OnEnable = OnEnable
UICareerSelect.OnDisable = OnDisable
UICareerSelect.OnAddListener = OnAddListener
UICareerSelect.OnRemoveListener = OnRemoveListener
UICareerSelect.OnCellMoveIn = OnCellMoveIn
UICareerSelect.OnCellMoveOut = OnCellMoveOut
UICareerSelect.ShowCells = ShowCells
UICareerSelect.ClearScroll = ClearScroll
UICareerSelect.ReInit = ReInit
UICareerSelect.PreviewCareerType = PreviewCareerType
UICareerSelect.OnCareerSelect = OnCareerSelect
return UICareerSelect
