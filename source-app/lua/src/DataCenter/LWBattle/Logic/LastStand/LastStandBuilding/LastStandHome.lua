local base = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local LastStandHome = BaseClass("LastStandHome", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function LastStandHome:Init(logic, config, pos)
  base.Init(self, logic, config, pos)
  self.searchType = BattleSearchType.Member
  self.lastStandBuildingType = LastStandBuildType.Home
  self.hpBarHeight = 3
  self.hpBarOffset = 0
  self.curCoin = 0
  local scale = ResetScale.x
  local path = "Assets/Main/Prefabs/LastStand/LastStandHome.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, pos.x, 0.01, pos.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function LastStandHome:ExecuteIntervalLogic()
end

function LastStandHome:OnViewLoaded(force)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.gameObject.name = "\229\159\186\229\156\176"
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.modelObj = self.gameObject.transform:Find("Model").gameObject
  self.createInfoObj = self.gameObject.transform:Find("CreateInfo").gameObject
  self.textProgress = self.createInfoObj.transform:Find("textNeedNum"):GetComponent(typeof(CS.TextMeshProEx))
  self.textProgress.text = self.buildNeedCoin - self.curCoin
  self.imageProgress = self.createInfoObj.transform:Find("imageProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageProgress.size = Vector2.New(4, 0)
  self.imageBuildingIcon = self.createInfoObj.transform:Find("imageBuilding"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageBuildingIcon:LoadSprite(string.format(LoadPath.LastStandSpritesPath, self.buildingConfig.icon))
  self.createInfoObj:SetActive(not self.isBuildingDone)
  self.modelObj:SetActive(self.isBuildingDone)
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
  self:OnLoadComplete()
end

function LastStandHome:OnBuildProgressRefresh()
  self.textProgress.text = self.buildNeedCoin - self.curCoin
end

function LastStandHome:OnBuildCoinFull()
  base.OnBuildCoinFull(self)
  EventManager:GetInstance():Broadcast(EventId.LastStandHomeBuildFinish)
  self.modelObj:SetActive(true)
  self.createInfoObj:SetActive(false)
end

function LastStandHome:OnBuildingDeath()
  base.OnBuildingDeath(self)
  self.logic:OnGameEnd(false)
end

function LastStandHome:GetRawProperty(type)
  return 0
end

return LastStandHome
