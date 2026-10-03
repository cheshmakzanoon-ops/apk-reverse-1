local FormationTacticalCardSkillState = BaseClass("FormationTacticalCardSkillState", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function FormationTacticalCardSkillState:OnCreate()
  base.OnCreate(self)
  self.bg = self:TryAddComponent(UIImage, "bg")
  self.deskIcon = self:TryAddComponent(UIImage, "deskIcon")
  self.bgRaw = self:TryAddComponent(UIRawImage, "bg")
  self.desc = self:TryAddComponent(UITextMeshProUGUIEx, "desc")
  self.timeTick = self:TryAddComponent(UITextMeshProUGUIEx, "timeTick")
end

function FormationTacticalCardSkillState:OnDestroy()
  base.OnDestroy(self)
end

function FormationTacticalCardSkillState:OnEnable()
  base.OnEnable(self)
end

function FormationTacticalCardSkillState:OnDisable()
  base.OnDisable(self)
end

function FormationTacticalCardSkillState:SetBg(bgPath)
  if self.bg then
    self.bg:LoadSpriteAsync(bgPath)
  end
  if self.bgRaw then
    self.bgRaw:LoadSpriteAsync(bgPath)
  end
end

function FormationTacticalCardSkillState:SetDesc(desc)
  if self.desc then
    self.desc:SetText(desc)
  end
end

function FormationTacticalCardSkillState:SetBgColorHex(colorHex)
  if self.bg then
    self.bg:SetColorHex(colorHex)
  end
end

function FormationTacticalCardSkillState:SetTickTime(tick)
  if self.timeTick then
    self.timeTick:SetText(tick)
  end
end

return FormationTacticalCardSkillState
