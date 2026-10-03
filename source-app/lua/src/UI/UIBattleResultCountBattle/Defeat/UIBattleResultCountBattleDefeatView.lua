local UIBattleResultCountBattleDefeatView = BaseClass("UIBattleResultCountBattleDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultCountBattleDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultCountBattleDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultCountBattleDefeatView:ComponentDefine()
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
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.animatorUIBattleResultCountBattleDefeat = self.viewSkin:AddComponent(self, UIAnimator, 8)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textTxtJump = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultCountBattleDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnReturn = nil
  self.animatorUIBattleResultCountBattleDefeat = nil
  self.btnJump = nil
  self.textTxtJump = nil
end

function UIBattleResultCountBattleDefeatView:DataDefine()
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
  self.items = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultCountBattleDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
  self.waitingForMsg = false
end

function UIBattleResultCountBattleDefeatView:DataDestroy()
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
  self.loopListView2Scroll:ClearAllItems()
  self.items = {}
  self.prefabIndex = nil
  self.itemConfigs = nil
  self.firstShowDelayAnim = false
end

function UIBattleResultCountBattleDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
end

function UIBattleResultCountBattleDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
  base.OnRemoveListener(self)
end

function UIBattleResultCountBattleDefeatView:RefreshView()
  local param = self:GetUserData()
  local canSkip = param.canSkip
  local stageId = param.stageId
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "order")
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
  if DataCenter.LWBattleManager:GetPVEEnterType() == PVEEnterType.Radar or not canSkip then
    self.btnReturn:SetActive(true)
    self.btnJump:SetActive(false)
  else
    self.btnReturn:SetActive(false)
    self.btnJump:SetActive(true)
  end
end

function UIBattleResultCountBattleDefeatView:TryGetScrollItem(listview, index)
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

function UIBattleResultCountBattleDefeatView:OnBtnTryAgainClick()
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
  local myStageId = self:GetUserData().stageId
  PostEventLog.Track(PostEventLog.Defines.BattleCountSkip, {stageId = myStageId, isSkip = 1})
end

function UIBattleResultCountBattleDefeatView:OnBtnReturnClick()
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
  if battleLogic.param and battleLogic.param.enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  battleLogic:NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
  local myStageId = self:GetUserData().stageId
  PostEventLog.Track(PostEventLog.Defines.BattleCountSkip, {stageId = myStageId, isSkip = 2})
end

function UIBattleResultCountBattleDefeatView:OnBtnJumpClick()
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
  PostEventLog.Track(PostEventLog.Defines.BattleCountSkip, {stageId = myStageId, isSkip = 0})
end

function UIBattleResultCountBattleDefeatView:OnJumpConfirmed(pveType)
  if pveType == PVEType.Count then
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit(nil, "win")
  end
end

function UIBattleResultCountBattleDefeatView:OnKeyCodeEscape()
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

return UIBattleResultCountBattleDefeatView
