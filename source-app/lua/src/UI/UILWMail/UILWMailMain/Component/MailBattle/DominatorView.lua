local DominatorView = BaseClass("DominatorView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DominatorTrainingLine = require("UI.UILWMail.UILWMailMain.Component.MailBattle.DominatorTrainingLine")
local MailDominatorSkillItem = require("UI.UILWMail.UILWMailMain.Component.MailBattle.MailDominatorSkillItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local DominatorTrainingGrade = require("UI.UILWMail.UILWMailMain.Component.MailBattle.DominatorTrainingGrade")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveSkills()
  self:RemoveIcons()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.power2_txt = self:AddComponent(UIText, "title/power2_txt")
  self.power1_txt = self:AddComponent(UIText, "title/power1_txt")
  self.dominators = self:AddComponent(UIBaseContainer, "dominatorIcons")
  self.training = self:AddComponent(UIBaseContainer, "training")
  self.trainings = self:AddComponent(UIBaseContainer, "training/trainings")
  self.leftGrading = self:AddComponent(DominatorTrainingGrade, "training/trainings/leftGrading")
  self.rightGrading = self:AddComponent(DominatorTrainingGrade, "training/trainings/rightGrading")
  self.trainingLines = self:AddComponent(UIBaseContainer, "training/trainingLines")
  self.leftDominatorSlot = self:AddComponent(UIBaseContainer, "dominatorIcons/leftDominatorSlot")
  self.rightDominatorSlot = self:AddComponent(UIBaseContainer, "dominatorIcons/rightDominatorSlot")
  self.leftDominatorMainSkill = self:AddComponent(MailDominatorSkillItem, "dominatorIcons/leftSkillItem")
  self.rightDominatorMainSkill = self:AddComponent(MailDominatorSkillItem, "dominatorIcons/rightSkillItem")
  self.leftSkills = self:AddComponent(UIBaseContainer, "dominatorIcons/leftSkills")
  self.rightSkills = self:AddComponent(UIBaseContainer, "dominatorIcons/rightSkills")
end

local function ComponentDestroy(self)
  self.power2_txt = nil
  self.power1_txt = nil
  self.dominators = nil
  self.training = nil
  self.trainings = nil
  self.leftTrainLv_icon = nil
  self.rightTrainLv_icon = nil
  self.rightSkillGroup = nil
  self.trainingLines = nil
end

function DominatorView:SetData(extData)
  self:RefreshData(extData)
  if self.leftDominatorInfo then
    self.power1_txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(self.leftDominatorInfo.power)))
  else
    self.power1_txt:SetText("0")
  end
  if self.rightDominatorInfo then
    self.power2_txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(self.rightDominatorInfo.power)))
  else
    self.power2_txt:SetText("0")
  end
  self:RefreshDominatorIcons()
  self:RefreshTrainLv()
end

function DominatorView:RefreshData(extData)
  self.hero = extData.hero
  self.progress1 = extData.player[1].progress
  self.progress2 = extData.player[2].progress
  self.leftDominatorUnit = self.hero[PVPBattleSlot.SelfDominator]
  self.rightDominatorUnit = self.hero[PVPBattleSlot.EnemyDominator]
  self.leftDominatorInfo = self.progress1.dominator
  self.leftDominatorTrainInfo = nil
  if self.leftDominatorInfo then
    self.leftDominatorTrainInfo = self.leftDominatorInfo.dominatorTrainInfos
  end
  self.rightDominatorInfo = self.progress2.dominator
  self.rightDominatorTrainInfo = nil
  if self.rightDominatorInfo then
    self.rightDominatorTrainInfo = self.rightDominatorInfo.dominatorTrainInfos
  end
  self.trainInfos = nil
end

function DominatorView:RefreshDominatorIcons()
  local hasDominators = self.leftDominatorUnit or self.rightDominatorUnit
  self.dominators:SetActive(hasDominators)
  if not hasDominators then
    return
  end
  self:RefreshSkills()
  self:RefreshIcons()
end

function DominatorView:RemoveTrainLines()
  self.trainingLines:RemoveComponents(DominatorTrainingLine)
  if self.trainingLinesReq then
    for i = 1, #self.trainingLinesReq do
      local v = self.trainingLinesReq[i]
      self:GameObjectDestroy(v)
    end
    self.trainingLinesReq = nil
  end
end

local LINE_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/dominator/trainingGroupLine.prefab"

function DominatorView:RefreshTrainLv()
  self.trainInfos = {}
  local leftTrainTemplate, rightTrainTemplate
  if not table.IsNullOrEmpty(self.leftDominatorTrainInfo) then
    for i = 1, #self.leftDominatorTrainInfo do
      local info = self.leftDominatorTrainInfo[i]
      local groupTemplate = DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(info.trainId)
      local isMain = groupTemplate:IsMainGroup()
      if isMain then
        leftTrainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(info.trainId + info.level)
      else
        self.trainInfos[info.trainId] = {
          id = info.trainId,
          left = info.level,
          right = nil
        }
      end
    end
  end
  if not table.IsNullOrEmpty(self.rightDominatorTrainInfo) then
    for i = 1, #self.rightDominatorTrainInfo do
      local info = self.rightDominatorTrainInfo[i]
      local groupTemplate = DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(info.trainId)
      local isMain = groupTemplate:IsMainGroup()
      if isMain then
        rightTrainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(info.trainId + info.level)
      elseif self.trainInfos[info.trainId] then
        self.trainInfos[info.trainId].right = info.level
      else
        self.trainInfos[info.trainId] = {
          id = info.trainId,
          left = nil,
          right = info.level
        }
      end
    end
  end
  local trainInfoArr = {}
  for k, v in pairs(self.trainInfos) do
    table.insert(trainInfoArr, v)
  end
  table.sort(trainInfoArr, function(a, b)
    return a.id < b.id
  end)
  if not leftTrainTemplate and not rightTrainTemplate then
    self.trainings:SetActive(false)
  else
    self.trainings:SetActive(true)
    local leftId, rightId, leftLv, rightLv
    if leftTrainTemplate then
      leftId = leftTrainTemplate.level_group
      leftLv = leftTrainTemplate.level_order
    end
    if rightTrainTemplate then
      rightId = rightTrainTemplate.level_group
      rightLv = rightTrainTemplate.level_order
    end
    self.leftGrading:SetData(leftId, leftLv, true)
    self.rightGrading:SetData(rightId, rightLv, true)
  end
  self:RemoveTrainLines()
  self.trainingLinesReq = {}
  for i = 1, #trainInfoArr do
    local k = trainInfoArr[i].id
    local v = trainInfoArr[i]
    local req = self:GameObjectInstantiateAsync(LINE_PREFAB_PATH, function(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      transform:SetParent(self.trainingLines.transform, false)
      transform:Set_localScale(1, 1, 1)
      local name = string.format("trainingLine_%s", k)
      go.name = name
      local comp = self.trainingLines:AddComponent(DominatorTrainingLine, name)
      comp:SetData(k, v.left and v.left or 0, v.right and v.right or 0)
    end)
    table.insert(self.trainingLinesReq, req)
  end
end

function DominatorView:RemoveSkills()
  self.leftSkills:RemoveComponents(MailDominatorSkillItem)
  self.rightSkills:RemoveComponents(MailDominatorSkillItem)
  if self.leftSkillReqs then
    for i = 1, #self.leftSkillReqs do
      local v = self.leftSkillReqs[i]
      self:GameObjectDestroy(v)
    end
    self.leftSkillReqs = nil
  end
  if self.rightSkillReqs then
    for i = 1, #self.rightSkillReqs do
      local v = self.rightSkillReqs[i]
      self:GameObjectDestroy(v)
    end
    self.rightSkillReqs = nil
  end
end

local SKILLITEM_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/dominator/dominatorSkillItem.prefab"

function DominatorView:RefreshSkills()
  local function RemoveNotShowSkill(skills, heroInfo)
    if not table.IsNullOrEmpty(skills) then
      local res = {}
      
      local dominatorMainTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(heroInfo.heroId)
      if dominatorMainTemplate then
        for i, v in pairs(skills) do
          if dominatorMainTemplate:IsShowSkillBySkillGroup(v:GetGroupId()) then
            table.insert(res, v)
          end
        end
      end
      return res
    end
  end
  
  local function SetDominatorSkill(mainSkill, skills, skillInfo, reqs, isReverse)
    if not skillInfo then
      mainSkill:SetActive(false)
      skills:SetActive(false)
      return
    end
    mainSkill:SetActive(true)
    skills:SetActive(true)
    mainSkill:SetData(skillInfo[1])
    if 1 < #skillInfo then
      local start, endIndex, step
      if isReverse then
        start = #skillInfo
        endIndex = 2
        step = -1
      else
        start = 2
        endIndex = #skillInfo
        step = 1
      end
      for i = start, endIndex, step do
        local req = self:GameObjectInstantiateAsync(SKILLITEM_PATH, function(req)
          local go = req.gameObject
          if IsNull(go) then
            return
          end
          local transform = go.transform
          transform:SetParent(skills.transform, false)
          transform:Set_localScale(1, 1, 1)
          local name = string.format("skillItem_%s", i)
          go.name = name
          local comp = skills:AddComponent(MailDominatorSkillItem, name)
          comp:SetData(skillInfo[i])
        end)
        table.insert(reqs, req)
      end
    end
  end
  
  self:RemoveSkills()
  if not self.leftSkillReqs then
    self.leftSkillReqs = {}
  end
  if not self.rightSkillReqs then
    self.rightSkillReqs = {}
  end
  local leftSkillInfos, rightSkillInfos
  if self.leftDominatorUnit then
    leftSkillInfos = self.leftDominatorUnit.heroInfo:GetSkillList()
    if table.IsNullOrEmpty(leftSkillInfos) then
      leftSkillInfos = nil
    end
    leftSkillInfos = RemoveNotShowSkill(leftSkillInfos, self.leftDominatorUnit.heroInfo)
  end
  if self.rightDominatorUnit then
    rightSkillInfos = self.rightDominatorUnit.heroInfo:GetSkillList()
    if table.IsNullOrEmpty(rightSkillInfos) then
      rightSkillInfos = nil
    end
    rightSkillInfos = RemoveNotShowSkill(rightSkillInfos, self.rightDominatorUnit.heroInfo)
  end
  SetDominatorSkill(self.leftDominatorMainSkill, self.leftSkills, leftSkillInfos, self.leftSkillReqs)
  SetDominatorSkill(self.rightDominatorMainSkill, self.rightSkills, rightSkillInfos, self.rightSkillReqs)
end

function DominatorView:RemoveIcons()
  self.leftDominatorSlot:RemoveComponents(UIHeroCellSmall)
  self.rightDominatorSlot:RemoveComponents(UIHeroCellSmall)
  if self.leftDominatorIconReq then
    self:GameObjectDestroy(self.leftDominatorIconReq)
    self.leftDominatorIconReq = nil
  end
  if self.rightDominatorIconReq then
    self:GameObjectDestroy(self.rightDominatorIconReq)
    self.rightDominatorIconReq = nil
  end
end

function DominatorView:RefreshIcons()
  local hasDominators = self.leftDominatorUnit or self.rightDominatorUnit
  if not hasDominators then
    return
  end
  self:RemoveIcons()
  if self.leftDominatorUnit then
    self.leftDominatorIconReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      transform:SetParent(self.leftDominatorSlot.transform, false)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local name = "leftDominator"
      go.name = name
      local comp = self.leftDominatorSlot:AddComponent(UIHeroCellSmall, name)
      local heroInfo = self.leftDominatorUnit
      comp:InitWithConfigId(heroInfo.heroId, nil, heroInfo.heroLevel, heroInfo.rankLv, heroInfo.weaponLevel)
    end)
  end
  if self.rightDominatorUnit then
    self.rightDominatorIconReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      transform:SetParent(self.rightDominatorSlot.transform, false)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local name = "rightDominator"
      go.name = name
      local comp = self.rightDominatorSlot:AddComponent(UIHeroCellSmall, name)
      local heroInfo = self.rightDominatorUnit
      comp:InitWithConfigId(heroInfo.heroId, nil, heroInfo.heroLevel, heroInfo.rankLv, heroInfo.weaponLevel)
    end)
  end
end

DominatorView.OnCreate = OnCreate
DominatorView.OnDestroy = OnDestroy
DominatorView.OnEnable = OnEnable
DominatorView.OnDisable = OnDisable
DominatorView.ComponentDefine = ComponentDefine
DominatorView.ComponentDestroy = ComponentDestroy
return DominatorView
