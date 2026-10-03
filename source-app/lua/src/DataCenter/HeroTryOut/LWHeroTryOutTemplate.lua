local LWHeroTryOutTemplate = BaseClass("LWHeroTryOutTemplate")

function LWHeroTryOutTemplate:__init()
  self.id = 0
  self.hero_id = 0
  self.tag_id = 0
  self.group_id = 0
  self.order = 0
  self.army_list = ""
  self.lattice_type = 0
  self.stage_type = 0
  self.stage_id = 0
  self.reward = 0
  self.name = ""
  self.desc = ""
  self.target = 0
  self.lw_scene_id = 0
  self.uav_id = 0
  self.uav_level = 0
  self.plot_enter = 0
  self.plot_back = 0
  self.monster_born = {}
  self.battle_skip_on = 0
end

function LWHeroTryOutTemplate:__delete()
  self.id = nil
  self.hero_id = nil
  self.tag_id = nil
  self.group_id = nil
  self.order = nil
  self.army_list = nil
  self.lattice_type = nil
  self.stage_type = nil
  self.stage_id = nil
  self.reward = nil
  self.name = nil
  self.desc = nil
  self.target = nil
  self.lw_scene_id = nil
  self.uav_id = nil
  self.uav_level = nil
  self.plot_enter = nil
  self.plot_back = nil
  self.monster_born = nil
  self.battle_skip_on = nil
end

function LWHeroTryOutTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.hero_id = rowData:getValue("hero_id") or 0
  self.tag_id = rowData:getValue("tag_id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.order = rowData:getValue("order") or 0
  self.army_list = rowData:getValue("army_list") or ""
  self.lattice_type = rowData:getValue("lattice_type") or 0
  self.stage_type = rowData:getValue("stage_type") or 0
  self.stage_id = rowData:getValue("stage_id") or 0
  self.reward = rowData:getValue("reward") or 0
  self.name = rowData:getValue("name") or ""
  self.desc = rowData:getValue("desc") or ""
  self.target = rowData:getValue("target") or 0
  self.lw_scene_id = rowData:getValue("lw_scene_id") or 0
  self.uav_id = rowData:getValue("uav_id") or 0
  self.uav_level = rowData:getValue("uav_level") or 0
  self.plot_enter = rowData:getValue("plot_enter") or 0
  self.plot_back = rowData:getValue("plot_back") or 0
  self.monster_born = rowData:getValue("monster_born") or {}
  self.battle_skip_on = rowData:getValue("battle_skip_on") or 0
end

function LWHeroTryOutTemplate:GetRewardsForShow()
  return DataCenter.RewardTemplateManager:GetList(self.reward) or {}
end

function LWHeroTryOutTemplate:GetState()
  local finishedOrder = 0
  local userData = DataCenter.HeroTryOutManager:GetUserData()
  if userData ~= nil then
    local finishedId = userData:GetFinishedTryOutIdByTagAndGroup(self.hero_id, self.tag_id, self.group_id)
    if finishedId ~= nil then
      local finishedTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(finishedId)
      if finishedTemplate ~= nil then
        finishedOrder = finishedTemplate.order
      end
    end
  end
  if finishedOrder >= self.order then
    return DataCenter.HeroTryOutManager.State.Finished
  elseif self.order == finishedOrder + 1 then
    return DataCenter.HeroTryOutManager.State.Going
  else
    return DataCenter.HeroTryOutManager.State.Locked
  end
end

function LWHeroTryOutTemplate:GetSelfArmyTemplateList()
  local res = {}
  if not string.IsNullOrEmpty(self.army_list) then
    local splitStr = string.split(self.army_list, ",")
    for _, v in ipairs(splitStr) do
      local lwArmyTemplate = DataCenter.LWArmyTemplateManager:GetArmyTemplate(v)
      if lwArmyTemplate ~= nil then
        table.insert(res, lwArmyTemplate)
      end
    end
  end
  return res
end

function LWHeroTryOutTemplate:TryPlayEnterPlot(callback)
  if self.plot_enter and self.plot_enter > 0 then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.plot_enter,
      hideMainUI = false,
      callback = callback
    })
  elseif callback then
    callback()
  end
end

function LWHeroTryOutTemplate:TryPlayBackPlot(callback)
  if self.plot_back and self.plot_back > 0 then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.plot_back,
      hideMainUI = false,
      callback = callback
    })
  elseif callback then
    callback()
  end
end

function LWHeroTryOutTemplate:OpenHeroDetail()
  DataCenter.HeroTryOutManager:OpenHeroDetail(self.hero_id)
end

function LWHeroTryOutTemplate:GetPlotIdByMonsterBornId(id)
  if self.monster_born then
    for i, v in pairs(self.monster_born) do
      if i == id then
        return v
      end
    end
  end
end

function LWHeroTryOutTemplate:IsFinished()
  local userData = DataCenter.HeroTryOutManager:GetUserData()
  if userData == nil then
    Logger.LogError("HeroTryOutTemplate:IsFinished userData is nil, \229\156\168\230\156\141\229\138\161\229\153\168\230\149\176\230\141\174\230\156\170\232\191\148\229\155\158\229\137\141\239\188\140\228\184\141\229\186\148\232\175\165\232\176\131\231\148\168\232\191\153\228\184\170\230\142\165\229\143\163\239\188\140\230\140\137\231\133\167\229\183\178\229\174\140\230\136\144\228\186\134\229\164\132\231\144\134")
    return true
  end
  local finishedId = userData:GetFinishedTryOutIdByTagAndGroup(self.hero_id, self.tag_id, self.group_id)
  if finishedId == nil then
    return false
  end
  local finishedTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(finishedId)
  if finishedTemplate == nil then
    Logger.LogError("HeroTryOutTemplate:IsFinished finishedTemplate is nil, id:" .. tostring(finishedId))
    return true
  end
  return self.order <= finishedTemplate.order
end

function LWHeroTryOutTemplate:IsCanSkip()
  return self.battle_skip_on == 1
end

return LWHeroTryOutTemplate
