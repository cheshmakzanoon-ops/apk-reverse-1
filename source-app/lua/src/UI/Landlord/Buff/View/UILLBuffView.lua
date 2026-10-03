local UILLBuffView = BaseClass("UILLBuffView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LLBuffItem = require("UI.Landlord.Buff.Component.LLBuffItem")
local ActMgr = DataCenter.LandlordMgr

function UILLBuffView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLBuffView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLBuffView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggleTT1 = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.toggleTT2 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.scrollView = self.viewSkin:AddComponent(self, UILoopListView2, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compYou1 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compYou2 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textDescTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgCampIcon = self.viewSkin:AddComponent(self, UIImage, 11)
  self.compYouList = {
    self.compYou1,
    self.compYou2
  }
  self.toggleTTList = {
    self.toggleTT1,
    self.toggleTT2
  }
end

function UILLBuffView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.btnClose = nil
  self.toggleTT1 = nil
  self.toggleTT2 = nil
  self.scrollView = nil
  self.compContent = nil
  self.compYou1 = nil
  self.compYou2 = nil
  self.compLock = nil
  self.textDescTip = nil
  self.imgCampIcon = nil
  self.toggleTTList = nil
end

function UILLBuffView:DataDefine()
  self.items = {}
  local group = self:GetUserData()
  local myGroup = ActMgr:GetMyGroup()
  if group == nil then
    group = myGroup
  end
  self.tabIdx = math.max(group, 1)
  local stageFlag = ActMgr:GetActCurStage() >= LLConst.LandlordStage.PREPARE
  for i, v in ipairs(self.compYouList) do
    v:SetActive(stageFlag and i == myGroup)
  end
  self.compLock:SetActive(not stageFlag)
  self.textDescTip:SetActive(stageFlag)
  self.toggleTTList[self.tabIdx]:SetIsOn(true)
  for i, tog in ipairs(self.toggleTTList) do
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleTTClick(i)
      end
    end)
  end
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self:OnToggleTTClick(self.tabIdx, true)
end

function UILLBuffView:DataDestroy()
  self.compContent:RemoveComponents(LLBuffItem)
  self.scrollView:ClearAllItems()
  self.items = nil
end

function UILLBuffView:OnAddListener()
  base.OnAddListener(self)
end

function UILLBuffView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILLBuffView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLBuffView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLBuffView:OnToggleTTClick(index, bForce)
  if not bForce and self.tabIdx == index then
    return
  end
  self.tabIdx = index
  self:RefreshList()
end

function UILLBuffView:RefreshList()
  if self.textDescTip:GetActive() then
    local bLord = self.tabIdx == LLConst.LandLordGroup.LORD
    self.imgCampIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and "lrb_jinmai_fenzu_fangshou.png" or "lrb_jinmai_fenzu_gongji.png"))
    self.textDescTip:SetLocalText(bLord and "zonewar_landlord_desc_1020" or "zonewar_landlord_desc_1019")
  end
  self.buffList = ActMgr:GetBuffsByType(self.tabIdx)
  self.buffCnt = #self.buffList
  self.scrollView:SetListItemCount(self.buffCnt, false, false)
  self.scrollView:RefreshAllShownItem()
end

function UILLBuffView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > self.buffCnt then
    return nil
  end
  local data = self.buffList[index]
  local csItem = loopScroll:NewListViewItem("LLBuffItem")
  csItem.gameObject:SetActive(true)
  local item = self.items[csItem]
  if item == nil then
    local nameStr = "Item_" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    item = self.compContent:AddComponent(LLBuffItem, nameStr)
    self.items[csItem] = item
  end
  item:SetData(data)
  return csItem
end

return UILLBuffView
