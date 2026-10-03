local LWArmyTemplateManager = BaseClass("LWArmyTemplateManager")

local function __init(self)
  self.armyTemplateDic = {}
end

local function __delete(self)
  self.armyTemplateDic = nil
end

local function GetArmyTemplate(self, id)
  if self.armyTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LWArmy, tostring(id))
    if oneTemplate ~= nil then
      local item = LWArmyTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.armyTemplateDic[item.id] = item
      end
    end
  end
  return self.armyTemplateDic[tonumber(id)]
end

local function TryGetArmyTemplate(self, id)
  if self.armyTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():tryGetLine(TableName.LWArmy, tostring(id))
    if oneTemplate ~= nil then
      local item = LWArmyTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.armyTemplateDic[item.id] = item
      end
    end
  end
  return self.armyTemplateDic[tonumber(id)]
end

function LWArmyTemplateManager:GetSoldierDataList(armyId)
  local res = {}
  if checknumber(armyId) > 0 then
    local armyConfigData = self:TryGetArmyTemplate(checknumber(armyId))
    if not table.IsNullOrEmpty(armyConfigData.line_up) then
      local soldierDataListTmp = {}
      for k, v in pairs(armyConfigData.line_up) do
        if v.soldierData ~= nil then
          local soldierData = {
            count = v.soldierData.num,
            id = v.soldierData.metaId,
            lv = 0
          }
          local soldierConfigData = DataCenter.SoldierDataManager:GetTemplate(v.soldierData.metaId)
          if soldierConfigData ~= nil then
            soldierData.lv = soldierConfigData.lv
          end
          if soldierDataListTmp[tostring(soldierData.id)] ~= nil then
            soldierDataListTmp[tostring(soldierData.id)].count = soldierDataListTmp[tostring(soldierData.id)].count + soldierData.count
          else
            soldierDataListTmp[tostring(soldierData.id)] = soldierData
          end
        end
      end
      for i, v in pairs(soldierDataListTmp) do
        table.insert(res, v)
      end
    end
  end
  return res
end

LWArmyTemplateManager.__init = __init
LWArmyTemplateManager.__delete = __delete
LWArmyTemplateManager.GetArmyTemplate = GetArmyTemplate
LWArmyTemplateManager.TryGetArmyTemplate = TryGetArmyTemplate
return LWArmyTemplateManager
