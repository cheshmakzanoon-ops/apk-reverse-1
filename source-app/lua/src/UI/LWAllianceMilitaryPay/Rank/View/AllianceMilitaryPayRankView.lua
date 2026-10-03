local AllianceMilitaryPayRankView = BaseClass("AllianceMilitaryPayRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local RankItem = require("UI/LWAllianceMilitaryPay/Rank/Component/AllianceMilitaryPayRankItem")

function AllianceMilitaryPayRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.toggle:SetIsOn(self.isFilter)
  SFSNetwork.SendMessage(MsgDefines.AllianceSalaryRank)
end

function AllianceMilitaryPayRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMilitaryPayRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggle = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.scrollViewScrollRank = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.compEmptyTip = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.toggle:SetOnValueChanged(function(isOn)
    self:OnFilterToggleValueChanged(isOn)
  end)
  self.scrollViewScrollRank:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollRank:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function AllianceMilitaryPayRankView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnClose = nil
  self.toggle = nil
  self.scrollViewScrollRank = nil
  self.compEmptyTip = nil
  self.btnPanel = nil
end

function AllianceMilitaryPayRankView:DataDefine()
  self.isFilter = Setting:GetBool("AllianceMilitaryPayRankFilterOn", false)
end

function AllianceMilitaryPayRankView:DataDestroy()
  self.bIsOneClick = nil
end

function AllianceMilitaryPayRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllianceMilitaryPayGetRankInfo, self.OnGetRankInfo)
end

function AllianceMilitaryPayRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnAllianceMilitaryPayGetRankInfo, self.OnGetRankInfo)
  base.OnRemoveListener(self)
end

function AllianceMilitaryPayRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function AllianceMilitaryPayRankView:OnFilterToggleValueChanged(isOn)
  self.isFilter = isOn
  Setting:SetBool("AllianceMilitaryPayRankFilterOn", self.isFilter)
  self:RefreshList()
end

function AllianceMilitaryPayRankView:OnGetRankInfo(message)
  if not message or not message.ranks then
    return
  end
  self.rankList = message.ranks
  local filterScore = LuaEntry.DataConfig:TryGetNum("alliance_pay_config", "k2") or 0
  self.filterRankList = {}
  for _, rankInfo in ipairs(self.rankList) do
    if filterScore > rankInfo.score then
      table.insert(self.filterRankList, rankInfo)
    end
  end
  self.filterRankList = self.filterRankList
  self:RefreshList()
end

function AllianceMilitaryPayRankView:RefreshList()
  self.curRankList = self.isFilter and self.filterRankList or self.rankList
  if not self.curRankList then
    return
  end
  local count = #self.curRankList
  if 0 < count then
    self.compEmptyTip:SetActive(false)
    self.scrollViewScrollRank:SetActive(true)
    self.scrollViewScrollRank:SetTotalCount(count)
    self.scrollViewScrollRank:RefillCells()
  else
    self.compEmptyTip:SetActive(true)
    self.scrollViewScrollRank:SetActive(false)
  end
end

function AllianceMilitaryPayRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollRank:AddComponent(RankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.curRankList[index])
  end
end

function AllianceMilitaryPayRankView:OnRankItemMoveOut(itemObj, index)
  self.scrollViewScrollRank:RemoveComponent(itemObj.name, RankItem)
end

function AllianceMilitaryPayRankView:ClearScroll()
  self.scrollViewScrollRank:ClearCells()
  self.scrollViewScrollRank:RemoveComponents(RankItem)
end

function AllianceMilitaryPayRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return AllianceMilitaryPayRankView
