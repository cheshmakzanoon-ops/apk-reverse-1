local base = UIBaseContainer
local T11SoldierBattleReportComponent = BaseClass("T11SoldierBattleReportComponent", UIBaseContainer)
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local skillPath = "Assets/Main/Prefabs/UI/T11/T11Common/T11SoldierSkillItem_BattleReport.prefab"
local coreSkillPath = "Assets/Main/Prefabs/UI/T11/T11Common/T11SoldierSkillItem_BattleReport_Core.prefab"
local M = T11SoldierBattleReportComponent

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textCoreSkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLeftCoreSkillNode = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compRightCoreSkillNode = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compLeftSkillList = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compRightSkillList = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
end

function M:ComponentDestroy()
  self.textCoreSkill = nil
  self.textSkill = nil
  self.compLeftCoreSkillNode = nil
  self.compRightCoreSkillNode = nil
  self.compLeftSkillList = nil
  self.compRightSkillList = nil
end

function M:DataDefine()
  self.extData = nil
  self.skillLeftRequestList = {}
  self.skillRightRequestList = {}
end

function M:DataDestroy()
  self.extData = nil
  self.skillLeftRequestList = nil
  self.skillRightRequestList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:Init()
  self.textCoreSkill:SetLocalText("soldier_eleven_report_skill_01")
  self.textSkill:SetLocalText("soldier_eleven_report_skill_02")
end

function M:SetData(extData, showPlayer1Skill, showPlayer2Skill, fixedSoldierType)
  self.extData = extData
  self.fixedSoldierType = fixedSoldierType
  self:InitLeftSkill(showPlayer1Skill)
  self:InitRightSkill(showPlayer2Skill)
end

function M:InitLeftSkill(showSkill)
  self:ClearSkillList(true)
  local player1 = self.extData.player[1]
  local leftSoldierElevenData = player1.soldierEleven
  if not showSkill then
    return
  end
  local stage = leftSoldierElevenData.stage
  local progress = leftSoldierElevenData.progress
  local type = T11Util.GetSoldierTypeByEffectList(leftSoldierElevenData.effects)
  local skillInfo = self:GetAllSkillsInfo(type, stage)
  local coreSkillInfo = skillInfo and skillInfo.coreSkillInfo
  local skillList = skillInfo and skillInfo.otherSkillInoList or {}
  self:RefreshSkillListNode(skillList, true)
  self:RefreshCoreSkill(coreSkillInfo, true)
end

function M:InitRightSkill(showSkill)
  self:ClearSkillList(false)
  local player2 = self.extData.player[2]
  local rightSoldierElevenData = player2.soldierEleven
  if not showSkill then
    return
  end
  local stage = rightSoldierElevenData.stage
  local progress = rightSoldierElevenData.progress
  local type = T11Util.GetSoldierTypeByEffectList(rightSoldierElevenData.effects)
  local skillInfo = self:GetAllSkillsInfo(type, stage)
  local coreSkillInfo = skillInfo and skillInfo.coreSkillInfo
  local skillList = skillInfo and skillInfo.otherSkillInoList or {}
  self:RefreshSkillListNode(skillList, false)
  self:RefreshCoreSkill(coreSkillInfo, false)
end

function M:GetAllSkillsInfo(soldierType, mailStage)
  local stageList = DataCenter.T11DataManager.curT11LevelData.stageData:GetStageList()
  local initStage = T11Util.GetT11InitialStage()
  local otherStage = {}
  for _, v in pairs(stageList) do
    if v ~= initStage then
      table.insert(otherStage, v)
    end
  end
  local coreSkillInfo = T11Util.GetSkillInfoByDesignatedStage(initStage, soldierType, mailStage)
  local otherSkillInoList = {}
  for _, v in pairs(otherStage) do
    local skillInfo = T11Util.GetSkillInfoByDesignatedStage(v, soldierType, mailStage)
    if skillInfo then
      table.insert(otherSkillInoList, skillInfo)
    end
  end
  return {coreSkillInfo = coreSkillInfo, otherSkillInoList = otherSkillInoList}
end

function M:RefreshSkillListNode(skillInfos, isLeft)
  local skillRequestSkillList = isLeft and self.skillLeftRequestList or self.skillRightRequestList
  local fixedSoldierType = isLeft and self.fixedSoldierType or nil
  for i = 1, table.length(skillInfos) do
    skillRequestSkillList[i] = self:GameObjectInstantiateAsync(skillPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      local parent = isLeft and self.compLeftSkillList or self.compRightSkillList
      go.transform:SetParent(parent.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "item" .. i
      local cell = parent:AddComponent(T11SoldierSkillItemComponent, go.name)
      cell:Init(skillInfos[i], true, false, fixedSoldierType)
    end)
  end
end

function M:ClearSkillList(isLeft)
  local parent = isLeft and self.compLeftSkillList or self.compRightSkillList
  local requestList = isLeft and self.skillLeftRequestList or self.skillRightRequestList
  parent:RemoveComponents(T11SoldierSkillItemComponent)
  for _, v in pairs(requestList) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  local coreParent = isLeft and self.compLeftCoreSkillNode or self.compRightCoreSkillNode
  local request = isLeft and self.coreSkillRequestLeft or self.coreSkillRequestRight
  coreParent:RemoveComponents(T11SoldierSkillItemComponent)
  self:GameObjectDestroy(request)
end

function M:RefreshCoreSkill(skillInfo, isLeft)
  if not skillInfo then
    return
  end
  local parent = isLeft and self.compLeftCoreSkillNode or self.compRightCoreSkillNode
  local fixedSoldierType = isLeft and self.fixedSoldierType or nil
  parent:RemoveComponents(T11SoldierSkillItemComponent)
  self.coreSkillRequestLeft = self:GameObjectInstantiateAsync(coreSkillPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(parent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local cell = parent:AddComponent(T11SoldierSkillItemComponent, go.name)
    cell:Init(skillInfo, true, false, fixedSoldierType)
  end)
end

return T11SoldierBattleReportComponent
