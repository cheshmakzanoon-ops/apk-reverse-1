local FormationTacticalCardSkillStateV2 = BaseClass("FormationTacticalCardSkillStateV2", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function FormationTacticalCardSkillStateV2:OnCreate()
  base.OnCreate(self)
  self.bg = self:TryAddComponent(UIImage, "bg")
  self.deskIcon = self:TryAddComponent(UIImage, "deskIcon")
  self.bgRaw = self:TryAddComponent(UIRawImage, "bg")
  self.desc = self:TryAddComponent(UITextMeshProUGUIEx, "desc")
  self.timeTick = self:TryAddComponent(UITextMeshProUGUIEx, "timeTick")
end

function FormationTacticalCardSkillStateV2:OnDestroy()
  base.OnDestroy(self)
end

function FormationTacticalCardSkillStateV2:OnEnable()
  base.OnEnable(self)
end

function FormationTacticalCardSkillStateV2:OnDisable()
  base.OnDisable(self)
end

function FormationTacticalCardSkillStateV2:SetBg(bgPath)
  if self.bg then
    self.bg:LoadSpriteAsync(bgPath)
  end
  if self.bgRaw then
    self.bgRaw:LoadSpriteAsync(bgPath)
  end
end

function FormationTacticalCardSkillStateV2:SetDesc(desc)
  if self.desc then
    self.desc:SetText(desc)
  end
end

function FormationTacticalCardSkillStateV2:SetBgColorHex(colorHex)
  if self.bg then
    self.bg:SetColorHex(colorHex)
  end
end

function FormationTacticalCardSkillStateV2:SetTickTime(tick)
  if self.timeTick then
    self.timeTick:SetText(tick)
  end
end

return FormationTacticalCardSkillStateV2
