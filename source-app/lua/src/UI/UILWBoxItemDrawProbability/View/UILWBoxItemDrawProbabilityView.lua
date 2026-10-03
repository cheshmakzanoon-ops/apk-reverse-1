local UILWBoxItemDrawProbabilityView = BaseClass("UILWBoxItemDrawProbabilityView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWBoxItemDrawProbabilityItemComponent = require("UI/UILWBoxItemDrawProbability/Component/UILWBoxItemDrawProbabilityItemComponent")

function UILWBoxItemDrawProbabilityView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWBoxItemDrawProbabilityView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBoxItemDrawProbabilityView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetLocalText("activity_torch_relay_title_5")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textDes = self:AddComponent(UIText, "RootContent/DesText")
  self.compRootContent = self:AddComponent(UIBaseContainer, "RootContent")
  self.compItemCell = self:AddComponent(UILWBoxItemDrawProbabilityItemComponent, "RootContent/ScrollView/ItemCell")
  self.compItemCell.gameObject:GameObjectCreatePool()
  self.compItemCell:SetActive(false)
  self.compContent = self:AddComponent(UIBaseContainer, "RootContent/ScrollView/Viewport/Content")
end

function UILWBoxItemDrawProbabilityView:ComponentDestroy()
  self:ClearScroll()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textDes = nil
  self.compRootContent = nil
  self.compItemCell = nil
  self.compContent = nil
end

function UILWBoxItemDrawProbabilityView:DataDefine()
end

function UILWBoxItemDrawProbabilityView:DataDestroy()
end

function UILWBoxItemDrawProbabilityView:OnAddListener()
  base.OnAddListener(self)
end

function UILWBoxItemDrawProbabilityView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWBoxItemDrawProbabilityView:OnOpen()
  if not self:InitData() then
    self.ctrl:CloseSelf()
    return
  end
  self:UpdateContent()
end

function UILWBoxItemDrawProbabilityView:InitData()
  self.param = self:GetUserData()
  if self.param == nil then
    return false
  end
  self.itemId = self.param.itemId
  if self.itemId == nil then
    return false
  end
  self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if self.itemTemplate == nil or self.itemTemplate.type ~= GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
    return false
  end
  self.groupId = checknumber(self.itemTemplate.para1)
  self.data = DataCenter.BoxItemDrawManager:GetUserData(self.groupId)
  if self.data == nil then
    return false
  end
  return true
end

function UILWBoxItemDrawProbabilityView:UpdateContent()
  local template = self.data:GetTemplate(self.data:GetCurRound())
  if template then
    local leftTime = self.data:GetCurTotalLeftCount()
    local bigRewardData = template:GetBigRewardShowData()
    if bigRewardData then
      self.textDes:SetLocalText("activity_torch_relay_rule_3", tostring(leftTime), tostring(bigRewardData.bannedTime))
    end
    local rewards = template:GetRewards()
    if rewards then
      for i, v in pairs(rewards) do
        local item = self.compItemCell.gameObject:GameObjectSpawn(self.compContent.transform)
        item.name = "item" .. i
        local obj = self.compContent:AddComponent(UILWBoxItemDrawProbabilityItemComponent, item.name)
        obj:SetActive(true)
        obj:ReInit(self.groupId, v)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compRootContent.transform)
end

function UILWBoxItemDrawProbabilityView:ClearScroll()
  self.compContent:RemoveComponents(UILWBoxItemDrawProbabilityItemComponent)
  self.compItemCell.gameObject:GameObjectRecycleAll()
end

function UILWBoxItemDrawProbabilityView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWBoxItemDrawProbabilityView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UILWBoxItemDrawProbabilityView
