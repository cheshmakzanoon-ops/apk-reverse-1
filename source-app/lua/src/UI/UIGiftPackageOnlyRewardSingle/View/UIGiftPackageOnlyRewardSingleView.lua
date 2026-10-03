local UIGiftPackageRewardGetView = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView")
local UIGiftPackageOnlyRewardSingleView = BaseClass("UIGiftPackageOnlyRewardSingleView", UIGiftPackageRewardGetView)
local base = UIGiftPackageRewardGetView
local Localization = CS.GameEntry.Localization
local rootOnlyPath = "rootOnly"
local textReceivedPath = "rootOnly/textReceived"
local textOnlyPath = "rootOnly/textOnly"
local CongratulationText = "TitleGetShowItem/Desc"
local Icon = "TitleGetShowItem/Icon"
local IconName = "TitleGetShowItem/Name"
local Effect_path = "TitleGetShowItem/Effect"

local function OnCreate(self)
  base.OnCreate(self)
  self.rootOnly = self:AddComponent(UIBaseContainer, rootOnlyPath)
  self.textReceived = self:AddComponent(UIText, textReceivedPath)
  self.textOnly = self:AddComponent(UIText, textOnlyPath)
  self.textCongratulations = self:AddComponent(UIText, CongratulationText)
  self.icon = self:AddComponent(UIImage, Icon)
  self.iconName = self:AddComponent(UIText, IconName)
  self.Effect = self:AddComponent(UIBaseContainer, Effect_path)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.rootOnly = nil
  self.textReceived = nil
  self.textOnly = nil
  self.textCongratulations = nil
  self.icon = nil
  self.iconName = nil
  self.Effect = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.param and self.param.isOnlyReward then
    self.textReceived:SetLocalText("season_s2_callback_tips_2")
    self.rootOnly:SetActive(true)
    if self.param.onlyText then
      self.textOnly:SetText(self.param.onlyText)
    else
      self.textOnly:SetLocalText("season_s2_callback_tips_3")
    end
  else
    self.rootOnly:SetActive(false)
  end
  if self.param and self.param.rewardList and self.param.rewardList[1] then
    local data = self.param.rewardList[1]
    local id = data.itemId or ""
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if template ~= nil then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/" .. template.icon)
      self.iconName:SetLocalText(template.name)
    end
    self.textCongratulations:SetText(Localization:GetString(data.singleShowDesc, data.singleShowDescParam[1] or ""))
  end
  self.Effect:SetActive(true)
end

UIGiftPackageOnlyRewardSingleView.OnCreate = OnCreate
UIGiftPackageOnlyRewardSingleView.ComponentDestroy = ComponentDestroy
UIGiftPackageOnlyRewardSingleView.OnEnable = OnEnable
return UIGiftPackageOnlyRewardSingleView
