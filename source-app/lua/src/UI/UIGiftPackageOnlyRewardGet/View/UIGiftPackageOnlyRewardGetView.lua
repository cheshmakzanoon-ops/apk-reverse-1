local UIGiftPackageRewardGetView = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView")
local UIGiftPackageOnlyRewardGetView = BaseClass("UIGiftPackageOnlyRewardGetView", UIGiftPackageRewardGetView)
local base = UIGiftPackageRewardGetView
local rootOnlyPath = "rootOnly"
local textReceivedPath = "rootOnly/textReceived"
local textOnlyPath = "rootOnly/textOnly"

local function OnCreate(self)
  base.OnCreate(self)
  self.rootOnly = self:AddComponent(UIBaseContainer, rootOnlyPath)
  self.textReceived = self:AddComponent(UIText, textReceivedPath)
  self.textOnly = self:AddComponent(UIText, textOnlyPath)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.rootOnly = nil
  self.textReceived = nil
  self.textOnly = nil
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
end

UIGiftPackageOnlyRewardGetView.OnCreate = OnCreate
UIGiftPackageOnlyRewardGetView.ComponentDestroy = ComponentDestroy
UIGiftPackageOnlyRewardGetView.OnEnable = OnEnable
return UIGiftPackageOnlyRewardGetView
