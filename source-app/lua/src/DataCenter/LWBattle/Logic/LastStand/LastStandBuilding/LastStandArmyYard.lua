local base = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local LastStandArmyYard = BaseClass("LastStandArmyYard", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local Localization = CS.GameEntry.Localization
local maxModelShowNum = 16

function LastStandArmyYard:Init(logic, config, pos)
  base.Init(self, logic, config, pos)
  self.soliderCount = 0
  self.createSoliderCount = 0
  self.maxSoliderCount = 10
  self.lastStandBuildingType = LastStandBuildType.ArmyYard
  self.soliderList = {}
  local scale = ResetScale.x
  local path = "Assets/Main/Prefabs/LastStand/LastStandArmyYard.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, pos.x, 0.01, pos.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function LastStandArmyYard:ExecuteEnterBuildingLogic()
  local count = self.soliderCount
  if count <= 0 then
    return
  end
  local posList = self.logic.team:PreGetEmptyPos(count)
  for i = 1, self.soliderCount do
    local pos = self:GetFirstUsePos()
    self.slotList[pos] = nil
    if self.soliderList and 0 < #self.soliderList then
      local v = table.remove(self.soliderList, 1)
      if v then
        v:SetTeamEndPos(posList[i].pos)
      end
    end
  end
  self.createSoliderCount = self.createSoliderCount - count
  self.soliderCount = 0
end

function LastStandArmyYard:AddSoliderToArmyYard(sourceBuildingUid)
  if not self.isBuildingDone or self.createSoliderCount >= self.maxSoliderCount then
    return false
  end
  self.createSoliderCount = self.createSoliderCount + 1
  if self.createSoliderCount <= maxModelShowNum then
    self:CreateSoliderModel(sourceBuildingUid)
  else
    self:OnSoliderEnterArmyYard()
  end
  self:RefreshCount()
  return true
end

function LastStandArmyYard:OnSoliderEnterArmyYard()
  self.soliderCount = self.soliderCount + 1
end

function LastStandArmyYard:RefreshCount()
  if self.soliderCount >= self.maxSoliderCount then
    self.textCount.text = Localization:GetString("ghostrecon_btn06")
  else
    self.textCount.text = self.soliderCount .. "/" .. self.maxSoliderCount
  end
end

function LastStandArmyYard:OnViewLoaded(force)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.gameObject.name = "\230\160\161\229\156\186"
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.textCount = self.gameObject.transform:Find("Model/countInfo/textCount"):GetComponent(typeof(CS.TextMeshProEx))
  self:RefreshCount()
  self.modelObj = self.gameObject.transform:Find("Model").gameObject
  self.modelObj:SetActive(self.isBuildingDone)
  self.createInfoObj = self.gameObject.transform:Find("CreateInfo").gameObject
  self.textProgress = self.createInfoObj.transform:Find("textNeedNum"):GetComponent(typeof(CS.TextMeshProEx))
  self.textProgress.text = self.buildNeedCoin - self.curCoin
  self.imageProgress = self.createInfoObj.transform:Find("imageProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageProgress.size = Vector2.New(4, 0)
  self.imageBuildingIcon = self.createInfoObj.transform:Find("imageBuilding"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageBuildingIcon:LoadSprite(string.format(LoadPath.LastStandSpritesPath, self.buildingConfig.icon))
  self.createInfoObj:SetActive(not self.isBuildingDone)
  self.levelInfoTrans = self.transform:Find("Model/levelInfo")
  self.levelInfoObj = self.levelInfoTrans.gameObject
  self.levelInfoObj:SetActive(true)
  self.textLevel = self.levelInfoTrans:Find("textLevel"):GetComponent(typeof(CS.TextMeshProEx))
  self.textLevel.text = self.buildingLevel
  self.updateProgressTrans = self.transform:Find("Model/levelInfo/updateProgress")
  self.updateProgressTrans.gameObject:SetActive(true)
  self.textUpgradeCost = self.updateProgressTrans:Find("textUpgradeCost"):GetComponent(typeof(CS.TextMeshProEx))
  self.imageUpgradeProgress = self.updateProgressTrans:Find("bgProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageUpgradeProgress.size = Vector2.New(1, 0)
  self.modelBuildingObj = self.transform:Find("Model/building")
  self.slotTrans = self.transform:Find("slot")
  self.line = {}
  self.slotList = {}
  for i = 1, 3 do
    self.line[i] = {}
    self.line[i].transform = self.transform:Find("slot/line" .. i)
    if i == 1 then
      self.line[i].maxNum = 4
    else
      self.line[i].maxNum = 6
    end
    self.line[i].curNum = 0
  end
  self:OnLoadComplete()
end

function LastStandArmyYard:OnBuildProgressRefresh()
  self.textProgress.text = self.buildNeedCoin - self.curCoin
end

function LastStandArmyYard:OnBuildCoinFull()
  base.OnBuildCoinFull(self)
  self.modelObj:SetActive(true)
  self.createInfoObj:SetActive(false)
end

function LastStandArmyYard:ExecuteIntervalLogic()
  self:RefreshCount()
end

function LastStandArmyYard:IsSoliderReachMaxCount()
  if self.soliderCount >= self.maxSoliderCount then
    return true
  end
  return false
end

local Solider = require("DataCenter/LWBattle/Logic/LastStand/LastStandBuilding/LastStandSoliderUnit")

function LastStandArmyYard:CreateSoliderModel(sourceBuildingUid)
  local solider = Solider.New()
  local data = {}
  data.modelPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle.prefab"
  local building = self.logic.buildingMgr:GetBuildingByUid(sourceBuildingUid)
  if not building then
    return
  end
  data.birthPos = building:GetPosition()
  
  function data.arriveCallBack()
    self:OnSoliderEnterArmyYard()
  end
  
  function data.arriveTeamCallBack()
    DataCenter.LWBattleManager.logic:AddMember(10001, 1, false)
  end
  
  data.speed = 5
  local emptyPos = self:GetEmptyPos()
  self.slotList[emptyPos] = true
  local slotIndex, posInLine, worldPos = self:GetSoliderPosInArmyYard(emptyPos)
  data.endPos = {worldPos}
  data.slotTrans = self.line[slotIndex].transform
  self.line[slotIndex].curNum = self.line[slotIndex].curNum + 1
  solider:SetData(data, self)
  solider:CreateModel()
  table.insert(self.soliderList, solider)
end

function LastStandArmyYard:OnBuildingUpgrade()
  base.OnBuildingUpgrade(self)
  self.maxSoliderCount = tonumber(self.buildingConfig.para1)
  self:RefreshCount()
end

function LastStandArmyYard:GetSoliderPosInArmyYard(index)
  if self.createSoliderCount > maxModelShowNum then
    return
  end
  local slotIndex = 1
  local posInLine = 0
  if index <= 4 then
    slotIndex = 1
    posInLine = index
  elseif index <= 10 then
    slotIndex = 2
    posInLine = index - 4
  else
    slotIndex = 3
    posInLine = index - 10
  end
  local posZ = posInLine * -1
  local localOffset = Vector3.New(0, 0, posZ)
  local trans = self.line[slotIndex].transform
  local worldPos = trans:TransformPoint(localOffset)
  return slotIndex, posInLine, Vector3.New(worldPos.x, worldPos.y, worldPos.z)
end

function LastStandArmyYard:GetEmptyPos()
  local index = 0
  for i = 1, maxModelShowNum do
    if not self.slotList[i] then
      index = i
      break
    end
  end
  return index
end

function LastStandArmyYard:GetFirstUsePos()
  local index = 0
  for i = 1, maxModelShowNum do
    if self.slotList[i] then
      index = i
      break
    end
  end
  return index
end

function LastStandArmyYard:OnDestroy()
  base.OnDestroy(self)
  if self.soliderList and #self.soliderList > 0 then
    for i, v in ipairs(self.soliderList) do
      v:Delete()
    end
    self.soliderList = {}
  end
end

function LastStandArmyYard:OnStayInBuilding()
  self:ExecuteEnterBuildingLogic()
end

return LastStandArmyYard
