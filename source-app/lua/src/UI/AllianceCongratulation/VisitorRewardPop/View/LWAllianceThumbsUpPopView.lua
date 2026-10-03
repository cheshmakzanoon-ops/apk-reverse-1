local LWAllianceThumbsUpPopView = BaseClass("LWAllianceThumbsUpPopView", UIBaseView)
local HeadItem = require("UI.AllianceCongratulation.VisitorRewardPop.Component.LWAllianceThumbsUpPopHeadItem")
local RewardItem = require("UI.AllianceCongratulation.VisitorRewardPop.Component.LWAllianceRewardItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeadList = {
  1,
  3,
  25
}

function LWAllianceThumbsUpPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(61010, false)
  self:RefreshPlayerList()
  self:RefreshRewardList()
end

function LWAllianceThumbsUpPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceThumbsUpPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compRowOne = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compRowTwo = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textThumbersUpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textAwesomeNode = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRewardList = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaimBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.headObjItem = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.rewardObjItem = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.headObjItem.gameObject:GameObjectCreatePool()
  self.rewardObjItem.gameObject:GameObjectCreatePool()
end

function LWAllianceThumbsUpPopView:ComponentDestroy()
  self.headObjItem.gameObject:GameObjectRecycleAll()
  self.rewardObjItem.gameObject:GameObjectRecycleAll()
  self.viewSkin = nil
  self.textTitle = nil
  self.compRowOne = nil
  self.compRowTwo = nil
  self.textThumbersUpName = nil
  self.textAwesomeNode = nil
  self.compRewardList = nil
  self.btnClaim = nil
  self.textClaimBtn = nil
  self.headObjItem = nil
  self.rewardObjItem = nil
end

function LWAllianceThumbsUpPopView:DataDefine()
  local msg = self:GetUserData()
  if msg then
    self.msg = msg
    self.playerList = msg.roleInfo
    self.rewardList = msg.reward
    if msg.visitorUidList then
      self.customerCount = #msg.visitorUidList
    end
    self.thumbCount = msg.thumbCount
  end
  self.textClaimBtn:SetLocalText("activity_99144_ui_6a")
end

function LWAllianceThumbsUpPopView:DataDestroy()
  self.playerList = nil
  self.rewardList = nil
  self.customerCount = nil
  self.thumbCount = nil
end

function LWAllianceThumbsUpPopView:OnAddListener()
  base.OnAddListener(self)
end

function LWAllianceThumbsUpPopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWAllianceThumbsUpPopView:OnBtnClaimClick()
  self.ctrl:CloseSelf()
end

function LWAllianceThumbsUpPopView:RefreshPlayerList()
  self.headObjItem.gameObject:GameObjectRecycleAll()
  if not self.playerList then
    self.playerList = {}
  end
  if not self.thumbCount then
    self.thumbCount = #self.playerList
  end
  if self.playerList then
    if self.customerCount and self.thumbCount < self.customerCount then
      local count = self.customerCount - self.thumbCount
      local list = DataCenter.AllianceCongratulationDataManager:GetPlayerHeadInfoForRewardPop()
      if list then
        local listLength = 0
        for uid, info in pairs(list) do
          table.insert(self.playerList, info)
          listLength = listLength + 1
        end
        count = count - listLength
        DataCenter.AllianceCongratulationDataManager:SetPlayerHeadInfoEmpty()
      end
      if 0 < count then
        for i = 1, count do
          local num = math.random(1, 3)
          if HeadList[num] then
            num = HeadList[num]
          else
            num = 1
          end
          local param = {
            name = "",
            abbr = "",
            headPic = "player_head_" .. num,
            headPicVer = 0
          }
          table.insert(self.playerList, param)
        end
      end
    end
    local playerListData = self.playerList
    if not playerListData or #playerListData <= 0 then
      return
    end
    self.compRowTwo:SetActive(table.length(playerListData) > 10)
    local nameList = {}
    for k, v in ipairs(playerListData) do
      local parentNode
      if k <= 10 then
        parentNode = self.compRowOne
      elseif k <= 20 then
        parentNode = self.compRowTwo
      end
      if parentNode then
        local gameObject = self.headObjItem.gameObject:GameObjectSpawn(parentNode.transform)
        local name = "item_" .. k
        gameObject.name = name
        local headItem = parentNode:AddComponent(HeadItem, name)
        headItem:ReInit(v)
        if not string.IsNullOrEmpty(v.name) then
          local playerName = UIUtil.FormatAllianceAndName(v.abbr, v.name)
          table.insert(nameList, playerName)
        end
      end
    end
    local playerNameStr = table.concat(nameList, ",")
    self.textThumbersUpName:SetText(playerNameStr)
    local playerNum = #playerListData
    local node = Localization:GetString("alliance_congratulation_visitor_tips", playerNum)
    self.textAwesomeNode:SetText(node)
  end
end

function LWAllianceThumbsUpPopView:RefreshRewardList()
  self.rewardObjItem.gameObject:GameObjectRecycleAll()
  if self.rewardList then
    local rewardListData = DataCenter.RewardManager:ReturnRewardParamForMessage(self.rewardList)
    if not rewardListData or #rewardListData <= 0 then
      return
    end
    local parentNode = self.compRewardList
    for k, v in ipairs(rewardListData) do
      local gameObject = self.rewardObjItem.gameObject:GameObjectSpawn(parentNode.transform)
      local name = "reward_" .. k
      gameObject.name = name
      local rewardItem = parentNode:AddComponent(RewardItem, name)
      rewardItem:ReInit(v)
    end
  end
end

return LWAllianceThumbsUpPopView
