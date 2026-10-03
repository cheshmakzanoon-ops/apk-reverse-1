local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UITCCardSkillTipView = BaseClass("UITCCardSkillTipView", base)
local Localization = CS.GameEntry.Localization

function UITCCardSkillTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textCondition = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgSkillIcon = self.viewSkin:AddComponent(self, UIImage, 4)
end

function UITCCardSkillTipView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textCondition = nil
  self.textDes = nil
  self.imgSkillIcon = nil
  base.ComponentDestroy(self)
end

function UITCCardSkillTipView:DataDefine()
end

function UITCCardSkillTipView:DataDestroy()
end

function UITCCardSkillTipView:OnAddListener()
  base.OnAddListener(self)
end

function UITCCardSkillTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITCCardSkillTipView:RefreshShow()
  base.RefreshShow(self)
  if not self.param or not self.param.skillData then
    Logger.LogError("param is nil")
    return
  end
  local skillData = self.param.skillData
  if skillData.template.name then
    self.textTitle:SetText(Localization:GetString(skillData.template.name))
  end
  if skillData.template.desc then
    self.textDes:SetText(skillData.template:GetDesc())
  end
  self.bgRoot:SetSizeDeltaXY(self.param.width + 120, 0)
  self.imgSkillIcon:LoadSpriteAuto(skillData.template:GetIcon())
end

return UITCCardSkillTipView
