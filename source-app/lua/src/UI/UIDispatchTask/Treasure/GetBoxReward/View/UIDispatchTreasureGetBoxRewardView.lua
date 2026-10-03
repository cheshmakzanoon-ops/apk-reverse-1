local base = UIBaseView
local UIDispatchTreasureGetBoxRewardView = BaseClass("UIDispatchTreasureGetBoxRewardView", base)
local GiftBoxRewardCell = require("UI.UIDispatchTask.Treasure.GetBoxReward.Component.UIDispatchTreasureGetBoxRewardCell")
local GiftBoxRewardCellPrefabPath = "Assets/Main/Prefabs/UI/DispatchTreasure/UIDispatchTreasureGetBoxRewardCell.prefab"
local Localization = CS.GameEntry.Localization
local TitleText_path = "PopUpTitle/Common_img_title/titleText"
local Content_path = "PopUpTitle/Common_bg_orange2"
local CommonRewardText_path = "PopUpTitle/Common_bg_orange2/ScrollView1/PropRewardsText"
local CommonRewardContent_path = "PopUpTitle/Common_bg_orange2/ScrollView1/VerContent/Viewport/Content1"
local BoxRewardText_path = "PopUpTitle/Common_bg_orange2/ScrollView2/GiftRewardsText"
local BoxRewardContent_path = "PopUpTitle/Common_bg_orange2/ScrollView2/Viewport/Content2"
local CloseBtn_path = "PopUpTitle/CloseBtn"
local MaskBtn_path = "panel"
local IntroBtn_path = "PopUpTitle/IntroBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.CommonRewardText = self:AddComponent(UIText, CommonRewardText_path)
  self.CommonRewardContent = self:AddComponent(UIBaseContainer, CommonRewardContent_path)
  self.BoxRewardText = self:AddComponent(UIText, BoxRewardText_path)
  self.BoxRewardContent = self:AddComponent(UIBaseContainer, BoxRewardContent_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.MaskBtn = self:AddComponent(UIButton, MaskBtn_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.CloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.MaskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.IntroBtn:SetOnClick(function()
    self.OnClickIntroBtn(self)
  end)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.Content = nil
  self.CommonRewardText = nil
  self.CommonRewardContent = nil
  self.BoxRewardText = nil
  self.BoxRewardContent = nil
  self.CloseBtn = nil
  self.MaskBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.modelItem = nil
  self.modelGift = nil
end

local function ReInit(self)
  self.showType = self:GetUserData()
  self.TitleText:SetLocalText(390334)
  self.CommonRewardText:SetLocalText("Treasure_map_reward_show_1")
  self:SetBoxRewardText()
  self:SetIntroBtnActive()
  self:RefreshCommonItemPanel()
  self:RefreshRewardItemPanel()
end

local function SetAllCellDestroy(self)
  self.CommonRewardContent:RemoveComponents(UICommonResItem)
  if self.modelItem ~= nil then
    for k, v in pairs(self.modelItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.BoxRewardContent:RemoveComponents(GiftBoxRewardCell)
  if self.modelGift ~= nil then
    for k, v in pairs(self.modelGift) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function RefreshCommonItemPanel(self)
  local listReward = DataCenter.ActDispatchTreasureManager:GetPreviewReward(DispathTreasureRewardType.Common).rewardInfo
  if listReward then
    self.modelItem = {}
    for i = 1, table.count(listReward) do
      self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.CommonRewardContent.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "item_reward_" .. i
        local cell = self.CommonRewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(listReward[i].rewardParam)
        if listReward[i].prop then
          cell.name_text:SetActive(false)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.Content.rectTransform)
      end)
    end
  end
end

local function RefreshRewardItemPanel(self)
  self.modelGift = {}
  local showCount = self:GetShowCountByType()
  for i = 1, showCount do
    self.modelGift[i] = self:GameObjectInstantiateAsync(GiftBoxRewardCellPrefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.BoxRewardContent.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "item_gift_" .. i
      local cell = self.BoxRewardContent:AddComponent(GiftBoxRewardCell, go.name)
      local rewardData
      local index = showCount - i + 1
      if self.showType == TreasureRewardType.ExplorerTreasure then
        rewardData = DataCenter.ExplorerTreasureManager:GetPreviewReward(index)
      elseif self.showType == TreasureRewardType.DigTreasure then
        rewardData = DataCenter.DigTreasureManager:GetPreviewReward(index)
      else
        rewardData = DataCenter.ActDispatchTreasureManager:GetPreviewReward(index)
      end
      cell:ReInit(rewardData, self.showType)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.Content.rectTransform)
    end)
  end
end

local function OnClickIntroBtn(self)
  local str = ""
  if self.showType == TreasureRewardType.ExplorerTreasure then
    local needNum = DataCenter.ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
    local guaranteedNeedTimes = DataCenter.ExplorerTreasureManager:GetGuaranteedNeedTimes()
    str = Localization:GetString("explorer_treasure_rule_explain_01", needNum, guaranteedNeedTimes, guaranteedNeedTimes + 1)
  elseif self.showType == TreasureRewardType.DigTreasure then
    str = Localization:GetString("treasure_map_activity_desc_01", 5, 20, 25, 5)
  end
  local param = {}
  param.activityRulesStr = str
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function GetShowCountByType(self)
  local count = 3
  if self.showType == TreasureRewardType.ExplorerTreasure then
    count = 5
  elseif self.showType == TreasureRewardType.DigTreasure then
    count = 4
  else
    count = 3
  end
  return count
end

local function SetBoxRewardText(self, text)
  if self.showType == TreasureRewardType.ExplorerTreasure then
    self.BoxRewardText:SetLocalText("explorer_treasure_reward_02")
  elseif self.showType == TreasureRewardType.DigTreasure then
    self.BoxRewardText:SetLocalText("treasure_map_reward_show_02")
  else
    self.BoxRewardText:SetLocalText("Treasure_map_reward_show_2")
  end
end

local function SetIntroBtnActive(self)
  if self.showType == TreasureRewardType.ExplorerTreasure or self.showType == TreasureRewardType.DigTreasure then
    self.IntroBtn:SetActive(true)
  else
    self.IntroBtn:SetActive(false)
  end
end

UIDispatchTreasureGetBoxRewardView.OnCreate = OnCreate
UIDispatchTreasureGetBoxRewardView.OnDestroy = OnDestroy
UIDispatchTreasureGetBoxRewardView.OnEnable = OnEnable
UIDispatchTreasureGetBoxRewardView.OnDisable = OnDisable
UIDispatchTreasureGetBoxRewardView.ComponentDefine = ComponentDefine
UIDispatchTreasureGetBoxRewardView.ComponentDestroy = ComponentDestroy
UIDispatchTreasureGetBoxRewardView.DataDefine = DataDefine
UIDispatchTreasureGetBoxRewardView.DataDestroy = DataDestroy
UIDispatchTreasureGetBoxRewardView.ReInit = ReInit
UIDispatchTreasureGetBoxRewardView.RefreshCommonItemPanel = RefreshCommonItemPanel
UIDispatchTreasureGetBoxRewardView.RefreshRewardItemPanel = RefreshRewardItemPanel
UIDispatchTreasureGetBoxRewardView.SetAllCellDestroy = SetAllCellDestroy
UIDispatchTreasureGetBoxRewardView.OnClickIntroBtn = OnClickIntroBtn
UIDispatchTreasureGetBoxRewardView.GetShowCountByType = GetShowCountByType
UIDispatchTreasureGetBoxRewardView.SetBoxRewardText = SetBoxRewardText
UIDispatchTreasureGetBoxRewardView.SetIntroBtnActive = SetIntroBtnActive
return UIDispatchTreasureGetBoxRewardView
