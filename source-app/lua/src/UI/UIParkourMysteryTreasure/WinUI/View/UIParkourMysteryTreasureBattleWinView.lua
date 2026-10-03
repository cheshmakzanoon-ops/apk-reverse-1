local UIParkourMysteryTreasureBattleWinView = BaseClass("UIParkourMysteryTreasureBattleWinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LayoutLayer = "Layout/"
local get_path = "Layout/Get"
local get_icon_path = "Layout/Get/GetIcon"
local get_count_path = "Layout/Get/Numbers/GetCount"
local total_count_path = "Layout/Get/Numbers/TotalCount"

function UIParkourMysteryTreasureBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIParkourMysteryTreasureBattleWinView:OnDestroy()
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.showRewardAnimCo then
    self.showRewardAnimCo = nil
  end
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  if self.tweens ~= nil then
    for _, v in pairs(self.tweens) do
      if v then
        v:Kill()
      end
    end
    self.tweens = nil
  end
  if self.delayCheck then
    self.delayCheck:Stop()
    self.delayCheck = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourMysteryTreasureBattleWinView:ComponentDefine()
  local param = self:GetUserData()
  self.bg = self:AddComponent(UIImage, "Image")
  self.bg:SetAlpha(0)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.layout:SetActive(false)
  self.backBtn = self:AddComponent(UIButton, "Layout/BtnGroup/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, "Layout/BtnGroup/NextBtn")
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.nextBtnText = self:AddComponent(UIText, "Layout/BtnGroup/NextBtn/NextBtnText")
  self.nextBtnText:SetLocalText("activity_breakthrough_tips_27")
  self.getObject = self.transform:Find(get_path).gameObject
  self.getCoin = self:AddComponent(UIImage, get_icon_path)
  self.coinCount = self:AddComponent(UITextMeshProUGUIEx, get_count_path)
  self.totalCount = self:AddComponent(UITextMeshProUGUIEx, total_count_path)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.rewardContent = self.transform:Find(LayoutLayer .. "RewardBg").gameObject
  self.rewardTitle1 = self:AddComponent(UIText, LayoutLayer .. "RewardBg/RewardTitle1")
  self.rewardGrid1 = self:AddComponent(UIBaseContainer, LayoutLayer .. "RewardBg/RewardGrid1")
  self.backBtnText = self:AddComponent(UIText, "Layout/BtnGroup/BackBtn/BackBtnText")
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.rankEntry = self:AddComponent(UIBaseContainer, LayoutLayer .. "RankEntry")
  self.rankText1 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank1")
  self.rankText2 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank2")
  self.rankText3 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank3")
  self.rankEntry:SetActive(false)
  self.killAndTime = self:AddComponent(UIBaseContainer, LayoutLayer .. "KillAndTime")
  self.killText = self:AddComponent(UIText, LayoutLayer .. "KillAndTime/KillText")
  self.timeText = self:AddComponent(UIText, LayoutLayer .. "KillAndTime/TimeText")
  self.block = self:AddComponent(UIBaseContainer, LayoutLayer .. "Block")
  if not CommonUtil.IsArabic() then
    self.rankText1:SetText(Localization:GetString("800827"))
    self.rankText3:SetText(Localization:GetString("800828"))
  else
    self.rankText1:SetText(Localization:GetString("800828"))
    self.rankText3:SetText(Localization:GetString("800827"))
  end
  self.remainSolider = self:AddComponent(UIBaseContainer, "Layout/LevelRemainSolider")
  self.remainSoliderTitle = self:AddComponent(UIText, "Layout/LevelRemainSolider/LevelRemainTitle")
  self.remainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_24"))
  self.remainSoliderCount = self:AddComponent(UIText, "Layout/LevelRemainSolider/LevelRemainCount")
  self.totalRemainSolider = self:AddComponent(UIBaseContainer, "Layout/TotalRemainSolider")
  self.totalRemainSoliderTitle = self:AddComponent(UIText, "Layout/TotalRemainSolider/TotalRemainTitle")
  self.totalRemainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_25"))
  self.totalRemainSoliderCount = self:AddComponent(UIText, "Layout/TotalRemainSolider/TotalRemainCount")
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  local backBtnName = 800306
  self.backBtnText:SetText(Localization:GetString(backBtnName))
  self.victoryText:SetText(Localization:GetString("311105"))
  self.rewardTitle1:SetText(Localization:GetString("800305"))
  self.emptyGroupContainer = self:AddComponent(UIBaseContainer, "Layout/EmptyGroup")
  self.btnGroupContainer = self:AddComponent(UIBaseContainer, "Layout/BtnGroup")
  self.btnGroupLayoutElement = self:AddComponent(UILayoutElement, "Layout/BtnGroup")
  self.killAndTime.gameObject:SetActive(false)
  self.nextBtn.gameObject:SetActive(false)
  self.remainSolider.gameObject:SetActive(false)
  self.totalRemainSolider.gameObject:SetActive(false)
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  local stageIndex = table.indexof(feature.stages, param.stageId)
  if feature.winType[index] == 1 then
    if #feature.winType == 1 then
      self.showSeq = {
        self.levelText,
        self.getObject,
        self.rankEntry,
        self.rewardContent,
        self.backBtn
      }
    else
      self.showSeq = {
        self.levelText,
        self.getObject,
        self.rankEntry,
        self.rewardContent,
        self.backBtn
      }
      if stageIndex ~= #feature.stages then
        table.insert(self.showSeq, self.nextBtn)
      end
    end
  elseif feature.winType[index] == 2 then
    if #feature.stages == 1 then
      self.showSeq = {
        self.levelText,
        self.getObject,
        self.rankEntry,
        self.rewardContent,
        self.backBtn
      }
    elseif #feature.winType == 1 then
      if stageIndex == #feature.stages then
        self.showSeq = {
          self.levelText,
          self.remainSolider,
          self.totalRemainSolider,
          self.rewardContent,
          self.backBtn
        }
      else
        self.showSeq = {
          self.levelText,
          self.remainSolider,
          self.totalRemainSolider,
          self.backBtn,
          self.nextBtn
        }
      end
    elseif stageIndex == #feature.stages then
      self.showSeq = {
        self.levelText,
        self.getObject,
        self.rankEntry,
        self.rewardContent,
        self.backBtn
      }
    else
      self.showSeq = {
        self.levelText,
        self.getObject,
        self.rankEntry,
        self.rewardContent,
        self.backBtn,
        self.nextBtn
      }
    end
  elseif feature.winType[index] == 0 then
    if feature.caty and feature.caty[index] and tonumber(feature.caty[index]) == PVEType.LastStand then
      self:HideLevelInfo()
      self.showSeq = {
        self.levelText,
        self.killAndTime,
        self.rewardContent,
        self.backBtn
      }
    elseif stageIndex == #feature.stages then
      self.showSeq = {
        self.levelText,
        self.killAndTime,
        self.rewardContent,
        self.backBtn
      }
    else
      self.showSeq = {
        self.levelText,
        self.killAndTime,
        self.rewardContent,
        self.backBtn,
        self.nextBtn
      }
    end
  end
  for _, c in ipairs(self.showSeq) do
    c:SetActive(false)
    c.transform:Set_localScale(0, 0, 0)
  end
  if DataCenter.StageFeatureBuildingManager.reward and 0 < #DataCenter.StageFeatureBuildingManager.reward then
    self:OnGetReward(DataCenter.StageFeatureBuildingManager.reward)
  end
  self:ShowRewardAnim()
end

function UIParkourMysteryTreasureBattleWinView:DataDefine()
  self.flyRewardList = {}
end

function UIParkourMysteryTreasureBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourMysteryTreasureBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIParkourMysteryTreasureBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourMysteryTreasureBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIParkourMysteryTreasureBattleWinView:ComponentDestroy()
  self.getCoin = nil
  self.coinCount = nil
  self.totalCount = nil
  self.bg = nil
  self.nextBtn = nil
  self.nextBtnText = nil
  self.backBtn = nil
  self.backBtnText = nil
  self.canvasGroup = nil
  self.levelText = nil
  self.rewardTitle1 = nil
  self.rewardGrid1 = nil
  self.rankEntry = nil
  self.remainSolider = nil
  self.remainSoliderCount = nil
  self.layout = nil
  self.getObject = nil
  self.victoryText = nil
  self.rankText1 = nil
  self.rankText2 = nil
  self.rankText3 = nil
  self.block = nil
  self.remainSoliderTitle = nil
  self.totalRemainSolider = nil
  self.totalRemainSoliderTitle = nil
  self.totalRemainSoliderCount = nil
  self.emptyGroupContainer = nil
  self.btnGroupContainer = nil
  self.btnGroupLayoutElement = nil
  self.killAndTime = nil
  self.killText = nil
  self.timeText = nil
end

function UIParkourMysteryTreasureBattleWinView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  local param = self:GetUserData()
  if param.enterType == PVEEnterType.StageFeatureBuilding then
    self.rewardTitle1:SetText(Localization:GetString("newbies_fuben_award_desc"))
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
    local index = 1
    if 1 < #feature.winType then
      index = table.indexof(feature.stages, param.stageId)
    end
    local stageIndex = table.indexof(feature.stages, param.stageId)
    if feature.winType[index] == 1 then
      if #feature.winType == 1 then
        self.levelText:SetLocalText("newbies_fuben_title")
      else
        local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), feature.stages[stageIndex], "desc")
        self.levelText:SetLocalText(desc)
      end
      self.getCoin:LoadSprite("Assets/Main/Sprites/ItemIcons/itemCoin.png")
      self.coinCount:SetText(param.coin)
      self.totalCount:SetText(tostring(feature.winNeedCount[index]))
      self.rankText2:SetText(string.format("%s", param.rank) .. "%")
      PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleWin, {
        param1 = tostring(param.coin)
      })
    elseif feature.winType[index] == 2 then
      if #feature.winType == 1 then
        if #feature.stages == 1 then
          self.levelText:SetLocalText("newbies_fuben_title")
          self.getCoin:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png")
          self.coinCount:SetText(param.remainNumber)
          self.totalCount:SetText(tostring(feature.winNeedCount[index]))
        else
          local content = Localization:GetString("newbies_fuben_title")
          self.levelText:SetText(string.format("%s %d/%d", content, stageIndex, tostring(#feature.stages)))
          self.remainSoliderCount:SetText(string.format("X %d", param.remainNumber or 0))
          self.totalRemainSoliderCount:SetText(string.format("%d", param.remainTotalNumber or 0) .. "/" .. tostring(param.needTotalNumber))
        end
      else
        local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), feature.stages[stageIndex], "desc")
        self.levelText:SetLocalText(desc)
        self.getCoin:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png")
        self.coinCount:SetText(param.remainNumber)
        self.totalCount:SetText(tostring(feature.winNeedCount[index]))
        self.rankText2:SetText(string.format("%s", param.rank) .. "%")
      end
      PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleWin, {
        param1 = tostring(param.remainNumber)
      })
    elseif feature.winType[index] == 0 then
      if #feature.winType == 1 then
        self.levelText:SetLocalText("newbies_fuben_title")
      else
        local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), feature.stages[stageIndex], "desc")
        self.levelText:SetLocalText(desc)
      end
      self.killText:SetText(Localization:GetString("800303") .. " " .. param.kill)
      self.timeText:SetText(Localization:GetString("800304") .. " " .. UITimeManager:GetInstance():SecondToFmtStringWithoutHour(param.time))
      PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleWin)
    end
    if 1 < #feature.winType and index < 3 then
      DataCenter.StageFeatureBuildingManager.MysteryRewardUpgradeLv = index
    end
  elseif param and param.rewardTitle then
    self.rewardTitle1:SetLocalText(param.rewardTitle)
  end
end

function UIParkourMysteryTreasureBattleWinView:OnNextBtnClick()
  self.ctrl:CloseSelf()
  local param = self:GetUserData()
  if param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnEnterBattle(param.buildUuid)
  end
end

function UIParkourMysteryTreasureBattleWinView:OnBackBtnClick()
  local param = self:GetUserData()
  local cfg = {}
  for i, v in ipairs(self.flyRewardList) do
    cfg[i] = {
      v[1].position,
      v[2]
    }
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  if feature.caty[index] == "0" then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  else
    DataCenter.LWBattleManager:Exit(nil, "win")
  end
  DataCenter.StageFeatureBuildingManager:OnExitBattle(param.buildUuid)
end

function UIParkourMysteryTreasureBattleWinView:CheckShowFirstPay()
  local param = self:GetUserData()
  local monopolyEnter
  if param and param.enterType and param.enterType == PVEEnterType.Monopoly then
    monopolyEnter = true
  end
  local showFirstPay
  if monopolyEnter then
    local logic = DataCenter.LWBattleManager.logic
    if logic and logic.initUnitDeath then
      showFirstPay = true
    end
  end
  local curMonopoly = DataCenter.MonopolyManager.player.curId
  local realShow
  if showFirstPay then
    local lastMonopoly = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.LAST_MONOPOLY_FIRSTPAY, 0)
    local passCount = LuaEntry.DataConfig:TryGetNum("first_cost_intensifying", "k1", -1)
    local endCount = LuaEntry.DataConfig:TryGetNum("first_cost_intensifying", "k2", -1)
    if -1 < endCount and curMonopoly > endCount then
      realShow = false
    elseif passCount == -1 then
      realShow = false
    elseif passCount == 0 then
      realShow = true
    elseif passCount < curMonopoly - lastMonopoly then
      realShow = true
    else
      realShow = false
    end
  end
  if realShow then
    local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
    local hasFirstPayGift = false
    if isNewFirstPay then
      local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
      hasFirstPayGift = firstPayPack ~= nil
    else
      local firstPayState = DataCenter.FirstPayManager:GetState()
      hasFirstPayGift = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
    end
  end
end

function UIParkourMysteryTreasureBattleWinView:OnGetReward(param)
  param = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.rewardCells = {}
  self.reqs = {}
  self.flyRewardList = {}
  local index = 0
  for _, v in pairs(param) do
    local req
    local p = v
    req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    index = index + 1
    local name = index
    req:completed("+", function(req)
      if req.isError or req.gameObject == nil then
        return
      end
      local go = req.gameObject
      go.name = name
      CommonUtil.CallAutoArabicMirrorManually(req)
      go.transform:SetParent(self.rewardGrid1.transform)
      table.insert(self.rewardCells, go)
      go.transform:Set_localScale(0, 0, 0)
      local cell
      if p.rewardType == RewardType.HERO then
        cell = self:AddComponent(UIHeroCellSmall, go)
        cell:SetData(p.heroUuid)
      else
        cell = self:AddComponent(UICommonResItem, go)
        cell:ReInit(p)
      end
      cell.gameObject:SetActive(false)
      table.insert(self.flyRewardList, {
        go.transform,
        p
      })
    end)
    table.insert(self.reqs, req)
  end
  DataCenter.StageFeatureBuildingManager.reward = nil
end

function UIParkourMysteryTreasureBattleWinView:ShowRewardAnim()
  local delay = 0.1
  local scaledelay = 0.2
  local finalScale = 1
  local finalScale2 = 1
  self.showRewardAnimCo = coroutine.start(function()
    coroutine.waitforseconds(1.5)
    self.layout:SetActive(true)
    if not IsNull(self.bg.unity_image) then
      self.bg.unity_image:DOFade(0.8784313725490196, 0.3)
    end
    coroutine.waitforseconds(1)
    for i = 1, #self.showSeq do
      coroutine.waitforseconds(delay)
      self.showSeq[i]:SetActive(true)
      if not IsNull(self.showSeq[i].transform) then
        self.showSeq[i].transform:DOScale(finalScale, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
      end
    end
    coroutine.waitforseconds(delay)
    for i, cells in ipairs({
      self.rewardCells,
      self.herosCells,
      self.workersCells
    }) do
      if 0 < #cells then
        local trans = self.showSeq[#self.showSeq - (4 - i)].transform
        if not IsNull(trans) then
          self.showSeq[#self.showSeq - (4 - i)]:SetActive(true)
          self.showSeq[#self.showSeq - (4 - i)].transform:DOScale(finalScale, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
          for i = 1, #cells do
            coroutine.waitforseconds(delay)
            cells[i]:SetActive(true)
            cells[i].transform:DOScale(finalScale2, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
          end
        end
      end
      coroutine.waitforseconds(delay)
    end
    if self.heroId and DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroId, {
        self.heroId
      }, nil, true)
    end
    self.showSeq[#self.showSeq]:SetActive(true)
    if self.isGoldLevel then
    end
  end)
end

function UIParkourMysteryTreasureBattleWinView:OnKeyCodeEscape()
  self:CreateDelayTimer(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIParkourMysteryTreasureBattleWinView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function UIParkourMysteryTreasureBattleWinView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function UIParkourMysteryTreasureBattleWinView:HideLevelInfo()
  self.killText:SetText("")
  self.timeText:SetText("")
  self.levelText:SetText("")
end

return UIParkourMysteryTreasureBattleWinView
