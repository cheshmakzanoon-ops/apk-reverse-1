local base = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local LastStandTurret = BaseClass("LastStandTurret", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local HeroUnit = require("Scene.LWBattle.ParkourBattle.Team.HeroUnit")
local Const = require("Scene.LWBattle.Const")

function LastStandTurret:Init(logic, config, pos)
  base.Init(self, logic, config, pos)
  self.lastStandBuildingType = LastStandBuildType.Turret
  self.searchType = BattleSearchType.None
  local scale = ResetScale.x
  local path = "Assets/Main/Prefabs/LastStand/LastStandTurret.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, pos.x, 0.01, pos.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function LastStandTurret:OnViewLoaded(force)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.gameObject.name = "\231\130\174\229\161\148"
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
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
  self.modelBuildingObj = self.transform:Find("Model/A_build_xswf_shaogang")
  self:OnLoadComplete()
end

function LastStandTurret:OnBuildProgressRefresh()
  self.textProgress.text = self.buildNeedCoin - self.curCoin
end

function LastStandTurret:OnBuildCoinFull()
  base.OnBuildCoinFull(self)
  self.modelObj:SetActive(true)
  self.createInfoObj:SetActive(false)
end

function LastStandTurret:CreateHero()
  local hero = HeroInfo.New()
  local level = 1
  local heroId = tonumber(self.buildingConfig.para1)
  hero:UpdateFromTemplate(heroId, level)
  local heroUnit = HeroUnit:New()
  heroUnit:Init(self.logic, nil, nil, {
    x = self.buildingPos.x,
    y = 3.63,
    z = self.buildingPos.z - 0.4
  }, hero)
  self.logic:AddUnit(heroUnit)
  heroUnit:SetInitUnit()
  heroUnit:ChangeStage(Const.ParkourBattleState.Boss)
  heroUnit:SetStealth(true)
  heroUnit:SetIsHideHpBar(true)
  self.heroUnit = heroUnit
  self.curHeroUnitGuid = heroUnit.guid
end

function LastStandTurret:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.heroUnit then
    self.heroUnit:OnUpdate(deltaTime)
  end
end

function LastStandTurret:OnBuildingUpgrade()
  base.OnBuildingUpgrade(self)
  if self.heroUnit then
    self.logic:RemoveUnit(self.heroUnit.guid)
    self.heroUnit:DestroyData()
  end
  self:CreateHero()
end

return LastStandTurret
