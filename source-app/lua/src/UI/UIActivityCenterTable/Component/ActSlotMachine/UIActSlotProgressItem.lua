local UIActSlotProgressItem = BaseClass("UIActSlotProgressItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local num_path = "num"
local reward_content_path = "rewardContent"
local u_i_common_res_item_path = "rewardContent/UICommonResItem"
local have_get_path = "rewardContent/haveGet"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.reward_content = self:AddComponent(UIButton, reward_content_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.have_get = self:AddComponent(UIImage, have_get_path)
  self.reward_content:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.showData = nil
end

local function DataDestroy(self)
  self.showData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotProgressReward, self.Refresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotProgressReward, self.Refresh)
end

local function SetData(self, showData, rewardData, index, actDetailData)
  self.showData = showData
  self.rewardData = rewardData
  self.curNum = actDetailData.totalScore
  self.index = index
  self.actDetailData = actDetailData
  self:Refresh()
end

local function Refresh(self)
  if self.showData == nil then
    return
  end
  self.num:SetText(self.showData[1])
  local rewardInfo = {}
  rewardInfo.rewardType = self.rewardData[1]
  rewardInfo.itemId = self.rewardData[2]
  rewardInfo.count = self.rewardData[3]
  self.u_i_common_res_item:ReInit(rewardInfo)
  if self.curNum >= self.showData[1] then
    self.num:SetColor(Color.New(0.2, 0.49019607843137253, 0, 1))
    if self.actDetailData.rewardProcessDict[self.index - 1] == nil then
      self.have_get:SetActive(false)
      self:AddHighLight()
    else
      self.have_get:SetActive(true)
      self:RemoveHighLight()
    end
  else
    self.num:SetColor(Color.New(0.47058823529411764, 0.21568627450980393, 0.0196078431372549, 1))
    self.have_get:SetActive(false)
  end
end

local function BtnClick(self)
  if self.curNum >= self.showData[1] and self.actDetailData.rewardProcessDict[self.index - 1] == nil then
    SFSNetwork.SendMessage(MsgDefines.SlotsProcessReward, tonumber(self.actDetailData.activityId), self.index - 1)
    return
  end
  self.u_i_common_res_item:OnBtnClick()
end

local function AddHighLight(self)
  if self.effectRequest ~= nil then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync(EffectAssets.ItemCanGetEffect, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.reward_content.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "effect"
  end)
end

local function RemoveHighLight(self)
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

UIActSlotProgressItem.OnCreate = OnCreate
UIActSlotProgressItem.OnDestroy = OnDestroy
UIActSlotProgressItem.ComponentDefine = ComponentDefine
UIActSlotProgressItem.ComponentDestroy = ComponentDestroy
UIActSlotProgressItem.DataDefine = DataDefine
UIActSlotProgressItem.DataDestroy = DataDestroy
UIActSlotProgressItem.OnAddListener = OnAddListener
UIActSlotProgressItem.OnRemoveListener = OnRemoveListener
UIActSlotProgressItem.SetData = SetData
UIActSlotProgressItem.Refresh = Refresh
UIActSlotProgressItem.BtnClick = BtnClick
UIActSlotProgressItem.AddHighLight = AddHighLight
UIActSlotProgressItem.RemoveHighLight = RemoveHighLight
return UIActSlotProgressItem
