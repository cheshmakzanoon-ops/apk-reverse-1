local FormationDominatorLine = BaseClass("FormationDominatorLine", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local DominatorTrainingGrade = require("UI.UILWMail.UILWMailMain.Component.MailBattle.DominatorTrainingGrade")

local function OnCreate(self)
  base.OnCreate(self)
  self.dominatorCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.supplyBar = self:AddComponent(UISlider, "Slider1")
  self.supply_num_txt = self:AddComponent(UIText, "loadNum1")
  self.trainingGrade = self:AddComponent(DominatorTrainingGrade, "trainingGrading")
end

local function OnDestroy(self)
  self.dominatorCell = nil
  self.supplyBar = nil
  self.supply_num_txt = nil
  self.dominatorInfo = nil
  base.OnDestroy(self)
end

local function InitData(self, dominatorUuid)
  self.uuid = dominatorUuid
  local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
  self.dominatorInfo = dominatorInfo
  if dominatorInfo then
    self:SetActive(true)
    local heroId = dominatorInfo.dominatorId
    local rankLv = dominatorInfo.rankLv
    self.dominatorCell:InitWithConfigId(heroId, nil, nil, rankLv)
    local trainInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
    local groupId, lv
    if trainInfo then
      local trainTemplate = trainInfo:GetCurLevelTemplate()
      if trainTemplate then
        groupId = trainInfo.groupId
        lv = trainInfo.level
      end
    end
    self.trainingGrade:SetData(groupId, lv, false)
  else
    self:SetActive(false)
  end
end

local function SetSupply(self, supply, fixedSoldierType)
  local _supply = supply or 0
  if self.dominatorInfo then
    local capacity = self.dominatorInfo:GetSoldierCapacity()
    if fixedSoldierType == SoldierType.Mummy then
      local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
      if s3_mummy_config_k7 ~= nil and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
        capacity = math.ceil(capacity / s3_mummy_config_k7)
      end
    end
    _supply = math.min(_supply, capacity)
    self.supplyBar:SetValue(_supply / capacity)
    self.supply_num_txt:SetText(math.floor(_supply))
  else
    self.supplyBar:SetValue(0)
    self.supply_num_txt:SetText("0")
  end
end

FormationDominatorLine.OnCreate = OnCreate
FormationDominatorLine.InitData = InitData
FormationDominatorLine.SetSupply = SetSupply
FormationDominatorLine.OnDestroy = OnDestroy
return FormationDominatorLine
