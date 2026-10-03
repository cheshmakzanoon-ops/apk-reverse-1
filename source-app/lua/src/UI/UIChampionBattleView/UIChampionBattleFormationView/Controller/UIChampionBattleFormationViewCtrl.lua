local UIChampionBattleFormationViewCtrl = BaseClass("UIChampionBattleFormationViewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleFormation)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetCurIndex(self, index)
  self.curIndex = index
end

local function GetAtkImage(self)
  return "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_attack.png"
end

local function GetAtkValue(self)
  local value = 0
  return value
end

local function GetDefImage(self)
  return "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_icon_defense.png"
end

local function GetDefValue(self)
  local value = 0
  return value
end

local function GetDefDes(self)
  local value = ""
  return value
end

local function GetAtkDes(self)
  local value = ""
  return value
end

local function GetMaxNum(self)
  local heroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= nil then
      heroes[v] = k
    end
  end)
  local asPlayerMaxSoldiers = MarchUtil.GetMaxCanAddSoldierNum(heroes, self.curIndex)
  return asPlayerMaxSoldiers
end

local function CheckMaxSoliderNum(self)
  local totalSoliderNum = self:GetTotalSoldierNum()
  local maxNum = self.maxNum
  if totalSoliderNum > maxNum then
    local totalNum = 0
    local curSoldiers = {}
    table.walk(self.curSoldiers, function(k, v)
      if 0 < v then
        local addNum = math.min(maxNum - totalNum, v)
        if 0 < addNum then
          curSoldiers[k] = addNum
          totalNum = totalNum + addNum
        end
      end
    end)
    self.curSoldiers = curSoldiers
    EventManager:GetInstance():Broadcast(EventId.ArmyFormationSave)
  end
end

local function InitData(self, index, needAutoFix)
  self.index = index
  self.needAutoFix = needAutoFix
  self.isMarch = 0
  if self.needAutoFix == 1 then
  end
  self:SetCurIndex(index)
  local buildId = MarchUtil.GetFormationBuildNameByIndex(index)
  self.formationUnLockIndex = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    Logger.Log("para 1", buildTemplate.para1)
    local vecPara1 = string.split(buildTemplate.para1, "|")
    for k, v in ipairs(vecPara1) do
      local vec1 = string.split(v, ";")
      if 2 <= #vec1 then
        self.formationUnLockIndex[tonumber(vec1[1])] = tonumber(vec1[2])
      end
    end
  end
  local info = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
  self.curHeroes = {}
  self.curSoldiers = {}
  if info ~= nil and info.formationArray ~= nil then
    local allFormations = info.formationArray
    table.walk(allFormations, function(_, v)
      if v ~= nil and v.formationId == self.index then
        table.walk(v.soldiers, function(k, v)
          local armId = tonumber(v.armsId)
          local armyConfig = DataCenter.ArmyTemplateManager:GetArmyTemplate(armId)
          if armyConfig ~= nil then
            local buildId = armyConfig.buildId
            if buildId ~= nil and buildId ~= 0 then
              local _, unlockId = DataCenter.ArmyManager:GetMaxUnLockId(buildId)
              if unlockId ~= nil and unlockId ~= "" then
                armId = tonumber(unlockId)
              end
            end
          end
          self.curSoldiers[armId] = v.total
        end)
        table.walk(v.heroes, function(k, v)
          self.curHeroes[v.index] = tonumber(v.heroUuid)
        end)
      end
    end)
  end
  self.maxNum = self:GetMaxNum()
  self:SetSoldierMax()
end

local function SetSoldierMax(self)
  self.maxSoldiers = {}
  local buildingTypes = BarracksBuild
  table.walk(buildingTypes, function(_, v)
    local _, unlockId = DataCenter.ArmyManager:GetMaxUnLockId(v)
    if unlockId ~= nil and unlockId ~= "" then
      self.maxSoldiers[toInt(unlockId)] = self.maxNum
    end
  end)
end

local function GetCurHeroData(self)
  return self.curHeroes
end

local function GetMaxHeroNum(self)
  return MarchUtil.GetMaxHeroValueByFormationIndex(self.curIndex)
end

local function GetCurCampData(self)
  local curHeroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= 0 then
      curHeroes[v] = k
    end
  end)
  return MarchUtil.GetCampAddParam(curHeroes)
end

local function GetCampRestraintData(self)
  local heroIdList = {}
  table.walk(self.curHeroes, function(k, v)
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if tempHeroData ~= nil then
      table.insert(heroIdList, tempHeroData.heroId)
    end
  end)
  return MarchUtil.GetRestraintCampAndValue(heroIdList)
end

local function GetCurrentHeroDataList(self, camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
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
  local result = {}
  for _, heroData in pairs(heroes) do
    if camp ~= nil and -1 < camp then
      local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
      if targetCamp == camp then
        table.insert(result, heroData.uuid)
      end
    else
      table.insert(result, heroData.uuid)
    end
  end
  return result
end

local function GetHeroDataByUuid(self, heroUuid)
  local data = {}
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local heroConfig = heroData:GetConfig()
  local camp = heroConfig.camp
  local rarity = heroConfig.rarity
  data.hero_rarity = HeroUtils.GetRarityIconName(rarity, true)
  data.heroUuid = heroUuid
  data.heroId = heroData.heroId
  data.qualityIndex = heroData.quality
  data.rankId = heroData:GetRank()
  data.isWaken = heroData:IsWakeUp()
  data.quality = HeroUtils.GetQualityBgInTroopsByPath(rarity, data.isWaken)
  data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
  data.level = heroData.level
  data.camp = HeroUtils.GetCampIconPath(camp)
  data.index = 0
  data.isInMarch = false
  data.rarity = rarity
  data.isSelect = false
  data.isLock = false
  data.formIndex = DataCenter.ActChampionBattleManager:GetHeroIndexInFormation(heroUuid)
  table.walk(self.curHeroes, function(k, v)
    if v == heroUuid then
      data.index = k
      data.isSelect = true
    else
      local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
      if tempHeroData ~= nil and tempHeroData.heroId == heroData.heroId then
        data.isLock = true
      end
    end
  end)
  if 0 < data.formIndex and data.formIndex ~= self.index then
    data.inDiffFormation = true
  end
  return data
end

local function SelectHeroByUuid(self, heroUuid)
  local tempIndex = 0
  local maxHeroNum = self:GetMaxHeroNum()
  for i = 1, maxHeroNum do
    if tempIndex <= 0 and self.curHeroes[i] == nil then
      tempIndex = i
    end
  end
  if 0 < tempIndex then
    self.curHeroes[tempIndex] = heroUuid
    self.maxNum = self:GetMaxNum()
    self:SetSoldierMax()
    self:OnOneKeyFillClick()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnSelectHeroSelect, heroData.heroId)
    end
    self:ShowChangeHeroWarning(heroUuid)
  else
  end
end

local function ShowChangeHeroWarning(self, heroUuid)
end

local function OnDeleteHeroByIndex(self, index)
  if self.curHeroes[index] ~= nil then
    local uuid = 0
    uuid = self.curHeroes[index]
    self.curHeroes[index] = nil
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    if tempHeroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnCancelHeroSelect, tempHeroData.heroId)
    end
    self.maxNum = self:GetMaxNum()
    self:SetSoldierMax()
    self:CheckMaxSoliderNum()
  end
end

local function GetCurrentSoliderDataList(self)
  local list = {}
  if self:NeedTakeArmy() == false then
    return list
  end
  table.walk(self.curSoldiers, function(k, v)
    local oneData = {}
    oneData.armyId = k
    oneData.name = ""
    oneData.icon = ""
    oneData.level = 1
    oneData.count = v
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
    if template ~= nil then
      oneData.icon = string.format(LoadPath.SoldierIcons, template.icon)
      oneData.name = Localization:GetString(template.name)
      oneData.level = template.level
    end
    table.insert(list, oneData)
  end)
  table.sort(list, function(a, b)
    if a.level ~= b.level then
      return a.level > b.level
    end
    return a.armyId > b.armyId
  end)
  return list
end

local function GetSoliderState(self)
  local oneData = {}
  oneData.curNum = self:GetTotalSoldierNum()
  oneData.maxNum = self.maxNum
  return oneData
end

local function GetCurrentSoldierNum(self, armyId)
  local num = 0
  if self.curSoldiers[armyId] ~= nil and 0 < self.curSoldiers[armyId] then
    num = self.curSoldiers[armyId]
  end
  return num
end

local function SetCurrentSoldierNum(self, armyId, num)
  if 0 < num then
    self.curSoldiers[armyId] = num
  else
    self.curSoldiers[armyId] = nil
  end
end

local function GetTotalSoldierNum(self)
  local count = 0
  table.walk(self.curSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function GetMaxSoldierNum(self)
  local count = 0
  table.walk(self.maxSoldiers, function(k, v)
    count = count + v
  end)
  return count
end

local function CheckMax(self, armyId, num)
  local oneMaxNum = self.maxSoldiers[armyId]
  local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
  local currentTotalNum = self:GetTotalSoldierNum()
  local restNum = currentTotalNum - oneCurrentNum
  local checkMax = math.min(oneMaxNum, num)
  local totalRest = self.maxNum - restNum
  local final = math.min(totalRest, checkMax)
  if final < 0 then
    final = 0
  end
  return final
end

local function GetCanAddHeroNum(self)
  local heroList = {}
  for k, v in pairs(self.curHeroes) do
    if v ~= nil and v ~= 0 then
      heroList[v] = k
    end
  end
  return MarchUtil.GetCanAddHeroNum(heroList, self.curIndex)
end

local function GetIsHeroInCurFormation(self, uuid)
  local isIn = false
  for k, v in pairs(self.curHeroes) do
    if v == uuid then
      return true
    end
  end
  return false
end

local function SaveHeroData(self)
end

local function OnFormationSave(self)
  if not self:AllowChangeFormation() then
    self:CloseSelf()
    return
  end
  local hasHero = false
  local hasSolider = false
  table.walk(self.curSoldiers, function(k, v)
    if 0 < v then
      hasSolider = true
    end
  end)
  table.walk(self.curHeroes, function(k, v)
    if 0 < v then
      hasHero = true
    end
  end)
  do
    local sfsObj = SFSArray.New()
    local tmpHero = {}
    local oneFormation = SFSObject.New()
    sfsObj:AddSFSObject(oneFormation)
    oneFormation:PutLong("formationId", self.index)
    local formationArray = SFSArray.New()
    table.walk(self.curSoldiers, function(k, v)
      local obj = SFSObject.New()
      obj:PutUtfString("armyId", tostring(k))
      obj:PutInt("count", math.floor(v))
      formationArray:AddSFSObject(obj)
    end)
    oneFormation:PutSFSArray("formations", formationArray)
    local heroArray = SFSArray.New()
    table.walk(self.curHeroes, function(k, v)
      local obj = SFSObject.New()
      obj:PutUtfString("heroUuid", tostring(v))
      obj:PutInt("index", k)
      tmpHero[tostring(v)] = k
      heroArray:AddSFSObject(obj)
    end)
    local powerNum = self:GetFormationPower()
    oneFormation:PutLong("power", math.ceil(powerNum))
    oneFormation:PutSFSArray("heroInfos", heroArray)
    local info = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
    if info ~= nil and info.formationArray ~= nil then
      local allFormations = info.formationArray
      table.walk(allFormations, function(_, v)
        if v ~= nil and v.formationId ~= self.index then
          local oneFormation = SFSObject.New()
          sfsObj:AddSFSObject(oneFormation)
          oneFormation:PutLong("formationId", v.formationId)
          local formationArray = SFSArray.New()
          table.walk(v.soldiers, function(k, v)
            local obj = SFSObject.New()
            obj:PutUtfString("armyId", v.armsId)
            obj:PutInt("count", v.total)
            formationArray:AddSFSObject(obj)
          end)
          oneFormation:PutSFSArray("formations", formationArray)
          local heroArray = SFSArray.New()
          table.walk(v.heroes, function(k, v)
            if tmpHero[tostring(v.heroUuid)] ~= nil then
              return
            end
            local obj = SFSObject.New()
            obj:PutUtfString("heroUuid", tostring(v.heroUuid))
            obj:PutInt("index", v.index)
            heroArray:AddSFSObject(obj)
          end)
          oneFormation:PutLong("power", v.power)
          oneFormation:PutSFSArray("heroInfos", heroArray)
        end
      end)
    end
    DataCenter.ActChampionBattleManager:SendChampionBattleFormationSave(sfsObj)
    self:CloseSelf()
  end
  goto lbl_93
  self:CloseSelf()
  ::lbl_93::
end

local function ClearFormation(self)
end

local function GetCostTime(self)
  local time = 0
  if self.costTime ~= nil then
    time = self.costTime
  end
  return time
end

local function GetArmyIdList(self)
  if self:NeedTakeArmy() == false then
    return {}
  end
  return table.keys(self.maxSoldiers)
end

local function GetArmyData(self, armyId)
  local oneData = {}
  oneData.name = ""
  oneData.armyId = armyId
  oneData.maxNum = self.maxSoldiers[armyId]
  oneData.icon = ""
  oneData.level = 0
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
  if template ~= nil then
    oneData.icon = string.format(LoadPath.SoldierIcons, template.icon)
    oneData.name = Localization:GetString(template.name)
    oneData.level = template.level
  end
  return oneData
end

local function OnOneKeyFillClick(self)
  if self:NeedTakeArmy() == false then
    return
  end
  self.curSoldiers = {}
  table.walk(self.maxSoldiers, function(k, v)
    local num = self:CheckMax(k, v)
    self:SetCurrentSoldierNum(k, num)
  end)
end

local function OnOneKeyClearClick(self)
  self.curSoldiers = {}
  table.walk(self.maxSoldiers, function(k, v)
    self:SetCurrentSoldierNum(k, 0)
  end)
end

local function OnSaveClick(self)
end

local function GetCostStaminaByTargetType(self, type)
  return 0
end

local function GetFormationPower(self)
  local curHeroes = {}
  table.walk(self.curHeroes, function(k, v)
    if v ~= 0 then
      curHeroes[v] = k
    end
  end)
  local campData = self:GetCurCampData()
  return MarchUtil.GetFormationPower(curHeroes, self.curSoldiers, self.curIndex, campData)
end

local function GetTargetPower(self)
  return nil
end

local function NeedTakeArmy(self)
  return true
end

local function GetScienceIdByUnlock(self, index)
  Logger.Log("GetScienceIdByUnlockIndex", index)
  if self.formationUnLockIndex[index] ~= nil then
    Logger.Log("GetScienceIdByUnlock", self.formationUnLockIndex[index])
    return self.formationUnLockIndex[index]
  end
end

local function AllowChangeFormation(self)
  return true
end

UIChampionBattleFormationViewCtrl.AllowChangeFormation = AllowChangeFormation
UIChampionBattleFormationViewCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIChampionBattleFormationViewCtrl.CheckMax = CheckMax
UIChampionBattleFormationViewCtrl.GetArmyIdList = GetArmyIdList
UIChampionBattleFormationViewCtrl.GetArmyData = GetArmyData
UIChampionBattleFormationViewCtrl.OnOneKeyFillClick = OnOneKeyFillClick
UIChampionBattleFormationViewCtrl.OnOneKeyClearClick = OnOneKeyClearClick
UIChampionBattleFormationViewCtrl.CloseSelf = CloseSelf
UIChampionBattleFormationViewCtrl.Close = Close
UIChampionBattleFormationViewCtrl.InitData = InitData
UIChampionBattleFormationViewCtrl.GetTotalSoldierNum = GetTotalSoldierNum
UIChampionBattleFormationViewCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIChampionBattleFormationViewCtrl.GetSoliderState = GetSoliderState
UIChampionBattleFormationViewCtrl.GetCurrentSoliderDataList = GetCurrentSoliderDataList
UIChampionBattleFormationViewCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIChampionBattleFormationViewCtrl.SelectHeroByUuid = SelectHeroByUuid
UIChampionBattleFormationViewCtrl.GetHeroDataByUuid = GetHeroDataByUuid
UIChampionBattleFormationViewCtrl.GetCurrentHeroDataList = GetCurrentHeroDataList
UIChampionBattleFormationViewCtrl.GetMaxNum = GetMaxNum
UIChampionBattleFormationViewCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIChampionBattleFormationViewCtrl.GetCurHeroData = GetCurHeroData
UIChampionBattleFormationViewCtrl.GetCurCampData = GetCurCampData
UIChampionBattleFormationViewCtrl.SetCurIndex = SetCurIndex
UIChampionBattleFormationViewCtrl.OnStartClick = OnStartClick
UIChampionBattleFormationViewCtrl.ClearFormation = ClearFormation
UIChampionBattleFormationViewCtrl.GetCostTime = GetCostTime
UIChampionBattleFormationViewCtrl.SaveHeroData = SaveHeroData
UIChampionBattleFormationViewCtrl.OnSaveClick = OnSaveClick
UIChampionBattleFormationViewCtrl.GetMaxHeroNum = GetMaxHeroNum
UIChampionBattleFormationViewCtrl.GetCostStaminaByTargetType = GetCostStaminaByTargetType
UIChampionBattleFormationViewCtrl.GetFormationPower = GetFormationPower
UIChampionBattleFormationViewCtrl.GetTargetPower = GetTargetPower
UIChampionBattleFormationViewCtrl.GetAtkValue = GetAtkValue
UIChampionBattleFormationViewCtrl.GetDefValue = GetDefValue
UIChampionBattleFormationViewCtrl.GetAtkDes = GetAtkDes
UIChampionBattleFormationViewCtrl.GetDefDes = GetDefDes
UIChampionBattleFormationViewCtrl.NeedTakeArmy = NeedTakeArmy
UIChampionBattleFormationViewCtrl.GetAtkImage = GetAtkImage
UIChampionBattleFormationViewCtrl.GetDefImage = GetDefImage
UIChampionBattleFormationViewCtrl.GetCanAddHeroNum = GetCanAddHeroNum
UIChampionBattleFormationViewCtrl.GetIsHeroInCurFormation = GetIsHeroInCurFormation
UIChampionBattleFormationViewCtrl.CheckMaxSoliderNum = CheckMaxSoliderNum
UIChampionBattleFormationViewCtrl.GetMaxSoldierNum = GetMaxSoldierNum
UIChampionBattleFormationViewCtrl.GetScienceIdByUnlock = GetScienceIdByUnlock
UIChampionBattleFormationViewCtrl.OnFormationSave = OnFormationSave
UIChampionBattleFormationViewCtrl.ShowChangeHeroWarning = ShowChangeHeroWarning
UIChampionBattleFormationViewCtrl.SetSoldierMax = SetSoldierMax
UIChampionBattleFormationViewCtrl.GetCampRestraintData = GetCampRestraintData
return UIChampionBattleFormationViewCtrl
