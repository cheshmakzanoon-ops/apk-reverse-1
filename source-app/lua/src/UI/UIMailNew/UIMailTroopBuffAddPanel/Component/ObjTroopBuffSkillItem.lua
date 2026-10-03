local ObjTroopBuffSkillItem = BaseClass("ObjTroopBuffSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_imgIcon = "bg/imgIcon"
local _cp_txtSkillLv = "bg/txtSkillLv"

function ObjTroopBuffSkillItem:OnCreate()
  base.OnCreate(self)
  self._imgIcon = self:AddComponent(UIImage, _cp_imgIcon)
  self._txtSkillLv = self:AddComponent(UIText, _cp_txtSkillLv)
end

function ObjTroopBuffSkillItem:SetData(param)
  local skillId = param.skillId
  local skillLv = param.skillLv
  self._txtSkillLv:SetText(skillLv)
  local skillIcon = HeroUtils.GetSkillIcon(skillId)
  self._imgIcon:LoadSprite(skillIcon)
end

return ObjTroopBuffSkillItem
