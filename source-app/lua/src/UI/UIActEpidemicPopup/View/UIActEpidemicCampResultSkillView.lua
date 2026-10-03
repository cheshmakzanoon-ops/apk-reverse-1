local UIActEpidemicCampResultSkillView = BaseClass("UIActEpidemicCampResultSkillView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActEpidemicSkillItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicSkillItem")

function UIActEpidemicCampResultSkillView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIActEpidemicCampResultSkillView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicCampResultSkillView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBackground = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBackground:SetOnClick(function()
    self:OnBtnBackgroundClick()
  end)
  self.compSkill1 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compSkill2 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textTmpTitleTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSkill3 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  local skillItems = {}
  for i = 1, 3 do
    local comp = self["compSkill" .. i]
    local icon = comp:AddComponent(UIActEpidemicSkillItem, "ItemIcon")
    local name = comp:AddComponent(UITextMeshProUGUIEx, "NameText")
    local desc = comp:AddComponent(UITextMeshProUGUIEx, "DescText")
    skillItems[i] = {
      comp = comp,
      icon = icon,
      name = name,
      desc = desc
    }
  end
  self.skillItems = skillItems
end

function UIActEpidemicCampResultSkillView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBackground = nil
  self.compSkill1 = nil
  self.compSkill2 = nil
  self.textTmpTitleTop = nil
  self.compSkill3 = nil
  self.compContent = nil
end

function UIActEpidemicCampResultSkillView:DataDefine()
  self.groupIndex = self:GetUserData()
end

function UIActEpidemicCampResultSkillView:DataDestroy()
end

function UIActEpidemicCampResultSkillView:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicCampResultSkillView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicCampResultSkillView:OnBtnBackgroundClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicCampResultSkillView:RefreshUI()
  local titleKey = self.groupIndex == ActEpidemicUtils.Group1 and "YiBianJinQu_trivial_tips_5" or "YiBianJinQu_trivial_tips_6"
  self.textTmpTitleTop:SetLocalText("YiBianJinQu_match_result_tips_1", Localization:GetString(titleKey))
  for i = 1, 3 do
    local skillID
    if i == 1 then
      skillID = ActEpidemicUtils.GetLordSkillArbiter()
    elseif i == 2 then
      skillID = ActEpidemicUtils.GetLordSkillPassive()
    else
      skillID = ActEpidemicUtils.GetLordSkillRandom(self.groupIndex)
    end
    local skillData = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillID)
    local skillItem = self.skillItems[i]
    if skillData then
      skillItem.comp:SetActive(true)
      skillItem.icon:Setup(skillID)
      skillItem.name:SetLocalText(skillData.name)
      skillItem.desc:SetLocalText(skillData.brief)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(skillItem.desc.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(skillItem.comp.rectTransform)
    else
      skillItem.comp:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.rectTransform)
end

return UIActEpidemicCampResultSkillView
