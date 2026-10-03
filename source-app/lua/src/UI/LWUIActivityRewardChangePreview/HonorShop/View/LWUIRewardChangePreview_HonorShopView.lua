local LWUIRewardChangePreview_HonorShopView = BaseClass("LWUIRewardChangePreview_HonorShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIRewardChangePreview_HonorShop_NewTitleComponent = require("UI/LWUIActivityRewardChangePreview/HonorShop/Component/LWUIRewardChangePreview_HonorShop_NewTitleComponent")
local LWUIRewardChangePreview_HonorShop_NewItemComponent = require("UI/LWUIActivityRewardChangePreview/HonorShop/Component/LWUIRewardChangePreview_HonorShop_NewItemComponent")

function LWUIRewardChangePreview_HonorShopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIRewardChangePreview_HonorShopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRewardChangePreview_HonorShopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textConfirm:SetLocalText("activity_rewardchange_btn")
end

function LWUIRewardChangePreview_HonorShopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.compContent = nil
  self.btnLWClose = nil
  self.btnConfirm = nil
  self.textConfirm = nil
end

function LWUIRewardChangePreview_HonorShopView:DataDefine()
end

function LWUIRewardChangePreview_HonorShopView:DataDestroy()
end

function LWUIRewardChangePreview_HonorShopView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIRewardChangePreview_HonorShopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIRewardChangePreview_HonorShopView:OnOpen()
  local shopIdList = self:GetUserData()
  if table.IsNullOrEmpty(shopIdList) then
    self.ctrl:CloseSelf()
    return
  end
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/HonorShop/LWUIRewardChangePreview_HonorShop_NewTitle.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compContent:AddComponent(LWUIRewardChangePreview_HonorShop_NewTitleComponent, go.name)
    model:ReInit(Localization:GetString("honor_shop_tips_1"))
    model:PlayIn()
  end)
  for i, v in ipairs(shopIdList) do
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/HonorShop/LWUIRewardChangePreview_HonorShop_NewItem.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "Item" .. i
      local model = self.compContent:AddComponent(LWUIRewardChangePreview_HonorShop_NewItemComponent, go.name)
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.HonorShop, v)
      if goodsConf then
        local param = {}
        if not string.IsNullOrEmpty(goodsConf.itemId) then
          param = {
            rewardType = RewardType.GOODS,
            itemId = goodsConf.itemId,
            count = goodsConf.itemNum
          }
        elseif goodsConf.resourceitem_id then
          param = {
            rewardType = RewardType.RESOURCE_ITEM,
            itemId = goodsConf.resourceitem_id,
            count = goodsConf.itemNum
          }
        else
          param = {
            rewardType = RewardType.HERO,
            itemId = goodsConf.hero,
            count = goodsConf.itemNum
          }
        end
        model:ReInit(param, goodsConf.maxTimes)
        model:PlayIn()
      else
        Logger.LogError("LWUIRewardChangePreview_HonorShopView config not found id: " .. v)
      end
    end)
  end
  local itemCount = table.count(shopIdList)
  self.btnConfirm.transform:Set_localPosition(0, -111 + (itemCount - 1) * 110 * -1, 0)
end

function LWUIRewardChangePreview_HonorShopView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIRewardChangePreview_HonorShopView:OnBtnLWCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIRewardChangePreview_HonorShopView:OnBtnConfirmClick()
  self.ctrl:CloseSelf()
end

return LWUIRewardChangePreview_HonorShopView
