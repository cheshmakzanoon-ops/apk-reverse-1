local UIS0AllianceBossRankView = BaseClass("UIS0AllianceBossRankView", UIBaseView)
local base = UIBaseView
local UIS0AllianceBossRankItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossRankItem")
local S0AllianceBossRankData = require("DataCenter.ActS0AllianceBoss.S0AllianceBossRankData")

function UIS0AllianceBossRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compNodeRank = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 6)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compRankSelf = self.viewSkin:AddComponent(self, UIS0AllianceBossRankItem, 8)
  self.textNoneTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossRankView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnEmpty = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTip = nil
  self.compNodeRank = nil
  self.scrollView = nil
  self.compContent = nil
  self.compRankSelf = nil
  self.textNoneTip = nil
end

function UIS0AllianceBossRankView:DataDefine()
  self.rankList = nil
  self.selfRankInfo = nil
  self.selfDamage = nil
  self.selfRank = nil
end

function UIS0AllianceBossRankView:DataDestroy()
  self.rankList = nil
  self.selfRankInfo = nil
  self.selfDamage = nil
  self.selfRank = nil
end

function UIS0AllianceBossRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossTopListGot, self.ParseRankInfo)
end

function UIS0AllianceBossRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossTopListGot, self.ParseRankInfo)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossRankView:InitView()
  DataCenter.S0AllianceBossDataManager:ReqGetRankInfo()
  self.textTitle:SetLocalText("s0_alliance_boss_rank_btn")
end

function UIS0AllianceBossRankView:ParseRankInfo(message)
  if message then
    self.selfDamage = message.selfDamage
    self.selfRank = message.selfRank
    local topList = message.topList
    local result = {}
    local selfRankInfo
    if topList ~= nil then
      local selfUid = LuaEntry.Player:GetUid()
      for i, v in ipairs(topList) do
        local oneData = S0AllianceBossRankData.New()
        oneData:ParseData(v)
        result[i] = oneData
        if oneData.uid == selfUid then
          selfRankInfo = oneData
          oneData.isSelf = true
        end
      end
    end
    self.selfRankInfo = selfRankInfo
    self.rankList = result
  end
  self:RefreshView()
end

function UIS0AllianceBossRankView:RefreshView()
  if self.rankList == nil or #self.rankList == 0 then
    self.compRankSelf:SetActive(false)
    self.compNodeRank:SetActive(false)
    self.textNoneTip:SetActive(true)
    self.textNoneTip:SetLocalText("s0_alliance_boss_rank_nodata_tips")
    return
  end
  if #self.rankList > 0 then
    self.compNodeRank:SetActive(true)
    self:ClearScroll()
    self.scrollView:SetTotalCount(#self.rankList)
    self.scrollView:RefillCells()
    self.textNoneTip:SetActive(false)
    if self.selfRank == -1 then
      self.compRankSelf:SetActive(false)
    else
      self.compRankSelf:SetActive(true)
      self.compRankSelf:RefreshItem(self.selfRankInfo)
    end
  else
    self.compRankSelf:SetActive(false)
    self.compNodeRank:SetActive(false)
    self.textNoneTip:SetActive(true)
    self.textNoneTip:SetLocalText("")
  end
end

function UIS0AllianceBossRankView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIS0AllianceBossRankItem, itemObj)
  if cellItem ~= nil then
    local info = self.rankList[index]
    if info then
      cellItem:RefreshItem(info)
    end
  end
end

function UIS0AllianceBossRankView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIS0AllianceBossRankItem)
end

function UIS0AllianceBossRankView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIS0AllianceBossRankItem)
end

function UIS0AllianceBossRankView:OnBtnEmptyClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossRankView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

return UIS0AllianceBossRankView
