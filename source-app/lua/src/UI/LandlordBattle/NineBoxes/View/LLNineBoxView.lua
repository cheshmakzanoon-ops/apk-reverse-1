local LLNineBoxView = BaseClass("LLNineBoxView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LLNineBoxCityItem = require("UI.LandlordBattle.NineBoxes.Component.LLNineBoxCityItem")
local ActMgr = DataCenter.LandlordMgr
local LIST_PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLNineBoxList.prefab"
local LIST_CLS = "UI.LandlordBattle.NineBoxes.Component.LLNineBoxList"
local TIP_PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLScorePointsTipRoot.prefab"
local TIP_CLS = "UI.LandlordBattle.NineBoxes.Component.LLScorePointsTipRoot"

function LLNineBoxView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLNineBoxView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLNineBoxView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnMoreReward = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnMoreReward:SetOnClick(function()
    self:OnBtnMoreRewardClick()
  end)
  self.compPanelRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
end

function LLNineBoxView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTips = nil
  self.loopListView = nil
  self.compContent = nil
  self.btnClose = nil
  self.btnMoreReward = nil
  self.compPanelRoot = nil
end

function LLNineBoxView:DataDefine()
  self.tipCb = BindCallback(self, self.OnTipShow)
  self.items = {}
  self.loopListView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.guideList = ActMgr:GetScoreShowList()
  self.maxCnt = #self.guideList
  self.loopListView:SetListItemCount(self.maxCnt, false, false)
  self.loopListView:RefreshAllShownItem()
  self.compBoxList = self:LoadComponentAsync(LIST_CLS, LIST_PREFAB, self.compPanelRoot, function()
    self.compBoxList:SetAnchoredPositionXY(0, -420)
  end)
end

function LLNineBoxView:DataDestroy()
  self:ClearAllItem()
  self.tipCb = nil
  self.tip_root = nil
end

function LLNineBoxView:OnAddListener()
  base.OnAddListener(self)
end

function LLNineBoxView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLNineBoxView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LLNineBoxView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function LLNineBoxView:OnBtnMoreRewardClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward)
end

function LLNineBoxView:ClearAllItem()
  self.compContent:RemoveComponents(LLNineBoxCityItem)
  self.loopListView:ClearAllItems()
  self.guideList = nil
  self.items = nil
end

function LLNineBoxView:TryGetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self.maxCnt then
    return nil
  end
  local data = self.guideList[index]
  local csItem = listview:NewListViewItem("LLNineBoxCityItem")
  csItem.gameObject:SetActive(true)
  local item = self.items[csItem]
  if item == nil then
    local nameStr = "Item_" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    item = self.compContent:AddComponent(LLNineBoxCityItem, nameStr)
    self.items[csItem] = item
  end
  item:SetData(data, index, self.tipCb)
  return csItem
end

function LLNineBoxView:OnTipShow(btn, index)
  if self.tip_root == nil then
    self.tip_root = self:LoadComponentAsync(TIP_CLS, TIP_PREFAB, self, function(comp)
      self.tip_root:SetAsLastSibling()
      self.tip_root:SetOffsetMinXY(0, 0)
      self.tip_root:SetOffsetMaxXY(0, 0)
      self.tip_root:SetSizeDeltaXY(0, 2600)
      local data = self.guideList[index]
      self.tip_root:OnTipCb(btn, data.score_detail)
    end)
  else
    local data = self.guideList[index]
    self.tip_root:OnTipCb(btn, data.score_detail)
  end
end

return LLNineBoxView
