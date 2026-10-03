local ResLackManager = BaseClass("ResLackManager")
local ResLackTipsTemplate = require("DataCenter.ResLackTips.ResLackTipsTemplate")
local ResLackItem_CommercialOrder = require("DataCenter.ResLackTips.ResLackItem_CommercialOrder")
local ResLackItem_BuildBuilding = require("DataCenter.ResLackTips.ResLackItem_BuildBuilding")
local ResLackItem_RocketOrder = require("DataCenter.ResLackTips.ResLackItem_RocketOrder")
local ResLackItem_UpgradeBuilding = require("DataCenter.ResLackTips.ResLackItem_UpgradeBuilding")
local ResLackItem_PickUpGarbage = require("DataCenter.ResLackTips.ResLackItem_PickUpGarbage")
local ResLackItem_AttackMonster = require("DataCenter.ResLackTips.ResLackItem_AttackMonster")
local ResLackItem_CollectResInWorld = require("DataCenter.ResLackTips.ResLackItem_CollectResInWorld")
local ResLackItem_CollectResInMainCity = require("DataCenter.ResLackTips.ResLackItem_CollectResInMainCity")
local ResLackItem_LoesCamp = require("DataCenter.ResLackTips.ResLackItem_LoesCamp")
local ResLackItem_Science = require("DataCenter.ResLackTips.ResLackItem_Science")
local ResLackItem_ResourceBagUse = require("DataCenter.ResLackTips.ResLackItem_ResourceBagUse")
local ResLackItem_ResourceBagBuy = require("DataCenter.ResLackTips.ResLackItem_ResourceBagBuy")
local ResLackItem_GoRadarTask = require("DataCenter.ResLackTips.ResLackItem_GoRadarTask")
local ResLackItem_HeroStation = require("DataCenter.ResLackTips.ResLackItem_HeroStation")
local ResLackItem_HeroStationUpgrade = require("DataCenter.ResLackTips.ResLackItem_HeroStationUpgrade")
local ResLackItem_HeroStationSkill = require("DataCenter.ResLackTips.ResLackItem_HeroStationSkill")
local ResLackItem_Quest = require("DataCenter.ResLackTips.ResLackItem_Quest")
local ResLackItem_BuyGiftPackage = require("DataCenter.ResLackTips.ResLackItem_BuyGiftPackage")
local ResLackItem_CommercialOrderComplete = require("DataCenter.ResLackTips.ResLackItem_CommercialOrderComplete")
local ResLackItem_GolloesOrderComplete = require("DataCenter.ResLackTips.ResLackItem_GolloesOrderComplete")
local ResLackItem_KonbiniOrderComplete = require("DataCenter.ResLackTips.ResLackItem_KonbiniOrderComplete")
local ReslackItem_AddSpeedBuild = require("DataCenter.ResLackTips.ReslackItem_AddSpeedBuild")
local ReslackItem_CapacityUseItem = require("DataCenter.ResLackTips.ReslackItem_CapacityUseItem")
local ReslackItem_KonbiniFree = require("DataCenter.ResLackTips.ReslackItem_KonbiniFree")
local ReslackItem_ResourceItemIsFree = require("DataCenter.ResLackTips.ReslackItem_ResourceItemIsFree")
local ReslackItem_ResourceItemIsWork = require("DataCenter.ResLackTips.ReslackItem_ResourceItemIsWork")
local ResLackItem_LockedLandLock = require("DataCenter.ResLackTips.ResLackItem_LockedLandLock")
local ResLackItem_LandLockChest = require("DataCenter.ResLackTips.ResLackItem_LandLockChest")
local ResLackItem_LockedLandLockUncheck = require("DataCenter.ResLackTips.ResLackItem_LockedLandLockUncheck")
local ResLackItem_BuildBuyItem = require("DataCenter.ResLackTips.ResLackItem_BuildBuyItem")
local ResLackItem_UsePaperItem = require("DataCenter.ResLackTips.ResLackItem_UsePaperItem")
local ResLackItem_BuyGiftNew = require("DataCenter.ResLackTips.ResLackItem_BuyGiftNew")
local ReslackItem_CommonShop = require("DataCenter.ResLackTips.ReslackItem_CommonShop")
local ReslackItem_ActDaily = require("DataCenter.ResLackTips.ReslackItem_ActDaily")
local ResLackItem_Explore = require("DataCenter.ResLackTips.ResLackItem_Explore")
local ResLackItem_BuyPveStamina = require("DataCenter.ResLackTips.ResLackItem_BuyPveStamina")
local ResLackItem_NpcPveStamina = require("DataCenter.ResLackTips.ResLackItem_NpcPveStamina")
local ResLackItem_UseBuildGoods = require("DataCenter.ResLackTips.ResLackItem_UseBuildGoods")
local ResLackItem_StorageShop = require("DataCenter.ResLackTips.ResLackItem_StorageShop")
local ResLackItem_GoWindowAllianceBat = require("DataCenter.ResLackTips.ResLackItem_GoWindowAllianceBat")
local ResLackItem_GoActWin = require("DataCenter.ResLackTips.ResLackItem_GoActWin")
local ResLackItem_ActAllianceArmy = require("DataCenter.ResLackTips.ResLackItem_ActAllianceArmy")
local ResLackItem_BuyGiftResNew = require("DataCenter.ResLackTips.ResLackItem_BuyGiftResNew")

function ResLackManager:__init()
  self._lack_list = {}
  self._lack_listNew = {}
  self.templateDict = nil
  self.tipToTemplateDict = nil
end

function ResLackManager:InitAllTemplates()
  if self.templateDict then
    return
  end
  self.templateDict = {}
  self.tipToTemplateDict = {}
  LocalController:instance():visitTable(TableName.LW_Res_Lack_Tips, function(id, lineData)
    local template = ResLackTipsTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template
    if self.tipToTemplateDict[template.tips] == nil then
      self.tipToTemplateDict[template.tips] = {}
    end
    table.insert(self.tipToTemplateDict[template.tips], template)
  end)
end

function ResLackManager:GetTemplate(id)
  self:InitAllTemplates()
  return self.templateDict[id]
end

function ResLackManager:GetTemplateByTip(tip)
  local templates = self:GetTemplatesByTip(tip)
  if 0 < #templates then
    return templates[1]
  else
    return nil
  end
end

function ResLackManager:GetTemplatesByTip(tip)
  self:InitAllTemplates()
  return self.tipToTemplateDict[tip] or {}
end

function ResLackManager:CheckResAddWay(_resType, _needCnt, isResItem)
  self._lack_list = {}
  self._lack_listNew = {}
  local mainLv = DataCenter.BuildManager.MainLv
  local playerLv = DataCenter.PlayerLevelManager:GetLevel()
  LocalController:instance():visitTable(TableName.LW_Res_Lack_Tips, function(id, lineData)
    local restype = lineData:getValue("res")
    local baseLevel = lineData:getValue("base")
    local good = lineData:getValue("goods")
    local resTypeOk = false
    local goodTypeOk = false
    local baseLevelOk = true
    local playerLevelOk = true
    if _resType == tonumber(restype) then
      resTypeOk = true
    end
    if _resType == toInt(good) then
      local tips = lineData:getValue("tips")
      if tips == 27 then
        local para1 = lineData:getValue("para1")
        local data = GiftPackManager.getFirstShowTypeGiftPack(para1)
        if data ~= nil then
          goodTypeOk = true
        end
      else
        goodTypeOk = true
      end
    end
    local baseLevelArray = string.split(baseLevel, "-")
    if table.count(baseLevelArray) == 2 then
      local minLevel = tonumber(baseLevelArray[1])
      local maxLevel = tonumber(baseLevelArray[2])
      if minLevel > mainLv or maxLevel < mainLv then
        baseLevelOk = false
      end
    end
    if (resTypeOk or goodTypeOk) and baseLevelOk and playerLevelOk then
      self:AddResItemToList(lineData, _resType, _needCnt, isResItem)
    end
  end)
  if table.count(self._lack_list) > 0 then
    local lackGroupList = {}
    for i, v in ipairs(self._lack_list) do
      local a = v:GetGroup()
      if a ~= "" then
        if lackGroupList[tonumber(v:GetGroup())] == nil then
          lackGroupList[tonumber(v:GetGroup())] = {}
        end
        table.insert(lackGroupList[tonumber(v:GetGroup())], v)
      else
        table.insert(self._lack_listNew, v)
      end
    end
    for k, v in pairs(lackGroupList) do
      table.sort(v, function(a, b)
        if a:GetOrder() < b:GetOrder() then
          return true
        elseif a:GetOrder() == b:GetOrder() then
          return false
        end
        return false
      end)
    end
    for i, v in pairs(lackGroupList) do
      table.insert(self._lack_listNew, v[1])
    end
    table.sort(self._lack_listNew, function(item1, item2)
      if item1:GetOrder() < item2:GetOrder() then
        return true
      elseif item1:GetOrder() == item2:GetOrder() then
        return false
      end
      return false
    end)
    for i = 1, #self._lack_listNew do
      if self._lack_listNew[i]._config.tips == 9 and DataCenter.GroceryStoreOrderDataManager:HasCanSubmitOrder() then
        table.insert(self._lack_listNew, 1, table.remove(self._lack_listNew, i))
        break
      end
      if self._lack_listNew[i]._config.tips == 1 then
        local state = DataCenter.ResidentOrderDataManager:GetBusinessBubbleState()
        if state == BusinessBubbleState.Yes then
          table.insert(self._lack_listNew, 1, table.remove(self._lack_listNew, i))
          break
        end
      end
    end
  end
  if _resType == ResourceType.Metal or _resType == ResourceType.Water or _resType == ResourceType.Electricity or _resType == ResourceType.Food or _resType == ResourceType.FORMATION_STAMINA or _resType == ResourceType.PVE_STAMINA or isResItem then
    self:CheckExtraRes(_resType, isResItem)
  end
  return self._lack_listNew
end

function ResLackManager:GetResAddWayByIndex(index)
  if index < 1 or index > #self._lack_list then
    return nil
  end
  return self._lack_list[index]
end

function ResLackManager:AddResItemToList(lineData, _resType, _needCnt, isResItem)
  local tips = lineData:getValue("tips")
  local reslackitem
  if tips == 1 then
    reslackitem = ResLackItem_CommercialOrder.New(lineData:getValue("id"))
  elseif tips == 2 then
    reslackitem = ResLackItem_BuildBuilding.New(lineData:getValue("id"))
  elseif tips == 3 then
    reslackitem = ResLackItem_RocketOrder.New(lineData:getValue("id"))
  elseif tips == 4 then
    reslackitem = ResLackItem_UpgradeBuilding.New(lineData:getValue("id"))
  elseif tips == 5 then
    reslackitem = ResLackItem_PickUpGarbage.New(lineData:getValue("id"))
  elseif tips == 6 then
    reslackitem = ResLackItem_AttackMonster.New(lineData:getValue("id"))
  elseif tips == 7 then
    reslackitem = ResLackItem_CollectResInWorld.New(lineData:getValue("id"))
  elseif tips == 8 then
    reslackitem = ResLackItem_CollectResInMainCity.New(lineData:getValue("id"))
  elseif tips == 9 then
    reslackitem = ResLackItem_LoesCamp.New(lineData:getValue("id"))
  elseif tips == 10 then
    reslackitem = ResLackItem_Science.New(lineData:getValue("id"))
  elseif tips == 11 then
    reslackitem = ResLackItem_ResourceBagUse.New(lineData:getValue("id"))
  elseif tips == 12 then
    reslackitem = ResLackItem_ResourceBagBuy.New(lineData:getValue("id"))
  elseif tips == 16 then
    reslackitem = ResLackItem_GoRadarTask.New(lineData:getValue("id"))
  elseif tips == 21 then
    reslackitem = ResLackItem_HeroStation.New(lineData:getValue("id"))
  elseif tips == 22 then
    reslackitem = ResLackItem_HeroStationUpgrade.New(lineData:getValue("id"))
  elseif tips == 23 then
    reslackitem = ResLackItem_HeroStationSkill.New(lineData:getValue("id"))
  elseif tips == 26 then
    reslackitem = ResLackItem_Quest.New(lineData:getValue("id"))
  elseif tips == 27 then
    reslackitem = ResLackItem_BuyGiftPackage.New(lineData:getValue("id"))
  elseif tips == 28 then
    reslackitem = ResLackItem_CommercialOrderComplete.New(lineData:getValue("id"))
  elseif tips == 29 then
    reslackitem = ResLackItem_GolloesOrderComplete.New(lineData:getValue("id"))
  elseif tips == 30 then
    reslackitem = ResLackItem_KonbiniOrderComplete.New(lineData:getValue("id"))
  elseif tips == 33 then
    reslackitem = ReslackItem_AddSpeedBuild.New(lineData:getValue("id"))
  elseif tips == 34 then
    reslackitem = ReslackItem_CapacityUseItem.New(lineData:getValue("id"))
  elseif tips == 35 then
    reslackitem = ReslackItem_KonbiniFree.New(lineData:getValue("id"))
  elseif tips == 36 then
    reslackitem = ReslackItem_ResourceItemIsFree.New(lineData:getValue("id"))
  elseif tips == 37 then
    reslackitem = ReslackItem_ResourceItemIsWork.New(lineData:getValue("id"))
  elseif tips == 38 then
    reslackitem = ResLackItem_LockedLandLock.New(lineData:getValue("id"))
  elseif tips == 39 then
    reslackitem = ResLackItem_LandLockChest.New(lineData:getValue("id"))
  elseif tips == 40 then
    reslackitem = ResLackItem_LockedLandLockUncheck.New(lineData:getValue("id"))
  elseif tips == 41 then
    reslackitem = ResLackItem_BuildBuyItem.New(lineData:getValue("id"))
  elseif tips == 42 then
    reslackitem = ResLackItem_UsePaperItem.New(lineData:getValue("id"))
  elseif tips == 44 then
    reslackitem = ResLackItem_BuyGiftNew.New(lineData:getValue("id"))
  elseif tips == 45 then
    reslackitem = ReslackItem_CommonShop.New(lineData:getValue("id"))
  elseif tips == 46 then
    reslackitem = ReslackItem_ActDaily.New(lineData:getValue("id"))
  elseif tips == 47 then
    reslackitem = ResLackItem_Explore.New(lineData:getValue("id"))
  elseif tips == 48 then
    reslackitem = ResLackItem_BuyPveStamina.New(lineData:getValue("id"))
  elseif tips == 49 then
    reslackitem = ResLackItem_NpcPveStamina.New(lineData:getValue("id"))
  elseif tips == 52 then
    reslackitem = ResLackItem_UseBuildGoods.New(lineData:getValue("id"))
  elseif tips == 64 then
    reslackitem = ResLackItem_StorageShop.New(lineData:getValue("id"))
  elseif tips == 75 then
    reslackitem = ResLackItem_GoWindowAllianceBat.New(lineData:getValue("id"))
  elseif tips == 78 then
    reslackitem = ResLackItem_GoActWin.New(lineData:getValue("id"))
  elseif tips == 88 then
    reslackitem = ResLackItem_ActAllianceArmy.New(lineData:getValue("id"))
  end
  if reslackitem == nil then
    return
  end
  local isOk = reslackitem:CheckIsOk(_resType, _needCnt, isResItem)
  if isOk then
    self._lack_list[#self._lack_list + 1] = reslackitem
  end
end

function ResLackManager:CheckExtraRes(_resType, isResItem)
  local reslackitem = ResLackItem_BuyGiftResNew.New()
  local isOk = reslackitem:CheckIsOk(_resType, isResItem)
  if isOk then
    table.insert(self._lack_listNew, reslackitem)
  end
end

function ResLackManager:SetRefreshParam(param)
  self.param = param
end

function ResLackManager:GetRefreshParam()
  local param = self.param
  self.param = nil
  return param
end

return ResLackManager
