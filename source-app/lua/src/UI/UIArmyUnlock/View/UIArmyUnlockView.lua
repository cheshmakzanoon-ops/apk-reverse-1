local UIArmyUnlockView = BaseClass("UIArmyUnlockView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "Root/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "Root/UICommonRewardPopUp/Panel"
local army_img_path = "Root/GameObject/UITrainSoldierCell/Icon"
local army_lv_path = "Root/GameObject/UITrainSoldierCell/LevelText"
local army_name_path = "Root/GameObject/UITrainSoldierCell/CountText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(130056)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.army_img = self:AddComponent(UIImage, army_img_path)
  self.army_lv = self:AddComponent(UIText, army_lv_path)
  self.army_name = self:AddComponent(UIText, army_name_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.next_btn = nil
  self.skillIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.armyId = self:GetUserData()
  self:Show()
end

local function Show(self)
  local armyTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.armyId)
  if armyTemplate ~= nil then
    self.army_img:LoadSprite(string.format(LoadPath.SoldierIcons, armyTemplate.icon))
    self.army_name:SetLocalText(armyTemplate.name)
    self.army_lv:SetText(RomeNum[armyTemplate.level])
  end
end

UIArmyUnlockView.OnCreate = OnCreate
UIArmyUnlockView.OnDestroy = OnDestroy
UIArmyUnlockView.ComponentDefine = ComponentDefine
UIArmyUnlockView.ComponentDestroy = ComponentDestroy
UIArmyUnlockView.DataDefine = DataDefine
UIArmyUnlockView.DataDestroy = DataDestroy
UIArmyUnlockView.OnEnable = OnEnable
UIArmyUnlockView.OnDisable = OnDisable
UIArmyUnlockView.ReInit = ReInit
UIArmyUnlockView.Show = Show
return UIArmyUnlockView
