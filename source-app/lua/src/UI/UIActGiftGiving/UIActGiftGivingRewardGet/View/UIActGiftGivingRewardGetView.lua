local UIActGiftGivingRewardGetView = BaseClass("UIActGiftGivingRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local btn_get_path = "Root/BtnGet"
local item_path = "Root/Item"
local content_path = "Root/ScrollView/Viewport/Content"
local content_text_path = "Root/contentText"

function UIActGiftGivingRewardGetView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self:RefreshView()
end

function UIActGiftGivingRewardGetView:OnDestroy()
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActGiftGivingRewardGetView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.btn_get = self:AddComponent(UIButton, btn_get_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_get:SetOnClick(function()
    self:GetBtnClick()
  end)
  self.item = self:AddComponent(UICanvasGroup, item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item:SetActive(false)
  self.item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
end

function UIActGiftGivingRewardGetView:ComponentDestroy()
  self.panel = nil
  self.btn_get = nil
  self.item = nil
  self.content = nil
  self.content_text = nil
end

function UIActGiftGivingRewardGetView:OnEnable()
  base.OnEnable(self)
end

function UIActGiftGivingRewardGetView:OnDisable()
  base.OnDisable(self)
end

function UIActGiftGivingRewardGetView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftGivingReceiveGiveReward, self.GetReceiveGiveRewardMsg)
end

function UIActGiftGivingRewardGetView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftGivingReceiveGiveReward, self.GetReceiveGiveRewardMsg)
end

function UIActGiftGivingRewardGetView:InitData()
  self.activityId = self:GetUserData()
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(self.activityInfo)
  self.targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
end

function UIActGiftGivingRewardGetView:RefreshView()
  if self.activityDetailData == nil then
    return
  end
  if self.targetIndex == 0 then
    return
  end
  self:RefreshCanGetRewardShowContent()
end

function UIActGiftGivingRewardGetView:GetBtnClick()
  if self.targetIndex == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingReceiveGiveReward, self.activityId, self.targetIndex - 1)
end

function UIActGiftGivingRewardGetView:GetReceiveGiveRewardMsg()
  self.targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
  if self.targetIndex > 0 then
    self:RefreshView()
  else
    self.ctrl:CloseSelf()
  end
end

function UIActGiftGivingRewardGetView:RefreshCanGetRewardShowContent()
  if not self.activityDetailData then
    return
  end
  local showData = {}
  local targetData = self.activityTemp.thxgiv_acc_show_tab[self.targetIndex]
  for i, v in ipairs(targetData) do
    showData[i] = {
      rewardType = RewardType.GOODS,
      itemId = v[1],
      count = v[2]
    }
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
  local contentTxtKey = "thxgiv_AimText1"
  if self.targetIndex == 1 then
    contentTxtKey = "thxgiv_AimText1"
  elseif self.targetIndex == 2 then
    contentTxtKey = "thxgiv_AimText2"
  end
  self.content_text:SetLocalText(contentTxtKey)
end

function UIActGiftGivingRewardGetView:ClearAllItem()
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

return UIActGiftGivingRewardGetView
