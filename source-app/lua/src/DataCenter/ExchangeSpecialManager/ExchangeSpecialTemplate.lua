local ExchangeSpecialTemplate = BaseClass("ExchangeSpecialTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = ""
  self.refund_ratio = ""
  self.active_gift_pack_id = ""
  self.refund_item_id = ""
  self.refund_speedup_minutes = ""
  self.building_visual_server = ""
  self.decoration_level_per_tier = ""
  self.building_banner_icon = ""
  self.model_effect = ""
  self.decoration_id = ""
  self.item_spd_menu = ""
  self.decoration_des1 = ""
  self.decoration_des2 = ""
  self.decoration_icon = ""
  self.effect_word = ""
  self.effect_icon = ""
  self.effectId = ""
  self.isShowThisServer = nil
end

local function __delete(self)
  self.id = 0
  self.type = ""
  self.refund_ratio = ""
  self.active_gift_pack_id = ""
  self.refund_item_id = ""
  self.refund_speedup_minutes = ""
  self.building_visual_server = ""
  self.decoration_level_per_tier = ""
  self.building_banner_icon = ""
  self.model_effect = ""
  self.decoration_id = ""
  self.item_spd_menu = ""
  self.decoration_des1 = ""
  self.decoration_des2 = ""
  self.decoration_icon = ""
  self.effect_word = ""
  self.effect_icon = ""
  self.effectId = ""
  self.isShowThisServer = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type") or ""
  self.refund_ratio = row:getValue("refund_ratio") or ""
  self.active_gift_pack_id = row:getValue("active_gift_pack_id") or ""
  self.refund_item_id = row:getValue("refund_item_id") or ""
  self.refund_speedup_minutes = row:getValue("refund_speedup_minutes") or ""
  self.building_visual_server = row:getValue("building_visual_server") or ""
  self.decoration_level_per_tier = row:getValue("decoration_level_per_tier") or ""
  self.building_banner_icon = row:getValue("building_banner_icon") or ""
  self.model_effect = row:getValue("model_effect") or ""
  self.decoration_id = row:getValue("decoration_id") or ""
  self.item_spd_menu = row:getValue("item_spd_menu") or ""
  self.decoration_des1 = row:getValue("decoration_des1") or ""
  self.decoration_des2 = row:getValue("decoration_des2") or ""
  self.decoration_icon = row:getValue("decoration_icon") or ""
  self.effect_word = row:getValue("effect_word") or ""
  self.effect_icon = row:getValue("effect_icon") or ""
  self.effectId = row:getValue("effectId") or ""
end

function ExchangeSpecialTemplate:CheckConfig()
  if tostring(self.id) ~= "1" then
    return
  end
  local key = "pyramid_package"
  if self:CheckConfigSuit(key) then
    Logger.LogError("Item\233\133\141\231\189\174pyramid_package\229\146\140ExchangeSpecial\232\161\168id\228\184\1861\231\154\132\229\175\185\228\184\141\228\184\138\228\186\134\239\188\129")
    local refund_ratio = LuaEntry.DataConfig:TryGetNum(key, "k1")
    local active_gift_pack_id = LuaEntry.DataConfig:TryGetNum(key, "k2")
    local refund_item_id = LuaEntry.DataConfig:TryGetNum(key, "k3")
    local refund_speedup_minutes = LuaEntry.DataConfig:TryGetNum(key, "k4")
    local building_visual_server = LuaEntry.DataConfig:TryGetNum(key, "k5")
    local decoration_level_per_tier = LuaEntry.DataConfig:TryGetNum(key, "k6")
    self.refund_ratio = refund_ratio
    self.active_gift_pack_id = active_gift_pack_id
    self.refund_item_id = refund_item_id
    self.refund_speedup_minutes = refund_speedup_minutes
    self.building_visual_server = building_visual_server
    self.decoration_level_per_tier = decoration_level_per_tier
  end
end

function ExchangeSpecialTemplate:CheckConfigSuit(key)
  local refund_ratio = LuaEntry.DataConfig:TryGetNum(key, "k1")
  local active_gift_pack_id = LuaEntry.DataConfig:TryGetNum(key, "k2")
  local refund_item_id = LuaEntry.DataConfig:TryGetNum(key, "k3")
  local refund_speedup_minutes = LuaEntry.DataConfig:TryGetNum(key, "k4")
  local building_visual_server = LuaEntry.DataConfig:TryGetNum(key, "k5")
  local decoration_level_per_tier = LuaEntry.DataConfig:TryGetNum(key, "k6")
  return self.refund_ratio == refund_ratio and self.active_gift_pack_id == active_gift_pack_id and self.refund_item_id == refund_item_id and self.refund_speedup_minutes == refund_speedup_minutes and self.building_visual_server == building_visual_server and self.decoration_level_per_tier == decoration_level_per_tier
end

function ExchangeSpecialTemplate:GetRefundRatio()
  return self.refund_ratio
end

function ExchangeSpecialTemplate:IsActivePackage(id)
  local isActivePackage = false
  local pyramidPackageGroupList = string.split(self.active_gift_pack_id, "|")
  for i = 1, #pyramidPackageGroupList do
    if not string.IsNullOrEmpty(pyramidPackageGroupList[i]) then
      local packIdsStr = string.split(pyramidPackageGroupList[i], ";")
      for k = 1, #packIdsStr do
        if packIdsStr[k] == id then
          isActivePackage = true
          break
        end
      end
    end
  end
  return isActivePackage
end

function ExchangeSpecialTemplate:IsShowEffectThisServer()
  if self.isShowThisServer ~= nil then
    return self.isShowThisServer
  end
  local showServerList = string.split(self.building_visual_server, ",")
  local curServerId = LuaEntry.Player:GetSourceServerId() or 0
  local isShowInServer = false
  for i = 1, #showServerList do
    local serverIdList = string.split(showServerList[i], "-")
    if 2 <= #serverIdList then
      local serverId1 = tonumber(serverIdList[1])
      local serverId2 = tonumber(serverIdList[2])
      if curServerId >= serverId1 and curServerId <= serverId2 then
        isShowInServer = true
        break
      end
    else
      local serverId = tonumber(serverIdList[1])
      if serverId == curServerId then
        isShowInServer = true
        break
      end
    end
  end
  self.isShowThisServer = isShowInServer
  return isShowInServer
end

function ExchangeSpecialTemplate:GetBuildCurLevelTemplateByIndex(curIndex)
  local levelStrList = string.split(self.decoration_level_per_tier, "|")
  local showLevel = tonumber(levelStrList[curIndex])
  if showLevel == nil then
    return
  end
  local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.decoration_id, showLevel)
  return buildCurLevelTemplate
end

function ExchangeSpecialTemplate:GetCanBuyPackage()
  local rechargeIds = WelfareController.GetPopupPackages()
  for i = 1, #rechargeIds do
    local packages = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeIds[i])
    if not table.IsNullOrEmpty(packages) then
      local package = packages[1]
      if package and package:isTimeValid() and package:canGet() and package:getCountdown() > 1500 and self:IsActivePackage(package._serverData.id) then
        return package
      end
    end
  end
end

function ExchangeSpecialTemplate:GetShowEffectWords(curIndex)
  local template = self:GetBuildCurLevelTemplateByIndex(curIndex)
  local effectNum = template.building_effect_last[tonumber(self.effectId)] or 1
  if self.effect_word == "1" then
    return Localization:GetString("decoration_packshow_1", math.floor(effectNum * 100))
  elseif self.effect_word == "2" then
    return Localization:GetString("decoration_packshow_2", math.floor(effectNum / 60))
  else
    return ""
  end
end

ExchangeSpecialTemplate.__init = __init
ExchangeSpecialTemplate.__delete = __delete
ExchangeSpecialTemplate.InitData = InitData
return ExchangeSpecialTemplate
