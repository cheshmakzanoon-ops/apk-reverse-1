local UIMainFormationScoutSelectList = BaseClass("UIMainFormationScoutSelectList", UIBaseContainer)
local base = UIBaseContainer
local ScoutSelectItem = require("UI.UIMain.Component.UIMainBottom.TroopList.UIMarchQueueFormationListCell")
local ResourceManager = CS.GameEntry.Resource
local troop_item_path = "Mask/Content2/UIMainFormationSelectCellNew"

local function OnCreate(self)
  base.OnCreate(self)
  self.view.ctrl:InitScoutData()
  self:ComponentDefine()
  self:DataDefine()
  self.targetUuid = self.view.ctrl.targetUuid
  self.pointId = self.view.ctrl.targetPoint
  self.scoutType = self.view.ctrl.targetType
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:HideTroopLine()
  base.OnDestroy(self)
end

local function Update(self)
end

local function ComponentDefine(self)
  self.TroopsTb = {}
  for i = 1, InvestigateTroopMaxNum do
    local temp = self:AddComponent(ScoutSelectItem, troop_item_path .. i)
    temp:SetActive(true)
    table.insert(self.TroopsTb, temp)
  end
end

local function ComponentDestroy(self)
  self.TroopsTb = nil
end

local function DataDefine(self)
  self.curSelectedIndex = -1
  self.targetUuid = nil
  self.pointId = nil
end

local function DataDestroy(self)
  self.curSelectedIndex = nil
  self.targetUuid = nil
  self.pointId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReturnTimeFromCurPosToTargetPos, self.OnCalcElecCostFinish)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.RefreshScoutSelectItems)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.RefreshScoutSelectItems)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReturnTimeFromCurPosToTargetPos, self.OnCalcElecCostFinish)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.RefreshScoutSelectItems)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.RefreshScoutSelectItems)
end

local function InitUI(self)
  self:TrySelectReadyFormation()
  self:RefreshScoutSelectItems()
  self:RefreshTipOnSelectChange()
  self:RefreshMarchLine()
end

local function InitScoutSelectTip(self)
end

local function RefreshScoutSelectItems(self)
  for i = 1, #self.TroopsTb do
    local formationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(i)
    if formationInfo.MarchInfo == nil or formationInfo.MarchInfo.state == MarchStatus.STATION then
      self.TroopsTb[i]:SetActive(false)
    else
      self.TroopsTb[i]:SetActive(true)
      self.TroopsTb[i]:RefreshScoutUI(i)
      self.TroopsTb[i]:SetSelected(i == self.curSelectedIndex)
    end
  end
end

local function TrySelectReadyFormation(self)
  if not self.pointId or self.pointId <= 0 then
    self.curSelectedIndex = -1
    return
  end
  local allInvesFormations = self.view.ctrl:GetAllScoutFormations()
  local unlockCount = DataCenter.ArmyFormationDataManager:GetMaxInvesFormationCount()
  for i, v in ipairs(allInvesFormations) do
    if self.curSelectedIndex == -1 then
      self.curSelectedIndex = i
    end
    if i <= unlockCount and v.state == 0 then
      self.curSelectedIndex = i
      break
    end
  end
end

local function ShowMarchLine(self)
  self:HideTroopLine()
  local lookAtFocusTime = 0.4
  CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(self.pointId), CS.LookAtFocusState.Formation, lookAtFocusTime)
end

local function RefreshMarchLine(self)
  if not self.pointId or self.pointId <= 0 then
    return
  end
  local startPointID = self.view.ctrl:GetScoutStartPoint(self.curSelectedIndex)
  if self.troopLine == nil and self.dragInstance == nil then
    self.dragInstance = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.TroopLineDrag)
    self.dragInstance:completed("+", function()
      if self.dragInstance.isError then
        return
      end
      self.dragInstance.gameObject:SetActive(true)
      self.dragInstance.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      self.troopLine = self.dragInstance.gameObject:GetComponent(typeof(CS.WorldTroopLine))
      if self.troopLine ~= nil then
        self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPointID), SceneUtils.TileIndexToWorld(self.pointId))
      end
    end)
  elseif self.troopLine ~= nil then
    self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPointID), SceneUtils.TileIndexToWorld(self.pointId))
  end
end

local function HideTroopLine(self)
  if self.dragInstance ~= nil then
    self.dragInstance:Destroy()
  end
  self.dragInstance = nil
  self.troopLine = nil
end

local function RefreshTipOnSelectChange(self)
end

local function ResetTipPosition(self, posX, posY)
end

local function GetInvesFormationStateDes(self)
  local invesFormationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(self.curSelectedIndex)
  if invesFormationInfo.MarchInfo == nil then
    return "141012"
  elseif invesFormationInfo.MarchInfo:GetMarchTargetType() == MarchTargetType.BACK_HOME then
    return "129007"
  else
    return "129006"
  end
end

local function GetInvesCostTime(self, targetPointID)
  local k2_speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k2")
  local distance = self.view.ctrl:GetInvesDistance(targetPointID, self.curSelectedIndex)
  return math.floor(distance / k2_speed)
end

local function GetUnlockLv(self, formationIndex)
  local unlockLv = self.view.ctrl:GetInvesFormationUnlockLv(formationIndex)
  return unlockLv
end

local function OnSelectTroopBtnClick(self, tempIndex)
  if self.curSelectedIndex > 0 then
    self.TroopsTb[self.curSelectedIndex]:SetSelected(false)
  end
  if self.pointId and 0 < self.pointId and tempIndex ~= self.curSelectedIndex then
    self.curSelectedIndex = tempIndex
    self:RefreshTipOnSelectChange()
    self:RefreshMarchLine()
  end
end

local function OnClickStartInvestigate(self)
  local invesFormationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(self.curSelectedIndex)
  if invesFormationInfo and invesFormationInfo.FormationInfo then
    self.view.ctrl:StartInvestigate(self.scoutType, self.targetUuid, self.pointId, invesFormationInfo.FormationInfo.uuid)
  end
end

local function OnCalcElecCostFinish(self, strReuslt)
end

local function RefreshTime(self)
  for i = 1, #self.TroopsTb do
    self.TroopsTb[i]:UpdateTime()
  end
end

UIMainFormationScoutSelectList.OnCreate = OnCreate
UIMainFormationScoutSelectList.OnDestroy = OnDestroy
UIMainFormationScoutSelectList.OnEnable = OnEnable
UIMainFormationScoutSelectList.OnDisable = OnDisable
UIMainFormationScoutSelectList.Update = Update
UIMainFormationScoutSelectList.ComponentDefine = ComponentDefine
UIMainFormationScoutSelectList.ComponentDestroy = ComponentDestroy
UIMainFormationScoutSelectList.DataDefine = DataDefine
UIMainFormationScoutSelectList.DataDestroy = DataDestroy
UIMainFormationScoutSelectList.OnAddListener = OnAddListener
UIMainFormationScoutSelectList.OnRemoveListener = OnRemoveListener
UIMainFormationScoutSelectList.InitUI = InitUI
UIMainFormationScoutSelectList.InitScoutSelectTip = InitScoutSelectTip
UIMainFormationScoutSelectList.RefreshScoutSelectItems = RefreshScoutSelectItems
UIMainFormationScoutSelectList.GetInvesFormationStateDes = GetInvesFormationStateDes
UIMainFormationScoutSelectList.RefreshTipOnSelectChange = RefreshTipOnSelectChange
UIMainFormationScoutSelectList.TrySelectReadyFormation = TrySelectReadyFormation
UIMainFormationScoutSelectList.GetInvesCostTime = GetInvesCostTime
UIMainFormationScoutSelectList.GetUnlockLv = GetUnlockLv
UIMainFormationScoutSelectList.OnCalcElecCostFinish = OnCalcElecCostFinish
UIMainFormationScoutSelectList.RefreshMarchLine = RefreshMarchLine
UIMainFormationScoutSelectList.OnSelectTroopBtnClick = OnSelectTroopBtnClick
UIMainFormationScoutSelectList.OnClickStartInvestigate = OnClickStartInvestigate
UIMainFormationScoutSelectList.ResetTipPosition = ResetTipPosition
UIMainFormationScoutSelectList.ShowMarchLine = ShowMarchLine
UIMainFormationScoutSelectList.HideTroopLine = HideTroopLine
UIMainFormationScoutSelectList.RefreshTime = RefreshTime
return UIMainFormationScoutSelectList
