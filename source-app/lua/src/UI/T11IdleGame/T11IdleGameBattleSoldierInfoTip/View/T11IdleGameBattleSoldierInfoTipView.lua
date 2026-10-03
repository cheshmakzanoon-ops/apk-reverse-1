local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local T11IdleGameBattleSoldierInfoTipView = BaseClass("T11IdleGameBattleSoldierInfoTipView", Base)
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.textContent = self:AddComponent(UIText, "Root/ImgBg/Content/ContentText")
end

local function ComponentDestroy(self)
  self.textContent = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  if self.param and self.param.contentText then
    self.textContent:SetText(self.param.contentText)
  end
end

T11IdleGameBattleSoldierInfoTipView.ComponentDefine = ComponentDefine
T11IdleGameBattleSoldierInfoTipView.ComponentDestroy = ComponentDestroy
T11IdleGameBattleSoldierInfoTipView.RefreshShow = RefreshShow
return T11IdleGameBattleSoldierInfoTipView
