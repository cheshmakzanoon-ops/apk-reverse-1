local UILLRewardView = BaseClass("UILLRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LLRewardBDItem = require("UI.Landlord.Reward.Component.LLRewardBDItem")
local LLRewardBuildItem = require("UI.Landlord.Reward.Component.LLRewardBuildItem")
local LLRewardRankItem = require("UI.Landlord.Reward.Component.LLRewardRankItem")
local LLRewardGroupItem = require("UI.Landlord.Reward.Component.LLRewardGroupItem")
local ActMgr = DataCenter.LandlordMgr
local CLS_Settlement = "UI.Landlord.Reward.Component.LLRewardSettlement"
local PREFAB_Settlement = "Assets/Main/Prefabs/UI/Landlord/Reward/LLRewardSettlement.prefab"
local CLS_Task = "UI.Landlord.Reward.Component.LLRewardTask"
local PREFAB_Task = "Assets/Main/Prefabs/UI/Landlord/Reward/LLRewardTask.prefab"

function UILLRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.scrollView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.toggleTT1 = self.viewSkin:AddComponent(self, UIToggle, 6)
  self.toggleTT2 = self.viewSkin:AddComponent(self, UIToggle, 7)
  self.toggleTC2 = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.toggleTC1 = self.viewSkin:AddComponent(self, UIToggle, 9)
  self.toggleTT3 = self.viewSkin:AddComponent(self, UIToggle, 10)
  self.imgGroupArr = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnGroup = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnGroup:SetOnClick(function()
    self:OnBtnGroupClick()
  end)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.compGroupCell = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.btnGroupContent = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnGroupContent:SetOnClick(function()
    self:OnBtnGroupContentClick()
  end)
  self.compYou1 = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compYou2 = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.textTT42 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textTT41 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.toggleTT4 = self.viewSkin:AddComponent(self, UIToggle, 21)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 22)
  self.compSR = self.viewSkin:AddComponent(self, UIBaseContainer, 23)
  self.toggleTT6 = self.viewSkin:AddComponent(self, UIToggle, 24)
  self.toggleTTList = {
    self.toggleTT1,
    self.toggleTT6,
    self.toggleTT2,
    self.toggleTT3,
    self.toggleTT4
  }
  self.toggleTCList = {
    self.toggleTC1,
    self.toggleTC2
  }
end

function UILLRewardView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.btnClose = nil
  self.compGroup = nil
  self.scrollView = nil
  self.compContent = nil
  self.toggleTT1 = nil
  self.toggleTT2 = nil
  self.toggleTC2 = nil
  self.toggleTC1 = nil
  self.toggleTT3 = nil
  self.imgGroupArr = nil
  self.textGroup = nil
  self.btnGroup = nil
  self.compGroupContent = nil
  self.compGroupCell = nil
  self.btnGroupContent = nil
  self.compYou1 = nil
  self.compYou2 = nil
  self.textTT42 = nil
  self.textTT41 = nil
  self.toggleTT4 = nil
  self.scrollRect = nil
  self.compSR = nil
  self.toggleTT6 = nil
  self.toggleTTList = nil
  self.toggleTCList = nil
end

function UILLRewardView:DataDefine()
  local camp = ActMgr:GetMyGroup()
  local stageFlag = ActMgr:GetActCurStage() >= LLConst.LandlordStage.PREPARE
  self.compYou1:SetActive(stageFlag and camp == LLConst.LandLordGroup.LORD)
  self.compYou2:SetActive(stageFlag and camp == LLConst.LandLordGroup.FARMER)
  local tabIdx = 1
  local sType = 1
  local param = self:GetUserData()
  if param ~= nil then
    if param.camp ~= nil then
      camp = param.camp
    end
    if param.tab ~= nil then
      tabIdx = param.tab
    end
    if param.sType ~= nil then
      sType = param.sType
    end
    if param.openTargetId then
      self.openTargetId = param.openTargetId
    end
  end
  self.curCamp = math.max(camp, 1)
  self.curTabIdx = tabIdx
  self.curSType = sType
  self.groupCells = {}
  self.infoCnt = 0
  self.cbSType = BindCallback(self, self.SetSTypeSel)
  self.toggleTCList[self.curCamp]:SetIsOn(true)
  for i, tog in ipairs(self.toggleTCList) do
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleTCClick(i)
      end
    end)
  end
  self.toggleTTList[tabIdx]:SetIsOn(true)
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
  self:OnToggleTCClick(self.curCamp, true)
end

function UILLRewardView:DataDestroy()
  self:ClearGroupItem()
  self.compContent:RemoveComponents(LLRewardBDItem)
  self.compContent:RemoveComponents(LLRewardBuildItem)
  self.compContent:RemoveComponents(LLRewardRankItem)
  self.scrollView:ClearAllItems()
  self.groupCells = nil
  self.group_cell = nil
  self.cbSType = nil
  self.compSettlementReward = nil
  self.compTaskReward = nil
end

function UILLRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UILLRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILLRewardView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLRewardView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLRewardView:OnBtnGroupClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetSTypeSel(0)
end

function UILLRewardView:OnBtnGroupContentClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetSTypeSel(self.curSType)
end

function UILLRewardView:ClearGroupItem()
  self.compGroupContent:RemoveComponents(LLRewardGroupItem)
  self.group_cell:GameObjectRecycleAll()
end

function UILLRewardView:OnToggleTCClick(index, bForce)
  if not bForce and self.curCamp == index then
    return
  end
  self.curCamp = index
  if not bForce then
    self.curSType = 1
    self.curTabIdx = LLConst.RewardTabType.WL
    self.toggleTTList[self.curTabIdx]:SetIsOn(true)
  end
  local key = self.curCamp == 1 and "zonewar_landlord_limit_1004" or "zonewar_landlord_limit_1003"
  self.textTT41:SetLocalText(key)
  self.textTT42:SetLocalText(key)
  self:RefreshGroupShow()
end

function UILLRewardView:OnToggleTTClick(index)
  if self.curTabIdx == index then
    return
  end
  self.curTabIdx = index
  self.curSType = 1
  self:RefreshGroupShow()
end

function UILLRewardView:SetSTypeSel(index)
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
      obj = self.compGroupContent:AddComponent(LLRewardGroupItem, item.name)
      obj:SetActive(true)
      table.insert(self.groupCells, obj)
    end
    obj:SetData(i, self.curSType, self.cbSType)
  end
end

function UILLRewardView:RefreshGroupShow()
  local showGroup = self.curTabIdx == LLConst.RewardTabType.PRank or self.curTabIdx == LLConst.RewardTabType.ARank
  self.compGroup:SetActive(showGroup)
  local x, y = self.scrollView:GetOffsetMaxXY()
  y = showGroup and -165 or -100
  self.scrollView:SetOffsetMaxXY(x, y)
  if showGroup then
    self.compGroupContent:SetActive(false)
    self.compGroupCell:SetActive(false)
    self:SetSTypeSel(self.curSType)
  else
    self:RefreshList()
  end
end

function UILLRewardView:RefreshList()
  if self:RefreshContentReward() then
    return
  end
  local list
  if self.curTabIdx == LLConst.RewardTabType.BD then
    list = {}
    local tmpList = ActMgr:GetCityTypeIdList()
    for _, id in ipairs(tmpList) do
      local template = ActMgr:GetCityTypeConfig(id)
      local rewardId = self.curCamp == LLConst.LandLordGroup.LORD and template.defend_reward or template.destroy_reward
      if rewardId ~= nil and rewardId ~= 0 then
        table.insert(list, id)
      end
    end
  elseif self.curTabIdx == LLConst.RewardTabType.PRank or self.curTabIdx == LLConst.RewardTabType.ARank then
    local type = (self.curTabIdx - 1) * 10 + self.curSType
    list = ActMgr:GetReward(type, self.curCamp)
  end
  self.infoList = list
  self.infoCnt = list ~= nil and #self.infoList or 0
  if self.curTabIdx == LLConst.RewardTabType.BD then
    self.infoCnt = self.infoCnt + 1
  end
  self.scrollView:SetActive(0 < self.infoCnt)
  if 0 < self.infoCnt then
    self.scrollView:SetListItemCount(self.infoCnt, false, false)
    self.scrollView:RefreshAllShownItem()
    self.scrollView:MovePanelToItemIndex(0)
  end
end

function UILLRewardView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > self.infoCnt then
    return nil
  end
  local data = self.infoList[index]
  local name, cls
  if self.curTabIdx == LLConst.RewardTabType.BD then
    if data == nil then
      name = "LLRewardBDItem"
      cls = LLRewardBDItem
    else
      name = "LLRewardBuildItem"
      cls = LLRewardBuildItem
    end
  else
    name = "LLRewardRankItem"
    cls = LLRewardRankItem
  end
  local csItem = loopScroll:NewListViewItem(name)
  local item = self.compContent:GetComponent(csItem.gameObject.name, cls)
  if item == nil then
    local nameStr = "Item_" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    item = self.compContent:AddComponent(cls, nameStr)
  end
  item:SetActive(true)
  item:SetData(data, self.curCamp)
  return csItem
end

function UILLRewardView:RefreshContentReward()
  local showFlag = self.curTabIdx == LLConst.RewardTabType.WL or self.curTabIdx == LLConst.RewardTabType.Week
  self.scrollView:SetActive(not showFlag)
  self.scrollRect:SetActive(showFlag)
  if showFlag then
    if self.curTabIdx == LLConst.RewardTabType.WL then
      if self.compSettlementReward == nil then
        self.compSettlementReward = self:LoadComponentAsync(CLS_Settlement, PREFAB_Settlement, self.compSR)
      end
      self.compSettlementReward:SetCamp(self.curCamp)
    elseif self.curTabIdx == LLConst.RewardTabType.Week then
      if self.compTaskReward == nil then
        self.compTaskReward = self:LoadComponentAsync(CLS_Task, PREFAB_Task, self.compSR)
      end
      self.compTaskReward:SetCamp(self.curCamp, self.scrollRect, self.openTargetId)
      self.openTargetId = nil
    end
    if self.compSettlementReward then
      self.compSettlementReward:SetActive(self.curTabIdx == LLConst.RewardTabType.WL)
    end
    if self.compTaskReward then
      self.compTaskReward:SetActive(self.curTabIdx == LLConst.RewardTabType.Week)
    end
  end
  return showFlag
end

return UILLRewardView
