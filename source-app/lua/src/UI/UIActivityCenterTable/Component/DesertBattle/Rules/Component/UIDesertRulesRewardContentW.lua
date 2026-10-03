local base = UIAsyncContainer
local UIDesertRulesRewardContentW = BaseClass("UIDesertRulesRewardContentW", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIDesertRulesRewardContentW:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDesertRulesRewardContentW:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesRewardContentW:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.name_ws = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.content_ws = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compDesc = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compScrollView = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function UIDesertRulesRewardContentW:ComponentDestroy()
  self.viewSkin = nil
  self.name_ws = nil
  self.content_ws = nil
  self.compDesc = nil
  self.compScrollView = nil
end

function UIDesertRulesRewardContentW:DataDefine()
  self.desc_ws = self.compDesc.gameObject
  self.desc_ws:GameObjectCreatePool()
  self.scrollView_ws = self.compScrollView.gameObject
  self.scrollView_ws:GameObjectCreatePool()
  self.reqList = {}
  self.contents = {}
end

function UIDesertRulesRewardContentW:DataDestroy()
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
  self.content_ws:RemoveComponent(UITextMeshProUGUIEx)
  self.content_ws:RemoveComponent(UIScrollRect)
  self.desc_ws:GameObjectRecycleAll()
  self.scrollView_ws:GameObjectRecycleAll()
  self.bfType = nil
  self.ruleList = nil
end

function UIDesertRulesRewardContentW:OnAddListener()
  base.OnAddListener(self)
end

function UIDesertRulesRewardContentW:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDesertRulesRewardContentW:ReInit(battleType, ruleList)
  self.bfType = battleType
  self.ruleList = ruleList
  self:RefreshView()
end

function UIDesertRulesRewardContentW:UpdateData()
  if self.ruleList == nil or self.bfType == nil then
    return
  end
  for _, rule in ipairs(self.ruleList) do
    if rule.order == 1 then
      self.name_ws:SetLocalText(rule.title)
    end
  end
  local idx = 1
  local wsContentTF = self.content_ws.transform
  local tbName = BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, BattleFieldTableKey.REWARD)
  LocalController:instance():visitTable(tbName, function(_, lineData)
    local rewardId = lineData:getIntValue("rewardId")
    local rewards = DataCenter.ChampionDuelManager:GetRewardsById(rewardId)
    local descName = "Desc_" .. idx
    local descText
    if self.contents[idx] == nil then
      local tmpDesc = self.desc_ws:GameObjectSpawn(wsContentTF)
      tmpDesc.name = descName
      tmpDesc:SetActive(true)
      descText = self.content_ws:AddComponent(UITextMeshProUGUIEx, descName)
      local tmpScrollView = self.scrollView_ws:GameObjectSpawn(wsContentTF)
      tmpScrollView:SetActive(true)
      local scrollName = "ScrollView_" .. idx
      tmpScrollView.name = scrollName
      self.content_ws:AddComponent(UIBaseContainer, scrollName)
      self.contents[idx] = self.content_ws:AddComponent(UIBaseContainer, scrollName .. "/Content")
    else
      descText = self.content_ws:GetComponent(descName, UITextMeshProUGUIEx)
    end
    if descText then
      descText:SetLocalText(lineData:getValue("desc"), lineData:getIntValue("para"), "")
    end
    self:ShowReward(rewards, idx)
    idx = idx + 1
  end)
end

function UIDesertRulesRewardContentW:GetItemName(idx, i)
  return string.format("item_%s_%s", idx, i)
end

function UIDesertRulesRewardContentW:ShowReward(rewards, idx)
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

return UIDesertRulesRewardContentW
