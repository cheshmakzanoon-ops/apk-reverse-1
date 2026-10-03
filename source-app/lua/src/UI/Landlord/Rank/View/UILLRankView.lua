local UILLRank = BaseClass("UILLRank", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LLRankItem = require("UI.Landlord.Rank.Component.LLRankItem")
local LLRankGroupItem = require("UI.Landlord.Rank.Component.LLRankGroupItem")
local ActMgr = DataCenter.LandlordMgr

function UILLRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLRank:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLRank:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.scrollView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.toggleTT1 = self.viewSkin:AddComponent(self, UIToggle, 6)
  self.toggleTT2 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.toggleTW1 = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.toggleTW2 = self.viewSkin:AddComponent(self, UIToggle, 9)
  self.toggleTW3 = self.viewSkin:AddComponent(self, UIToggle, 10)
  self.compMyRank = self.viewSkin:AddComponent(self, LLRankItem, 11)
  self.btnGroup = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnGroup:SetOnClick(function()
    self:OnBtnGroupClick()
  end)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.imgGroupArr = self.viewSkin:AddComponent(self, UIImage, 16)
  self.compGroupCell = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.btnGroupContent = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnGroupContent:SetOnClick(function()
    self:OnBtnGroupContentClick()
  end)
  self.compCurWeek2 = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.compCurWeek1 = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.compCurWeek3 = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.toggleTTList = {
    self.toggleTT1,
    self.toggleTT2
  }
  self.toggleTWList = {
    self.toggleTW1,
    self.toggleTW2,
    self.toggleTW3
  }
  self.compCurWeekList = {
    self.compCurWeek1,
    self.compCurWeek2,
    self.compCurWeek3
  }
end

function UILLRank:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.btnClose = nil
  self.btnReward = nil
  self.scrollView = nil
  self.compContent = nil
  self.toggleTT1 = nil
  self.toggleTT2 = nil
  self.toggleTW1 = nil
  self.toggleTW2 = nil
  self.toggleTW3 = nil
  self.compMyRank = nil
  self.btnGroup = nil
  self.compGroupContent = nil
  self.textGroup = nil
  self.compGroup = nil
  self.imgGroupArr = nil
  self.compGroupCell = nil
  self.btnGroupContent = nil
  self.compCurWeek2 = nil
  self.textEmpty = nil
  self.compCurWeek1 = nil
  self.compCurWeek3 = nil
  self.toggleTTList = nil
  self.toggleTWList = nil
  self.compCurWeekList = nil
end

function UILLRank:DataDefine()
  local maxWeek = Mathf.Clamp(ActMgr:GetBattleWeek(), 1, #self.toggleTWList)
  self.curWeek = Mathf.Clamp(ActMgr:GetCurWeek(), 1, maxWeek)
  self.curTabIdx = 1
  self.curSType = 1
  self.groupCells = {}
  self.rankItems = {}
  self.rankCount = 0
  self.cbSType = BindCallback(self, self.SetSTypeSel)
  self.toggleTWList[self.curWeek]:SetIsOn(true)
  for i, tog in ipairs(self.toggleTWList) do
    tog:SetActive(maxWeek >= i)
    self.compCurWeekList[i]:SetActive(self.curWeek == i)
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleTWClick(i)
      end
    end)
  end
  self.toggleTTList[1]:SetIsOn(true)
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
  self.group_cell = self.compGroupCell.gameObject
  self.group_cell:GameObjectCreatePool()
  self:OnToggleTWClick(self.curWeek, true)
end

function UILLRank:DataDestroy()
  self:ClearGroupItem()
  self.compContent:RemoveComponents(LLRankItem)
  self.scrollView:ClearAllItems()
  self.groupCells = nil
  self.group_cell = nil
  self.cbSType = nil
  self.rankItems = nil
  ActMgr:CleanRankData()
end

function UILLRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordRankRefresh, self.OnRankListRefresh)
end

function UILLRank:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordRankRefresh, self.OnRankListRefresh)
  base.OnRemoveListener(self)
end

function UILLRank:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLRank:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLRank:OnBtnRewardClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local tab = self.curTabIdx == 1 and LLConst.RewardTabType.PRank or LLConst.RewardTabType.ARank
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
    tab = tab,
    sType = self.curSType
  })
end

function UILLRank:OnBtnGroupClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetSTypeSel(0)
end

function UILLRank:OnBtnGroupContentClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetSTypeSel(self.curSType)
end

function UILLRank:ClearGroupItem()
  self.compGroupContent:RemoveComponents(LLRankGroupItem)
  self.group_cell:GameObjectRecycleAll()
end

function UILLRank:OnToggleTWClick(index, bForce)
  if not bForce and self.curWeek == index then
    return
  end
  local curWeek = math.max(ActMgr:GetCurWeek(), 1)
  if index > curWeek then
    self.toggleTWList[self.curWeek]:SetIsOn(true)
    return
  end
  self.curWeek = index
  if not bForce then
    self.curSType = 1
    self.curTabIdx = 1
    self.toggleTTList[self.curTabIdx]:SetIsOn(true)
  end
  self:RefreshGroupShow()
end

function UILLRank:OnToggleTTClick(index)
  if self.curTabIdx == index then
    return
  end
  self.curTabIdx = index
  self.curSType = 1
  self:RefreshGroupShow()
end

function UILLRank:SetSTypeSel(index)
  local bShowContent = index == 0
  self.compGroupContent:SetActive(bShowContent)
  self.btnGroupContent:SetActive(bShowContent)
  local imgName = bShowContent and "cfm_tongyong_anniu_xiao_1.png" or "cfm_tongyong_anniu_xiao_2.png"
  local imgPath = string.format(LoadPath.CommonPath, imgName)
  self.imgGroupArr:LoadSpriteAuto(imgPath)
  if not bShowContent then
    self.curSType = index
    local key = DataCenter.LandlordMgr:GetRankTypeKey(index)
    self.textGroup:SetLocalText(key)
    self:RefreshList()
    return
  end
  for i = 1, 4 do
    local obj = self.groupCells[i]
    if obj == nil then
      local item = self.group_cell:GameObjectSpawn(self.compGroupContent.transform)
      item.name = "Item_" .. i
      obj = self.compGroupContent:AddComponent(LLRankGroupItem, item.name)
      obj:SetActive(true)
      table.insert(self.groupCells, obj)
    end
    obj:SetData(i, self.curSType, self.cbSType)
  end
end

function UILLRank:RefreshGroupShow()
  self.compGroupContent:SetActive(false)
  self.compGroupCell:SetActive(false)
  self:SetSTypeSel(self.curSType)
end

function UILLRank:OnRankListRefresh(param)
  if self.curWeek ~= param.week or self.curTabIdx ~= param.tab then
    return
  end
  if self.curSType ~= param.sType then
    return
  end
  self:RefreshList()
end

function UILLRank:RefreshList()
  local rankDic = ActMgr:TryGetRank(self.curWeek, self.curTabIdx, self.curSType)
  self.rankList = rankDic ~= nil and rankDic.list or nil
  if table.IsNullOrEmpty(self.rankList) then
    self.rankCount = 0
    self.textEmpty:SetActive(true)
    self.scrollView:SetActive(false)
    self.compMyRank:SetActive(false)
    return
  end
  self.textEmpty:SetActive(false)
  self.rankCount = #self.rankList
  self.scrollView:SetActive(true)
  self.scrollView:SetListItemCount(self.rankCount, false, false)
  self.scrollView:RefreshAllShownItem()
  self.compMyRank:SetActive(true)
  self.compMyRank:SetAsSelf(rankDic, self.curTabIdx == 1, self.rankList[1])
end

function UILLRank:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > self.rankCount then
    return nil
  end
  local data = self.rankList[index]
  local csItem = loopScroll:NewListViewItem("LLRankItem")
  csItem.gameObject:SetActive(true)
  local item = self.rankItems[csItem]
  if item == nil then
    local nameStr = "Item_" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    item = self.compContent:AddComponent(LLRankItem, nameStr)
    self.rankItems[csItem] = item
  end
  item:SetData(data, self.curTabIdx == 1, self.rankList[1])
  return csItem
end

return UILLRank
