local base = UIBaseView
local UICommonRewardTip = BaseClass("UICommonRewardTip", base)
local Localization = CS.GameEntry.Localization

function UICommonRewardTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UICommonRewardTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonRewardTip:OnAddListener()
  base.OnAddListener(self)
end

function UICommonRewardTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICommonRewardTip:ComponentDefine()
  self.bgMask = self:AddComponent(UIButton, "Mask")
  self.bgMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, "Tip/TipBg/ScrollRect/ViewPort/Content")
  self.bg = self:AddComponent(UIBaseComponent, "Tip/TipBg")
  self.title = self:AddComponent(UIText, "Tip/TipBg/Title")
end

function UICommonRewardTip:ComponentDestroy()
  self.bgMask = nil
  self.bg = nil
end

function UICommonRewardTip:DataDefine()
  self.position, self.textStr, self.rewardData = self:GetUserData()
end

function UICommonRewardTip:DataDestroy()
  self.position, self.textStr, self.rewardData = nil, nil, nil
end

function UICommonRewardTip:Refresh()
  self.title:SetText(self.textStr or "")
  self.bg:SetPosition(self.position)
  self:ClearReward()
  local rewardList = self.rewardData
  for i, data in ipairs(rewardList) do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local index = i
      local nameStr = "UICommonResItem" .. index
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.content.transform)
      transform:Set_localScale(0.75, 0.75, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local item = self.content:AddComponent(UICommonResItem, nameStr)
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      item:ReInit(param)
    end)
  end
end

function UICommonRewardTip:ClearReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

return UICommonRewardTip
