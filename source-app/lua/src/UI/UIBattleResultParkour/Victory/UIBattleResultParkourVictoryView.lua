local UIBattleResultParkourVictoryView = BaseClass("UIBattleResultParkourVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultParkourVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultParkourVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultParkourVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compNodeReward = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textTxtFirstRewardTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollViewRewardScrollView = self.viewSkin:AddComponent(self, UIScrollView, 7)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textTxtAllianceShare = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnAllianceShare = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnAllianceShare:SetOnClick(function()
    self:OnBtnAllianceShareClick()
  end)
  self.animatorUIBattleResultParkourVictory = self.viewSkin:AddComponent(self, UIAnimator, 11)
  self.textTxtTitle:SetLocalText("311105")
  self.textTxtReturn:SetLocalText("800306")
  self.textTxtFirstRewardTip:SetLocalText("800305")
  self.textTxtAllianceShare:SetLocalText("season_s3_coinlevel_share_text_2")
  self.compNodeReward:SetActive(false)
  self.scrollViewRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIBattleResultParkourVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.compNodeReward = nil
  self.textTxtFirstRewardTip = nil
  self.scrollViewRewardScrollView = nil
  self.compRewardContent = nil
  self.textTxtAllianceShare = nil
  self.btnAllianceShare = nil
  self.animatorUIBattleResultParkourVictory = nil
end

function UIBattleResultParkourVictoryView:DataDefine()
  self.rewardScrollCellPool = {}
  self.rewardItemIndex = 1
  self.rewardFlyReward = {}
  self.rewardDatalist = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  local hasAni, animTime = self.animatorUIBattleResultParkourVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultParkourVictoryView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(10027)
  local param = self:GetUserData()
  local stageId = param.stageId
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.textTxtStage:SetLocalText(levelTitlePrefixKey, order)
  if param.overrideStageText then
    self.textTxtStage:SetText(param.overrideStageText)
  end
  self.level_type = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.stageId, "level_type")
  self.isGoldLevel = self.level_type and tonumber(self.level_type) == 1
  self.btnAllianceShare:SetActive(self.isGoldLevel)
  if DataCenter.ParkourManager.reward and DataCenter.ParkourManager.rewardStageId == stageId then
    self:OnGetReward(DataCenter.ParkourManager.reward)
  end
end

function UIBattleResultParkourVictoryView:OnGetReward(param)
  local s = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self:GetUserData().stageId, "visitor_event")
  if tonumber(s) then
    table.insert(param, {
      rewardType = RewardType.WORKER
    })
  elseif type(s) == "string" then
    local spl = string.split(s, "|")
    for _, v in ipairs(spl) do
      if tonumber(v) then
        table.insert(param, {
          rewardType = RewardType.WORKER
        })
      end
    end
  end
  self.rewardDatalist = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  self.compNodeReward:SetActive(#self.rewardDatalist > 0)
  DataCenter.ParkourManager.reward = nil
  DataCenter.ParkourManager.rewardStageId = nil
  self:RefreshReward()
  for i, v in ipairs(self.rewardDatalist) do
    if v.rewardType == RewardType.HERO then
      self.heroId = v.heroUuid
      break
    end
  end
  if self.heroId and DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroId, {
      self.heroId
    }, nil, true)
  end
end

function UIBattleResultParkourVictoryView:RefreshReward()
  self.scrollViewRewardScrollView:SetTotalCount(#self.rewardDatalist)
  if #self.rewardDatalist > 0 then
    self.scrollViewRewardScrollView:RefillCells()
  end
end

function UIBattleResultParkourVictoryView:ClearRewardScroll()
  self.scrollViewRewardScrollView:ClearCells()
  self.compRewardContent:RemoveComponents(UICommonResItem)
  self.rewardScrollCellPool = nil
  self.rewardItemIndex = nil
  self.rewardFlyReward = nil
  self.rewardDatalist = nil
end

function UIBattleResultParkourVictoryView:OnRewardItemMoveIn(itemObj, index)
  local itemName = itemObj.name
  local item = self.rewardScrollCellPool[itemName]
  local firstCreate = false
  if not item then
    firstCreate = true
    itemName = tostring(self.rewardItemIndex)
    itemObj.name = itemName
    item = self.compRewardContent:AddComponent(UICommonResItem, itemObj)
    self.rewardScrollCellPool[itemName] = item
    self.rewardItemIndex = self.rewardItemIndex + 1
  end
  local data = self.rewardDatalist[index]
  item:ReInit(data)
  if not firstCreate then
    self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
  else
    self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
  end
  if data.rewardType == RewardType.RESOURCE then
    local name = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(name)
  end
  self.rewardFlyReward[itemObj.transform] = data
end

function UIBattleResultParkourVictoryView:OnRewardItemMoveOut(itemObj, index)
  self.rewardFlyReward[itemObj.transform] = nil
end

function UIBattleResultParkourVictoryView:DataDestroy()
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
  self:ClearRewardScroll()
  self.heroId = nil
end

function UIBattleResultParkourVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultParkourVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultParkourVictoryView:OnKeyCodeEscape()
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

function UIBattleResultParkourVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  local cfg = {}
  for i, v in pairs(self.rewardFlyReward) do
    table.insert(cfg, {
      i.position,
      v
    })
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultParkourVictoryView:OnBtnAllianceShareClick()
  if not self.interactableBtns then
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("456550")
    return
  end
  local goldCount = self:GetGoldCount()
  if not goldCount then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.GoldRelic
  shareParam.param = {goldCount = goldCount}
  local chatData = {}
  local allianceChannelRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  if string.IsNullOrEmpty(allianceChannelRoomId) then
    return
  end
  chatData.roomId = allianceChannelRoomId
  chatData.post = shareParam.post
  chatData.param = shareParam.param
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
  local cfg = {}
  for i, v in pairs(self.rewardFlyReward) do
    table.insert(cfg, {
      i.position,
      v
    })
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultParkourVictoryView:GetGoldCount()
  local logic = DataCenter.LWBattleManager.logic
  if logic and logic.GetGoods then
    local goods = logic:GetGoods()
    if goods and goods[2] then
      return goods[2]
    end
  end
end

return UIBattleResultParkourVictoryView
