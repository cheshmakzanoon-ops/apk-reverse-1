local FormationScoutSelectListV2 = BaseClass("FormationScoutSelectListV2", UIAsyncContainer)
local base = UIAsyncContainer
local ResourceManager = CS.GameEntry.Resource
local FormationScoutSelectTip = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationScoutSelectTipV2")
local ScoutSelectItem = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationScoutSelectItemV2")
local troop_item_path = "layout/scoutFormation"
local troop_info_path = "Root"

local function OnCreate(self)
  base.OnCreate(self)
  self.view.ctrl:InitScoutData()
  self:ComponentDefine()
  self:DataDefine()
  self.targetUuid = self.view.ctrl.targetUuid
  self.pointId = self.view.ctrl.targetPoint
  self.scoutType = self.view.ctrl.targetType
  self.targetServerId = self.view.ctrl.targetServerId
  self:SetAnchoredPositionXY(0, 0)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:HideTroopLine()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.TroopsTb = {}
  for i = 1, InvestigateTroopMaxNum do
    local temp = self:AddComponent(ScoutSelectItem, troop_item_path .. i)
    temp:SetActive(true)
    table.insert(self.TroopsTb, temp)
  end
  self.ScoutSelectTip = self:AddComponent(UIBaseContainer, troop_info_path)
end

local function ComponentDestroy(self)
  self.TroopsTb = nil
  self.ScoutSelectTip = nil
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

function FormationScoutSelectListV2:UpdateData()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.TroopsTb ~= nil then
      self:InitUI()
    end
  end, 1)
end

local function InitUI(self)
  if not self:AsyncLoadDone() then
    return
  end
  self:TrySelectReadyFormation()
  self:InitScoutSelectTip()
  self:RefreshScoutSelectItems()
  self:RefreshTipOnSelectChange()
  self:RefreshMarchLine()
end

local function InitScoutSelectTip(self)
  if self.curSelectedIndex <= 0 then
    self.ScoutSelectTip:SetActive(false)
  else
    self.ScoutSelectTip:SetActive(true)
    if self.model then
      self:GameObjectDestroy(self.model)
      self.scoutTip = nil
    end
    self.ScoutSelectTip:RemoveAllComponentes()
    local prefabPath, classScript = self:GetRootPath()
    self.model = self:GameObjectInstantiateAsync(prefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.ScoutSelectTip.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.scoutTip = self.ScoutSelectTip:AddComponent(classScript, go.name)
      self.scoutTip:InitUI(self.pointId, self.curSelectedIndex, self.targetServerId)
      self:ResetTipPosition()
    end)
  end
end

local function GetRootPath(self)
  local prefabPath, classScript = UIAssets.FormationScoutSelectTip, FormationScoutSelectTip
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  local extraInfo = pointInfo and SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
  local cityTemplate = extraInfo and DataCenter.AllianceCityTemplateManager:GetTemplate(extraInfo.cityId, extraInfo.serverId)
  if cityTemplate and cityTemplate.asset and cityTemplate.asset > 0 and DataCenter.SeasonBankManager:IsCurOpen(true) then
    prefabPath = UIAssets.FormationScoutBankDepositTip
    classScript = require("UI.LWSeason5.LWBank.Group.BankDepositTip")
  end
  return prefabPath, classScript
end

local function RefreshScoutSelectItems(self)
  for i = 1, #self.TroopsTb do
    self.TroopsTb[i]:RefreshUI(i)
    self.TroopsTb[i]:SetSelected(i == self.curSelectedIndex)
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
  if self.pointId and self.pointId > 0 and self.scoutTip then
    self.scoutTip:RefreshUI(self.curSelectedIndex)
  end
end

local function ResetTipPosition(self, posX, posY)
  if posX then
    self.posX = posX
  end
  if posY then
    self.posY = posY
  end
  if self.scoutTip and self.posX then
    self.scoutTip:ResetTipPosition(self.posX, self.posY)
  end
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

local function GetInvesCostTime(self, targetPointID, targetServerId)
  local k2_speed = self.view.ctrl:GetScoutSpeed(targetPointID, self.curSelectedIndex, targetServerId)
  local distance = self.view.ctrl:GetInvesDistance(targetPointID, self.curSelectedIndex, targetServerId)
  return math.floor(distance / k2_speed)
end

local function GetUnlockLv(self, formationIndex)
  local unlockLv = self.view.ctrl:GetInvesFormationUnlockLv(formationIndex)
  return unlockLv
end

local function OnSelectTroopBtnClick(self, tempIndex)
  if self.curSelectedIndex > 0 and self.TroopsTb then
    self.TroopsTb[self.curSelectedIndex]:SetSelected(false)
  end
  if self.pointId and 0 < self.pointId and tempIndex ~= self.curSelectedIndex then
    self.curSelectedIndex = tempIndex
    self:RefreshTipOnSelectChange()
    self:RefreshMarchLine()
  end
end

local function OnClickStartInvestigate(self, param)
  local invesFormationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(self.curSelectedIndex)
  if invesFormationInfo and invesFormationInfo.FormationInfo then
    if param ~= nil and type(param) == "number" then
      param = nil
    end
    self.view.ctrl:StartInvestigate(self.scoutType, self.targetUuid, self.pointId, invesFormationInfo.FormationInfo.uuid, param)
  end
end

local function OnCalcElecCostFinish(self, strReuslt)
end

FormationScoutSelectListV2.OnCreate = OnCreate
FormationScoutSelectListV2.OnDestroy = OnDestroy
FormationScoutSelectListV2.OnEnable = OnEnable
FormationScoutSelectListV2.OnDisable = OnDisable
FormationScoutSelectListV2.ComponentDefine = ComponentDefine
FormationScoutSelectListV2.ComponentDestroy = ComponentDestroy
FormationScoutSelectListV2.DataDefine = DataDefine
FormationScoutSelectListV2.DataDestroy = DataDestroy
FormationScoutSelectListV2.OnAddListener = OnAddListener
FormationScoutSelectListV2.OnRemoveListener = OnRemoveListener
FormationScoutSelectListV2.InitUI = InitUI
FormationScoutSelectListV2.InitScoutSelectTip = InitScoutSelectTip
FormationScoutSelectListV2.GetRootPath = GetRootPath
FormationScoutSelectListV2.RefreshScoutSelectItems = RefreshScoutSelectItems
FormationScoutSelectListV2.GetInvesFormationStateDes = GetInvesFormationStateDes
FormationScoutSelectListV2.RefreshTipOnSelectChange = RefreshTipOnSelectChange
FormationScoutSelectListV2.TrySelectReadyFormation = TrySelectReadyFormation
FormationScoutSelectListV2.GetInvesCostTime = GetInvesCostTime
FormationScoutSelectListV2.GetUnlockLv = GetUnlockLv
FormationScoutSelectListV2.OnCalcElecCostFinish = OnCalcElecCostFinish
FormationScoutSelectListV2.RefreshMarchLine = RefreshMarchLine
FormationScoutSelectListV2.OnSelectTroopBtnClick = OnSelectTroopBtnClick
FormationScoutSelectListV2.OnClickStartInvestigate = OnClickStartInvestigate
FormationScoutSelectListV2.ResetTipPosition = ResetTipPosition
FormationScoutSelectListV2.ShowMarchLine = ShowMarchLine
FormationScoutSelectListV2.HideTroopLine = HideTroopLine
return FormationScoutSelectListV2
