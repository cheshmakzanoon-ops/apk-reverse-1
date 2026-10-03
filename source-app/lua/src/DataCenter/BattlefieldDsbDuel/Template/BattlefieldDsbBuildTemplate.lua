local base = require("Scene.Battlefield.Common.BattlefieldBuildTemplate")
local BattlefieldDsbBuildTemplate = BaseClass("BattlefieldDsbBuildTemplate", base)

function BattlefieldDsbBuildTemplate:ResetData()
  base.ResetData(self)
  self.rulesPath = ""
end

function BattlefieldDsbBuildTemplate:InitData(row)
  base.InitData(self, row)
  if self:IsScoreBox() then
    self.rulesPath = self.pic
  else
    self.rulesPath = string.format("%s11", self.pic)
  end
end

function BattlefieldDsbBuildTemplate:GetRulesIconPath()
  return self.rulesPath
end

function BattlefieldDsbBuildTemplate:GetIconPath(role)
  if self:IsScoreBox() then
    return self.pic
  end
  local color = BattlefieldDsbDuelUtils.GetColorByRoleType(role, true)
  if color then
    return string.format("%s%s", self.pic, color.buildTemplateIconIndex)
  else
    return self.rulesPath
  end
end

function BattlefieldDsbBuildTemplate:GetDetailPath(role)
  return self:GetIconPath(role)
end

return BattlefieldDsbBuildTemplate
