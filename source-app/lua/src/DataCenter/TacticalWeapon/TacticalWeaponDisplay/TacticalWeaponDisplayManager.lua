local TacticalWeaponDisplayManager = BaseClass("TacticalWeaponDisplayManager")
local TacticalWeaponLevelPreviewTemplate = require("DataCenter.TacticalWeapon.TacticalWeaponDisplay.TacticalWeaponLevelPreviewTemplate")

function TacticalWeaponDisplayManager:__init()
end

function TacticalWeaponDisplayManager:__delete()
end

function TacticalWeaponDisplayManager:GetTemplateList()
  if not self.displayConfigList then
    self.displayConfigList = {}
    LocalController:instance():visitTable(TableName.LW_UAV_LEVEL_PREVIEW, function(id, line)
      local template = TacticalWeaponLevelPreviewTemplate.New()
      template:InitData(line)
      table.insert(self.displayConfigList, template)
    end)
    if #self.displayConfigList > 1 then
      table.sort(self.displayConfigList, function(a, b)
        return a.location_level < b.location_level
      end)
    end
  end
  return self.displayConfigList
end

return TacticalWeaponDisplayManager
