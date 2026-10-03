local InteractionTemplateManager = BaseClass("InteractionTemplateManager")

function InteractionTemplateManager:__init()
end

function InteractionTemplateManager:__delete()
  self.bubbleTemplates = nil
  self.likeTemplates = nil
  self.heroBubbleTextList = nil
end

function InteractionTemplateManager:GetBubbleTemplateByType(type)
  if self.bubbleTemplates == nil then
    self.bubbleTemplates = {}
    LocalController:instance():visitTable(TableName.Main_UI_Pop, function(id, lineData)
      if lineData ~= nil then
        self.bubbleTemplates[lineData.type] = {
          id = lineData.id,
          type = lineData.type,
          time = lineData.time,
          dialog = lineData.dialog,
          icon = lineData.icon,
          banner = lineData.banner
        }
      end
    end)
  end
  return self.bubbleTemplates[type]
end

function InteractionTemplateManager:GetLikeTemplateByType(type)
  if self.likeTemplates == nil then
    self.likeTemplates = {}
  end
  if self.likeTemplates[type] == nil then
    local lineData = LocalController:instance():getLine(TableName.Like_Setting, type)
    if lineData ~= nil then
      self.likeTemplates[type] = {
        id = lineData.id,
        desc = lineData.desc,
        daily_max = lineData.daily_max,
        pop_max = lineData.pop_max
      }
    end
  end
  return self.likeTemplates[type]
end

function InteractionTemplateManager:GetRandomHeroBubbleText()
  if self.heroBubbleTextList == nil then
    self.heroBubbleTextList = {}
    local config = self:GetBubbleTemplateByType(InteractionBubbleType.STEALTH_MOBILE_FORCE)
    if config then
      local textArray = config.dialog
      if not string.IsNullOrEmpty(textArray) then
        local array = string.split(textArray, ";")
        for _, v in ipairs(array) do
          if not string.IsNullOrEmpty(v) then
            table.insert(self.heroBubbleTextList, v)
          end
        end
      end
    end
  end
  local count = #self.heroBubbleTextList
  if count < 0 then
    return ""
  end
  local index = math.random(count)
  return self.heroBubbleTextList[index]
end

return InteractionTemplateManager
