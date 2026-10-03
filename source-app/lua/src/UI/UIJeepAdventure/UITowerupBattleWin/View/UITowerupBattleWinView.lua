local UITowerupBattleWinView = BaseClass("UITowerupBattleWinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LayoutLayer = "Layout/"
local UIStatisticList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleStatisticHeroList")
local UIBattleRewardList = require("UI.UIJeepAdventure.UITowerupBattleWin.Component.UIBattleRewardList")
local UILWTrainBattleEndScienceContainer = require("UI.UILWRailway.UILWTrainBattleEnd.UILWTrainBattleEndScienceContainer")
local back_toggle_path = "Layout/backToggle"
local checkbox_text = "Layout/backToggle/Text"
local share_btn_path = "Layout/Btns/ShareBtn"
local share_btn_text_path = "Layout/Btns/ShareBtn/ShareBtnText"
local autoWaitTime = 5000
local DynamicAssetName = {
  RewardScroll = "RewardScroll",
  MakeDmgScroll = "MakeDmgScroll",
  TakeDmgScroll = "TakeDmgScroll",
  TrainBattleEndScienceContainer = "TrainBattleEndScienceContainer"
}
local DynamicAsset = {
  [DynamicAssetName.RewardScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleRewardScroll.prefab",
    class = UIBattleRewardList,
    parentPath = "Layout"
  },
  [DynamicAssetName.MakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleMakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Layout"
  },
  [DynamicAssetName.TakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleTakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Layout"
  },
  [DynamicAssetName.TrainBattleEndScienceContainer] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainBattleEndScienceContainer.prefab",
    class = UILWTrainBattleEndScienceContainer,
    parentPath = "Layout"
  }
}

function UITowerupBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Show()
end

function UITowerupBattleWinView:OnDestroy()
  self:DeleteTimer()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.showRewardAnimCo then
    self.showRewardAnimCo = nil
  end
  if self.dynamicReqs then
    for k, v in pairs(self.dynamicReqs) do
      v:Destroy()
    end
    self.dynamicReqs = nil
  end
  self.tabIdx = nil
  self.rewardParam = nil
  self:ComponentDestroy()
  self.tabComps = nil
  base.OnDestroy(self)
end

function UITowerupBattleWinView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "Btns/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, LayoutLayer .. "Btns/NextBtn")
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    self:ShareBtnClick()
  end)
  self.share_btn_text = self:AddComponent(UITextMeshProUGUIEx, share_btn_text_path)
  self.share_btn_text:SetLocalText("truck_btn001")
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.victoryText:SetText(Localization:GetString("311105"))
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.backBtnText = self:AddComponent(UIText, LayoutLayer .. "Btns/BackBtn/BackBtnText")
  self.nextBtnText = self:AddComponent(UIText, LayoutLayer .. "Btns/NextBtn/BtnText")
  local param, battleManagerParam = self:GetUserData()
  self.battleManagerParam = battleManagerParam
  local stageId = param.stageId
  if self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    self.cfgId = self.battleManagerParam.extraData.cfgId
    self.pageType = self.battleManagerParam.extraData.pageType
    local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId, self.pageType)
    if targetStageMeta then
      stageId = targetStageMeta.idle_reward_stageid
    end
  elseif self.battleManagerParam.enterType == PVEEnterType.HeroTryOut then
    stageId = nil
  end
  if stageId and self.battleManagerParam.enterType ~= PVEEnterType.DetectZombieBusTrain then
    self.stageTemp = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId)
  end
  if self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    local isSwitchOn = DataCenter.LWJeepAdventureManager:GetBackSwitchOn()
    if isSwitchOn then
      self.backBtnText:SetLocalText(300520)
    else
      self.backBtnText:SetLocalText(800306)
    end
    self.nextBtnText:SetLocalText(456809)
    local nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId + 1, self.pageType)
    self.nextBtn:SetActive(nextTemplate ~= nil)
  elseif self.battleManagerParam.enterType == PVEEnterType.TruckRob or self.battleManagerParam.enterType == PVEEnterType.HSRRob then
    self.backBtnText:SetLocalText(300520)
    self.nextBtn:SetActive(false)
  elseif self.battleManagerParam.enterType == PVEEnterType.DetectZombieBusTrain then
    self.backBtnText:SetLocalText(300520)
    local showNextBtn = false
    local isInWorldEnter = self.battleManagerParam.extraData.isInWorld
    local curBusIndex = self.battleManagerParam.extraData.busIndex
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    showNextBtn = isInWorldEnter and nextBusData ~= nil
    self.nextBtn:SetActive(showNextBtn)
  elseif self.battleManagerParam.enterType == PVEEnterType.HeroTryOut then
    self.backBtnText:SetLocalText(300520)
    self.nextBtn:SetActive(false)
  else
    self.nextBtn:SetActive(false)
  end
  if stageId and self.battleManagerParam.enterType ~= PVEEnterType.DetectZombieBusTrain then
    self.levelText:SetText(Localization:GetString("800313", GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId, "level")))
  else
    self.levelText:SetText("")
  end
  self.tabBtns = {
    self:AddComponent(UIButton, "Layout/Tabs/RewardBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  local rewardScroll = self:AddComponent(DynamicAsset[DynamicAssetName.RewardScroll].class, "Layout/RewardScroll")
  self.tabComps = {
    [1] = {
      assetName = DynamicAssetName.RewardScroll,
      comp = rewardScroll,
      param1 = "reward"
    },
    [2] = {
      assetName = DynamicAssetName.TakeDmgScroll,
      comp = nil,
      param1 = "makeDmg"
    },
    [3] = {
      assetName = DynamicAssetName.MakeDmgScroll,
      comp = nil,
      param1 = "takeDmg"
    }
  }
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Layout/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/RewardBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(456808)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/RewardBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(456808)
  self.checkbox_text = self:AddComponent(UIText, checkbox_text)
  self.checkbox_text:SetLocalText(456810)
  self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function(value)
    self:OnToggerChangeFunc(value)
  end)
  self.autoNextStageStartTime = -1
end

function UITowerupBattleWinView:Show()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITowerupBattleWin) then
      self.canvasGroup:DOFade(1, 0.2)
      self:RefreshView()
    end
  end, 1.5)
  self:OnGetReward(DataCenter.TowerUpSaveDataManager.saveData)
  self:RefreshAutoNextStageToggerView()
  self:AddTimer()
  self.share_btn:SetActive(self.battleManagerParam.enterType == PVEEnterType.TruckRob)
end

function UITowerupBattleWinView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:RefreshView()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 204, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UITowerupBattleWinView:DataDefine()
  self.heroId = nil
  self.dynamicReqs = {}
end

function UITowerupBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UITowerupBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UITowerupBattleWinView:OnKeyCodeEscape()
  if self.exitTimer == nil then
    self.exitTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
      self:OnBackBtnClick()
      if self.exitTimer then
        self.exitTimer:Stop()
        self.exitTimer = nil
      end
    end, 1)
  end
end

function UITowerupBattleWinView:ComponentDestroy()
  self.back_btn = nil
  self.nextBtn = nil
  self.layout = nil
  self.canvasGroup = nil
  self.victoryText = nil
  self.levelText = nil
  self.backBtnText = nil
  self.nextBtnText = nil
  self.battleManagerParam = nil
  self.stageTemp = nil
  self.tabBtns = nil
  self.tabComps = nil
  self.highlightMask = nil
  self.highlightInner = nil
  self.checkbox_text = nil
  self.back_toggle = nil
  self.autoNextStageStartTime = nil
  self.share_btn = nil
  self.share_btn_text = nil
end

function UITowerupBattleWinView:RefreshView()
  for i, v in ipairs(self.tabComps) do
    local assetName = v.assetName
    local tabComp = v.comp
    if i == self.tabIdx then
      if i == 1 then
        tabComp:SetActive(true)
        tabComp:RefreshView()
        tabComp:FadeIn()
      elseif self.dynamicReqs[assetName] ~= nil then
        if tabComp then
          tabComp:SetActive(true)
          tabComp:FadeIn()
        end
      else
        local req = self:GameObjectInstantiateAsync(DynamicAsset[assetName].prefabPath, function(request)
          if self.tabIdx == nil then
            request:Destroy()
            return
          end
          local go = request.gameObject
          go.name = assetName
          local parentPath = DynamicAsset[assetName].parentPath
          go.transform.parent = self.transform:Find(parentPath)
          local comp = self:AddComponent(DynamicAsset[assetName].class, parentPath .. "/" .. assetName, v.param1, self.battleManagerParam)
          self.tabComps[i].comp = comp
          comp:SetLocalScale(Vector3.one)
          comp:SetAnchorMinXY(0.5, 0)
          comp:SetAnchorMaxXY(0.5, 1)
          comp:SetAnchoredPositionXY(0, -528.06)
          comp:SetSizeDeltaXY(616, -781.66)
          comp:RefreshView()
          if self.tabIdx == i then
            comp:SetActive(true)
            comp:FadeIn()
          else
            comp:SetActive(false)
          end
        end)
        self.dynamicReqs[assetName] = req
      end
    elseif tabComp then
      tabComp:SetActive(false)
    end
  end
  if self.battleManagerParam.enterType == PVEEnterType.TruckRob and self.tabIdx == 1 then
    local trainRewards = self.battleManagerParam.attackTrainReward
    local showTips = false
    for i = 1, #trainRewards do
      local reward = trainRewards[i]
      if reward.trainRewardState and reward.trainRewardState == TrainRewardState.Recapture then
        showTips = true
        break
      end
    end
    local assetName = DynamicAssetName.TrainBattleEndScienceContainer
    if self.dynamicReqs[assetName] then
      if self.trainBattleEndScienceContainer then
        self.trainBattleEndScienceContainer:SetActive(true)
        self.trainBattleEndScienceContainer:ReInit(showTips)
      end
    else
      do
        local req = self:GameObjectInstantiateAsync(DynamicAsset[assetName].prefabPath, function(request)
          if self.tabIdx == nil then
            request:Destroy()
            return
          end
          local go = request.gameObject
          go.name = assetName
          local parentPath = DynamicAsset[assetName].parentPath
          go.transform.parent = self.transform:Find(parentPath)
          self.trainBattleEndScienceContainer = self:AddComponent(DynamicAsset[assetName].class, parentPath .. "/" .. assetName)
          if self.tabIdx == 1 then
            self.trainBattleEndScienceContainer:SetActive(true)
            self.trainBattleEndScienceContainer:SetLocalScale(Vector3.one)
            self.trainBattleEndScienceContainer:SetLocalPositionXYZ(0, -325, 0)
            self.trainBattleEndScienceContainer:ReInit(showTips)
          else
            self.trainBattleEndScienceContainer:SetActive(false)
          end
        end)
        self.dynamicReqs[assetName] = req
      end
    end
  elseif self.trainBattleEndScienceContainer then
    self.trainBattleEndScienceContainer:SetActive(false)
  end
end

function UITowerupBattleWinView:OnBackBtnClick()
  local battleManagerParam = self.battleManagerParam
  DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
  if battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    if battleManagerParam.type == PVEType.FakePVP or battleManagerParam.type == PVEType.Parkour then
      DataCenter.LWBattleManager:SetBattleExitFlag(true)
      DataCenter.LWBattleManager:Exit(function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end)
    elseif battleManagerParam.type == PVEType.Barrage then
      DataCenter.ZombieBattleManager:SetBattleExitFlag(true)
      DataCenter.ZombieBattleManager:Exit(function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end, LWStageType.TowerupAdvanture)
    end
  elseif battleManagerParam.enterType == PVEEnterType.HeroTryOut then
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit(nil, "win")
  else
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit()
  end
end

function UITowerupBattleWinView:OnNextBtnClick()
  if self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    if self.cfgId > 0 and self.pageType then
      local curId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(self.pageType)
      if curId ~= self.cfgId then
        local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId, self.pageType)
        if targetStageMeta then
          if targetStageMeta.type == TowerupBattleType.Zombie or targetStageMeta.type == TowerupBattleType.Parkour then
            UIUtil.ShowTipsId("towerup_001")
          else
            local serverMsg = self.battleManagerParam.extraData.serverMsg
            local isWin = -1
            local id = -1
            if serverMsg ~= nil then
              isWin = serverMsg.isWin
              id = serverMsg.id
            end
            Logger.LogError("TowerupBattleWinView curId and self.cfgId is diff " .. "curId:" .. tostring(curId) .. "self.cfgId:" .. tostring(self.cfgId) .. "isWin:" .. tostring(isWin) .. "id:" .. tostring(id))
          end
        else
          Logger.LogError("TowerupBattleWinView curId and self.cfgId is diff " .. "curId:" .. tostring(curId) .. "self.cfgId:" .. tostring(self.cfgId) .. " targetStageMeta is nil")
        end
        return
      end
      DataCenter.LWJeepAdventureManager:EnterBattle(curId + 1, self.pageType)
    end
  elseif self.battleManagerParam.enterType == PVEEnterType.DetectZombieBusTrain then
    local isInWorldEnter = self.battleManagerParam.extraData.isInWorld
    local curBusIndex = self.battleManagerParam.extraData.busIndex
    local curEventId = self.battleManagerParam.extraData.eventUuid
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    if isInWorldEnter and nextBusData then
      DataCenter.LWBattleManager:Destroy()
      local lastPosition, lastEuler = DataCenter.RadarCenterDataManager:GetLastZombieBusBattleEnterPosAndEuler()
      DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(nextBusData, nextBusIndex, curEventId, lastPosition, lastEuler)
    else
      self:OnBackBtnClick()
    end
  end
end

function UITowerupBattleWinView:OnGetReward(param)
  if self.battleManagerParam.enterType == PVEEnterType.TruckRob then
    param = DataCenter.RewardManager:ReturnRewardParamForMessage(self.battleManagerParam.attackTrainReward)
  elseif self.battleManagerParam.enterType == PVEEnterType.DetectZombieBusTrain or self.battleManagerParam.enterType == PVEEnterType.HSRRob then
    param = DataCenter.RewardManager:ReturnRewardParamForMessage(self.battleManagerParam.reward)
  else
    param = DataCenter.RewardManager:ReturnRewardParamForMessage(param)
  end
  if param == nil then
    return
  end
  self.rewardParam = param
  if self.tabComps[1].comp then
    self.tabComps[1].comp:RefreshView()
  end
end

function UITowerupBattleWinView:OnToggerChangeFunc(state)
  if not self.battleManagerParam then
    return
  end
  if self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure and self.pageType == JeepAdventurePageType.Domintor then
    if state then
      local isCanAuto = DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator()
      if not isCanAuto then
        UIUtil.ShowTipsId("dominator_pve_dec_10")
        self.back_toggle:SetIsOn(false)
        return
      else
        DataCenter.TowerUpSaveDataManager:SetAutoNextStage(true)
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      end
    else
      DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
      self.autoNextStageStartTime = -1
    end
  else
    local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    if isNext ~= state then
      DataCenter.TowerUpSaveDataManager:SetAutoNextStage(state)
      isNext = state
      if isNext then
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      else
        self.autoNextStageStartTime = -1
      end
    end
  end
end

function UITowerupBattleWinView:RefreshAutoNextStageToggerView()
  if self.battleManagerParam.enterType == PVEEnterType.TruckRob or self.battleManagerParam.enterType == PVEEnterType.HSRRob then
    self.back_toggle:SetActive(false)
  elseif self.battleManagerParam.enterType == PVEEnterType.DetectZombieBusTrain then
    self.back_toggle:SetActive(false)
  elseif self.battleManagerParam.enterType == PVEEnterType.HeroTryOut then
    self.back_toggle:SetActive(false)
  elseif self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    self.back_toggle:SetActive(true)
    if self.pageType == JeepAdventurePageType.Domintor then
      local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
      if not isNext then
        self.back_toggle:SetIsOn(false)
        self.autoNextStageStartTime = -1
      else
        local isCanAuto = DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator()
        if not isCanAuto then
          DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
          self.back_toggle:SetIsOn(false)
          self.autoNextStageStartTime = -1
        else
          self.back_toggle:SetIsOn(true)
          self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
        end
      end
    else
      local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
      local curShowState = self.back_toggle:GetIsOn()
      self.back_toggle:SetIsOn(isNext)
      if isNext then
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      else
        self.autoNextStageStartTime = -1
      end
    end
  end
end

function UITowerupBattleWinView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.CheckAutoNext, self, false, false, false)
  end
  self.timer:Start()
end

function UITowerupBattleWinView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.exitTimer then
    self.exitTimer:Stop()
    self.exitTimer = nil
  end
end

function UITowerupBattleWinView:CheckAutoNext()
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

function UITowerupBattleWinView:ShareBtnClick()
  local shareParam = {}
  if self.battleManagerParam.enterType == PVEEnterType.TruckRob then
    if self.battleManagerParam.mailUid == nil then
      UIUtil.ShowTipsId("battle_report_loading")
      return
    end
    local mailData = DataCenter.MailDataManager:GetMailInfoById(self.battleManagerParam.mailUid)
    if mailData == nil then
      UIUtil.ShowTipsId("battle_report_loading")
      return
    end
    shareParam.post = PostType.Text_FightReport
    shareParam.param = {}
    shareParam.param.reportUid = mailData.uid
    shareParam.param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
    shareParam.param.mailType = mailData.type
    shareParam.param.toUser = mailData.toUser
    local extData = mailData:GetMailExt()
    if extData then
      shareParam.param.train_quality = extData.trainData.train_quality
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

return UITowerupBattleWinView
