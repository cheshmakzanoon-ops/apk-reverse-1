local LWResourceLackManager = BaseClass("LWResourceLackManager")
local LWResourceLackTemplate = require("DataCenter.LWResourceLack.LWResourceLackTemplate")

function LWResourceLackManager:__init()
  self.res_map = {}
  self.good_map = {}
  self.resource_item_map = {}
  self.special_res_map = {}
  self.all_map = {}
  self.goldSecondConfirmRequireGoldCount = nil
  self.goldSecondConfirmRequireMainLevel = nil
  self.initialized = false
end

function LWResourceLackManager:__delete()
  self.initialized = false
  self.goldSecondConfirmRequireGoldCount = nil
  self.goldSecondConfirmRequireMainLevel = nil
  self.all_map = nil
end

function LWResourceLackManager:CleanData()
  self.res_map = {}
  self.good_map = {}
  self.resource_item_map = {}
  self.special_res_map = {}
  self.all_map = {}
  self.initialized = false
end

function LWResourceLackManager:Init()
  local theSeasonIndex = SeasonUtil.GetSeason()
  self.res_map = {}
  self.good_map = {}
  self.resource_item_map = {}
  self.special_res_map = {}
  self.all_map = {}
  LocalController:instance():visitTable(TableName.LW_Res_Lack_Tips, function(id, lineData)
    local season_condition = lineData.season_condition
    if season_condition ~= nil and season_condition ~= "" and season_condition ~= 0 then
      local theType = type(season_condition)
      if theType == "number" then
        if theSeasonIndex ~= season_condition then
          return
        end
      elseif theType == "string" then
        local theMin, theMax = string.match(season_condition, "([^-]+)-([^-]+)")
        local sMin, dayMin, sMax, dayMax = string.match(season_condition, "^(%d+),(%d+)%-(%d+),(%d+)$")
        if theMin and theMax and tonumber(theMin) and tonumber(theMax) then
          if theSeasonIndex < toInt(theMin) or theSeasonIndex > toInt(theMax) then
            return
          end
        elseif sMin and dayMin and sMax and dayMax and tonumber(sMin) and tonumber(sMax) and tonumber(dayMin) and tonumber(dayMax) then
          if theSeasonIndex < toInt(sMin) or theSeasonIndex > toInt(sMax) then
            return
          end
          local seasonDay = SeasonUtil.GetSeasonDay()
          if theSeasonIndex == toInt(sMin) and seasonDay < toInt(dayMin) or theSeasonIndex == toInt(sMax) and seasonDay > toInt(dayMax) then
            return
          end
        else
          return
        end
      end
    end
    local template = LWResourceLackTemplate.New()
    template:InitData(lineData)
    if 0 < template.res then
      if not self.res_map[template.res] then
        self.res_map[template.res] = {}
      end
      local t = self.res_map[template.res]
      table.insert(t, template)
    elseif 0 < template.goods then
      if not self.good_map[template.goods] then
        self.good_map[template.goods] = {}
      end
      local t = self.good_map[template.goods]
      table.insert(t, template)
    elseif 0 < template.res_item then
      if not self.resource_item_map[template.res_item] then
        self.resource_item_map[template.res_item] = {}
      end
      local t = self.resource_item_map[template.res_item]
      table.insert(t, template)
    elseif 0 < template.special_trigger then
      if not self.special_res_map[template.special_trigger] then
        self.special_res_map[template.special_trigger] = {}
      end
      local t = self.special_res_map[template.special_trigger]
      table.insert(t, template)
    end
    self.all_map[id] = template
  end)
  self.initialized = true
end

function LWResourceLackManager:GetResourceWay(resourceType)
  if not self.initialized then
    self:Init()
  end
  return self.res_map[resourceType]
end

function LWResourceLackManager:GetGoodsWay(id)
  if not self.initialized then
    self:Init()
  end
  return self.good_map[id]
end

function LWResourceLackManager:GetResourceItemWay(id)
  if not self.initialized then
    self:Init()
  end
  return self.resource_item_map[id]
end

function LWResourceLackManager:GetSpecialResWay(type)
  if not self.initialized then
    self:Init()
  end
  return self.special_res_map[type]
end

function LWResourceLackManager:SetReceiveHangUpRewardSilentlySign()
  self.receiveHangUpRewardSilently = true
end

function LWResourceLackManager:GetReceiveHangUpRewardSilentlySign()
  return self.receiveHangUpRewardSilently
end

function LWResourceLackManager:ResetReceiveHangUpRewardSilentlySign()
  self.receiveHangUpRewardSilently = false
end

function LWResourceLackManager:IsShowGoldSecondConfirmByGoldNum(goldNum)
  if not self:HasShownGoldSecondConfirmToday() then
    if self.goldSecondConfirmRequireMainLevel == nil then
      self.goldSecondConfirmRequireMainLevel = LuaEntry.DataConfig:TryGetNum("diamond_lack_tips", "k1", 0)
    end
    local mainLv = DataCenter.BuildManager.MainLv
    if mainLv and mainLv >= self.goldSecondConfirmRequireMainLevel then
      if self.goldSecondConfirmRequireGoldCount == nil then
        self.goldSecondConfirmRequireGoldCount = LuaEntry.DataConfig:TryGetNum("diamond_lack_tips", "k2", 0)
      end
      if goldNum and goldNum >= self.goldSecondConfirmRequireGoldCount then
        return true
      end
    end
  end
  return false
end

function LWResourceLackManager:IsShowGoldSecondConfirmByLackResource(lackResource)
  local spendGold = 0
  if lackResource then
    for k, v in pairs(lackResource) do
      local need = v - LuaEntry.Resource:GetCntByResType(k)
      spendGold = spendGold + CommonUtil.GetResGoldByType(k, need)
    end
  end
  return self:IsShowGoldSecondConfirmByGoldNum(spendGold)
end

function LWResourceLackManager:HasShownGoldSecondConfirmToday()
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local key = "gold_cost_second_confirm_today_" .. tostring(todayZero)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function LWResourceLackManager:SetHasShownGoldSecondConfirmToday()
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local key = "gold_cost_second_confirm_today_" .. tostring(todayZero)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function LWResourceLackManager:GetTemplateById(id)
  if self.all_map then
    return self.all_map[id]
  end
end

function LWResourceLackManager:GetType59FakeLackData(param)
  local template = LWResourceLackTemplate.New()
  template:InitType59FakeLackData(param)
  return template
end

return LWResourceLackManager
