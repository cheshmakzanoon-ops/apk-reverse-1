local UIFormationLackPowerCtrl = BaseClass("UIFormationLackPowerCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationLackPower)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitFormationUuid(self, uuid)
  self.uuid = uuid
end

local function GetAddList(self, monsterLevel)
  local list = {}
  local templateList = {}
  local mainLv = DataCenter.BuildManager.MainLv
  LocalController:instance():visitTable(TableName.Res_Lack_Tips, function(id, lineData)
    local tips = lineData:getValue("tips")
    local type = 0
    if tips ~= nil then
      type = tonumber(tips)
    end
    local goods = lineData:getValue("goods")
    local res = lineData:getValue("res")
    if goods ~= nil and goods ~= "" and res ~= nil and res ~= "" then
    elseif type == FormationAddSoldierType.TrainSoldier or type == FormationAddSoldierType.ThirdHeroBuild or type == FormationAddSoldierType.KillMonster or type == FormationAddSoldierType.HeroUpgrade or type == FormationAddSoldierType.HeroExchange then
      local oneData = {}
      oneData.selectType = type
      local baseLevel = lineData:getValue("base")
      oneData.order = lineData:getValue("order")
      oneData.name = lineData:getValue("name")
      oneData.pic = lineData:getValue("pic")
      oneData.para1 = lineData:getValue("para1")
      oneData.btnName = Localization:GetString(lineData:getValue("btn_name"))
      oneData.hasHero = false
      local limitLv = lineData:getValue("monster_level_limit")
      local scienceLimitLevel = lineData:getValue("science_level_limit")
      local baseLevelOk = true
      local levelLimit = true
      local scienceLimit = true
      local baseLevelArray = string.split(baseLevel, "-")
      if table.count(baseLevelArray) == 2 then
        local minLevel = tonumber(baseLevelArray[1])
        local maxLevel = tonumber(baseLevelArray[2])
        if minLevel > mainLv or maxLevel < mainLv then
          baseLevelOk = false
        end
      end
      if limitLv ~= nil then
        local monsterLevelArray = string.split(limitLv, "-")
        if table.count(monsterLevelArray) == 2 then
          local minLevel = tonumber(monsterLevelArray[1])
          local maxLevel = tonumber(monsterLevelArray[2])
          if minLevel > monsterLevel or maxLevel < monsterLevel then
            levelLimit = false
          end
        end
      end
      if scienceLimitLevel ~= nil and scienceLimitLevel ~= "" then
        local scienceId = tonumber(scienceLimitLevel)
        if DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, 1) then
          scienceLimit = false
        end
      end
      if baseLevelOk == true and levelLimit == true and scienceLimit == true then
        if type == FormationAddSoldierType.ThirdHeroBuild then
          local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
          local count = 0
          if allHeroes ~= nil then
            count = table.count(allHeroes)
            oneData.hasHero = 2 < count
          end
        elseif type == FormationAddSoldierType.HeroUpgrade then
          oneData.hasHero = true
          table.insert(templateList, oneData)
        elseif type == FormationAddSoldierType.HeroExchange then
          local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(self.uuid)
          if heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
            oneData.heroUuid = heroUuid
            oneData.targetHeroUuid = targetHeroUuid
            oneData.hasHero = true
            table.insert(templateList, oneData)
          end
        else
          table.insert(templateList, oneData)
        end
      end
    end
  end)
  if 0 < #templateList then
    table.sort(templateList, function(a, b)
      if a.hasHero == true and b.hasHero == false then
        return true
      elseif a.hasHero == false and b.hasHero == true then
        return false
      else
        return a.order < b.order
      end
    end)
  end
  for i = 1, #templateList do
    if i <= 3 then
      table.insert(list, templateList[i])
    end
  end
  return list
end

UIFormationLackPowerCtrl.CloseSelf = CloseSelf
UIFormationLackPowerCtrl.Close = Close
UIFormationLackPowerCtrl.GetAddList = GetAddList
UIFormationLackPowerCtrl.InitFormationUuid = InitFormationUuid
return UIFormationLackPowerCtrl
