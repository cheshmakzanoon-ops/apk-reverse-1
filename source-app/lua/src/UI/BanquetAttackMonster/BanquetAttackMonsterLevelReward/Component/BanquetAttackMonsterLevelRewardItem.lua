local BanquetAttackMonsterLevelRewardItem = BaseClass("BanquetAttackMonsterLevelRewardItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local index_num_path = "indexNum"
local content_path = "RewardScroll/Content"
local receive_btn_path = "ReceiveBtn"
local completed_content_path = "CompletedContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.index_num = self:AddComponent(UITextMeshProUGUIEx, index_num_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.completed_content = self:AddComponent(UIBaseContainer, completed_content_path)
  self.receive_btn:SetOnClick(function()
    self:ReceiveBtnClick()
  end)
  self.content:SetAnchoredPositionXY(0, 0)
  self.modelItemList = {}
  self.compList = {}
end

local function ComponentDestroy(self)
  self:RemoveReward()
end

local function SetData(self, boxData, level, activityId)
  self.activityId = activityId
  self.boxData = boxData
  self.level = level
  local targetRewardList = self.boxData.reward
  self.showList = DataCenter.RewardManager:ReturnRewardParamForView(targetRewardList)
  self.index_num:SetText(self.boxData.targetLevel)
  if self.level >= self.boxData.targetLevel then
    if self.boxData.state ~= 1 then
      self.receive_btn:SetActive(true)
      self.completed_content:SetActive(false)
      UIGray.SetGray(self.receive_btn.transform, false, true)
    else
      self.receive_btn:SetActive(false)
      self.completed_content:SetActive(true)
    end
  else
    self.receive_btn:SetActive(true)
    self.completed_content:SetActive(false)
    UIGray.SetGray(self.receive_btn.transform, true, true)
  end
  for i = 1, #self.showList do
    if self.compList[i] then
      self.compList[i]:ReInit(self.showList[i])
    elseif self.modelItemList[i] == nil then
      self.modelItemList[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(0.8, 0.8, 1)
        go.transform:Set_sizeDelta(90, 90)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_pivot(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        if self.showList[i] then
          go.gameObject:SetActive(true)
          cell:ReInit(self.showList[i])
        else
          go.gameObject:SetActive(false)
        end
      end)
    end
  end
  for i = #self.showList + 1, #self.modelItemList do
    if self.compList[i] then
      self.compList[i]:SetActive(false)
    end
  end
end

function _ENV:RemoveReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.modelItemList ~= nil then
    for k, v in pairs(self.modelItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.modelItemList = {}
  self.compList = {}
end

function _ENV:ReceiveBtnClick()
  if self.boxData and self.boxData.state ~= 1 and self.level >= self.boxData.targetLevel then
    local sendParam = {}
    sendParam.aid = tonumber(self.activityId)
    sendParam.id = DataCenter.ActBanquetV2Data.actBanquetId
    sendParam.level = self.boxData.targetLevel
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2LevelReward, sendParam)
  end
end

BanquetAttackMonsterLevelRewardItem.OnCreate = OnCreate
BanquetAttackMonsterLevelRewardItem.OnDestroy = OnDestroy
BanquetAttackMonsterLevelRewardItem.ComponentDefine = ComponentDefine
BanquetAttackMonsterLevelRewardItem.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterLevelRewardItem.SetData = SetData
BanquetAttackMonsterLevelRewardItem.RemoveReward = RemoveReward
BanquetAttackMonsterLevelRewardItem.ReceiveBtnClick = ReceiveBtnClick
return BanquetAttackMonsterLevelRewardItem
