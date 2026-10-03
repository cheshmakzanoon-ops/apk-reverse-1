local UIBattleResultNewbieDefeatView = BaseClass("UIBattleResultNewbieDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultNewbieDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultNewbieDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultNewbieDefeatView:ComponentDefine()
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
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textTxtJump = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.animatorUIBattleResultNewbieDefeat = self.viewSkin:AddComponent(self, UIAnimator, 10)
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.textTxtJump:SetLocalText("110171")
end

function UIBattleResultNewbieDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnJump = nil
  self.textTxtJump = nil
  self.btnReturn = nil
  self.animatorUIBattleResultNewbieDefeat = nil
end

function UIBattleResultNewbieDefeatView:DataDefine()
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
  self.waitingForMsg = false
  self.items = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultNewbieDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultNewbieDefeatView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.firstShowDelayAnim = false
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self.loopListView2Scroll:ClearAllItems()
  self.items = {}
  self.prefabIndex = nil
  self.itemConfigs = nil
  self.timeItemCfg = nil
  self.killItemCfg = nil
end

function UIBattleResultNewbieDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
end

function UIBattleResultNewbieDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
  base.OnRemoveListener(self)
end

function UIBattleResultNewbieDefeatView:OnKeyCodeEscape()
  if not self.interactableBtns then
    return
  end
  if self.EscTimer ~= nil then
    return
  end
  if DataCenter.LWGuideManager:GetCurGuideId() < GuideState.CityCopter then
    return
  end
  self.EscTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
    self.EscTimer = nil
  end, 1)
end

function UIBattleResultNewbieDefeatView:RefreshView()
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
  self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, false, false)
  self.firstShowDelayAnim = true
  self.btnReturn:SetActive(not (DataCenter.LWGuideManager:GetCurGuideId() < GuideState.CityCopter))
end

function UIBattleResultNewbieDefeatView:OnBtnTryAgainClick()
  if not self.interactableBtns then
    return
  end
  if self.waitingForMsg then
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

function UIBattleResultNewbieDefeatView:OnBtnJumpClick()
  if not self.interactableBtns then
    return
  end
  if self.waitingForMsg then
    return
  end
  self.waitingForMsg = true
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 0})
end

function UIBattleResultNewbieDefeatView:OnJumpConfirmed()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultNewbieDefeatView:TryGetScrollItem(listview, index)
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
    item:ReInit(data)
    if not firstCreate then
      self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
    elseif not self.firstShowDelayAnim then
      self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
    end
  end
  return csItem
end

function UIBattleResultNewbieDefeatView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  if self.waitingForMsg then
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
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

return UIBattleResultNewbieDefeatView
