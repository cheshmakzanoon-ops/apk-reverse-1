local UIFormationSoldierChooseCtrl = BaseClass("UIFormationSoldierChooseCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationSoldierChoose)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, uuid)
  self.uuid = uuid
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  local soldiers = formation.soldiers
  self.curSoldiers = {}
  table.walk(soldiers, function(k, v)
    self.curSoldiers[k] = v
  end)
  local freeSoldiers = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
  self.maxSoldiers = {}
  self.maxNum = self:GetMaxSoldier()
  table.walk(freeSoldiers, function(k, v)
    if self.curSoldiers[k] ~= nil and self.curSoldiers[k] > 0 then
      self.maxSoldiers[k] = v + self.curSoldiers[k]
    elseif 0 < v then
      self.maxSoldiers[k] = v
    end
  end)
end

local function GetArmyIdList(self)
  return table.keys(self.maxSoldiers)
end

local function GetArmyData(self, armyId)
  local oneData = {}
  oneData.name = ""
  oneData.maxNum = self.maxSoldiers[armyId]
  oneData.icon = ""
  oneData.level = 0
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
  if template ~= nil then
    oneData.icon = template.icon
    oneData.name = Localization:GetString(template.name)
    oneData.level = template.level
  end
  return oneData
end

local function GetCurrentSoldierNum(self, armyId)
  local num = 0
  if self.curSoldiers[armyId] ~= nil and 0 < self.curSoldiers[armyId] then
    num = self.curSoldiers[armyId]
  end
  return num
end

local function SetCurrentSoldierNum(self, armyId, num)
  if 0 < num then
    self.curSoldiers[armyId] = num
  else
    self.curSoldiers[armyId] = nil
  end
end

local function CheckMax(self, armyId, num)
  local oneMaxNum = self.maxSoldiers[armyId]
  local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
  local currentTotalNum = self:GetTotalSoldierNum()
  local restNum = currentTotalNum - oneCurrentNum
  local checkMax = math.min(oneMaxNum, num)
  local totalRest = self.maxNum - restNum
  local final = math.min(totalRest, checkMax)
  if final < 0 then
    final = 0
  end
  return final
end

local function GetTotalSoldierNum(self)
  local count = 0
  table.walk(self.curSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function OnSaveClick(self)
  DataCenter.ArmyFormationDataManager:SetArmyFormationSoldier(self.uuid, self.curSoldiers)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
  self:CloseSelf()
end

local function OnOneKeyFillClick(self)
  self.curSoldiers = {}
  table.walk(self.maxSoldiers, function(k, v)
    local num = self:CheckMax(k, v)
    self:SetCurrentSoldierNum(k, num)
  end)
end

local function OnOneKeyClearClick(self)
  self.curSoldiers = {}
  table.walk(self.maxSoldiers, function(k, v)
    self:SetCurrentSoldierNum(k, 0)
  end)
end

local function GetMaxSoldier(self)
end

UIFormationSoldierChooseCtrl.CloseSelf = CloseSelf
UIFormationSoldierChooseCtrl.Close = Close
UIFormationSoldierChooseCtrl.InitData = InitData
UIFormationSoldierChooseCtrl.GetArmyIdList = GetArmyIdList
UIFormationSoldierChooseCtrl.GetArmyData = GetArmyData
UIFormationSoldierChooseCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIFormationSoldierChooseCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIFormationSoldierChooseCtrl.CheckMax = CheckMax
UIFormationSoldierChooseCtrl.GetTotalSoldierNum = GetTotalSoldierNum
UIFormationSoldierChooseCtrl.OnSaveClick = OnSaveClick
UIFormationSoldierChooseCtrl.OnOneKeyFillClick = OnOneKeyFillClick
UIFormationSoldierChooseCtrl.GetMaxSoldier = GetMaxSoldier
UIFormationSoldierChooseCtrl.OnOneKeyClearClick = OnOneKeyClearClick
return UIFormationSoldierChooseCtrl
