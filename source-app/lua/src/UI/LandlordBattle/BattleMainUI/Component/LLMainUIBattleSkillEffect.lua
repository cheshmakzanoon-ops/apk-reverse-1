local base = UIBaseContainer
local LLMainUIBattleSkillEffect = BaseClass("LLMainUIBattleSkillEffect", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLMainUIBattleSkillEffect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIBattleSkillEffect:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIBattleSkillEffect:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compItem1 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textEffectText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compItem2 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.imgEffectIcon2 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textEffectText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function LLMainUIBattleSkillEffect:ComponentDestroy()
  self.viewSkin = nil
  self.compItem1 = nil
  self.textEffectText1 = nil
  self.compItem2 = nil
  self.imgEffectIcon2 = nil
  self.textEffectText2 = nil
end

function LLMainUIBattleSkillEffect:DataDefine()
end

function LLMainUIBattleSkillEffect:DataDestroy()
end

function LLMainUIBattleSkillEffect:OnAddListener()
  base.OnAddListener(self)
end

function LLMainUIBattleSkillEffect:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMainUIBattleSkillEffect:SetShow(skillId, numHole, numSolider)
  local stateTemplate = DataCenter.StatusManager:GetTemplate(skillId)
  if stateTemplate then
    local iconName, extr, hex
    local num1, num2 = numHole, numSolider
    iconName = stateTemplate.icon
    extr = "+"
    if num1 == nil then
      num1 = string.formatDecimalDown(tonumber(stateTemplate.effect_num), 0)
    end
    hex = "fb7156"
    self.textEffectText1:SetText(num1 ~= 0 and extr .. num1 or num1)
    self.textEffectText1:SetColorHex(hex)
    if num2 ~= nil then
      self.textEffectText2:SetText(num2 ~= 0 and extr .. num2 or num2)
      self.textEffectText2:SetColorHex(hex)
      self.textEffectText2.transform.parent.gameObject:SetActive(true)
    else
      self.textEffectText2.transform.parent.gameObject:SetActive(false)
    end
  end
end

return LLMainUIBattleSkillEffect
