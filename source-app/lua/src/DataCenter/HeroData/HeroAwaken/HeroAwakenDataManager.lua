local HeroAwakenDataManager = BaseClass("HeroAwakenDataManager")

function HeroAwakenDataManager:__init()
end

function HeroAwakenDataManager:__delete()
end

local function __isHeroAwakenOpenByHeroInfo(heroInfo)
  if heroInfo == nil then
    return false
  end
  local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(heroInfo.heroId)
  if awakenTemplate == nil or not awakenTemplate:IsTimeOpen() then
    return false
  end
  if not heroInfo:IsReachMaxRank() then
    return false
  end
  if not heroInfo:IsUniqueWeaponOpen() then
    return false
  end
  local minUniqueWeaponLv = LuaEntry.DataConfig:TryGetNum("hero_awaken_config", "k4", 0)
  local uniqueWeaponLv = heroInfo:GetUniqueWeaponLv()
  if minUniqueWeaponLv > uniqueWeaponLv then
    return false
  end
  return true
end

function HeroAwakenDataManager:IsHeroAwakenOpenByHeroId(heroId)
  if not self:IsHeroAwakenFunctionOn() or heroId == nil then
    return false
  end
  local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroInfo == nil then
    return false
  end
  return __isHeroAwakenOpenByHeroInfo(heroInfo)
end

function HeroAwakenDataManager:IsHeroAwakenOpenByHeroInfo(heroInfo)
  if not self:IsHeroAwakenFunctionOn() or heroInfo == nil then
    return false
  end
  return __isHeroAwakenOpenByHeroInfo(heroInfo)
end

function HeroAwakenDataManager:IsHeroAwakenFunctionOn()
  if not LuaEntry.DataConfig:CheckSwitch("hero_awaken") then
    return false
  end
  local requireSeasonStr = LuaEntry.DataConfig:TryGetStr("hero_awaken_config", "k1", "")
  local requireSeasonStrSplit = string.split(requireSeasonStr, ";")
  if #requireSeasonStrSplit == 2 then
    local requireSeasonNum = tonumber(requireSeasonStrSplit[1]) or 0
    local requireSeasonDay = tonumber(requireSeasonStrSplit[2]) or 0
    local seasonNum = SeasonUtil.GetSeason()
    if requireSeasonNum < seasonNum then
      return true
    elseif requireSeasonNum > seasonNum then
      return false
    end
    return requireSeasonDay <= SeasonUtil.GetSeasonDayByOpenServerZero()
  end
  return false
end

function HeroAwakenDataManager:IsHeroAwakenCanUpgradeByHeroInfo(heroInfo)
  if heroInfo == nil then
    return false
  end
  if not self:IsHeroAwakenOpenByHeroInfo(heroInfo) then
    return false
  end
  local minUniqueWeaponLv = LuaEntry.DataConfig:TryGetNum("hero_awaken_config", "k2", 0)
  local uniqueWeaponLv = heroInfo:GetUniqueWeaponLv()
  if minUniqueWeaponLv > uniqueWeaponLv then
    return false
  end
  return true
end

function HeroAwakenDataManager:SendAwakenUpgradeMsg(heroUuid, useCommonItem)
  SFSNetwork.SendMessage(MsgDefines.UpgradeHeroAwaken, heroUuid, useCommonItem)
end

local SINGLE_HERO_AWAKEN_GUIDE_PREF_KEY = "SINGLE_HERO_AWAKEN_GUIDE_PREF_KEY"

function HeroAwakenDataManager:IsHasShownSingleHeroAwakenGuide(heroId)
  local key = SINGLE_HERO_AWAKEN_GUIDE_PREF_KEY .. tostring(heroId)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function HeroAwakenDataManager:SetHasShownDetailByActivityInfo(heroId)
  local key = SINGLE_HERO_AWAKEN_GUIDE_PREF_KEY .. tostring(heroId)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function HeroAwakenDataManager:ShowSingleHeroAwakenGuide(heroId, callback)
  local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(heroId)
  if awakenTemplate and awakenTemplate.guide_plot_id > 0 then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = awakenTemplate.guide_plot_id,
      hideMainUI = false,
      callback = function()
        if callback then
          callback()
        end
      end
    })
  elseif callback then
    callback()
  end
end

return HeroAwakenDataManager
