local LWMainEpidemicZoneSkillEffect = BaseClass("LWMainEpidemicZoneSkillEffect", UIBaseContainer)
local base = UIBaseContainer
local actMgr = DataCenter.ActEpidemicZoneManager
local item1_path = "Item1"
local text1_path = "Item1/EffectText1"
local item2_path = "Item2"
local icon2_path = "Item2/EffectIcon2"
local text2_path = "Item2/EffectText2"

function LWMainEpidemicZoneSkillEffect:OnCreate()
  base.OnCreate(self)
  self.item1 = self:AddComponent(UIBaseContainer, item1_path)
  self.text1 = self:AddComponent(UITextMeshProUGUIEx, text1_path)
  self.item2 = self:AddComponent(UIBaseContainer, item2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.text2 = self:AddComponent(UITextMeshProUGUIEx, text2_path)
end

function LWMainEpidemicZoneSkillEffect:OnDestroy()
  self.item1 = nil
  self.text1 = nil
  self.item2 = nil
  self.icon2 = nil
  self.text2 = nil
  base.OnDestroy(self)
end

function LWMainEpidemicZoneSkillEffect:SetShow(skillId, numHole, numSolider)
  local template = actMgr:GetTemplateSkillById(skillId)
  local iconName, extr, hex
  local num1, num2 = numHole, numSolider
  if skillId == EpidemicSkillId.Hospital then
    iconName = "wxy_jishashibing_lanbing.png"
    extr = "+"
    if num1 == nil then
      num1 = string.formatDecimalDown(template.cureHole / template.effPartTime, 0) .. "/s"
    end
    if num2 == nil then
      num2 = string.formatDecimalDown(template.cureSolider / template.effPartTime, 0) .. "/s"
    end
    hex = "5fef87"
  else
    iconName = skillId == EpidemicSkillId.Judgment and "mjc_yibianjinqu_jifei_icon" or "wxy_jishashibing_hongbing.png"
    extr = skillId == EpidemicSkillId.Judgment and "" or "-"
    if num1 == nil then
      num1 = string.formatDecimalDown(template.damageHole / template.effPartTime, 0) .. "/s"
    end
    if num2 == nil and template.damageSolider ~= nil then
      num2 = string.formatDecimalDown(template.damageSolider / template.effPartTime, 0) .. "/s"
    end
    hex = "fb7156"
  end
  self.icon2:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldEpidemicPath, iconName))
  self.text1:SetText(num1 ~= 0 and extr .. num1 or num1)
  self.text1:SetColorHex(hex)
  if num2 ~= nil then
    self.text2:SetText(num2 ~= 0 and extr .. num2 or num2)
    self.text2:SetColorHex(hex)
    self.text2.transform.parent.gameObject:SetActive(true)
  else
    self.text2.transform.parent.gameObject:SetActive(false)
  end
end

return LWMainEpidemicZoneSkillEffect
