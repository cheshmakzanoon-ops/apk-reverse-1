local UIBattleResultFrontBreakDefeatView = BaseClass("UIBattleResultFrontBreakDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local CommonResultGoToList = require("UI.UIBattleResultComponents.CommonResultGoToListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")
local UIGray = CS.UIGray

function UIBattleResultFrontBreakDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultFrontBreakDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultFrontBreakDefeatView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnTryAgain = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTryAgain:SetOnClick(function()
    self:OnBtnTryAgainClick()
  end)
  self.textTxtTryAgain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnHelp = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnHelp:SetOnClick(function()
    self:OnBtnHelpClick()
  end)
  self.textTxtHelp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtCountdown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.animatorUIBattleResultFrontBreakDefeat = self.viewSkin:AddComponent(self, UIAnimator, 11)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.textTxtHelp:SetLocalText("frontline_help_fail_01")
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultFrontBreakDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnHelp = nil
  self.textTxtHelp = nil
  self.btnReturn = nil
  self.textTxtCountdown = nil
  self.animatorUIBattleResultFrontBreakDefeat = nil
end

function UIBattleResultFrontBreakDefeatView:DataDefine()
  self.timeItemCfg = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_shijian_icon.png",
    name = Localization:GetString("800304"),
    valueStr = ""
  }
  self.killItemCfg = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_guai_icon.png",
    name = Localization:GetString("800303"),
    valueStr = ""
  }
  self.watchVideoItemCfg = {
    cmp = CommonResultGoToList,
    prefabName = "CommonResultGoToList",
    icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_ytb_icon.png",
    name = Localization:GetString("settlement_video_desc"),
    funcTxt = Localization:GetString("settlement_video_button")
  }
  self.skipItemCfg = {
    cmp = CommonResultGoToList,
    prefabName = "CommonResultGoToList",
    icon = "Assets/Main/Sprites/UI/CommonCombatResultNew/zyf_jiesuan_dingwei_icon.png",
    name = Localization:GetString("settlement_skip_desc"),
    funcTxt = Localization:GetString("110171")
  }
  self.isHideHelpBtn = true
  self.items = {}
  
  function self.watchVideoItemCfg.funcGO()
    self:OnBtnVideoClick()
  end
  
  function self.skipItemCfg.funcGO()
    self:OnBtnSkipClick()
  end
  
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultFrontBreakDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultFrontBreakDefeatView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self.firstShowDelayAnim = false
  self.loopListView2Scroll:ClearAllItems()
  self.itemConfigs = nil
  self.items = {}
  self.prefabIndex = nil
  self.watchVideoItemCfg.funcGO = nil
  self.skipItemCfg.funcGO = nil
  self.killItemCfg = nil
  self.timeItemCfg = nil
  self.watchVideoItemCfg = nil
  self.skipItemCfg = nil
end

function UIBattleResultFrontBreakDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.StageFeatureChapterSkip, self.OnStageFeatureChapterSkip)
end

function UIBattleResultFrontBreakDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.StageFeatureChapterSkip, self.OnStageFeatureChapterSkip)
  base.OnRemoveListener(self)
end

function UIBattleResultFrontBreakDefeatView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.textTxtStage:SetLocalText(levelTitlePrefixKey, order)
  self.itemConfigs = {}
  table.insert(self.itemConfigs, self.timeItemCfg)
  table.insert(self.itemConfigs, self.killItemCfg)
  local time = param.time or 0
  self.timeItemCfg.valueStr = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time)
  local kill = param.kill or 0
  self.killItemCfg.valueStr = string.format("%d", kill)
  local isEasyStageFeatureSkippedStage = DataCenter.LWEasyStageFeatureChapterManager:IsSkipStage(param.stageId)
  local isStageFeatureSkippedStage = DataCenter.LWStageFeatureChapterManager:IsSkipStage(param.stageId)
  local isStageFeatureResetedStage = DataCenter.LWStageFeatureChapterManager:IsStageReseted(param.stageId)
  local isIntegratedStageFeatureSkippedStage = DataCenter.LWIntegratedStageFeatureChapterManager:IsSkipStage(param.integratedStageDifficulty, param.stageId)
  local isIntegratedStageFeatureResetedStage = DataCenter.LWIntegratedStageFeatureChapterManager:IsStageReseted(param.integratedStageDifficulty, param.stageId)
  local difficulty = param.integratedStageDifficulty or 0
  local currentIntegratedStageCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetStageBelongsChapterCfgData(param.stageId)
  local isHelpShareOn = DataCenter.LWStageFeatureChapterManager:IsHelpShareFunctionOn()
  local currentChapterCfg = DataCenter.LWStageFeatureChapterManager:GetStageBelongsChapterCfgData(stageId)
  if isHelpShareOn and LuaEntry.Player:IsInAlliance() and not param.isChapterHelp then
    local showHelp = false
    if param.isIntegratedStage then
      showHelp = currentIntegratedStageCfg and difficulty > StageFeatureIntegratedDifficulty.Normal and not isIntegratedStageFeatureResetedStage
    else
      showHelp = not isStageFeatureResetedStage and currentChapterCfg
    end
    self.btnHelp:SetActive(showHelp)
    self.isHideHelpBtn = not showHelp
  else
    self.btnHelp:SetActive(false)
    self.isHideHelpBtn = true
  end
  if param.loseToShowVideo and param.loseToShowVideoURL then
    table.insert(self.itemConfigs, self.watchVideoItemCfg)
  end
  if not param.isChapterHelp then
    local showSkip = false
    if param.isIntegratedStage then
      if not isIntegratedStageFeatureSkippedStage and not isIntegratedStageFeatureResetedStage then
        local failSkipNum = param.chapterFailSkipNum or 0
        if 0 < failSkipNum then
          local isNotNormal = difficulty ~= StageFeatureIntegratedDifficulty.Normal
          local failCount = DataCenter.LWIntegratedStageFeatureChapterManager:GetFailCount(difficulty, param.stageId)
          if isNotNormal and failSkipNum <= failCount then
            showSkip = true
          end
        end
      end
    elseif not isEasyStageFeatureSkippedStage and not isStageFeatureSkippedStage and not isStageFeatureResetedStage then
      local failSkipNum = param.chapterFailSkipNum or 0
      if 0 < failSkipNum then
        local normalFail = DataCenter.LWStageFeatureChapterManager:GetFailCount(param.stageId)
        local easyFail = DataCenter.LWEasyStageFeatureChapterManager:GetFailCount(param.stageId)
        if failSkipNum <= normalFail or failSkipNum <= easyFail then
          showSkip = true
        end
      end
    end
    if showSkip then
      table.insert(self.itemConfigs, self.skipItemCfg)
    end
  end
  self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, false, false)
  self.firstShowDelayAnim = true
end

function UIBattleResultFrontBreakDefeatView:OnBtnTryAgainClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Restart()
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 1})
end

function UIBattleResultFrontBreakDefeatView:OnBtnSkipClick()
  if not self.interactableBtns then
    return
  end
  local param = self:GetUserData()
  if param and param.stageId then
    if param.isIntegratedStage then
      DataCenter.LWIntegratedStageFeatureChapterManager:SendSkipMessage(param.integratedStageDifficulty, param.stageId)
    else
      DataCenter.LWStageFeatureChapterManager:SendSkipMessage(param.stageId)
    end
    PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {
      stageId = param.stageId,
      isSkip = 0
    })
    return
  end
  self:OnBtnReturnClick()
end

function UIBattleResultFrontBreakDefeatView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 2})
  if battleLogic.param and battleLogic.param.enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  battleLogic:NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UIBattleResultFrontBreakDefeatView:OnBtnHelpClick()
  if not self.interactableBtns then
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.post = PostType.StageFeatureHelpInvite
  shareParam.param = {}
  local stageId = param.stageId or 0
  shareParam.param.stageId = stageId
  local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order") or 0
  shareParam.param.stageOrder = stageOrder
  shareParam.param.fromChapter = true
  shareParam.param.score = param.score or 0
  shareParam.param.rank = param.rank or 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
  PostEventLog.Track(PostEventLog.Defines.C_clickLoseShareBtn)
end

function UIBattleResultFrontBreakDefeatView:OnBtnVideoClick()
  if not self.interactableBtns then
    return
  end
  local param = self:GetUserData()
  if param and param.loseToShowVideoURL then
    CS.SDKManager.OpenURL(param.loseToShowVideoURL)
  end
end

function UIBattleResultFrontBreakDefeatView:Update1000MS()
  if self.isHideHelpBtn then
    return
  end
  local isMeetHelpShareCd, leftTime = DataCenter.LWStageFeatureChapterManager:IsMeetShareCd()
  if isMeetHelpShareCd then
    UIGray.SetGray(self.btnHelp.transform, false, true)
    self.textTxtCountdown:SetText("")
  else
    UIGray.SetGray(self.btnHelp.transform, true, false)
    local str = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(leftTime / 1000)
    self.textTxtCountdown:SetLocalText("frontline_help_fail_02", str)
  end
end

function UIBattleResultFrontBreakDefeatView:OnKeyCodeEscape()
  if not self.interactableBtns then
    return
  end
  if self.EscTimer ~= nil then
    return
  end
  self.EscTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
    self.EscTimer = nil
  end, 1)
end

function UIBattleResultFrontBreakDefeatView:OnStageFeatureChapterSkip()
  local param = self:GetUserData()
  if param and param.stageId then
    local isStageFeatureChapterSkippedStage = DataCenter.LWStageFeatureChapterManager:IsSkipStage(param.stageId)
    local isEasyStageFeatureChapterSkippedStage = DataCenter.LWEasyStageFeatureChapterManager:IsSkipStage(param.stageId)
    local isIntegratedStageFeatureSkippedStage = DataCenter.LWIntegratedStageFeatureChapterManager:IsSkipStage(param.integratedStageDifficulty, param.stageId)
    if isStageFeatureChapterSkippedStage or isEasyStageFeatureChapterSkippedStage or isIntegratedStageFeatureSkippedStage then
      if param.enterType == PVEEnterType.StageFeatureScene then
        DataCenter.LWBattleManager:SetBattleExitFlag(true)
      end
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Exit(nil, "quit")
      return
    end
  end
  self:OnBtnReturnClick()
end

function UIBattleResultFrontBreakDefeatView:TryGetScrollItem(listview, index)
  if #self.itemConfigs <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #self.itemConfigs then
    return nil
  end
  local data = self.itemConfigs[index]
  local csItem = listview:NewListViewItem(data.prefabName)
  local firstCreate = false
  local itemName = csItem.gameObject.name
  local item = self.items[csItem]
  if item == nil then
    firstCreate = true
    local prefabIndex = self.prefabIndex or 0
    itemName = "Item" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = itemName
    item = self.compContent:AddComponent(data.cmp, itemName)
    self.items[csItem] = item
  end
  if item ~= nil then
    self.items[csItem]:ReInit(data)
    if not firstCreate then
      self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
    elseif not self.firstShowDelayAnim then
      self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
    end
  end
  return csItem
end

return UIBattleResultFrontBreakDefeatView
