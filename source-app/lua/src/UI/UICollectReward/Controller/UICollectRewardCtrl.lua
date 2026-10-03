local UICollectRewardCtrl = BaseClass("UICollectRewardCtrl", UIBaseCtrl)
local greenBgPath = "Assets/Main/Sprites/UI/UIFormationDefence/dl_jiangli_dikuang01.png"
local redBgPath = "Assets/Main/Sprites/UI/UIFormationDefence/dl_jiangli_dikuang02.png"
local kuang3Path = "Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_3.png"
local kuangPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_touxiangkuang.png"
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UICollectReward)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

function UICollectRewardCtrl:GetItemViewData(collectRewardData)
  if collectRewardData.type == CollectRewardType.ICE_SUPPLIES then
    local params = string.split(collectRewardData.contentId, "|")
    if params and #params == 2 then
      local config = LocalController:instance():getLine(TableName.LWIceSupplies, params[1])
      local data = {}
      data.bg = greenBgPath
      data.playerHeadFrame = kuangPath
      data.monsterIconContentFlag = true
      data.energyIconShow = true
      data.headFlag = false
      local lvString = Localization:GetString("300665", config.level)
      local nameStr = Localization:GetString(config.name)
      data.monsterNameN = lvString .. " " .. nameStr
      data.monsterNameNColor = CollectRewardNameGreen
      data.pvpImgFlag = false
      local flag = params[2]
      if flag == "0" then
        data.typePointFlag = false
        data.monsterIconPath = config.icon
      elseif flag == "1" then
        data.typePointFlag = true
        data.typePointTxt = "season_s2_ice_supplies_16"
        data.typePointSprite = string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian")
        data.monsterIconPath = config.lucky_icon
      elseif flag == "2" then
        data.typePointFlag = true
        data.typePointTxt = "zone_mobilization_supplies_super_reward"
        data.typePointSprite = string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian")
        data.monsterIconPath = config.red_icon
      end
      return data
    end
  elseif collectRewardData.type == CollectRewardType.ALLIANCE_PUSH then
    local configId = toInt(collectRewardData.contentId)
    local pointId = toInt(collectRewardData.pointId)
    local serverId = toInt(collectRewardData.serverId)
    local worldId = toInt(collectRewardData.worldId)
    local uuid = collectRewardData.targetUuid
    local config = LocalController:instance():getLine(TableName.AllianceMine, configId)
    local data = {}
    data.clickParam = {}
    data.clickParam.uuid = uuid
    data.clickParam.serverId = serverId
    data.clickParam.worldId = worldId
    data.clickParam.pointId = pointId
    data.clickParam.objType = CollectCheckObjType.Alliance_Collect_Res
    data.bg = greenBgPath
    data.playerHeadFrame = kuangPath
    data.monsterIconContentFlag = true
    data.headFlag = false
    data.energyIconShow = false
    local nameStr = Localization:GetString(config.name)
    data.monsterNameN = nameStr
    data.monsterNameNColor = CollectRewardNameGreen
    data.pvpImgFlag = false
    data.typePointFlag = true
    data.typePointTxt = "season_s2_ice_supplies_16"
    data.typePointSprite = string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian")
    data.monsterIconPath = string.format(LoadPath.ItemPath, config.icon_small)
    data.contentText = Localization:GetString("season_s3_alliance_res_build_tips_1", UIUtil.MakeJumpLink(pointId, serverId, worldId))
    return data
  end
  return nil
end

UICollectRewardCtrl.CloseSelf = CloseSelf
UICollectRewardCtrl.Close = Close
return UICollectRewardCtrl
