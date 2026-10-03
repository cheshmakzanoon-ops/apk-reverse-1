local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local LWUIActRecycleTipView = BaseClass("LWUIActRecycleTipView", Base)
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.desText = self:AddComponent(UIText, "Root/ImgBg/Content/DesText")
end

local function ComponentDestroy(self)
  Base.ComponentDestroy(self)
  self.desText = nil
end

local function RefreshShow(self)
  Base.RefreshShow(self)
  if self.param and self.param.desc then
    self.desText:SetText(self.param.desc)
  end
end

LWUIActRecycleTipView.ComponentDefine = ComponentDefine
LWUIActRecycleTipView.ComponentDestroy = ComponentDestroy
LWUIActRecycleTipView.RefreshShow = RefreshShow
return LWUIActRecycleTipView
