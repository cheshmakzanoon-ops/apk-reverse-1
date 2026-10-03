local UIGiftPackageRewardGetView = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView")
local UIGiftPackageOnlyRewardAdView = BaseClass("UIGiftPackageOnlyRewardAdView", UIGiftPackageRewardGetView)
local base = UIGiftPackageRewardGetView
local Localization = CS.GameEntry.Localization
local rootOnlyPath = "rootOnly"
local textReceivedPath = "rootOnly/textReceived"
local textOnlyPath = "rootOnly/textOnly"
local descTxtPath = "Desc"

local function OnCreate(self)
  base.OnCreate(self)
  self.rootOnly = self:AddComponent(UIBaseContainer, rootOnlyPath)
  self.textReceived = self:AddComponent(UIText, textReceivedPath)
  self.textOnly = self:AddComponent(UIText, textOnlyPath)
  self.textDesc = self:AddComponent(UIText, descTxtPath)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.rootOnly = nil
  self.textReceived = nil
  self.textOnly = nil
  self.textDesc = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.rootOnly:SetActive(false)
  self.textDesc:SetText(Localization:GetString("activity_ads_007", self.param.collectAdNum or 0))
end

UIGiftPackageOnlyRewardAdView.OnCreate = OnCreate
UIGiftPackageOnlyRewardAdView.ComponentDestroy = ComponentDestroy
UIGiftPackageOnlyRewardAdView.OnEnable = OnEnable
return UIGiftPackageOnlyRewardAdView
