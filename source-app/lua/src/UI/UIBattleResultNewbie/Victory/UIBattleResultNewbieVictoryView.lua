local UIBattleResultNewbieVictoryView = BaseClass("UIBattleResultNewbieVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultNewbieVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultNewbieVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultNewbieVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.animatorUIBattleResultNewbieVictory = self.viewSkin:AddComponent(self, UIAnimator, 7)
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.textTxtTitle:SetLocalText("311105")
  self.textTxtReturn:SetLocalText("800306")
end

function UIBattleResultNewbieVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.animatorUIBattleResultNewbieVictory = nil
end

function UIBattleResultNewbieVictoryView:DataDefine()
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
  local hasAni, animTime = self.animatorUIBattleResultNewbieVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultNewbieVictoryView:DataDestroy()
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

function UIBattleResultNewbieVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultNewbieVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultNewbieVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultNewbieVictoryView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature)
  local stageOrder = GetTableData(tableName, stageId, "order")
  self.textTxtStage:SetText(Localization:GetString(GetTableData(tableName, stageId, "name"), stageOrder))
  self.itemConfigs = {}
  table.insert(self.itemConfigs, self.timeItemCfg)
  table.insert(self.itemConfigs, self.killItemCfg)
  local time = param.time or 0
  self.timeItemCfg.valueStr = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time)
  local kill = param.kill or 0
  self.killItemCfg.valueStr = string.format("%d", kill)
  self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, false, false)
  self.firstShowDelayAnim = true
  DataCenter.LWSoundManager:PlaySound(10027)
end

function UIBattleResultNewbieVictoryView:TryGetScrollItem(listview, index)
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

function UIBattleResultNewbieVictoryView:OnKeyCodeEscape()
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

return UIBattleResultNewbieVictoryView
