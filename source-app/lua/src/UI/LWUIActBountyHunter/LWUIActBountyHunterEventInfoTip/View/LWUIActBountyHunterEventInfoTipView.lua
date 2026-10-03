local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local LWUIActBountyHunterEventInfoTipView = BaseClass("LWUIActBountyHunterEventInfoTipView", Base)
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, "Root/ImgBg/Content/TitleText")
  self.desText = self:AddComponent(UIText, "Root/ImgBg/Content/DesText")
end

local function ComponentDestroy(self)
  Base.ComponentDestroy(self)
  self.titleText = nil
  self.desText = nil
end

local function RefreshShow(self)
  Base.RefreshShow(self)
  if self.param and self.param.title then
    self.titleText:SetText(self.param.title)
  end
  if self.param and self.param.desc then
    self.desText:SetText(self.param.desc)
  end
end

LWUIActBountyHunterEventInfoTipView.ComponentDefine = ComponentDefine
LWUIActBountyHunterEventInfoTipView.ComponentDestroy = ComponentDestroy
LWUIActBountyHunterEventInfoTipView.RefreshShow = RefreshShow
return LWUIActBountyHunterEventInfoTipView
