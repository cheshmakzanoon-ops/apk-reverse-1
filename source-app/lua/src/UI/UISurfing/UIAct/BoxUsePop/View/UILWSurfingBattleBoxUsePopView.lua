local UILWSurfingBattleBoxUsePopView = BaseClass("UILWSurfingBattleBoxUsePopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UILWSurfingBattleBoxUsePopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshSelectedItemInfo()
end

function UILWSurfingBattleBoxUsePopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingBattleBoxUsePopView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Common_img_title/titleText")
  self.btnLWInfo = self:AddComponent(UIButton, "content/LW_Btn_Info")
  self.btnIcon = self:AddComponent(UIButton, "content/btnIcon")
  self.btnIcon:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "content/UICommonResItem")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "content/descText")
  self.slider = self:AddComponent(UISlider, "content/UISliderGroup/Slider")
  self.slider:SetOnValueChanged(function(value)
    if self.notChangeData then
      return
    end
    local maxCount = self.selectedItemData.count or 0
    local count = math.floor(maxCount * value)
    self:SetSelectCount(count, true)
  end)
  self.btnSub = self:AddComponent(UIButton, "content/UISliderGroup/subBtn")
  self.btnSub:SetOnClick(function()
    self:OnBtnSubClick()
  end)
  self.btnAdd = self:AddComponent(UIButton, "content/UISliderGroup/addBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.textCurCount = self:AddComponent(UITextMeshProUGUIEx, "content/UISliderGroup/numRoot/curCount")
  self.btnOpen = self:AddComponent(UIButton, "content/btnOpen")
  self.btnOpen:SetOnClick(function()
    self:OnBtnOpenClick()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "content/btnOpen/LW_Btn_Common_New_Base/BtnText")
end

function UILWSurfingBattleBoxUsePopView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnLWInfo = nil
  self.btnClose = nil
  self.compUICommonResItem = nil
  self.textDesc = nil
  self.slider = nil
  self.btnSub = nil
  self.btnAdd = nil
  self.textCurCount = nil
  self.btnOpen = nil
  self.textBtn = nil
end

function UILWSurfingBattleBoxUsePopView:DataDefine()
  local goodsId = DataCenter.LWSurfingDataManager:GetDailyBoxId()
  self.selectedItemData = DataCenter.ItemData:GetItemById(goodsId)
  self.selectedGoodsId = goodsId
end

function UILWSurfingBattleBoxUsePopView:DataDestroy()
  self.selectedGoodsId = nil
  self.selectedItemData = nil
end

function UILWSurfingBattleBoxUsePopView:OnAddListener()
  base.OnAddListener(self)
end

function UILWSurfingBattleBoxUsePopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSurfingBattleBoxUsePopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleBoxUsePopView:OnBtnLWInfoClick()
  local itemId = self.selectedGoodsId
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local desc = "parkour_buff_reward_show_desc"
  local title = "parkour_buff_reward_show"
  if itemTemplate then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNoticeNew, {anim = true}, itemTemplate.drop_info_para, title, desc)
  else
    Logger.LogError("OnRateBtnClick: not found " .. tostring(itemId))
  end
end

function UILWSurfingBattleBoxUsePopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleBoxUsePopView:OnBtnSubClick()
  local count = self.selectCount - 1
  self:SetSelectCount(count)
end

function UILWSurfingBattleBoxUsePopView:OnBtnAddClick()
  local count = self.selectCount + 1
  self:SetSelectCount(count)
end

function UILWSurfingBattleBoxUsePopView:SetSelectCount(count)
  if not self.selectedGoodsId or not self.selectedItemData then
    return
  end
  local maxCount = self.selectedItemData.count or 0
  if count > maxCount then
    count = maxCount
  end
  if count < 1 then
    count = 1
  end
  self.selectCount = count
  self:RefreshSelectCount()
end

function UILWSurfingBattleBoxUsePopView:RefreshSelectedItemInfo()
  if not self.selectedGoodsId then
    return
  end
  self.compUICommonResItem:ReInit({
    rewardType = RewardType.GOODS,
    itemId = self.selectedGoodsId,
    enableClick = false,
    hideHaveCountShow = true,
    nil
  })
  if not self.selectedItemData or self.selectedItemData.count <= 0 then
    self.btnOpen:SetActive(false)
    self.textCurCount:SetText("")
    self.selectCount = 0
  else
    self.btnOpen:SetActive(true)
    self.textCurCount:SetText(string.format("x%d", self.selectedItemData.count))
    self.selectCount = 1
    self:RefreshSelectCount()
  end
end

function UILWSurfingBattleBoxUsePopView:RefreshSelectCount(exceptSldier)
  if not self.selectedGoodsId or not self.selectedItemData then
    return
  end
  local selectCount = self.selectCount or 0
  local para3 = self.selectedItemData.goods.para3 or ""
  local paras = string.split(para3, ";")
  local goodsId = tonumber(paras[2]) or 0
  local perScore = tonumber(paras[3]) or 0
  local willGetScore = selectCount * perScore
  self.textCurCount:SetText(tostring(selectCount))
  self.notChangeData = true
  if not exceptSldier then
    self.slider:SetValue(selectCount / self.selectedItemData.count <= 1 and selectCount / self.selectedItemData.count or 1)
  end
  self.notChangeData = false
  UIGray.SetGray(self.btnSub.transform, selectCount <= 1, true)
  UIGray.SetGray(self.btnAdd.transform, selectCount >= self.selectedItemData.count, true)
end

function UILWSurfingBattleBoxUsePopView:OnBtnOpenClick()
  if not self.selectedGoodsId then
    return
  end
  local selectedItemData = DataCenter.ItemData:GetItemById(self.selectedGoodsId)
  local count = self.selectCount or 1
  self.ctrl:UseItem(self.selectedGoodsId, count)
  if selectedItemData.count == count then
    self:OnBtnCloseClick()
  else
    self:RefreshSelectedItemInfo()
  end
end

return UILWSurfingBattleBoxUsePopView
