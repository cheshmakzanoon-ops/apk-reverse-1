local UILWSkyBattleGoFightView = BaseClass("UILWSkyBattleGoFightView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UILWStageSkyBattleChapter.Components.UISkyBattleRewardItem")

function UILWSkyBattleGoFightView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSkyBattleGoFightView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSkyBattleGoFightView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBossPart = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.rawImgBossAvatorImg = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textChallengeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textGoalTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textGoaItem1lDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textGoalItem2Desc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textGoalItem3Desc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compRewardTemplate = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textDescTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textDescContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnChallenge = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.textChallengeBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compRewardPart = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.btnChallengeStamina = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnChallengeStamina:SetOnClick(function()
    self:OnBtnChallengeStaminaClick()
  end)
  self.textStaminaChallengeBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textStaminaCostTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compFightPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.compContentBg = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.compRewardTemplate:SetActive(false)
end

function UILWSkyBattleGoFightView:ComponentDestroy()
  self.viewSkin = nil
  self.compBossPart = nil
  self.rawImgBossAvatorImg = nil
  self.textChallengeTitle = nil
  self.textGoalTitle = nil
  self.textGoaItem1lDesc = nil
  self.textGoalItem2Desc = nil
  self.textGoalItem3Desc = nil
  self.textRewardTitle = nil
  self.compRewardTemplate = nil
  self.compContent = nil
  self.textDescTitle = nil
  self.textDescContent = nil
  self.btnChallenge = nil
  self.textChallengeBtnTxt = nil
  self.btnClose = nil
  self.compRewardPart = nil
  self.btnChallengeStamina = nil
  self.textStaminaChallengeBtnTxt = nil
  self.textStaminaCostTxt = nil
  self.compFightPanel = nil
  self.compContentBg = nil
end

function UILWSkyBattleGoFightView:DataDefine()
  self.rewardComps = {}
end

function UILWSkyBattleGoFightView:DataDestroy()
  for _, rewardComp in ipairs(self.rewardComps) do
    if rewardComp then
      local go = rewardComp.gameObject
      self:RemoveComponent(rewardComp)
      if not IsNull(go) then
        CS.UnityEngine.GameObject.Destroy(go)
      end
    end
  end
  self.onEnterClick = nil
  self.rewardComps = nil
end

function UILWSkyBattleGoFightView:ReInit(stageId, showReward, growthMode)
  self.growthMode = growthMode
  self.stageId = stageId
  local introduce = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "introduce")
  self.textDescContent:SetLocalText(introduce)
  local stageName = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "name")
  local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "order")
  self.textChallengeTitle:SetLocalText(stageName, order)
  local special = tonumber(LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "special_level")) or 0
  self.compBossPart:SetActive(special == 1)
  self.textGoalTitle:SetLocalText("plane_chapter_detail_04")
  self.textRewardTitle:SetLocalText("plane_chapter_detail_08")
  self.textDescTitle:SetLocalText("plane_chapter_detail_09")
  self.btnChallenge:SetActive(not self.growthMode)
  self.btnChallengeStamina:SetActive(self.growthMode)
  self.textChallengeBtnTxt:SetLocalText("plane_chapter_detail_11")
  self.textStaminaChallengeBtnTxt:SetLocalText("plane_chapter_detail_11")
  local staminaToChallenge = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "stamina")
  self.textStaminaCostTxt:SetText(string.format("- %d", tonumber(staminaToChallenge)))
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local stageConditions = mgr:GetStageStarCondition(stageId)
  if stageConditions then
    local goalItem1DescTxt = stageConditions[1] and mgr:GetConditionLocalKey(stageConditions[1].type, stageConditions[1].value) or ""
    self.textGoaItem1lDesc:SetText(goalItem1DescTxt)
    local goalItem2DescTxt = stageConditions[2] and mgr:GetConditionLocalKey(stageConditions[2].type, stageConditions[2].value) or ""
    self.textGoalItem2Desc:SetText(goalItem2DescTxt)
    local goalItem3DescTxt = stageConditions[3] and mgr:GetConditionLocalKey(stageConditions[3].type, stageConditions[3].value) or ""
    self.textGoalItem3Desc:SetText(goalItem3DescTxt)
  end
  local x, y
  if self.growthMode then
  else
    local anchorPosY = 17
    local contentOffsetY = -103.4
    if special == 1 then
      anchorPosY = -14.5
      contentOffsetY = -224.5
    end
    self.compFightPanel:SetAnchoredPositionXY(0, anchorPosY)
    self.compContentBg:SetOffsetMaxXY(0, contentOffsetY)
  end
  if showReward and self.growthMode then
    self.compRewardPart:SetActive(true)
    local rewardDatas = mgr:GetStageRewardShow(stageId)
    local idx = 1
    for _, reward in ipairs(rewardDatas) do
      local rewardComp = self.rewardComps[idx]
      if not rewardComp then
        local rewardObj = CS.UnityEngine.GameObject.Instantiate(self.compRewardTemplate.gameObject, self.compContent.transform)
        rewardObj.name = "reward_" .. idx
        rewardComp = self:AddComponent(UICommonResItem, rewardObj)
        self.rewardComps[idx] = rewardComp
      end
      rewardComp:SetActive(true)
      rewardComp:ReInit(reward)
      idx = idx + 1
    end
    for i = idx, #self.rewardComps do
      self.rewardComps[i]:SetActive(false)
    end
  else
    self.compRewardPart:SetActive(false)
  end
end

function UILWSkyBattleGoFightView:OnBtnChallengeClick()
  if self.onEnterClick then
    self.onEnterClick(self.stageId)
  end
end

function UILWSkyBattleGoFightView:OnBtnChallengeStaminaClick()
  if self.onEnterClick then
    self.onEnterClick(self.stageId)
  end
end

function UILWSkyBattleGoFightView:OnBtnCloseClick()
  self:SetActive(false)
end

function UILWSkyBattleGoFightView:SetOnEnterClick(onEnterClick)
  self.onEnterClick = onEnterClick
end

return UILWSkyBattleGoFightView
