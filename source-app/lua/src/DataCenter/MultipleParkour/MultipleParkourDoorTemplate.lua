local MultipleParkourDoorTemplate = BaseClass("MultipleParkourDoorTemplate")

function MultipleParkourDoorTemplate:InitData(row)
  self.id = tonumber(row:getValue("id"))
  self.type = tonumber(row:getValue("type"))
  self.map_type = tonumber(row:getValue("map_type"))
  self.loading_time = tonumber(row:getValue("loading_time"))
  self.base_score = tonumber(row:getValue("base_score"))
  self.day_times = tonumber(row:getValue("day_times"))
  self.total_limit = tonumber(row:getValue("total_limit"))
  self.match_time = tonumber(row:getValue("match_time"))
  self.sound_id_bgm = tonumber(row:getValue("sound_id_bgm")) or 0
  self.top_score = tonumber(row:getValue("top_score")) or 0
  self.choose_speed = tonumber(row:getValue("choose_speed"))
  self.choose_over_speed = tonumber(row:getValue("choose_over_speed"))
  self.door_space = tonumber(row:getValue("door_space"))
  self.boss_over_time = tonumber(row:getValue("boss_over_time"))
  self.emoji_percentage = tonumber(row:getValue("emoji_percentage"))
  self.win_emoji = row:getValue("win_emoji")
  self.lose_emoji = row:getValue("lose_emoji")
  local scene = row:getValue("scene")
  self.sceneGroupCfg = {}
  local sceneGroupArray = string.split(scene, "|")
  for _, sceneGroup in ipairs(sceneGroupArray) do
    local sceneIdArray = string.split(sceneGroup, ",")
    local offset = 0
    local tmpSceneCfg = {}
    tmpSceneCfg.cfgArr = {}
    for _, sceneId in ipairs(sceneIdArray) do
      local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), sceneId)
      local sceneCfg = {}
      sceneCfg.meta = sceneMeta
      sceneCfg.offset = offset
      sceneCfg.isDeco = false
      table.insert(tmpSceneCfg.cfgArr, sceneCfg)
      offset = offset + sceneMeta.scene_size
      tmpSceneCfg.totalSize = offset
    end
    table.insert(self.sceneGroupCfg, tmpSceneCfg)
  end
  self.reward_show = row:getValue("reward_show")
end

function MultipleParkourDoorTemplate:GetRewardShowList()
  if self.rewardShowList == nil then
    self.rewardShowList = {}
    if not string.IsNullOrEmpty(self.reward_show) then
      local rewardStrVec = string.split_ss_array(self.reward_show, "|")
      table.walk(rewardStrVec, function(k, v)
        local str = v
        local item = DataCenter.RewardManager:ParseOneRewardStr(str)
        if item then
          table.insert(self.rewardShowList, item)
        end
      end)
    end
  end
  return self.rewardShowList
end

return MultipleParkourDoorTemplate
