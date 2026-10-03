local ActivityTorchRelayGrowUpConfigTemplate = BaseClass("ActivityTorchRelayGrowUpConfigTemplate")

function ActivityTorchRelayGrowUpConfigTemplate:__init()
  self.id = 0
  self.grow_up_group = 0
  self.attribute = 0
  self.level = 0
  self.value = 0
  self.cost = ""
  self.value_show = ""
  self.rare_cheer_show = ""
  self.cheer_show = ""
  self.cheer_scene_position = ""
  self.costId = nil
  self.costNum = nil
end

function ActivityTorchRelayGrowUpConfigTemplate:__delete()
  self.id = nil
  self.grow_up_group = nil
  self.attribute = nil
  self.level = nil
  self.value = nil
  self.cost = nil
  self.value_show = nil
  self.rare_cheer_show = nil
  self.cheer_show = nil
  self.cheer_scene_position = nil
  self.costId = nil
  self.costNum = nil
end

function ActivityTorchRelayGrowUpConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.grow_up_group = tonumber(row:getValue("grow_up_group")) or 0
  self.attribute = tonumber(row:getValue("attribute")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  self.value = tonumber(row:getValue("value")) or 0
  self.cost = row:getValue("cost") or ""
  self.value_show = row:getValue("value_show") or ""
  self.rare_cheer_show = row:getValue("rare_cheer_show") or ""
  self.cheer_show = row:getValue("cheer_show") or ""
  self.cheer_scene_position = row:getValue("cheer_scene_position") or ""
  if not string.IsNullOrEmpty(self.cost) then
    local splitCost = string.split(self.cost, ";")
    if #splitCost == 2 then
      self.costId = tonumber(splitCost[1])
      self.costNum = tonumber(splitCost[2])
    end
  end
end

function ActivityTorchRelayGrowUpConfigTemplate:GetAdvanceCheerShowData()
  if not string.IsNullOrEmpty(self.rare_cheer_show) then
    local str = string.split(self.rare_cheer_show, ";")
    if #str == 4 then
      return {
        shadowPreZDistance = checknumber(str[1]),
        shadowPlayTime = checknumber(str[2]),
        shadowPlayZDistance = checknumber(str[3]),
        dropItemPreZDistance = checknumber(str[4])
      }
    end
  end
end

function ActivityTorchRelayGrowUpConfigTemplate:GetNormalCheerShowData()
  if not string.IsNullOrEmpty(self.cheer_show) then
    local str = string.split(self.cheer_show, ";")
    if #str == 2 then
      return {
        triggerDistance = checknumber(str[1]),
        triggerGapTime = checknumber(str[2])
      }
    end
  end
end

function ActivityTorchRelayGrowUpConfigTemplate:GetCheerIndexList()
  local res = {}
  if not string.IsNullOrEmpty(self.cheer_scene_position) then
    local str = string.split(self.cheer_scene_position, "|")
    if 0 < #str then
      local index = math.random(1, #str)
      local str2 = str[index]
      if str2 then
        local str3 = string.split(str2, ";")
        for i, v in pairs(str3) do
          table.insert(res, checknumber(v))
        end
      end
    end
  end
  return res
end

return ActivityTorchRelayGrowUpConfigTemplate
