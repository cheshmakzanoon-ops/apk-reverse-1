local base = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.UIZombieEliteBossRewardItem")
local UIZombieEliteBossRewardRateItem = BaseClass("UIZombieEliteBossRewardRateItem", base)
local rate_text_path = "RateText"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.rate_text = self:AddComponent(UITextMeshProUGUIEx, rate_text_path)
end

local function ComponentDestroy(self)
  self.rate_text = nil
  base.ComponentDestroy(self)
end

local function SetRateText(self, rate)
  local rateStr = string.format("%.2f", tonumber(rate) * 100)
  self.rate_text:SetText(rateStr .. "%")
end

UIZombieEliteBossRewardRateItem.OnCreate = OnCreate
UIZombieEliteBossRewardRateItem.OnDestroy = OnDestroy
UIZombieEliteBossRewardRateItem.ComponentDefine = ComponentDefine
UIZombieEliteBossRewardRateItem.ComponentDestroy = ComponentDestroy
UIZombieEliteBossRewardRateItem.SetRateText = SetRateText
return UIZombieEliteBossRewardRateItem
