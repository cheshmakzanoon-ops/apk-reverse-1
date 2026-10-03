local T11IdleGameTemplate = BaseClass("T11IdleGameTemplate")
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameTemplate:__init()
  self.id = 0
  self.stage_name = ""
  self.stage_order = 0
  self.node_num = 0
  self.node_interval = 0
  self.first_boss_id = ""
  self.non_event_node_weight = ""
  self.idle_end_reward = ""
  self.back_pic_loop = {}
  self.preview_id = 0
  self.sceneDataList = nil
end

function T11IdleGameTemplate:__delete()
  self.id = nil
  self.stage_name = nil
  self.stage_order = nil
  self.node_num = nil
  self.node_interval = nil
  self.first_boss_id = nil
  self.non_event_node_weight = nil
  self.idle_end_reward = nil
  self.back_pic_loop = nil
  self.preview_id = nil
  self.sceneDataList = nil
end

function T11IdleGameTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.stage_name = rowData:getValue("stage_name") or ""
  self.stage_order = rowData:getValue("stage_order") or 0
  self.node_num = rowData:getValue("node_num") or 0
  self.node_interval = rowData:getValue("node_interval") or 0
  self.first_boss_id = rowData:getValue("first_boss_id") or ""
  self.non_event_node_weight = rowData:getValue("non_event_node_weight") or ""
  self.idle_end_reward = rowData:getValue("idle_end_reward") or ""
  self.back_pic_loop = rowData:getValue("back_pic_loop") or {}
  self.preview_id = rowData:getValue("preview_id") or 0
end

function T11IdleGameTemplate:GetSceneDataList()
  if self.sceneDataList == nil then
    self.sceneDataList = {}
    for i, v in ipairs(self.back_pic_loop) do
      local strPair = string.split(v, ";")
      if #strPair == 2 then
        local data = {
          prefabPath = strPair[1],
          length = tonumber(strPair[2]) or 1024
        }
        table.insert(self.sceneDataList, data)
      end
    end
  end
  return self.sceneDataList
end

function T11IdleGameTemplate:GetSceneDataByIndex(index)
  local sceneDataList = self:GetSceneDataList()
  if table.IsNullOrEmpty(sceneDataList) then
    return nil
  end
  local count = #sceneDataList
  local realIndex = (index - 1) % count + 1
  return sceneDataList[realIndex]
end

function T11IdleGameTemplate:GetState()
  local curLevel = DataCenter.T11IdleGameDataManager:GetIdleGameCurLevel()
  if self.stage_order == curLevel then
    return Const.LevelState.Current
  elseif curLevel > self.stage_order then
    return Const.LevelState.Finished
  else
    return Const.LevelState.Locked
  end
end

function T11IdleGameTemplate:GetTotalTimeMS()
  return self.node_num * self.node_interval * 1000
end

function T11IdleGameTemplate:IsFinalLevel()
  local allLevelTemplates = DataCenter.T11IdleGameTemplateManager:GetAllLevelTemplatesInOrder()
  if not table.IsNullOrEmpty(allLevelTemplates) then
    local lastLevel = allLevelTemplates[#allLevelTemplates]
    return lastLevel.stage_order == self.stage_order
  else
    return true
  end
end

function T11IdleGameTemplate:GetFirstBossTemplate()
  return DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(self.first_boss_id)
end

function T11IdleGameTemplate:GetPreviewData()
  if self.preview_id > 0 then
    return LocalController:instance():getLine(TableName.LW_IDLE_GAME_REWARD_PREVIEW, self.preview_id)
  end
end

function T11IdleGameTemplate:GetName()
  return Localization:GetString(self.stage_name, self.stage_order)
end

return T11IdleGameTemplate
