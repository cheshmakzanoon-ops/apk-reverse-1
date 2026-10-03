local UIPlayerLevelView = BaseClass("UIPlayerLevelView", UIBaseView)
local base = UIBaseView
local LevelContent = require("UI.UIPlayerLevel.Component.LevelContent")
local CareerContent = require("UI.UIPlayerLevel.Component.CareerContent")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local tab_on_sprite = "Common_btn_tab_up"
local tab_off_sprite = "Common_btn_tab_down"
local level_content_path = "LevelContent"
local level_tab_path = "Tabs/LevelTab"
local level_icon_path = "Tabs/LevelTab/LevelIcon"
local level_sprite = "UIPlayerInfo_btn_level"
local career_content_path = "CareerContent"
local career_tab_path = "Tabs/CareerTab"
local career_icon_path = "Tabs/CareerTab/CareerIcon"
local career_sprite = "UIPlayerInfo_btn_career"
local TabType = {Level = 1, Career = 2}

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
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.level_content = self:AddComponent(LevelContent, level_content_path)
  self.level_icon_image = self:AddComponent(UIImage, level_icon_path)
  self.level_tab_btn = self:AddComponent(UIButton, level_tab_path)
  self.level_tab_btn:SetOnClick(function()
    self:OnTabClick(TabType.Level)
  end)
  self.level_tab_btn:SetActive(DataCenter.PlayerLevelManager:Enabled())
  self.career_content = self:AddComponent(CareerContent, career_content_path)
  self.career_content:SetDraggingDisableBtn({
    self.close_btn,
    self.return_btn
  })
  self.career_icon_image = self:AddComponent(UIImage, career_icon_path)
  self.career_tab_btn = self:AddComponent(UIButton, career_tab_path)
  self.career_tab_btn:SetOnClick(function()
    self:OnTabClick(TabType.Career)
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.level_content = nil
  self.career_content = nil
end

local function DataDefine(self)
  self.tabType = TabType.Level
end

local function DataDestroy(self)
  self.tabType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  for _, t in pairs(TabType) do
    self:CloseTab(t)
  end
  self.tabType = self:GetUserData() or TabType.Level
  self:OnTabClick(self.tabType)
  local showCareerTab = DataCenter.PlayerCareerManager:Enabled() and DataCenter.PlayerCareerManager:GetCareerType() > 0
  self.career_tab_btn:SetActive(showCareerTab)
end

local function OnTabClick(self, tabType)
  self:CloseTab(self.tabType)
  self.tabType = tabType
  self:OpenTab(self.tabType)
end

local function OpenTab(self, tabType)
  if tabType == TabType.Level then
    self.level_tab_btn:LoadSprite(string.format(LoadPath.CommonNewPath, tab_on_sprite))
    self.level_icon_image:LoadSprite(string.format(LoadPath.CommonNewPath, level_sprite))
    self.level_content:SetActive(true)
    self.level_content:ReInit()
    self.txt_title:SetLocalText(120987)
  elseif tabType == TabType.Career then
    local careerType = DataCenter.PlayerCareerManager:GetCareerType()
    local careerLv = DataCenter.PlayerCareerManager:GetCareerLv()
    self.career_tab_btn:LoadSprite(string.format(LoadPath.CommonNewPath, tab_on_sprite))
    self.career_icon_image:LoadSprite(string.format(LoadPath.CommonNewPath, career_sprite))
    self.career_content:SetActive(true)
    self.career_content:ReInit(careerType, careerLv, true, false, false)
    self.txt_title:SetLocalText(395000)
  end
end

local function CloseTab(self, tabType)
  if tabType == TabType.Level then
    self.level_tab_btn:LoadSprite(string.format(LoadPath.CommonNewPath, tab_off_sprite))
    self.level_icon_image:LoadSprite(string.format(LoadPath.CommonNewPath, level_sprite .. "_unchecked"))
    self.level_content:SetActive(false)
  elseif tabType == TabType.Career then
    self.career_tab_btn:LoadSprite(string.format(LoadPath.CommonNewPath, tab_off_sprite))
    self.career_icon_image:LoadSprite(string.format(LoadPath.CommonNewPath, career_sprite .. "_unchecked"))
    self.career_content:SetActive(false)
  end
end

UIPlayerLevelView.OnCreate = OnCreate
UIPlayerLevelView.OnDestroy = OnDestroy
UIPlayerLevelView.ComponentDefine = ComponentDefine
UIPlayerLevelView.ComponentDestroy = ComponentDestroy
UIPlayerLevelView.DataDefine = DataDefine
UIPlayerLevelView.DataDestroy = DataDestroy
UIPlayerLevelView.OnEnable = OnEnable
UIPlayerLevelView.OnDisable = OnDisable
UIPlayerLevelView.OnAddListener = OnAddListener
UIPlayerLevelView.OnRemoveListener = OnRemoveListener
UIPlayerLevelView.ReInit = ReInit
UIPlayerLevelView.OnTabClick = OnTabClick
UIPlayerLevelView.OpenTab = OpenTab
UIPlayerLevelView.CloseTab = CloseTab
return UIPlayerLevelView
