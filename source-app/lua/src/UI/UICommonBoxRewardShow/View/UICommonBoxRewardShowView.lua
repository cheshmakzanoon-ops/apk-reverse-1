local base = UIBaseView
local UICommonBoxRewardShowView = BaseClass("UICommonBoxRewardShowView", base)
local GiftBoxRewardCell = require("UI.UIDispatchTask.Treasure.GetBoxReward.Component.UIDispatchTreasureGetBoxRewardCell")
local GiftBoxRewardCellPrefabPath = "Assets/Main/Prefabs/UI/DispatchTreasure/UIDispatchTreasureGetBoxRewardCell.prefab"
local TitleText_path = "PopUpTitle/Common_img_title/titleText"
local Content_path = "PopUpTitle/Common_bg_orange2"
local BoxRewardContent_path = "PopUpTitle/Common_bg_orange2/ScrollView2/Viewport/Content2"
local CloseBtn_path = "PopUpTitle/CloseBtn"
local MaskBtn_path = "panel"
local des_path = "PopUpTitle/Common_bg_orange2/PropRewardsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
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
  self.BoxRewardContent = self:AddComponent(UIBaseContainer, BoxRewardContent_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.MaskBtn = self:AddComponent(UIButton, MaskBtn_path)
  self.des = self:AddComponent(UIText, des_path)
  self.CloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.MaskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.Content = nil
  self.BoxRewardContent = nil
  self.CloseBtn = nil
  self.MaskBtn = nil
  self.des = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UICommonBoxRewardShowView:ReInit()
  self.data = self:GetUserData()
  self.TitleText:SetLocalText(self.data.titleKey)
  self.des:SetLocalText(self.data.desKey)
  self:RefreshRewardItemPanel()
end

function UICommonBoxRewardShowView:RefreshRewardItemPanel()
  self.modelGift = {}
  local count = #self.data.boxList
  for i = 1, count do
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
      local data = DataCenter.ActDispatchTreasureManager:GetPreviewRewardById(self.data.boxList[i].id)
      data.boxIconPath = self.data.boxList[i].boxIconPath
      data.nameStrId = self.data.boxList[i].nameStrId
      cell:ReInit(data)
      cell:SetTip2TextActive(false)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.Content.rectTransform)
    end)
  end
end

function UICommonBoxRewardShowView:SetAllCellDestroy()
  self.BoxRewardContent:RemoveComponents(GiftBoxRewardCell)
  if self.modelGift ~= nil then
    for k, v in pairs(self.modelGift) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.modelGift = nil
  end
end

UICommonBoxRewardShowView.OnCreate = OnCreate
UICommonBoxRewardShowView.OnDestroy = OnDestroy
UICommonBoxRewardShowView.OnEnable = OnEnable
UICommonBoxRewardShowView.OnDisable = OnDisable
UICommonBoxRewardShowView.ComponentDefine = ComponentDefine
UICommonBoxRewardShowView.ComponentDestroy = ComponentDestroy
UICommonBoxRewardShowView.DataDefine = DataDefine
UICommonBoxRewardShowView.DataDestroy = DataDestroy
return UICommonBoxRewardShowView
