local UILWT11IdleGameBattleRewardView = BaseClass("UILWT11IdleGameBattleRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameBattleRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWT11IdleGameBattleRewardView:OnDestroy()
  if self.param and self.param.closeCallback then
    self.param.closeCallback()
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollRectUICommonGridInfinityScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 5)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 6)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.listGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridInfinityScrollViewContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.textBtn:SetLocalText("t11_idle_game_button_11")
end

function UILWT11IdleGameBattleRewardView:ComponentDestroy()
  self:ClearItemCell()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTips = nil
  self.scrollRectUICommonGridInfinityScrollView = nil
  self.gridInfinityScrollViewContent = nil
  self.btnLWCommonNew = nil
  self.textBtn = nil
end

function UILWT11IdleGameBattleRewardView:DataDefine()
  self.param = nil
end

function UILWT11IdleGameBattleRewardView:DataDestroy()
  self.param = nil
end

function UILWT11IdleGameBattleRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleRewardView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil or table.IsNullOrEmpty(self.param.rewards) then
    self.ctrl:CloseSelf()
    return
  end
  self.textTitle:SetText(self.param.title)
  self.textTips:SetActive(self.param.tips ~= nil)
  if self.param.tips ~= nil then
    self.textTips:SetText(self.param.tips)
    self.scrollRectUICommonGridInfinityScrollView.rectTransform:Set_sizeDelta(653.2, 246.6)
    local x = self.scrollRectUICommonGridInfinityScrollView:GetAnchoredPositionX()
    self.scrollRectUICommonGridInfinityScrollView:SetAnchoredPositionXY(x, 6.35)
  else
    self.scrollRectUICommonGridInfinityScrollView.rectTransform:Set_sizeDelta(653.2, 361.7)
    local x = self.scrollRectUICommonGridInfinityScrollView:GetAnchoredPositionX()
    self.scrollRectUICommonGridInfinityScrollView:SetAnchoredPositionXY(x, 38.898)
  end
  self.gridInfinityScrollViewContent:SetItemCount(#self.param.rewards)
  self.gridInfinityScrollViewContent:ForceUpdate()
end

function UILWT11IdleGameBattleRewardView:OnInitScroll(go, index)
  local item = self.scrollRectUICommonGridInfinityScrollView:AddComponent(UICommonResItem, go)
  item.transform:Set_localScale(0.9, 0.9, 1)
  item:SetActive(false)
  self.listGO[go] = item
end

function UILWT11IdleGameBattleRewardView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(self.param.rewards[theIndex])
  end
end

function UILWT11IdleGameBattleRewardView:OnDestroyScrollItem(go, index)
end

function UILWT11IdleGameBattleRewardView:ClearItemCell()
  self.scrollRectUICommonGridInfinityScrollView:SetVerticalNormalizedPosition(1)
  self.scrollRectUICommonGridInfinityScrollView:RemoveComponents(UICommonResItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.listGO = nil
end

function UILWT11IdleGameBattleRewardView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameBattleRewardView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameBattleRewardView:OnBtnLWCommonNewClick()
  if self.param and self.param.claimCallback then
    self.param.claimCallback()
  end
  self.ctrl:CloseSelf()
end

return UILWT11IdleGameBattleRewardView
