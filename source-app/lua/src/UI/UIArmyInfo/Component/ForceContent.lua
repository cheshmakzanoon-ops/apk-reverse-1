local ForceContent = BaseClass("ForceContent", UIBaseContainer)
local base = UIBaseContainer
local TotalDetailItem = require("UI.UIArmyInfo.Component.TotalDetailItem")
local TroopItem = require("UI.UIArmyInfo.Component.TroopItem")
local TurrentItem = require("UI.UIArmyInfo.Component.TurrentItem")
local total_freeSolider_scrollView_path = "LayerGo/TotalContent"
local total_turrent_scrollView_path = "LayerGo/TurretContent"
local total_Troop_scrollView_path = "LayerGo/TroopContent"
local tabTotal_path = "Tab/TabTotal"
local tabInside_path = "Tab/TabInside"
local tabOutside_path = "Tab/TabOutside"
local tabTurret_path = "Tab/TabTurret"
local tabTotal_txt_path = "Tab/TabTotal/Text_Total"
local tabInside_txt_path = "Tab/TabInside/Text_Inside"
local tabOutside_txt_path = "Tab/TabOutside/Text_Outside"
local tabTurret_txt_path = "Tab/TabTurret/Text_Turret"
local tabSelect_img = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_tab_open.png"
local tabUnSelect_img = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_tab_close.png"
local totalSolider_path = "LayerGo/TotalContent/TotalDes/Slider/TotalNum"
local totalSolider_des_path = "LayerGo/TotalContent/TotalDes/"
local solider_path = "LayerGo/TotalContent/TotalDes/Slider"
local solider_progress_path = "LayerGo/TotalContent/TotalDes/Slider/Fill Area/Fill"
local solider_full_path = "LayerGo/TotalContent/TotalDes/Slider/Full"
local empty_txt_path = "EmptyText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.slider = self:AddComponent(UISlider, solider_path)
  self.solider_progress = self:AddComponent(UIImage, solider_progress_path)
  self.solider_full = self:AddComponent(UIImage, solider_full_path)
  self.tabTotal_btn = self:AddComponent(UIButton, tabTotal_path)
  self.tabInside_btn = self:AddComponent(UIButton, tabInside_path)
  self.tabOutside_btn = self:AddComponent(UIButton, tabOutside_path)
  self.tabTurret_btn = self:AddComponent(UIButton, tabTurret_path)
  self.tabTotal_img = self:AddComponent(UIImage, tabTotal_path)
  self.tabInside_img = self:AddComponent(UIImage, tabInside_path)
  self.tabOutside_img = self:AddComponent(UIImage, tabOutside_path)
  self.tabTurret_img = self:AddComponent(UIImage, tabTurret_path)
  self.tabTotal_txt = self:AddComponent(UIText, tabTotal_txt_path)
  self.tabInside_txt = self:AddComponent(UIText, tabInside_txt_path)
  self.tabOutside_txt = self:AddComponent(UIText, tabOutside_txt_path)
  self.tabTurret_txt = self:AddComponent(UIText, tabTurret_txt_path)
  self.totalSolider = self:AddComponent(UIText, totalSolider_path)
  self.totalSolider_des = self:AddComponent(UIText, totalSolider_des_path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.total_scrollView = self:AddComponent(UIScrollView, total_freeSolider_scrollView_path)
  self.turrent_scrollView = self:AddComponent(UIScrollView, total_turrent_scrollView_path)
  self.troop_scrollView = self:AddComponent(UIScrollView, total_Troop_scrollView_path)
  self.total_scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.total_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.turrent_scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.turrent_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.troop_scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.troop_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.tabTotal_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TroopType.Total)
  end)
  self.tabInside_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TroopType.Inside)
  end)
  self.tabOutside_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TroopType.Outside)
  end)
  self.tabTurret_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TroopType.Turret)
  end)
end

local function ComponentDestroy(self)
  self.total_freeSolider_title = nil
  self.itemList = nil
  self.cells = nil
  self.scrollView = nil
  self.total_content = nil
  self.turrent_content = nil
  self.troop_content = nil
  self.slider = nil
  self.solider_progress = nil
  self.solider_full = nil
end

local function DataDefine(self)
  self.cellList = {}
  self.item = nil
  self.troopType = TroopType.Total
end

local function DataDestroy(self)
  self.cellList = nil
  self.item = nil
  self.troopType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self:TabClick(TroopType.Total)
  self.tabTotal_txt:SetLocalText(130068)
  self.tabInside_txt:SetLocalText(GameDialogDefine.DEFENCE_FORMATION)
  self.tabOutside_txt:SetLocalText(300057)
  self.tabTurret_txt:SetLocalText(300626)
end

local function InitFreeSolider(self, itemList)
  self:ClearScroll()
  if #self.itemList > 0 then
    self.scrollView:SetTotalCount(#itemList)
    self.scrollView:RefillCells()
    self.empty_txt:SetText("")
  elseif self.troopType == TroopType.Turret then
    self.empty_txt:SetLocalText(129069)
  elseif self.troopType == TroopType.Total then
    self.empty_txt:SetLocalText(129070)
  else
    self.empty_txt:SetLocalText(129068)
  end
end

local function ClearScroll(self)
  self.cells = {}
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(self.item)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  self.cells[index] = self.scrollView:AddComponent(self.item, itemObj)
  local param = {}
  param.key = self.itemList[index].key
  param.value = self.itemList[index].value
  param.index = index
  param.troopType = self.troopType
  self.cells[index]:ReInit(param)
end

local function OnItemMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scrollView:RemoveComponent(itemObj.name, self.item)
end

local function TabClick(self, troopType)
  if troopType == TroopType.Total then
    self.troopType = TroopType.Total
    self.tabTotal_img:LoadSprite(tabSelect_img)
    self.tabInside_img:LoadSprite(tabUnSelect_img)
    self.tabOutside_img:LoadSprite(tabUnSelect_img)
    self.tabTurret_img:LoadSprite(tabUnSelect_img)
    self.total_scrollView:SetActive(true)
    self.turrent_scrollView:SetActive(false)
    self.troop_scrollView:SetActive(false)
    self.scrollView = self.total_scrollView
    self.item = TotalDetailItem
    self.cells = nil
    self.cellList = {}
    self.itemList = self:GetTotalSolider()
    self:InitFreeSolider(self.itemList)
  elseif troopType == TroopType.Inside then
    self.troopType = TroopType.Inside
    self.tabTotal_img:LoadSprite(tabUnSelect_img)
    self.tabInside_img:LoadSprite(tabSelect_img)
    self.tabOutside_img:LoadSprite(tabUnSelect_img)
    self.tabTurret_img:LoadSprite(tabUnSelect_img)
    self.total_scrollView:SetActive(false)
    self.turrent_scrollView:SetActive(false)
    self.troop_scrollView:SetActive(true)
    self.scrollView = self.troop_scrollView
    self.item = TroopItem
    self.cells = nil
    self.cellList = {}
    self.itemList = self:GetFormationList()
    self:InitFreeSolider(self.itemList)
  elseif troopType == TroopType.Outside then
    self.troopType = TroopType.Outside
    self.tabTotal_img:LoadSprite(tabUnSelect_img)
    self.tabInside_img:LoadSprite(tabUnSelect_img)
    self.tabOutside_img:LoadSprite(tabSelect_img)
    self.tabTurret_img:LoadSprite(tabUnSelect_img)
    self.total_scrollView:SetActive(false)
    self.turrent_scrollView:SetActive(false)
    self.troop_scrollView:SetActive(true)
    self.scrollView = self.troop_scrollView
    self.item = TroopItem
    self.cells = nil
    self.cellList = {}
    self.itemList = self:GetOutsideFormation()
    self:InitFreeSolider(self.itemList)
  elseif troopType == TroopType.Turret then
    self.troopType = TroopType.Turret
    self.tabTotal_img:LoadSprite(tabUnSelect_img)
    self.tabInside_img:LoadSprite(tabUnSelect_img)
    self.tabOutside_img:LoadSprite(tabUnSelect_img)
    self.tabTurret_img:LoadSprite(tabSelect_img)
    self.total_scrollView:SetActive(false)
    self.turrent_scrollView:SetActive(true)
    self.troop_scrollView:SetActive(false)
    self.scrollView = self.turrent_scrollView
    self.item = TurrentItem
    self.cells = nil
    self.cellList = {}
    self.itemList = self:GetArrowTowerData()
    self:InitFreeSolider(self.itemList)
  end
end

local function GetTotalSolider(self)
  local totalSoldiers = DataCenter.ArmyManager:GetTotalMarchAndFreeArmyNum()
  local maxSoldiers = {}
  local soliderNum = self.view.ctrl:GetTotalArmyNum()
  table.walk(totalSoldiers, function(k, v)
    if 0 < v then
      local param = {}
      param.key = k
      param.value = v
      table.insert(maxSoldiers, param)
    end
  end)
  table.sort(maxSoldiers, function(a, b)
    local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.key)
    local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
    if aData.level > bData.level then
      return true
    elseif aData.level == bData.level then
      if aData.arm > bData.arm then
        return true
      end
      return false
    end
  end)
  local trainNum = 0
  local armyBuilds = BarracksBuild
  for _, v in pairs(armyBuilds) do
    trainNum = trainNum + DataCenter.ArmyManager:GetQueueArmyNum(v)
  end
  if 0 < trainNum then
    local param = {}
    param.key = ForceTypeTrainAndUpgrade
    param.value = trainNum
    table.insert(maxSoldiers, param)
  end
  local injured = DataCenter.HospitalManager:GetHospitalCount()
  if 0 < injured then
    local param = {}
    param.key = ForceTypeInjured
    param.value = injured
    table.insert(maxSoldiers, param)
  end
  self.totalSolider_des.gameObject:SetActive(true)
  local max = DataCenter.ArmyManager:GetArmyNumMax()
  self.totalSolider:SetText(string.GetFormattedSeperatorNum(soliderNum) .. "/" .. string.GetFormattedSeperatorNum(max))
  self.totalSolider_des:SetLocalText(130068)
  local percent = 1.0 * soliderNum / max
  percent = math.min(1.0, math.max(0, percent))
  self.slider:SetValue(percent)
  self.solider_full:SetActive(soliderNum >= max)
  self.solider_progress:SetActive(soliderNum < max)
  return maxSoldiers
end

local function GetfreeSolider(self)
  local freeSoldiers = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
  local maxSoldiers = {}
  local soliderNum = self.view.ctrl:GetTotalArmyNum()
  table.walk(freeSoldiers, function(k, v)
    if 0 < v then
      local param = {}
      param.key = k
      param.value = v
      table.insert(maxSoldiers, param)
    end
  end)
  table.sort(maxSoldiers, function(a, b)
    local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.key)
    local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
    if aData.level > bData.level then
      return true
    elseif aData.level == bData.level then
      if aData.arm > bData.arm then
        return true
      end
      return false
    end
  end)
  self.totalSolider_des.gameObject:SetActive(true)
  local max = DataCenter.ArmyManager:GetArmyNumMax()
  self.totalSolider:SetText(string.GetFormattedSeperatorNum(soliderNum) .. "/" .. string.GetFormattedSeperatorNum(max))
  self.totalSolider_des:SetLocalText(130068)
  local percent = 1.0 * soliderNum / max
  percent = math.min(1.0, math.max(0, percent))
  self.slider:SetValue(percent)
  self.solider_full:SetActive(soliderNum >= max)
  self.solider_progress:SetActive(soliderNum < max)
  return maxSoldiers
end

local function GetFormationList(self)
  local allMarch = {}
  local freeHeroList = self:GetFreeHeroListExceptFormation()
  local formation = DataCenter.ArmyFormationDataManager:GetDefenceArmyFormationData()
  local usedHeroes = {}
  local freeSoldiers = self:GetfreeSolider()
  local maxDefenceFormationNum = DataCenter.DefenceWallDataManager:GetMaxDefenceNum()
  table.walksort(formation, function(leftKey, rightKey)
    return formation[leftKey].index < formation[rightKey].index
  end, function(k, v)
    if v.index > maxDefenceFormationNum then
      return
    end
    local maxHeroNum = MarchUtil.GetMaxHeroValueByDefendFormationIndex(v.index)
    local formationHeroes = {}
    local formationSoliders = {}
    table.walk(v.heroes, function(a, b)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
      if heroData ~= nil and heroData.state == ArmyFormationState.Free then
        formationHeroes[heroData.heroId] = heroData
      end
    end)
    local curHeroNum = table.count(formationHeroes)
    for i = curHeroNum, maxHeroNum - 1 do
      for k1, v1 in pairs(freeHeroList) do
        local heroData = v1
        if heroData ~= nil and formationHeroes[heroData.heroId] == nil and usedHeroes[heroData.heroId] == nil then
          formationHeroes[heroData.heroId] = heroData
          usedHeroes[heroData.heroId] = heroData
          break
        end
      end
    end
    local temp = {}
    if next(formationHeroes) then
      for p, q in pairs(formationHeroes) do
        temp[q.uuid] = p
      end
    end
    local maxSoliderNum = MarchUtil.GetDefenceFormationMaxCanAddSoldierNum(temp)
    local totalNum = 0
    local soldiers = {}
    for a, b in pairs(freeSoldiers) do
      if b.value ~= 0 then
        if maxSoliderNum <= b.value then
          soldiers[b.key] = math.floor(maxSoliderNum)
          b.value = b.value - maxSoliderNum
          totalNum = totalNum + math.floor(maxSoliderNum)
          maxSoliderNum = 0
          break
        else
          soldiers[b.key] = math.floor(b.value)
          totalNum = totalNum + math.floor(b.value)
          maxSoliderNum = maxSoliderNum - b.value
          b.value = 0
        end
      end
    end
    local tempFormation = {}
    tempFormation.heroes = formationHeroes
    tempFormation.maxSoliderNum = math.floor(totalNum)
    tempFormation.soldiers = soldiers
    local param = {}
    param.key = k
    param.value = tempFormation
    table.insert(allMarch, param)
  end)
  return allMarch
end

local function GetOutsideFormation(self)
  local allMarch = {}
  local allianceId = LuaEntry.Player.allianceId
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
  if selfMarch ~= nil then
    table.walk(selfMarch, function(k, v)
      local param = {}
      param.key = k
      param.value = v:GetFirstArmyInfo()
      table.insert(allMarch, param)
    end)
  end
  return allMarch
end

local function GetArrowTowerData(self)
  local allTowerData = {}
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_ARROW_TOWER)
  for k, v in pairs(list) do
    local param = {}
    param.key = v.uuid
    param.value = v
    table.insert(allTowerData, param)
  end
  return allTowerData
end

local function GetFreeHeroListExceptFormation(self)
  local allFreeHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local formation = DataCenter.ArmyFormationDataManager:GetDefenceArmyFormationData()
  local heroesInFormation = {}
  local freeHeroes = {}
  for k, v in pairs(formation) do
    for a, b in pairs(v.heroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
      if heroData ~= nil and heroesInFormation[heroData.heroId] == nil and heroData.state == ArmyFormationState.Free then
        heroesInFormation[heroData.heroId] = a
      end
    end
  end
  table.walk(allFreeHeroes, function(k, v)
    if v.state == ArmyFormationState.Free and heroesInFormation[k] == nil then
      table.insert(freeHeroes, v)
    end
  end)
  table.sort(freeHeroes, function(heroA, heroB)
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end)
  return freeHeroes
end

ForceContent.OnCreate = OnCreate
ForceContent.OnDestroy = OnDestroy
ForceContent.OnDisable = OnDisable
ForceContent.ComponentDefine = ComponentDefine
ForceContent.ComponentDestroy = ComponentDestroy
ForceContent.DataDefine = DataDefine
ForceContent.DataDestroy = DataDestroy
ForceContent.OnAddListener = OnAddListener
ForceContent.OnRemoveListener = OnRemoveListener
ForceContent.ReInit = ReInit
ForceContent.ShowTotalContent = ShowTotalContent
ForceContent.ClearScroll = ClearScroll
ForceContent.OnItemMoveIn = OnItemMoveIn
ForceContent.OnItemMoveOut = OnItemMoveOut
ForceContent.InitFreeSolider = InitFreeSolider
ForceContent.TabClick = TabClick
ForceContent.GetFormationList = GetFormationList
ForceContent.GetOutsideFormation = GetOutsideFormation
ForceContent.GetfreeSolider = GetfreeSolider
ForceContent.GetArrowTowerData = GetArrowTowerData
ForceContent.GetFreeHeroListExceptFormation = GetFreeHeroListExceptFormation
ForceContent.GetTotalSolider = GetTotalSolider
return ForceContent
