local GiftQuickSendTemplateManager = BaseClass("GiftQuickSendTemplateManager")

local function __init(self)
  self.templateDic = nil
  self.tempAllNum = nil
end

local function __delete(self)
  self.templateDic = nil
  self.tempAllNum = nil
end

local function GetTemplate(self, id)
  if self.templateDic == nil then
    self.templateDic = {}
  end
  if self.templateDic[id] == nil then
    local lineData = LocalController:instance():getLine(TableName.quick_gift_component, id)
    if lineData ~= nil then
      local data = {}
      data.relationship = toInt(lineData.relationship)
      if not string.IsNullOrEmpty(lineData.show_gift_friend) then
        data.show_gift_friend = string.string2array_num_oneSep(lineData.show_gift_friend, ";")
      end
      if not string.IsNullOrEmpty(lineData.show_gift_enemy) then
        data.show_gift_enemy = string.string2array_num_oneSep(lineData.show_gift_enemy, ";")
      end
      self.templateDic[id] = data
    end
  end
  return self.templateDic[id]
end

GiftQuickSendTemplateManager.__init = __init
GiftQuickSendTemplateManager.__delete = __delete
GiftQuickSendTemplateManager.GetTemplate = GetTemplate
return GiftQuickSendTemplateManager
