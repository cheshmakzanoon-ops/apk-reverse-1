local UILWT11IdleGameBattleMainView = BaseClass("UILWT11IdleGameBattleMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UILWT11IdleGameBattleMain_BattleContentComponent = require("UI/T11IdleGame/T11IdleGameBattleMain/Component/UILWT11IdleGameBattleMain_BattleContentComponent")
local UILWT11IdleGameBattleMain_EntranceContentComponent = require("UI/T11IdleGame/T11IdleGameBattleMain/Component/UILWT11IdleGameBattleMain_EntranceContentComponent")
local UILWT11IdleGameBattleMain_BossContentComponent = require("UI/T11IdleGame/T11IdleGameBattleMain/Component/UILWT11IdleGameBattleMain_BossContentComponent")

function UILWT11IdleGameBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  self.passDayTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self:OnPassDay()
  end, remainTimeS)
end

function UILWT11IdleGameBattleMainView:OnDestroy()
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnLWBack = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnLWBack:SetOnClick(function()
    self:OnBtnLWBackClick()
  end)
  self.compChangeEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compEffUiT11IdleChangeBack = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compEffUiT11IdleChange = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.textTitle:SetLocalText("t11_idle_game_name_1")
end

function UILWT11IdleGameBattleMainView:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWInfo = nil
  self.textTitle = nil
  self.compRoot = nil
  self.btnLWBack = nil
  self.compChangeEffect = nil
  self.compEffUiT11IdleChangeBack = nil
  self.compEffUiT11IdleChange = nil
end

function UILWT11IdleGameBattleMainView:DataDefine()
  self.battleCompReq = nil
  self.battleComp = nil
  self.entranceCompReq = nil
  self.entranceComp = nil
  self.bossCompReq = nil
  self.bossComp = nil
  self.contentType = Const.MainViewContentType.None
end

function UILWT11IdleGameBattleMainView:DataDestroy()
  if self.delayShowLevelChangeRewardTimer then
    self.delayShowLevelChangeRewardTimer:Stop()
    self.delayShowLevelChangeRewardTimer = nil
  end
  if self.delayShowEndGameRewardTimer then
    self.delayShowEndGameRewardTimer:Stop()
    self.delayShowEndGameRewardTimer = nil
  end
  self.battleCompReq = nil
  self.battleComp = nil
  self.entranceCompReq = nil
  self.entranceComp = nil
  self.bossCompReq = nil
  self.bossComp = nil
  self.contentType = nil
end

function UILWT11IdleGameBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameOnGetIdleGameMainMessage, self.OnGetMainMessage)
  self:AddUIListener(EventId.T11IdleGameOnStartIdleGameMessage, self.OnStartGameMessage)
  self:AddUIListener(EventId.T11IdleGameOnShowEndGameReward, self.OnShowEndGameReward)
  self:AddUIListener(EventId.T11IdleGameOnClickEnterBossBattle, self.OnClickEnterBoss)
  self:AddUIListener(EventId.T11IdleGameOnLevelChanged, self.OnLevelChanged)
  self:AddUIListener(EventId.T11IdleGameOnInitMessage, self.OnInitMessage)
end

function UILWT11IdleGameBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameOnGetIdleGameMainMessage, self.OnGetMainMessage)
  self:RemoveUIListener(EventId.T11IdleGameOnStartIdleGameMessage, self.OnStartGameMessage)
  self:RemoveUIListener(EventId.T11IdleGameOnShowEndGameReward, self.OnShowEndGameReward)
  self:RemoveUIListener(EventId.T11IdleGameOnClickEnterBossBattle, self.OnClickEnterBoss)
  self:RemoveUIListener(EventId.T11IdleGameOnLevelChanged, self.OnLevelChanged)
  self:RemoveUIListener(EventId.T11IdleGameOnInitMessage, self.OnInitMessage)
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMainView:OnOpen()
  DataCenter.T11IdleGameDataManager:SendGetIdleGameMainMessage()
  DataCenter.T11IdleGameManager:SetHasShownAlertTowerBubbleRedToday()
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameRefreshAlertTowerBubble)
  self.compEffUiT11IdleChange:SetActive(false)
  self.compEffUiT11IdleChangeBack:SetActive(false)
  DataCenter.LWSoundManager:PlaySound(91023, false)
end

function UILWT11IdleGameBattleMainView:OnGetMainMessage()
  self.infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if self.contentType ~= Const.MainViewContentType.None then
    return
  end
  if not self.infoData or not self.infoData:IsHasStarted() then
    self:CreateEntranceContent({isFromOpen = true}, false)
  else
    self:CreateBattleContent({isFromOpen = true}, false)
  end
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData and mainData:HasSurpriseBox() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameSurpriseBox, {anim = true})
  end
  local timeNow = UITimeManager:GetInstance():GetServerTime()
  DataCenter.T11IdleGameDataManager:SetLastEventTipsUpdateTime(timeNow)
end

function UILWT11IdleGameBattleMainView:CreateBossContent(param, isSwitching)
  if not self.bossCompReq and not self.bossComp then
    local req = self:GameObjectInstantiateAsync(Const.MainBossContentUIPrefabPath)
    req:completed("+", function()
      if not IsNull(req.gameObject) and not IsNull(self.compRoot) then
        local pageObj = req.gameObject
        local transform = pageObj.transform
        transform:SetParent(self.compRoot.transform)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        transform:Set_sizeDelta(0, 0)
        transform:SetAsFirstSibling()
        self.bossComp = self:AddComponent(UILWT11IdleGameBattleMain_BossContentComponent, pageObj)
        self.bossComp:SetActive(true)
        self.bossComp:ReInit(param)
        if isSwitching == true then
          self.bossComp:PlayChangeAnim()
        end
      end
    end)
    self.bossCompReq = req
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UILWT11IdleGameBattleMainView:CreateBossContent: \233\135\141\229\164\141\229\136\155\229\187\186")
  end
  self.contentType = Const.MainViewContentType.Boss
end

function UILWT11IdleGameBattleMainView:CreateBattleContent(param, isSwitching)
  if not self.battleCompReq and not self.battleComp then
    local req = self:GameObjectInstantiateAsync(Const.MainBattleContentUIPrefabPath)
    req:completed("+", function()
      if not IsNull(req.gameObject) and not IsNull(self.compRoot) then
        local pageObj = req.gameObject
        local transform = pageObj.transform
        transform:SetParent(self.compRoot.transform)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        transform:Set_sizeDelta(0, 0)
        transform:SetAsFirstSibling()
        self.battleComp = self:AddComponent(UILWT11IdleGameBattleMain_BattleContentComponent, pageObj)
        self.battleComp:SetActive(true)
        self.battleComp:ReInit(param)
        if isSwitching == true then
          self.battleComp:PlayChangeAnim()
        end
      end
    end)
    self.battleCompReq = req
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UILWT11IdleGameBattleMainView:CreateBattleContent: \233\135\141\229\164\141\229\136\155\229\187\186")
  end
  self.contentType = Const.MainViewContentType.Battle
end

function UILWT11IdleGameBattleMainView:CreateEntranceContent(param, isSwitching)
  if not self.entranceCompReq and not self.entranceComp then
    local req = self:GameObjectInstantiateAsync(Const.MainEntranceContentUIPrefabPath)
    req:completed("+", function()
      if not IsNull(req.gameObject) and not IsNull(self.compRoot) then
        local pageObj = req.gameObject
        local transform = pageObj.transform
        transform:SetParent(self.compRoot.transform)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        transform:Set_sizeDelta(0, 0)
        transform:SetAsFirstSibling()
        self.entranceComp = self:AddComponent(UILWT11IdleGameBattleMain_EntranceContentComponent, pageObj)
        self.entranceComp:SetActive(true)
        self.entranceComp:ReInit(param)
        if isSwitching == true then
          self.entranceComp:PlayChangeAnim()
        end
      end
    end)
    self.entranceCompReq = req
    DataCenter.T11IdleGameManager:PrintRealWarningLog("UILWT11IdleGameBattleMainView:CreateEntranceContent: \229\188\128\229\167\139\229\136\155\229\187\186")
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UILWT11IdleGameBattleMainView:CreateEntranceContent: \233\135\141\229\164\141\229\136\155\229\187\186")
  end
  self.contentType = Const.MainViewContentType.Entrance
end

function UILWT11IdleGameBattleMainView:DestroyBattleContent()
  if self.battleComp then
    self:RemoveComponents(UILWT11IdleGameBattleMain_BattleContentComponent)
  end
  self.battleComp = nil
  if self.battleCompReq then
    self.battleCompReq:Destroy()
    self.battleCompReq = nil
  end
end

function UILWT11IdleGameBattleMainView:DestroyEntranceContent()
  if self.entranceComp then
    self:RemoveComponents(UILWT11IdleGameBattleMain_EntranceContentComponent)
  end
  self.entranceComp = nil
  if self.entranceCompReq then
    self.entranceCompReq:Destroy()
    self.entranceCompReq = nil
  end
  DataCenter.T11IdleGameManager:PrintRealWarningLog("UILWT11IdleGameBattleMainView:DestroyEntranceContent: \229\188\128\229\167\139\233\148\128\230\175\129")
end

function UILWT11IdleGameBattleMainView:DestroyBossContent()
  if self.bossComp then
    self:RemoveComponents(UILWT11IdleGameBattleMain_BossContentComponent)
  end
  self.bossComp = nil
  if self.bossCompReq then
    self.bossCompReq:Destroy()
    self.bossCompReq = nil
  end
end

function UILWT11IdleGameBattleMainView:OnStartGameMessage()
  self:StopChangeUIComponentTimer()
  self.infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if self.infoData == nil then
    return
  end
  if self.infoData:IsHasStarted() and self.entranceComp then
    local ret, time = self.entranceComp:PlayChangeBackAnim()
    if ret then
      self:CreateBattleContent({isFromStart = true, isFromOpen = false}, true)
      self.changeUIComponentTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DestroyEntranceContent()
        self:DestroyBossContent()
      end, time)
    end
    self:PlayChangeNextEffect()
  end
end

function UILWT11IdleGameBattleMainView:StopChangeUIComponentTimer()
  if self.changeUIComponentTimer then
    self.changeUIComponentTimer:Stop()
    self.changeUIComponentTimer = nil
  end
end

function UILWT11IdleGameBattleMainView:OnShowEndGameReward(evtData)
  self:StopChangeUIComponentTimer()
  if self.battleComp then
    local ret, time = self.battleComp:PlayChangeBackAnim()
    if ret then
      self:CreateEntranceContent(nil, true)
      self.changeUIComponentTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DestroyBattleContent()
        self:DestroyBossContent()
      end, time)
      self:PlayChangePreviousEffect()
    end
  end
  
  local function ShowSurpriseBox()
    local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
    if not mainData or not mainData:HasSurpriseBox() then
    else
      local param = {}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameSurpriseBox, {anim = true}, param)
    end
  end
  
  if self.delayShowEndGameRewardTimer then
    self.delayShowEndGameRewardTimer:Stop()
    self.delayShowEndGameRewardTimer = nil
  end
  self.delayShowEndGameRewardTimer = TimerManager:GetInstance():DelayInvoke(function()
    if evtData and evtData.reward then
      DataCenter.RewardManager:ShowCommonReward(evtData, nil, nil, nil, nil, nil, function()
        ShowSurpriseBox()
      end)
    else
      ShowSurpriseBox()
    end
  end, 1.2)
end

function UILWT11IdleGameBattleMainView:OnClickEnterBoss()
  if self.bossCompReq ~= nil or self.bossComp ~= nil then
    return
  end
  self:StopChangeUIComponentTimer()
  if self.battleComp then
    local ret, time = self.battleComp:PlayChangeBackAnim()
    if ret then
      self:CreateBossContent(nil, true)
      self.changeUIComponentTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DestroyEntranceContent()
        self:DestroyBattleContent()
      end, time)
      self:PlayChangeNextEffect()
    end
  end
end

function UILWT11IdleGameBattleMainView:OnClickExitBoss()
  if self.battleCompReq ~= nil or self.battleComp ~= nil then
    return
  end
  if self.entranceCompReq ~= nil or self.entranceComp ~= nil then
    return
  end
  self:StopChangeUIComponentTimer()
  if self.bossComp then
    local ret, time = self.bossComp:PlayChangeBackAnim()
    if ret then
      if self.infoData and self.infoData:IsHasStarted() then
        self:CreateBattleContent({isFromOpen = false}, true)
      else
        self:CreateEntranceContent(nil, true)
      end
      self.changeUIComponentTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DestroyBossContent()
      end, time)
      self:PlayChangePreviousEffect()
    end
  end
  DataCenter.LWSoundManager:PlaySound(90119, false)
end

function UILWT11IdleGameBattleMainView:OnLevelChanged(evtData)
  self:StopChangeUIComponentTimer()
  if self.bossComp then
    local ret, time = self.bossComp:PlayChangeBackAnim()
    if ret then
      local newLevelId
      if evtData and evtData.idleGameMain and evtData.idleGameMain.currentLevel then
        newLevelId = evtData.idleGameMain.currentLevel
      end
      self:CreateEntranceContent({newLevelId = newLevelId}, true)
      self.changeUIComponentTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DestroyBossContent()
      end, time)
      self:PlayChangePreviousEffect()
    end
  end
  
  local function ShowSurpriseBox()
    local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
    if not mainData or not mainData:HasSurpriseBox() then
    else
      local param = {}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameSurpriseBox, {anim = true}, param)
    end
  end
  
  if self.delayShowLevelChangeRewardTimer then
    self.delayShowLevelChangeRewardTimer:Stop()
    self.delayShowLevelChangeRewardTimer = nil
  end
  self.delayShowLevelChangeRewardTimer = TimerManager:GetInstance():DelayInvoke(function()
    if evtData and evtData.reward then
      DataCenter.RewardManager:ShowCommonReward(evtData, nil, nil, nil, nil, nil, function()
        ShowSurpriseBox()
      end)
    else
      ShowSurpriseBox()
    end
  end, 2)
end

function UILWT11IdleGameBattleMainView:OnBtnLWInfoClick()
  DataCenter.T11IdleGameManager:OpenRule()
end

function UILWT11IdleGameBattleMainView:OnBtnLWCommonNewClick()
  DataCenter.T11IdleGameDataManager:SendStartIdleGameMessage()
end

function UILWT11IdleGameBattleMainView:GetBattleComponent()
  return self.battleComp
end

function UILWT11IdleGameBattleMainView:GetBossComponent()
  return self.bossComp
end

function UILWT11IdleGameBattleMainView:OnBtnLWBackClick()
  if self.contentType == Const.MainViewContentType.None then
    self.ctrl:CloseSelf()
  elseif self.contentType == Const.MainViewContentType.Entrance then
    self.ctrl:CloseSelf()
  elseif self.contentType == Const.MainViewContentType.Battle then
    self.ctrl:CloseSelf()
  elseif self.contentType == Const.MainViewContentType.Boss then
    self:OnClickExitBoss()
  end
end

function UILWT11IdleGameBattleMainView:OnInitMessage()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameBattleMainView:OnPassDay()
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  mainData:TryAddStartGameLeftTime()
end

function UILWT11IdleGameBattleMainView:PlayChangeNextEffect()
  self.compEffUiT11IdleChange:SetActive(false)
  self.compEffUiT11IdleChange:SetActive(true)
end

function UILWT11IdleGameBattleMainView:PlayChangePreviousEffect()
  self.compEffUiT11IdleChangeBack:SetActive(false)
  self.compEffUiT11IdleChangeBack:SetActive(true)
end

return UILWT11IdleGameBattleMainView
