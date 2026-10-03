local base = UIAsyncContainer
local UIDesertRulesRewardContentD = BaseClass("UIDesertRulesRewardContentD", base)
local Localization = CS.GameEntry.Localization
local UIDesertRulesRewardItemPoint = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.UIDesertRulesRewardItemPoint")

function UIDesertRulesRewardContentD:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDesertRulesRewardContentD:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesRewardContentD:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPointCell = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.name_al = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.tab_content = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.tog1 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.tog2 = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.togFlag1 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.togFlag2 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.btn_reward_info = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btn_reward_info:SetOnClick(function()
    self:OnBtn_reward_infoClick()
  end)
  self.icon_reward_info = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.desc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.desc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.content1 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.content2 = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.name_user = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.name_point1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.name_point2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.content_point_win = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.desc_user_win = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.content_user_lose = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.desc_user_lose = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.content_user_win = self.viewSkin:AddComponent(self, UIBaseContainer, 21)
  self.content_point_lose = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.name_player = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.content_player = self.viewSkin:AddComponent(self, UIBaseContainer, 24)
  self.desc_player1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.desc_player2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.content_player1 = self.viewSkin:AddComponent(self, UIBaseContainer, 27)
  self.content_player2 = self.viewSkin:AddComponent(self, UIBaseContainer, 28)
  self.togList = {
    self.tog1,
    self.tog2
  }
  self.togFlagList = {
    self.togFlag1,
    self.togFlag2
  }
end

function UIDesertRulesRewardContentD:ComponentDestroy()
  self.viewSkin = nil
  self.compPointCell = nil
  self.name_al = nil
  self.tab_content = nil
  self.tog1 = nil
  self.tog2 = nil
  self.togFlag1 = nil
  self.togFlag2 = nil
  self.btn_reward_info = nil
  self.icon_reward_info = nil
  self.desc1 = nil
  self.desc2 = nil
  self.content1 = nil
  self.content2 = nil
  self.name_user = nil
  self.name_point1 = nil
  self.name_point2 = nil
  self.content_point_win = nil
  self.desc_user_win = nil
  self.content_user_lose = nil
  self.desc_user_lose = nil
  self.content_user_win = nil
  self.content_point_lose = nil
  self.name_player = nil
  self.content_player = nil
  self.desc_player1 = nil
  self.desc_player2 = nil
  self.content_player1 = nil
  self.content_player2 = nil
  self.togList = nil
  self.togFlagList = nil
end

function UIDesertRulesRewardContentD:DataDefine()
  self.tabIdx = 1
  self.reqList = {}
  self.contents = {
    self.content1,
    self.content2,
    self.content_player1,
    self.content_player2,
    self.content_point_win,
    self.content_point_lose
  }
  for i, tog in ipairs(self.togList) do
    tog:SetIsOn(i == 1)
    tog:SetOnValueChanged(function(tf)
      if tf then
        self:OnSelectDesertRewardTab(i)
      end
    end)
  end
  self.thePointCell = self.compPointCell.gameObject
  self.thePointCell:GameObjectCreatePool()
end

function UIDesertRulesRewardContentD:DataDestroy()
  if self.reqList ~= nil then
    for _, list in pairs(self.reqList) do
      for _, req in pairs(list) do
        if req then
          req:Destroy()
        end
      end
    end
    self.reqList = nil
  end
  if self.contents ~= nil then
    for _, content in pairs(self.contents) do
      if content then
        content:RemoveAllComponentes()
      end
    end
    self.contents = nil
  end
  self.thePointCell:GameObjectRecycleAll()
  self.thePointCell = nil
  self.tabIdx = 1
  self.bfType = nil
  self.ruleList = nil
end

function UIDesertRulesRewardContentD:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonRewardInfo, self.RefreshContent)
end

function UIDesertRulesRewardContentD:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonRewardInfo, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UIDesertRulesRewardContentD:OnBtn_reward_infoClick()
  local strTip = Localization:GetString("Desert_strom_interface_1003")
  UIUtil.ShowBubbleTips(strTip, self.icon_reward_info.transform.position, 0, -30, 0, nil, nil)
end

function UIDesertRulesRewardContentD:OnSelectDesertRewardTab(idx)
  if not self.hadTeam2 or self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  local data = self:GetRewardInfoData()
  if data == nil or data[1] == nil then
    return
  end
  self:ShowAllianceReward(data)
end

function UIDesertRulesRewardContentD:GetRewardInfoData(doReq)
  local data
  local showFlag = false
  if self.bfType == BattleFieldType.Desert then
    data = DataCenter.ActDragonManager:GetRewardInfo()
    showFlag = data ~= nil and data[1] ~= nil
    if not showFlag and doReq then
      DataCenter.ActDragonManager:SendGetRewardInfo()
    end
  end
  return data, showFlag
end

function UIDesertRulesRewardContentD:GetTeam2()
  local team2 = 0
  if self.bfType == BattleFieldType.Desert then
    local actInfo = DataCenter.ActDragonManager:GetActInfo()
    team2 = actInfo ~= nil and actInfo.hadTeam2 or 0
  end
  return team2
end

function UIDesertRulesRewardContentD:ReInit(battleType, ruleList)
  self.bfType = battleType
  self.ruleList = ruleList
  self:GetRewardInfoData(true)
  self:RefreshView()
end

function UIDesertRulesRewardContentD:UpdateData()
  if self.ruleList == nil or self.bfType == nil then
    return
  end
  local team2 = self:GetTeam2()
  for i, flag in pairs(self.togFlagList) do
    flag:SetActive(i == team2)
  end
  self.hadTeam2 = team2 ~= 0
  self.tab_content:SetActive(self.hadTeam2)
  if self.ruleList ~= nil then
    for _, rule in ipairs(self.ruleList) do
      local order = rule.order
      if order == 1 then
        self.name_al:SetLocalText(rule.title)
        self.desc1:SetLocalText(rule.desc1)
        self.desc2:SetLocalText(rule.desc2)
      elseif order == 2 then
        self.name_player:SetLocalText(rule.title)
        self.desc_player1:SetLocalText(rule.desc1)
        self.desc_player2:SetLocalText(rule.desc2)
      elseif order == 3 then
        self.name_user:SetLocalText(rule.title)
        self.desc_user_win:SetLocalText(rule.desc1)
        self.desc_user_lose:SetLocalText(rule.desc2)
      end
    end
  end
  self:RefreshContent()
end

function UIDesertRulesRewardContentD:RefreshContent()
  local data, showFlag = self:GetRewardInfoData()
  if not showFlag then
    return
  end
  self:ShowAllianceReward(data)
  self:ShowReward(data[3], 3)
  self:ShowReward(data[4], 4)
  self:ShowRewards(data[5], 5)
  self:ShowRewards(data[6], 6)
end

function UIDesertRulesRewardContentD:ShowAllianceReward(data)
  local winAllianceReward = data[1]
  local loseAllianceReward = data[2]
  if self.hadTeam2 then
    local tbName = BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, BattleFieldTableKey.REWARD)
    local winKey = self.tabIdx == 1 and "win_alliance_reward" or "win_alliance_reward_abandonB"
    local winId = LocalController:instance():getIntValue(tbName, 1002, winKey)
    winAllianceReward = DataCenter.ChampionDuelManager:GetRewardsById(winId)
    local loseKey = self.tabIdx == 1 and "lose_alliance_reward" or "lose_alliance_reward_abandonB"
    local loseId = LocalController:instance():getIntValue(tbName, 1002, loseKey)
    loseAllianceReward = DataCenter.ChampionDuelManager:GetRewardsById(loseId)
  end
  if winAllianceReward ~= nil then
    self:ShowReward(winAllianceReward, 1)
  end
  if loseAllianceReward ~= nil then
    self:ShowReward(loseAllianceReward, 2)
  end
end

function UIDesertRulesRewardContentD:GetItemName(idx, i)
  return string.format("item_%s_%s", idx, i)
end

function UIDesertRulesRewardContentD:ShowReward(rewards, idx)
  local content = self.contents[idx]
  if content == nil then
    return
  end
  local list = self.reqList[idx] or {}
  self.reqList[idx] = list
  local max = math.max(#list, rewards ~= nil and #rewards or 0)
  for i = 1, max do
    local cellIdx = i
    local theName = self:GetItemName(idx, cellIdx)
    local req = list[cellIdx]
    if req ~= nil then
      content:RemoveComponent(theName, UICommonResItem)
      req:Destroy()
      list[cellIdx] = nil
    end
    local reward = rewards[cellIdx]
    if reward ~= nil then
      list[cellIdx] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          if self.reqList then
            self.reqList[idx][cellIdx] = nil
          end
          return
        end
        local go = request.gameObject
        go.name = theName
        go.gameObject:SetActive(true)
        local tf = go.transform
        tf:SetParent(content.transform)
        tf:Reset()
        local cell = content:AddComponent(UICommonResItem, theName)
        cell:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
        cell:SetLocalScaleXYZ(0.8, 0.8, 1)
        cell:ReInit(reward)
      end)
    end
  end
end

function UIDesertRulesRewardContentD:ShowRewards(rewards, idx)
  local content = self.contents[idx]
  if content == nil then
    return
  end
  local info
  if self.bfType == BattleFieldType.Desert then
    info = DataCenter.ActDragonManager:GetScoreInfo(idx)
  end
  content:SetActive(info ~= nil)
  if info == nil then
    return
  end
  for i, v in ipairs(info) do
    if v ~= nil then
      local theName = self:GetItemName(idx, i)
      local goItem = content.transform:Find(theName)
      if goItem == nil then
        goItem = self.thePointCell:GameObjectSpawn(content.transform)
        goItem.name = theName
      end
      local itemNode = content:GetComponent(theName, UIDesertRulesRewardItemPoint)
      if itemNode == nil then
        itemNode = content:AddComponent(UIDesertRulesRewardItemPoint, theName)
      end
      if itemNode then
        itemNode:SetActive(true)
        itemNode:ReInit(info[i], rewards[i])
      end
    end
  end
end

return UIDesertRulesRewardContentD
