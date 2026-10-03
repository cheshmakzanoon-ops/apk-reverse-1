local UIRewardShowView = BaseClass("UIRewardShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local Content = "PopUpTitle/Common_bg_orange2"
local Txt_ItemReward = "PopUpTitle/Common_bg_orange2/ScrollView1/rewardsText"
local Rect_ItemContent = "PopUpTitle/Common_bg_orange2/ScrollView1/Viewport/Content1"
local closeBtn_path = "PopUpTitle/CloseBtn"
local maskBtn_path = "panel"

function UIRewardShowView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:ReInit()
end

function UIRewardShowView:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRewardShowView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, title_path)
  self.content = self:AddComponent(UIBaseContainer, Content)
  self._itemReward_txt = self:AddComponent(UIText, Txt_ItemReward)
  self._itemContent_rect = self:AddComponent(UIBaseContainer, Rect_ItemContent)
end

function UIRewardShowView:ComponentDestroy()
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

function UIRewardShowView:ReInit()
  self.titleTxtN:SetText(self.param.title)
  self._itemReward_txt:SetText(self.param.rewardTitle)
  self.listReward = self.param.listReward
  self:SetAllCellDestroy()
  self:RefreshItemReward(self.listReward)
end

function UIRewardShowView:RefreshItemReward(listReward)
  self.modelItem = {}
  if listReward then
    for i = 1, table.count(listReward) do
      self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._itemContent_rect.transform)
        go.transform:Set_localScale(0.75, 0.75, 0.75)
        go.name = "item_reward_" .. i
        local cell = self._itemContent_rect:AddComponent(UICommonResItem, go.name)
        cell:ReInit(listReward[i])
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      end)
    end
  end
end

function UIRewardShowView:SetAllCellDestroy()
  self._itemContent_rect:RemoveComponents(UICommonResItem)
  if self.modelItem ~= nil then
    for k, v in pairs(self.modelItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return UIRewardShowView
