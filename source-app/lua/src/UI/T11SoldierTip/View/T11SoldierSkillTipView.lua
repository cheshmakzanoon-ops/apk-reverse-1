local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local T11SoldierSkillTipView = BaseClass("T11SoldierSkillTipView", base)
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local t11_soldier_skill_item_4_skill_tip_path = "Root/ImgBg/SkillIconRoot/T11SoldierSkillItem_4_SkillTip"

function T11SoldierSkillTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textCondition = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.skillIconItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_4_skill_tip_path)
end

function T11SoldierSkillTipView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.viewSkin = nil
  self.textTitle = nil
  self.textDes = nil
  self.textCondition = nil
end

function T11SoldierSkillTipView:OnAddListener()
  base.OnAddListener(self)
end

function T11SoldierSkillTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SoldierSkillTipView:RefreshShow()
  base.RefreshShow(self)
  if not self.param or not self.param.skillData then
    Logger.LogError("param is nil")
    return
  end
  local skillData = self.param.skillData
  local fixedSoldierType = self.param.fixedSoldierType
  if fixedSoldierType == SoldierType.Mummy then
    if skillData.effect_mummy_name then
      self.textTitle:SetText(Localization:GetString(skillData.effect_mummy_name))
    else
      self.textTitle:SetText("")
    end
    if skillData.effect_mummy_desc then
      self.textDes:SetText(Localization:GetString(skillData.effect_mummy_desc))
    else
      self.textDes:SetText("")
    end
  else
    if skillData.name then
      self.textTitle:SetText(Localization:GetString(skillData.name))
    else
      self.textTitle:SetText("")
    end
    if skillData.desc then
      self.textDes:SetText(Localization:GetString(skillData.desc))
    else
      self.textDes:SetText("")
    end
  end
  self.bgRoot:SetSizeDeltaXY(self.param.width + 120, 0)
  self.showLockImage = self.param.showLockImage
  self.skillIconItem:Init(self.param.skillData, self.showLockImage, true, fixedSoldierType)
  local showConditionText = not self.param.skillData.isUnlock and self.showLockImage
  self.textCondition:SetActive(showConditionText)
  if showConditionText then
    if skillData.effect_unlock_info then
      self.textCondition:SetText(Localization:GetString(skillData.effect_unlock_info))
    else
      self.textCondition:SetActive(false)
    end
  end
end

return T11SoldierSkillTipView
