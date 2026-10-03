local ParkourScoreTierTemplateManager = BaseClass("ParkourScoreTierTemplateManager")
local ParkourScoreTierTemplate = require("DataCenter.LWBattle.Logic.GhostParkour.Data.ParkourScoreTierTemplate")

function ParkourScoreTierTemplateManager:__init()
  self.tierTemps = {}
end

function ParkourScoreTierTemplateManager:__delete()
  self:Destroy()
end

function ParkourScoreTierTemplateManager:Destroy()
  for _, v in pairs(self.tierTemps) do
    v:Delete()
  end
  self.tierTemps = nil
end

function ParkourScoreTierTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.tierTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.parkour_score_tier), intId)
    if line ~= nil then
      local item = ParkourScoreTierTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.tierTemps[item.id] = item
      end
    end
  end
  return self.tierTemps[intId]
end

function ParkourScoreTierTemplateManager:GetRewards(rewardId)
  local res = {}
  if rewardId and 0 < rewardId then
    local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
    if line ~= nil then
      local MyStrNull = string.IsNullOrEmpty
      local MySplit = string.split
      local MyInsert = table.insert
      local itemValues = line:getValue("item") or ""
      local numValues = line:getValue("num") or ""
      if not MyStrNull(itemValues) and not MyStrNull(numValues) then
        local ids = MySplit(itemValues, "|")
        local nums = MySplit(numValues, "|")
        if ids ~= nil and 0 < #ids then
          for i, id in pairs(ids) do
            local oneData = {}
            oneData.itemId = id
            oneData.count = nums[i] or 0
            oneData.rewardType = RewardType.GOODS
            MyInsert(res, oneData)
          end
        end
      end
      local itemValuesRes = line:getValue("resource_randomtype") or ""
      local numValuesRes = line:getValue("resource_rate") or ""
      if not MyStrNull(itemValuesRes) and not MyStrNull(numValuesRes) then
        local idsRes = MySplit(itemValuesRes, "|")
        local numsRes = MySplit(numValuesRes, "|")
        if idsRes ~= nil and 0 < #idsRes then
          for i, id in pairs(idsRes) do
            local oneData = {}
            oneData.itemId = id
            local numss = MySplit(numsRes[i], ";")
            oneData.count = numss[1] or 0
            oneData.rewardType = RewardType.RESOURCE
            MyInsert(res, oneData)
          end
        end
      end
    end
  end
  return res
end

return ParkourScoreTierTemplateManager
