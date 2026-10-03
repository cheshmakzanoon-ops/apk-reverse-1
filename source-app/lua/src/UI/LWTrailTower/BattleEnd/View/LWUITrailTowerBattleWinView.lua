local LWUITrailTowerBattleWinView = BaseClass("LWUITrailTowerBattleWinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LWUITrailTowerBattleEndHeroItemRender = require("UI.LWTrailTower.BattleEnd.Component.LWUITrailTowerBattleEndHeroItemRender")
local UILWPureDisplaySkirmishResultView = require("UI.UISkirmish.ResultPureDisplay.View.UILWPureDisplaySkirmishResultView")
local LayoutLayer = "Layout"
local victoryText_path = "Layout/Title/VictoryGo/VictoryText"
local stageText_path = "Layout/LevelText"
local backBtn_path = "Layout/Btns/BackBtn"
local nextBtn_path = "Layout/Btns/NextBtn"
local nextBtnText_path = "Layout/Btns/NextBtn/BtnText"
local detailBtn_path = "Layout/DetailBtn"
local rewardContent_path = "Layout/RewardScrollView/Viewport/RewardContent"
local heroContent_path = "Layout/HeroContent"
local heroItemObj_path = "BattleEndHeroItemRender"
local backToggle_path = "Layout/backToggle"
local checkbox_text_path = "Layout/backToggle/Text"
local autoWaitTime = 5000

function LWUITrailTowerBattleWinView:OnCreate()
  base.OnCreate(self)
  local stageData, battleManagerParam = self:GetUserData()
  self.stageId = stageData.stageId
  self.battleManagerParam = battleManagerParam
  self:ComponentDefine()
  self:ReInit()
end

function LWUITrailTowerBattleWinView:OnDestroy()
  self:DeleteTimer()
  self:ComponentDestroy()
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  base.OnDestroy(self)
end

function LWUITrailTowerBattleWinView:ComponentDefine()
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.canvasGroup.interactable = false
  self.victoryText = self:AddComponent(UIText, victoryText_path)
  self.victoryText:SetText(Localization:GetString("311105"))
  self.stageText = self:AddComponent(UIText, stageText_path)
  self.nextBtnText = self:AddComponent(UIText, nextBtnText_path)
  self.nextBtnText:SetLocalText(456809)
  self.checkboxText = self:AddComponent(UIText, checkbox_text_path)
  self.checkboxText:SetLocalText(456810)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, nextBtn_path)
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.detailBtn:SetOnClick(function()
    self:DetailBtnClick()
  end)
  self.backToggle = self:AddComponent(UIToggle, backToggle_path)
  self.backToggle:SetIsOn(false)
  self.backToggle:SetOnValueChanged(function(value)
    self:OnToggleChangeFunc(value)
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.heroContent = self:AddComponent(UIBaseContainer, heroContent_path)
  self.heroItemObj = self.transform:Find(heroItemObj_path).gameObject
  self.heroItemObj:GameObjectCreatePool()
end

function LWUITrailTowerBattleWinView:ComponentDestroy()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.heroContent:RemoveComponents(LWUITrailTowerBattleEndHeroItemRender)
  self.heroItemObj:GameObjectRecycleAll()
  self.layout = nil
  self.canvasGroup = nil
  self.victoryText = nil
  self.stageText = nil
  self.checkboxText = nil
  self.backBtn = nil
  self.nextBtn = nil
  self.nextBtnText = nil
  self.detailBtn = nil
  self.backToggle = nil
  self.rewardContent = nil
  self.heroContent = nil
  self.heroItemObj = nil
end

function LWUITrailTowerBattleWinView:ReInit()
  self.autoNextStageStartTime = -1
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimer then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTrailTowerBattleWin) and self.canvasGroup then
      self.canvasGroup:DOFade(1, 0.2)
      self.canvasGroup.interactable = true
      self:RefreshHeroEffect()
    end
  end, 1.5)
  local trailTowerLevelConfig = LocalController:instance():getLine(TableName.LW_Trail_Tower_Level, self.stageId)
  if trailTowerLevelConfig ~= nil then
    self.towerId = tonumber(trailTowerLevelConfig:getValue("tower_id"))
    self.difficultyGroup = tonumber(trailTowerLevelConfig:getValue("level_group"))
    local order = tonumber(trailTowerLevelConfig:getValue("level_order"))
    local stageDes = self.difficultyGroup .. "-" .. order
    self.stageText:SetText(Localization:GetString("trialtower_018", stageDes))
    local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.towerId)
    self.nextStageId = trailTowerInfo ~= nil and trailTowerInfo.curStage or -1
    self.isFinish = true
    if trailTowerInfo ~= nil then
      self.isFinish = trailTowerInfo.isFinish
    end
    local stageEnd = DataCenter.LWTrailTowerManager:IsDifficultyGroupChange(self.towerId) or self.nextStageId == -1 or self.isFinish
    self.backToggle:SetActive(not stageEnd)
    if not stageEnd then
      self:AddTimer()
      self:RefreshAutoNextStageToggleView()
    else
      self:DeleteTimer()
    end
  end
  self:ShowReward()
  self:ShowHero()
end

function LWUITrailTowerBattleWinView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.CheckAutoNext, self, false, false, false)
  end
  self.timer:Start()
end

function LWUITrailTowerBattleWinView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWUITrailTowerBattleWinView:CheckAutoNext()
  if self.autoNextStageStartTime == nil or self.autoNextStageStartTime <= 0 then
    self.nextBtnText:SetLocalText(456809)
    return
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.autoNextStageStartTime + autoWaitTime then
      self:OnNextBtnClick()
      self.autoNextStageStartTime = -1
    else
      local btnStr = Localization:GetString(456809)
      local showTime = math.floor((self.autoNextStageStartTime + autoWaitTime - curTime) / 1000)
      local btnTimeStr = btnStr .. string.format(" (%s)", showTime)
      self.nextBtnText:SetText(btnTimeStr)
    end
  end
end

function LWUITrailTowerBattleWinView:RefreshAutoNextStageToggleView()
  local isNext = DataCenter.LWTrailTowerManager:IsAutoNextStage(self.towerId)
  self.backToggle:SetIsOn(isNext)
  if isNext then
    self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
  else
    self.autoNextStageStartTime = -1
  end
end

function LWUITrailTowerBattleWinView:ShowReward()
  self.rewardContent:RemoveComponents(UIHeroCellSmall)
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  local param = DataCenter.RewardManager:ReturnRewardParamForMessage(DataCenter.LWTrailTowerManager.battleEndReward)
  if param ~= nil then
    local index = 0
    for _, v in pairs(param) do
      local req
      local p = v
      if p.rewardType == RewardType.HERO then
        req = Resource:InstantiateAsync(UIAssets.UIHeroCellSmall)
      else
        req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
      end
      index = index + 1
      local name = index
      req:completed("+", function(req)
        local go = req.gameObject
        go.name = name
        CommonUtil.CallAutoArabicMirrorManually(req)
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        local cell
        if p.rewardType == RewardType.HERO then
          cell = self.rewardContent:AddComponent(UIHeroCellSmall, go)
          cell:SetData(p.heroUuid)
        else
          cell = self.rewardContent:AddComponent(UICommonResItem, go)
          cell:ReInit(p)
        end
      end)
      table.insert(self.reqs, req)
    end
  end
end

function LWUITrailTowerBattleWinView:ShowHero()
  self.heroItemList = {}
  local heroDic = DataCenter.LWTrailTowerManager.battleEndDisplayHeroDic
  local index = 0
  for heroUuid, heroDisplayData in pairs(heroDic) do
    local itemObj = self.heroItemObj:GameObjectSpawn(self.heroContent.transform)
    index = index + 1
    itemObj.name = "heroItem" .. index
    itemObj:SetActive(true)
    local heroItemRender = self.heroContent:AddComponent(LWUITrailTowerBattleEndHeroItemRender, itemObj.name)
    heroItemRender:SetData(heroDisplayData)
    table.insert(self.heroItemList, heroItemRender)
  end
end

function LWUITrailTowerBattleWinView:RefreshHeroEffect()
  if self.heroItemList ~= nil then
    for _, heroItemRender in pairs(self.heroItemList) do
      heroItemRender:RefreshLvUpEffect()
    end
  end
end

function LWUITrailTowerBattleWinView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit()
end

function LWUITrailTowerBattleWinView:OnNextBtnClick()
  local stageEnd = DataCenter.LWTrailTowerManager:IsDifficultyGroupChange(self.towerId) or self.nextStageId == -1 or self.isFinish
  if stageEnd then
    self:OnBackBtnClick()
  else
    local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.towerId)
    if trailTowerInfo and trailTowerInfo:IsEnd() then
      UIUtil.ShowTipsId("trialtower_error_01")
      self:OnBackBtnClick()
      return
    end
    local nextTrailTowerLevelTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerLevelTemplate(self.towerId, self.difficultyGroup, self.nextStageId)
    if nextTrailTowerLevelTemplate ~= nil then
      local param = {}
      param.type = PVEType.FakePVP
      param.enterType = PVEEnterType.TrailTower
      param.levelId = nextTrailTowerLevelTemplate.levelArmyId
      param.sceneId = nextTrailTowerLevelTemplate.sceneId
      param.extraData = {}
      param.extraData.trailTowerLevelTemplate = nextTrailTowerLevelTemplate
      DataCenter.LWBattleManager:Enter(param)
    end
  end
end

function LWUITrailTowerBattleWinView:OnToggleChangeFunc(state)
  local isNext = DataCenter.LWTrailTowerManager:IsAutoNextStage(self.towerId)
  if isNext ~= state then
    DataCenter.LWTrailTowerManager:SetAutoNextStage(self.towerId, state)
    isNext = state
    if isNext then
      self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
    else
      self.autoNextStageStartTime = -1
    end
  end
end

function LWUITrailTowerBattleWinView:DetailBtnClick()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic ~= nil and logic.battleData ~= nil then
    local panelParam = UILWPureDisplaySkirmishResultView.ParamDataClass.New()
    panelParam.battleData = logic.battleData
    panelParam.enterType = PVEEnterType.TrailTower
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPureDisplaySkirmishResult, {anim = false}, panelParam)
  end
end

return LWUITrailTowerBattleWinView
