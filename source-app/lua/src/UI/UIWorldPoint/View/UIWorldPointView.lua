local UIWorldPointView = BaseClass("UIWorldPointView", UIBaseView)
local base = UIBaseView
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local luaPath_otherPlayer = "UI.UIWorldPoint.Component.WorldPlayerDes"
local luaPath_collect = "UI.UIWorldPoint.Component.WorldCollectDes"
local luaPath_dispatch_task = "UI.UIWorldPoint.Component.WorldDispatchTask"
local luaPath_monster = "UI.UIWorldPoint.Component.WorldMonsterDes"
local luaPath_flowerCar = "UI.UIWorldPoint.Component.WorldFlowerCarDes"
local luaPath_train = "UI.UIWorldPoint.Component.WorldTrainDes"
local luaPath_HSR = "UI.UIWorldPoint.Component.UIWorldPointHSRComponent"
local luaPath_worldTrigger = "UI.UIWorldPoint.Component.WorldTriggerDes"
local luaPath_wolfShadow = "UI.UIWorldPoint.Component.WolfShadowDes"
local luaPath_allyDrillCow = "UI.UIWorldPoint.Component.AllyDrillCowDes"
local luaPath_simpleMonster = "UI.UIWorldPoint.Component.WorldSimpleMonsterDes"
local luaPath_meteoriteInfo = "UI.UIWorldPoint.Component.MeteoriteCollectionInfo"
local luaPath_drillObj = "UI.UIWorldPoint.Component.WorldDrillDes"
local luaPath_ZombieRushObj = "UI.UIWorldPoint.Component.WorldZombieRushDes"
local luaPath_BerserkBossObj = "UI.UIWorldPoint.Component.WorldBerserkBossDes"
local luaPath_desertObj = "UI.UIWorldPoint.Component.WorldDesertDes"
local luaPath_dragonBuild = "UI.UIWorldPoint.Component.WorldDragonBuild"
local luaPath_winterEntityNew = "UI.UIWorldPoint.Component.WorldWinterEntityNew"
local luaPath_epidemicBuild = "UI.UIWorldPoint.Component.WorldEpidemicBuild"
local luaPath_TreasureDetectObj = "UI.UIWorldPoint.Component.WorldTreasureDetect"
local luaPath_AllianceBuild = "UI.UIWorldPoint.Component.WorldAllianceBuild"
local luaPath_DetectZombieBusTrain = "UI.UIWorldPoint.Component.WorldDetectZombieBusTrain"
local luaPath_DetectDigGameObj = "UI.UIWorldPoint.Component.WorldDetectDigGame"
local luaPath_airshipDonate = "UI.UIWorldPoint.Component.AirshipDonateDetail"
local luaPath_flowerTrain = "UI.UIWorldPoint.Component.FlowerTrainContent"
local luaPath_flowerTrainReward = "UI.UIWorldPoint.Component.FlowerTrainRewardContent"
local luaPath_valentineStar = require("UI.UIWorldPoint.Component.ValentineStar")
local luaPath_battlefieldBuilding = "UI.UIWorldPoint.Component.UIWorldPointNewBattlefieldBuilding"
local luaPath_ScoutDes = "UI.UIWorldPoint.Component.WorldScoutDes"
local UIWorldPointBtn = require("UI.UIWorldPoint.Component.UIWorldPointBtn")
local WorldSeasonBuildDes = require("UI.UIWorldPoint.Component.WorldSeasonBuildDes")
local WorldActBossDes = require("UI.UIWorldPoint.Component.WorldActBossDes")
local WorldPlunderDes = require("UI.UIWorldPoint.Component.WorldPlunderDes")
local WorldRuinBuildDes = require("UI.UIWorldPoint.Component.WorldRuinBuildDes")
local GuideGarbageInfo = require("UI.UIWorldPoint.Component.GuideGarbageInfo")
local WorldChallengeDes = require("UI.UIWorldPoint.Component.WorldChallengeDes")
local WorldScoutDes = require("UI.UIWorldPoint.Component.WorldScoutDes")
local WorldTrigger = require("UI.UIWorldPoint.Component.WorldTriggerDes")
local WorldAllianceCollect = require("UI.UIWorldPoint.Component.WorldAllianceCollect")
local WorldPointGhostrecon = require("UI.UIWorldPoint.Component.WorldPointGhostrecon")
local WorldSuppliesPoint = require("UI/UIWorldPoint.Component.WorldSuppliesPoint")
local ZoneMobilizationSuppliesPoint = require("UI/UIWorldPoint.Component.ZoneMobilizationSuppliesPoint")
local WorldDetectSurvivor = require("UI.UIWorldPoint.Component.WorldDetectSurvivor")
local WorldSuppliesTop = require("UI.UIWorldPoint.Component.WorldSuppliesTop")
local ZoneMobilizationSuppliesPointTop = require("UI.UIWorldPoint.Component.ZoneMobilizationSuppliesPointTop")
local DarknessSuppliesPoint = require("UI/LWSeason4.Component.DarknessSuppliesPoint")
local KillZombieKirovBossDesc = require("UI.UIWorldPoint.Component.KillZombieKirovBossDesc")
local KillZombieKirovBoxDesc = require("UI.UIWorldPoint.Component.KillZombieKirovBoxDesc")
local WorldRetryCollectDes = require("UI.UIWorldPoint.Component.WorldRetryCollectDes")
local WorldS1RestCityDefendMonster = require("UI.UIWorldPoint.Component.WorldS1RestCityDefendMonster")
local WorldS1RestBloodyQueenMonster = require("UI.UIWorldPoint.Component.WorldS1RestBloodyQueenMonster")
local WorldAllianceCollectPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/SeasonAllianceCollect.prefab"
local WorldSuppliesPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/WorldSuppliesPoint.prefab"
local ZoneMobilizationSuppliesPointPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ZoneMobilization/ZoneMobilizationSuppliesPoint.prefab"
local WorldDetectSurvivorPrefa = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/WorldDetectSurvivor.prefab"
local WorldSuppliesTopPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/worldSuppliesTop.prefab"
local ZoneMobilizationSuppliesPointTopPrefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ZoneMobilization/ZoneMobilizationSuppliesPointTop.prefab"
local DarknessSuppliesPrefab = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/DarknessSuppliesPoint.prefab"
local SeasonFrozenStatus = require("UI.UIWorldPoint.Component.SeasonFrozenStatus")
local WorldPropertyShow = require("UI.UIWorldPoint.Component.WorldPropertyShow")
local WorldHeadInfo = require("UI.UIWorldPoint.Component.WorldHeadInfo")
local UIDecorationStickers = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickers")
local UIWorldS0AllianceBuildDesc = require("UI.UIWorldPoint.Component.UIWorldS0AllianceBuildDesc")
local UIWorldS0AllianceBossDesc = require("UI.UIWorldPoint.Component.UIWorldS0AllianceBossDesc")
local Localization = CS.GameEntry.Localization
local WorldPointUIType = _ENV.WorldPointUIType
local UnityHorizontalOrVerticalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalOrVerticalLayoutGroup)
local BtnPosition = {}
BtnPosition[1] = {
  Vector3.New(0, -131.5, 0)
}
BtnPosition[2] = {
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0)
}
BtnPosition[3] = {
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0)
}
BtnPosition[4] = {
  Vector3.New(241.5, -6.5, 0),
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0),
  Vector3.New(-241.5, -6.5, 0)
}
BtnPosition[5] = {
  Vector3.New(297.5, 92.5, 0),
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0),
  Vector3.New(-297.5, 92.5, 0)
}
local BtnCellCircle = Vector3.New(0, 120, 0)
local AnimName = {
  Enter = "CommonPopup_movein",
  Exit = "CommonPopup_moveout"
}
local BuildAdjust = {
  left = 200,
  right = 200,
  top = 350,
  bottom = 150
}
local LoadAssetMap = {
  [WorldPointUIType.ZoneMobilizationSuppliesPoint] = {
    prefab = ZoneMobilizationSuppliesPointPrefab,
    cls = ZoneMobilizationSuppliesPoint,
    objName = "ZoneMobilizationSuppliesPoint"
  },
  [WorldPointUIType.DarknessSuppliesPoint] = {
    prefab = DarknessSuppliesPrefab,
    cls = DarknessSuppliesPoint,
    objName = "DarknessSuppliesPoint"
  },
  [WorldPointUIType.WorldAllianceResourceCollect] = {
    prefab = WorldAllianceCollectPrefab,
    cls = WorldAllianceCollect,
    objName = "WorldAllianceResourceCollect"
  },
  [WorldPointUIType.WorldSuppliesPoint] = {
    prefab = WorldSuppliesPrefab,
    cls = WorldSuppliesPoint,
    objName = "WorldSuppliesPoint"
  },
  [WorldPointUIType.WorldDetectSurvivor] = {
    prefab = WorldDetectSurvivorPrefa,
    cls = WorldDetectSurvivor,
    objName = "WorldDetectSurvivor"
  },
  [WorldPointUIType.AllianceMine] = {
    name = "AsyncAllianceMine",
    lua = "UI.UIWorldPoint.Component.WorldAlMinePanel",
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/alMinePanel.prefab"
  },
  [WorldPointUIType.AllianceActMine] = {
    name = "AsyncAllianceMine",
    lua = "UI.UIWorldPoint.Component.WorldAlMinePanel",
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/alMinePanel.prefab"
  },
  [WorldPointUIType.AllianceCollectPoint] = {
    name = "alliance_collect_obj",
    lua = "UI.UIWorldPoint.Component.WorldAllianceCollectResDes",
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/allianceCollect.prefab"
  },
  [WorldPointUIType.CityAttachmentBuild] = {
    name = "CityAttachmentBuild",
    lua = "UI.UIWorldPoint.Component.WorldCityAttachmentBuild",
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/CityAttachmentBuild.prefab"
  },
  [WorldPointUIType.SandWorm] = {
    name = "SandWorm",
    lua = "UI.UIWorldPoint.Component.WorldSandWormDes",
    prefab = "Assets/Main/SeasonRes/S3/Prefabs/UI/SandWormPoint/sandWormPointObj.prefab"
  },
  [WorldPointUIType.KillZombieKirovBoss] = {
    objName = "KillZombieKirovBoss",
    cls = KillZombieKirovBossDesc,
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/KillZombie/KillZombieKirovBoss.prefab"
  },
  [WorldPointUIType.KillZombieKirovBox] = {
    objName = "KillZombieKirovBox",
    cls = KillZombieKirovBoxDesc,
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/KillZombie/KillZombieKirovBox.prefab"
  },
  [WorldPointUIType.DetectRetryResource] = {
    objName = "DetectRetryResource",
    cls = WorldRetryCollectDes,
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewRetryCollect.prefab"
  },
  [WorldPointUIType.S1RestCityDefendMonster] = {
    objName = "S1RestCityDefendMonster",
    cls = WorldS1RestCityDefendMonster,
    prefab = "Assets/Main/Prefabs/UI/LWOffSeason1/World/UIWorldPointComponent/UIWorldPointS1RestCityDefendMonsterObj.prefab"
  },
  [WorldPointUIType.S1RestBloodyQueenMonster] = {
    objName = "S1RestBloodyQueenMonster",
    cls = WorldS1RestBloodyQueenMonster,
    prefab = "Assets/Main/Prefabs/UI/LWOffSeason1/World/UIWorldPointComponent/UIWorldPointS1RestBloodyQueenMonsterObj.prefab"
  },
  [WorldPointUIType.SkyBattle] = {
    objName = "SkyBattle",
    cls = WorldRetryCollectDes,
    prefab = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/UIWorldPointNewRetryCollect.prefab"
  }
}
local VIEW_DEFAULT_WIDTH = 538
local VIEW_WIDTH_CONFIG = {
  [WorldPointUIType.FlowerTrain] = 624,
  [WorldPointUIType.FlowerTrainReward] = 624
}
local bg_arrow_up_path = "PosGo/message/bg/bgArrowUp"
local bg_arrow_path = "PosGo/message/bgArrow"
local bg_path = "PosGo/message/bg"
local pos_go_path = "PosGo"
local mapSticker = "SecondLevelPlane"
local bg_go_path = "PosGo/message/bg"
local pos_go_info_path = "PosGo/message"
local btn_virus_path = "PosGo/message/bg/Top/name/BtnVirus"
local virus_level_text_path = "PosGo/message/bg/Top/name/BtnVirus/BtnVirusBg/VirusLevelText"
local virus_bg_path = "PosGo/message/bg/Top/name/BtnVirus/BtnVirusBg"
local name_text_path = "PosGo/message/bg/Top/name/NameContainer/NameText"
local name_icon_path = "PosGo/message/bg/Top/name/NameContainer/BtnIcon"
local name_icon_effect_path = "PosGo/message/bg/Top/name/NameContainer/BtnIcon/effect"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local this_path = ""
local btn_mark_path = "PosGo/message/bg/Top/Btn_mark"
local btn_share_path = "PosGo/message/bg/Top/Btn_share"
local btn_alliance_share_path = "PosGo/message/bg/Top/Btn_alliance_share"
local btn_detail_path = "PosGo/message/bg/Top/btn_detail"
local btn_return_path = "PosGo/message/bg/Top/btn_return"
local career_label_path = "PosGo/message/bg/UICareerLabel"
local monster_obj_path = "PosGo/message/bg/monsterObj"
local seanson_build_obj_path = "PosGo/message/bg/seasonBuildObj"
local simple_monster_obj_path = "PosGo/message/bg/simpleMonsterObj"
local plunder_obj_path = "PosGo/message/bg/plunderObj"
local world_ruin_build_path = "PosGo/message/bg/worldRuinBuild"
local act_boss_obj_path = "PosGo/message/bg/actBossObj"
local challenge_obj_path = "PosGo/message/bg/challengeObj"
local guide_garbage_path = "GuidePanel"
local scout_obj_path = "PosGo/message/bg/scoutObj"
local btn_king_path = "PosGo/message/bg/Top/Btn_King"
local alliance_build_obj_path = "PosGo/message/bg/allianceBuild"
local test_btn_path = "PosGo/message/bg/TestBtn"
local top2_path = "PosGo/message/bg/Top2"
local property_path = "PosGo/message/bg/Property"
local top_path = "PosGo/message/bg/Top"
local top_bg_path = "PosGo/message/bg/Top/topBg"
local season_frozen_tips_path = "PosGo/message/bg/seasonFrozenTips"
local ghostrecon_obj_path = "PosGo/message/bg/ghostreconObj"
local tip_obj_path = "PosGo/message/bg/tipObj"
local tip_text_path = "PosGo/message/bg/tipObj/tipText"
local airship_donate_path = "PosGo/message/bg/AirshipDonate"
local refresh_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/RefreshBtn"
local six_build_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/SixBuildBtn"
local frame_path = "PosGo/message/bg/Frame"
local valentine_star_path = "PosGo/message/bg/ValentineStar"
local other_player_root_path = "PosGo/message/bg/otherPlayerRoot"
local collect_root_path = "PosGo/message/bg/collectRoot"
local alliance_build_root = "PosGo/message/bg/allianceBuildRoot"
local dispatch_task_root_path = "PosGo/message/bg/dispatchTaskRoot"
local monster_root_path = "PosGo/message/bg/monsterRoot"
local flowerCar_root_path = "PosGo/message/bg/flowerCarRoot"
local train_root_path = "PosGo/message/bg/trainRoot"
local hsr_root_path = "PosGo/message/bg/hsrRoot"
local zombieBus_train_root_path = "PosGo/message/bg/zombieBusTrainRoot"
local world_trigger_root_path = "PosGo/message/bg/worldTriggerRoot"
local simple_monster_root_path = "PosGo/message/bg/simpleMonsterRoot"
local meteorite_collection_root_path = "PosGo/message/bg/meteoriteCollectionRoot"
local drill_obj_root_path = "PosGo/message/bg/drillObjRoot"
local zombie_rush_obj_root_path = "PosGo/message/bg/ZombieRushObjRoot"
local berserk_boss_obj_root_path = "PosGo/message/bg/BerserkBossObjRoot"
local desert_obj_root_path = "PosGo/message/bg/desertObjRoot"
local dragon_build_root_path = "PosGo/message/bg/dragonBuildRoot"
local winter_entity_new_root_path = "PosGo/message/bg/winterEntityNewRoot"
local epidemic_build_root_path = "PosGo/message/bg/epidemicBuildRoot"
local treasure_detect_obj_root_path = "PosGo/message/bg/TreasureDetectObjRoot"
local airship_donate_obj_root_path = "PosGo/message/bg/AirshipDonateObjRoot"
local flower_train_root_path = "PosGo/message/bg/FlowerTrainRoot"
local flower_train_reward_root_path = "PosGo/message/bg/FlowerTrainRewardRoot"
local dynamic_common_root_path = "PosGo/message/bg/dynamicCommonRoot"
local detect_dig_game_root_path = "PosGo/message/bg/DetectDigGameObjRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitDynamicComps()
  if self.rectTransform then
    self.rectTransform:SetAsFirstSibling()
  end
  self.gmHappyKey = GMUtils.AddHappy(BindRet(self, self.DebugHappyInfo))
end

local function OnDestroy(self)
  WorldDesertSelectEffectManager:GetInstance():HidePos()
  self:ComponentDestroy()
  self:DataDestroy()
  self:DestroyDynamicComps()
  base.OnDestroy(self)
  GMUtils.DelHappy(self.gmHappyKey)
  self.gmHappyKey = nil
end

function UIWorldPointView:OnAsyncLoaded(luaInst)
end

function UIWorldPointView:CreateDynamicComp_Deprecated(name, root, prefabPath, luaPath)
  local comp = UIAsyncLoaderBridge.New(self, name, root, prefabPath, luaPath, true, Bind(self, self.OnAsyncLoaded))
  if not self.dynamicComps then
    self.dynamicComps = {}
  end
  table.insert(self.dynamicComps, comp)
  return comp
end

function UIWorldPointView:CreateDynamicCompNew(name, prefabPath, luaPath)
  local comp = UIAsyncLoaderBridge.New(self, name, self.common_dynamic_root, prefabPath, luaPath, false, Bind(self, self.OnAsyncLoaded))
  if self.common_dynamic_root and self.common_dynamic_root.gameObject then
    self.common_dynamic_root.gameObject:SetActive(true)
  end
  if not self.dynamicComps then
    self.dynamicComps = {}
  end
  table.insert(self.dynamicComps, comp)
  return comp
end

function UIWorldPointView:InitDynamicComps()
  self.dynamicOtherPlayer = self:CreateDynamicComp_Deprecated("dynamicOtherPlayer", self.other_player_root, UIAssets.UIWorldPointComp_otherPlayer, luaPath_otherPlayer)
  self.dynamicCollect = self:CreateDynamicComp_Deprecated("dynamicCollect", self.collect_root, UIAssets.UIWorldPointComp_collect, luaPath_collect)
  self.dynamicDispatchTask = self:CreateDynamicComp_Deprecated("dynamicDispatchTask", self.dispatch_task_root, UIAssets.UIWorldPointComp_dispatchTask, luaPath_dispatch_task)
  self.dynamicMonster = self:CreateDynamicComp_Deprecated("dynamicMonster", self.monster_root, UIAssets.UIWorldPointComp_monster, luaPath_monster)
  self.dynamicFlowerCar = self:CreateDynamicComp_Deprecated("dynamicFlowerCar", self.flowerCar_root, UIAssets.UIWorldPointComp_flowerCar, luaPath_flowerCar)
  self.dynamicTrain = self:CreateDynamicComp_Deprecated("dynamicTrain", self.train_root, UIAssets.UIWorldPointComp_train, luaPath_train)
  self.dynamicHSR = self:CreateDynamicComp_Deprecated("dynamicHSR", self.hsr_Root, UIAssets.UIWorldPointComp_HSR, luaPath_HSR)
  self.dynamicWorldTrigger = self:CreateDynamicComp_Deprecated("dynamicWorldTrigger", self.worldTrigger_root, UIAssets.UIWorldPointComp_worldTrigger, luaPath_worldTrigger)
  self.dynamicSimpleMonster = self:CreateDynamicComp_Deprecated("dynamicSimpleMonster", self.simple_monster_obj_root, UIAssets.UIWorldPointComp_simpleMonster, luaPath_simpleMonster)
  self.dynamicMeteoriteInfo = self:CreateDynamicComp_Deprecated("dynamicMeteoriteInfo", self.meteorite_collection_root, UIAssets.UIWorldPointComp_meteoriteInfo, luaPath_meteoriteInfo)
  self.dynamicDrillObj = self:CreateDynamicComp_Deprecated("dynamicDrillObj", self.drill_obj_root, UIAssets.UIWorldPointComp_drillObj, luaPath_drillObj)
  self.dynamicZombieRush = self:CreateDynamicComp_Deprecated("dynamicZombieRush", self.zombie_rush_obj_root, UIAssets.UIWorldPointComp_zombieRushObj, luaPath_ZombieRushObj)
  self.dynamicBerserkBoss = self:CreateDynamicComp_Deprecated("dynamicBerserkBoss", self.berserk_boss_obj_root, UIAssets.UIWorldPointComp_BerserkBossObj, luaPath_BerserkBossObj)
  self.dynamicDesertObj = self:CreateDynamicComp_Deprecated("dynamicDesertObj", self.desert_obj_root, UIAssets.UIWorldPointComp_desertObj, luaPath_desertObj)
  self.dynamicDragonBuild = self:CreateDynamicComp_Deprecated("dynamicDragonBuild", self.dragon_build_root, UIAssets.UIWorldPointComp_dragonBuild, luaPath_dragonBuild)
  self.dynamicWinterEntityNew = self:CreateDynamicComp_Deprecated("dynamicWinterEntityNew", self.winter_entity_new_root, UIAssets.UIWorldPointComp_winterEntityNew, luaPath_winterEntityNew)
  self.dynamicEpidemicBuild = self:CreateDynamicComp_Deprecated("dynamicEpidemicBuild", self.epidemic_build_root, UIAssets.UIWorldPointComp_epidemicBuild, luaPath_epidemicBuild)
  self.dynamicTreasureDetectObj = self:CreateDynamicComp_Deprecated("dynamicTreasureDetectObj", self.treasure_detect_obj_root, UIAssets.UIWorldPointComp_TreasureDetectObj, luaPath_TreasureDetectObj)
  self.dynamicDetectZombieBusTrainObj = self:CreateDynamicComp_Deprecated("dynamicDetectZombieBusTrainObj", self.zombieBusTrainRoot, UIAssets.UIWorldPointComp_DetectZombieBusTrain, luaPath_DetectZombieBusTrain)
  self.dynamicAllianceBuild = self:CreateDynamicComp_Deprecated("dynamicAllianceBuild", self.alliance_build_root, UIAssets.UIWorldPointComp_AllianceBuildObj, luaPath_AllianceBuild)
  self.dynamicDetectDigGameObj = self:CreateDynamicComp_Deprecated("dynamicDetectDigGameObj", self.detect_dig_game_root, UIAssets.UIWorldPointComp_DetectDigGameObj, luaPath_DetectDigGameObj)
  self.dynamicAirshipDonate = self:CreateDynamicComp_Deprecated("dynamicAirshipDonate", self.airship_donate_obj_root, UIAssets.UIWorldPointComp_airshipDonate, luaPath_airshipDonate)
  self.dynamicFlowerTrainInfo = self:CreateDynamicCompNew("dynamicFlowerTrainInfo", UIAssets.UIWorldPointComp_FlowerTrain, luaPath_flowerTrain)
  self.dynamicFlowerTrainRewardInfo = self:CreateDynamicCompNew("dynamicFlowerTrainRewardInfo", UIAssets.UIWorldPointComp_FlowerTrainReward, luaPath_flowerTrainReward)
  self.dynamicBattlefieldBuilding = self:CreateDynamicCompNew("dynamicBattlefieldBuilding", UIAssets.UIWorldPointComp_battlefieldBuilding, luaPath_battlefieldBuilding)
  self.dynamicScoutDes = self:CreateDynamicCompNew("dynamicScoutDes", UIAssets.UIWorldPointComp_ScoutDes, luaPath_ScoutDes)
  self.dynamicWolfShadow = self:CreateDynamicCompNew("dynamicWolfShadow", UIAssets.UIWorldPointComp_wolfShadow, luaPath_wolfShadow)
  self.dynamicAllyDrillCow = self:CreateDynamicCompNew("dynamicAllyDrillCow", UIAssets.UIWorldPointComp_cow, luaPath_allyDrillCow)
  self.dynamicValentineStar = self:CreateDynamicCompNew("dynamicValentineStar", UIAssets.UIWorldPoint_ValentineStar, luaPath_valentineStar)
  self.dynamicS0AllianceDrillBuilding = self:CreateDynamicCompNew("dynamicS0AllianceDrillBuilding", UIAssets.UIS0AllianceDrillBuildingDescPrefab, UIWorldS0AllianceBuildDesc)
  self.dynamicS0AllianceDrillBoss = self:CreateDynamicCompNew("dynamicS0AllianceDrillBoss", UIAssets.UIS0AllianceDrillBossDescPrefab, UIWorldS0AllianceBossDesc)
end

local function ComponentDefine(self)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_go_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.pos_go_info = self:AddComponent(UIBaseContainer, pos_go_info_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_icon = self:AddComponent(UIImage, name_icon_path)
  self.name_icon:SetActive(false)
  self.name_icon_effect = self:AddComponent(UIBaseContainer, name_icon_effect_path)
  self.name_icon_effect:SetActive(false)
  self.quality = self:AddComponent(UIImage, "PosGo/message/bg/Top/name/quality")
  self.qualityEmptyCell = self:AddComponent(UIImage, "PosGo/message/bg/Top/name/emptyCell")
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.mapSticker = self:AddComponent(UIDecorationStickers, "SecondLevelPlane/mapStickers")
  self.other_player_root = self.transform:Find(other_player_root_path)
  self.collect_root = self.transform:Find(collect_root_path)
  self.dispatch_task_root = self.transform:Find(dispatch_task_root_path)
  self.monster_root = self.transform:Find(monster_root_path)
  self.flowerCar_root = self.transform:Find(flowerCar_root_path)
  self.train_root = self.transform:Find(train_root_path)
  self.hsr_Root = self.transform:Find(hsr_root_path)
  self.zombieBusTrainRoot = self.transform:Find(zombieBus_train_root_path)
  self.worldTrigger_root = self.transform:Find(world_trigger_root_path)
  self.simple_monster_obj_root = self.transform:Find(simple_monster_root_path)
  self.meteorite_collection_root = self.transform:Find(meteorite_collection_root_path)
  self.drill_obj_root = self.transform:Find(drill_obj_root_path)
  self.zombie_rush_obj_root = self.transform:Find(zombie_rush_obj_root_path)
  self.berserk_boss_obj_root = self.transform:Find(berserk_boss_obj_root_path)
  self.desert_obj_root = self.transform:Find(desert_obj_root_path)
  self.dragon_build_root = self.transform:Find(dragon_build_root_path)
  self.winter_entity_new_root = self.transform:Find(winter_entity_new_root_path)
  self.epidemic_build_root = self.transform:Find(epidemic_build_root_path)
  self.treasure_detect_obj_root = self.transform:Find(treasure_detect_obj_root_path)
  self.common_dynamic_root = self.transform:Find(dynamic_common_root_path)
  self.alliance_build_root = self.transform:Find(alliance_build_root)
  self.detect_dig_game_root = self.transform:Find(detect_dig_game_root_path)
  self.airship_donate_obj_root = self.transform:Find(airship_donate_obj_root_path)
  self.flower_train_obj_root = self.transform:Find(flower_train_root_path)
  self.flower_train_reward_obj_root = self.transform:Find(flower_train_reward_root_path)
  self.seanson_build_obj = self:AddComponent(WorldSeasonBuildDes, seanson_build_obj_path)
  self.act_boss_obj = self:AddComponent(WorldActBossDes, act_boss_obj_path)
  self.plunder_obj = self:AddComponent(WorldPlunderDes, plunder_obj_path)
  self.world_ruin_build = self:AddComponent(WorldRuinBuildDes, world_ruin_build_path)
  self.challenge_obj = self:AddComponent(WorldChallengeDes, challenge_obj_path)
  self.fristClickPlayerTip = self:AddComponent(UIBaseContainer, "PosGo/message/bgArrow/firstShowHead")
  self.bg_arrow_up = self:AddComponent(UIImage, bg_arrow_up_path)
  self.bg_arrow = self:AddComponent(UIImage, bg_arrow_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.ghostrecon_obj = self:AddComponent(WorldPointGhostrecon, ghostrecon_obj_path)
  self.tip_obj = self:AddComponent(UIBaseContainer, tip_obj_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.tipObjLayoutGroup = self.tip_obj.gameObject:GetComponent(UnityHorizontalOrVerticalLayoutGroup)
  self.tipObjLayoutGroupPretop = self.tipObjLayoutGroup.padding.top
  self.btn_virus = self:AddComponent(UIButton, btn_virus_path)
  self.virus_level_text = self:AddComponent(UIText, virus_level_text_path)
  self.virus_bg = self:AddComponent(UIImage, virus_bg_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.imgTopBg = self:AddComponent(UIImage, top_bg_path)
  self.top2 = self:AddComponent(WorldHeadInfo, top2_path)
  self.property = self:AddComponent(WorldPropertyShow, property_path)
  self.btn_king = self:AddComponent(UIButton, btn_king_path)
  self.btn_king:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnKingClick()
  end)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
  self.btn_alliance_mark = self:AddComponent(UIButton, btn_alliance_share_path)
  self.btn_alliance_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(true)
  end)
  self.btnMarkImg = self:AddComponent(UIImage, btn_mark_path)
  self.guide_garbage = self:AddComponent(GuideGarbageInfo, guide_garbage_path)
  self.guide_garbage:SetActive(false)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    self:OnShareClick()
  end)
  self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
  self.btn_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDetailClick()
  end)
  self.btn_detail:SetActive(true)
  self.btn_return = self:AddComponent(UIButton, btn_return_path)
  self.btn_return:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnReturnClick()
  end)
  self.btn_return:SetActive(false)
  self.fristClickPlayerTip:SetActive(false)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.mapStikerAASP = self.transform:Find(mapSticker):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.posGoComponent = self:AddComponent(UIBaseComponent, pos_go_path)
  self.model = {}
  self.career_label = self:AddComponent(UICareerLabel, career_label_path)
  self.btn_virus:SetActive(false)
  self.btn_virus:SetOnClick(function()
    if self.info and self.info.pointData then
      local virusLayer = toInt(self.info.pointData.virusLayer)
      if 0 < virusLayer then
        if self.info.pointData.virusProbability ~= nil and self.info.pointData.virusProbability ~= 0 then
          local param = {}
          param.howToPlayList = {101009}
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
          return
        end
        if UIUtil.ShowS1HowToPlay(101003) then
          return
        end
        UIUtil.ShowTips(Localization:GetString("season_tips198", virusLayer))
      end
    end
  end)
  self.season_frozen_tips = self:AddComponent(SeasonFrozenStatus, season_frozen_tips_path)
  self.season_frozen_tips:SetActive(false)
  self.test_btn = self:AddComponent(UIButton, test_btn_path)
  self.test_btn:SetActive(false)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:SetActive(false)
  self.refresh_btn:LoadSpriteAuto("Assets/Main/Sprites/UI/UIBuildBtns/mjc_zhujiemian_qiehuan.png")
  self.refresh_btn:SetOnClick(function()
    self.pos_go:SetActive(false)
    if self.buttonAroundPlane == nil then
      local luaPath = "UI.UIWorldPoint.Component.WorldButtonAroundPlane"
      local prefabPath = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ButtonAroundPlane.prefab"
      self.buttonAroundPlane = self:LoadComponentAsync(luaPath, prefabPath, self)
      self.buttonAroundPlane:SetData(self.info.pointData, self.ctrl.pointId, UIWorldPointBtn)
    else
      self.buttonAroundPlane:ShowMe(self.info.pointData, self.ctrl.pointId, UIWorldPointBtn)
    end
  end)
  self.six_build_btn = self:AddComponent(UIWorldPointBtn, six_build_btn_path)
  self.six_build_btn:SetActive(false)
  self.frameImg = self:AddComponent(UIImage, frame_path)
  self.frameImg:SetActive(false)
  self.imgTopBg:SetActive(false)
end

local function ComponentDestroy(self)
  if self.tipObjLayoutGroup and self.tipObjLayoutGroupPretop then
    self.tipObjLayoutGroup.padding.top = self.tipObjLayoutGroupPretop
  end
  self.tipObjLayoutGroup = nil
  self.tipObjLayoutGroupPretop = nil
  if self.delayAutoFitUI then
    self.delayAutoFitUI:Stop()
    self.delayAutoFitUI = nil
  end
  self:OnDestroyReq()
  self.refresh_btn = nil
  self.pos_go = nil
  self.name_text = nil
  self.timer_action = nil
  self.timer_actionArrow = nil
  self.build_btn_obj = nil
  self.build_btn_go = nil
  self.this_anim = nil
  self.build_btn_anim = nil
  self.btn_mark = nil
  self.btn_share = nil
  self.btn_detail = nil
  self.btn_return = nil
  self.AutoAdjustScreenPos = nil
  self.model = nil
  self.guide_garbage = nil
  self.career_label = nil
  self.posGoComponent = nil
  self.top = nil
  self.top2 = nil
  self.property = nil
  self.btn_virus = nil
  self.virus_level_text = nil
  self.virus_bg = nil
  self.season_frozen_tips = nil
  self.meteoriteCollection = nil
  self.frameImg = nil
end

function UIWorldPointView:OnDestroyReq()
  for _, cfg in pairs(LoadAssetMap) do
    if cfg and cfg.name then
      local node = self[cfg.name]
      if node then
        node:Delete()
        self[cfg.name] = nil
      end
    end
  end
  if self.contentPanelReq ~= nil then
    self:GameObjectDestroy(self.contentPanelReq)
    self.contentPanelReq = nil
  end
  if self.viewTopReq ~= nil then
    self:GameObjectDestroy(self.viewTopReq)
    self.viewTopReq = nil
  end
  if self.bg_go ~= nil then
    self.bg_go:RemoveAllComponentes()
  end
  self.contentPanelCom = nil
  self.viewTopCom = nil
end

local function DataDefine(self)
  self.worldPos = nil
  self.screenPos = nil
  self.buildBtnCells = {}
  self.closeTimer = nil
  self.targetBtnPos = 0
  WorldArrowManager:GetInstance():RemoveEffect()
end

local function DataDestroy(self)
  self:RemoveUpdate()
  self.worldPos = nil
  self.screenPos = nil
  self.buildBtnCells = nil
  self.closeTimer = nil
  self.targetBtnPos = nil
  self.bossIsProtected = nil
end

function UIWorldPointView:DestroyDynamicComps()
  if self.dynamicComps then
    for k, v in ipairs(self.dynamicComps) do
      if v then
        v:Delete()
      end
    end
  end
  self.dynamicComps = nil
  self.dynamicOtherPlayer = nil
  self.dynamicCollect = nil
  self.dynamicDispatchTask = nil
  self.dynamicMonster = nil
  self.dynamicFlowerCar = nil
  self.dynamicTrain = nil
  self.dynamicWorldTrigger = nil
  self.dynamicSimpleMonster = nil
  self.dynamicMeteoriteInfo = nil
  self.dynamicDragonBuild = nil
  self.dynamicWinterEntity = nil
  self.dynamicWinterEntityNew = nil
  self.dynamicEpidemicBuild = nil
  self.dynamicDetectZombieBusTrainObj = nil
  self.dynamicDetectDigGameObj = nil
  self.dynamicAirshipDonate = nil
  self.dynamicFlowerTrainInfo = nil
  self.dynamicFlowerTrainRewardInfo = nil
  self.dynamicWolfShadow = nil
  self.dynamicAllyDrillCow = nil
  self.dynamicBattlefieldBuilding = nil
  self.dynamicScoutDes = nil
  self.dynamicValentineStar = nil
  self.dynamicS0AllianceDrillBuilding = nil
  self.dynamicS0AllianceDrillBoss = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
  self:PostProcessDispatchTask()
end

local function OnDisable(self)
  if self.ctrl.type == WorldPointUIType.ActBoss then
    WorldBossBloodTipManager:GetInstance():SetViewClose()
  end
  if self.ctrl.type == WorldPointUIType.MonsterLock then
    DataCenter.MonsterLockBubbleManager:ResetAllBubble()
  end
  self:RemoveUpdate()
  self.ctrl:ClearData()
  self.needReInit = nil
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIWorldPointView, self.RefreshUIWorldPointViewSignal)
  self:AddUIListener(EventId.WorldPointDetail, self.SetData)
  self:AddUIListener(EventId.GetSingleGarbageInfoSuccess, self.RefreshRewardList)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.ShowActBossBattleValue, self.UpdateActBossBlood)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.SetData)
  self:AddUIListener(EventId.RunningBossTodaySkillChange, self.RunningBossTodaySkill)
  self:AddUIListener(EventId.WorldGetAllianceCollectResDetailUpdate, self.SetData)
  self:AddUIListener(EventId.PointObjectUpdate, self.PointObjectUpdateCall)
  self:AddUIListener(EventId.GetBerserkBossDetailData, self.SetData)
  self:AddUIListener(EventId.UIAsyncLoadDynamicPrefabFinish, self.OnAsyncLoadFinish)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIWorldPointView, self.RefreshUIWorldPointViewSignal)
  self:RemoveUIListener(EventId.WorldPointDetail, self.SetData)
  self:RemoveUIListener(EventId.GetSingleGarbageInfoSuccess, self.RefreshRewardList)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.ShowActBossBattleValue, self.UpdateActBossBlood)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.SetData)
  self:RemoveUIListener(EventId.RunningBossTodaySkillChange, self.RunningBossTodaySkill)
  self:RemoveUIListener(EventId.WorldGetAllianceCollectResDetailUpdate, self.SetData)
  self:RemoveUIListener(EventId.PointObjectUpdate, self.PointObjectUpdateCall)
  self:RemoveUIListener(EventId.GetBerserkBossDetailData, self.SetData)
  self:RemoveUIListener(EventId.UIAsyncLoadDynamicPrefabFinish, self.OnAsyncLoadFinish)
  base.OnRemoveListener(self)
end

function UIWorldPointView:OnAsyncLoadFinish()
  if ComponentIsValid(self.bg) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.rectTransform)
  end
end

local function ReInit(self)
  self:RemoveUpdate()
  self.serverData = nil
  self.info = self.ctrl:GetPointData()
  self.bossIsProtected = nil
  if self.tipObjLayoutGroup and self.tipObjLayoutGroupPretop then
    self.tipObjLayoutGroup.padding.top = self.tipObjLayoutGroupPretop
  end
  if self.ctrl.type == WorldPointUIType.City and (self.info == nil or self.info.pointData == nil) then
    self.ctrl:CloseSelf()
    return
  end
  if self.ctrl.type == WorldPointUIType.Desert or self.ctrl.type == WorldPointUIType.Ruin then
    WorldDesertSelectEffectManager:GetInstance():ShowPos(self.ctrl.pointId)
    if self.test_btn and CS.CommonUtils.IsDebug() and CS.SDKManager.IS_UNITY_EDITOR() then
      local ownerUid = self.view.ctrl.ownerUid
      if ownerUid ~= LuaEntry.Player:GetUid() and LuaEntry.Player:IsInSelfServer() then
        self.test_btn:SetActive(true)
      else
        self.test_btn:SetActive(false)
      end
    end
  else
    WorldDesertSelectEffectManager:GetInstance():HidePos()
  end
  self.pos_go:SetActive(true)
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.mapSticker:ReInit(MapStickerOpenType.Wrold, function()
    self:ShowStickerPlane(false)
  end)
  self.quality:SetActive(false)
  self.qualityEmptyCell:SetActive(true)
  if self.info ~= nil then
    local tileX = BuildTilesSize.One
    local tileY = BuildTilesSize.One
    self.worldPos = BuildingUtils.GetBuildModelCenterVec(self.ctrl.pointId, tileX, tileY, ForceChangeScene.World, self.ctrl.serverId)
    local x, y = self.transform:Get_lossyScale()
    local lossyScale = y
    if lossyScale <= 0 then
      lossyScale = 1
    end
    self.bg:SetLocalPositionXYZ(0, 0, 0)
    if VIEW_WIDTH_CONFIG[self.ctrl.type] ~= nil then
      self.bg:SetSizeDeltaX(VIEW_WIDTH_CONFIG[self.ctrl.type])
    else
      self.bg:SetSizeDeltaX(VIEW_DEFAULT_WIDTH)
    end
    self.bg_arrow_up:SetActive(false)
    self.bg_arrow:SetActive(true)
    self.bg_arrow:SetLocalPositionXYZ(0, -6.6, 0)
    local isMarch = self.info.pointData and self.info.pointData.marchType ~= nil
    if self.ctrl.type ~= WorldPointUIType.SingleMapGarbage and self.ctrl.type ~= WorldPointUIType.Train and self.ctrl.type ~= WorldPointUIType.HSR and self.ctrl.type ~= WorldPointUIType.DetectZombieBusTrain and self.ctrl.type ~= WorldPointUIType.S1RestBloodyQueenMonster and self.ctrl.type ~= WorldPointUIType.FlowerTrain and isMarch and self.info.pointData.marchType ~= NewMarchType.RUNNING_BOSS and self.info.pointData.marchType ~= NewMarchType.RUNNING_MUMMY and self.info.pointData.marchType ~= NewMarchType.MUMMY and self.info.pointData.marchType ~= NewMarchType.SANDFISH and self.info.pointData.marchType ~= NewMarchType.ZONE_MOBILIZATION_BOSS and not self.info.pointData.isMoving and self.info.pointData.marchType ~= NewMarchType.BEHEMOTH_BOSS then
      UIUtil.ClickBuildAdjustCameraView(self.worldPos, BuildAdjust, lossyScale, self.ctrl.serverId)
    end
    self.AutoAdjustScreenPos:Init(self.worldPos)
    if self.info and self.info.pointData and self.info.pointData.special == WorldMonsterSpecialType.SmallSandWorm then
      self.AutoAdjustScreenPos:Init(self.worldPos + Vector3.forward * 5)
    end
    self.mapStikerAASP:Init(self.worldPos)
    self.mapStikerAASP.gameObject:SetActive(false)
    self.AutoAdjustScreenPos.enabled = true
    if isMarch then
      if self.info.pointData.marchType == NewMarchType.RUNNING_BOSS or self.info.pointData.marchType == NewMarchType.RUNNING_MUMMY or self.info.pointData.marchType == NewMarchType.MUMMY or self.info.pointData.marchType == NewMarchType.SANDFISH or self.info.pointData.marchType == NewMarchType.ZONE_MOBILIZATION_BOSS or self.info.pointData.marchType == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN or self.info.pointData.marchType == NewMarchType.BEHEMOTH_BOSS or self.ctrl.type == WorldPointUIType.S1RestBloodyQueenMonster or self.info.pointData.marchType == NewMarchType.FLOWER_TRAIN then
        local anchoredPositionY = 0
        if self.info.pointData.marchType == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN then
          anchoredPositionY = -300
        end
        if self.ctrl.type == WorldPointUIType.S1RestBloodyQueenMonster then
          anchoredPositionY = 100
        end
        if self.info.pointData.marchType == NewMarchType.FLOWER_TRAIN then
          anchoredPositionY = -500
        end
        self.posGoComponent:SetAnchoredPositionXY(0, anchoredPositionY)
        self.AutoAdjustScreenPos.enabled = false
      elseif self.info.pointData.isMoving then
        self.posGoComponent:SetAnchoredPositionXY(0, -188)
        self.AutoAdjustScreenPos.enabled = false
      end
    end
    if self.ctrl.type == WorldPointUIType.Monster or self.ctrl.type == WorldPointUIType.Boss or self.ctrl.type == WorldPointUIType.SandWorm then
      local virusLayer = toInt(self.info.pointData.virusLayer)
      self.btn_virus:SetActive(0 < virusLayer)
      self.virus_level_text:SetText("+" .. virusLayer)
      if self.info.pointData.virusProbability ~= nil and self.info.pointData.virusProbability ~= 0 then
        self.virus_bg:LoadSpriteAsync("Assets/Main/Sprites/UI/UISeason/Sprites/SeasonMain/Mjc_pop_bingdu_bg.png")
      else
        self.virus_bg:LoadSpriteAsync("Assets/Main/Sprites/LodIcon/Mjc_saiji2_pop_bingdu_bg.png")
      end
      local levelStr = self.info.pointData.marchType == NewMarchType.SANDFISH and "???" or self.info.pointData.level
      self.name_text:SetLocalText(140205, levelStr, "")
    elseif self.ctrl.type == WorldPointUIType.DrillBase or self.ctrl.type == WorldPointUIType.ChallengeBoss or self.ctrl.type == WorldPointUIType.AllyDrillHugeSandWorm or self.ctrl.type == WorldPointUIType.AllyDrillRoadHog then
      local t = Localization:GetString(self.info.pointData.name)
      self.name_text:SetLocalText(140205, self.info.pointData.level, t)
    elseif self.ctrl.type == WorldPointUIType.CollectPoint then
      if BattleFieldUtil.InBattleField() then
        self.name_text:SetLocalText(self.info.pointData.shareName)
      else
        self.name_text:SetText(self.info.pointData.name)
      end
    elseif self.ctrl.type == WorldPointUIType.MeteoriteResPoint then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.MeteoriteResCollectArmy then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.Build and self.info.isSeasonPlayerBuilding then
      self.name_text:SetText("")
    elseif self.ctrl.type == WorldPointUIType.CityResPoint then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.AllianceCollectPoint then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.WolfShadow then
      self.name_text:SetLocalText("season_s4_blood_hunter_shadow_name")
    elseif self.ctrl.type == WorldPointUIType.CollectArmy then
      local pd = self.info.pointData
      local pdName = ""
      if not string.IsNullOrEmpty(pd.name) then
        pdName = Localization:GetString(pd.name)
      end
      self.name_text:SetText(Localization:GetString("104290", pd.level, pdName))
    elseif self.ctrl.type == WorldPointUIType.Explore or self.ctrl.type == WorldPointUIType.DetectEventFakePVP or self.ctrl.type == WorldPointUIType.DetectEventPVE or self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect or self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint or self.ctrl.type == WorldPointUIType.WorldDetectSurvivor or self.ctrl.type == WorldPointUIType.DetectRetryResource or self.ctrl.type == WorldPointUIType.DominatorGuide or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_1 or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_2 then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.Treasure then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.Sample then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.DetectEventSuppliesSearch then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.Rescue then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.PickGarbage then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.SingleMapGarbage then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.MonsterLock then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.MonsterReward then
      self.name_text:SetLocalText(104190)
    elseif self.ctrl.type == WorldPointUIType.ActBoss then
      self.name_text:SetText(Localization:GetString(self.info.pointData.name))
    elseif self.ctrl.type == WorldPointUIType.PuzzleBoss then
      self.name_text:SetText(Localization:GetString(self.info.pointData.name))
    elseif self.ctrl.type == WorldPointUIType.DispatchTask then
      self.name_text:SetText("")
    elseif self.ctrl.type == WorldPointUIType.Ghostrecon then
      self.name_text:SetText("")
    elseif self.ctrl.type == WorldPointUIType.DragonBuild or self.ctrl.type == WorldPointUIType.WinterEntity or self.ctrl.type == WorldPointUIType.EpidemicBuild then
      self.name_text:SetText(Localization:GetString(self.info.pointData.name))
    elseif self.ctrl.type == WorldPointUIType.PlayerKillMonsterTreasure then
      local name = "season_s4_monster_tips30"
      local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
      cast(info, typeof(CS.TreasurePointInfo))
      local worldTreasureType = info and info:GetWorldTreasureType()
      if worldTreasureType and worldTreasureType == WorldTreasureType.GeneFragment then
        local temp = DataCenter.TreasureTemplateManager:GetTemplate(tonumber(info.eventId))
        if temp and not string.IsNullOrEmpty(temp.name) then
          name = temp.name
        end
      end
      self.name_text:SetLocalText(name)
    elseif self.ctrl.type == WorldPointUIType.WorldDetectCaveExploration then
      local param = {}
      param.isShowIcon = false
      param.nameText = self.info.pointData.name
      param.isHideRolle = true
      param.height = 0
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.info.pointData.eventId)
      if template ~= nil and template:IsRollTreasure() then
        UIUtil.CheckEventTrigger(OpMode.ClickBtnS4WinePub)
      end
      if string.IsNullOrEmpty(self.info.pointData.panel_image) then
        param.lordBannerPath = "Assets/Main/SeasonRes/S3/Textures/WorldPointBanner/ljq_leidaduobao_tips.png"
      else
        param.lordBannerPath = self.info.pointData.panel_image
      end
      self.top2:RefreshData(param)
    elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
      local triggerMeta = DataCenter.WorldTriggerTemplateManager:GetMeta(self.info.pointData.cfgId)
      if triggerMeta then
        self.name_text:SetText(triggerMeta:GetName())
      end
    elseif self.ctrl.type == WorldPointUIType.Train then
      if self.ctrl.trainData.type == TrainType.Truck then
        self.name_text:SetLocalText(457525)
      else
        self.name_text:SetLocalText(self.ctrl.trainData.buyFlag == 0 and 458503 or "alliance_train_vip019")
      end
      self.quality:SetActive(true)
      self.quality:LoadSprite(self.info.pointData:GetQualityPath())
      self.qualityEmptyCell:SetActive(false)
      self:AddUpdate()
      self.AutoAdjustScreenPos.enabled = false
    elseif self.ctrl.type == WorldPointUIType.HSR then
      self.name_text:SetText("")
      local param = {}
      param.lordBannerPath = "Assets/Main/SeasonRes/S5/Textures/HighSpeedRailway/LXYS5_zhanquhuoche_19_banner.png"
      param.banner2AnchoredPositionY = 137
      param.banner2SizeDeltaY = 746
      param.isShowIcon = false
      param.isHideRolle = true
      self.top2:RefreshData(param)
      self:AddUpdate()
      self.posGoComponent:SetAnchoredPositionXY(0, -220)
      self.AutoAdjustScreenPos.enabled = false
    elseif self.ctrl.type == WorldPointUIType.Desert or self.ctrl.type == WorldPointUIType.Ruin then
      local level = self.info.pointData.level
      local name_prev = ""
      if level ~= nil and 0 < level then
        if self.ctrl.ownerUid == nil or self.ctrl.ownerUid == "" or self.ctrl.ownerUid == 0 then
          name_prev = UIUtil.GetString("\230\177\161\230\159\147\231\154\132", "season_tiles_first_name")
        end
        self.name_text:SetText("Lv." .. level .. " " .. name_prev .. Localization:GetString(self.info.pointData.name, level))
      else
        self.name_text:SetText(Localization:GetString("110245"))
      end
    elseif self.ctrl.type == WorldPointUIType.CityAttachmentBuild then
      self.name_text:SetText(self.info.pointData.name)
      if self.info.pointData.state == 0 then
        self.name_icon:SetActive(true)
        self.name_icon:SetEnable(false)
        self.name_icon_effect:SetActive(true)
      else
        self.name_icon:SetActive(false)
        self.name_icon_effect:SetActive(false)
      end
    elseif self.ctrl.type == WorldPointUIType.AllianceMine or self.ctrl.type == WorldPointUIType.AllianceActMine then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
      local level = toInt(self.info.pointData.level)
      local seasonType = SeasonUtil.GetSeasonType()
      if 0 < level and SeasonUtil.SeasonHasMilitaryCenter(seasonType) then
        self.name_text:SetText("Lv." .. level .. " " .. Localization:GetString(self.info.pointData.name))
      else
        self.name_text:SetText(Localization:GetString(self.info.pointData.name))
      end
    elseif self.ctrl.type == WorldPointUIType.ZombieRush then
      self.name_text:SetText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.Aisilla then
      self.name_text:SetLocalText(140205, self.info.pointData.level, "")
    elseif self.ctrl.type == WorldPointUIType.ZoneMobilization then
      local name = self.info and self.info.pointData and self.info.pointData.name
      if not string.IsNullOrEmpty(name) then
        self.name_text:SetText(name)
      else
        self.name_text:SetText("")
      end
    elseif self.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
      self.name_text:SetLocalText(140205, self.info.pointData.level, "")
    elseif self.ctrl.type == WorldPointUIType.DetectZombieBusTrain then
      local name = ""
      local zombieBusEvent = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
      if zombieBusEvent and zombieBusEvent.busList then
        local busList = zombieBusEvent.busList
        local busListCount = #busList
        local busData, i = DataCenter.RadarCenterDataManager:GetOneCanAttackZombieBusData(busList)
        local preName = zombieBusEvent.template:GetRealName()
        name = string.format("%s (%d/%d)", preName, i, busListCount)
      end
      self.name_text:SetText(name)
    elseif self.ctrl.type == WorldPointUIType.KillZombieKirovBoss then
      self.name_text:SetLocalText("")
    elseif self.ctrl.type == WorldPointUIType.TreasureChest then
      self.name_text:SetLocalText(self.info.pointData.name)
    elseif self.ctrl.type == WorldPointUIType.SkyBattle then
      self.name_text:SetLocalText(self.info.pointData.name)
    end
    if CS.SceneManager:IsInCity() or self.ctrl.type == WorldPointUIType.CollectPoint or self.ctrl.type == WorldPointType.MONSTER_REWARD or self.ctrl.type == WorldPointUIType.Sample or self.ctrl.type == WorldPointUIType.PickGarbage or self.ctrl.type == WorldPointUIType.SingleMapGarbage or self.ctrl.type == WorldPointUIType.CollectArmy or self.ctrl.type == WorldPointUIType.WinterEntity or self.ctrl.type == WorldPointUIType.DrillBase or self.ctrl.type == WorldPointUIType.ZombieRush or self.ctrl.type == WorldPointUIType.City and self.info.pointData and self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent or self.ctrl.type == WorldPointUIType.City and self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent or self.ctrl.type == WorldPointUIType.Rescue or self.ctrl.type == WorldPointUIType.Ghostrecon or self.ctrl.type == WorldPointUIType.WorldDetectCaveExploration or self.ctrl.type == WorldPointUIType.PlayerKillMonsterTreasure or self.ctrl.type == WorldPointUIType.ZoneMobilization or self.ctrl.type == WorldPointUIType.WorldRuinDestroyBuilding or self.ctrl.type == WorldPointUIType.MeteoriteResPoint or self.ctrl.type == WorldPointUIType.MeteoriteResCollectArmy or self.ctrl.type == WorldPointUIType.DetectRetryRescue or self.ctrl.type == WorldPointUIType.DetectRetryResource or self.ctrl.type == WorldPointUIType.DetectZombieBusTrain or self.ctrl.type == WorldPointUIType.TreasureChest or self.ctrl.type == WorldPointUIType.SkyBattle or self.ctrl.type == WorldPointUIType.DetectEventSuppliesSearch or self.ctrl.type == WorldPointUIType.DetectAttackCityS0Monster or self.ctrl.type == WorldPointUIType.DispatchTask or self.ctrl.type == WorldPointUIType.S0AllianceDrillBuilding or self.ctrl.type == WorldPointUIType.S0AllianceDrillBoss then
      self.btn_return:SetActive(false)
      self.btn_detail:SetActive(false)
      self.qualityEmptyCell:SetActive(true)
    else
      self.btn_return:SetActive(false)
      self.btn_detail:SetActive(true)
      self.qualityEmptyCell:SetActive(false)
    end
    if self.ctrl.type == WorldPointUIType.EpidemicBuild then
      local battlefieldType = self.info.battlefieldType
      self.btn_detail:SetActive(battlefieldType >= BattleFieldType.NewBattleTypeStart)
    end
    self.season_frozen_tips:SetActive(false)
    if self.ctrl.type == WorldPointUIType.City and 0 >= LuaEntry.Player:GetCurWorldId() then
      local governmentInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(self.ctrl.ownerUid)
      local positionId
      if governmentInfo ~= nil then
        positionId = governmentInfo.positionId
      elseif self.info and self.info.pointData and self.info.pointData.positionId then
        positionId = self.info.pointData.positionId
      end
      if positionId == 10001 or positionId == "10001" then
        self.btn_king:SetActive(false)
      else
        local serverId = self.ctrl.serverId
        if DataCenter.GovernmentManager:OfficerCrossOpen() and self.info and self.info.pointData and self.info.pointData.srcServerId then
          serverId = self.info.pointData.srcServerId
        end
        self.btn_king:SetActive(self.ctrl.ownerUid ~= LuaEntry.Player.uid and (LuaEntry.Player:IsPresident(serverId) or LuaEntry.Player:IsFirstLady(serverId)))
      end
    else
      self.btn_king:SetActive(false)
      if self.ctrl.type == WorldPointUIType.Boss then
        local marchInfo = CS.SceneManager.World:GetMarch(self.ctrl.uuid)
        if marchInfo then
          self.season_frozen_tips:Refresh(self.ctrl.type, marchInfo.thermalConductor, nil, self.ctrl.uuid)
        end
      elseif self.ctrl.type ~= WorldPointUIType.AllianceMine and self.ctrl.type ~= WorldPointUIType.WorldSuppliesPoint and self.ctrl.type ~= WorldPointUIType.ZoneMobilizationSuppliesPoint and self.ctrl.type ~= WorldPointUIType.DarknessSuppliesPoint and self.ctrl.type ~= WorldPointUIType.KillZombieKirovBox and self.ctrl.type ~= WorldPointUIType.SandWorm and not BattleFieldUtil.InBattleField() then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
        if pointInfo then
          self.season_frozen_tips:Refresh(self.ctrl.type, pointInfo.thermalConductor, nil, self.ctrl.uuid)
        end
      end
    end
    self:ShowTopBtn()
    self:RefreshMarkBtnImg()
    self:RefreshAllianceMarkBtn()
    self:ShowBtn()
    self:ShowGuideGarbage()
    self.pos_go:SetActive(true)
    self.mapStikerAASP.gameObject:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.rectTransform)
    if self.ctrl.type == WorldPointUIType.DragonBuild or self.ctrl.type == WorldPointUIType.EpidemicBuild or self.ctrl.type == WorldPointUIType.CollectPoint or self.ctrl.type == WorldPointUIType.CollectArmy then
      local size = self.bg:GetSizeDelta()
      self.bg:SetLocalPositionXYZ(0, 0.2 * size.y, 0)
      self.bg_arrow:SetLocalPositionXYZ(0, 0.2 * size.y - 6.6, 0)
    elseif self.ctrl.type == WorldPointUIType.WinterEntity then
      local size = self.bg:GetSizeDelta()
      self.bg:SetLocalPositionXYZ(0, 0.5 * size.y, 0)
      self.bg_arrow:SetLocalPositionXYZ(0, 0.5 * size.y - 6.6, 0)
    elseif self.ctrl.type == WorldPointUIType.KillZombieKirovBoss or self.ctrl.type == WorldPointUIType.KillZombieKirovBox then
      self.bg_arrow:SetLocalPositionXYZ(0, -14.2, 0)
    end
    if self.delayAutoFitUI then
      self.delayAutoFitUI:Stop()
    end
    if ComponentIsValid(self.bg) then
      self.bg:SetAlpha(1)
    end
    if self.ctrl.type == WorldPointUIType.Treasure then
      self.pos_go_info:SetAnchoredPositionXY(0, 230)
    elseif self.ctrl.type == WorldPointUIType.FlowerTrain then
      self.pos_go_info:SetAnchoredPositionXY(0, 0)
    elseif self.ctrl.type == WorldPointUIType.S0AllianceDrillBoss then
      self.pos_go_info:SetAnchoredPositionXY(0, 25)
      if ComponentIsValid(self.bg) then
        self.bg:SetAlpha(0)
      end
    else
      self.pos_go_info:SetAnchoredPositionXY(0, 94)
      self.delayAutoFitUI = TimerManager:GetInstance():DelayFrameInvoke(function()
        self:ReAutoFitUI()
      end, 5)
    end
  end
end

function UIWorldPointView:ReAutoFitUI()
  if not self.bg then
    return
  end
  local yy = 700 - self.bg:GetSizeDelta().y
  if yy < 0 then
    self.pos_go_info:SetAnchoredPositionXY(0, yy + 94)
    self.build_btn_obj:SetAnchoredPositionXY(0, yy - 47)
  else
    self.pos_go_info:SetAnchoredPositionXY(0, 94)
    self.build_btn_obj:SetAnchoredPositionXY(0, -47)
  end
end

function UIWorldPointView:ShowStickerPlane(isShow)
  self.pos_go:SetActive(not isShow)
  self.mapStikerAASP.gameObject:SetActive(isShow)
  if self.buttonAroundPlane then
    self.buttonAroundPlane:SetActive(false)
  end
end

function UIWorldPointView:PlayFirstPlayerClickGuide(icon)
  local key = "world_click_Player" .. LuaEntry.Player.uid
  CommonUtil.PlayerPrefsSetBool(key, false)
  if not self.fristClickPlayerTip then
    return
  end
  self:PlayClickGuide(icon)
  self.fristClickPlayerTip:SetActive(true)
  CommonUtil.PlayerPrefsSetBool(key, false)
end

function UIWorldPointView:PlayFireworkClickGuide(btn)
  self:PlayClickGuide(btn)
  DataCenter.LWFireworkManager:SetNeedShowWorldPointGuide(false)
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:RemoveFingerArrow()
  end, 3)
end

function UIWorldPointView:PlayClickGuide(component)
  if not component then
    return
  end
  local lparam = {}
  lparam.position = component.transform.position
  lparam.position.x = lparam.position.x + component.rectTransform.rect.width / 2
  lparam.position.y = lparam.position.y - component.rectTransform.rect.height / 2
  lparam.positionType = PositionType.Screen
  DataCenter.ArrowManager:ShowFingerArrow(lparam)
end

function UIWorldPointView:DebugHappyInfo()
  local sb = StringBuilder.New()
  if self.ctrl then
    local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    if info and info.Description then
      sb:AppendFormat(info:Description())
    else
      return nil
    end
  end
  return sb:ToString()
end

local function SetData(self)
  if self.ctrl.type == WorldPointUIType.Train then
    self.dynamicTrain:RefreshData(self.info.pointData)
    return
  end
  if self.ctrl.type == WorldPointUIType.HSR then
    self.dynamicHSR:RefreshData()
    return
  end
  if self.ctrl.type == WorldPointUIType.DetectZombieBusTrain then
    self.dynamicDetectZombieBusTrainObj:RefreshData(self.info.pointData)
    return
  end
  if self.ctrl.type == WorldPointUIType.WolfShadow then
    self.dynamicWolfShadow:RefreshData(self.info.pointData)
    self.name_text:SetLocalText("season_s4_blood_hunter_shadow_name")
    return
  end
  if self.ctrl.type == WorldPointUIType.PickGarbage then
    self.info = self.ctrl:GetPointData()
    self.dynamicMonster:RefreshData(self.info.pointData)
    self.career_label:SetActive(false)
    self.plunder_obj:SetActive(false)
    return
  end
  if self.ctrl.type == WorldPointUIType.City and (self.info == nil or self.info.pointData == nil) then
    self.ctrl:CloseSelf()
    return
  end
  local serverData = self.ctrl:GetPlayerData(self.ctrl.pointId)
  self.serverData = serverData
  if serverData ~= nil then
    if self.ctrl.type == WorldPointUIType.Road or self.ctrl.type == WorldPointUIType.City or self.ctrl.type == WorldPointUIType.Build then
      if self.info.isSeasonPlayerBuilding then
        self.plunder_obj:SetActive(false)
        self.dynamicOtherPlayer:SetActive(false)
        self.seanson_build_obj:SetActive(true)
        self.seanson_build_obj:UpdateInfo(serverData)
        self.name_text:SetText(self.seanson_build_obj:GetName())
      else
        local playerName = ""
        if serverData.playerData then
          local name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(serverData.playerData.uid, serverData.playerData.name)
          playerName = UIUtil.FormatServerAllianceName(serverData.playerData.srcServer, serverData.playerData.alAbbr, name)
        end
        local key = "world_click_Player" .. LuaEntry.Player.uid
        local isFristClicPlayer = CommonUtil.PlayerPrefsGetBool(key, true)
        if isFristClicPlayer then
          self.dynamicOtherPlayer:PlayerHeadClickGuide(Bind(self, self.PlayFirstPlayerClickGuide))
        end
        if DataCenter.LWFireworkManager:GetNeedShowWorldPointGuide() then
          self.dynamicOtherPlayer:FireworkBtnClickGuide(Bind(self, self.PlayFireworkClickGuide))
        end
        CommonUtil.PlayerPrefsSetBool(key, false)
        if self.ctrl.type == WorldPointUIType.City and self.info.pointData.IsWerewolf then
          self.name_text:SetLocalText(GameDialogDefine.WEREWOLF)
        else
          self.name_text:SetText(playerName)
        end
        if self.info.pointData and self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent then
          self.property:RefreshData(serverData)
        else
          self.dynamicOtherPlayer:UpdateInfo(serverData, self.info.pointData)
        end
        if self.info.isSeasonPlayerBuilding then
          self.plunder_obj:SetActive(false)
        else
          self.plunder_obj:RefreshData(serverData)
        end
        if serverData.playerData and serverData.playerData.valentineShow and tonumber(serverData.playerData.valentineShow) == 1 and serverData.playerData.activityId and serverData.playerData.valentineRank then
          local rankData = DataCenter.ValentineDataManager:GetRankDataById(serverData.playerData.valentineRank)
          if rankData and not string.IsNullOrEmpty(rankData.frame) then
            self.frameImg:LoadSpriteAsync(rankData.frame)
            self.frameImg:SetActive(true)
            self.dynamicValentineStar:SetActive(true)
            self.dynamicValentineStar:Refresh(serverData.playerData.valentineExp, serverData.playerData.valentineRank, serverData.playerData.activityId)
          end
        else
          self.frameImg:SetActive(false)
          self.dynamicValentineStar:SetActive(false)
        end
      end
    elseif self.ctrl.type == WorldPointUIType.WinterEntity then
      self.dynamicWinterEntityNew:UpdateDetailInfo(serverData)
    elseif self.ctrl.type == WorldPointUIType.DragonBuild then
      self.dynamicDragonBuild:UpdateDetailInfo(serverData)
    elseif self.ctrl.type == WorldPointUIType.CollectPoint then
      self.dynamicCollect:UpdateInfo(serverData)
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.EpidemicBuild then
      local battlefieldType = self.info.battlefieldType
      local bTemp = BattleFieldUtil.GetBattlefieldBuildTemplate(self.info.pointData.buildId)
      if bTemp then
        if bTemp:IsRes() then
          if string.IsNullOrEmpty(self.info.pointData.gatherUUID) then
            self.dynamicCollect:UpdateInfo(serverData)
            self.plunder_obj:SetActive(false)
          end
        elseif battlefieldType >= BattleFieldType.NewBattleTypeStart then
          self.dynamicBattlefieldBuilding:RefreshView(self.info, serverData)
        else
          self.dynamicEpidemicBuild:UpdateDetailInfo(serverData)
        end
      end
    elseif self.ctrl.type == WorldPointUIType.MeteoriteResPoint then
      local meteorite = self:GetMeteoriteCollectionNode()
      if meteorite then
        meteorite:Refresh(self.info.pointData)
        self:ShowMeteoriteCollectionNode()
      end
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.MeteoriteResCollectArmy then
      local meteorite = self:GetMeteoriteCollectionNode()
      if meteorite then
        meteorite:Refresh(self.info.pointData)
        self:ShowMeteoriteCollectionNode()
      end
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.CityResPoint then
      self.dynamicCollect:UpdateInfo(serverData)
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.Desert or self.ctrl.type == WorldPointUIType.Ruin then
      if self.dynamicDesertObj ~= nil then
        self.dynamicDesertObj:UpdateInfo(self.ctrl.pointId, serverData)
      end
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.DispatchTask then
      self.dynamicDispatchTask:UpdateInfo()
      local playerInfo = serverData.playerData
      if playerInfo then
        local name = serverData.shareName
        if playerInfo then
          if not string.IsNullOrEmpty(playerInfo.alAbbr) then
            name = "[" .. playerInfo.alAbbr .. "]"
          elseif not string.IsNullOrEmpty(playerInfo.allianceId) then
            local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(playerInfo.allianceId)
            if data == nil then
              SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, playerInfo.allianceId)
            else
              name = "[" .. data.abbr .. "]"
            end
          end
          local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(playerInfo.uid, playerInfo.name)
          name = name .. showName
        end
        if self.info and self.info.clickByOther and self.info.protectDispatchTask then
          self.name_text:SetText(DataCenter.ActDispatchTaskDataManager:GetProtectName())
        else
          self.name_text:SetText(name)
        end
      end
    elseif self.ctrl.type == WorldPointUIType.Ghostrecon then
      self.ghostrecon_obj:UpdateInfo()
      local playerInfo = serverData.playerData
      if playerInfo then
        local name = serverData.shareName
        if playerInfo then
          if not string.IsNullOrEmpty(playerInfo.alAbbr) then
            name = "[" .. playerInfo.alAbbr .. "]"
          elseif not string.IsNullOrEmpty(playerInfo.allianceId) then
            local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(playerInfo.allianceId)
            if data == nil then
              SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, playerInfo.allianceId)
            else
              name = "[" .. data.abbr .. "]"
            end
          end
          name = name .. playerInfo.name
        end
        if self.info and self.info.protectGhostrecon then
          self.name_text:SetText(DataCenter.ActDispatchTaskDataManager:GetProtectName())
        else
          self.name_text:SetText(name)
        end
      end
    elseif self.ctrl.type == WorldPointUIType.Desert then
      self.dynamicDesertObj:UpdateInfo(self.ctrl.pointId, serverData)
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.AllianceCollectPoint then
      if self.alliance_collect_obj then
        self.alliance_collect_obj:UpdateInfo(serverData)
      end
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.CityAttachmentBuild then
      if self.CityAttachmentBuild then
        self.CityAttachmentBuild:UpdateInfo(serverData)
      end
      self.plunder_obj:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.AllianceMine or self.ctrl.type == WorldPointUIType.AllianceActMine then
      if self.AsyncAllianceMine ~= nil then
        self.AsyncAllianceMine:RefreshData(self.ctrl.pointId, self.info.pointData, serverData)
      end
      if self.bg_go then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.rectTransform)
      end
      return
    elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
      self.dynamicAllianceBuild:SetActive(true)
      self.dynamicAllianceBuild:SetData(self.ctrl.pointId, serverData)
    elseif self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect or self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
      local detailData = self:GetPointServerData()
      if self.contentPanelCom then
        if not detailData then
          self.ctrl:CloseSelf()
          return
        end
        self.contentPanelCom:RefreshServerData(detailData)
        if self.buildBtnCells == nil or #self.buildBtnCells == 0 then
          self.info.btnList = detailData.btnList
          self:ShowBtn()
        end
      end
    elseif self.ctrl.type == WorldPointUIType.ZombieRush then
      if self.dynamicZombieRush ~= nil then
        self.dynamicZombieRush:UpdateDetailInfo(serverData.playerData)
      end
    elseif self.ctrl.type == WorldPointUIType.BerserkBoss then
      if self.dynamicBerserkBoss ~= nil then
        self.dynamicBerserkBoss:ShowAllianceRankData()
      end
    elseif self.ctrl.type == WorldPointUIType.ZoneMobilization then
      if self.dynamicAirshipDonate then
        local playerInfo = serverData.playerData
        if playerInfo then
          self.dynamicAirshipDonate:UpdateView(playerInfo)
        end
      end
    elseif self.ctrl.type == WorldPointUIType.WorldRuinDestroyBuilding then
      self.world_ruin_build:RefreshData(serverData, self.ctrl.pointId)
      self.name_text:SetText(serverData.shareName)
    elseif self.ctrl.type == WorldPointUIType.FlowerTrain then
      self.dynamicFlowerTrainInfo:RefreshView(self.ctrl.flowerTrainData, self.ctrl.flowerTrainIndex)
    elseif self.ctrl.type == WorldPointUIType.FlowerTrainReward then
      local topBtnAction = {}
      
      function topBtnAction.shareBtnAction()
        self:OnShareClick()
      end
      
      function topBtnAction.markBtnAction()
        self:OnMarkClick()
      end
      
      self.dynamicFlowerTrainRewardInfo:RefreshView(serverData, topBtnAction)
    elseif self.ctrl.type == WorldPointUIType.S0AllianceDrillBuilding then
      if self.dynamicS0AllianceDrillBuilding and self.info and self.info.pointData then
        self.dynamicS0AllianceDrillBuilding:RefreshData(self.info.pointData)
      end
    elseif self.ctrl.type == WorldPointUIType.S0AllianceDrillBoss then
      if self.dynamicS0AllianceDrillBoss and self.info and self.info.pointData then
        self.dynamicS0AllianceDrillBoss:RefreshData(self.info.pointData)
      end
    else
      self.plunder_obj:SetActive(false)
    end
    if serverData.playerData then
      if serverData.playerData.allianceScout and not SeasonUtil.IsSeasonPlayerBuilding(self.ctrl.buildId) and self.ctrl.type ~= WorldPointUIType.DispatchTask and self.ctrl.type ~= WorldPointUIType.Ghostrecon and self.ctrl.type ~= WorldPointUIType.CollectArmy then
        self.dynamicScoutDes:RefreshData(serverData.playerData.allianceScout)
        self.dynamicScoutDes:SetActive(true)
      else
        self.dynamicScoutDes:SetActive(false)
      end
      self.career_label:SetData(serverData.playerData.careerType, serverData.playerData.careerLv)
    end
  else
    self.career_label:SetActive(false)
    self.plunder_obj:SetActive(false)
  end
  if self.viewTopCom and (self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint) then
    self.viewTopCom:RefreshServerData(self:GetPointServerData())
  end
end

function UIWorldPointView:InjuryAllianceCheck(isSelfAlliance)
  local wounded = 0
  local injury = 0
  if isSelfAlliance then
    wounded = LuaEntry.DataConfig:TryGetNum("injury_config", "k5")
    injury = LuaEntry.DataConfig:TryGetNum("injury_config", "k6")
  else
    wounded = LuaEntry.DataConfig:TryGetNum("injury_config", "k3")
    injury = LuaEntry.DataConfig:TryGetNum("injury_config", "k4")
  end
  local dead = 100 - wounded - injury
  self.injuryValue = injury
  self.woundedValue = wounded
  self.deadValue = dead
  local value = 0
  local dialog = "104320"
  if 0 < dead then
    dialog = "302014"
    value = dead
  elseif dead == 0 then
    dialog = "121581"
    value = injury
  elseif dead < 0 then
    dialog = "121581"
    value = injury
    print("injury scale wrong :" .. wounded .. " " .. injury)
  end
  return dialog, value
end

function UIWorldPointView:InjuryBuildCheck(isSelfAlliance)
  local dead = 0
  local value = 0
  local wounded = 0
  local injury = 0
  if self.ctrl.buildId == BuildingTypes.WORM_HOLE_CROSS then
    wounded = LuaEntry.DataConfig:TryGetNum("injury_config", "k7")
    injury = LuaEntry.DataConfig:TryGetNum("injury_config", "k8")
    dead = 100 - wounded - injury
    self.injuryValue = injury
    self.woundedValue = wounded
    self.deadValue = dead
  elseif self.ctrl.type == WorldPointUIType.AllianceActMine then
    wounded = LuaEntry.DataConfig:TryGetNum("injury_config", "k17")
    injury = LuaEntry.DataConfig:TryGetNum("injury_config", "k18")
    dead = 100 - wounded - injury
    self.injuryValue = injury
    self.woundedValue = wounded
    self.deadValue = dead
  else
    return self:InjuryAllianceCheck(isSelfAlliance)
  end
  local dialog = "104320"
  if 0 < dead then
    dialog = "302014"
    value = dead
  elseif dead == 0 then
    dialog = "121581"
    value = injury
  elseif dead < 0 then
    dialog = "121581"
    value = injury
    print("injury scale wrong :" .. wounded .. " " .. injury)
  end
  return dialog, value
end

function UIWorldPointView:OnClickInjuryTips()
  local content = "\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148" .. "\n" .. Localization:GetString("121586")
  local injuryMsg = Localization:GetString("121581") .. " " .. self.injuryValue .. "%"
  local woundedMsg = Localization:GetString("121582") .. " " .. self.woundedValue .. "%"
  local deadMsg = Localization:GetString("302014") .. " " .. self.deadValue .. "%"
  local msg = deadMsg .. "\n" .. injuryMsg .. "\n" .. woundedMsg .. "\n" .. content
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self._img_injury.transform.position + Vector3.New(0, 15, 0) * scaleFactor
  local param = {}
  param.content = msg
  param.dir = 1
  param.defWidth = 300
  param.pivot = 0.25
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function RefreshMarkBtnImg(self)
  if self.ctrl.type == WorldPointUIType.Barricade then
    return
  end
  local point = self:GetRealPoint()
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(point, self.ctrl.serverId, true)
  if favorData then
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

local function ShowGuideGarbage(self)
  if self.ctrl.type == WorldPointUIType.SingleMapGarbage then
    self.guide_garbage:SetActive(true)
  else
    self.guide_garbage:SetActive(false)
  end
end

local function ShowTopBtn(self)
  self.pos_go_info:SetActive(true)
  self.btn_mark:SetActive(false)
  self.btn_share:SetActive(false)
  self.btn_alliance_mark:SetActive(false)
  self.dynamicWolfShadow:SetActive(false)
  self.career_label:SetActive(false)
  self.plunder_obj:SetActive(false)
  self.world_ruin_build:SetActive(false)
  self.dynamicDragonBuild:SetActive(false)
  self.dynamicWinterEntityNew:SetActive(false)
  self.dynamicEpidemicBuild:SetActive(false)
  self.dynamicDispatchTask:SetActive(false)
  self.dynamicMonster:SetActive(false)
  self.dynamicFlowerCar:SetActive(false)
  self.dynamicAllyDrillCow:SetActive(false)
  self.dynamicOtherPlayer:SetActive(false)
  self.dynamicCollect:SetActive(false)
  self.dynamicTrain:SetActive(false)
  self.dynamicHSR:SetActive(false)
  self.dynamicBattlefieldBuilding:SetActive(false)
  self.dynamicScoutDes:SetActive(false)
  self.dynamicDetectZombieBusTrainObj:SetActive(false)
  self.dynamicWorldTrigger:SetActive(false)
  self.seanson_build_obj:SetActive(false)
  self:HideMeteoriteCollectionNode()
  self.act_boss_obj:SetActive(false)
  self.dynamicDesertObj:SetActive(false)
  self.challenge_obj:SetActive(false)
  self.dynamicSimpleMonster:SetActive(false)
  self.dynamicDrillObj:SetActive(false)
  self.name_text:SetActive(false)
  self.dynamicTreasureDetectObj:SetActive(false)
  self.dynamicAllianceBuild:SetActive(false)
  self.property:SetActive(false)
  self.frameImg:SetActive(false)
  self.dynamicDetectDigGameObj:SetActive(false)
  if self.dynamicZombieRush ~= nil then
    self.dynamicZombieRush:SetActive(false)
  end
  self.ghostrecon_obj:SetActive(false)
  if self.dynamicBerserkBoss ~= nil then
    self.dynamicBerserkBoss:SetActive(false)
  end
  self.tip_obj:SetActive(false)
  if self.dynamicAirshipDonate ~= nil then
    self.dynamicAirshipDonate:SetActive(false)
  end
  self.dynamicFlowerTrainInfo:SetActive(false)
  self.dynamicFlowerTrainRewardInfo:SetActive(false)
  self.dynamicValentineStar:SetActive(false)
  self.dynamicS0AllianceDrillBuilding:SetActive(false)
  self.dynamicS0AllianceDrillBoss:SetActive(false)
  local flagTop2 = self.ctrl.type == WorldPointUIType.City and self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent or self.ctrl.type == WorldPointUIType.WorldDetectCaveExploration or self.ctrl.type == WorldPointUIType.Boss and self.info.pointData.special == WorldMonsterSpecialType.CityGhostBoss or self.info.pointData and self.info.pointData.monsterType == LWWorldMonsterType.FlowerCar or self.ctrl.type == WorldPointUIType.HSR
  local useNewTop = self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint or self.ctrl.type == WorldPointUIType.S1RestCityDefendMonster or self.ctrl.type == WorldPointUIType.S1RestBloodyQueenMonster or self.ctrl.type == WorldPointUIType.FlowerTrain or self.ctrl.type == WorldPointUIType.FlowerTrainReward
  if useNewTop then
    self.top2:SetActive(false)
    self.top:SetActive(false)
  else
    self.top2:SetActive(flagTop2)
    self.top:SetActive(not flagTop2)
  end
  for theType, cfg in pairs(LoadAssetMap) do
    if cfg and cfg.name and theType ~= self.ctrl.type then
      local node = self[cfg.name]
      if node then
        node:Delete()
        self[cfg.name] = nil
      end
    end
  end
  local cfg = LoadAssetMap[self.ctrl.type]
  if cfg and cfg.name and cfg.lua and cfg.prefab and self[cfg.name] == nil then
    local cls = require(cfg.lua)
    if cls and self[cfg.name] == nil then
      self[cfg.name] = cls.New(self, self.bg.transform, cfg.prefab)
    end
  end
  if self.CityGhostBoss ~= nil then
    self.CityGhostBoss:SetActive(false)
  end
  if self.ctrl.type == WorldPointUIType.SingleMapGarbage or self.ctrl.type == WorldPointUIType.PickGarbage or self.ctrl.type == WorldPointUIType.Sample or self.ctrl.type == WorldPointUIType.Rescue or self.ctrl.type == WorldPointUIType.TreasureChest or self.ctrl.type == WorldPointUIType.DetectEventSuppliesSearch or self.ctrl.type == WorldPointUIType.DetectRetryRescue then
    self.dynamicSimpleMonster:SetActive(true)
    self.dynamicSimpleMonster:RefreshData(self.info.pointData)
  elseif self.ctrl.type == WorldPointUIType.DetectAttackCityS0Monster then
    self.dynamicMonster:SetActive(true)
    self.dynamicMonster:RefreshData(self.info.pointData)
    self.name_text:SetActive(true)
    self.name_text:SetText(self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.Train then
    self.btn_mark:SetActive(true)
    self.btn_share:SetActive(true)
    self.name_text:SetActive(true)
    self.dynamicTrain:SetActive(true)
    self.dynamicTrain:RefreshData(self.info.pointData)
  elseif self.ctrl.type == WorldPointUIType.HSR then
    self.btn_mark:SetActive(true)
    self.btn_share:SetActive(true)
    self.name_text:SetActive(true)
    self.dynamicHSR:SetActive(true)
    self.dynamicHSR:RefreshData()
  elseif self.ctrl.type == WorldPointUIType.DetectZombieBusTrain then
    self.name_text:SetActive(true)
    self.dynamicDetectZombieBusTrainObj:SetActive(true)
    self.dynamicDetectZombieBusTrainObj:RefreshData(self.info.pointData)
  elseif self.ctrl.type == WorldPointUIType.WorldDetectCaveExploration then
    self.tip_obj:SetActive(true)
    self.name_text:SetActive(true)
    if self.tipObjLayoutGroup then
      self.tipObjLayoutGroup.padding.top = 0
    end
    self.tip_text:SetText(self.info.pointData.tip)
  elseif self.ctrl.type == WorldPointUIType.PlayerKillMonsterTreasure then
    self.tip_obj:SetActive(true)
    self.name_text:SetActive(true)
    if self.tipObjLayoutGroup then
      self.tipObjLayoutGroup.padding.top = 0
    end
    local desc = "season_s4_monster_tips31"
    local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    cast(info, typeof(CS.TreasurePointInfo))
    local worldTreasureType = info and info:GetWorldTreasureType()
    if worldTreasureType and worldTreasureType == WorldTreasureType.GeneFragment then
      local temp = DataCenter.TreasureTemplateManager:GetTemplate(tonumber(info.eventId))
      if temp and not string.IsNullOrEmpty(temp.desc) then
        desc = temp.desc
      end
    end
    self.tip_text:SetLocalText(desc)
  elseif self.ctrl.type == WorldPointUIType.DetectEventDigGame or self.ctrl.type == WorldPointUIType.DetectEventLastStand then
    self.name_text:SetActive(true)
    self.name_text:SetText(self.info.pointData.name)
    self.dynamicDetectDigGameObj:SetActive(true)
    self.dynamicDetectDigGameObj:RefreshData(self.info.pointData)
  elseif self.ctrl.type == WorldPointUIType.DetectEventSuppliesSearch then
    self.name_text:SetActive(true)
    self.name_text:SetText(self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.FlowerTrain then
    self.dynamicFlowerTrainInfo:SetActive(true)
    self.dynamicFlowerTrainInfo:RefreshView(self.ctrl.flowerTrainData, self.ctrl.flowerTrainIndex)
  elseif self.ctrl.type == WorldPointUIType.FlowerTrainReward then
    self.dynamicFlowerTrainRewardInfo:SetActive(true)
    local topBtnAction = {}
    
    function topBtnAction.shareBtnAction()
      self:OnShareClick()
    end
    
    function topBtnAction.markBtnAction()
      self:OnMarkClick()
    end
    
    self.dynamicFlowerTrainRewardInfo:RefreshView(self.ctrl.flowerTrainRewardData, topBtnAction)
  else
    local k1 = LuaEntry.DataConfig:TryGetNum("monster_level_show", "k1")
    local currentMainLv = DataCenter.BuildManager.MainLv
    if k1 > currentMainLv then
      if self.ctrl.type == WorldPointUIType.Monster then
        self.dynamicSimpleMonster:SetActive(true)
        self.dynamicSimpleMonster:RefreshData(self.info.pointData)
      end
    else
      if CS.SceneManager:IsInCity() or self.ctrl.type == WorldPointUIType.MonsterReward or self.ctrl.type == WorldPointUIType.Explore or self.ctrl.type == WorldPointUIType.DetectEventFakePVP or self.ctrl.type == WorldPointUIType.DetectEventPVE or self.ctrl.type == WorldPointUIType.MonsterLock or self.ctrl.type == WorldPointUIType.Desert or self.info.pointData.belongSelf then
      else
        self.btn_mark:SetActive(true)
        self.btn_share:SetActive(true)
      end
      self.name_text:SetActive(true)
      if self.ctrl.type == WorldPointUIType.Monster then
        self.dynamicMonster:SetActive(true)
        self.dynamicMonster:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.Boss then
        if self.info.pointData.special == WorldMonsterSpecialType.MonsterInvasionBoss then
          self.btn_mark:SetActive(true)
          self.btn_share:SetActive(true)
        elseif self.info.pointData.special == WorldMonsterSpecialType.SuperRunningBoss then
          self.btn_mark:SetActive(true)
          self.btn_share:SetActive(true)
        elseif self.info.pointData.marchType == NewMarchType.RUNNING_MUMMY or self.info.pointData.marchType == NewMarchType.MUMMY then
          self.btn_mark:SetActive(false)
        end
        local seasonType = SeasonUtil.GetSeasonType()
        if seasonType == SeasonMapType.Darkness and self.info.pointData.special == WorldMonsterSpecialType.CityGhostBoss then
          local top2param = {
            isHideRolle = true,
            isShowIcon = false,
            special = WorldMonsterSpecialType.CityGhostBoss,
            type = WorldPointUIType.Monster,
            lordBannerPath = "Assets/Main/SeasonRes/S4/Textures/WorldUI/mjc_s4_shijie_pop_bg_01.png"
          }
          
          function top2param.share()
            DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
            self:OnShareClick()
          end
          
          function top2param.mark()
            DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
            self:OnMarkClick(false)
          end
          
          if LuaEntry.Player:IsInAlliance() then
            function top2param.allianceShare()
              DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
              
              self:OnMarkClick(true)
            end
          end
          self.top2:RefreshData(top2param)
          self.dynamicMonster:SetActive(false)
          if self.CityGhostBoss == nil then
            local lua = "UI.LWSeason4.Component.CityGhostBoss"
            local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/World/CityGhostBossInfo.prefab"
            self.CityGhostBoss = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.bg)
          end
          self.CityGhostBoss:RefreshData(self.info.pointData)
        elseif self.info.pointData.monsterType == LWWorldMonsterType.FlowerCar then
          local top2param = {
            isHideRolle = true,
            monsterType = LWWorldMonsterType.FlowerCar,
            lordBannerPath = "Assets/Main/SeasonRes/S4/Textures/WorldUI/mjc_s4_shijie_pop_bg_01.png"
          }
          
          function top2param.share()
            DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
            self:OnShareClick()
          end
          
          function top2param.mark()
            DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
            self:OnMarkClick(false)
          end
          
          if LuaEntry.Player:IsInAlliance() then
            function top2param.allianceShare()
              DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
              
              self:OnMarkClick(true)
            end
          end
          self.top2:RefreshData(top2param)
          self.dynamicFlowerCar:SetActive(true)
          self.dynamicFlowerCar:RefreshData(self.info.pointData)
        elseif self.info.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
          self.dynamicAllyDrillCow:SetActive(true)
          self.dynamicAllyDrillCow:RefreshData(self.info.pointData)
        else
          self.dynamicMonster:SetActive(true)
          self.dynamicMonster:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.Explore or self.ctrl.type == WorldPointUIType.DetectEventFakePVP or self.ctrl.type == WorldPointUIType.DetectEventPVE then
        self.dynamicMonster:SetActive(true)
        self.dynamicMonster:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.MonsterLock then
        self.dynamicMonster:SetActive(true)
        self.dynamicMonster:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.City or self.ctrl.type == WorldPointUIType.Build or self.ctrl.type == WorldPointUIType.CollectArmy or self.ctrl.type == WorldPointUIType.Road then
        if self.ctrl.type == WorldPointUIType.Build and self.ctrl.buildId == BuildingTypes.LW_CITY_RUIN or self.ctrl.buildId == BuildingTypes.LW_CITY_RUIN_1 then
        elseif self.info.isSeasonPlayerBuilding then
          self.dynamicOtherPlayer:SetActive(false)
          self.seanson_build_obj:SetActive(true)
          self.seanson_build_obj:RefreshData(self.info.pointData)
        elseif self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent then
          self.property:SetActive(true)
          local param = {}
          local eventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.info.pointData.uuid)
          if eventData then
            local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventData.eventId)
            if template.appearance_id ~= 0 then
              param.appearanceId = tostring(template.appearance_id)
            end
          end
          self.top2:RefreshData(param)
        else
          self.dynamicOtherPlayer:SetActive(true)
          self.dynamicOtherPlayer:RefreshData(self.info.pointData)
        end
        if self.ctrl.type == WorldPointUIType.City and BattleFieldUtil.InBattleField() then
          self.btn_mark:SetActive(false)
          self.btn_alliance_mark:SetActive(false)
        end
      elseif self.ctrl.type == WorldPointUIType.CollectPoint or self.ctrl.type == WorldPointUIType.CityResPoint then
        if BattleFieldUtil.InBattleField() then
          self.btn_mark:SetActive(false)
        end
        self.dynamicCollect:SetActive(true)
        self.dynamicCollect:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.MeteoriteResPoint then
        local meteorite = self:GetMeteoriteCollectionNode()
        if meteorite then
          meteorite:Refresh(self.info.pointData)
          self:ShowMeteoriteCollectionNode()
        end
      elseif self.ctrl.type == WorldPointUIType.MeteoriteResCollectArmy then
        local meteorite = self:GetMeteoriteCollectionNode()
        if meteorite then
          meteorite:Refresh(self.info.pointData)
          self:ShowMeteoriteCollectionNode()
        end
      elseif self.ctrl.type == WorldPointUIType.AllianceCollectPoint then
        if self.alliance_collect_obj then
          self.alliance_collect_obj:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.CityAttachmentBuild then
        if self.CityAttachmentBuild then
          self.CityAttachmentBuild:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.SandWorm then
        if self.SandWorm then
          self.SandWorm:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.ActBoss then
        self.pos_go_info:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.PuzzleBoss then
        self.act_boss_obj:SetActive(true)
        self.act_boss_obj:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.ChallengeBoss then
        self.challenge_obj:SetActive(true)
        self.challenge_obj:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.DrillBase or self.ctrl.type == WorldPointUIType.AllyDrillHugeSandWorm or self.ctrl.type == WorldPointUIType.AllyDrillRoadHog then
        self.dynamicDrillObj:SetActive(true)
        self.dynamicDrillObj:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.Desert or self.ctrl.type == WorldPointUIType.Ruin then
        if self.dynamicDesertObj ~= nil then
          self.dynamicDesertObj:SetActive(true)
          self.dynamicDesertObj:RefreshData(self.info.pointData)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.rectTransform)
        end
        self.btn_mark:SetActive(true)
        self.btn_share:SetActive(true)
      elseif self.ctrl.type == WorldPointUIType.DispatchTask then
        self.dynamicDispatchTask:SetActive(true)
        self.dynamicDispatchTask:RefreshData(self.info.pointData, self.ctrl.pointId, self.info)
        self:SetData()
        self.btn_alliance_mark:SetActive(false)
        self.btn_mark:SetActive(not self.info.clickBySelf)
        self.btn_share:SetActive(not self.info.clickBySelf)
      elseif self.ctrl.type == WorldPointUIType.DragonBuild then
        self.btn_mark:SetActive(false)
        self.dynamicDragonBuild:SetActive(true)
        self.dynamicDragonBuild:RefreshData(self.info.pointData)
        self.btn_alliance_mark:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
        self.dynamicWorldTrigger:SetActive(true)
        self.dynamicWorldTrigger:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.WolfShadow then
        self.btn_share:SetActive(false)
        self.dynamicWolfShadow:SetActive(true)
        self.dynamicWolfShadow:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.WinterEntity then
        self.btn_mark:SetActive(false)
        self.dynamicWinterEntityNew:SetActive(true)
        self.dynamicWinterEntityNew:RefreshData(self.info.pointData)
        self.btn_alliance_mark:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.EpidemicBuild then
        self.btn_mark:SetActive(false)
        self.btn_alliance_mark:SetActive(false)
        local battlefieldType = self.info.battlefieldType
        if battlefieldType >= BattleFieldType.NewBattleTypeStart then
          local bTemp = BattleFieldUtil.GetBattlefieldBuildTemplate(self.info.pointData.buildId)
          if bTemp:IsRes() then
            if string.IsNullOrEmpty(self.info.pointData.gatherUUID) then
              self.dynamicCollect:SetActive(true)
              self.dynamicCollect:RefreshData(self.info.pointData)
            else
              self.dynamicOtherPlayer:SetActive(true)
              self.dynamicOtherPlayer:RefreshData(self.info.pointData)
            end
          else
            self.dynamicBattlefieldBuilding:SetActive(true)
          end
        elseif DataCenter.EpidemicBuildTemplateMgr:IsRes(self.info.pointData.buildId) then
          if string.IsNullOrEmpty(self.info.pointData.gatherUUID) then
            self.dynamicCollect:SetActive(true)
            self.dynamicCollect:RefreshData(self.info.pointData)
          else
            self.dynamicOtherPlayer:SetActive(true)
            self.dynamicOtherPlayer:RefreshData(self.info.pointData)
          end
        else
          self.dynamicEpidemicBuild:SetActive(true)
          self.dynamicEpidemicBuild:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.AllianceMine or self.ctrl.type == WorldPointUIType.AllianceActMine then
        if self.AsyncAllianceMine ~= nil then
          self.AsyncAllianceMine:SetActive(true)
          self.AsyncAllianceMine:RefreshData(self.ctrl.pointId, self.info.pointData, nil)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.rectTransform)
        end
      elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
        self.dynamicAllianceBuild:SetActive(true)
        self.dynamicAllianceBuild:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.Treasure then
        self.btn_alliance_mark:SetActive(false)
        self.dynamicTreasureDetectObj:SetActive(true)
        self.dynamicTreasureDetectObj:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.ZombieRush then
        if self.dynamicZombieRush ~= nil then
          self.btn_share:SetActive(true)
          self.btn_mark:SetActive(false)
          self.dynamicZombieRush:SetActive(true)
          self.dynamicZombieRush:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.Ghostrecon then
        if self.ghostrecon_obj ~= nil then
          self.btn_share:SetActive(true)
          self.btn_mark:SetActive(false)
          self.ghostrecon_obj:SetActive(true)
          self.ghostrecon_obj:RefreshData(self.info.pointData, self.ctrl.pointId, self.info)
          self:SetData()
        end
      elseif self.ctrl.type == WorldPointUIType.BerserkBoss then
        if self.dynamicBerserkBoss ~= nil then
          self.top2:SetActive(false)
          self.top:SetActive(false)
          self.dynamicBerserkBoss:SetActive(true)
          self.dynamicBerserkBoss:RefreshData(self.info.pointData)
        end
      elseif self.ctrl.type == WorldPointUIType.Aisilla then
        self.dynamicMonster:SetActive(true)
        self.dynamicMonster:RefreshData(self.info.pointData)
        self.btn_mark:SetActive(true)
        self.btn_share:SetActive(true)
      elseif self.ctrl.type == WorldPointUIType.Barricade then
        self.top2:SetActive(false)
        self.top:SetActive(false)
        self.tip_obj:SetActive(true)
        self.tip_text:SetLocalText("transfer_city_01")
      elseif self.ctrl.type == WorldPointUIType.ZoneMobilization then
        if self.dynamicAirshipDonate ~= nil then
          self.dynamicAirshipDonate:SetActive(true)
        end
      elseif self.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
        self.dynamicMonster:SetActive(true)
        self.dynamicMonster:RefreshData(self.info.pointData)
      elseif self.ctrl.type == WorldPointUIType.WorldActivityTreasure then
        self.pos_go_info:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.KillZombieKirovBoss then
        self.top2:SetActive(false)
        self.top:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.KillZombieKirovBox then
        self.top2:SetActive(false)
        self.top:SetActive(false)
      elseif self.ctrl.type == WorldPointUIType.DetectRetryResource then
        self.btn_share:SetActive(true)
        self.btn_mark:SetActive(true)
      elseif self.ctrl.type == WorldPointUIType.S0AllianceDrillBuilding then
        if self.dynamicS0AllianceDrillBuilding ~= nil then
          self.dynamicS0AllianceDrillBuilding:SetActive(true)
        end
      elseif self.ctrl.type == WorldPointUIType.S0AllianceDrillBoss then
        self.top2:SetActive(false)
        self.top:SetActive(false)
        if self.dynamicS0AllianceDrillBoss ~= nil then
          self.dynamicS0AllianceDrillBoss:SetActive(true)
        end
      end
    end
  end
  if self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect or self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.WorldDetectSurvivor or self.ctrl.type == WorldPointUIType.DominatorGuide or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_1 or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_2 or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint or self.ctrl.type == WorldPointUIType.KillZombieKirovBoss or self.ctrl.type == WorldPointUIType.KillZombieKirovBox or self.ctrl.type == WorldPointUIType.DetectRetryResource or self.ctrl.type == WorldPointUIType.SkyBattle or self.ctrl.type == WorldPointUIType.S1RestCityDefendMonster or self.ctrl.type == WorldPointUIType.S1RestBloodyQueenMonster then
    if self.ctrl.type == WorldPointUIType.WorldDetectSurvivor or self.ctrl.type == WorldPointUIType.DominatorGuide or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_1 or self.ctrl.type == WorldPointUIType.DominatorCockatriceUnlock_2 then
      self.btn_share:SetActive(false)
      self.btn_mark:SetActive(false)
    end
    self:ShowAsyncLoadContent()
  elseif self.contentPanelCom then
    self.contentPanelCom.gameObject:SetActive(false)
  end
  if self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
    self:ShowTopAsync()
  elseif self.viewTopCom then
    self.viewTopCom.gameObject:SetActive(false)
  end
end

local function SetAllCellDestroy(self)
  self.build_btn_go:RemoveComponents(UIWorldPointBtn)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function ShowBtn(self)
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  if self.info.btnList ~= nil then
    self.refresh_btn:SetActive(#self.info.btnList > 5)
  else
    self.refresh_btn:SetActive(false)
  end
  self.buildBtnCells = {}
  self:SetAllCellDestroy()
  local k1 = LuaEntry.DataConfig:TryGetNum("monster_level_show", "k1")
  local currentMainLv = DataCenter.BuildManager.MainLv
  if k1 > currentMainLv and self.ctrl.type ~= WorldPointUIType.SingleMapGarbage then
    self.build_btn_obj:SetActive(false)
    return
  end
  self.btnList = self.info.btnList
  self.btnCount = self.btnList and #self.btnList or 0
  if self.btnCount > 0 then
    if self.info.skipBtnSort ~= true then
      table.sort(self.btnList, function(a, b)
        return b < a
      end)
    end
    self.build_btn_obj:SetActive(true)
    local fiveBtnList = UIUtil.GetBtnShown(self.btnList, 5)
    local theBtnCount = #fiveBtnList
    if self.info.skipBtnSort ~= true then
      table.sort(fiveBtnList, function(a, b)
        return b < a
      end)
    end
    for k, v in ipairs(fiveBtnList) do
      if k < 6 then
        local param = {}
        param.btnType = v
        param.pointId = self.ctrl.pointId
        param.info = self.info.pointData
        local index = CommonUtil.IsArabicAutoMirrorOpen() and theBtnCount - k + 1 or k
        param.position = BtnPosition[theBtnCount][index] - BtnCellCircle
        param.byDetect = self.info.byDetect
        self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIWorldTileBuildBtn, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.build_btn_go.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.transform:Set_localPosition(BtnCellCircle.x, BtnCellCircle.y, BtnCellCircle.z)
          local nameStr = self.view.ctrl:GetPointBtnEnumName(v) .. UIUtil.GetLoopListItemIndex()
          go.name = nameStr
          self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldPointBtn, nameStr)
          self.buildBtnCells[v]:ReInit(param)
        end)
      end
    end
  else
    self.build_btn_obj:SetActive(false)
  end
end

local function RefreshUIWorldPointViewSignal(self, data)
  if data ~= nil then
    local strArr = string.split(data, ";")
    if 5 < #strArr then
      do
        local newType = tonumber(strArr[4])
        local destroyReq = false
        if self.ctrl.type ~= newType then
          destroyReq = true
        end
        if self.ctrl.type ~= WorldPointUIType.SingleMapGarbage then
          local ret, time = self.this_anim:PlayAnimationReturnTime(AnimName.Exit)
          if ret then
            self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
              if self.closeTimer ~= nil then
                self.closeTimer:Stop()
                self.closeTimer = nil
              end
              if self.ctrl ~= nil then
                self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6])
                self.this_anim:Play(AnimName.Enter, 0, 0)
                if destroyReq then
                  self:OnDestroyReq()
                end
                self:ReInit()
              end
            end, self, true, false, false)
            self.closeTimer:Start()
          end
        else
          if 7 < #strArr then
            self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6], strArr[7], strArr[8])
          else
            self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6])
          end
          if destroyReq then
            self:OnDestroyReq()
          end
          self:ReInit()
        end
      end
    end
  end
end

local function UpdateActBossBlood(self, data)
  if self.ctrl.type ~= WorldPointUIType.ActBoss then
    return
  end
  if data ~= nil then
    local strArr = string.split(data, ";")
    if 4 <= #strArr then
      local uuid = tonumber(strArr[1])
      if uuid ~= 0 and uuid == self.ctrl.uuid then
        local initBlood = tonumber(strArr[4])
        local curBlood = tonumber(strArr[3])
        self.act_boss_obj:SetBloodSlider(curBlood, initBlood)
      end
    end
  end
end

local function AddUpdate(self)
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

local function RemoveUpdate(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

local function OnUpdate(self)
  if self.ctrl.type == WorldPointUIType.Train then
    local pos = self.ctrl:GetTrainPosition()
    if pos then
      self.pos_go.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(pos)
    end
  end
end

local function ShowArrow(self, v)
  local param = {}
  param.position = v:GetPosition()
  param.arrowType = ArrowType.Capacity
  param.positionType = PositionType.Screen
  param.isPanel = false
  if param.position ~= nil then
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

local function OnMarkClick(self, isAlliance)
  local panelType = MarkGroup.Personal
  if isAlliance then
    panelType = MarkGroup.Alliance
  end
  if self.ctrl.type == WorldPointUIType.Build or self.ctrl.type == WorldPointUIType.City then
    if self.serverData ~= nil then
      local name = self.serverData.shareName
      local playerInfo = self.serverData.playerData
      if playerInfo then
        if not MailBattleParseHelper.IsWerewolf(playerInfo) and not string.IsNullOrEmpty(playerInfo.alAbbr) then
          name = "[" .. playerInfo.alAbbr .. "]"
        end
        name = name .. playerInfo.name
      end
      local realPoint = self:GetRealPoint()
      self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, nil, panelType, playerInfo.uid)
    end
  elseif self.ctrl.type == WorldPointUIType.Train then
    local name, pos = self.ctrl:GetTrainShareNameAndPos()
    local realPoint = pos * 10 + 1
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, nil, panelType)
  elseif self.ctrl.type == WorldPointUIType.FlowerTrainReward then
    local name, pos = self.ctrl:GetFlowerTrainMarkNameAndPos()
    local realPoint = pos
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, nil, panelType)
  elseif self.ctrl.type == WorldPointUIType.DispatchTask then
    local name = 456288
    local realPoint = self:GetRealPoint()
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, nil, panelType)
  elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
    local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(self.info.pointData.cfgId)
    local realPoint = self:GetRealPoint()
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, meta:GetName(), nil, panelType)
  elseif self.ctrl.type == WorldPointUIType.WolfShadow then
    local realPoint = self:GetRealPoint()
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, Localization:GetString("season_s4_blood_hunter_shadow_name"), nil, panelType)
  elseif self.ctrl.type == WorldPointUIType.WorldRuinDestroyBuilding then
    self.ctrl:OnMarkClick(self.ctrl.serverId, self:GetRealPoint(), self.info.shareName, nil, panelType)
  elseif self.info ~= nil then
    local name = self.info.pointData.shareName
    if name ~= nil then
      local realPoint = self:GetRealPoint()
      self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, self.info.pointData.level, panelType)
    end
  end
end

local function GetRealPoint(self)
  local tileX = BuildTilesSize.One
  local buildTemplate
  if self.ctrl.type == WorldPointUIType.City then
    buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  elseif self.ctrl.type == WorldPointUIType.AllianceMine then
    tileX = BuildTilesSize.Three
  elseif self.ctrl.type == WorldPointUIType.DragonBuild then
    buildTemplate = DataCenter.DragonBuildTemplateManager:GetTemplate(self.ctrl.buildId)
  elseif self.ctrl.type == WorldPointUIType.WinterEntity then
    buildTemplate = DataCenter.WinterStormTemplateManager:GetTemplate(self.ctrl.buildId)
  elseif self.ctrl.type == WorldPointUIType.EpidemicBuild then
    buildTemplate = BattleFieldUtil.GetBattlefieldBuildTemplate(self.ctrl.buildId)
  elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(self.ctrl.buildId) or WorldAllianceBuildUtil.IsAllianceCenterFlag(self.ctrl.buildId) then
    tileX = BuildTilesSize.Three
  elseif self.ctrl.type == WorldPointUIType.ZombieRush then
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.ctrl.buildId)
    if template then
      tileX = template.resSize
    end
  elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
    buildTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.ctrl.buildId)
  elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
    tileX = self.info.pointData.config.size
  elseif self.ctrl.buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    tileX = BuildTilesSize.Three
  else
    buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.ctrl.buildId)
  end
  if buildTemplate ~= nil then
    tileX = buildTemplate.tileX or buildTemplate.resSize or BuildTilesSize.One
  end
  local realPoint = self.ctrl.pointId * 10 + tileX
  return realPoint
end

local function OnShareClick(self)
  if self.ctrl.type == WorldPointUIType.Build or self.ctrl.type == WorldPointUIType.City then
    if self.serverData ~= nil then
      local name = self.serverData.shareName
      local playerInfo = self.serverData.playerData
      if playerInfo then
        if not string.IsNullOrEmpty(playerInfo.alAbbr) then
          name = "[" .. playerInfo.alAbbr .. "]"
        end
        name = name .. playerInfo.name
      end
      self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, nil, nil, nil, playerInfo.uid)
    end
  elseif self.ctrl.type == WorldPointUIType.Train then
    local name, pos = self.ctrl:GetTrainShareNameAndPos()
    self.ctrl:OnShareClick(self.ctrl.serverId, pos, name)
  elseif self.ctrl.type == WorldPointUIType.FlowerTrainReward then
    local name, pos = self.ctrl:GetFlowerTrainShareNameAndPos()
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, nil, self.info.pointData.level)
  elseif self.ctrl.type == WorldPointUIType.Treasure then
    local name = self.info.pointData.shareName
    if name ~= nil then
      self.ctrl:ShareTreasure(self.info)
    end
  elseif self.ctrl.type == WorldPointUIType.DispatchTask then
    local name = Localization:GetString("456288")
    local uname
    if self.info and self.info.clickByOther and self.info.protectDispatchTask then
      uname = DataCenter.ActDispatchTaskDataManager:GetProtectName()
    end
    local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    local uuid = self.info.pointData.uuid
    if info ~= nil then
      uuid = info.uuid
    end
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, uname, nil, nil, nil, uuid)
  elseif self.ctrl.type == WorldPointUIType.Ghostrecon then
    if self.info.pointData.ownerUid == LuaEntry.Player.uid and self.info.pointData.completionTime == 0 then
      DataCenter.ActGhostreconManager:ShareOwnGhostreconTask(self.info.pointData.uuid)
    else
      local playerInfo = self.serverData.playerData
      local name
      if self.info and self.info.protectGhostrecon then
        name = DataCenter.ActDispatchTaskDataManager:GetProtectName()
      else
        name = UIUtil.FormatServerAllianceName(playerInfo.srcServer, playerInfo.abbr, playerInfo.name)
      end
      self.ctrl:OnShareClick(self.info.pointData.serverId, self.ctrl.pointId, name, nil, nil, PostType.GHOST_RECON_SHARE_POINT)
    end
  elseif self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect then
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, self.info.pointData.shareName, nil, self.info.pointData.level)
  elseif self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, self.info.pointData.shareName, nil, nil, PostType.SuppliesPositionShare)
  elseif self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint then
    local name = self.info.pointData.name
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, nil, nil, PostType.SuppliesPositionShare)
  elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
    local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(self.info.pointData.cfgId)
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, meta.name, meta.level)
  elseif self.ctrl.type == WorldPointUIType.WorldRuinDestroyBuilding then
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, self.info.shareName)
  elseif self.ctrl.type == WorldPointUIType.Monster and self.info.pointData.special == WorldMonsterSpecialType.GoldenBeetleBoss then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.Boss and self.info.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.Monster and self.info.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.Boss and self.info.pointData.special == WorldMonsterSpecialType.SandFish then
    self.ctrl:OnShareMovingMarchClick("science_condition", "???", self.info.pointData.name)
  elseif self.ctrl.type == WorldPointUIType.Boss and (self.info.pointData.marchType == NewMarchType.RUNNING_MUMMY or self.info.pointData.marchType == NewMarchType.MUMMY) then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name, self.info.pointData.ownerName)
  elseif self.ctrl.type == WorldPointUIType.Boss and self.info.pointData.monsterType == LWWorldMonsterType.RunningMonster then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name)
  elseif self.info and self.info.pointData and self.info.pointData.isMoving then
    self.ctrl:OnShareMovingMarchClick("science_condition", self.info.pointData.level, self.info.pointData.name)
  elseif self.info ~= nil then
    local name = self.info.pointData.shareName
    local uname = self:GetPlayerName()
    self.bossIsProtected = self:GetMonsterProtectedState()
    if name ~= nil then
      if self.bossIsProtected then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local createTime = self.info.pointData.createTime
        local cfgTime = LuaEntry.DataConfig:TryGetNum("monster_invasion", "k12")
        if createTime and 0 < createTime and cfgTime and 0 < cfgTime then
          local protectionEndTime = createTime + cfgTime * 1000
          if curTime >= protectionEndTime then
            self.bossIsProtected = false
          end
        end
      end
      if self.info.pointData.special == WorldMonsterSpecialType.MonsterInvasionBoss and self.info.pointData.belongSelf and self.bossIsProtected then
        self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, uname, self.info.pointData.level, PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED, nil, self.info.pointUuid, self.info.pointData.srcServer)
      elseif self.info.pointData.special == WorldMonsterSpecialType.MonsterInvasionBoss then
        self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, uname, self.info.pointData.level, PostType.INVASION_BOSS_SHARE, nil, self.info.pointUuid, self.info.pointData.srcServer)
      else
        self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, uname, self.info.pointData.level)
      end
    end
  end
end

function UIWorldPointView:GetMonsterProtectedState()
  local data = self.info and self.info.pointData
  if data and data ~= nil then
    return data
  end
  return true
end

function UIWorldPointView:GetPlayerName()
  local serverData = self.ctrl:GetPlayerData(self.ctrl.pointId)
  local data = self.info.pointData
  if self.ctrl.type == WorldPointUIType.CollectArmy then
    return data and data.resourceName or ""
  else
    return serverData and serverData.name or ""
  end
end

local function OnDetailClick(self)
  if self.info ~= nil then
    if self.ctrl.type == WorldPointUIType.Monster or self.ctrl.type == WorldPointUIType.Explore or self.ctrl.type == WorldPointUIType.DetectEventPVE or self.ctrl.type == WorldPointUIType.DetectEventFakePVP or self.ctrl.type == WorldPointUIType.MonsterLock or self.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
      if self.info.pointData and self.info.pointData.monsterType == LWWorldMonsterType.FlowerCar then
        self.dynamicFlowerCar:OnInfoClick()
      else
        self.dynamicMonster:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.Boss then
      if self.info.pointData.special == WorldMonsterSpecialType.CityStrongholdBOSS and UIUtil.ShowS1HowToPlay(101004) then
        return
      end
      if self.info.pointData and self.info.pointData.monsterType == LWWorldMonsterType.FlowerCar then
        self.dynamicFlowerCar:OnInfoClick()
      elseif self.info.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
        self.dynamicAllyDrillCow:OnInfoClick()
      else
        self.dynamicMonster:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.DragonBuild then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBuildDetail, {anim = true}, self.info.pointData)
    elseif self.ctrl.type == WorldPointUIType.WinterEntity then
    elseif self.ctrl.type == WorldPointUIType.EpidemicBuild then
      local battlefieldType = self.info.battlefieldType
      if battlefieldType >= BattleFieldType.NewBattleTypeStart then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelBattleBuildDetail, {anim = true}, self.info.pointData)
      end
    elseif self.ctrl.type == WorldPointUIType.Train then
      self.dynamicTrain:OnInfoClick()
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.HSR then
      self.dynamicHSR:OnInfoClick()
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.AllianceCollectPoint then
      if self.alliance_collect_obj then
        self.alliance_collect_obj:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.CityAttachmentBuild then
      if self.CityAttachmentBuild then
        self.CityAttachmentBuild:OnInfoClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.SandWorm then
      if self.SandWorm then
        self.SandWorm:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.AllianceMine or self.ctrl.type == WorldPointUIType.AllianceActMine then
      if self.AsyncAllianceMine ~= nil then
        self.AsyncAllianceMine:OnInfoClick()
      end
    elseif self.ctrl.type == WorldPointUIType.Desert then
      if self.dynamicDesertObj ~= nil then
        self.dynamicDesertObj:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
      if UIUtil.ShowS1HowToPlay(101007) then
        return
      end
      if self.dynamicAllianceBuild ~= nil then
        self.dynamicAllianceBuild:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.City then
      if self.info and self.info.pointData and self.info.pointData.IsWerewolf then
        UIUtil.ShowTipsId("season_s4_activity_1200011_desc7")
      elseif self.ctrl.ownerUid ~= nil and self.ctrl.ownerUid ~= "" then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, self.ctrl.ownerUid)
        self.ctrl:CloseSelf()
      end
    elseif self.ctrl.type == WorldPointUIType.Treasure then
      UIUtil.ShowTipsId(801346)
    elseif self.ctrl.type == WorldPointUIType.Build and self.info.isSeasonPlayerBuilding then
      if self.seanson_build_obj ~= nil then
        self.seanson_build_obj:OnInfoClick()
      end
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect or self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
      if self.contentPanelCom then
        self.contentPanelCom:OnInfoClick()
        self.btn_detail:SetActive(false)
        self.btn_return:SetActive(true)
      end
    elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
      self.dynamicWorldTrigger:OnInfoClick()
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    elseif self.ctrl.type == WorldPointUIType.WolfShadow then
      self.dynamicWolfShadow:OnInfoClick()
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(true)
    end
  end
end

local function OnReturnClick(self)
  if self.info ~= nil then
    if self.ctrl.type == WorldPointUIType.Boss or self.ctrl.type == WorldPointUIType.Monster or self.ctrl.type == WorldPointUIType.Explore or self.ctrl.type == WorldPointUIType.DetectEventPVE or self.ctrl.type == WorldPointUIType.DetectEventFakePVP or self.ctrl.type == WorldPointUIType.MonsterLock or self.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
      if self.info.pointData and self.info.pointData.monsterType == LWWorldMonsterType.FlowerCar then
        self.dynamicFlowerCar:OnReturnClick()
      elseif self.info.pointData.special == WorldMonsterSpecialType.AllyDrillCow then
        self.dynamicAllyDrillCow:OnReturnClick()
      else
        self.dynamicMonster:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.Train then
      self.dynamicTrain:OnReturnClick()
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.HSR then
      self.dynamicHSR:OnReturnClick()
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.AllianceCollectPoint then
      if self.alliance_collect_obj then
        self.alliance_collect_obj:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.CityAttachmentBuild then
      if self.CityAttachmentBuild then
        self.CityAttachmentBuild:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.SandWorm then
      if self.SandWorm then
        self.SandWorm:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.City and self.info.pointData.specialType == CS.Protobuf.SpecialType.DetectEvent then
      self.btn_detail:SetActive(false)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.AllianceBuild then
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
      if self.dynamicAllianceBuild ~= nil then
        self.dynamicAllianceBuild:OnReturnClick()
      end
    elseif self.ctrl.type == WorldPointUIType.Desert then
      if self.dynamicDesertObj ~= nil then
        self.dynamicDesertObj:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.Build and self.info.isSeasonPlayerBuilding then
      if self.seanson_build_obj ~= nil then
        self.seanson_build_obj:OnReturnClick()
      end
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect or self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
      if self.contentPanelCom then
        self.contentPanelCom:OnReturnClick()
        self.btn_detail:SetActive(true)
        self.btn_return:SetActive(false)
      end
    elseif self.ctrl.type == WorldPointUIType.WorldTrigger then
      self.dynamicWorldTrigger:OnReturnClick()
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    elseif self.ctrl.type == WorldPointUIType.WolfShadow then
      self.dynamicWolfShadow:OnReturnClick()
      self.btn_detail:SetActive(true)
      self.btn_return:SetActive(false)
    end
  end
end

local function RefreshRewardList(self, message)
  if message.reward and #message.reward > 0 then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
    self.info.pointData.rewardStr = self.ctrl:GetRewards(rewardList)
    self.guide_garbage:RefreshData(self.info.pointData)
  end
end

local function UpdateLod(self, lod)
  if 2 <= lod then
    self.ctrl:CloseSelf(false)
  end
end

local function RefreshAllianceMarkBtn(self)
  local show = true
  if not LuaEntry.Player:IsInAlliance() then
    show = false
  elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    show = false
  elseif self.ctrl.type == WorldPointUIType.DispatchTask or self.ctrl.type == WorldPointUIType.ZombieRush or self.ctrl.type == WorldPointUIType.Ghostrecon or self.ctrl.type == WorldPointUIType.DragonBuild or self.ctrl.type == WorldPointUIType.WinterEntity or self.ctrl.type == WorldPointUIType.EpidemicBuild or self.ctrl.type == WorldPointUIType.ZoneMobilization or self.ctrl.type == WorldPointUIType.ZoneMobilizationBoss or self.ctrl.type == WorldPointUIType.WorldDetectCaveExploration or self.ctrl.type == WorldPointUIType.PlayerKillMonsterTreasure or self.ctrl.type == WorldPointUIType.WorldRuinDestroyBuilding or self.ctrl.type == WorldPointUIType.DetectEventDigGame or self.ctrl.type == WorldPointUIType.DetectEventLastStand or self.ctrl.type == WorldPointUIType.KillZombieKirovBoss or self.ctrl.type == WorldPointUIType.DetectZombieBusTrain or self.ctrl.type == WorldPointUIType.SkyBattle or self.ctrl.type == WorldPointUIType.S0AllianceDrillBuilding or self.ctrl.type == WorldPointUIType.S0AllianceDrillBoss then
    show = false
  elseif (self.ctrl.type == WorldPointUIType.City or self.ctrl.type == WorldPointUIType.CollectPoint or self.ctrl.type == WorldPointUIType.DetectRetryResource or self.ctrl.type == WorldPointUIType.MeteoriteResPoint) and BattleFieldUtil.InBattleField() then
    show = false
  elseif self.info and self.info.pointData and (self.info.pointData.marchType == NewMarchType.RUNNING_MUMMY or self.info.pointData.marchType == NewMarchType.MUMMY) then
    show = false
  end
  self.btn_alliance_mark:SetActive(show)
end

local function RefreshMarkList(self)
  self:RefreshMarkBtnImg()
end

local function CheckResourceItemIsFull(self)
  return self.ctrl:CheckResourceItemIsFull(self.info.pointData.rewardStr)
end

local function OnKingClick(self)
  local serverId = self.ctrl.serverId
  if DataCenter.GovernmentManager:OfficerCrossOpen() and self.info and self.info.pointData and self.info.pointData.srcServerId then
    serverId = self.info.pointData.srcServerId
  end
  if self.info ~= nil and (LuaEntry.Player:IsPresident(serverId) or LuaEntry.Player:IsFirstLady(serverId)) then
    local data = self.info
    local serverData = self.serverData
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficialDialog, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, data, serverData)
  end
end

local function RunningBossTodaySkill(self)
  if self.dynamicMonster then
    self.dynamicMonster:RefreshRunningBossText()
  end
end

local function PostProcessDispatchTask(self)
  local serverId = self.ctrl.serverId
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if loginServerId ~= mySourceServerId or serverId ~= mySourceServerId then
    return
  end
  if self.ctrl.type == WorldPointUIType.DispatchTask and self.info and self.info.clickByOther then
    local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    if info ~= nil then
      DataCenter.ActDispatchTaskDataManager:AddFollowCount(info.uuid)
    end
  end
end

local function ShowAsyncLoadContent(self)
  local loadData = LoadAssetMap[self.ctrl.type]
  if loadData and loadData.cls ~= nil and loadData.objName ~= nil and loadData.prefab ~= nil then
    local cls = loadData.cls
    local prefabAsset = loadData.prefab
    local name = loadData.objName
    if self.contentPanelReq == nil then
      self.contentPanelReq = self:GameObjectInstantiateAsync(prefabAsset, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.name = name
        go.transform:SetParent(self.bg_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.contentPanelCom = self.bg_go:AddComponent(cls, go.name)
        self.contentPanelCom:RefreshData(self.info.pointData)
        local serverData = self:GetPointServerData()
        if serverData then
          self.contentPanelCom:RefreshServerData(serverData)
          if self.buildBtnCells == nil or #self.buildBtnCells == 0 then
            self.info.btnList = serverData.btnList
            self:ShowBtn()
          end
        end
      end)
    elseif self.contentPanelCom then
      self.contentPanelCom:RefreshData(self.info.pointData)
      do
        local serverData = self:GetPointServerData()
        if serverData then
          self.contentPanelCom:RefreshServerData(serverData)
          if self.buildBtnCells == nil or #self.buildBtnCells == 0 then
            self.info.btnList = serverData.btnList
            self:ShowBtn()
          end
        end
      end
    end
  end
end

function UIWorldPointView:GetPointServerData()
  if self.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect then
    return self.ctrl:GetAllianceCollectDetailData(self.ctrl.pointId)
  elseif self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
    return self.ctrl:GetWorldSuppliesPointDetailData(self.ctrl.pointId)
  end
  return nil
end

function UIWorldPointView:ShowTopAsync()
  if self.viewTopReq == nil then
    local prefab, cls
    if self.ctrl.type == WorldPointUIType.WorldSuppliesPoint or self.ctrl.type == WorldPointUIType.DarknessSuppliesPoint then
      prefab = WorldSuppliesTopPrefab
      cls = WorldSuppliesTop
    elseif self.ctrl.type == WorldPointUIType.ZoneMobilizationSuppliesPoint then
      prefab = ZoneMobilizationSuppliesPointTopPrefab
      cls = ZoneMobilizationSuppliesPointTop
    end
    if prefab then
      self.viewTopReq = self:GameObjectInstantiateAsync(prefab, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.name = "worldPointViewTop"
        go.transform:SetParent(self.bg_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsFirstSibling()
        self.viewTopCom = self.bg_go:AddComponent(cls, go.name)
        local data = {}
        data.host = self
        data.returnBtn = self.OnReturnClick
        data.detailBtn = self.OnDetailClick
        data.shareBtn = self.OnShareClick
        data.markBtn = self.OnMarkClick
        self.viewTopCom:Init(data)
        self.viewTopCom:RefreshData(self.info.pointData)
        local serverData = self:GetPointServerData()
        if serverData then
          self.viewTopCom:RefreshServerData(serverData)
        end
      end)
    end
  elseif self.viewTopCom then
    self.viewTopCom:RefreshData(self.info.pointData)
    local serverData = self:GetPointServerData()
    if serverData then
      self.viewTopCom:RefreshServerData(serverData)
    end
  end
end

function UIWorldPointView:PointObjectUpdateCall(uuid)
  if self.ctrl.uuid == uuid then
    self.needReInit = true
  end
end

function UIWorldPointView:GetMeteoriteCollectionNode()
  return self.dynamicMeteoriteInfo
end

function UIWorldPointView:HideMeteoriteCollectionNode()
  self.dynamicMeteoriteInfo:SetActive(false)
end

function UIWorldPointView:ShowMeteoriteCollectionNode()
  self.dynamicMeteoriteInfo:SetActive(true)
end

function UIWorldPointView:Description()
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("ctrl.type = %s", self.ctrl.type))
  sb:AppendLine(string.format("ctrl.uuid = %s", self.ctrl.uuid))
  sb:AppendLine(string.format("ctrl.pointId = %s", self.ctrl.pointId))
  sb:AppendLine(string.format("ctrl.ownerUid = %s", self.ctrl.ownerUid))
  sb:AppendLine(string.format("ctrl.isAlliance = %s", self.ctrl.isAlliance))
  sb:AppendLine(string.format("ctrl.buildId = %s", self.ctrl.buildId))
  sb:AppendLine(string.format("ctrl.desertId = %s", self.ctrl.desertId))
  sb:AppendLine(string.format("ctrl.isArrow = %s", self.ctrl.isArrow))
  sb:AppendLine("----\229\138\168\230\128\129\231\187\132\228\187\182\232\175\166\230\131\133----")
  if self.dynamicComps then
    sb:AppendFormatLine("\229\138\168\230\128\129\231\187\132\228\187\182\230\149\176\233\135\143:%s", #self.dynamicComps)
    for k, v in ipairs(self.dynamicComps) do
      sb:AppendLine(v:Description())
    end
  else
    sb:AppendLine("----\229\185\182\230\178\161\230\156\137\228\187\187\228\189\149\229\138\168\230\128\129\231\187\132\228\187\182\229\145\162----")
  end
  return sb:ToString()
end

local function Update(self)
  if self.needReInit then
    self:ReInit()
    self.needReInit = false
  end
end

function UIWorldPointView:SetTopBg(spritePath)
  if not spritePath then
    self.imgTopBg:SetActive(false)
  else
    self.imgTopBg:LoadSpriteAsync(spritePath)
    self.imgTopBg:SetActive(true)
  end
end

UIWorldPointView.OnCreate = OnCreate
UIWorldPointView.OnDestroy = OnDestroy
UIWorldPointView.OnEnable = OnEnable
UIWorldPointView.OnDisable = OnDisable
UIWorldPointView.ComponentDefine = ComponentDefine
UIWorldPointView.ComponentDestroy = ComponentDestroy
UIWorldPointView.DataDefine = DataDefine
UIWorldPointView.DataDestroy = DataDestroy
UIWorldPointView.OnAddListener = OnAddListener
UIWorldPointView.OnRemoveListener = OnRemoveListener
UIWorldPointView.ReInit = ReInit
UIWorldPointView.ShowTopBtn = ShowTopBtn
UIWorldPointView.ShowBtn = ShowBtn
UIWorldPointView.RefreshUIWorldPointViewSignal = RefreshUIWorldPointViewSignal
UIWorldPointView.SetAllCellDestroy = SetAllCellDestroy
UIWorldPointView.SetData = SetData
UIWorldPointView.OnReturnClick = OnReturnClick
UIWorldPointView.OnDetailClick = OnDetailClick
UIWorldPointView.OnMarkClick = OnMarkClick
UIWorldPointView.OnShareClick = OnShareClick
UIWorldPointView.OnKingClick = OnKingClick
UIWorldPointView.RefreshRewardList = RefreshRewardList
UIWorldPointView.UpdateLod = UpdateLod
UIWorldPointView.CheckResourceItemIsFull = CheckResourceItemIsFull
UIWorldPointView.ShowGuideGarbage = ShowGuideGarbage
UIWorldPointView.ShowArrow = ShowArrow
UIWorldPointView.UpdateActBossBlood = UpdateActBossBlood
UIWorldPointView.RefreshMarkBtnImg = RefreshMarkBtnImg
UIWorldPointView.GetRealPoint = GetRealPoint
UIWorldPointView.RefreshMarkList = RefreshMarkList
UIWorldPointView.RefreshAllianceMarkBtn = RefreshAllianceMarkBtn
UIWorldPointView.AddUpdate = AddUpdate
UIWorldPointView.RemoveUpdate = RemoveUpdate
UIWorldPointView.OnUpdate = OnUpdate
UIWorldPointView.RunningBossTodaySkill = RunningBossTodaySkill
UIWorldPointView.PostProcessDispatchTask = PostProcessDispatchTask
UIWorldPointView.ShowAsyncLoadContent = ShowAsyncLoadContent
UIWorldPointView.Update = Update
return UIWorldPointView
