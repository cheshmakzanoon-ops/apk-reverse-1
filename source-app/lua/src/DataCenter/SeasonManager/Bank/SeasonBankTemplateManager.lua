local SeasonBankTemplateManager = BaseClass("SeasonBankTemplateManager")
local Localization = CS.GameEntry.Localization

function SeasonBankTemplateManager:__init()
end

function SeasonBankTemplateManager:__delete()
end

local function __SortByLevel(a, b)
  return a.level < b.level
end

function SeasonBankTemplateManager:GetStrongholdListByLevel(serverId)
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local list = DataCenter.AllianceCityTemplateManager:GetStrongholdList(serverId)
  if not list then
    return {}
  end
  local levelDic = {}
  for _, v in ipairs(list) do
    if not levelDic[v.level] then
      levelDic[v.level] = v
    end
  end
  local levelList, index = {}, 1
  for _, v in pairs(levelDic) do
    levelList[index] = v
    index = index + 1
  end
  table.sort(levelList, __SortByLevel)
  return levelList
end

function SeasonBankTemplateManager:GetOpenTimeStamps(cityId, serverId)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  local openLimits = cityTemplate and cityTemplate.deposit_open_time
  if table.IsNullOrEmpty(openLimits) then
    return {}
  end
  local timeStamps = {}
  local _, day = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(openLimits) do
    if v and v > day then
      timeStamps[i] = UITimeManager:GetInstance():GetFutureDayZero(serverTime, v - day)
    else
      timeStamps[i] = 0
    end
  end
  return timeStamps
end

function SeasonBankTemplateManager.getters:mailId()
  return {
    80354,
    80355,
    80357,
    80356
  }
end

function SeasonBankTemplateManager.getters:mailName()
  return {
    "s5_bank_ui32",
    "s5_bank_ui35",
    "s5_bank_ui34",
    "s5_bank_ui33"
  }
end

function SeasonBankTemplateManager.getters:subTitle()
  return {
    "s5_bank_ui14",
    "s5_bank_ui15",
    "s5_bank_ui16",
    "s5_bank_ui17"
  }
end

function SeasonBankTemplateManager.getters:titleBg()
  return {
    "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_tiaomu_lan.png",
    "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_tiaomu_lv.png",
    "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_tiaomu_huang.png",
    "Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_tiaomu_hong.png"
  }
end

function SeasonBankTemplateManager.getters:color()
  return {
    Color.FromHex("2a2830"),
    Color.FromHex("099b4a"),
    Color.FromHex("ea8f0d"),
    Color.FromHex("f53c3d")
  }
end

function SeasonBankTemplateManager.getters:tipsIcon()
  return {
    "Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png",
    "Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaolv.png",
    "Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png",
    "Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaohong.png"
  }
end

function SeasonBankTemplateManager.getters:tipsText()
  return {
    "s5_bank_ui36",
    "s5_bank_ui39",
    "s5_bank_ui38",
    "s5_bank_ui37"
  }
end

function SeasonBankTemplateManager.getters:typeDesc()
  return {
    "s5_bank_ui59",
    "s5_bank_ui62",
    "s5_bank_ui61",
    "s5_bank_ui60"
  }
end

function SeasonBankTemplateManager.getters:bankSign()
  return {
    "s5_bank_ui42",
    "s5_bank_ui45",
    "s5_bank_ui44",
    "s5_bank_ui43"
  }
end

function SeasonBankTemplateManager.getters:bankEmoji()
  return {
    "Assets/Main/Sprites/ItemIcons/zyf_biaoqing_fengmian_7.png",
    "Assets/Main/Sprites/ItemIcons/zyf_biaoqing_fengmian_6.png",
    "Assets/Main/Sprites/ItemIcons/zyf_biaoqing_fengmian_10.png",
    "Assets/Main/Sprites/ItemIcons/zyf_biaoqing_fengmian_9.png"
  }
end

function SeasonBankTemplateManager.getters:bankStamp()
  return {
    "Assets/Main/SeasonRes/S5/Textures/Bank/zxl_s5yh_yinzhang_hui.png",
    "Assets/Main/SeasonRes/S5/Textures/Bank/zxl_s5yh_yinzhang_lv.png",
    "Assets/Main/SeasonRes/S5/Textures/Bank/zxl_s5yh_yinzhang_huang.png",
    "Assets/Main/SeasonRes/S5/Textures/Bank/zxl_s5yh_yinzhang_hong.png"
  }
end

return SeasonBankTemplateManager
