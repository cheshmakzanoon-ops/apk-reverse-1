local UIBattleResultParkourDefeatView = BaseClass("UIBattleResultParkourDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultParkourDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultParkourDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultParkourDefeatView:ComponentDefine()
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
  self.animatorUIBattleResultParkourDefeat = self.viewSkin:AddComponent(self, UIAnimator, 8)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultParkourDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnReturn = nil
  self.animatorUIBattleResultParkourDefeat = nil
end

function UIBattleResultParkourDefeatView:DataDefine()
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
  local hasAni, animTime = self.animatorUIBattleResultParkourDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultParkourDefeatView:DataDestroy()
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self.loopListView2Scroll:ClearAllItems()
  self.items = {}
  self.prefabIndex = nil
  self.itemConfigs = nil
  self.firstShowDelayAnim = false
end

function UIBattleResultParkourDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultParkourDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultParkourDefeatView:RefreshView()
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
  if param.hideTryAgainBtn then
    self.btnTryAgain:SetActive(false)
  else
    self.btnTryAgain:SetActive(true)
  end
end

function UIBattleResultParkourDefeatView:TryGetScrollItem(listview, index)
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

function UIBattleResultParkourDefeatView:OnKeyCodeEscape()
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

function UIBattleResultParkourDefeatView:OnBtnTryAgainClick()
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

function UIBattleResultParkourDefeatView:OnBtnReturnClick()
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
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

return UIBattleResultParkourDefeatView
