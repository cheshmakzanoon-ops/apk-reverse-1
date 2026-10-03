local UIActLotteryBeSendRewardGetView = BaseClass("UIActLotteryBeSendRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local btn_get_path = "Main/Root/BtnGet"
local item_path = "Main/Root/Item"
local content_path = "Main/Root/ScrollView/Viewport/Content"
local content_text_path = "Main/Root/contentText"

function UIActLotteryBeSendRewardGetView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self:RefreshView()
end

function UIActLotteryBeSendRewardGetView:OnDestroy()
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryBeSendRewardGetView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.btn_get = self:AddComponent(UIButton, btn_get_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_get:SetOnClick(function()
    self:GetBtnClick()
  end)
  self.btn_get:SetSafeClickMode(true)
  self.item = self:AddComponent(UICanvasGroup, item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item:SetActive(false)
  self.item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
end

function UIActLotteryBeSendRewardGetView:ComponentDestroy()
  self.panel = nil
  self.btn_get = nil
  self.item = nil
  self.content = nil
  self.content_text = nil
end

function UIActLotteryBeSendRewardGetView:OnEnable()
  base.OnEnable(self)
end

function UIActLotteryBeSendRewardGetView:OnDisable()
  base.OnDisable(self)
end

function UIActLotteryBeSendRewardGetView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryGetBeSendReward, self.GetReceiveGiveRewardMsg)
end

function UIActLotteryBeSendRewardGetView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLotteryGetBeSendReward, self.GetReceiveGiveRewardMsg)
end

function UIActLotteryBeSendRewardGetView:InitData()
  self.activityId = self:GetUserData()
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.showData = DataCenter.RewardManager:ReturnRewardParamForView(self.activityDetailData.reward)
end

function UIActLotteryBeSendRewardGetView:RefreshView()
  if self.activityDetailData == nil then
    return
  end
  local num = 0
  if self.showData and 0 < #self.showData then
    num = self.showData[1].count
  end
  self.content_text:SetLocalText("thxgiv_Lottery_text_11", num)
  self:RefreshCanGetRewardShowContent()
end

function UIActLotteryBeSendRewardGetView:GetBtnClick()
  SFSNetwork.SendMessage(MsgDefines.LottoThanksgivingReceiveReward, self.activityId)
end

function UIActLotteryBeSendRewardGetView:GetReceiveGiveRewardMsg()
  self.showData = DataCenter.RewardManager:ReturnRewardParamForView(self.activityDetailData.reward)
  if self.showData and #self.showData > 0 then
    self:RefreshView()
  else
    self.ctrl:CloseSelf()
  end
end

function UIActLotteryBeSendRewardGetView:RefreshCanGetRewardShowContent()
  if not self.activityDetailData then
    return
  end
  local showData = self.showData
  if showData == nil then
    showData = {}
  end
  for i, v in ipairs(showData) do
    if self.itemList[i] == nil then
      local showIndex = "Item" .. i
      local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = showIndex
      local obj = self.content:AddComponent(UICommonResItem, item.name)
      self.itemList[i] = obj
    end
    self.itemList[i]:SetActive(true)
    self.itemList[i]:ReInit(v)
  end
  for i = #showData + 1, #self.itemList do
    self.itemList[i]:SetActive(false)
  end
end

function UIActLotteryBeSendRewardGetView:ClearAllItem()
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

return UIActLotteryBeSendRewardGetView
