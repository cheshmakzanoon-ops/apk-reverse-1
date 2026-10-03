local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIOffSeason1RecaptureBuffTipView = BaseClass("UIOffSeason1RecaptureBuffTipView", base)
local Localization = CS.GameEntry.Localization

function UIOffSeason1RecaptureBuffTipView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
end

function UIOffSeason1RecaptureBuffTipView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureBuffTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/TitleText")
  self.textBuff = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/BuffText")
  self.textLock = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/LockText")
end

function UIOffSeason1RecaptureBuffTipView:ComponentDestroy()
  self.textTitle = nil
  self.textBuff = nil
  self.textLock = nil
  base.ComponentDestroy(self)
end

function UIOffSeason1RecaptureBuffTipView:DataDefine()
end

function UIOffSeason1RecaptureBuffTipView:DataDestroy()
end

function UIOffSeason1RecaptureBuffTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1RecaptureBuffTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureBuffTipView:RefreshShow()
  base.RefreshShow(self)
  local effectInfo = self.param.effectInfo
  if effectInfo == nil or effectInfo.cfg == nil then
    return
  end
  self.textTitle:SetLocalText(effectInfo.cfg.name)
  self.textBuff:SetLocalText(effectInfo.cfg.description)
  if not effectInfo.unlock then
    self.textLock:SetActive(true)
    self.textLock:SetLocalText("s1_offseason_activity_recapture_buffUnlockTips", effectInfo.level, effectInfo.needNum)
  else
    self.textLock:SetActive(false)
  end
end

return UIOffSeason1RecaptureBuffTipView
