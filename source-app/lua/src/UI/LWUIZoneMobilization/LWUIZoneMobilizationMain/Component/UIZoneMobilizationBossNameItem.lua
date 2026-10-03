local base = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationNameItem")
local UIZoneMobilizationBossNameItem = BaseClass("UIZoneMobilizationBossNameItem", base)
local Localization = CS.GameEntry.Localization

function UIZoneMobilizationBossNameItem:OnCreate()
  base.OnCreate(self)
end

function UIZoneMobilizationBossNameItem:OnDestroy()
  base.OnDestroy(self)
end

function UIZoneMobilizationBossNameItem:AddListeners()
end

function UIZoneMobilizationBossNameItem:RemoveListeners()
end

function UIZoneMobilizationBossNameItem:SetNameText(bossId, serverId, color)
  if bossId then
    local bossData = LocalController:instance():getLine(TableName.ZoneMobilizationBoss, bossId)
    if bossData then
      local monsterId = bossData.world_monster
      if monsterId then
        local nameId = GetTableData(TableName.Monster, monsterId, "name")
        local name = Localization:GetString(nameId)
        local str = Localization:GetString("zone_mobilization_boss_name_include", color, serverId, name)
        self.title_text:SetText(str)
      end
    end
  end
end

return UIZoneMobilizationBossNameItem
