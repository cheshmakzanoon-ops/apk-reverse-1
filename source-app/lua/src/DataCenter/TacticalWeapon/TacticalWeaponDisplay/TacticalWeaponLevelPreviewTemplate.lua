local TacticalWeaponLevelPreviewTemplate = BaseClass("TacticalWeaponLevelPreviewTemplate")

function TacticalWeaponLevelPreviewTemplate:__init()
  self.id = 0
  self.display_level = 0
  self.location_level = 0
  self.skill_level = 0
  self.display_drone_icon = 0
  self.display_drone_text = ""
end

function TacticalWeaponLevelPreviewTemplate:__delete()
  self.id = nil
  self.display_level = nil
  self.location_level = nil
  self.skill_level = nil
  self.display_drone_icon = nil
  self.display_drone_text = nil
  self.airDescTitle = nil
  self.airDesc = nil
end

function TacticalWeaponLevelPreviewTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.display_level = row:getValue("display_level") or 0
  self.location_level = row:getValue("location_level") or 0
  self.skill_level = row:getValue("skill_level") or 0
  self.display_drone_icon = row:getValue("display_drone_icon") or 0
  self.display_drone_text = row:getValue("display_drone_text") or ""
  local splitStr = string.split(self.display_drone_text, ";")
  if 2 <= #splitStr then
    self.airDescTitle = splitStr[1]
    self.airDesc = splitStr[2]
  end
end

return TacticalWeaponLevelPreviewTemplate
