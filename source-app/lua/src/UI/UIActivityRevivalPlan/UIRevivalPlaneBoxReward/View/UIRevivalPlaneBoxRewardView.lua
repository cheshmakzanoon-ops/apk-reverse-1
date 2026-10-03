local UIRevivalPlaneBoxRewardView = BaseClass("UIRevivalPlaneBoxRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIRevivalPlaneBoxRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRevivalPlaneBoxRewardView:OnDestroy()
  self:ClearReward()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlaneBoxRewardView:ComponentDefine()
  self.btnSpecialBg = self:AddComponent(UIButton, "SpecialBg")
  self.btnSpecialBg:SetOnClick(function()
    self:OnBtnSpecialBgClick()
  end)
  self.textOtherTitle = self:AddComponent(UIText, "SpecialBg/OtherTitleBg/OtherTitleText")
  self.compContent = self:AddComponent(UIBaseContainer, "Content")
  self.textOtherTitle:SetText(Localization:GetString("128027"))
end

function UIRevivalPlaneBoxRewardView:ComponentDestroy()
  self.btnSpecialBg = nil
  self.textOtherTitle = nil
  self.compContent = nil
end

function UIRevivalPlaneBoxRewardView:DataDefine()
  self.itemReqs = {}
end

function UIRevivalPlaneBoxRewardView:DataDestroy()
  self.itemReqs = nil
end

function UIRevivalPlaneBoxRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlaneBoxRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlaneBoxRewardView:ReInit()
  self.rewardList = self:GetUserData()
  if self.rewardList == nil then
    return
  end
  local count = #self.rewardList
  for i = 1, count do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local scale = 0.9
      local item = req.gameObject
      item.name = "reward_item" .. i
      item.transform:SetParent(self.compContent.transform)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.compContent:AddComponent(UICommonResItem, item.name)
      local data = self.rewardList[i]
      if data == nil then
        item:SetActive(false)
        return
      end
      item:SetActive(true)
      cell:ReInit(data)
    end)
  end
end

function UIRevivalPlaneBoxRewardView:ClearReward()
  self.compContent:RemoveComponents(UICommonResItem)
  if table.count(self.itemReqs) > 0 then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function UIRevivalPlaneBoxRewardView:OnBtnSpecialBgClick()
  self.ctrl:CloseSelf()
end

return UIRevivalPlaneBoxRewardView
