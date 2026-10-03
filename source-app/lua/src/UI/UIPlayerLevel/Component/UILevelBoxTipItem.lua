local UILevelBoxTipItem = BaseClass("UILevelBoxTipItem", UIBaseContainer)
local base = UIBaseContainer
local LevelManager = DataCenter.PlayerLevelManager
local UIItem = require("UI.UIGiftPackage.Component.UIGiftItem")
local item_path = "Item"
local name_path = "Name"
local count_path = "Count"
local career_lv_path = "CareerLv"

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
  self.item = self:AddComponent(UIItem, item_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.count_text = self:AddComponent(UIText, count_path)
  self.career_lv_text = self:AddComponent(UIText, career_lv_path)
end

local function ComponentDestroy(self)
  self.item = nil
  self.name_text = nil
  self.count_text = nil
  self.career_lv_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  local param = {
    isSimple = true,
    iconName = data.icon
  }
  self.name_text:SetText(data.name)
  self.count_text:SetText(data.count)
  self.item:ReInit(param)
  
  function self.item.OnBtnClick()
    local param = {}
    param.type = "desc"
    param.title = data.name or ""
    param.desc = data.desc or ""
    param.alignObject = self.item.btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
  
  if DataCenter.PlayerCareerManager:EnabledShow() and data.type == LevelManager.ContentInfoType.Career then
    self.career_lv_text:SetActive(true)
    self.career_lv_text:SetText(data.count)
  else
    self.career_lv_text:SetActive(false)
  end
end

UILevelBoxTipItem.OnCreate = OnCreate
UILevelBoxTipItem.OnDestroy = OnDestroy
UILevelBoxTipItem.ComponentDefine = ComponentDefine
UILevelBoxTipItem.ComponentDestroy = ComponentDestroy
UILevelBoxTipItem.DataDefine = DataDefine
UILevelBoxTipItem.DataDestroy = DataDestroy
UILevelBoxTipItem.OnAddListener = OnAddListener
UILevelBoxTipItem.OnRemoveListener = OnRemoveListener
UILevelBoxTipItem.OnEnable = OnEnable
UILevelBoxTipItem.OnDisable = OnDisable
UILevelBoxTipItem.SetData = SetData
return UILevelBoxTipItem
