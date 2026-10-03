local InteractionBubbleManager = BaseClass("InteractionBubbleManager")
local rapidjson = require("rapidjson")
local OpenWindowWhiteList = {
  UIWindowNames.UIChatNew_v2,
  UIWindowNames.UILWAlMail_v2,
  UIWindowNames.UIGovernmentEmail_v2,
  UIWindowNames.UIPostAllianceNotice
}

function InteractionBubbleManager:__init()
  self.flyInTaskQueue = {}
  EventManager:GetInstance():AddListener(EventId.OnAfterWindowDestroy, self.OnWindowDestroy)
end

function InteractionBubbleManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnAfterWindowDestroy, self.OnWindowDestroy)
end

function InteractionBubbleManager:OnWindowDestroy()
  DataCenter.InteractionBubbleManager:CheckOpenWindow()
end

function InteractionBubbleManager:CheckOpenWindow()
  local open = false
  for _, window in ipairs(OpenWindowWhiteList) do
    if UIManager:GetInstance():IsWindowOpen(window) then
      open = true
      break
    end
  end
  if self:HasFlyInTask() and not open then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIInteractionBubble, {anim = true})
  end
end

function InteractionBubbleManager:HandlePushUiPopInfoMessage(msg)
  local settingKey = InteractionBubbleType2SettingKey[msg.type]
  if settingKey and LuaEntry.Player:GetUserSetting(settingKey) == "1" then
    return
  end
  table.insert(self.flyInTaskQueue, msg)
  DataCenter.InteractionBubbleManager:CheckOpenWindow()
end

function InteractionBubbleManager:HasFlyInTask()
  return self.flyInTaskQueue[1]
end

function InteractionBubbleManager:GetFlyInTaskCount()
  return #self.flyInTaskQueue
end

function InteractionBubbleManager:FlyInTaskDequeue()
  return table.remove(self.flyInTaskQueue, 1)
end

function InteractionBubbleManager:HandleDispatchStartMessage(data)
  local heroList = {}
  if type(data) == "number" then
    local taskId = data
    local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(taskId)
    if taskInfo then
      table.insertto(heroList, taskInfo.heroList)
    end
  elseif type(data) == "table" then
    for _, taskId in ipairs(data) do
      local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(taskId)
      if taskInfo then
        local list = taskInfo.heroList
        for _, v in ipairs(list) do
          table.insert(heroList, v)
          if #heroList == 3 then
            break
          end
        end
      end
      if #heroList == 3 then
        break
      end
    end
  end
  for _, v in ipairs(heroList) do
    table.insert(self.flyInTaskQueue, {type = 1, heroUuid = v})
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIInteractionBubble, {anim = true})
end

function InteractionBubbleManager:DebugHandleMsg()
  local jsonStr = "{\"pic\":\"player_head_1\",\"uid\":\"7513557021000555\",\"picVer\":5,\"subType\":10321,\"type\":7}"
  local msg = rapidjson.decode(jsonStr)
  self:HandlePushUiPopInfoMessage(msg)
end

function InteractionBubbleManager:DebugHandleMsg2()
  table.insert(self.flyInTaskQueue, {type = 1, heroUuid = 5549695521261906})
  table.insert(self.flyInTaskQueue, {type = 1, heroUuid = 5549695521246331})
  table.insert(self.flyInTaskQueue, {type = 1, heroUuid = 5549695521261219})
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIInteractionBubble, {anim = true})
end

return InteractionBubbleManager
