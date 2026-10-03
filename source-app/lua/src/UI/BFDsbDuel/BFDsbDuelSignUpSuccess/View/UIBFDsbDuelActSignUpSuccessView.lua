local UIBFDsbDuelActSignUpSuccessView = BaseClass("UIBFDsbDuelActSignUpSuccessView", UIBaseView)
local UIBFDsbDuelActSignUpSuccessItem = require("UI.BFDsbDuel.BFDsbDuelSignUpSuccess.Component.UIBFDsbDuelActSignUpSuccessItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActSignUpSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActSignUpSuccessView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActSignUpSuccessView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnBattle = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnBattle:SetOnClick(function()
    self:OnBtnBattleClick()
  end)
  self.textBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.scrollViewScrollView = self.viewSkin:AddComponent(self, UIScrollView, 6)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textTips2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle:SetLocalText("dsb_duel_interface_1008")
  self.textBtnTxt:SetLocalText("dsb_duel_guide_tips_1006")
  self.textTips:SetLocalText("dsb_duel_interface_1009")
  self.textTips2:SetLocalText("dsb_duel_interface_1013")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIBFDsbDuelActSignUpSuccessView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnBattle = nil
  self.textBtnTxt = nil
  self.textTips = nil
  self.scrollViewScrollView = nil
  self.compContent = nil
  self.textTips2 = nil
  self.btnClose = nil
end

function UIBFDsbDuelActSignUpSuccessView:DataDefine()
  self.data = nil
  self:RefreshUI(true)
end

function UIBFDsbDuelActSignUpSuccessView:DataDestroy()
  self.data = nil
end

function UIBFDsbDuelActSignUpSuccessView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
  self:AddUIListener(EventId.AllianceRank, self.OnAllianceRank)
end

function UIBFDsbDuelActSignUpSuccessView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceRank, self.OnAllianceRank)
  self:RemoveUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActSignUpSuccessView:OnDsbDuelActSignUpSuccess()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActSignUpSuccessView:OnAllianceRank()
  self:RefreshUI(false)
end

function UIBFDsbDuelActSignUpSuccessView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActSignUpSuccessView:OnBtnBattleClick()
  if self.isAllCheck then
    BattlefieldDsbDuelUtils.ActInfo:SendActSignUpMsg()
  else
  end
end

function UIBFDsbDuelActSignUpSuccessView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActSignUpSuccessView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollViewScrollView:AddComponent(UIBFDsbDuelActSignUpSuccessItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.data[index])
end

function UIBFDsbDuelActSignUpSuccessView:OnItemMoveOut(itemObj, index)
  self.scrollCellPool[itemObj.name] = nil
  self.scrollViewScrollView:RemoveComponent(itemObj.name, UIBFDsbDuelActSignUpSuccessItem)
end

function UIBFDsbDuelActSignUpSuccessView:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UIBFDsbDuelActSignUpSuccessItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
end

function UIBFDsbDuelActSignUpSuccessView:RefreshUI(isInit)
  self:ClearScroll()
  self.data = {}
  self.isAllCheck = self:CheckAllianceRequirements(isInit)
  self.scrollViewScrollView:SetTotalCount(#self.data)
  self.scrollViewScrollView:RefillCells()
end

function UIBFDsbDuelActSignUpSuccessView:CheckAllianceRequirements(isInit)
  local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.data = {}
  local thresholdStr = LuaEntry.DataConfig:TryGetStr("dsb_duel_league", "k4", "")
  local thresholdList = string.string2array_num_oneSep(thresholdStr, ",")
  if not allianceBaseData then
    table.insert(self.data, {
      state = 0,
      index = 1,
      param = thresholdList[1]
    })
    table.insert(self.data, {
      state = 0,
      index = 2,
      param = thresholdList[2]
    })
    table.insert(self.data, {
      state = 0,
      index = 3,
      param = thresholdList[3]
    })
    return false
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local allianceCreateTime = allianceBaseData.createTime
  local daysPassed = (currentTime - allianceCreateTime) / 86400000
  local isMoreThan7Days = daysPassed > thresholdList[1]
  table.insert(self.data, {
    state = isMoreThan7Days and 1 or 0,
    index = 1,
    param = thresholdList[1]
  })
  local allianceRankList, rankIsReady = DataCenter.RankDataManager:GetAllianceRankListByType(0, RankingTypeServer.POWER_ALLIANCE, LuaEntry.Player:GetSourceServerId(), isInit)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local myRank = -1
  for _, rankData in ipairs(allianceRankList) do
    if rankData.uid == myAllianceId then
      myRank = rankData.rank
      break
    end
  end
  local isTop32 = 0 < myRank and myRank <= thresholdList[2]
  table.insert(self.data, {
    state = isTop32 and 1 or 0,
    index = 2,
    param = thresholdList[2],
    showWait = not rankIsReady
  })
  local memberCount = allianceBaseData.curMember
  local isMoreThan20Members = memberCount >= thresholdList[3]
  table.insert(self.data, {
    state = isMoreThan20Members and 1 or 0,
    index = 3,
    param = thresholdList[3]
  })
  return isMoreThan7Days and isTop32 and isMoreThan20Members
end

return UIBFDsbDuelActSignUpSuccessView
