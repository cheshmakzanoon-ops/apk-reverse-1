local AdvancedChallengeBossTemplateManager = BaseClass("AdvancedChallengeBossTemplateManager")
local AdvancedChallengeBossTemplate = require("DataCenter.ActivityListData.ActKillZombie.AdvancedChallengeBossTemplate")

function AdvancedChallengeBossTemplateManager:__init()
  self.bossTemps = {}
end

function AdvancedChallengeBossTemplateManager:__delete()
  self:Destroy()
end

function AdvancedChallengeBossTemplateManager:Destroy()
  for _, v in pairs(self.bossTemps) do
    v:Delete()
  end
  self.bossTemps = nil
end

function AdvancedChallengeBossTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.bossTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.AdvancedChallengeBoss), intId)
    if line ~= nil then
      local item = AdvancedChallengeBossTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.bossTemps[item.id] = item
      end
    end
  end
  return self.bossTemps[intId]
end

return AdvancedChallengeBossTemplateManager
