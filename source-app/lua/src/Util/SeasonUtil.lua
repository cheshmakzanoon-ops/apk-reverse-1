local SeasonUtil = {}
local Localization = CS.GameEntry.Localization
local WorldCityTableName = {}
local SeasonActivityContentHandler = {}
SeasonActivityContentHandler[EnumActivity.SeasonAttackCityActivity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/AttackCity/UIAttackCityMain.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.AttackCity.SeasonAttackCityMain"
}
SeasonActivityContentHandler[EnumActivity.SeasonCrossAttackCityActivity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/CrossServerAttackCity/CrossServerAttackCity.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.CrossServerAttackCity.CrossServerAttackCity"
}
SeasonActivityContentHandler[EnumActivity.SeasonAttackWorldDesertActivity.Type] = {
  assetPath = UIAssets.UIActWastelandChallengeRank,
  clsPath = "UI.UIActivityCenterTable.Component.UIActWastelandChallengeRank.UIActWastelandChallengeRank"
}
SeasonActivityContentHandler[EnumActivity.SeasonCrossDeclareWarActivity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/DeclareCity/DeclareCityMain.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityMain"
}
SeasonActivityContentHandler[EnumActivity.SeasonServerBattleV8Activity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/LWServerBattleV8Main.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.ServerBattleV8.ServerBattleV8Main"
}
SeasonActivityContentHandler[EnumActivity.NineNationKingBattle.Type] = {
  viewName = UIWindowNames.UIKingBattle
}
SeasonActivityContentHandler[EnumActivity.Season6CampDestroy.Type] = {
  viewName = UIWindowNames.SeasonCampDestroyMain
}

function SeasonUtil.OpenSeasonCampDestroyBuffDetail()
  local mgr = DataCenter.SeasonCampDestroyManager
  if not mgr or not mgr.actConfig then
    return
  end
  local actConfig = mgr.actConfig
  local para = actConfig:getValue("para")
  local para1 = actConfig:getValue("para_1")
  if not para or not para1 then
    return
  end
  local thresholds = string.split(para, "|")
  local statusIds = string.split(para1, "|")
  if #thresholds ~= #statusIds or #thresholds == 0 then
    return
  end
  local statusConfigs = {}
  for i = 1, #thresholds do
    local statusId = toInt(statusIds[i])
    local statusConfig = LocalController:instance():getLine(TableName.StatusTab, statusId)
    if statusConfig then
      table.insert(statusConfigs, {
        statusId = statusId,
        threshold = toInt(thresholds[i]),
        name = statusConfig:getValue("name") or "",
        icon = statusConfig:getValue("icon") or "",
        description = statusConfig:getValue("description") or "",
        info = statusConfig:getValue("info") or ""
      })
    end
  end
  if #statusConfigs == 0 then
    return
  end
  local args = {
    windowTitle = Localization:GetString("season_s6_activity_1200112_buff_title"),
    desc = Localization:GetString("season_s6_activity_1200112_buff_desc"),
    titles = {
      Localization:GetString("season_s6_activity_1200112_buff_limit_col1"),
      Localization:GetString("season_s6_activity_1200112_buff_limit_col2"),
      Localization:GetString("season_s6_activity_1200112_buff_limit_col3")
    },
    contents = {}
  }
  for i, config in ipairs(statusConfigs) do
    local rangeText = ""
    if i == #statusConfigs then
      rangeText = string.format("0%% - %d%%", config.threshold)
    else
      local nextConfig = statusConfigs[i + 1]
      rangeText = string.format("%d%% - %d%%", nextConfig.threshold, config.threshold)
    end
    table.insert(args.contents, {
      rangeText,
      Localization:GetString(config.name),
      Localization:GetString(config.description)
    })
  end
  UIUtil.OpenAuto(UIWindowNames.SeasonCampDestroyBuffDetail, args)
end

SeasonActivityContentHandler[EnumActivity.SeasonKillMonsterRank.Type] = {
  assetPath = UIAssets.UIActWastelandChallengeRank,
  clsPath = "UI.UIActivityCenterTable.Component.UIActWastelandChallengeRank.UIActWastelandChallengeRank"
}
SeasonActivityContentHandler[EnumActivity.SeasonStrongholdRank.Type] = {
  assetPath = UIAssets.UIActWastelandChallengeRank,
  clsPath = "UI.UIActivityCenterTable.Component.UIActWastelandChallengeRank.UIActWastelandChallengeRank"
}
SeasonActivityContentHandler[EnumActivity.SeasonSynthesis.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonSynthesis.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.SeasonSynthesis.SeasonSynthesis"
}
SeasonActivityContentHandler[EnumActivity.SeasonCallbackActivity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/UISeasonCallback.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallback"
}
SeasonActivityContentHandler[EnumActivity.ActMigration.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationMain.prefab",
  clsPath = "UI.LWUIMigration.LWUIMigrationMain"
}
SeasonActivityContentHandler[EnumActivity.SeasonFactionKingWarActivity.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason/ServerBattleCamp.prefab",
  clsPath = "UI.LWSeason.LWSeasonMain.Component.ServerBattleCamp.ServerBattleCamp"
}
SeasonActivityContentHandler[EnumActivity.SeasonPhoto.Type] = {
  viewName = UIWindowNames.SeasonPhotoMain
}
SeasonActivityContentHandler[EnumActivity.HighSpeedRailway.Type] = {
  viewName = UIWindowNames.UIHSRMain
}
SeasonActivityContentHandler[EnumActivity.SeasonPreview.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason1/SeasonPreview/SeasonPreviewS1.prefab",
  clsPath = "UI.LWSeason1.SeasonPreview.Main/SeasonPreviewMain"
}
SeasonActivityContentHandler[EnumActivity.DesertTreasure.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason1/UIActDesertTreasure.prefab",
  clsPath = "UI/LWSeason1/DesertTreasure/UIActDesertTreasureViewS1"
}
SeasonActivityContentHandler[EnumActivity.LimitedTimeFeast.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason1/SpreadVirus/LWSeasonSpreadVirus.prefab",
  clsPath = "UI.LWSeason1.LWSeasonSpreadVirus.View.LWSeasonSpreadVirusView"
}
SeasonActivityContentHandler[EnumActivity.VirusResearch.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason1/VirusResearch/LWSeasonVirusResearch.prefab",
  clsPath = "UI.LWSeason1.LWSeasonVirusResearch.Main.LWSeasonVirusResearchView"
}
SeasonActivityContentHandler[EnumActivity.BossLogin.Type] = {
  assetPath = "Assets/Main/Prefabs/UI/LWSeason1/BossLogin/LWSeasonBossLogin.prefab",
  clsPath = "UI.LWSeason1.LWSeasonBossLogin.View.LWSeasonBossLoginView"
}
SeasonActivityContentHandler[EnumActivity.SeasonAllianceWarTime.Type] = {
  assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeMain.prefab",
  clsPath = "UI.LWSeason5.UILWSeasonAllianceWarTime.UILWSeasonAllianceWarTimeMain"
}
SeasonActivityContentHandler.Season_2_0 = {
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason1/UIAttackCityMain.prefab",
    clsPath = "UI.LWSeason1.SeasonAttackCityMain"
  },
  [EnumActivity.SeasonPeriodicCard.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonPeriodicCard/UIActSeasonPeriodicCard.prefab",
    clsPath = "UI.LWSeason.LWSeasonMain.Component.UILWActPeriodicCard"
  },
  [EnumActivity.SeasonServerBattleV8Activity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason/LWServerBattleV8MainS1.prefab",
    clsPath = "UI.LWSeason.LWSeasonMain.Component.ServerBattleV8.ServerBattleV8Main"
  },
  [EnumActivity.SeasonFarmer.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonFarmerMain.prefab",
    clsPath = "UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerMain"
  },
  [EnumActivity.SeasonPreview.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/SeasonPreview/SeasonPreviewS2.prefab",
    clsPath = "UI.LWSeason2.SeasonPreview.Main.SeasonPreviewMain"
  },
  [EnumActivity.ActivityTetris.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisMain.prefab",
    clsPath = "UI.LWSeason1.UILWSeasonTetris.UILWSeasonTetrisMain"
  }
}
SeasonActivityContentHandler.Season_3_0 = {
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/UIAttackSnowCityMain.prefab",
    clsPath = "UI.LWSeason2.Activity.LWSeasonAttackSnowCityMain"
  },
  [EnumActivity.SeasonFactionSelectionActivity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionSelection.prefab",
    clsPath = "UI.LWSeason2.Activity.LWSeasonFactionSelection"
  },
  [EnumActivity.SeasonFactionDeclareWarActivity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionDeclareWar.prefab",
    clsPath = "UI.LWSeason2.Activity.LWSeasonFactionDeclareWar"
  },
  [EnumActivity.SeasonFactionBigWarActivity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionBigWar.prefab",
    clsPath = "UI.LWSeason2.Activity.LWSeasonFactionBigWar"
  },
  [EnumActivity.SeasonPeriodicCard.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonPeriodicCard/UIActSeasonPeriodicCard.prefab",
    clsPath = "UI.LWSeason.LWSeasonMain.Component.UILWActPeriodicCard"
  },
  [EnumActivity.SeasonServerBattleV8Activity.Type] = {
    assetPath = "Assets/Main/Prefabs/UI/LWSeason/LWServerBattleV8MainS1.prefab",
    clsPath = "UI.LWSeason.LWSeasonMain.Component.ServerBattleV8.ServerBattleV8Main"
  },
  [EnumActivity.SeasonPreview.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonPreview/SeasonPreview.prefab",
    clsPath = "UI.LWSeason3.SeasonPreview.Main.SeasonPreviewMain"
  }
}
SeasonActivityContentHandler.Season_4_0 = {
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/UIAttackWormCityMain.prefab",
    clsPath = "UI.LWSeason3.Activity.LWSeasonAttackWormCityMain"
  },
  [EnumActivity.SeasonFactionSelectionActivityMummy.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/UIActivityContent.prefab",
    clsPath = "UI.LWSeason3.UILWFactionSelection.LWSeasonFactionSelectionS3"
  },
  [EnumActivity.SeasonFactionDeclareWarActivityMummy.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionDeclareWar/FactionDeclareWar.prefab",
    clsPath = "UI.LWSeason3.UILWFactionWar.LWSeasonFactionDeclareWarS3"
  },
  [EnumActivity.SeasonFactionBigWarActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/FactionBigWar.prefab",
    clsPath = "UI.LWSeason3.UILWFactionWar.LWSeasonFactionBigWarS3"
  },
  [EnumActivity.DiggingGame.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/DiggingGame/DiggingGameMain.prefab",
    clsPath = "UI.LWSeason3.DiggingGame.DiggingGameMain.DiggingGameMain"
  },
  [EnumActivity.TradeStation.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWTradeStation/TradeStationMain.prefab",
    clsPath = "UI.LWSeason.LWSeasonTradeStation.TradeStationMain.TradeStationMain"
  },
  [EnumActivity.SeasonGreen.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/SeasonGreenMain.prefab",
    clsPath = "UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.SeasonGreenMain"
  },
  [EnumActivity.DesertTreasure.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/Activity/DesertTreasure/UIActDesertTreasure.prefab",
    clsPath = "UI.LWSeason3.Activity.DesertTreasure.UIActDesertTreasureView"
  },
  [EnumActivity.SeasonLastWar.Type] = {
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/Season3LastWar.prefab",
    clsPath = "UI.LWSeason3.Activity.Season3LastWar"
  },
  [EnumActivity.SeasonPreview.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSeason4/SeasonActivity/SeasonPreview/SeasonPreview.prefab",
    clsPath = "UI.LWSeason4.SeasonPreview.Main.SeasonPreviewMain"
  }
}
SeasonActivityContentHandler.Season_5_0 = {
  [EnumActivity.SeasonLastWar.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/Season4LastWar.prefab",
    clsPath = "UI.LWSeason4.Activity.Season4LastWar"
  },
  [EnumActivity.TradeStation.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/TradeStationMainS4.prefab",
    clsPath = "UI.LWSeason4.TradeStationMain.TradeStationMainS4"
  },
  [EnumActivity.SeasonFactionSelectionActivityMummy.Type] = {
    assetPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UIActivityContent.prefab",
    clsPath = "UI.LWSeason4.UILWFactionSelection.LWSeasonFactionSelectionS4"
  },
  [EnumActivity.DesertTreasure.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/DesertTreasure/UIActDesertTreasure.prefab",
    clsPath = "UI.LWSeason4.Activity.DesertTreasure.UIActDesertTreasureViewS4"
  },
  [EnumActivity.SeasonFactionDeclareWarActivityMummy.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/FactionDeclareWar/FactionDeclareWar.prefab",
    clsPath = "UI.LWSeason4.UILWFactionWar.LWSeasonFactionDeclareWarS4"
  },
  [EnumActivity.SeasonFactionBigWarActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/FactionBigWar.prefab",
    clsPath = "UI.LWSeason4.UILWFactionWar.LWSeasonFactionBigWarS4"
  },
  [EnumActivity.SeasonHunter.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterMain.prefab",
    clsPath = "UI.LWSeason.LWSeasonHunter.SeasonHunterMain.SeasonHunterMain"
  },
  [EnumActivity.DarknessSupplies.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/LWSeasonSuppliesShareS4.prefab",
    clsPath = "UI.LWSeason4.Activity.SeasonSupplies.SeasonSuppliesShareS4"
  },
  [EnumActivity.GoldTree.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreeMain.prefab",
    clsPath = "UI.LWSeason.LWSeasonGoldTree.SeasonGoldTreeMain.SeasonGoldTreeMain"
  },
  [EnumActivity.SheepGame.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepActivity.prefab",
    clsPath = "UI.LWSeason4.Activity.SheepGame.LWUISheepActivity"
  },
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/CityOccupy/UIAttackDarkCityMain.prefab",
    clsPath = "UI.LWSeason4.Activity.LWSeasonAttackDarkCityMain"
  },
  [EnumActivity.SeasonSelectLocation.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocation/SeasonSelectLocationMain.prefab",
    clsPath = "UI.LWSeason5.SeasonSelectLocation.SeasonSelectLocationMain"
  },
  [EnumActivity.SeasonSelectLocationGame.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocationGame/SeasonSelectLocationGameMain.prefab",
    clsPath = "UI.LWSeason5.SeasonSelectLocationGame.SeasonSelectLocationGameMain"
  },
  [EnumActivity.SeasonPreview.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonActivity/SeasonPreview/SeasonPreviewS5.prefab",
    clsPath = "UI.LWSeason5.SeasonPreview.Main.SeasonPreviewMain"
  }
}
SeasonActivityContentHandler.Season_6_0 = {
  [EnumActivity.SeasonBountyShop.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonBountyShop/SeasonBountyShop.prefab",
    clsPath = "UI.LWSeason5.SeasonBountyShop.SeasonBountyShopMain",
    CanShow = function()
      return DataCenter.SeasonBountyShopManager:ActCanShow()
    end,
    CantEnterAction = function()
      UIUtil.ShowTipsId("season_s5_bp_tips01")
    end
  },
  [EnumActivity.SeasonCrossDeclareWarActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/DeclareCityS5/S5DeclareCityMain.prefab",
    clsPath = "UI.LWSeason5.DeclareCity.Season5DeclareCityMain"
  },
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/LWSeason5/Season5AttackCityContainer.prefab",
    clsPath = "UI.LWSeason5.Activity.LWSeason5AttackCityContainer"
  },
  [EnumActivity.TradeStation.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/TradeStationMainS5.prefab",
    clsPath = "UI.LWSeason5.TradeStationMain.TradeStationMainS5"
  },
  [EnumActivity.SeasonMoneyRank.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonMoneyRank/SeasonMoneyRankMain.prefab",
    clsPath = "UI.LWSeason5.UILWSeasonMoneyRank.SeasonMoneyRankMain"
  },
  [EnumActivity.SeasonWarZoneOutpostFix.Type] = {
    viewName = UIWindowNames.UILWSeasonOutpostFixS5
  },
  [EnumActivity.SeasonWarZoneOutpostAttack.Type] = {
    viewName = UIWindowNames.UILWSeasonOutpostAttackS5
  },
  [EnumActivity.NineNationKingBattle.Type] = {
    viewName = UIWindowNames.UIKingBattle
  },
  [EnumActivity.BiuBiu.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/BiuBiu/UILWBiuBiuActivity.prefab",
    clsPath = "UI.LWSeason5.Activity.BiuBiu.UILWBiuBiuActivity"
  },
  [EnumActivity.SeasonSelectCamp.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SelectCamp/S6SelectCampMain.prefab",
    clsPath = "UI.LWSeason6.UILWSeasonSelectCamp.UILWSeasonSelectCampMain"
  },
  [EnumActivity.SeasonPreview.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/SeasonPreview/SeasonPreviewS6.prefab",
    clsPath = "UI.LWSeason6.SeasonPreview.Main.SeasonPreviewMain"
  }
}
SeasonActivityContentHandler.Season_6_1 = {
  [EnumActivity.SeasonRainforestKingBattle.Type] = {
    viewName = UIWindowNames.UILWSeasonRainforestKingBattle
  },
  [EnumActivity.SeasonWarZoneOutpostFix.Type] = {
    viewName = UIWindowNames.UILWSeasonOutpostMainUIS6
  },
  [EnumActivity.SeasonWarZoneOutpostAttack.Type] = {
    viewName = UIWindowNames.UILWSeasonOutpostAttackS6
  },
  [EnumActivity.SeasonAttackCityActivity.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Season6AttackCityContainer.prefab",
    clsPath = "UI.LWSeason6.Activity.LWSeason6AttackCityContainer"
  },
  [EnumActivity.TradeStation.Type] = {
    assetPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/TradeStationMainS5.prefab",
    clsPath = "UI.LWSeason5.TradeStationMain.TradeStationMainS5"
  },
  [EnumActivity.CampScience.Type] = {
    assetPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampScience.prefab",
    clsPath = "UI.LWSeasonShared.UICampScience.UICampScienceMain"
  },
  [EnumActivity.GGGo.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/GGGo/UILWGGGoActivity.prefab",
    clsPath = "UI.LWSeason6.GGGo.UILWGGGoActivity"
  },
  [EnumActivity.SeasonMilitary.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Military/S6MilitaryMain.prefab",
    clsPath = "UI.LWSeason6.UILWSeasonMilitary.UILWSeasonMilitaryMain"
  },
  [EnumActivity.SeasonMilitaryElite.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MilitaryElite/S6MilitaryEliteMain.prefab",
    clsPath = "UI.LWSeason6.UILWSeasonMilitaryElite.UILWSeasonMilitaryEliteMain",
    CanShow = function()
      return false
    end
  },
  [EnumActivity.SeasonBountyShop.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MilitaryShop/SeasonMilitaryShop.prefab",
    clsPath = "UI.LWSeason6.UILWSeasonMilitaryShop.UILWSeasonMilitaryShopMain",
    CanShow = function()
      return DataCenter.SeasonBountyShopManager:ActCanShow()
    end,
    CanEnter = function()
      return DataCenter.SeasonBountyShopManager:ActCanShow()
    end,
    CantEnterAction = function()
      UIUtil.ShowTipsId("season_s5_bp_tips01")
    end
  },
  [EnumActivity.SeasonCityAltar.Type] = {
    assetPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/CityAltar/S6CityAltarMain.prefab",
    clsPath = "UI.LWSeason6.UILWSeasonCityAltar.UILWSeasonCityAltarMain"
  }
}

function SeasonUtil.UpdateActivityContentHandler()
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config and config.season_icon == "Mjc_saiji2_zhujiemian_cion_new" then
    local actConfig = SeasonActivityContentHandler.Season_2_0
    if actConfig then
      actConfig[EnumActivity.SeasonAttackCityActivity.Type] = {
        assetPath = "Assets/Main/Prefabs/UI/LWSeason1/UIAttackCityMainLondon.prefab",
        clsPath = "UI.LWSeason1.SeasonAttackCityMainLondon"
      }
      actConfig[EnumActivity.SeasonServerBattleV8Activity.Type] = {
        assetPath = "Assets/Main/Prefabs/UI/LWSeason/LWServerBattleV8MainLondon.prefab",
        clsPath = "UI.LWSeason.LWSeasonMain.Component.ServerBattleV8.ServerBattleV8Main"
      }
    end
  end
end

function SeasonUtil.GetSeasonActivityContentHandler(ActivityType, subViewType)
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local theSeasonMapType1 = SeasonMapType.Nothing
  local theSeasonMapType2 = 0
  if infoPlayer and infoPlayer.currentSeasonConfig then
    theSeasonMapType1 = toInt(infoPlayer.currentSeasonConfig.type)
    theSeasonMapType2 = toInt(infoPlayer.currentSeasonConfig.type1 or infoPlayer.currentSeasonConfig.type2)
  end
  local key = string.format("Season_%s_%s", theSeasonMapType1, theSeasonMapType2)
  if SeasonActivityContentHandler[key] ~= nil then
    local data = SeasonActivityContentHandler[key][ActivityType]
    if data ~= nil then
      return data
    end
  end
  local cfg = SeasonActivityContentHandler[ActivityType]
  if cfg ~= nil then
    return cfg
  end
  if theSeasonMapType2 ~= 0 and subViewType == BattlePassType.SeasonBattlePass and ActivityType == EnumActivity.BattlePass_new.Type then
    local handlerData = {}
    handlerData.assetPath = UIAssets.UISeasonBattlePass
    handlerData.cls = require("UI.LWSeasonShared.UIBattlePass.View.UISeasonBattlePassView")
    return handlerData
  end
  return nil
end

function SeasonUtil.OpenSeasonActivityById(closeOtherWindows, activityId, ...)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData then
    if closeOtherWindows then
      GoToUtil.CloseAllWindows()
    end
    SeasonUtil.OpenSeasonActivity(activityData)
    return true
  end
  return false
end

function SeasonUtil.OpenSeasonActivity(data, ...)
  local soundId = DataCenter.SeasonDataManager:GetSeasonUIButtonSoundId(data)
  if soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
  if data == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, "SeasonMain", ...)
    return
  end
  local handlerData = SeasonUtil.GetSeasonActivityContentHandler(data.type)
  if handlerData ~= nil and handlerData.CanEnter ~= nil and not handlerData.CanEnter() then
    if handlerData.CantEnterAction ~= nil then
      handlerData.CantEnterAction()
    end
    return
  end
  if handlerData and handlerData.viewName then
    if data and type(data.PlayLoginSound) == "function" then
      data:PlayLoginSound()
    end
    UIManager:GetInstance():OpenWindow(handlerData.viewName, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, data.id, ...)
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
    local titleText = select(1, ...)
    local param = select(2, ...)
    EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {
      activityId = data.id,
      titleTxt = titleText,
      param = param,
      anim = anim,
      UIMainAnim = UIMainAnim
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, data.id, ...)
  end
end

function SeasonUtil.OpenSeasonActivityByType(act_type, ...)
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(act_type)
  if activityData == nil then
    UIUtil.ShowTipsId("season_tips137")
    return
  end
  SeasonUtil.OpenSeasonActivity(activityData, ...)
end

function SeasonUtil.IsOpen()
  return SeasonUtil.IsInSeasonPrepareMode() or SeasonUtil.IsInSeason()
end

function SeasonUtil.GetSeasonInfo(serverId)
  local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList
  if infoList and serverId ~= nil and serverId ~= 0 then
    return infoList[toInt(serverId)]
  end
  return nil
end

function SeasonUtil.GetCurServerConfig()
  return SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
end

function SeasonUtil.CurServerIsInSeason()
  if LuaEntry.Player:IsInSourceServer() then
    return SeasonUtil.IsInSeason()
  end
  local data = SeasonUtil.GetCurServerConfig()
  if data then
    return data:ServerInReady() and data:InNormalMode()
  end
  return false
end

function SeasonUtil.CurServerTypeInSeason(needSubdivisionType)
  if LuaEntry.Player:IsInSourceServer() then
    if needSubdivisionType == true then
      return SeasonUtil.GetSeasonSubdivisionType()
    end
    return SeasonUtil.GetSeasonType(false, needSubdivisionType)
  end
  local data = SeasonUtil.GetCurServerConfig()
  if data and (data.open and data.mode == 1 or data.mode == 2 or data.mode == 3) then
    if needSubdivisionType == true then
      return data:GetServerSubdivisionType()
    end
    return data:GetServerType()
  end
  return SeasonMapType.Nothing
end

function SeasonUtil.IsInSeasonOrHalt(serverId)
  local data = SeasonUtil.GetSeasonInfo(serverId)
  if data and (data:ServerInReady() and data:InNormalMode() or data:InHaltMode()) then
    return true
  end
  return false
end

function SeasonUtil.NeedTipWhenQuitAlliance()
  local mgr = DataCenter.SeasonDataManager
  local info = mgr:GetUserSeasonInfo()
  if info and info.seasonConfig and not string.IsNullOrEmpty(info.seasonConfig.join_alliance_cd) and info:ServerInReady() and mgr:InNormalMode() then
    local join_alliance_cd = info.seasonConfig.join_alliance_cd
    if join_alliance_cd ~= nil and join_alliance_cd ~= "" and join_alliance_cd ~= 0 then
      local A, B = string.match(join_alliance_cd, "([^|]+)|([^|]+)")
      if A and B and 0 < toInt(A) then
        return true
      end
    end
  end
  return false
end

function SeasonUtil.IsInSeason(ignoreGroup)
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local infoServer = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if infoServer == nil or infoPlayer == nil then
    return false
  end
  if ignoreGroup == true then
    local theTypeServer = infoServer:GetServerSubdivisionType(false)
    local theTypePlayer = infoPlayer:GetServerSubdivisionType(false)
    if theTypeServer ~= theTypePlayer or infoServer:GetSeasonEndTime() ~= infoPlayer:GetSeasonEndTime() then
      return false
    end
    return infoPlayer:ServerInReady() and infoPlayer:InNormalMode() and infoServer:ServerInReady() and infoServer:InNormalMode()
  end
  if infoPlayer then
    return infoPlayer:ServerInReady() and infoPlayer:InNormalMode() and infoPlayer:IsInBattleServerGroupInt(LuaEntry.Player:GetSelfServerId())
  end
  return false
end

function SeasonUtil.IsUserInSeason()
  local seasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  return seasonInfo and seasonInfo:ServerInReady() and seasonInfo:InNormalMode()
end

function SeasonUtil.GetServerGroup()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer then
    return infoPlayer:GetServerGroup()
  end
end

function SeasonUtil.IsInSameGroup(serverId, serverEnum)
  if serverId == nil or serverId <= 0 then
    return false
  end
  local seasonInfoTemplate
  if serverEnum == nil or serverEnum == ServerEnum.Source then
    seasonInfoTemplate = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  elseif serverEnum == ServerEnum.Login then
    seasonInfoTemplate = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  elseif serverEnum == ServerEnum.View then
    seasonInfoTemplate = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
  end
  if not seasonInfoTemplate then
    return false
  end
  return seasonInfoTemplate:IsInBattleServerGroupInt_IgnoreSplitServer(toInt(serverId))
end

function SeasonUtil.IsInSameMap(serverId, serverEnum)
  local myServerId = LuaEntry.Player:GetServerId(serverEnum)
  if SeasonUtil.InSeasonBigMapMode(myServerId) then
    return SeasonUtil.IsInSameGroup(serverId, serverEnum)
  end
  return serverId == myServerId
end

function SeasonUtil.IsInSeasonWithoutGroup()
  return SeasonUtil.IsInSeason(true)
end

function SeasonUtil.IsInSeasonTruceMode()
  local data = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if data and (data:ServerInReady() and data:InNormalMode() or data:InTruceMode()) then
    return true
  end
  return false
end

function SeasonUtil.IsInSeasonPrepareMode(checkTime_)
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if info and info:IsInBattleServerGroupInt(LuaEntry.Player:GetSelfServerId()) then
    if info:InPreviewMode() then
      local endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
      if endTime == nil then
        Logger.LogError("\229\156\168\233\162\132\231\131\173\230\156\159\228\189\134\230\152\175\230\178\161\230\156\137\230\137\190\229\136\176\228\184\139\228\184\128\232\181\155\229\173\163\231\154\132\230\149\176\230\141\174")
        return false
      end
      if checkTime_ and endTime < UITimeManager:GetInstance():GetServerTime() then
        return false
      end
      return true
    end
    local isWait = not info:ServerInReady() and info:InNormalMode()
    if isWait and checkTime_ then
      return false
    else
      return isWait
    end
  end
  return false
end

function SeasonUtil.GetFarmerConfigId()
  local cfgId = 0
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  if season and 0 < season and SeasonUtil.IsInSeason() then
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config and config.builders_alliance_group then
      cfgId = toInt(config.builders_alliance_group)
    end
  end
  return cfgId
end

function SeasonUtil.HasVirus()
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if info == nil then
    CityState.VirusCity = 0
    CityState.VirusCityMax = 0
    CityState.VirusCityMaxEffect = 0
    return false, 0, 0
  end
  if info then
    if toInt(info.seasonId) == 0 then
      CityState.VirusCity = 0
      CityState.VirusCityMax = 0
      CityState.VirusCityMaxEffect = 0
      return false, 0, 0
    end
    if info:ServerInReady() and info:InNormalMode() then
      if CityState.VirusCity ~= nil and CityState.VirusCity ~= 0 and CityState.VirusCityMax ~= nil and CityState.VirusCityMax ~= 0 then
        local VirusCity = toInt(CityState.VirusCity)
        return 0 < VirusCity, VirusCity, toInt(CityState.VirusCityMax)
      end
      local config = info:GetCurrentSeasonConfig()
      if config and config.virus_infection and not string.IsNullOrEmpty(config.virus_infection) then
        local hasVirus, theEffectId = string.match(config.virus_infection, "([^;]+);([^;]+)")
        if hasVirus == "1" and theEffectId then
          CityState.VirusCity = toInt(theEffectId)
          LocalController:instance():visitTable(TableName.StatusEffect, function(id, lineData)
            if toInt(lineData.father_status) == CityState.VirusCity and lineData.level_max ~= nil and lineData.level_max ~= "" then
              local arr = string.split(lineData.level_max, "|")
              if arr ~= nil and 0 < #arr then
                CityState.VirusCityMax = toInt(id)
                CityState.VirusCityMaxEffect = toInt(arr[1])
                CS.GameEntry.Data.Player:SetData("VirusCityMaxEffect", tostring(CityState.VirusCityMax))
              end
            end
          end)
          return true, toInt(CityState.VirusCity), toInt(CityState.VirusCityMax)
        elseif hasVirus == "0" then
          CityState.VirusCity = 0
          CityState.VirusCityMax = 0
          CityState.VirusCityMaxEffect = 0
        end
      else
        CityState.VirusCity = 0
        CityState.VirusCityMax = 0
        CityState.VirusCityMaxEffect = 0
      end
    end
  end
  return false, 0, 0
end

function SeasonUtil.GetSeasonEndTime()
  return DataCenter.SeasonDataManager:GetSeasonEndTime()
end

function SeasonUtil.CalcVirusLevel(virusNum, endTime, statusId)
  local virusLayer = toInt(virusNum)
  local virusEndTime = toInt(endTime)
  if virusLayer <= 0 or virusEndTime <= 0 then
    return 0, 0, 0
  end
  local virusLifeTime = toInt(GetTableData(TableName.StatusTab, statusId or CityState.VirusCity, "time", 300))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if virusEndTime < 4000000000 and 1600000000 < virusEndTime then
    curTime = curTime * 0.001
  else
    virusLifeTime = virusLifeTime * 1000
  end
  if virusEndTime < curTime then
    if virusLayer == 1 then
      return 0, 0, 0
    end
    repeat
      virusEndTime = virusEndTime + virusLifeTime
      virusLayer = virusLayer - 1
    until curTime <= virusEndTime or virusLayer == 0
  end
  if 1 < virusLayer then
    return virusLayer, virusEndTime, virusEndTime + (virusLayer - 1) * virusLifeTime
  end
  return virusLayer, virusEndTime, virusEndTime
end

function SeasonUtil.HasAllianceScienceData()
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  if season and 0 < season then
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config and config.alliance_science and config.alliance_science ~= "" and config.alliance_science ~= 0 then
      return DataCenter.AllianceScienceTemplateManager:ExistSeasonScienceTabData(config.alliance_science)
    end
  end
  return false
end

function SeasonUtil.IsMummySoldierFunctionEnabled()
  local isInSeason = SeasonUtil.IsInSeason(true)
  local seasonType = SeasonUtil.GetSeasonType()
  return isInSeason and (seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation)
end

function SeasonUtil.IsInSeasonDesertMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType() == SeasonMapType.Desert
end

function SeasonUtil.IsInSeasonCityStrongholdMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold
end

function SeasonUtil.IsInSeasonSnowMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType() == SeasonMapType.Snow
end

function SeasonUtil.IsInSeasonMummyMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType() == SeasonMapType.Mummy
end

function SeasonUtil.IsInSeasonDarknessMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType() == SeasonMapType.Darkness
end

function SeasonUtil.IsInSeasonNineNationMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType(false, false) == SeasonMapType.NineNation
end

function SeasonUtil.IsInSeasonNineNationBasicMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType(false, true) == SeasonMapType.NineNation
end

function SeasonUtil.IsInSeasonNineNationRainforestMode(ignoreGroup)
  return SeasonUtil.IsInSeason(ignoreGroup) and SeasonUtil.GetSeasonType(false, true) == SeasonMapType.NineNationRainforest
end

function SeasonUtil.IsInRainforestSeason(ignoreGroup)
  return SeasonUtil.IsInSeasonNineNationRainforestMode(ignoreGroup)
end

function SeasonUtil.GetCurWorldSeasonType(anyMode, needSubdivisionType)
  local config = SeasonUtil.GetCurServerConfig()
  if config and (anyMode == true and config.mode ~= 0 or config.open and config.mode == 1) then
    if needSubdivisionType == true then
      return config:GetServerSubdivisionType()
    end
    return config:GetServerType()
  end
  return SeasonMapType.Nothing
end

function SeasonUtil.GetCurWorldSeasonId(anyMode)
  local config = SeasonUtil.GetCurServerConfig()
  if config and (anyMode == true and config.mode ~= 0 or config.open and config.mode == 1) then
    return config.seasonId
  end
  return 0
end

function SeasonUtil.GetSourceSeasonType(needSubdivisionType)
  local config = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if config and config.open and config.mode == 1 then
    if needSubdivisionType == true then
      return config:GetServerSubdivisionType()
    end
    return config:GetServerType()
  end
  return SeasonMapType.Nothing
end

function SeasonUtil.IsInSeasonSnowModeWithoutGroup()
  return SeasonUtil.IsInSeasonWithoutGroup() and SeasonUtil.GetSeasonType() == SeasonMapType.Snow
end

function SeasonUtil.IsCurWorldInSeasonSnowModeWithoutGroup()
  local config = SeasonUtil.GetCurServerConfig()
  return config and config.open and config.mode == 1 and config:GetServerType() == SeasonMapType.Snow
end

function SeasonUtil.IsInAndAfterSeasonSnowMode()
  local data = SeasonUtil.GetCurServerConfig()
  return data and (data.open and data.mode == 1 or data.mode == 2) and data:GetServerType() == SeasonMapType.Snow
end

function SeasonUtil.OpenSeasonMain(includePreview)
  if SeasonUtil.IsInSeason() then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif includePreview and SeasonUtil.IsInSeasonPrepareMode(true) then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIUtil.ShowTipsId("season_tips168")
  end
end

local function ConvertSeasonUI(ui_name)
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local seasonType = SeasonMapType.Nothing
  if infoPlayer ~= nil then
    seasonType = infoPlayer:GetServerSubdivisionType(true)
  end
  if ui_name == UIWindowNames.UILWSeasonMain then
    if seasonType == SeasonMapType.NineNationRainforest then
      ui_name = UIWindowNames.LWSeason6Main
    elseif seasonType == SeasonMapType.NineNation then
      ui_name = UIWindowNames.LWSeason5Main
    elseif seasonType == SeasonMapType.Darkness then
      ui_name = UIWindowNames.LWSeason4Main
    elseif seasonType == SeasonMapType.Mummy then
      ui_name = UIWindowNames.LWSeason3Main
    elseif seasonType == SeasonMapType.Snow then
      ui_name = UIWindowNames.LWSeason2Main
    elseif seasonType == SeasonMapType.CityStronghold then
      ui_name = UIWindowNames.LWSeason1Main
    elseif seasonType == SeasonMapType.Desert then
      ui_name = UIWindowNames.UILWSeasonMain
    end
  elseif ui_name == UIWindowNames.UILWSeasonCityOccupyList then
    if seasonType == SeasonMapType.CityStronghold then
      ui_name = UIWindowNames.UILWSeasonCityOccupyList
    elseif seasonType == SeasonMapType.Snow then
      ui_name = UIWindowNames.UILWSeasonCityOccupyListS2
    elseif seasonType == SeasonMapType.Mummy then
      ui_name = UIWindowNames.UILWSeasonCityOccupyListS3
    elseif seasonType == SeasonMapType.Darkness then
      ui_name = UIWindowNames.UILWSeasonCityOccupyListS4
    elseif seasonType == SeasonMapType.NineNation then
      ui_name = UIWindowNames.UILWSeasonCityOccupyListS5
    elseif seasonType == SeasonMapType.NineNationRainforest then
      ui_name = UIWindowNames.UILWSeasonCityOccupyListS6
    end
  end
  if seasonType == SeasonMapType.NineNationRainforest then
    if ui_name == UIWindowNames.UILWMummyMain then
      ui_name = UIWindowNames.UILWMummyMainS6
    elseif ui_name == UIWindowNames.UILWMummyLack then
      ui_name = UIWindowNames.UILWMummyLackS6
    elseif ui_name == UIWindowNames.UILWMummyLackSource then
      ui_name = UIWindowNames.UILWMummyLackSourceS6
    end
  elseif seasonType == SeasonMapType.NineNation then
    if ui_name == UIWindowNames.UILWMummyMain then
      ui_name = UIWindowNames.UILWMummyMainS5
    elseif ui_name == UIWindowNames.UILWMummyLack then
      ui_name = UIWindowNames.UILWMummyLackS5
    elseif ui_name == UIWindowNames.UILWMummyLackSource then
      ui_name = UIWindowNames.UILWMummyLackSourceS5
    end
  end
  return ui_name
end

function SeasonUtil.ShowSeasonUI(ui_name, ...)
  UIManager:GetInstance():OpenWindow(ConvertSeasonUI(ui_name), ...)
end

function SeasonUtil.CloseSeasonUI(ui_name, closeOptions)
  UIManager:GetInstance():DestroyWindow(ConvertSeasonUI(ui_name), closeOptions)
end

function SeasonUtil.GetSeasonId()
  return DataCenter.SeasonDataManager:GetSeasonId()
end

function SeasonUtil.SeasonTaskShowCondition()
  local mainLv = DataCenter.BuildManager.MainLv
  if SeasonUtil.IsInSeason() and mainLv and mainLv >= SEASON_MIN_LEVEL then
    return true
  end
  return false
end

function SeasonUtil.CanAttackBuild(pointId, forceCheck)
  local inProtect = false
  local alreadyExitOccupy = false
  if SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer() == false or CrossServerUtil:GetIsCrossServer() and CrossServerUtil.GetIsInBattleServerGroup(LuaEntry.Player:GetCurServerId()) == true then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info ~= nil then
      cast(info, typeof(CS.BuildPointInfo))
      if info ~= nil then
        local mainIndex = info.mainIndex
        local tileSize = info.tileSize
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
        if buildTemplate ~= nil and (buildTemplate.tab_type == UIBuildListTabType.SeasonBuild or forceCheck or BuildingUtils.IsInEdenSubwayGroup(info.itemId) == true) then
          local vecPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
          local mainRange = BuildingUtils.GetAllNeighborsPos4(vecPos, tileSize, tileSize)
          for a, b in pairs(mainRange) do
            if inProtect == false then
              inProtect = SeasonUtil.IsDesertInProtect(SceneUtils.TilePosToIndex(b, ForceChangeScene.World))
            end
          end
          if inProtect == false then
            local rangeList = BuildingUtils.GetBuildRoundPos(vecPos, tileSize, tileSize)
            for i = 1, #rangeList do
              if alreadyExitOccupy == false then
                local v2 = rangeList[i]
                alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(v2, ForceChangeScene.World))
              end
            end
          end
        else
          inProtect = false
          alreadyExitOccupy = true
        end
      end
    end
  else
    inProtect = false
    alreadyExitOccupy = true
  end
  return inProtect, alreadyExitOccupy
end

function SeasonUtil.CanAttackAllianceBuild(pointId)
  local inProtect = false
  local alreadyExitOccupy = false
  if SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer() == false or CrossServerUtil:GetIsCrossServer() and CrossServerUtil.GetIsInBattleServerGroup(LuaEntry.Player:GetCurServerId()) == true then
    local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
    local mainIndex = pointInfo.mainIndex
    if pointInfo ~= nil then
      local info = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if info then
        local tileSize = 3
        local mineID = info.buildId
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mineID)
        if template ~= nil then
          tileSize = template.resSize
        end
        alreadyExitOccupy = SeasonUtil.CheckDesertConnect(mainIndex, tileSize, false)
      end
    end
  else
    inProtect = false
    alreadyExitOccupy = true
  end
  return inProtect, alreadyExitOccupy
end

function SeasonUtil.GetSeason()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local infoServer = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  local seasonNumPlayer = 0
  local seasonNumServer = 0
  if infoPlayer ~= nil then
    seasonNumPlayer = toInt(infoPlayer.seasonId)
  end
  if infoServer ~= nil then
    seasonNumServer = toInt(infoServer.seasonId)
  end
  return seasonNumPlayer, seasonNumServer
end

function SeasonUtil.GetSeasonWeek(time)
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeek(time)
  if season <= 0 then
    seasonWeek = UITimeManager:GetInstance():GetOpenServerWeek(time)
  end
  return season, seasonWeek
end

function SeasonUtil.GetSeasonDay()
  if SeasonUtil.GetSeason() <= 0 then
    return UITimeManager:GetInstance():GetOpenServerDay()
  else
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local now = UITimeManager:GetInstance():GetServerTime()
    return (now - theSeasonStartTime) // 86400000 + 1
  end
end

function SeasonUtil.GetSeasonLeftDay()
  local theSeasonEndTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  return (theSeasonEndTime - now) // 86400000
end

function SeasonUtil.GetSeasonDayByOpenServerZero()
  if SeasonUtil.GetSeason() <= 0 then
    return UITimeManager:GetInstance():GetOpenServerDayByOpenServerZero()
  else
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local now = UITimeManager:GetInstance():GetServerTime()
    return (now - theSeasonStartTime) // 86400000 + 1
  end
end

function SeasonUtil.GetSeasonSubdivisionType(includePreview, server)
  local config
  if server == nil or server == ServerEnum.Login then
    config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  elseif server == ServerEnum.Source then
    config = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  elseif server == ServerEnum.View then
    config = SeasonUtil.GetCurServerConfig()
  elseif IsNumber(server) then
    config = SeasonUtil.GetSeasonInfo(server)
  end
  if config then
    return config:GetServerSubdivisionType(includePreview)
  end
  return SeasonMapType.Nothing
end

function SeasonUtil.GetSeasonType(includePreview, needSubdivisionType, server)
  local config
  if server == nil or server == ServerEnum.Login then
    config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  elseif server == ServerEnum.Source then
    config = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  elseif server == ServerEnum.View then
    config = SeasonUtil.GetCurServerConfig()
  elseif IsNumber(server) then
    config = SeasonUtil.GetSeasonInfo(server)
  end
  if config then
    if needSubdivisionType == true then
      return config:GetServerSubdivisionType(includePreview)
    end
    return config:GetServerType(includePreview)
  end
  return SeasonMapType.Nothing
end

function SeasonUtil.GetSeasonVersion(includePreview)
  local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if config then
    return config:GetSeasonVersion(includePreview)
  end
  return 0
end

function SeasonUtil.TypeAndType1ToSubdivisionType(type, type1)
  if type1 == 0 then
    return type
  end
  return type * 10000 + type1
end

function SeasonUtil.GetSeasonTypeAndVersion(includePreview, serverId)
  local config = SeasonUtil.GetSeasonInfo(serverId or LuaEntry.Player:GetSourceServerId())
  if config then
    return config:GetSeasonTypeAndVersion(includePreview == true)
  end
  return SeasonMapType.Nothing, 0
end

function SeasonUtil.IsMummyYardBuilding(theBuildId)
  local buildId = toInt(theBuildId)
  local level = buildId % 1000
  local itemId = buildId - level
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local seasonType = SeasonMapType.Nothing
  if infoPlayer ~= nil then
    seasonType = infoPlayer:GetServerSubdivisionType(false)
  end
  if seasonType == SeasonMapType.Mummy and itemId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S3 then
    return true
  end
  if seasonType == SeasonMapType.Darkness and itemId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S4 then
    return true
  end
  if seasonType == SeasonMapType.NineNationRainforest and itemId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S6 then
    return true
  end
  if seasonType == SeasonMapType.NineNation and itemId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S5 then
    return true
  end
  return false
end

function SeasonUtil.SeasonHasCityStronghold(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  return seasonType ~= SeasonMapType.Nothing and seasonType ~= SeasonMapType.Desert
end

function SeasonUtil.SeasonHasTradingStation(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  return seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation
end

function SeasonUtil.SeasonHasAltar(seasonType, serverId)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  if seasonType == SeasonMapType.NineNation then
    seasonType = SeasonUtil.GetSeasonSubdivisionType(false, serverId)
  end
  return seasonType == SeasonMapType.NineNationRainforest
end

function SeasonUtil.SeasonHasFactionWar(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerSubdivisionType(false)
    end
  end
  return seasonType == SeasonMapType.Snow or seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNationRainforest
end

function SeasonUtil.GetFactionSelectionActivityType(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  if seasonType == SeasonMapType.Snow then
    return EnumActivity.SeasonFactionSelectionActivity.Type
  elseif seasonType == SeasonMapType.Mummy then
    return EnumActivity.SeasonFactionSelectionActivityMummy.Type
  elseif seasonType == SeasonMapType.Darkness then
    return EnumActivity.SeasonFactionSelectionActivityMummy.Type
  end
  return 0
end

function SeasonUtil.GetFactionWarActivityType(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  if seasonType == SeasonMapType.Snow then
    return EnumActivity.SeasonFactionDeclareWarActivity.Type
  elseif seasonType == SeasonMapType.Mummy then
    return EnumActivity.SeasonFactionDeclareWarActivityMummy.Type
  elseif seasonType == SeasonMapType.Darkness then
    return EnumActivity.SeasonFactionDeclareWarActivityMummy.Type
  end
  return 0
end

function SeasonUtil.AttackCityStrongholdSeason()
  local seasonType = SeasonUtil.GetSeasonType()
  return seasonType == SeasonMapType.CityStronghold or seasonType == SeasonMapType.NineNation or LuaEntry.Player:AtHomeNow()
end

function SeasonUtil.SeasonHasAllianceSkill(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerSubdivisionType(false)
    end
  end
  return seasonType ~= SeasonMapType.Nothing and seasonType ~= SeasonMapType.Desert and seasonType ~= SeasonMapType.CityStronghold and seasonType ~= SeasonMapType.NineNation
end

function SeasonUtil.SeasonHasMummyYardBuild(seasonType)
  return SeasonUtil.GetMummyYardBuildingId(seasonType) ~= 0
end

function SeasonUtil.GetMummyYardBuildingId(seasonType)
  if seasonType == nil then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer ~= nil then
      seasonType = infoPlayer:GetServerType(false)
    end
  end
  if seasonType == SeasonMapType.Mummy then
    return BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S3
  end
  if seasonType == SeasonMapType.Darkness then
    return BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S4
  end
  if seasonType == SeasonMapType.NineNation then
    local subdivisionType = SeasonUtil.GetSeasonSubdivisionType()
    if subdivisionType == SeasonMapType.NineNationRainforest then
      return BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S6
    end
    return BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S5
  end
  return 0
end

function SeasonUtil.GetSeasonResistanceSelf(selfValue, targetValue, resistance_type)
  if checknumber(resistance_type) == 2 then
    local resistance_base = LuaEntry.DataConfig:TryGetNum("resistance_base", "k1", 250)
    if resistance_base == 0 then
      resistance_base = 250
    end
    local ratio = math.floor((targetValue - selfValue) / resistance_base + 0.5)
    return DataCenter.SeasonDataManager:GetDamageConfig2(ratio)
  end
  return DataCenter.SeasonDataManager:GetDamageConfig(selfValue / targetValue)
end

function SeasonUtil.GetSeasonResistanceOther(selfValue, targetValue, resistance_type)
  if checknumber(resistance_type) == 2 then
    local resistance_base = LuaEntry.DataConfig:TryGetNum("resistance_base", "k1", 250)
    if resistance_base == 0 then
      resistance_base = 250
    end
    local ratio = math.floor((targetValue - selfValue) / resistance_base + 0.5)
    return DataCenter.SeasonDataManager:GetMonsterDamageConfig2(ratio)
  end
  return DataCenter.SeasonDataManager:GetMonsterDamageConfig(selfValue / targetValue)
end

function SeasonUtil.GetSeasonResistance1Self(selfValue, targetValue)
  return DataCenter.SeasonDataManager:GetDamage1Config(selfValue / targetValue)
end

function SeasonUtil.IsResistanceType1Monster(protoData)
  local resistanceType = 0
  if protoData ~= nil and protoData.player ~= nil and #protoData.player > 1 then
    local table_name = LuaEntry.Player:GetABTestTableName(TableName.Monster)
    local player = protoData.player[2]
    if player.armyType == MailTargetType.Monster then
      local monsterId = player.contentId
      if monsterId ~= nil and 0 < monsterId then
        resistanceType = LocalController:instance():getIntValue(table_name, monsterId, "resistance_type", 0)
        if checknumber(resistanceType) == 1 then
          return true, 1
        end
      end
    elseif player.armyType == MailTargetType.Army then
      local monsterId = player.monsterId
      if monsterId ~= nil and 0 < monsterId then
        resistanceType = LocalController:instance():getIntValue(table_name, monsterId, "resistance_type", 0)
        if checknumber(resistanceType) == 1 then
          return true, 1
        end
      end
    end
  end
  return false, resistanceType
end

function SeasonUtil.IsDesertInProtect(pointId)
  local inProtect = false
  local tileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
  if tileInfo ~= nil then
    local desertInfo = tileInfo:GetWorldDesertInfo()
    if desertInfo ~= nil then
      local protectEndTime = desertInfo.protectEndTime
      local curSecond = UITimeManager:GetInstance():GetServerSeconds()
      if protectEndTime > curSecond then
        inProtect = true
      end
    end
  end
  return inProtect
end

function SeasonUtil.IsDesertOccupy(pointId)
  if not SeasonUtil.IsInSeasonDesertMode() then
    return true
  end
  local alreadyExitOccupy = false
  local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
  if worldTileInfo ~= nil then
    local desertInfo = worldTileInfo:GetWorldDesertInfo()
    if desertInfo ~= nil then
      local playerType = desertInfo:GetPlayerType()
      if playerType == CS.PlayerType.PlayerSelf or playerType == CS.PlayerType.PlayerAlliance or playerType == CS.PlayerType.PlayerAllianceLeader then
        alreadyExitOccupy = true
      end
    end
    local pointData = worldTileInfo:GetPointInfo()
    if pointData ~= nil and alreadyExitOccupy == false then
      if pointData.PointType == WorldPointType.WORLD_ALLIANCE_CITY or pointData.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointData.PointType, pointData.extraInfo, pointData)
        if allianceCityPointInfo ~= nil then
          local allianceId = allianceCityPointInfo.allianceId
          if allianceId ~= "" and allianceId == LuaEntry.Player.allianceId then
            alreadyExitOccupy = true
          elseif LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
            local cityId = allianceCityPointInfo.cityId
            local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
            if template ~= nil and template.eden_city_type == WorldAllianceCityType.Stronghold and allianceId ~= "" and DataCenter.GloryManager:IsSameCampByAllianceId(allianceId) == true then
              alreadyExitOccupy = true
            end
          end
        end
      elseif pointData.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
        local allianceBuildingPointInfo = PBController.ParsePbFromBytes(pointData.extraInfo, "protobuf.AllianceBuildingPointInfo")
        if allianceBuildingPointInfo ~= nil then
          local coverSpeed = allianceBuildingPointInfo.durabilitySpeed or 0
          local state = allianceBuildingPointInfo.state or 0
          if 0 < coverSpeed and state == AllianceMineStatus.Build then
            local curHp = allianceBuildingPointInfo.durability or 0
            local lastHpTime = allianceBuildingPointInfo.lastDurabilityTime or 0
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceBuildingPointInfo.buildId)
            if template ~= nil then
              local maxHp = template.resDurable
              if state == AllianceMineStatus.Build and curHp and maxHp and curHp ~= maxHp then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local deltaTime = curTime - lastHpTime
                local cur_hp = math.min(deltaTime / 1000 * coverSpeed + curHp, maxHp)
                if maxHp > cur_hp then
                  return false
                end
              end
            end
          end
          local allianceBuildId = allianceBuildingPointInfo.buildId
          local cityAllianceId = allianceBuildingPointInfo.allianceId
          local allianceId = LuaEntry.Player.allianceId
          if (WorldAllianceBuildUtil.IsAllianceCenterFlag(allianceBuildId) or WorldAllianceBuildUtil.IsAllianceCenterGroup(allianceBuildId) or WorldAllianceBuildUtil.IsAllianceFrontGroup(allianceBuildId)) and allianceId ~= nil and allianceId ~= "" and cityAllianceId == allianceId then
            alreadyExitOccupy = true
          end
        end
      elseif pointData.PointType == WorldPointType.PlayerBuilding then
        cast(pointData, typeof(CS.BuildPointInfo))
        if pointData ~= nil then
          local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(pointData.itemId)
          if template ~= nil and template.tab_type == UIBuildListTabType.SeasonBuild then
            local state = pointData:GetPlayerType()
            if state == CS.PlayerType.PlayerSelf or state == CS.PlayerType.PlayerAlliance or state == CS.PlayerType.PlayerAllianceLeader then
              alreadyExitOccupy = true
            end
          end
        end
      end
    end
  end
  return alreadyExitOccupy
end

function SeasonUtil.GetBloodyNightResistanceValueAdd()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704030)
    if stateMeta and stateMeta.effect_num then
      local effect_num = tonumber(stateMeta.effect_num)
      if effect_num then
        return effect_num
      end
    end
  end
  return 0
end

function SeasonUtil.GetSelfSeasonResistanceValue()
  local value = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_SEASON_DESERT_RESISTANCE)
  return math.max(0, toInt(value))
end

function SeasonUtil.GetResistanceByPoint(pointIndex)
  local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointIndex)
  if worldTileInfo ~= nil then
    local desertInfo = worldTileInfo:GetWorldDesertInfo()
    if desertInfo ~= nil then
      local allianceId = desertInfo.allianceId
      if allianceId ~= "" and allianceId == LuaEntry.Player.allianceId then
        return 0
      end
      if desertInfo.ownerUid == LuaEntry.Player:GetUid() then
        return 0
      end
      local config = LocalController:instance():getLine(TableName.Desert, desertInfo.desertId)
      if config then
        return toInt(config.desert_buff or 0)
      end
    end
  end
  return 0
end

function SeasonUtil.GetResistanceByUuid(pointUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(pointUuid)
  if info ~= nil then
    if info == nil then
      return 0
    end
    if info.PointType == WorldPointType.WORLD_ALLIANCE_CITY or info.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if extraInfo then
        local cityId = extraInfo.cityId
        local serverId = info.serverId
        local data = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
        if data then
          return toInt(data.city_resistance_b)
        end
      end
    end
  end
  return 0
end

function SeasonUtil.IsSeasonPlayerBuilding(buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(toInt(buildId))
  if buildTemplate ~= nil and buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
    return true
  end
  return false
end

function SeasonUtil.IsSeasonPlayerBuildingInt(buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil and buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
    return true
  end
  return false
end

function SeasonUtil.CanBuildPlayerBuilding(buildId)
  if not LuaEntry.Player:AtHomeNow() then
    return false
  end
  local nBuildId = toInt(buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(nBuildId)
  if buildTemplate == nil or buildTemplate.tab_type ~= UIBuildListTabType.SeasonBuild then
    return false
  end
  local effectCondition = buildTemplate.effectCondition
  if effectCondition and effectCondition.effectId then
    local effectId = effectCondition.effectId
    local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
    if effectValue == nil or effectValue == 0 then
      return false
    end
  end
  local allianceCenterId = tonumber(buildTemplate.para1)
  local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
  if allianceCenterData ~= nil then
    if allianceCenterData.status == AllianceMineStatus.Build then
      return false
    end
    local buildDic = DataCenter.DesertDataManager:GetSeasonBuildList()
    for k, v in pairs(buildDic) do
      if v.itemId == nBuildId and v.posV2 and v.pointId then
        return false
      end
    end
    return true
  end
  return false
end

function SeasonUtil.CanBuildPlayerBuildingCount(allianceCenterBaseId)
  if not LuaEntry.Player:AtHomeNow() then
    return 0
  end
  local buildingCount = 0
  local allBuildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  local seasonBuildIds = allBuildIds[UIBuildListTabType.SeasonBuild]
  if seasonBuildIds then
    for k, v in pairs(seasonBuildIds) do
      if v.buildTemplate and (allianceCenterBaseId == nil or v.buildTemplate.allianceCenterBaseId == allianceCenterBaseId) and SeasonUtil.CanBuildPlayerBuilding(v.buildTemplate.id) then
        buildingCount = buildingCount + 1
      end
    end
  end
  return buildingCount
end

function SeasonUtil.CurInNinePalacesMode()
  local theTypeServer = SeasonUtil.GetSeasonType()
  return theTypeServer == SeasonMapType.NineNation
end

function SeasonUtil.OnClickWorldTile(curIndex, clickType, info, needCloseUI)
  local needCloseWorldPointUI = true
  local world = CS.SceneManager.World
  if world then
    local worldPos = world.curTouchPoint
    if SeasonUtil.CurServerTypeInSeason() == SeasonMapType.NineNation then
      local curServerId = LuaEntry.Player:GetCurServerId()
      local isSingleServerMode = SeasonUtil.IsSeasonInSingleServerMode(curServerId)
      local config = SeasonUtil.GetSeasonInfo(curServerId)
      if isSingleServerMode then
        local serverId = config:GetServerIdFromWorldPos(worldPos)
        if serverId ~= 0 and serverId ~= curServerId then
          UIUtil.ShowTipsId("s5_map_tips_2")
          return needCloseWorldPointUI
        end
      end
      if 0 > worldPos.x or worldPos.x >= 6000 or 0 > worldPos.z or 6000 <= worldPos.z then
        return needCloseWorldPointUI
      end
    elseif 0 > worldPos.x or worldPos.x >= 2000 or 0 > worldPos.z or worldPos.z >= 2000 then
      return needCloseWorldPointUI
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBlackTile, {anim = true}, curIndex)
  return needCloseWorldPointUI
end

function SeasonUtil.GetDesertIfoByPointId(pointId)
  local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
  if worldTileInfo ~= nil then
    return worldTileInfo:GetWorldDesertInfo()
  end
end

function SeasonUtil.OnClickWorldPlayerBuilding(curIndex, clickType, info, needCloseUI)
  local needChangeCamera = UIUtil.CheckNeedQuitFocus()
  local allianceId = LuaEntry.Player.allianceId
  if info.ownerUid == LuaEntry.Player.uid then
    DataCenter.BuildManager:CheckSendBuildFinish(info.uuid, false, info)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(info.mainIndex))
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, tostring(info.mainIndex), needChangeCamera)
    end
    needCloseUI[UIWindowNames.UIWorldTileUI] = nil
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
    end
  else
    local isAlliance = 1
    if not string.IsNullOrEmpty(allianceId) and info.allianceId == allianceId then
      isAlliance = 1
    else
      isAlliance = 0
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Build .. ";" .. isAlliance .. ";" .. info.itemId
      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Build, isAlliance, info.itemId)
    end
    needCloseUI[UIWindowNames.UIWorldPoint] = nil
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
end

function SeasonUtil.AttackDesert(theParam, pointId, thePointUuid, desert_level)
  if theParam then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isProtect = theParam.protectEndTime and curTime < theParam.protectEndTime
    if isProtect then
      UIUtil.ShowTipsId("season_tiles_popui_info003")
      return
    end
  end
  local inProtect = SeasonUtil.IsDesertInProtect(pointId)
  if inProtect == true then
    UIUtil.ShowTipsId(110242)
  elseif desert_level == 0 then
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_EMPTY_DESERT, pointId, thePointUuid, -1, 1)
  else
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_DESERT, pointId, thePointUuid, -1, 1)
  end
end

function SeasonUtil.CheckDesertConnect(mainIndex, tileSize, showTips, isAttackDesert, action)
  if showTips then
    local inProtect = SeasonUtil.IsDesertInProtect(mainIndex)
    if inProtect == true then
      if showTips then
        UIUtil.ShowTipsId(110242)
      end
      return false
    end
  end
  local alreadyExitOccupy = false
  local vecPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
  local rangeList = BuildingUtils.GetBuildRoundPos(vecPos, tileSize, tileSize)
  for i = 1, #rangeList do
    if alreadyExitOccupy == false then
      alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(rangeList[i], ForceChangeScene.World))
      if alreadyExitOccupy then
        break
      end
    end
  end
  if showTips and not alreadyExitOccupy then
    if 3 < tileSize then
      UIUtil.ShowTipsId("season_city_battle_tips001")
    elseif isAttackDesert then
      SeasonUtil.TryShowDesertTip(action)
    else
      UIUtil.ShowTipsId("season_tips100")
    end
    WorldDesertSelectEffectManager:GetInstance():ShowWarnPos(mainIndex, tileSize, 0)
  end
  if isAttackDesert and alreadyExitOccupy and action and type(action) == "function" then
    pcall(action)
  end
  return alreadyExitOccupy
end

function SeasonUtil.CanMoveByActivity(activityType)
  if activityType ~= 0 then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(activityType)
    if actList and 0 < #actList then
      return true
    end
  end
  return false
end

function SeasonUtil.CanMoveCityTo(serverId)
  if LuaEntry.Player:GetSelfServerId() == serverId then
    return true
  end
  if LuaEntry.Player:GetSourceServerId() == serverId then
    return true
  end
  local CanMove = false
  if DataCenter.SeasonDataManager:IsInBattleServerGroup(serverId) then
    local theSeasonType = SeasonUtil.GetSeasonType()
    CanMove = CanMove or SeasonUtil.CanMoveByActivity(EnumActivity.TradeStation.Type) or SeasonUtil.CanMoveByActivity(SeasonUtil.GetFactionWarActivityType(theSeasonType)) or SeasonUtil.CanMoveByActivity(SeasonUtil.GetFactionSelectionActivityType(theSeasonType))
    if not CanMove and DataCenter.SeasonDataManager:CanCrossDeclareWar() then
      CanMove = true
    elseif theSeasonType == SeasonMapType.Desert or theSeasonType == SeasonMapType.CityStronghold then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonCrossAttackCityActivity.Type)
      if actList and 0 < #actList then
        local actData = actList[1]
        if actData then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local para4 = actData.para4
          local startTime = actData.startTime
          local endTime = actData.endTime
          local fightStartTime = startTime + toInt(para4) * OneHourTime * 1000
          local fightEndTime = endTime
          if curTime > fightStartTime and curTime < fightEndTime then
            CanMove = true
          end
        end
      end
      if not CanMove then
        local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
        if data then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if data.isDeclareWarDay and (data.curActBeginTime == nil or curTime >= toInt(data.curActBeginTime)) then
            CanMove = true
          end
        end
      end
    end
  end
  return CanMove
end

function SeasonUtil.ShareDesert(serverId, uuid, desertId, oriDesertId, pointId)
  if uuid == nil or uuid == 0 or desertId == nil or desertId == 0 then
    return
  end
  local ShareDesertMax = LuaEntry.DataConfig:TryGetNum("lw_season_desert", "k9", 20)
  local ShareDesertCount = UIUtil.GetTodayActiveCount("UserShareDesertCount", false)
  if ShareDesertMax <= ShareDesertCount then
    UIUtil.ShowTipsId("season_tips183")
    return
  end
  local configLine = LocalController:instance():getLine(TableName.Desert, toInt(desertId))
  if configLine then
    local desert_level = toInt(configLine.desert_level)
    local desert_name = configLine.desert_name
    local canShare = toInt(configLine.is_gift) == 1
    if canShare and desert_name and 0 < desert_level then
      local name = Localization:GetString(desert_name)
      local msgTitle = Localization:GetString("season_ui_desc036")
      local msg1 = Localization:GetString("season_ui_desc037")
      local msg2 = Localization:GetString("season_ui_desc038", desert_level, name)
      local msg = string.format([[
%s

%s]], msg1, msg2)
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.UserShareDesert, msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        local share_param = {}
        share_param.sid = serverId
        share_param.worldId = 0
        share_param.desertUuid = uuid
        share_param.desertId = desertId
        share_param.oriDesertId = oriDesertId
        share_param.postType = PostType.SeasonDesert
        share_param.pointId = pointId
        local chatData = {}
        chatData.roomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
        chatData.post = PostType.SeasonDesert
        chatData.param = share_param
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
        UIUtil.GetTodayActiveCount("UserShareDesertCount", true)
      end, function()
      end, nil, msgTitle, false, nil, nil)
    end
  end
end

function SeasonUtil.TryShowDesertTip(callback)
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.UserDesertLinkTip) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonDesertTip, {anim = true}, callback)
  elseif callback and type(callback) == "function" then
    pcall(callback)
  end
end

function SeasonUtil.GetSeasonShopResCount()
  return DataCenter.ItemData:GetItemCount(640025)
end

function SeasonUtil.CanShowSeasonShop()
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  return 0 < toInt(season)
end

function SeasonUtil.GetWorldCityTableName()
  return DataCenter.SeasonDataManager:GetWorldCityTableName()
end

function SeasonUtil.GetWorldCityTableNameByServerId(_serverId)
  local serverId = toInt(_serverId)
  if serverId <= 0 then
    return "lw_worldcity"
  end
  local tblName = WorldCityTableName[serverId]
  if tblName ~= nil then
    return tblName
  end
  local data = SeasonUtil.GetSeasonInfo(serverId)
  if data then
    tblName = data:GetWorldCityTableName()
    if tblName ~= nil then
      WorldCityTableName[serverId] = tblName
      return tblName
    end
  end
  local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(serverId)
  local table_name
  if config and config.city then
    table_name = config.city
  else
    table_name = Setting:GetPrivateString("MapTableName" .. serverId, "lw_worldcity")
  end
  return table_name
end

function SeasonUtil.GetWorldCityTableNameBySeasonConfigId(configId)
  local data = DataCenter.SeasonTemplateManager:GetConfigData(configId)
  if data and not string.IsNullOrEmpty(data.city) then
    return data.city
  end
  return "lw_worldcity"
end

function SeasonUtil.GetCanonModelName(cityId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  return cityMeta and cityMeta.model or ""
end

function SeasonUtil.GetCanonNameModel(cityId, cityUuid, template)
  local ObjNode
  if cityUuid then
    ObjNode = CS.SceneManager.World:GetObjectByUuid(cityUuid)
    if ObjNode ~= nil then
      local go = ObjNode:GetGameObject()
      if go ~= nil then
        return go.transform:Find("Model/CityLabel/NameLabel/NameText")
      end
      return nil
    end
  end
  local cityMeta = template or DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  if cityMeta then
    ObjNode = CS.SceneManager.World:GetObjectByPoint(cityMeta:GetPointId())
    if ObjNode then
      local go = ObjNode:GetGameObject()
      if go ~= nil then
        return go.transform:Find("Model/CityLabel/NameLabel/NameText")
      end
    end
  end
  return nil
end

function SeasonUtil.GetCanonAnimModel(cityId, cityUuid, template)
  local ObjNode
  if cityUuid then
    ObjNode = CS.SceneManager.World:GetObjectByUuid(cityUuid)
    if ObjNode ~= nil then
      local go = ObjNode:GetGameObject()
      if go ~= nil then
        return go.transform:Find("Model/AnimRoot/A_build_wangzuozhandapao_skin")
      end
      return nil
    end
  end
  local cityMeta = template or DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  if cityMeta then
    ObjNode = CS.SceneManager.World:GetObjectByPoint(cityMeta:GetPointId())
    if ObjNode then
      local go = ObjNode:GetGameObject()
      if go ~= nil then
        return go.transform:Find("Model/AnimRoot/A_build_wangzuozhandapao_skin")
      end
    end
  end
  return nil
end

function SeasonUtil.GetPresidentOccupationRate(key, defValue)
  if SeasonUtil.GetSeason() ~= 0 then
    return LuaEntry.DataConfig:TryGetNum("season_president_occupation_rate", key, defValue) or defValue
  end
  return LuaEntry.DataConfig:TryGetNum("president_occupation_rate", key, defValue) or defValue
end

function SeasonUtil.GetMummyConfig(key, defValue, asNum)
  local seasonType = SeasonUtil.GetSeasonType()
  local config_name = "s3_mummy_config"
  if seasonType == SeasonMapType.Darkness then
    config_name = "s4_mummy_config"
  elseif seasonType == SeasonMapType.Mummy then
    config_name = "s3_mummy_config"
  elseif seasonType == SeasonMapType.NineNation then
    local subdivisionType = SeasonUtil.GetSeasonSubdivisionType()
    if subdivisionType == SeasonMapType.NineNationRainforest then
      config_name = "s6_mummy_config"
    else
      config_name = "s5_mummy_config"
    end
  else
    return defValue
  end
  if asNum then
    return LuaEntry.DataConfig:TryGetNum(config_name, key, defValue)
  end
  return LuaEntry.DataConfig:TryGetStr(config_name, key, defValue)
end

function SeasonUtil.GetMummyConfigNum(key, defValue)
  return SeasonUtil.GetMummyConfig(key, defValue, true)
end

function SeasonUtil.GetMummyConfigStr(key, defValue)
  return SeasonUtil.GetMummyConfig(key, defValue, false)
end

function SeasonUtil.TryParseAllianceCityPointInfo(pointType, extraInfo, pointInfo)
  local cityInfo
  if not extraInfo then
    return
  end
  if pointType == WorldPointType.WORLD_ALLIANCE_CITY then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.AllianceCityPointInfo")
  elseif pointType == WorldPointType.WORLD_CITY_STRONGHOLD then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.CityStrongholdPointInfo")
    if cityInfo ~= nil and cityInfo.strongholdId ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.strongholdId
      cityInfo.openTime = 0
      cityInfo.durability = 0
      cityInfo.lastDurabilityTime = 0
    end
    local bankRobInfo = cityInfo and cityInfo.bankRobInfo
    if not table.IsNullOrEmpty(bankRobInfo) and not IsNull(pointInfo) then
      local info = not IsNull(pointInfo.StrongholdInfo) and pointInfo.StrongholdInfo.BankRobInfo or nil
      if not IsNull(info) then
        bankRobInfo.totalAmount = info.TotalAmount or 0
        bankRobInfo.robAmount = info.RobAmount or 0
        bankRobInfo.robEndTime = info.RobEndTime or 0
        bankRobInfo.robStage = info.RobStage or 0
      end
    end
  elseif pointType == WorldPointType.WORLD_CITY_TRADE then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.CityTradePointInfo")
    if cityInfo ~= nil and cityInfo.tradeId ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.tradeId
      cityInfo.durability = 0
      cityInfo.lastDurabilityTime = 0
      if cityInfo.giveUpTime and 0 < cityInfo.giveUpTime then
        cityInfo.giveUpTime = cityInfo.giveUpTime * 0.001
      end
    end
  elseif pointType == WorldPointType.CITY_ALTAR then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.CityAltarPointInfo")
    if cityInfo ~= nil and cityInfo.cfgid ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.cfgid
    end
  elseif pointType == WorldPointType.GOLD_TREE then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.GoldTreePointInfo")
    if cityInfo ~= nil and cityInfo.treeId ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.treeId
      cityInfo.durability = 0
      cityInfo.lastDurabilityTime = 0
    end
  elseif pointType == WorldPointType.WORLD_CITY_OUTPOST then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.OutpostInfo")
    if cityInfo ~= nil and cityInfo.treeId ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.treeId
      cityInfo.durability = 0
      cityInfo.lastDurabilityTime = 0
    end
  elseif pointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
    cityInfo = PBController.ParsePbFromBytes(extraInfo, "protobuf.OutpostTowerInfo")
    if cityInfo ~= nil and cityInfo.treeId ~= nil and cityInfo.cityId == nil then
      cityInfo.cityId = cityInfo.treeId
      cityInfo.durability = 0
      cityInfo.lastDurabilityTime = 0
    end
  elseif pointType == WorldPointType.ZWL_BUILDING or pointType == WorldPointType.ZWL_BUILDING_BUFF or pointType == WorldPointType.ZWL_BUILDING_THRONE or pointType == WorldPointType.ZWL_BUILDING_TOWER then
    cityInfo = pointInfo
  end
  return cityInfo
end

function SeasonUtil.TryShowConfirmWhenAttackBoss(action, marchType, special)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local infoServer = SeasonUtil.GetSeasonInfo(curServerId)
  local showIt = marchType == NewMarchType.RUNNING_BOSS or special == WorldMonsterSpecialType.RunningMonster
  if showIt and infoServer ~= nil and not infoServer:ServerInReady() then
    local seasonStartTime = tonumber(infoServer.nextSeasonStartTime or infoServer.seasonStartTime)
    if seasonStartTime ~= nil then
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local nowZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(seasonStartTime * 0.001)
      local theZeroTime = math.floor(nowZeroTime * 1000 + 0.5)
      if serverTime > theZeroTime and serverTime < theZeroTime + OneDayTime * 1000 then
        UIUtil.TryShowConfirm(TodayNoSecondConfirmType.AttackWorldBossBeforeSeasonStart, Localization:GetString("season5_tips100"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          pcall(action)
        end, function()
        end, nil, nil, false, nil, nil)
        return
      end
    end
  end
  pcall(action)
end

function SeasonUtil.CanAttackCityStronghold(cityId)
  local serverId = LuaEntry.Player:GetCurServerId()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if cityTemplate ~= nil then
    if not cityTemplate:IsCityStronghold() then
      return true
    end
    local cityMgr = DataCenter.WorldAllianceCityDataManager
    local myAlId = LuaEntry.Player.allianceId
    if myAlId == nil or myAlId == "" then
      return false
    end
    local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityData(myAlId, cityId)
    if myAlCityInfo ~= nil then
      return true
    end
    if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(myAlId, cityId) then
      return true
    end
    local allianceFlagList = {}
    if LuaEntry.Player:AtHomeNow() then
      local myCitiesCount = cityMgr:GetCitiesCountByAlId(myAlId, true)
      local myStrongholdCount = cityMgr:GetStrongholdCountByAlId(myAlId, true)
      if myCitiesCount == 0 and myStrongholdCount == 0 then
        return cityTemplate.level == 1 and cityTemplate.type == WorldAllianceCityType.Stronghold or cityTemplate.type == WorldAllianceCityType.MissileFactory or cityTemplate.type == WorldAllianceCityType.Canon or cityTemplate.type == WorldAllianceCityType.King
      end
    else
      local allianceFlagDic = DataCenter.AllianceMineManager:GetAllianceFlagData()
      if allianceFlagDic then
        for i, v in pairs(allianceFlagDic) do
          if v and v.curServerId == serverId and v.GetZoneId then
            allianceFlagList[toInt(v:GetZoneId())] = true
          end
        end
      end
    end
    if allianceFlagList[toInt(cityId)] then
      return true
    end
    if type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
      for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
        myAlCityInfo = cityMgr:GetMyAlCityInfo(neighbourCityId)
        if myAlCityInfo ~= nil or allianceFlagList[toInt(neighbourCityId)] then
          return true
        end
      end
    end
  end
  return false
end

function SeasonUtil.GetSeasonShowIconPath(activityData)
  if activityData.type == EnumActivity.BloodyNight.Type then
    local template = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
    if template and not string.IsNullOrEmpty(template.stage_banner) then
      return template.stage_banner
    end
  end
  if activityData.type == EnumActivity.SeasonMilitary.Type then
    local myCampId = Mathf.Clamp(checknumber(DataCenter.SeasonFactionWarDataManager.myCampId), 1, 2)
    local skinCell = LocalController:instance():tryGetLine(TableName.SeasonCampSkin, 6)
    local column = string.format("resource_camp0%s", myCampId)
    if skinCell ~= nil and not string.IsNullOrEmpty(column) then
      return skinCell[column]
    end
  end
  if not string.IsNullOrEmpty(activityData.season_show_icon_full) then
    return activityData.season_show_icon_full
  end
  if not string.IsNullOrEmpty(activityData.season_show_icon) then
    return "Assets/Main/TextureEx/Season/Activity/" .. activityData.season_show_icon .. ".png"
  end
end

function SeasonUtil.GetNewIconPathInBloodyNight(imgPath)
  if imgPath and DataCenter.BloodyNightDataManager:IsBloodyNight() then
    if string.endswith(imgPath, "_banner.png") then
      local darkIconPath = imgPath:gsub("_banner.png", "_xueye_banner.png")
      if CS.GameEntry.Resource:HasAsset(darkIconPath) then
        imgPath = darkIconPath
      end
    else
      local darkIconPath = imgPath:gsub(".png", "_xueye.png")
      if CS.GameEntry.Resource:HasAsset(darkIconPath) then
        imgPath = darkIconPath
      end
    end
  end
  return imgPath
end

function SeasonUtil.GetNewPrefabPathInBloodyNight(prefabPath)
  if prefabPath and DataCenter.BloodyNightDataManager:IsBloodyNight() then
    local darkPrefabPath = prefabPath:gsub(".prefab", "_xueye.prefab")
    if CS.GameEntry.Resource:HasAsset(darkPrefabPath) then
      prefabPath = darkPrefabPath
    end
  end
  return prefabPath
end

function SeasonUtil.IsOpenSeasonBuildInCity()
  local mgr = DataCenter.SeasonDataManager
  local info = mgr:GetUserSeasonInfo()
  if info and info:ServerInReady() and mgr:InNormalMode() and SeasonUtil.GetSeasonType() ~= SeasonMapType.Desert and DataCenter.BuildManager.MainLv >= 10 then
    return true
  end
  return false
end

function SeasonUtil.IsOpenAttackMonsterByLevel(type, specialType)
  if type == 1 or type == 2 or type == 3 or type == 5 or 14 <= type and type <= 21 then
    if specialType == 0 and SeasonUtil.IsInSeason() then
      return true
    end
  else
    return false
  end
end

function SeasonUtil.SynthesisRemainRedPoint(data)
  if data == nil then
    return false
  end
  local remainTimes = SeasonUtil.SynthesisRemainCount(data)
  if toInt(remainTimes) > 0 and data.para_3 ~= nil and data.para_3 ~= "" then
    local itemList = string.split(data.para_3, "|")
    for k, itemId in pairs(itemList) do
      if itemId ~= nil and itemId ~= "" then
        local itemData = DataCenter.ItemData:GetItemById(itemId)
        if itemData == nil or itemData.count == nil or itemData.count == 0 then
          return false
        end
      end
    end
    return true
  end
  return false
end

function SeasonUtil.SynthesisRemainCount(data)
  local recoverInterval = tonumber(data.para) * 3600
  local maxCount = tonumber(data.para_1)
  local remainTimes = 0
  local extraData = DataCenter.ActivityListDataManager:GetExtraData(SEASON_ACTIVITY_SYNTHESIS)
  local remainRecover = 0
  if extraData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local recoverTimes = math.floor((math.modf(curTime) - extraData.refreshTime) / 1000 / recoverInterval)
    remainRecover = math.floor((math.modf(curTime) - extraData.refreshTime) / 1000 % recoverInterval)
    remainTimes = extraData.num + recoverTimes
    if maxCount < remainTimes then
      remainTimes = maxCount
    end
  end
  return remainTimes, maxCount, recoverInterval, remainRecover
end

function SeasonUtil.GetSeasonAchievementsGroup()
  if DataCenter.SeasonDataManager:InNormalMode() then
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config and not string.IsNullOrEmpty(config.season_achievements) then
      return toInt(config.season_achievements)
    end
  end
  return 0
end

function SeasonUtil.IsSeasonAchievmentNew()
  local group = SeasonUtil.GetSeasonAchievementsGroup()
  return group ~= 0
end

function SeasonUtil.GetTemperatureColor(theTemperature)
  local num = tonumber(theTemperature) or 0
  if 50 <= num then
    return Color.FromHex("ff6060")
  end
  if 44 <= num then
    return Color.FromHex("fd7442")
  end
  if 39 <= num then
    return Color.FromHex("fb9438")
  end
  if 34 <= num then
    return Color.FromHex("f3cb38")
  end
  if 29 <= num then
    return Color.FromHex("fadd71")
  end
  if 24 <= num then
    return Color.FromHex("c5db5d")
  end
  if 19 <= num then
    return Color.FromHex("76db5d")
  end
  if 14 <= num then
    return Color.FromHex("5bdd98")
  end
  if 9 <= num then
    return Color.FromHex("61e9db")
  end
  if 4 <= num then
    return Color.FromHex("4fe8ea")
  end
  if -1 <= num then
    return Color.FromHex("4be2f8")
  end
  if -6 <= num then
    return Color.FromHex("4bd0f8")
  end
  if -11 <= num then
    return Color.FromHex("4bc1fe")
  end
  if -16 <= num then
    return Color.FromHex("5cb4ff")
  end
  if -21 <= num then
    return Color.FromHex("71aaff")
  end
  if -26 <= num then
    return Color.FromHex("7797ff")
  end
  if -31 <= num then
    return Color.FromHex("8798ff")
  end
  if -37 <= num then
    return Color.FromHex("9191ff")
  end
  return Color.FromHex("9191ff")
end

function SeasonUtil.SesaonRankOfPersaon(theType)
  return theType == SeasonRankType.PersonalPower or theType == SeasonRankType.PersonalCrossServerPower
end

function SeasonUtil.SesaonRankOfAlliance(theType)
  return theType == SeasonRankType.AlliancePower or theType == SeasonRankType.AllianceCrossServerPower or theType == SeasonRankType.AllianceRareLand or theType == SeasonRankType.AllianceCamp1RareLand or theType == SeasonRankType.AllianceCamp2RareLand or theType == SeasonRankType.ServerFamer or theType == SeasonRankType.AllianceCamp1Power or theType == SeasonRankType.AllianceCamp2Power
end

function SeasonUtil.SesaonRankOfServer(theType)
  return theType == SeasonRankType.ServerPower or theType == SeasonRankType.ServerRareLand
end

function SeasonUtil.SesaonRankOfCamp(theType)
  return theType == SeasonRankType.CampRareLand or theType == SeasonRankType.CampPower
end

function SeasonUtil.SesaonRankTabName(theType)
  if SeasonUtil.SesaonRankOfPersaon(theType) then
    return "393080"
  elseif SeasonUtil.SesaonRankOfAlliance(theType) then
    return "393081"
  elseif SeasonUtil.SesaonRankOfServer(theType) then
    return "800941"
  elseif SeasonUtil.SesaonRankOfCamp(theType) then
    return "season_s2_rank_reward_1"
  end
  return "error"
end

function SeasonUtil.SesaonRankGroup(theType)
  if SeasonUtil.SesaonRankOfPersaon(theType) then
    return SeasonRankGroup.Personal
  elseif SeasonUtil.SesaonRankOfAlliance(theType) then
    return SeasonRankGroup.Alliance
  elseif SeasonUtil.SesaonRankOfServer(theType) then
    return SeasonRankGroup.Server
  elseif SeasonUtil.SesaonRankOfCamp(theType) then
    return SeasonRankGroup.Camp
  end
  return SeasonRankGroup.Personal
end

function SeasonUtil.CheckSeasonResourceByServerId(serverId)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if serverId ~= loginServerId then
    SFSNetwork.SendMessage(MsgDefines.GetSpecialServerSeasonInfo, serverId)
  end
  if CS.UnityEngine.Application.isEditor or serverId == loginServerId then
    return true
  end
  local configId = 0
  local thePackageId = 0
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  if seasonInfo == nil then
    local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(serverId)
    if config then
      configId = toInt(config.configId)
      thePackageId = toInt(config.packConfig)
    end
  else
    thePackageId = seasonInfo:GetPackageId(false)
  end
  if thePackageId == 0 then
    if CS.CommonUtils.IsDebug() and not CS.UnityEngine.Application.isEditor then
      local activePackageId = CS.DownloadManifestManager.Instance:GetCurrentDownloadConfigId()
      if 0 < activePackageId then
        Logger.LogInfo(string.format("CheckSeasonResourceByServerId %s %s ShowMessage", serverId, activePackageId))
        UIUtil.ShowMessage(Localization:GetString("seaon_unpack_resource_tip1"), 1, GameDialogDefine.CONFIRM)
        return false
      end
    end
    return true
  end
  if SeasonUtil.IsSeasonResDownloaded(thePackageId) then
    return true
  end
  local activePackageId = CS.DownloadManifestManager.Instance:GetCurrentDownloadConfigId()
  if 0 < activePackageId then
    Logger.LogInfo(string.format("CheckSeasonResourceByServerId %s %s %s ShowMessage", serverId, activePackageId, configId))
    if thePackageId == activePackageId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonResourceDownload, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, thePackageId, serverId, true)
    else
      UIUtil.ShowMessage(Localization:GetString("seaon_unpack_resource_tip1"), 1, GameDialogDefine.CONFIRM)
    end
  else
    Logger.LogInfo(string.format("CheckSeasonResourceByServerId %s %s %s OpenWindow", serverId, thePackageId, configId))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonResourceDownload, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, thePackageId, serverId, true)
  end
  return false
end

function SeasonUtil.UnpackLog(msg)
end

function SeasonUtil.CheckSeasonResource()
  if CS.UnityEngine.Application.isEditor then
    return true
  end
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if severInfo then
    local nextSeasonConfigId = severInfo.nextSeasonConfigId
    if nextSeasonConfigId ~= nil and severInfo:InPreviewMode() then
      local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, nextSeasonConfigId)
      if seasonConfig then
        local packageId = toInt(seasonConfig.package)
        if 0 < packageId and not SeasonUtil.IsSeasonResDownloaded(packageId) then
          Logger.LogInfo("CheckSeasonResource InPreviewMode NotDownload configId = " .. tostring(packageId))
          return false
        end
      end
    end
  end
  return true
end

function SeasonUtil.GetSeasonResourcePackName(includeNotReward)
  if CS.UnityEngine.Application.isEditor then
    return nil, false
  end
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if severInfo then
    local nextSeasonConfigId = severInfo.nextSeasonConfigId
    if nextSeasonConfigId ~= nil and severInfo:InPreviewMode() then
      local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, nextSeasonConfigId)
      if seasonConfig then
        local packageId = toInt(seasonConfig.package)
        if 0 < packageId then
          if not LuaEntry.Player:CheckUnpackResourceReward(packageId) then
            Logger.LogInfo("CheckSeasonResource NotReward configId = " .. tostring(packageId))
            return packageId, true
          end
          if not SeasonUtil.IsSeasonResDownloaded(packageId) then
            Logger.LogInfo("CheckSeasonResource NotDownload configId = " .. tostring(packageId))
            return packageId, true
          end
        end
      end
    end
  end
  if includeNotReward then
    local activePackageId = CS.DownloadManifestManager.Instance:GetCurrentDownloadConfigId()
    if 0 < activePackageId then
      Logger.LogInfo("CheckSeasonResource CurrentDownloadConfigId = " .. tostring(activePackageId))
      return activePackageId, false
    end
    local packageId = DataCenter.SeasonResourceDownloadManager:GetNotRewardPackageId(true)
    if packageId then
      local str = tostring(packageId)
      local key = "SeasonResDownloadId" .. str
      local value = UIUtil.GetTodayActiveCount(key, false)
      local isDownToday = value ~= nil and 1 <= value
      Logger.LogInfo("CheckSeasonResource NotRewardPackageId = " .. str .. " , isDownToday = " .. tostring(isDownToday) .. " , " .. key .. " = " .. value)
      if isDownToday then
        return packageId, false
      else
        SFSNetwork.SendMessage(MsgDefines.LwSeasonResRqReward, packageId)
        LuaEntry.Player:AddUnpackResourceReward(packageId)
      end
    end
  end
  return nil, false
end

function SeasonUtil.CheckSeasonResourceBtnShowState()
  if CS.UnityEngine.Application.isEditor then
    return nil
  end
  return SeasonUtil.GetSeasonResourcePackName(true)
end

function SeasonUtil.IsSeasonActivityOpen(activityId, seasonType_, includePrepare_, includeTruce_)
  if string.IsNullOrEmpty(activityId) then
    return false
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not activityData then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if activityData.endTime and now >= activityData.endTime then
    return false
  end
  if activityData.startTime and now < activityData.startTime then
    return false
  end
  if includePrepare_ and SeasonUtil.IsInSeasonPrepareMode() then
    return true
  end
  if seasonType_ and SeasonUtil.GetSeasonType() ~= seasonType_ then
    return false
  end
  if includeTruce_ and SeasonUtil.IsInSeasonTruceMode() then
    return true
  end
  return SeasonUtil.IsInSeason()
end

function SeasonUtil.SendFarmerAchievementData()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  if isFarmer then
    local AchievementsGroupData = DataCenter.SeasonRewardDataManager:GetAchievementsGroupData()
    local config = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    local achievementGroup = toInt(config.season_achievements)
    local achieveData = AchievementsGroupData[achievementGroup]
    if achieveData then
      for key, value in pairs(achieveData) do
        local id = toInt(value.id)
        if (not DataCenter.SeasonRewardDataManager.personalRewardData or not DataCenter.SeasonRewardDataManager.personalRewardData[id]) and (value.flag == SeasonAchivementFlag.Personal or value.flag == SeasonAchivementFlag.Alliance and LuaEntry.Player:IsInAlliance()) then
          SFSNetwork.SendMessage(MsgDefines.UserSesaonAchievementV2Info, id)
        end
      end
    end
  end
end

local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function SeasonUtil.CheckSeasonFarmerAchievement()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  local farmerAchievement = false
  if isFarmer then
    local config = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    local achievementGroup = toInt(config.season_achievements)
    farmerAchievement = SeasonRedPointUtils.SeasonAchievementEnterRed(achievementGroup)
  end
  return farmerAchievement
end

function SeasonUtil.CanJoinWar(fixedSoldierType, showTip)
  local seasonType = SeasonUtil.GetSeasonType()
  if SeasonUtil.SeasonHasMummyYardBuild(seasonType) then
    local targetNeedUseMummy = false
    if fixedSoldierType == SoldierType.Mummy then
      local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
      if mummyCount == 0 then
        if showTip then
          UIUtil.ShowTipsId("season_s3_Mummy_tips010")
        end
        return false
      end
      targetNeedUseMummy = true
    end
    local formationList = DataCenter.ArmyFormationDataManager:GetCurFormationList()
    if formationList then
      local hasFormationCanJoin = false
      local Player = LuaEntry.Player
      for formationUuid, formationData in pairs(formationList) do
        if formationData ~= nil then
          local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formationData.uuid, Player.allianceId)
          if march == nil or not march.isMummyMarch and not targetNeedUseMummy and march:GetMarchTargetType() == MarchTargetType.BACK_HOME then
            hasFormationCanJoin = true
          end
        end
      end
      if not hasFormationCanJoin then
        if showTip then
          if targetNeedUseMummy then
            UIUtil.ShowTipsId("season_s3_tips010")
          else
            UIUtil.ShowTipsId("season_s3_tips012")
          end
        end
        return false
      end
    end
  end
  return true
end

function SeasonUtil.UpdateTroopIconByMarchInfo(marchInfo, troop_pin)
  if marchInfo == nil or troop_pin == nil then
    return
  end
  local isMummyMarch = marchInfo:IsMummyMarch()
  if isMummyMarch then
    troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/zyf_S3_wujisuofang_6-1.png")
    if marchInfo.ownerUid == LuaEntry.Player.uid then
      troop_pin.color = CityLabelGreenColor
    elseif LuaEntry.Player:IsInAlliance() and marchInfo.allianceUid == LuaEntry.Player.allianceId then
      if marchInfo.ownerUid == CSharpCallLuaInterface.GetAllianceLeaderUid() then
        troop_pin.color = CityLabelPurpleColor
      else
        troop_pin.color = CityLabelBlueColor
      end
    else
      local setting = CSharpCallLuaInterface.GetWorldChessColorSetting(marchInfo.ownerServer or 0, marchInfo.allianceUid, marchInfo.ownerUid, marchInfo.ownerCurServerId)
      if setting ~= nil and setting.troop_pin_color ~= nil then
        troop_pin.color = setting.troop_pin_color
        return
      end
      local thePlayerType = CSharpCallLuaInterface.IsMyEnemy(marchInfo.ownerServer or 0, marchInfo.allianceUid, marchInfo.ownerCurServerId)
      if thePlayerType == CS.PlayerType.PlayerAllianceEnemy then
        troop_pin.color = CityLabelAllianceEnemyColor
      elseif thePlayerType == CS.PlayerType.PlayerZoneEnemy then
        troop_pin.color = CityLabelZoneEnemyColor
      elseif thePlayerType == CS.PlayerType.PlayerSeasonEnemy then
        troop_pin.color = CityLabelSeasonEnemyColor
      elseif thePlayerType == CS.PlayerType.PlayerSeasonCamp then
        troop_pin.color = CityLabelSeasonCampColor
      elseif thePlayerType == CS.PlayerType.PlayerSeasonAssist then
        troop_pin.color = CityLabelSeasonAssistColor
      else
        troop_pin.color = CityLabelWhiteColor
      end
    end
  else
    troop_pin.color = Color.white
    if marchInfo.ownerUid == LuaEntry.Player.uid then
      troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_green.png")
    elseif LuaEntry.Player:IsInAlliance() and marchInfo.allianceUid == LuaEntry.Player.allianceId then
      if marchInfo.ownerUid == CSharpCallLuaInterface.GetAllianceLeaderUid() then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_leader.png")
      else
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_blue.png")
      end
    else
      local setting = CSharpCallLuaInterface.GetWorldChessColorSetting(marchInfo.ownerServer or 0, marchInfo.allianceUid, marchInfo.ownerUid, marchInfo.ownerCurServerId)
      if setting ~= nil and setting.troop_icon ~= nil then
        troop_pin:LoadSprite(setting.troop_icon)
        return
      end
      local thePlayerType = CSharpCallLuaInterface.IsMyEnemy(marchInfo.ownerServer or 0, marchInfo.allianceUid, marchInfo.ownerCurServerId)
      if thePlayerType == CS.PlayerType.PlayerAllianceEnemy then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_enemy_alliance.png")
      elseif thePlayerType == CS.PlayerType.PlayerZoneEnemy then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_enemy_zone.png")
      elseif thePlayerType == CS.PlayerType.PlayerSeasonEnemy then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_enemy_season.png")
      elseif thePlayerType == CS.PlayerType.PlayerSeasonCamp then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_camp_season.png")
      elseif thePlayerType == CS.PlayerType.PlayerSeasonAssist then
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_assist_season.png")
      else
        troop_pin:LoadSprite("Assets/Main/Sprites/LodIcon/troop_white.png")
      end
    end
  end
end

local _theDialogDict = {}

function SeasonUtil.UpdateDialogSkin(data, reset)
  if reset or _theDialogDict == nil then
    _theDialogDict = {}
  end
  if data then
    for k, v in pairs(data) do
      _theDialogDict[k] = v
    end
    CS.GameEntry.Localization:UpdateSkinData(_theDialogDict)
  end
end

local function UpdateResourceSkin(resource_type, reward_type, dataList)
  if dataList ~= nil and 3 <= #dataList then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resource_type)
    if template ~= nil then
      template.icon = dataList[1]
      template.name = dataList[2]
      template.description = dataList[3]
      template.big_icon = dataList[4] or ""
    end
    ResourceTypeTxt[reward_type] = dataList[2]
    ResourceTypeIconName[resource_type] = string.format(LoadPath.LWCommonPath, dataList[1])
  end
end

function SeasonUtil.UpdateResourceSkin(skinCfg)
  if skinCfg then
    local line = skinCfg
    if line and line.id then
      local str = line.resource_13
      if not string.IsNullOrEmpty(str) then
        UpdateResourceSkin(ResourceType.FLINT, RewardType.FLINT, string.split_ss_array(str, "|"))
      end
      str = line.resource_10
      if not string.IsNullOrEmpty(str) then
        UpdateResourceSkin(ResourceType.OBSIDIAN, RewardType.OBSIDIAN, string.split_ss_array(str, "|"))
      end
      str = line.resource_alliance
      if not string.IsNullOrEmpty(str) then
        UpdateResourceSkin(ResourceType.AllianceStone, RewardType.AllianceStone, string.split_ss_array(str, "|"))
      end
    end
  end
end

function SeasonUtil.TryUpdateSeasonBuild(taskId)
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
  if questTemplate ~= nil and questTemplate.accept2 ~= nil then
    local type2 = toInt(questTemplate.type2)
    local listType = toInt(questTemplate.listType)
    if type2 == 517 then
      local buildId = toInt(questTemplate.accept2)
      local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildId)
      if dataList and 0 < #dataList and dataList[1] then
        local buildData = dataList[1]
        if buildData ~= nil and buildData.uuid ~= nil then
          SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
          DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
        end
      end
    elseif type2 == 396 and listType == 3 then
      local seasonType = SeasonUtil.GetSeasonSubdivisionType()
      if seasonType == SeasonMapType.NineNationRainforest then
        for i = 1, 10 do
          local theId = 840000 + i * 1000
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(theId)
          if buildData ~= nil and buildData.uuid ~= nil then
            DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
          end
        end
      elseif seasonType == SeasonMapType.NineNation then
        for i = 1, 10 do
          local theId = 820000 + i * 1000
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(theId)
          if buildData ~= nil and buildData.uuid ~= nil then
            DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
          end
        end
      end
    elseif type2 == 555 then
    end
  end
end

function SeasonUtil.CanAllianceMakeFriends(serverId)
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    return info:InNormalMode() and info:ServerInReady() and info:CanAllianceMakeFriends() and info:IsInBattleServerGroupInt(mySourceServerId)
  end
  return false
end

function SeasonUtil.SeasonHasCampMasterServer(seasonType)
  if seasonType == nil then
    seasonType = SeasonUtil.GetSeasonType(false, true)
  end
  return seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNationRainforest
end

function SeasonUtil.SeasonHasMilitaryCenter(seasonType)
  local buildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
  return buildId ~= 0
end

function SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType)
  if seasonType == nil then
    seasonType = SeasonUtil.GetSeasonType()
  end
  return seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness
end

function SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
  if seasonType == nil then
    seasonType = SeasonUtil.GetSeasonType()
  end
  if seasonType == SeasonMapType.Snow then
    return BuildingTypes.SEASON_STOVE_CENTER, BuildingTypes.SEASON_STOVE_CENTER_CARRIER
  elseif seasonType == SeasonMapType.Mummy then
    return BuildingTypes.SEASON_MUMMY_CENTER, BuildingTypes.SEASON_MUMMY_CENTER_CARRIER
  elseif seasonType == SeasonMapType.Darkness then
    return BuildingTypes.SEASON_POWER_CENTER, BuildingTypes.SEASON_POWER_CENTER_CARRIER
  end
  return 0, 0
end

function SeasonUtil.IsSeasonMilitaryCenterOrPlugin(buildId, seasonType)
  if seasonType == nil then
    seasonType = SeasonUtil.GetSeasonType()
  end
  if seasonType == SeasonMapType.Snow then
    return buildId == BuildingTypes.SEASON_STOVE_CENTER
  elseif seasonType == SeasonMapType.Mummy then
    return buildId == BuildingTypes.SEASON_MUMMY_CENTER or buildId == BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_JS or buildId == BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_KTT or buildId == BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_YLC or buildId == BuildingTypes.SEASON_MUMMY_CENTER_PLUGIN_SB
  elseif seasonType == SeasonMapType.Darkness then
    return buildId == BuildingTypes.SEASON_POWER_CENTER or buildId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN1 or buildId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN2 or buildId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN3
  end
  return false
end

function SeasonUtil.IsInSeasonOrNotInSeasonResult()
  if SeasonUtil.IsInSeason() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    if settleTime ~= 0 and curTime > settleTime then
      return false
    end
    return true
  end
  return false
end

function SeasonUtil.IsInSeasonAndNotInResult()
  if SeasonUtil.IsInSeason() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    if settleTime ~= 0 and curTime < settleTime then
      return true
    end
  end
  return false
end

function SeasonUtil.IsInSeasonSettleTime()
  if SeasonUtil.IsInSeason() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    if settleTime ~= 0 and curTime > settleTime then
      return true
    end
  end
  return false
end

function SeasonUtil.IsSeasonMilitaryCenterCarrier(buildId, seasonType)
  if seasonType == nil then
    seasonType = SeasonUtil.GetSeasonType()
  end
  if seasonType == SeasonMapType.Snow then
    return buildId == BuildingTypes.SEASON_STOVE_CENTER_CARRIER
  elseif seasonType == SeasonMapType.Mummy then
    return buildId == BuildingTypes.SEASON_MUMMY_CENTER_CARRIER
  elseif seasonType == SeasonMapType.Darkness then
    return buildId == BuildingTypes.SEASON_POWER_CENTER_CARRIER
  end
  return false
end

function SeasonUtil.GetSeasonBuffValue(effectId)
  local effectValueAll = 0
  local inBattleWorld = BattleFieldUtil.InBattleField()
  local isInSeason = SeasonUtil.IsInSeason(false)
  if isInSeason then
    local seasonType = SeasonUtil.GetSeasonSubdivisionType()
    if seasonType == SeasonMapType.Snow then
      local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
      local curMeta = DataCenter.TemperatureTemplateManager:GetTemplate(math.floor(temp))
      if curMeta then
        effectValueAll = curMeta:GetValue(effectId)
      end
    elseif seasonType == SeasonMapType.Darkness then
      if not inBattleWorld then
        local lightData = DataCenter.SeasonLightDataManager:GetBuffValue(effectId)
        if lightData then
          effectValueAll = lightData
        end
      end
    elseif seasonType == SeasonMapType.NineNationRainforest then
    else
      if seasonType == SeasonMapType.NineNation then
      else
      end
    end
    local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
    if effectList and effectList.effect then
      for theEffectId, theEffectValue in pairs(effectList.effect) do
        if effectId == theEffectId then
          effectValueAll = effectValueAll + (tonumber(theEffectValue) or 0)
          break
        end
      end
    elseif not inBattleWorld then
    end
    if not inBattleWorld then
      local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
      if effectList and effectList.effect then
        for theEffectId, theEffectValue in pairs(effectList.effect) do
          if effectId == theEffectId then
            effectValueAll = effectValueAll + (tonumber(theEffectValue) or 0)
            break
          end
        end
      end
      if effectList and effectList.state then
        for _, stateId in pairs(effectList.state) do
          local meta = LocalController:instance():getLine(TableName.StatusTab, stateId)
          if meta and meta.effect and meta.effect_num then
            local effectKeyList = string.split_ii_array(meta.effect, "|")
            local effectValueList = string.split_ff_array(meta.effect_num, "|")
            if effectKeyList and effectValueList then
              for index, theEffectId in ipairs(effectKeyList) do
                if effectId == theEffectId then
                  effectValueAll = effectValueAll + (effectValueList[index] or 0)
                end
              end
            end
          end
        end
      end
      local tradeBuff = DataCenter.SeasonTradeDataManager:GetShowBuffData()
      if tradeBuff ~= nil and tradeBuff.effectId == effectId then
        effectValueAll = effectValueAll + (tonumber(tradeBuff.effectValue) or 0)
      end
      local GlobalState = DataCenter.SeasonDataManager:GetGlobalStatus()
      if GlobalState then
        for k, v in pairs(GlobalState) do
          if v and v.effects and v.reason and v.stateId then
            for _, effect in pairs(v.effects) do
              if effect.eff and effect.val and toInt(effect.eff) == effectId then
                effectValueAll = effectValueAll + (tonumber(effect.val) or 0)
              end
            end
          end
        end
      end
    end
  end
  return effectValueAll
end

function SeasonUtil.GetSeasonPrepareDay()
  if SeasonUtil.IsInSeasonPrepareMode(true) then
    local config = DataCenter.SeasonDataManager:GetServerSeasonInfo()
    if config then
      local now = UITimeManager:GetInstance():GetServerTime()
      return (now - config.nextSeasonPreviewTime) / 86400000 + 1
    end
    return -1
  end
  return -1
end

function SeasonUtil.GetSeasonSmallIconPath(season)
  return string.format("Assets/Main/Sprites/UI/LWUIResource/cfm_tianxiadashi_S%s.png", tostring(season))
end

function SeasonUtil.GetWorldSkinConfig(seasonType)
  if seasonType == SeasonMapType.CityStronghold then
    return LocalController:instance():getLine(TableName.World_Skin, 103)
  elseif seasonType == SeasonMapType.Snow then
    return LocalController:instance():getLine(TableName.World_Skin, 102)
  elseif seasonType == SeasonMapType.Mummy then
    return LocalController:instance():getLine(TableName.World_Skin, 104)
  elseif seasonType == SeasonMapType.Darkness then
    return LocalController:instance():getLine(TableName.World_Skin, 105)
  elseif seasonType == SeasonMapType.NineNation then
    local subdivisionType = SeasonUtil.GetSeasonSubdivisionType()
    if subdivisionType == SeasonMapType.NineNationRainforest then
      return LocalController:instance():getLine(TableName.World_Skin, 116)
    else
      return LocalController:instance():getLine(TableName.World_Skin, 107)
    end
  elseif seasonType == SeasonMapType.NineNationRainforest then
    return LocalController:instance():getLine(TableName.World_Skin, 116)
  end
  return nil
end

function SeasonUtil.GetOccupyStrongholdInfo(serverId)
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  local seasonType = SeasonMapType.Nothing
  local config = SeasonUtil.GetSeasonInfo(curServerId)
  if config then
    seasonType = config:GetServerSubdivisionType()
  end
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local strongholdCount = 0
  local isBigMap = seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.NineNationRainforest
  for _, v in pairs(CrossOccupyStrongholdList) do
    if v and (isBigMap or v.serverId == curServerId) then
      strongholdCount = strongholdCount + 1
    end
  end
  local myAlId = LuaEntry.Player.allianceId
  local myStrongholdCount = DataCenter.WorldAllianceCityDataManager:GetStrongholdCountByAlId(myAlId, true, curServerId)
  local strongholdMax = 0
  local strongholdMaxLocal = 0
  local CrossOccupyStrongholdMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
  if CrossOccupyStrongholdMaxNum then
    local tmp = toInt(CrossOccupyStrongholdMaxNum[tostring(curServerId)])
    if 0 < tmp then
      strongholdMax = tmp
    end
  end
  if strongholdMaxLocal == 0 then
    if seasonType == SeasonMapType.CityStronghold then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s1_stronghold", "k4", 3))
    elseif seasonType == SeasonMapType.Snow then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s2_stronghold", "k4", 3))
    elseif seasonType == SeasonMapType.Mummy then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s3_stronghold", "k4", 3))
    elseif seasonType == SeasonMapType.Darkness then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s4_stronghold", "k4", 3))
    elseif seasonType == SeasonMapType.NineNation then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_stronghold", "k4", 3))
    elseif seasonType == SeasonMapType.NineNationRainforest then
      strongholdMaxLocal = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s6_stronghold", "k4", 3))
    end
    local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId, curServerId)
    if myAlCities then
      for _, cityId in ipairs(myAlCities) do
        local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, curServerId)
        if meta and meta:IsCity() then
          strongholdMaxLocal = strongholdMaxLocal + meta:getIntValue("stronghold_max", 0)
        end
      end
    end
  end
  return math.min(strongholdCount, myStrongholdCount), math.max(strongholdMax or 0, strongholdMaxLocal)
end

function SeasonUtil.GetStrongholdConfig(serverId, isNum, key, defaultValue)
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  local seasonType = SeasonMapType.Nothing
  local config = SeasonUtil.GetSeasonInfo(curServerId)
  if config then
    seasonType = config:GetServerSubdivisionType()
  end
  local configKey
  if seasonType == SeasonMapType.CityStronghold then
    configKey = "season_new_s1_stronghold"
  elseif seasonType == SeasonMapType.Snow then
    configKey = "season_new_s2_stronghold"
  elseif seasonType == SeasonMapType.Mummy then
    configKey = "season_new_s3_stronghold"
  elseif seasonType == SeasonMapType.Darkness then
    configKey = "season_new_s4_stronghold"
  elseif seasonType == SeasonMapType.NineNation then
    configKey = "season_new_s5_stronghold"
  elseif seasonType == SeasonMapType.NineNationRainforest then
    configKey = "season_new_s6_stronghold"
  end
  if configKey then
    if isNum then
      return LuaEntry.DataConfig:TryGetNum(configKey, key, defaultValue)
    end
    return LuaEntry.DataConfig:TryGetStr(configKey, key, defaultValue)
  end
  if isNum then
    return checknumber(defaultValue)
  end
  return defaultValue
end

function SeasonUtil.GetSeasonWeekCardConfig()
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if info ~= nil and info.currentSeasonConfig ~= nil then
    local week_card_id = toInt(info.currentSeasonConfig.week_card)
    if 0 < week_card_id then
      return LocalController:instance():getLine(TableName.Season_Week_Card, week_card_id)
    end
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonPeriodicCard.Type)
  if actList ~= nil and 0 < #actList then
    local weekAct = actList[1]
    if weekAct then
      local week_card_id = toInt(weekAct.para)
      if 0 < week_card_id then
        return LocalController:instance():getLine(TableName.Season_Week_Card, week_card_id)
      end
    end
  end
  return nil
end

function SeasonUtil.IsSeasonWeekCardBuilding(buildId)
  local config = SeasonUtil.GetSeasonWeekCardConfig()
  if config ~= nil and buildId == toInt(config.farm_building_weekcard) then
    return true
  end
  return false
end

function SeasonUtil.IsSeasonFarmBuilding(buildId)
  local config = SeasonUtil.GetSeasonWeekCardConfig()
  if config ~= nil then
    local farm_building = config.farm_building
    if farm_building ~= nil and type(farm_building) == "string" then
      local arr = string.split_ii_array(farm_building, "|")
      for _, v in ipairs(arr) do
        if v == buildId then
          return true
        end
      end
    end
  end
  return false
end

function SeasonUtil.GetCenterServerId(serverId, includePreview)
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info and info:GetServerType(includePreview) == SeasonMapType.NineNation then
    local centerServerId = info:GetNinePalacesServer(5)
    if centerServerId ~= 0 then
      return centerServerId
    end
  end
  return serverId
end

function SeasonUtil.GetShownServerIdByCityIdInBigMap(serverId, cityId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if cityMeta then
    local bigMapIndex = cityMeta.bigMapIndex
    local season = cityMeta:getIntValue("season", 0)
    if bigMapIndex ~= 0 and (season == 5 or season == 6 or season == 7) then
      local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
      if seasonInfo then
        local theServerId = seasonInfo:GetNinePalacesServer(bigMapIndex)
        if theServerId ~= 0 then
          return theServerId
        end
      end
    end
  end
  return serverId
end

local NineNationKingCityId = {
  321,
  332,
  343,
  984,
  995,
  1006,
  1647,
  1658,
  1669
}
local NineNationKingCityPos = {
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500
}
local RainforestKingCityId = {
  321,
  332,
  343,
  1059,
  1103,
  1088,
  1823,
  1834,
  1845
}
local RainforestKingCityPos = {
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500,
  499500
}

function SeasonUtil.GetCenterCityId(theServerId, includePreview)
  if theServerId == nil then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  local data = SeasonUtil.GetSeasonInfo(theServerId)
  if data then
    local seasonType = data:GetServerSubdivisionType(includePreview)
    if seasonType == SeasonMapType.NineNationRainforest then
      return RainforestKingCityId[5], RainforestKingCityPos[5]
    elseif seasonType == SeasonMapType.NineNation then
      return NineNationKingCityId[5], NineNationKingCityPos[5]
    end
  end
  return 48, 497500
end

function SeasonUtil.GetKingCityId(theServerId)
  if theServerId == nil then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  local data = SeasonUtil.GetSeasonInfo(theServerId)
  if data then
    local seasonType = data:GetServerSubdivisionType(false)
    if seasonType == SeasonMapType.NineNationRainforest then
      local mapIndex = data:GetNinePalacesIndex(theServerId)
      return RainforestKingCityId[mapIndex], RainforestKingCityPos[mapIndex]
    elseif seasonType == SeasonMapType.NineNation then
      local mapIndex = data:GetNinePalacesIndex(theServerId)
      return NineNationKingCityId[mapIndex], NineNationKingCityPos[mapIndex]
    end
  end
  return 48, 497500
end

function SeasonUtil.IsKingCity(cityId, serverId)
  local theServerId = serverId or LuaEntry.Player:GetCurServerId()
  local data = SeasonUtil.GetSeasonInfo(theServerId)
  if data then
    local seasonType = data:GetServerSubdivisionType(false)
    local theKingCityList
    if seasonType == SeasonMapType.NineNationRainforest then
      theKingCityList = RainforestKingCityId
    elseif seasonType == SeasonMapType.NineNation then
      theKingCityList = NineNationKingCityId
    end
    if theKingCityList ~= nil then
      for k, v in ipairs(theKingCityList) do
        if v == cityId then
          return true
        end
      end
      return false
    end
  end
  return cityId == 48
end

local NineNationOutpostId = {
  707,
  711,
  716,
  1022,
  0,
  968,
  1274,
  1279,
  1283
}
local RainforestOutpostId = {
  290,
  291,
  353,
  354,
  300,
  301,
  363,
  364,
  310,
  311,
  373,
  374,
  1038,
  1039,
  1117,
  1118,
  1048,
  1049,
  1127,
  1128,
  1792,
  1793,
  1855,
  1856,
  1802,
  1803,
  1865,
  1866,
  1812,
  1813,
  1875,
  1876
}
local RainforestOutpostDict = {
  {
    290,
    291,
    353,
    354
  },
  {
    300,
    301,
    363,
    364
  },
  {
    310,
    311,
    373,
    374
  },
  {
    1038,
    1039,
    1117,
    1118
  },
  {},
  {
    1048,
    1049,
    1127,
    1128
  },
  {
    1792,
    1793,
    1855,
    1856
  },
  {
    1802,
    1803,
    1865,
    1866
  },
  {
    1812,
    1813,
    1875,
    1876
  }
}

function SeasonUtil.GetOutpostList(seasonType, mapIndex)
  if seasonType == SeasonMapType.NineNationRainforest then
    return RainforestOutpostDict[mapIndex]
  elseif seasonType == SeasonMapType.NineNation and mapIndex == 5 then
    return NineNationOutpostId
  end
  return {}
end

function SeasonUtil.GetOutpostId(serverId)
  local data = SeasonUtil.GetSeasonInfo(serverId)
  if data then
    local seasonType = data:GetServerSubdivisionType(false)
    if seasonType == SeasonMapType.NineNationRainforest then
      local mapIndex = data:GetNinePalacesIndex(serverId)
      local cityList = RainforestOutpostDict[mapIndex]
      return cityList[1], serverId, cityList
    elseif seasonType == SeasonMapType.NineNation then
      local mapIndex = data:GetNinePalacesIndex(serverId)
      local cityId = NineNationOutpostId[mapIndex]
      return cityId, data:GetNinePalacesServer(5)
    end
  end
  return 0, 0
end

function SeasonUtil.IsOutpost(cityId, serverId)
  local data = SeasonUtil.GetSeasonInfo(serverId)
  if data then
    local seasonType = data:GetServerSubdivisionType(false)
    if seasonType == SeasonMapType.NineNationRainforest then
      for _, v in ipairs(RainforestOutpostId) do
        if v == cityId then
          return true
        end
      end
    elseif seasonType == SeasonMapType.NineNation then
      for _, v in ipairs(NineNationOutpostId) do
        if v == cityId then
          return true
        end
      end
    end
  end
  return false
end

function SeasonUtil.GetOutpostDefaultOwner(cityId)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local data = SeasonUtil.GetSeasonInfo(curServerId)
  if data then
    local seasonType = data:GetServerSubdivisionType(false)
    if seasonType == SeasonMapType.NineNationRainforest then
      local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
      if putByServerId == nil or putByServerId == 0 then
        return 0
      end
      return putByServerId
    elseif seasonType == SeasonMapType.NineNation then
      for mapIndex, v in ipairs(NineNationOutpostId) do
        if v == cityId then
          return DataCenter.SeasonDataManager:GetNinePalacesServer(mapIndex, ServerEnum.View)
        end
      end
    end
  end
  return 0
end

function SeasonUtil.IsNewS1(includePreview, serverId)
  local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion(includePreview, serverId)
  return seasonType == SeasonMapType.CityStronghold and 1 <= seasonVersion
end

function SeasonUtil.GetSeasonGroupName(serverId)
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info then
    local ServerType = info:GetServerSubdivisionType()
    if ServerType == SeasonMapType.NineNationRainforest then
      return string.format("S6_%s_%s", info.seasonConfigId, info.seasonStartTime)
    elseif ServerType == SeasonMapType.NineNation then
      return string.format("S5_%s_%s", info.seasonConfigId, info.seasonStartTime)
    end
  end
  return serverId
end

function SeasonUtil.InSeasonBigMapMode(serverId, checkServerId)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if serverId == nil then
    serverId = loginServerId
  end
  local data = SeasonUtil.GetSeasonInfo(serverId)
  if data then
    if checkServerId ~= nil then
      return data:GetServerType(false) == SeasonMapType.NineNation, data:IsInBattleServerGroupInt(toInt(checkServerId))
    end
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    return data:GetServerType(false) == SeasonMapType.NineNation, curServerId == serverId or data:IsInBattleServerGroupInt(curServerId), mySourceServerId == serverId or data:IsInBattleServerGroupInt(mySourceServerId), loginServerId == serverId or data:IsInBattleServerGroupInt(loginServerId)
  end
  return false
end

function SeasonUtil.InSourceMapNow()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  if loginServerId == mySourceServerId and loginServerId == curServerId then
    return true
  end
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
  if isBigMapMode and srcSameGroup and loginSameGroup then
    return true
  end
  return false
end

function SeasonUtil.GetSeasonStartTimeByServerId(serverId)
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info then
    return info:GetSeasonStartTime()
  end
  return 0
end

function SeasonUtil.CheckConnectSwitch(cityId, serverId, includeAllyFriend)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if cityTemplate ~= nil then
    local allyFriendMgr = DataCenter.SeasonAllyFriendManager
    local has_nearBy_data = type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy)
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local cityServer = cityTemplate:GetCurServerId(serverId)
    local cityMgr = DataCenter.WorldAllianceCityDataManager
    local myAlId = LuaEntry.Player.allianceId
    if not allyFriendMgr:HasFriend() then
      includeAllyFriend = false
    end
    if cityTemplate:IsCrossZoneOutpostCanon() then
      local parent_city_id = cityTemplate.parent_output
      local cityData = cityMgr:GetAllianceCityDataByCityId(parent_city_id, cityServer)
      if cityData then
        if cityData.occupyServerId == mySourceServerId then
          return true
        end
        if includeAllyFriend and allyFriendMgr:IsMyAllianceFriend(cityData.allianceId) then
          return true
        end
      end
      local world = CS.SceneManager.World
      if world ~= nil then
        local uuid = CS.WorldPointManager.GetCityUuid(cityServer, parent_city_id)
        if uuid then
          local pointInfo = world:GetPointInfoByUuid(uuid)
          if pointInfo and (pointInfo.ownerServerId == mySourceServerId or pointInfo.tmpOwnerServerId == mySourceServerId) then
            return true
          end
          if includeAllyFriend and pointInfo and allyFriendMgr:IsMyAllianceFriend(pointInfo.ownerAllianceId) then
            return true
          end
        end
      end
      local pointInfo = cityTemplate:GetPointInfo()
      if pointInfo ~= nil then
        local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if extraInfo ~= nil then
          if extraInfo.ownerServerId == mySourceServerId or extraInfo.tmpOwnerServerId == mySourceServerId then
            return true
          end
          if includeAllyFriend and allyFriendMgr:IsMyAllianceFriend(extraInfo.ownerAllianceId) then
            return true
          end
        end
      end
      return SeasonUtil.CheckConnectSwitch(parent_city_id, serverId, includeAllyFriend)
    end
    local allianceFlagList = {}
    local allianceFlagDic = DataCenter.AllianceMineManager:GetAllianceFlagData()
    if allianceFlagDic then
      for i, v in pairs(allianceFlagDic) do
        if v and v.curServerId == cityServer and v.GetZoneId then
          allianceFlagList[toInt(v:GetZoneId())] = true
        end
      end
    end
    if allianceFlagList[toInt(cityId)] then
      return true
    end
    if has_nearBy_data and cityTemplate then
      local seasonIndex = cityTemplate:getIntValue("season", 0)
      local s5City = seasonIndex == 5 or seasonIndex == 6 or seasonIndex == 7
      for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
        local myAlCityInfo = cityMgr:GetMyAlCityInfo(neighbourCityId)
        if myAlCityInfo ~= nil or allianceFlagList[toInt(neighbourCityId)] then
          return true
        end
        if s5City then
          local cityData = cityMgr:GetAllianceCityDataByCityId(neighbourCityId, cityServer)
          if cityData and cityData.occupyServerId == mySourceServerId then
            return true
          end
          if includeAllyFriend and cityData and allyFriendMgr:IsMyAllianceFriend(cityData.allianceId) then
            return true
          end
        end
      end
    end
    if cityServer == mySourceServerId then
      if myAlId == nil or myAlId == "" then
        return false
      end
      local myAlCityInfo = cityMgr:GetAllianceCityData(myAlId, cityId)
      if myAlCityInfo ~= nil then
        return true
      end
      if cityMgr:GetCityIsNearBySelfAlliance(myAlId, cityId) then
        return true
      end
      local myCitiesCount = cityMgr:GetCitiesCountByAlId(myAlId, true)
      local myStrongholdCount = cityMgr:GetStrongholdCountByAlId(myAlId, true)
      if myCitiesCount == 0 and myStrongholdCount == 0 then
        return cityTemplate.level == 1 and cityTemplate.type == WorldAllianceCityType.Stronghold or cityTemplate.type == WorldAllianceCityType.MissileFactory or cityTemplate.type == WorldAllianceCityType.Canon or cityTemplate.type == WorldAllianceCityType.King
      end
    end
  end
  return false
end

function SeasonUtil.CanCrossInteraction(serverId, checkTime, showTip, error_tip_id)
  if not serverId or serverId == LuaEntry.Player:GetSelfServerId() then
    return true
  end
  if not SeasonUtil.IsInSeason() then
    if showTip then
      UIUtil.ShowTipsId(error_tip_id or "season_tips143")
    end
    return false
  end
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if not isBigMapMode or not srcSameGroup then
    if showTip then
      UIUtil.ShowTipsId(error_tip_id or "season_tips143")
    end
    return false
  end
  return true
end

function SeasonUtil.PutAllianceBuild(serverId, buildId, gotoPointIndex, position)
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:GetSelfServerId() == serverId then
    if SceneUtils.GetIsInWorld() then
      local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
      BuildingUtils.ShowPutAllianceBuild(buildId, 0, toInt(pointId), PlaceBuildType.Build)
    else
      GoToUtil.GotoWorldPos(position, 150, nil, function()
        local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
        BuildingUtils.ShowPutAllianceBuild(buildId, 0, toInt(pointId), PlaceBuildType.Build)
      end, serverId)
    end
  else
    GoToUtil.GotoWorldPos(position, 150, nil, function()
      CrossServerUtil.SetLastJumpToParam({
        mode = JumpServerMode.PutAllianceBuild,
        buildId = buildId,
        type = MoveCrossServerType.SeasonBattleDesert,
        serverId = serverId
      })
      BuildingUtils.ShowPutAllianceBuild(buildId, 0, toInt(gotoPointIndex), PlaceBuildType.Build)
    end, serverId)
  end
end

function SeasonUtil.IsSeasonResDownloaded(packageId)
  return CS.ResourcePackageManager.IsSeasonResDownloaded(toInt(packageId))
end

function SeasonUtil.CityIsInBattle(_serverId, _cityId)
  local serverId = _serverId or LuaEntry.Player:GetCurServerId()
  local tradeInfo = DataCenter.SeasonTradeDataManager:GetServerTradeStationData(_cityId, serverId)
  if tradeInfo ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return curTime > tradeInfo.battleStartTime and curTime < tradeInfo.battleEndTime
  end
  return DataCenter.WorldAllianceCityDataManager:GetStrongholdBattleState(serverId, _cityId)
end

function SeasonUtil.GetOccupyCityMaxCount()
  local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12", 6)
  local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_CITY_MAX_NUM)
  if effectNum ~= nil and effectNum ~= 0 then
    cityMax = cityMax + effectNum
  end
  if SeasonUtil.GetSeason() ~= 0 then
    if LuaEntry.Player:IsLoginSourceServer() then
      cityMax = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal or cityMax
    else
      cityMax = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumOther or cityMax
    end
  end
  return cityMax
end

function SeasonUtil.IsOccupyCityCountReachedMax(serverId)
  if DataCenter.SeasonCampDestroyManager:IsEnemyServer(serverId) then
    return false
  end
  local myAlId = LuaEntry.Player.allianceId
  if string.IsNullOrEmpty(myAlId) then
    Logger.LogInfo("IsOccupyCityCountReachedMax - myAlId = nil")
    return true
  end
  local myCitiesCount = DataCenter.WorldAllianceCityDataManager:GetCitiesCountByAlId(myAlId, true)
  if myCitiesCount == 0 then
    return false
  end
  if serverId ~= nil then
    local occupyNumDict = DataCenter.SeasonDataManager.CrossOccupyCityNumDict
    if occupyNumDict then
      local occupyNum = toInt(occupyNumDict[serverId])
      if 0 < occupyNum then
        myCitiesCount = occupyNum
      end
    end
  end
  local cityMax = SeasonUtil.GetOccupyCityMaxCount()
  if myCitiesCount >= cityMax then
    local msg
    local occupyNumDict = DataCenter.SeasonDataManager.CrossOccupyCityNumDict
    if occupyNumDict then
      local rapidjson = require("rapidjson")
      local postData = {}
      for k, v in pairs(occupyNumDict) do
        postData[tostring(k)] = tostring(v)
      end
      if rapidjson then
        local cache = rapidjson.encode(postData, {pretty = false, sort_keys = true})
        msg = string.format("IsOccupyCityCountReachedMax - [%s]%s, %s/%s, %s", serverId or "", myAlId, myCitiesCount, cityMax, cache)
      end
    end
    if msg == nil then
      msg = string.format("IsOccupyCityCountReachedMax - [%s]%s, %s/%s", serverId or "", myAlId, myCitiesCount, cityMax)
    end
    if msg then
      Logger.LogInfo(msg)
    end
    return true
  end
  return false
end

function SeasonUtil.GetStrongholdInBattle()
  local myAllianceId = LuaEntry.Player.allianceId
  if string.IsNullOrEmpty(myAllianceId) then
    return nil, nil
  end
  local mgr = DataCenter.AllianceWarDataManager
  local allWarList = mgr:GetAllianceData()
  if allWarList ~= nil then
    for key, warData in pairs(allWarList) do
      if warData.type == AllianceTeamType.ATTACK_CITY_STRONGHOLD and warData.targetContentId ~= nil and warData.targetContentId ~= 0 then
        return warData.server, warData.targetContentId
      elseif warData.type == AllianceTeamType.ATTACK_BOSS and warData.targetContentId ~= nil and warData.targetContentId ~= 0 then
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(warData.targetContentId)
        if monster ~= nil and (monster.special == WorldMonsterSpecialType.CityStrongholdPVP or monster.special == WorldMonsterSpecialType.CityStrongholdBOSS) then
          return warData.server, SceneUtils.GetZoneIdByPosId(warData.targetPointId, warData.server)
        end
      end
    end
  end
  return nil, nil
end

function SeasonUtil.CanJoinBattleRainforest(cityServerId_)
  local info = SeasonUtil.GetSeasonInfo(cityServerId_ or LuaEntry.Player:GetCurServerId())
  if info and info:GetServerSubdivisionType() ~= SeasonMapType.NineNationRainforest then
    return false
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if mySourceServerId == cityServerId_ then
    return true
  end
  local kingCityId = SeasonUtil.GetKingCityId(cityServerId_)
  if kingCityId ~= nil and kingCityId ~= 0 then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, cityServerId_)
    if cityTemplate then
      local nearBy = cityTemplate.nearBy
      if nearBy then
        local mgr = DataCenter.WorldAllianceCityDataManager
        for _, cityId in ipairs(nearBy) do
          local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId))
          if cityInfo ~= nil and cityInfo.occupyServerId == mySourceServerId and toInt(cityInfo.destroyServerId) == 0 then
            return true
          end
        end
      end
    end
  end
  return false
end

function SeasonUtil.CanJoinBattle(cityServerId_)
  local info = SeasonUtil.GetSeasonInfo(cityServerId_ or LuaEntry.Player:GetCurServerId())
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    return SeasonUtil.CanJoinBattleRainforest(cityServerId_)
  end
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    return DataCenter.SeasonNineKingManager:CanJoinBattle(nil, cityServerId_)
  end
  return DataCenter.ZoneWarManager:CanJoinBattle()
end

function SeasonUtil.IsBattleMember(cityServerId_, serverId_, allianceId_)
  local info = SeasonUtil.GetSeasonInfo(cityServerId_ or LuaEntry.Player:GetCurServerId())
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    return SeasonUtil.CanJoinBattleRainforest(cityServerId_)
  end
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    return DataCenter.SeasonNineKingManager:CanJoinBattle(allianceId_, cityServerId_)
  end
  return DataCenter.ZoneWarManager:IsBattleMember(serverId_)
end

function SeasonUtil.IsNineNationKingMember(cityServerId_, allianceId_)
  local info = SeasonUtil.GetSeasonInfo(cityServerId_ or LuaEntry.Player:GetCurServerId())
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    return SeasonUtil.CanJoinBattleRainforest(cityServerId_)
  end
  if not SeasonUtil.IsNineKingActive(cityServerId_) then
    return false
  end
  return DataCenter.SeasonNineKingManager:CanJoinBattle(allianceId_, cityServerId_)
end

function SeasonUtil.IsNineKingActive(serverId_, checkIsBattle_, checkIsSource_)
  local theServerId = serverId_ or LuaEntry.Player:GetCurServerId()
  if SeasonUtil.GetCurWorldSeasonType(true) == SeasonMapType.NineNation then
    if checkIsSource_ and not DataCenter.SeasonDataManager:IsInNinePalacesMode(theServerId, ServerEnum.Source) then
      return false
    end
    return DataCenter.SeasonNineKingManager:IsCurWorldActive(theServerId, checkIsBattle_)
  end
  return false
end

function SeasonUtil.IsAlly(ownerServerId, serverId, ownerAllianceId, allianceId_)
  if serverId and ownerServerId then
    local info = SeasonUtil.GetSeasonInfo(serverId)
    if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
      return info:GetCampIdByServerId(ownerServerId) == info:GetCampIdByServerId(serverId)
    end
  end
  if SeasonUtil.IsNineKingActive(ownerServerId) then
    return DataCenter.SeasonNineKingManager:IsAlly(ownerAllianceId, allianceId_)
  end
  return DataCenter.ZoneWarManager:IsAlly(ownerServerId, serverId)
end

function SeasonUtil.GetMyEnemyServerNow(ownerServerId, ownerAllianceId_)
  if SeasonUtil.IsNineKingActive(ownerServerId) then
    return DataCenter.SeasonNineKingManager:GetMyEnemyNow(ownerAllianceId_)
  end
  return DataCenter.ZoneWarManager:GetMyEnemyServerNow(ownerServerId)
end

function SeasonUtil.ParseKillScoreData(killInfo, ownerServerId_, ownerAllianceId_, ownerAbbr_)
  if SeasonUtil.IsNineKingActive(ownerServerId_) then
    return DataCenter.SeasonNineKingManager:ParseKillScoreData(killInfo, ownerServerId_, ownerAllianceId_, ownerAbbr_)
  end
  return DataCenter.ZoneWarManager:ParseKillScoreData(killInfo, ownerServerId_)
end

function SeasonUtil.GetWorldBattleEndTime(cityServerId_)
  local theServerId = cityServerId_ or LuaEntry.Player:GetCurServerId()
  local info = SeasonUtil.GetSeasonInfo(theServerId)
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    local mapIndex = info:GetNinePalacesIndex(theServerId)
    if mapIndex ~= 5 then
      return DataCenter.SeasonRainforestKingBattleManager:GetFightingEndTime()
    end
  end
  if SeasonUtil.IsNineKingActive(theServerId) then
    return DataCenter.SeasonNineKingManager:GetWorldBattleEndTime(theServerId)
  end
  return DataCenter.ZoneWarManager:GetCrossKingBattleEndTime()
end

function SeasonUtil.GetWorldBattleTotalPoint(cityServerId_)
  local theServerId = cityServerId_ or LuaEntry.Player:GetCurServerId()
  local info = SeasonUtil.GetSeasonInfo(theServerId)
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    local mapIndex = info:GetNinePalacesIndex(theServerId)
    if mapIndex ~= 5 then
      local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
      if actData then
        return toInt(actData.para_3)
      end
    end
  end
  if SeasonUtil.IsNineKingActive(theServerId) then
    return DataCenter.SeasonNineKingManager:GetWorldTotalScore(theServerId)
  end
  return LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k3", 360000)
end

function SeasonUtil.GetWorldBattlePointSpeed(cityServerId_)
  local theServerId = cityServerId_ or LuaEntry.Player:GetCurServerId()
  local info = SeasonUtil.GetSeasonInfo(theServerId)
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    local mapIndex = info:GetNinePalacesIndex(theServerId)
    if mapIndex ~= 5 then
      local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
      if actData then
        return toInt(actData.para_4)
      end
    end
  end
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    return DataCenter.SeasonNineKingManager:GetWorldPointSpeed(cityServerId_)
  end
  return LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k2", 1)
end

function SeasonUtil.GetTowerSpeedAdd(cityServerId_)
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    return DataCenter.SeasonNineKingManager:GetTowerSpeedAdd(cityServerId_)
  end
  return DataCenter.ZoneWarManager:GetTowerSpeedAdd()
end

function SeasonUtil.GetWorldBattleName(info, setColor_, isEnemy_, cityServerId_, showCamp_)
  cityServerId_ = cityServerId_ or LuaEntry.Player:GetCurServerId()
  if not setColor_ then
    if info.serverId then
      local seasonInfo = SeasonUtil.GetSeasonInfo(cityServerId_)
      if seasonInfo and seasonInfo:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
        return string.format("#%s", info.serverId or "-")
      end
    end
    if SeasonUtil.IsNineKingActive(cityServerId_) then
      local name = info.allianceAbbr or info.alAbbr
      if string.IsNullOrEmpty(name) then
        return ""
      end
      return string.format("[%s]", name)
    end
    if showCamp_ then
      return DataCenter.ZoneWarManager:GetCampName(info.serverId)
    end
    return string.format("#%s", info.serverId or "-")
  end
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    local name = info.allianceAbbr or info.alAbbr
    if string.IsNullOrEmpty(name) then
      return ""
    end
    return string.format("<color=%s>[%s]</color>", isEnemy_ and "#FF7A81" or "#2BD3FF", name)
  end
  if showCamp_ then
    return string.format("<color=%s>%s</color>", isEnemy_ and "#FF7A81" or "#2BD3FF", DataCenter.ZoneWarManager:GetCampName(info.serverId))
  end
  return string.format("<color=%s>#%s</color>", isEnemy_ and "#FF7A81" or "#2BD3FF", info.serverId or "-")
end

function SeasonUtil.GetBatteryDesc(cityServerId_)
  if SeasonUtil.IsNineKingActive(cityServerId_) then
    return "season_s5_activity_1200067_limit15", "season_s5_activity_1200067_desc07", "season_s5_activity_1200067_desc06"
  end
  return 801431, 801432, 801473
end

function SeasonUtil.GetSeason6CampIconPath(campType)
  if campType == SeasonFactionType.Rebels then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying01_icon.png"
  elseif campType == SeasonFactionType.Gendarmerie then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying02_icon.png"
  else
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying03_icon.png"
  end
end

function SeasonUtil.GetSeason6CampMidIconPath(campType)
  if campType == SeasonFactionType.Rebels then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying01_mid.png"
  elseif campType == SeasonFactionType.Gendarmerie then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying02_mid.png"
  else
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying03_mid.png"
  end
end

local season6campColor_Camp1 = Color.New(0.35294117647058826, 0.6549019607843137, 0.38823529411764707, 1)
local season6campColor_Camp2 = Color.New(0.1803921568627451, 0.5686274509803921, 0.6941176470588235, 1)
local season6campColor_Default = Color.New(1.0, 1.0, 1.0, 0)

function SeasonUtil.GetSeason6CampColor(campType)
  if campType == SeasonFactionType.Rebels then
    return season6campColor_Camp1
  elseif campType == SeasonFactionType.Gendarmerie then
    return season6campColor_Camp2
  else
    return season6campColor_Default
  end
end

local season6campFontColor_Camp1 = Color.New(0.5568627450980392, 1.0, 0.807843137254902, 1)
local season6campFontColor_Camp2 = Color.New(0.45098039215686275, 0.9803921568627451, 1.0, 1)
local season6campFontColor_Default = Color.New(0.5568627450980392, 1.0, 0.807843137254902, 1)

function SeasonUtil.GetSeason6CampFontColor(campType)
  if campType == SeasonFactionType.Rebels then
    return season6campFontColor_Camp1
  elseif campType == SeasonFactionType.Gendarmerie then
    return season6campFontColor_Camp2
  else
    return season6campFontColor_Default
  end
end

function SeasonUtil.GetSeason6CampAvatarTexPath(campType)
  if campType == SeasonFactionType.Rebels then
    return "Assets/Main/SeasonRes/S6/Textures/Avatar/lyt_s6boss_01.png"
  elseif campType == SeasonFactionType.Gendarmerie then
    return "Assets/Main/SeasonRes/S6/Textures/Avatar/lyt_s6boss_03.png"
  else
    return "Assets/Main/SeasonRes/S6/Textures/Avatar/lyt_s6boss_02.png"
  end
end

function SeasonUtil.GetSeason6CampNameBgPath(campType)
  if campType == SeasonFactionType.Rebels then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_fuwuqibg01.png"
  elseif campType == SeasonFactionType.Gendarmerie then
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_fuwuqibg02.png"
  else
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_fuwuqibg01.png"
  end
end

function SeasonUtil.GetSeason6CampCityAvatarPrefabPath(campType)
  if campType == SeasonFactionType.Rebels then
    return "Assets/Main/SeasonRes/S6/Prefabs/WorldUI/WorldCityHeadInfo_01.prefab"
  elseif campType == SeasonFactionType.Gendarmerie then
    return "Assets/Main/SeasonRes/S6/Prefabs/WorldUI/WorldCityHeadInfo_03.prefab"
  else
    return "Assets/Main/SeasonRes/S6/Prefabs/WorldUI/WorldCityHeadInfo_02.prefab"
  end
end

local __battleColor = {
  Color.New(0.15294117647058825, 0.7490196078431373, 0.9921568627450981, 1),
  Color.New(0.8117647058823529, 0.16470588235294117, 0.16470588235294117, 1),
  Color.New(39, 191, 253, 255),
  Color.New(207, 42, 42, 255)
}

function SeasonUtil.GetWorldBattleColor(isEnemy_)
  if isEnemy_ then
    return __battleColor[2], __battleColor[4], isEnemy_
  end
  return __battleColor[1], __battleColor[3], isEnemy_
end

function SeasonUtil.GetIsCentralServer()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(loginServerId, ServerEnum.Login)
  if mapIndex == 5 then
    return true
  end
  return false
end

function SeasonUtil.TryShowChangeToSingleServerModeTips()
  if BattleFieldUtil.InBattleField() then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if CrossServerUtil:GetIsCrossServer() then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local data = SeasonUtil.GetSeasonInfo(curServerId)
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    if data ~= nil and data:IsInBattleServerGroupInt_IgnoreSplitServer(loginServerId) then
      SeasonUtil.ShowChangeToSingleServerModeTips()
    end
  end
end

function SeasonUtil.ShowChangeToSingleServerModeTips()
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("activity_concert_15"),
    contentText = Localization:GetString("s5_map_tips_3"),
    btnNum = 1,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        SeasonUtil.GotoPlayerBasePos()
        local selfServerId = LuaEntry.Player:GetSelfServerId()
        GoToUtil.GotoServerZone(selfServerId, true)
      end
    },
    closeAction = function()
      SeasonUtil.GotoPlayerBasePos()
      local selfServerId = LuaEntry.Player:GetSelfServerId()
      GoToUtil.GotoServerZone(selfServerId, true)
    end
  })
end

function SeasonUtil.PlayDestroyVfxByCityId(serverId, cityId, setFirstView)
  if SceneUtils.GetIsInWorld() then
    local theWorld = CS.SceneManager.World
    local curServerId = serverId or LuaEntry.Player:GetCurServerId()
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, curServerId)
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    if template ~= nil and seasonInfo ~= nil then
      local theServerId = template:GetServerIdByEnum(ServerEnum.View)
      if seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
        theServerId = seasonInfo:GetNinePalacesServer(template.bigMapIndex)
        if seasonInfo.isSingleServerMode and theServerId ~= serverId then
          if setFirstView and theWorld then
            theWorld:SetFirstViewRequestFlag(true)
            theWorld:UpdateViewRequest(true)
          end
          return
        end
      end
      local pointId = template:GetPointId()
      local effectPath = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_s6_z_chengshi_baopo.prefab"
      theWorld:CreateBattleVFX(effectPath, 5, function(go)
        local _world = CS.SceneManager.World
        if _world ~= nil and go ~= nil and pointId then
          go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, theServerId)
        end
        if setFirstView and _world then
          _world:SetFirstViewRequestFlag(true)
          _world:UpdateViewRequest(true)
        end
      end)
    elseif setFirstView and theWorld then
      theWorld:SetFirstViewRequestFlag(true)
      theWorld:UpdateViewRequest(true)
    end
  end
end

function SeasonUtil.GotoPlayerBasePos()
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  local targetPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World, selfServerId)
  local world = CS.SceneManager.World
  if world then
    world:StopCameraMove()
    GoToUtil.GotoPos(targetPos, world.Zoom, 0.1, nil, selfServerId, 0)
  end
end

function SeasonUtil.IsSeasonInSingleServerMode(serverId)
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  if seasonInfo ~= nil and seasonInfo.isSingleServerMode then
    return true
  else
    return false
  end
end

function SeasonUtil.ClearTableNameByServerId(serverId)
  if WorldCityTableName and WorldCityTableName[serverId] then
    WorldCityTableName[serverId] = nil
  end
end

function SeasonUtil.IsInLandlordActAndOnCenterServer()
  local llData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActLandlord.Type)
  if not llData then
    return false
  end
  local landlordMgr = DataCenter.LandlordMgr
  if not landlordMgr then
    return false
  end
  local actData = landlordMgr:GetActData()
  if actData == nil then
    return false
  end
  local centerServerId = landlordMgr:GetCenterServerId()
  if centerServerId == nil or centerServerId <= 0 then
    return false
  end
  return LuaEntry.Player:GetSelfServerId() == centerServerId
end

function SeasonUtil.JumpToCityById(cityId)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if not cityTemplate then
    return
  end
  local pointId = cityTemplate:GetPointId()
  local serverId = cityTemplate:GetSourceServerId()
  if pointId and serverId and 0 < serverId then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, serverId)
  end
end

function SeasonUtil.GetCityOccupyCampId(cityId, serverId)
  if not cityId or cityId == 0 then
    return 0
  end
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if not cityInfo or not cityInfo.occupyServerId then
    return 0
  end
  local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(cityInfo.occupyServerId)
  return campId or 0
end

return ConstClass("SeasonUtil", SeasonUtil)
