local UICapacityBoxItem = require("UI.UIGiftPackRewardSelect.Component.UICapacityBoxItem")
local UIGiftPackRewardSelectView = BaseClass("UIGiftPackRewardSelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIGiftPackRewardSelectView:OnCreate()
  base.OnCreate(self)
  self.giftPackId, self.callBack = self:GetUserData()
  self:ComponentDefine()
  if not self.giftPackId then
    self.ctrl:CloseSelf()
    return
  end
  self.giftPackData = GiftPackageData.get(self.giftPackId)
  if not self.giftPackData then
    self.ctrl:CloseSelf()
    return
  end
  if table.IsNullOrEmpty(self.giftPackData:getCombs()) then
    self.ctrl:CloseSelf()
    return
  end
  self.selectIndex = self.giftPackData:getChooseIndex()
  if self.selectIndex < 1 then
    self.selectIndex = 1
  end
  self:ReInit()
end

function UIGiftPackRewardSelectView:OnDestroy()
  if self.giftPackData then
    self.giftPackData:setChooseIndex(self.selectIndex)
    self.giftPackData:saveChooseInfo()
  end
  if self.callBack then
    self.callBack()
  end
  self.giftPackData = nil
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGiftPackRewardSelectView:ComponentDefine()
  self._return_panel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self._return_panel:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.txt_title = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self._content_rect = self:AddComponent(UIBaseContainer, "Rect_ScrollView/Viewport/Content")
  self._use_btn = self:AddComponent(UIButton, "Btn_Use")
  self._use_txt = self:AddComponent(UIText, "Btn_Use/Txt_Use")
  self._use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  end)
  self._use_btn:SetActive(false)
  self.cell_select = self:AddComponent(UIBaseContainer, "SelectGo")
  self.cell_select:SetActive(false)
end

function UIGiftPackRewardSelectView:ComponentDestroy()
  self._return_panel = nil
  self.close_btn = nil
  self.txt_title = nil
  self._content_rect = nil
  self._use_btn = nil
  self._use_txt = nil
  self.cell_select.transform:SetParent(self.transform)
  self.cell_select:SetActive(false)
  self.cell_select = nil
end

function UIGiftPackRewardSelectView:OnEnable()
  base.OnEnable(self)
end

function UIGiftPackRewardSelectView:OnDisable()
  base.OnDisable(self)
end

function UIGiftPackRewardSelectView:OnAddListener()
  base.OnAddListener(self)
end

function UIGiftPackRewardSelectView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGiftPackRewardSelectView:ReInit()
  UIGray.SetGray(self._use_btn.transform, true)
  self:ClearScroll()
  self.modelHero = {}
  local List = {}
  local combs = self.giftPackData:getCombs()
  for i = 1, table.count(combs) do
    local items = combs[i]
    if not table.IsNullOrEmpty(items) then
      table.insert(List, items[1])
    end
  end
  for i = 1, #List do
    self.loadedCount = 0
    self.modelHero[i] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self._content_rect.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = i
      local cell = self._content_rect:AddComponent(UICapacityBoxItem, go.name)
      local param = {}
      
      function param.callback(trans, index)
        self:ItemCallBack(trans, index)
      end
      
      param.count = 1
      param.index = i
      param.itemId = List[i].itemId
      param.itemcount = List[i].count
      param.rewardType = RewardType.GOODS
      cell:RefreshData(param)
      self.loadedCount = self.loadedCount + 1
      if self.loadedCount == #List then
        local request = self.modelHero[self.selectIndex]
        if request and not IsNull(request.gameObject) then
          self:ItemCallBack(request.gameObject.transform, self.selectIndex)
        end
      end
    end)
  end
end

function UIGiftPackRewardSelectView:ItemCallBack(trans, index)
  self.cell_select.transform:SetParent(trans)
  self.cell_select.transform:Set_localPosition(0, 0, 0)
  self.cell_select.transform:Set_localScale(1, 1, 1)
  self.cell_select:SetActive(true)
  self.selectIndex = index
  UIGray.SetGray(self._use_btn.transform, false, true)
end

function UIGiftPackRewardSelectView:ClearScroll()
  self._content_rect:RemoveComponents(UICapacityBoxItem)
  if self.modelHero ~= nil then
    for k, v in pairs(self.modelHero) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return UIGiftPackRewardSelectView
