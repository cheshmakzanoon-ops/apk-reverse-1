local UIPVEResultView = BaseClass("UIPVEResultView", UIBaseView)
local base = UIBaseView
local Const = require("Scene.BattlePveModule.Const")
local UIGuidePioneerHeroExpCell = require("UI.UIPVE.UIPVEResult.Component.UIGuidePioneerHeroExpCell")
local UIPVEPowerLackScrollView = require("UI.UIPVE.UIPVEPowerLack.Component.UIPVEPowerLackScrollView")
local win_path = "Win"
local win_text_path = win_path .. "/WinText"
local win_hero_item_path = win_path .. "/Vert/HeroItems"
local win_scroll_view_path = win_path .. "/Vert/ScrollView"
local fail_path = "Fail"
local fail_text_path = fail_path .. "/FailText"
local fail_scroll_view_path = fail_path .. "/UIPVEPowerLackScrollView"
local arenaResult_path = "arena"
local arenaOldRank_path = "arena/rank/oldRank"
local arenaRankArrow_path = "arena/rank/rankArrow"
local arenaNewRank_path = "arena/rank/newRank"
local arenaScore_path = "arena/score"
local arenaOldScore_path = "arena/score/oldScore"
local arenaScoreArrow_path = "arena/score/scoreArrow"
local arenaNewScore_path = "arena/score/newScore"
local arenaRewardContent_path = "arena/scrollRect/Viewport/Content"
local arenaRewardTemplate_path = "arena/template(inactive)/UICommonResItem"
local adventure_path = "Adventure"
local adventure_exit_btn_path = "Adventure/AdventureExit"
local adventure_exit_text_path = "Adventure/AdventureExit/AdventureExitText"
local adventure_reset_btn_path = "Adventure/AdventureReset"
local adventure_reset_text_path = "Adventure/AdventureReset/AdventureResetText"
local adventure_desc_path = "Adventure/AdventureDesc"
local adventure_fail_path = "Adventure/AdventureFail"
local monster_path = "Monster"
local monster_exit_btn_path = "Monster/MonsterExit"
local monster_exit_text_path = "Monster/MonsterExit/MonsterExitText"
local monster_reset_btn_path = "Monster/MonsterReset"
local monster_reset_text_path = "Monster/MonsterReset/MonsterResetText"

local function OnCreate(self)
  base.OnCreate(self)
  self.panel = self:AddComponent(UIButton, "Panel")
  self.panel:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.win = self:AddComponent(UIBaseContainer, win_path)
  self.win_text = self:AddComponent(UIText, win_text_path)
  self.win_text:SetLocalText(390186)
  self.win_hero_item = self:AddComponent(UIBaseContainer, win_hero_item_path)
  self.win_scroll_view = self:AddComponent(UIScrollView, win_scroll_view_path)
  self.win_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.win_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.fail = self:AddComponent(UIBaseContainer, fail_path)
  self.fail_text = self:AddComponent(UIText, fail_text_path)
  self.fail_scroll_view = self:AddComponent(UIPVEPowerLackScrollView, fail_scroll_view_path)
  self.arenaResultN = self:AddComponent(UIBaseContainer, arenaResult_path)
  self.arenaResultN:SetActive(false)
  self.arenaOldRankN = self:AddComponent(UIText, arenaOldRank_path)
  self.arenaRankArrowN = self:AddComponent(UIImage, arenaRankArrow_path)
  self.arenaNewRankN = self:AddComponent(UIText, arenaNewRank_path)
  self.arenaScoreN = self:AddComponent(UIBaseContainer, arenaScore_path)
  self.arenaOldScoreN = self:AddComponent(UIText, arenaOldScore_path)
  self.arenaScoreArrowN = self:AddComponent(UIImage, arenaScoreArrow_path)
  self.arenaNewScoreN = self:AddComponent(UIText, arenaNewScore_path)
  self.arenaRewardTemplateN = self:AddComponent(UIBaseContainer, arenaRewardTemplate_path)
  self.arenaRewardTemplateN.gameObject:GameObjectCreatePool()
  self.arenaRewardContentN = self:AddComponent(UIBaseContainer, arenaRewardContent_path)
  self.adventure_go = self:AddComponent(UIBaseContainer, adventure_path)
  self.adventure_go:SetActive(false)
  self.adventure_exit_btn = self:AddComponent(UIButton, adventure_exit_btn_path)
  self.adventure_exit_btn:SetOnClick(function()
    self:OnAdventureExitClick()
  end)
  self.adventure_exit_text = self:AddComponent(UIText, adventure_exit_text_path)
  self.adventure_exit_text:SetLocalText(110043)
  self.adventure_reset_btn = self:AddComponent(UIButton, adventure_reset_btn_path)
  self.adventure_reset_btn:SetOnClick(function()
    self:OnAdventureResetClick()
  end)
  self.adventure_reset_text = self:AddComponent(UIText, adventure_reset_text_path)
  self.adventure_reset_text:SetLocalText(150116)
  self.adventure_desc_text = self:AddComponent(UIText, adventure_desc_path)
  self.adventure_fail_text = self:AddComponent(UIText, adventure_fail_path)
  self.adventure_fail_text:SetLocalText(302296)
  self.monster = self:AddComponent(UIBaseContainer, monster_path)
  self.monster_exit_btn = self:AddComponent(UIButton, monster_exit_btn_path)
  self.monster_exit_text = self:AddComponent(UIText, monster_exit_text_path)
  self.monster_exit_text:SetLocalText(110043)
  self.monster:SetActive(false)
  self.monster_exit_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.monster_reset_btn = self:AddComponent(UIButton, monster_reset_btn_path)
  self.monster_reset_text = self:AddComponent(UIText, monster_reset_text_path)
  self.monster_reset_text:SetLocalText(134021)
  self.monster_reset_btn:SetOnClick(function()
    self:OnMonsterResetClick()
  end)
  self.rewardList = {}
  self.itemList = {}
  self.canClose = false
end

local function OnDestroy(self)
  if self.delayClose ~= nil then
    self.delayClose:Stop()
    self.delayClose = nil
  end
  self.arenaRewardContentN:RemoveComponents(UICommonResItem)
  self.arenaRewardTemplateN.gameObject:GameObjectRecycleAll()
  self.panel = nil
  self.win = nil
  self.win_text = nil
  self.win_hero_item:RemoveComponents(UIGuidePioneerHeroExpCell)
  self.win_hero_item = nil
  self.win_scroll_view = nil
  self.fail = nil
  self.fail_text = nil
  self.fail_scroll_view = nil
  self.rewardList = nil
  self.itemList = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  self.panel:SetInteractable(true)
  local expInfoDict = PveActorMgr:GetInstance().expInfoDict or {}
  local result, param = self:GetUserData()
  if result == nil then
    result = PveActorMgr:GetInstance():GetBattleResult()
  end
  self.win:SetActive(result == Const.Result.Win)
  if result == Const.Result.Win then
    if table.count(expInfoDict) > 0 then
      self.win_hero_item:SetActive(true)
      TimerManager:GetInstance():DelayInvoke(function()
        for _, heroExp in pairs(expInfoDict) do
          self:AddHeroExpObj(heroExp)
        end
      end, 0.5)
      self.delayClose = TimerManager:GetInstance():DelayInvoke(function()
        self.canClose = true
      end, 1.5)
    else
      self.win_hero_item:SetActive(false)
      self.canClose = true
    end
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(DataCenter.BattleLevel.battleRewardMessage) or {}
    self:ShowCells()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_finish, false)
  else
    self.delayClose = TimerManager:GetInstance():DelayInvoke(function()
      self.canClose = true
    end, 1.5)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_lost, false)
  end
  self.fail:SetActive(result == Const.Result.Fail)
  self.fail_scroll_view:SetActive(false)
  local trigger = PveActorMgr:GetInstance():GetCurTrigger()
  local showTip = trigger and trigger:IsTypeMonster() and trigger:GetMonsterSpecialType() ~= 1 and not trigger:IsMonsterWithHp()
  if result == Const.Result.Fail and showTip then
    local tips = {}
    for _, tip in ipairs(PvePowerLackShowTips[PvePowerLackType.Fail]) do
      local template = DataCenter.ResLackManager:GetTemplateByTip(math.abs(tip))
      if template and template:CheckMainLevelAndPlayerLevel() then
        table.insert(tips, tip)
      end
    end
    self.fail_scroll_view:SetData(PvePowerLackType.Fail, tips, 6, false)
    self.fail_scroll_view:SetActive(true)
    DataCenter.GuideManager:SendLogMessage(DataCenter.BattleLevel.levelId, StatTTType.PveBattleFail, tostring(trigger:GetTriggerId()))
  end
  self.fail_text:SetLocalText(390187)
  self.monster:SetActive(false)
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.ArenaBattle then
    self.fail_scroll_view:SetActive(false)
    self.arenaResultN:SetActive(true)
    self.adventure_go:SetActive(false)
    local arrowPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/%s.png"
    local newRank, oldRank, newScore, oldScore = DataCenter.ArenaManager:GetFightRankChange()
    self.arenaOldRankN:SetText(oldRank <= 0 and "--" or oldRank)
    local rankArrow = oldRank < newRank and "Common_btn_arrow3" or "Common_btn_arrow4"
    self.arenaRankArrowN:LoadSprite(string.format(arrowPath, rankArrow))
    self.arenaNewRankN:SetText(newRank)
    self.arenaOldScoreN:SetText(oldScore)
    local scoreArrow = oldScore <= newScore and "Common_btn_arrow4" or "Common_btn_arrow3"
    self.arenaScoreArrowN:LoadSprite(string.format(arrowPath, scoreArrow))
    self.arenaNewScoreN:SetText(newScore)
    self:ShowArenaRewards()
  elseif entranceType == PveEntrance.BattlePlayBack then
    self.fail_scroll_view:SetActive(false)
    self.arenaResultN:SetActive(false)
    self.adventure_go:SetActive(false)
  elseif entranceType == PveEntrance.Adventure then
    self.fail_scroll_view:SetActive(false)
    self.arenaResultN:SetActive(false)
    self.fail_text:SetLocalText(302295)
    if param and param.showBtn then
      self.panel:SetInteractable(false)
      self.adventure_go:SetActive(true)
      local resetTime = DataCenter.AdventureManager:GetTodayRestResetTime()
      self.adventure_desc_text:SetLocalText(302250, resetTime)
    else
      self.panel:SetInteractable(true)
      self.adventure_go:SetActive(false)
    end
  elseif trigger ~= nil and trigger:IsMonsterWithHp() then
    self.fail_scroll_view:SetActive(false)
    self.arenaResultN:SetActive(false)
    self.adventure_go:SetActive(false)
    if result == Const.Result.Fail then
      self.monster:SetActive(true)
      self.fail_text:SetLocalText(310162)
    end
  end
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveBattleShowResult, trigger:GetTriggerId() .. "," .. result)
  base.OnEnable(self)
end

local function ShowArenaRewards(self)
  if not self.arenaRewardItemsTb then
    self.arenaRewardItemsTb = {}
  end
  local arenaRewards = DataCenter.ArenaManager:GetCachedRewards() or {}
  for i, reward in ipairs(arenaRewards) do
    local item = self.arenaRewardTemplateN.gameObject:GameObjectSpawn(self.arenaRewardContentN.transform)
    item.name = "item" .. i
    local obj = self.arenaRewardContentN:AddComponent(UICommonResItem, item.name)
    local tempParam = {}
    tempParam.rewardType = reward.type
    tempParam.itemId = reward.value.itemId
    tempParam.count = reward.value.rewardAdd
    obj:ReInit(tempParam)
  end
end

local function AddHeroExpObj(self, heroExp)
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/Guide/UIGuidePioneerHeroExpCell.prefab", function(request)
    if request.isError then
      return
    end
    if not self.win_hero_item then
      request:Destroy()
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.win_hero_item.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    go.name = nameStr
    local itemObj = self.win_hero_item:AddComponent(UIGuidePioneerHeroExpCell, go.name)
    itemObj:InitData(heroExp)
  end)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local reward = self.rewardList[index]
  local item = self.win_scroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(reward)
  self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  self.win_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
  self.itemList[index] = nil
end

local function ShowCells(self)
  if #self.rewardList > 0 then
    self.win_scroll_view:SetActive(false)
    self.delayClose = TimerManager:GetInstance():DelayInvoke(function()
      if self.win_scroll_view then
        self.win_scroll_view:SetActive(true)
        self.win_scroll_view:SetTotalCount(#self.rewardList)
        self.win_scroll_view:RefillCells()
      end
    end, 0.9)
  else
    self.win_scroll_view:SetActive(false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnCloseClick(self)
  if self.canClose == false then
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEResult)
  local result = PveActorMgr:GetInstance():GetBattleResult()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  if levelType == PveLevelType.FightLevel or levelType == PveLevelType.RadarExpLevel then
    if result == Const.Result.Win then
      DataCenter.BattleLevel:OnFinish()
      DataCenter.BattleLevel:CheckBattleReward()
    end
    DataCenter.BattleLevel:Exit()
  elseif levelType == PveLevelType.BattlePlayBackLevel then
    local param = PveActorMgr:GetInstance():GetLevelParam()
    local mailId, jumpType
    if param ~= nil and param.pveEntrance == PveEntrance.BattlePlayBack then
      mailId = param.mailId
      jumpType = param.jumpType
    end
    DataCenter.BattleLevel:Exit(function()
      if jumpType == PlayBackEndJumpType.Mail then
        if mailId ~= nil then
          GoToUtil.GotoOpenView(UIWindowNames.UIMailNew, MailInternalGroup.MAIL_IN_report, mailId)
        end
      elseif jumpType == PlayBackEndJumpType.Arena then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, 8)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaHistory)
      elseif jumpType == PlayBackEndJumpType.MineCave then
        DataCenter.MineCaveManager:SetEnemyPlayerPower()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, ActivityOverviewType.MineCave)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveLog)
      end
    end)
  elseif levelType == PveLevelType.NormalLevel or levelType == PveLevelType.HeroExpLevel or levelType == PveLevelType.NormalExpLevel or levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.SkillLevel then
    PveActorMgr:GetInstance():Leave()
  elseif levelType == PveLevelType.ArmyLevel then
    PveActorMgr:GetInstance():Leave()
    DataCenter.BattleLevel:UpdateArmyRecordHpBar(true)
  elseif levelType == PveLevelType.AdventureLevel then
    if result == Const.Result.Fail then
      DataCenter.BattleLevel:Exit()
    else
      PveActorMgr:GetInstance():Leave()
      DataCenter.AdventureManager:CheckShowReward()
    end
  end
end

local function OnFailBtnClick(self, idx)
  if idx == 0 then
    DataCenter.BattleLevel:Exit(function()
      local num = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER)
      if num <= 0 then
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER)
      else
        SceneUtils.ChangeToWorld(function()
          GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster, DataCenter.MonsterManager:GetCurCanAttackMaxLevel())
        end)
      end
    end)
  end
  if idx == 1 then
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK, WorldTileBtnType.City_TrainingInfantry)
    end)
  end
  if idx == 2 then
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE, WorldTileBtnType.City_Science)
    end)
  end
  if idx == 3 then
    DataCenter.BattleLevel:Exit(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance)
    end)
  end
end

local function OnAdventureExitClick(self)
  DataCenter.BattleLevel:Exit()
end

local function OnAdventureResetClick(self)
  local resetTime = DataCenter.AdventureManager:GetTodayRestResetTime()
  if 0 < resetTime then
    self.ctrl:CloseSelf()
    DataCenter.AdventureManager:SendReset()
  else
    UIUtil.ShowTipsId(302285)
  end
end

local function OnMonsterResetClick(self)
  local trigger = PveActorMgr:GetInstance():GetCurTrigger()
  if trigger ~= nil and trigger:IsMonsterWithHp() then
    self.ctrl:CloseSelf()
    PveActorMgr:GetInstance():ResetBattle()
    DataCenter.BattleLevel:EnterBattle(trigger, true)
  end
end

UIPVEResultView.OnCreate = OnCreate
UIPVEResultView.OnDestroy = OnDestroy
UIPVEResultView.OnEnable = OnEnable
UIPVEResultView.OnDisable = OnDisable
UIPVEResultView.OnCloseClick = OnCloseClick
UIPVEResultView.OnFailBtnClick = OnFailBtnClick
UIPVEResultView.AddHeroExpObj = AddHeroExpObj
UIPVEResultView.OnCreateCell = OnCreateCell
UIPVEResultView.OnDeleteCell = OnDeleteCell
UIPVEResultView.ShowCells = ShowCells
UIPVEResultView.OnAdventureExitClick = OnAdventureExitClick
UIPVEResultView.OnAdventureResetClick = OnAdventureResetClick
UIPVEResultView.OnMonsterResetClick = OnMonsterResetClick
UIPVEResultView.ShowArenaRewards = ShowArenaRewards
return UIPVEResultView
