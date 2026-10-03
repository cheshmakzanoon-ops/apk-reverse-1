local UIChampionBattleMainView = BaseClass("UIChampionBattleMainView", UIBaseView)
local ChampionBattleItem_strongest = require("UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_strongest")
local ChampionBattleItem_signUp = require("UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_signUp")
local ChampionBattleItem_auditions = require("UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_auditions")
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local Group_signUp_path = "Group_signUp"
local Group_auditions_path = "Group_auditions"
local Group_strongest_path = "Group_strongest"
local faqBtn_path = "Group_common/faqBtn"
local closeBtn_path = "Group_common/closeBtn"
local stageToggle1_path = "Group_common/ProcessList/stage1Btn"
local stageToggle1_text_path = "Group_common/ProcessList/stage1Btn/toggleLabel1"
local stageToggle1_state_text_path = "Group_common/ProcessList/stage1Btn/stateText1"
local stageToggle2_path = "Group_common/ProcessList/stage2Btn"
local stageToggle2_text_path = "Group_common/ProcessList/stage2Btn/toggleLabel2"
local stageToggle2_state_text_path = "Group_common/ProcessList/stage2Btn/stateText2"
local stageToggle3_path = "Group_common/ProcessList/stage3Btn"
local stageToggle3_text_path = "Group_common/ProcessList/stage3Btn/toggleLabel3"
local stageToggle3_state_text_path = "Group_common/ProcessList/stage3Btn/stateText3"
local debugCdTxt_path = "Group_common/Image/debugCdTxt"
local betRecordBtn_path = "Group_common/Group_Button/betRecordBtn"
local betRecordBtn_text_path = "Group_common/Group_Button/betRecordBtn/betRecordBtn_text"
local recordBtn_path = "Group_common/Group_Button/recordBtn"
local recordBtnRedPoint_path = "Group_common/Group_Button/recordBtn/recordBtn_redPoint"
local recordBtn_text_path = "Group_common/Group_Button/recordBtn/recordBtn_text"
local rankBtn_path = "Group_common/Group_Button/rankBtn"
local rankBtn_text_path = "Group_common/Group_Button/rankBtn/rankBtn_text"
local rewardBtn_path = "Group_common/Group_Button/rewardBtn"
local rewardBtn_text_path = "Group_common/Group_Button/rewardBtn/rewardBtn_text"
local ruleBtn_path = "Group_common/Group_Button/ruleBtn"
local ruleBtn_text_path = "Group_common/Group_Button/ruleBtn/ruleBtn_text"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local SelectedColor = Color.New(0.7529411764705882, 0.984313725490196, 0.30196078431372547, 1.0)
local UnSelectedColor = Color.New(0.5647058823529412, 0.8627450980392157, 0.9686274509803922, 1.0)

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.Group_signUp = self:AddComponent(UIBaseContainer, Group_signUp_path)
  self.Group_auditions = self:AddComponent(UIBaseContainer, Group_auditions_path)
  self.Group_strongest = self:AddComponent(UIBaseContainer, Group_strongest_path)
  self.faqBtn = self:AddComponent(UIButton, faqBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.stageToggle1 = self:AddComponent(UIToggle, stageToggle1_path)
  self.stageToggle1_text = self:AddComponent(UIText, stageToggle1_text_path)
  self.stageToggle1_text:SetLocalText(302029)
  self.stageToggle1_state_text = self:AddComponent(UIText, stageToggle1_state_text_path)
  self.stageToggle1_state_text_shadow = self:AddComponent(UIShadow, stageToggle1_state_text_path)
  self.stageToggle1_text_shadow = self:AddComponent(UIShadow, stageToggle1_text_path)
  self.stageToggle2 = self:AddComponent(UIToggle, stageToggle2_path)
  self.stageToggle2_text = self:AddComponent(UIText, stageToggle2_text_path)
  self.stageToggle2_text:SetLocalText(302030)
  self.stageToggle2_state_text_shadow = self:AddComponent(UIShadow, stageToggle2_state_text_path)
  self.stageToggle2_state_text = self:AddComponent(UIText, stageToggle2_state_text_path)
  self.stageToggle2_text_shadow = self:AddComponent(UIShadow, stageToggle2_text_path)
  self.stageToggle3 = self:AddComponent(UIToggle, stageToggle3_path)
  self.stageToggle3_text = self:AddComponent(UIText, stageToggle3_text_path)
  self.stageToggle3_text:SetLocalText(302031)
  self.stageToggle3_state_text = self:AddComponent(UIText, stageToggle3_state_text_path)
  self.stageToggle3_state_text_shadow = self:AddComponent(UIShadow, stageToggle3_state_text_path)
  self.stageToggle3_text_shadow = self:AddComponent(UIShadow, stageToggle3_text_path)
  self.debugCdTxt = self:AddComponent(UIText, debugCdTxt_path)
  self.betRecordBtn = self:AddComponent(UIButton, betRecordBtn_path)
  self.betRecordBtn_text = self:AddComponent(UIText, betRecordBtn_text_path)
  self.recordBtn = self:AddComponent(UIButton, recordBtn_path)
  self.recordBtn_text = self:AddComponent(UIText, recordBtn_text_path)
  self.recordBtnRedPoint = self:AddComponent(UIBaseContainer, recordBtnRedPoint_path)
  self.recordBtnRedPoint:SetActive(false)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rankBtn_text = self:AddComponent(UIText, rankBtn_text_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtn_text = self:AddComponent(UIText, rewardBtn_text_path)
  self.ruleBtn = self:AddComponent(UIButton, ruleBtn_path)
  self.ruleBtn_text = self:AddComponent(UIText, ruleBtn_text_path)
  self.betRecordBtn_text:SetText("--bet--")
  self.recordBtn_text:SetLocalText(302028)
  self.rankBtn_text:SetLocalText(390040)
  self.rewardBtn_text:SetLocalText(302026)
  self.ruleBtn_text:SetLocalText(302027)
  self.betRecordBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_betRecordBtn()
  end)
  self.recordBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_recordBtn()
  end)
  self.rankBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_rankBtn()
  end)
  self.rewardBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_rewardBtn()
  end)
  self.ruleBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_ruleBtn()
  end)
  self.stageToggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.stageToggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.stageToggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.closeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.faqBtn:SetActive(false)
  self.faqBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:onClick_faqBtn()
  end)
end

local function ToggleControlBorS(self)
  if self.stageToggle1:GetIsOn() then
    self:onClickSwitchActState(Activity_ChampionBattle_Stage_State.SingUp)
    self.stageToggle1_state_text:SetColor(SelectedColor)
    self.stageToggle2_state_text:SetColor(UnSelectedColor)
    self.stageToggle3_state_text:SetColor(UnSelectedColor)
    self.stageToggle1_text:SetColor(SelectedColor)
    self.stageToggle2_text:SetColor(UnSelectedColor)
    self.stageToggle3_text:SetColor(UnSelectedColor)
    self.stageToggle1_state_text_shadow:AllEnable(false)
    self.stageToggle2_state_text_shadow:AllEnable(true)
    self.stageToggle3_state_text_shadow:AllEnable(true)
    self.stageToggle1_text_shadow:AllEnable(false)
    self.stageToggle2_text_shadow:AllEnable(true)
    self.stageToggle3_text_shadow:AllEnable(true)
  elseif self.stageToggle2:GetIsOn() then
    self:onClickSwitchActState(Activity_ChampionBattle_Stage_State.Auditions)
    self.stageToggle2_state_text:SetColor(SelectedColor)
    self.stageToggle1_state_text:SetColor(UnSelectedColor)
    self.stageToggle3_state_text:SetColor(UnSelectedColor)
    self.stageToggle2_text:SetColor(SelectedColor)
    self.stageToggle1_text:SetColor(UnSelectedColor)
    self.stageToggle3_text:SetColor(UnSelectedColor)
    self.stageToggle2_state_text_shadow:AllEnable(false)
    self.stageToggle3_state_text_shadow:AllEnable(true)
    self.stageToggle1_state_text_shadow:AllEnable(true)
    self.stageToggle2_text_shadow:AllEnable(false)
    self.stageToggle1_text_shadow:AllEnable(true)
    self.stageToggle3_text_shadow:AllEnable(true)
  elseif self.stageToggle3:GetIsOn() then
    self:onClickSwitchActState(Activity_ChampionBattle_Stage_State.Strongest)
    self.stageToggle3_text:SetColor(SelectedColor)
    self.stageToggle2_text:SetColor(UnSelectedColor)
    self.stageToggle1_text:SetColor(UnSelectedColor)
    self.stageToggle3_state_text:SetColor(SelectedColor)
    self.stageToggle1_state_text:SetColor(UnSelectedColor)
    self.stageToggle2_state_text:SetColor(UnSelectedColor)
    self.stageToggle3_state_text_shadow:AllEnable(false)
    self.stageToggle2_state_text_shadow:AllEnable(true)
    self.stageToggle1_state_text_shadow:AllEnable(true)
    self.stageToggle3_text_shadow:AllEnable(false)
    self.stageToggle2_text_shadow:AllEnable(true)
    self.stageToggle1_text_shadow:AllEnable(true)
  end
end

local function DataDefine(self)
  self.curStageTab = -1
  self.curChooseStage = 0
  
  function self.timer_action(temp)
    self:OnUpdate()
  end
  
  self.alreadyShow = false
  DataCenter.ActChampionBattleManager:SetEntranceRed()
  DataCenter.ActChampionBattleManager:SendActChampBattleDataRefreshCmd()
  self:AddTimer()
end

local function OnDestroy(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(4)
  self:ComponentDestroy()
  self:DataDestroy()
  DataCenter.ActChampionBattleManager:SaveLastRecordRound()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  if self.lua_group_singUp ~= nil then
    self.lua_group_singUp = nil
  end
  if self.lua_group_auditions ~= nil then
    self.lua_group_auditions = nil
  end
  if self.lua_group_strongest ~= nil then
    self.lua_group_strongest = nil
  end
  if self.delayPosterInvoke ~= nil then
    self.delayPosterInvoke:Stop()
    self.delayPosterInvoke = nil
  end
  if self.requestStrongest ~= nil then
    self.requestStrongest:Destroy()
    self.requestStrongest = nil
  end
  if self.requestAuditions ~= nil then
    self.requestAuditions:Destroy()
    self.requestAuditions = nil
  end
  if self.requestSingUp ~= nil then
    self.requestSingUp:Destroy()
    self.requestSingUp = nil
  end
  self.bg = nil
  self.Group_signUp = nil
  self.Group_auditions = nil
  self.Group_strongest = nil
  self.faqBtn = nil
  self.closeBtn = nil
  self.recordBtnRedPoint = nil
  self.stageToggle1 = nil
  self.stageToggle1_text = nil
  self.stageToggle1_state_text = nil
  self.stageToggle2 = nil
  self.stageToggle2_text = nil
  self.stageToggle2_state_text = nil
  self.stageToggle3 = nil
  self.stageToggle3_text = nil
  self.stageToggle3_state_text = nil
  self.debugCdTxt = nil
  self.betRecordBtn = nil
  self.betRecordBtn_text = nil
  self.recordBtn = nil
  self.recordBtn_text = nil
  self.rankBtn = nil
  self.rankBtn_text = nil
  self.rewardBtn = nil
  self.rewardBtn_text = nil
  self.ruleBtn = nil
  self.ruleBtn_text = nil
  self:RemoveTimer()
  self.timer_action = nil
end

local function DataDestroy(self)
  self.curStageTab = nil
  self.timer_action = nil
  self.championBattleInfo = nil
  self.alreadyShow = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionBattleDataRefresh, self.OnrefreshData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChampionBattleDataRefresh, self.OnrefreshData)
  base.OnRemoveListener(self)
end

local function OnrefreshData(self)
  self.championBattleInfo = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
  if self.championBattleInfo == nil then
    return
  end
  local curIndexState = self.championBattleInfo:GetCurState()
  if self.curChooseStage == Activity_ChampionBattle_Stage_State.None then
    self.curChooseStage = curIndexState
  end
  if self.curChooseStage == Activity_ChampionBattle_Stage_State.SingUp then
    if self.stageToggle1:GetIsOn() then
      self:onClickSwitchActState(self.curChooseStage)
    else
      self.stageToggle1:SetIsOn(true)
    end
  elseif self.curChooseStage == Activity_ChampionBattle_Stage_State.Auditions then
    if self.stageToggle2:GetIsOn() then
      self:onClickSwitchActState(self.curChooseStage)
    else
      self.stageToggle2:SetIsOn(true)
    end
  elseif self.curChooseStage == Activity_ChampionBattle_Stage_State.Strongest then
    if self.stageToggle3:GetIsOn() then
      self:onClickSwitchActState(self.curChooseStage)
    else
      self.stageToggle3:SetIsOn(true)
    end
  end
  self:DelayOpenPoster()
  self:ShowBattleResultHint()
end

local function InitGroup_SingUp(self)
  if self.lua_group_singUp == nil then
    if self.requestSingUp == nil then
      self.requestSingUp = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_signUp)
      self.requestSingUp:completed("+", function()
        if self.requestSingUp.isError or self.requestSingUp.gameObject == nil then
          return
        end
        self.requestSingUp.gameObject:SetActive(true)
        self.requestSingUp.gameObject.name = "ChampionBattleItem_signUp"
        self.requestSingUp.gameObject.transform:SetParent(self.Group_signUp.transform)
        self.requestSingUp.gameObject.transform.localPosition = ResetPosition
        self.requestSingUp.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.lua_group_singUp = self.Group_signUp:AddComponent(ChampionBattleItem_signUp, "ChampionBattleItem_signUp")
        self.lua_group_singUp:SetData(self.championBattleInfo)
      end)
    end
  else
    self.lua_group_singUp:SetData(self.championBattleInfo)
  end
end

local function InitGroup_Auditions(self)
  if self.lua_group_auditions == nil then
    if self.requestAuditions == nil then
      self.requestAuditions = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_auditions)
      self.requestAuditions:completed("+", function()
        if self.requestAuditions.isError or self.requestAuditions.gameObject == nil then
          return
        end
        self.requestAuditions.gameObject:SetActive(true)
        self.requestAuditions.gameObject.name = "ChampionBattleItem_auditions"
        self.requestAuditions.gameObject.transform:SetParent(self.Group_auditions.transform)
        self.requestAuditions.gameObject.transform.localPosition = ResetPosition
        self.requestAuditions.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.lua_group_auditions = self.Group_auditions:AddComponent(ChampionBattleItem_auditions, "ChampionBattleItem_auditions")
        self.lua_group_auditions:SetData(self.championBattleInfo)
      end)
    end
  else
    self.lua_group_auditions:SetData(self.championBattleInfo)
  end
end

local function InitGroup_Strongest(self)
  if self.lua_group_strongest == nil then
    if self.requestStrongest == nil then
      self.requestStrongest = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_strongest)
      self.requestStrongest:completed("+", function()
        if self.requestStrongest.isError and self.requestStrongest.gameObject ~= nil then
          return
        end
        self.requestStrongest.gameObject:SetActive(true)
        self.requestStrongest.gameObject.name = "ChampionBattleItem_strongest"
        self.requestStrongest.gameObject.transform:SetParent(self.Group_strongest.transform)
        self.requestStrongest.gameObject.transform.localPosition = ResetPosition
        self.requestStrongest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.lua_group_strongest = self.Group_strongest:AddComponent(ChampionBattleItem_strongest, "ChampionBattleItem_strongest")
        self.lua_group_strongest:SetData(self.championBattleInfo)
      end)
    end
  else
    self.lua_group_strongest:SetData(self.championBattleInfo)
  end
end

local function SetBgByChild(self, bgUrl)
  self.bg:LoadSprite(bgUrl)
end

local function RefreshCurStage(self, stage)
  local curIndexState = self.championBattleInfo:GetCurState()
  if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
    self.stageToggle1_state_text:SetLocalText(302049)
    self.stageToggle2_state_text:SetLocalText(302064)
    self.stageToggle3_state_text:SetLocalText(302065)
  elseif curIndexState == Activity_ChampionBattle_Stage_State.Auditions then
    self.stageToggle1_state_text:SetLocalText(302048)
    self.stageToggle2_state_text:SetLocalText(302049)
    self.stageToggle3_state_text:SetLocalText(302065)
  elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
    self.stageToggle2_state_text:SetLocalText(302048)
    self.stageToggle2_state_text:SetLocalText(302048)
    self.stageToggle3_state_text:SetLocalText(302049)
  end
  local bgUrl
  if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
    if stage == Activity_ChampionBattle_Stage_State.Auditions then
      bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k4")
    elseif stage == Activity_ChampionBattle_Stage_State.Strongest then
      bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k5")
    else
      bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k" .. stage)
    end
  elseif curIndexState == Activity_ChampionBattle_Stage_State.Auditions then
    if stage == Activity_ChampionBattle_Stage_State.Strongest then
      bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k5")
    else
      bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k" .. stage)
    end
  else
    bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k" .. stage)
  end
  bgUrl = "Assets/Main/TextureEx/UIActivity/" .. bgUrl
  self:SetBgByChild(bgUrl)
  if stage == Activity_ChampionBattle_Stage_State.SingUp then
    self.Group_signUp:SetActive(true)
    self.Group_auditions:SetActive(false)
    self.Group_strongest:SetActive(false)
    self:InitGroup_SingUp()
  elseif stage == Activity_ChampionBattle_Stage_State.Auditions then
    self.Group_signUp:SetActive(false)
    self.Group_auditions:SetActive(true)
    self.Group_strongest:SetActive(false)
    self:InitGroup_Auditions()
  elseif stage == Activity_ChampionBattle_Stage_State.Strongest then
    self.Group_signUp:SetActive(false)
    self.Group_auditions:SetActive(false)
    self.Group_strongest:SetActive(true)
    self:InitGroup_Strongest()
  end
  self:ShowButtonGroup()
end

local function onClickSwitchActState(self, stage)
  if self.championBattleInfo == nil then
    return
  end
  self.curChooseStage = stage
  self:RefreshCurStage(stage)
end

local function ShowButtonGroup(self)
  local curIndexState = self.championBattleInfo:GetCurState()
  if curIndexState == Activity_ChampionBattle_Stage_State.Auditions or curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
    self.recordBtn:SetActive(true)
  else
    self.recordBtn:SetActive(false)
  end
  if curIndexState == Activity_ChampionBattle_Stage_State.Auditions or curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
    self.rankBtn:SetActive(true)
  else
    self.rankBtn:SetActive(false)
  end
  self:RefreshRecordRedPoint()
end

local function onClick_closeBtn(self)
  self.ctrl:CloseSelf()
end

local function DelayOpenPoster(self)
  local localSaveKey = self.championBattleInfo.startTime
  local count = ChampionBattlePosterType.Strongest_King
  for i = count, 1, -1 do
    local isOpened = DataCenter.ActChampionBattleManager:GetChampionStrongestPoster(i, localSaveKey)
    if isOpened then
      local listData = self.championBattleInfo:GetStrongestPosterDataByType(i)
      if listData ~= nil then
        DataCenter.ActChampionBattleManager:SetChampionStrongestPoster(i, localSaveKey, false)
        self.delayPosterInvoke = TimerManager:GetInstance():DelayInvoke(function()
          if i == ChampionBattlePosterType.Strongest_King then
          else
          end
        end, 0.4)
        return
      end
    end
  end
end

local function onClick_rewardBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleReward)
end

local function onClick_ruleBtn(self)
  local strTitle = Localization:GetString("302022")
  local subTitle = Localization:GetString("100239")
  local strContent = Localization:GetString("302062")
  UIUtil.ShowIntro(strTitle, subTitle, strContent)
end

local function onClick_rankBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleRankView)
end

local function onClick_recordBtn(self)
  DataCenter.ActChampionBattleManager:SendActChampionBattleReportListCmd()
  DataCenter.ActChampionBattleManager:ResetNeedShowRecord()
  self:RefreshRecordRedPoint()
end

local function onClick_betRecordBtn(self)
end

local function onClick_faqBtn(self)
end

local function SendCmdForClock(self)
  local oneHour = 3600
  local leftTime = UITimeManager:GetInstance():GetResSecondsTo24()
  local fmodValue = math.fmod(leftTime, oneHour)
  if fmodValue == 0 then
    DataCenter.ActChampionBattleManager:SendActChampBattleDataRefreshCmd()
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
  self:OnUpdate()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnUpdate(self)
  if self.championBattleInfo == nil or self.debugCdTxt == nil then
    return
  end
  self:SendCmdForClock()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.championBattleInfo.endTime
  local startTime = self.championBattleInfo.startTime
  local leftTime = endTime - curTime
  if curTime > startTime and 0 < leftTime then
    self.debugCdTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

local function ShowBattleResultHint(self)
  if self.alreadyShow ~= true and DataCenter.ActChampionBattleManager:NeedShowRecord() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleResultHintView)
  end
  self.alreadyShow = true
end

local function RefreshRecordRedPoint(self)
  self.recordBtnRedPoint:SetActive(DataCenter.ActChampionBattleManager:GetNeedShowRecord())
end

UIChampionBattleMainView.AddTimer = AddTimer
UIChampionBattleMainView.RemoveTimer = RemoveTimer
UIChampionBattleMainView.OnUpdate = OnUpdate
UIChampionBattleMainView.OnCreate = OnCreate
UIChampionBattleMainView.ComponentDefine = ComponentDefine
UIChampionBattleMainView.DataDefine = DataDefine
UIChampionBattleMainView.OnDestroy = OnDestroy
UIChampionBattleMainView.ComponentDestroy = ComponentDestroy
UIChampionBattleMainView.DataDestroy = DataDestroy
UIChampionBattleMainView.OnAddListener = OnAddListener
UIChampionBattleMainView.OnRemoveListener = OnRemoveListener
UIChampionBattleMainView.SendCmdForClock = SendCmdForClock
UIChampionBattleMainView.onClick_faqBtn = onClick_faqBtn
UIChampionBattleMainView.onClick_betRecordBtn = onClick_betRecordBtn
UIChampionBattleMainView.onClick_recordBtn = onClick_recordBtn
UIChampionBattleMainView.onClick_rankBtn = onClick_rankBtn
UIChampionBattleMainView.onClick_ruleBtn = onClick_ruleBtn
UIChampionBattleMainView.onClick_rewardBtn = onClick_rewardBtn
UIChampionBattleMainView.DelayOpenPoster = DelayOpenPoster
UIChampionBattleMainView.onClick_closeBtn = onClick_closeBtn
UIChampionBattleMainView.ShowButtonGroup = ShowButtonGroup
UIChampionBattleMainView.onClickSwitchActState = onClickSwitchActState
UIChampionBattleMainView.RefreshCurStage = RefreshCurStage
UIChampionBattleMainView.SetBgByChild = SetBgByChild
UIChampionBattleMainView.ToggleControlBorS = ToggleControlBorS
UIChampionBattleMainView.OnrefreshData = OnrefreshData
UIChampionBattleMainView.InitGroup_SingUp = InitGroup_SingUp
UIChampionBattleMainView.InitGroup_Auditions = InitGroup_Auditions
UIChampionBattleMainView.InitGroup_Strongest = InitGroup_Strongest
UIChampionBattleMainView.ShowBattleResultHint = ShowBattleResultHint
UIChampionBattleMainView.RefreshRecordRedPoint = RefreshRecordRedPoint
return UIChampionBattleMainView
