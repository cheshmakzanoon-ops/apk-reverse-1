local base = UIBaseContainer
local UIBFDsbDuelActRulesRewardDetailItem = BaseClass("UIBFDsbDuelActRulesRewardDetailItem", UIBaseContainer)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIBFDsbDuelActRulesRewardDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesRewardDetailItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesRewardDetailItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTitleText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnInfoBtn2 = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfoBtn2:SetOnClick(function()
    self:OnBtnInfoBtn2Click()
  end)
  self.btnReceiveBtn2 = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnReceiveBtn2:SetOnClick(function()
    self:OnBtnReceiveBtn2Click()
  end)
  self.compLayout2 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textReceiveBtnText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTitleText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnInfoBtn3 = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnInfoBtn3:SetOnClick(function()
    self:OnBtnInfoBtn3Click()
  end)
  self.compLayout3 = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.btnReceiveBtn3 = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnReceiveBtn3:SetOnClick(function()
    self:OnBtnReceiveBtn3Click()
  end)
  self.textReceiveBtnText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compBg3 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
end

function UIBFDsbDuelActRulesRewardDetailItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textTitleText2 = nil
  self.btnInfoBtn2 = nil
  self.btnReceiveBtn2 = nil
  self.compLayout2 = nil
  self.textReceiveBtnText2 = nil
  self.textTitleText3 = nil
  self.btnInfoBtn3 = nil
  self.compLayout3 = nil
  self.btnReceiveBtn3 = nil
  self.textReceiveBtnText3 = nil
  self.compBg3 = nil
end

function UIBFDsbDuelActRulesRewardDetailItem:DataDefine()
  self.rewardReqs2 = {}
  self.rewardReqs3 = {}
end

function UIBFDsbDuelActRulesRewardDetailItem:DataDestroy()
  self:ClearRewardItems()
end

function UIBFDsbDuelActRulesRewardDetailItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesRewardDetailItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesRewardDetailItem:OnBtnInfoBtn2Click()
end

function UIBFDsbDuelActRulesRewardDetailItem:OnBtnReceiveBtn2Click()
  local allianceRewardReceiveState = BattlefieldDsbDuelUtils.ActInfo:GetReceiveState(self.data.id, true)
  if allianceRewardReceiveState == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive then
    BattlefieldDsbDuelUtils.ActInfo:SendActGetRewardMsg(self.data.id, BattlefieldDsbConst.BF_DSB_REWARD_Type.AllianceReward)
  end
end

function UIBFDsbDuelActRulesRewardDetailItem:OnBtnInfoBtn3Click()
  local strTip = Localization:GetString("dsb_duel_interface_1047")
  UIUtil.ShowBubbleTips(strTip, self.btnInfoBtn3.transform.position, 0, -30, 0)
end

function UIBFDsbDuelActRulesRewardDetailItem:OnBtnReceiveBtn3Click()
  local zoneRewardReceiveState = BattlefieldDsbDuelUtils.ActInfo:GetReceiveState(self.data.id, false)
  if zoneRewardReceiveState == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive then
    BattlefieldDsbDuelUtils.ActInfo:SendActGetRewardMsg(self.data.id, BattlefieldDsbConst.BF_DSB_REWARD_Type.ZoneReward)
  end
end

function UIBFDsbDuelActRulesRewardDetailItem:ClearRewardItems()
  self:ClearRewardItemsInLayout(self.compLayout2, self.rewardReqs2)
  self:ClearRewardItemsInLayout(self.compLayout3, self.rewardReqs3)
end

function UIBFDsbDuelActRulesRewardDetailItem:ClearRewardItemsInLayout(layout, reqs)
  if not layout then
    return
  end
  layout:RemoveComponents(UICommonResItem)
  if reqs then
    for k, v in pairs(reqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  table.clear(reqs)
end

function UIBFDsbDuelActRulesRewardDetailItem:SetRankRewards(rewards, layoutType)
  local layout, reqs
  if layoutType == 1 then
    layout = self.compLayout2
    reqs = self.rewardReqs2
  else
    layout = self.compLayout3
    reqs = self.rewardReqs3
  end
  if not rewards or #rewards == 0 then
    return
  end
  for i = 1, #rewards do
    local idx = i
    reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go:SetActive(true)
      go.transform:SetParent(layout.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "item_reward_" .. idx
      local cell = layout:AddComponent(UICommonResItem, go.name)
      cell:ReInit(rewards[idx])
      cell:SetSizeDelta(Vector2.New(150, 150))
    end)
  end
end

function UIBFDsbDuelActRulesRewardDetailItem:SetData(data)
  if not data then
    return
  end
  self.data = data
  local rank1, rank2 = data:GetRankRange()
  local rankStr = rank1 == rank2 and rank1 or rank1 .. "-" .. rank2
  self.textTitle:SetLocalText("dsb_duel_guide_tips_1025", rankStr)
  self.textTitleText2:SetLocalText("2010310")
  self.textTitleText3:SetLocalText("801424")
  self:ClearRewardItems()
  self:SetRankRewards(data:GetRankRewardList(), 1)
  self.compBg3:SetActive(not table.IsNullOrEmpty(data:GetZoneRankRewardList()))
  if not table.IsNullOrEmpty(data:GetZoneRankRewardList()) then
    self:SetRankRewards(data:GetZoneRankRewardList(), 2)
  end
  self.allianceRewardReceiveState = BattlefieldDsbDuelUtils.ActInfo:GetReceiveState(data.id, true)
  self.zoneRewardReceiveState = BattlefieldDsbDuelUtils.ActInfo:GetReceiveState(data.id, false)
  if BattlefieldDsbDuelUtils.ActInfo:GetZoneRewardCount(self.data.id) and self.zoneRewardReceiveState == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive then
    self.textReceiveBtnText3:SetText("\195\151" .. BattlefieldDsbDuelUtils.ActInfo:GetZoneRewardCount(self.data.id))
  else
    self.textReceiveBtnText3:SetLocalText(self.zoneRewardReceiveState == BattlefieldDsbConst.BF_DSB_REWARD_STATE.Received and "170003" or "129054")
  end
  self.textReceiveBtnText2:SetLocalText(self.allianceRewardReceiveState == BattlefieldDsbConst.BF_DSB_REWARD_STATE.Received and "170003" or "129054")
  UIGray.SetGray(self.btnReceiveBtn2.transform, self.allianceRewardReceiveState ~= BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive, true)
  UIGray.SetGray(self.btnReceiveBtn3.transform, self.zoneRewardReceiveState ~= BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive, true)
end

return UIBFDsbDuelActRulesRewardDetailItem
