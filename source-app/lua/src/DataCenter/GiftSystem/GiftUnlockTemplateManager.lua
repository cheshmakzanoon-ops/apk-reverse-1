local GiftUnlockTemplateManager = BaseClass("GiftUnlockTemplateManager")
local GiftUnlockTemplate = require("DataCenter.GiftSystem.GiftUnlockTemplate")

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
    local lineData = LocalController:instance():getLine(TableName.Gift_Unlock, id)
    if lineData ~= nil then
      local temp = GiftUnlockTemplate.New()
      temp:InitData(lineData)
      self.templateDic[id] = temp
    end
  end
  return self.templateDic[id]
end

local function GetAllNum(self)
  if self.tempAllNum == nil then
    self.tempAllNum = LocalController:instance():GetTableLength(TableName.Gift_Unlock)
  end
  return self.tempAllNum
end

GiftUnlockTemplateManager.__init = __init
GiftUnlockTemplateManager.__delete = __delete
GiftUnlockTemplateManager.GetTemplate = GetTemplate
GiftUnlockTemplateManager.GetAllNum = GetAllNum
return GiftUnlockTemplateManager
