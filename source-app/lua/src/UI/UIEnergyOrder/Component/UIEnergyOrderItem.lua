local UIEnergyOrderItem = BaseClass("UIEnergyOrderItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Localization = CS.GameEntry.Localization
local title_path = "Title"
local icon_path = "Icon"
local count_path = "Count"
local check_path = "Check"
local find_path = "Find"
local find_icon_path = "Find/FindIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.count_text = self:AddComponent(UIText, count_path)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.find_btn = self:AddComponent(UIButton, find_path)
  self.find_btn:SetOnClick(function()
    self:OnFindClick()
  end)
  self.find_icon_go = self:AddComponent(UIBaseContainer, find_icon_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.icon_image = nil
  self.count_text = nil
  self.check_go = nil
  self.find_btn = nil
  self.find_icon_go = nil
end

local function DataDefine(self)
  self.data = nil
  self.enough = nil
end

local function DataDestroy(self)
  self.data = nil
  self.enough = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  self.data = data
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.itemId)
  local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(data.itemId)
  self.enough = haveCount >= data.count
  self.title_text:SetLocalText(template.name)
  self.icon_image:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
  self.find_icon_go:SetActive(not self.enough)
  local color = self.enough and "white" or "red"
  self.count_text:SetText(string.format("<color=%s>%s</color>/%s", color, haveCount, data.count))
end

local function OnFindClick(self)
  if self.enough then
    local tempParam = GoToUtil.GetSourceByResourceItem(self.data.itemId)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.transform.position + Vector3.New(0, -20, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.title = tempParam.name
    param.content = tempParam.buildName
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 240
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  else
    local lackTab = {}
    local param = {}
    param.type = ResLackType.ResItem
    param.itemId = self.data.itemId
    param.targetNum = self.data.count
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
  end
end

UIEnergyOrderItem.OnCreate = OnCreate
UIEnergyOrderItem.OnDestroy = OnDestroy
UIEnergyOrderItem.ComponentDefine = ComponentDefine
UIEnergyOrderItem.ComponentDestroy = ComponentDestroy
UIEnergyOrderItem.DataDefine = DataDefine
UIEnergyOrderItem.DataDestroy = DataDestroy
UIEnergyOrderItem.OnEnable = OnEnable
UIEnergyOrderItem.OnDisable = OnDisable
UIEnergyOrderItem.SetData = SetData
UIEnergyOrderItem.OnFindClick = OnFindClick
return UIEnergyOrderItem
