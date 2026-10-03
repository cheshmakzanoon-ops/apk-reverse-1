local UIActGiftBoxKeyAccessItem = require("UI.UIActGiftBox.UIActGiftBoxKeyAccess.Component.UIActGiftBoxKeyAccessItem")
local UIActGiftBoxKeyAccessView = BaseClass("UIActGiftBoxKeyAccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local return_btn_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/Common_bg_orange2/Scroll View/Viewport/Content"
local slider_path = "PopUpTitle/Common_bg_orange2/BG/Slider"
local slider_txt_path = "PopUpTitle/Common_bg_orange2/BG/SliderText"
local slider_icon_path = "PopUpTitle/Common_bg_orange2/BG/Img"
local slider_image_path = "PopUpTitle/Common_bg_orange2/BG/Slider/Rect/Fill"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.model = {}
  self:ReInit()
end

local function OnDestroy(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(110018)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.slider_image = self:AddComponent(UIImage, slider_image_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:ClearList()
  self.title = nil
  self.content = nil
  self.close_btn = nil
  self.return_btn = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResLackList, self.OnRefreshView)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.BuyKonbiniRefresh, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.UseItemSuccessHandle)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResLackList, self.OnRefreshView)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.BuyKonbiniRefresh, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.UseItemSuccessHandle)
end

local function ReInit(self)
  self.lackResource, self.distab, self.startPt, self.isList, self.isPVESTAMINA = self:GetUserData()
  self.slider_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.distab[1].resType))
  self.slider_txt:SetText(string.GetFormattedSeperatorNum(self.distab[1].needCount - self.distab[1].disNum) .. "/" .. string.GetFormattedSeperatorNum(self.distab[1].needCount))
  self.slider:SetValue((self.distab[1].needCount - self.distab[1].disNum) / self.distab[1].needCount)
  table.sort(self.lackResource[1], function(a, b)
    return a:GetTips() < b:GetTips()
  end)
  self:ClearList()
  table.walk(self.lackResource[1], function(k, v)
    self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIActGiftBoxKeyAccessItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(v:GetTips())
      go.name = nameStr
      self.needResourceCells[k] = self.content:AddComponent(UIActGiftBoxKeyAccessItem, nameStr)
      self.needResourceCells[k]:ReInit(v, self.distab[1])
      if k == 1 then
        self.needResourceCells[k]:ShowRecommend(true)
      end
    end)
  end)
end

local function ClearList(self)
  self.content:RemoveComponents(UIActGiftBoxKeyAccessItem)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.needResourceCells = {}
end

local function UseItemSuccessHandle(self, itemId)
  local param = DataCenter.ResLackManager:GetRefreshParam()
  if param == nil then
    return
  end
  self.distab[1].disNum = param.count
  for i = 1, 2 do
    if self.lackResource[1][i]:GetTips() == ResLackGoToType.ResourceBagUse or self.lackResource[1][i]:GetTips() == ResLackGoToType.LoesCamp or self.lackResource[1][i]:GetTips() == ResLackGoToType.ResourceBagBuy or self.lackResource[1][i]:GetTips() == ResLackGoToType.UseGoods then
      self.lackResource[1][i]:CheckIsOk(param.type, self.distab[1].needCount, self.distab[1].isResItem)
    end
  end
  self.slider_txt:SetText(string.GetFormattedSeperatorNum(self.distab[1].needCount - self.distab[1].disNum) .. "/" .. string.GetFormattedSeperatorNum(self.distab[1].needCount))
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTime:Stop()
    self.delayTime = nil
    self.slider:DOValue((self.distab[1].needCount - self.distab[1].disNum) / self.distab[1].needCount, 0.3, function()
      self.slider:SetValue((self.distab[1].needCount - self.distab[1].disNum) / self.distab[1].needCount)
    end)
  end, 0.2)
end

local function OnRefreshView(self, param)
  self.refreshParam = param
end

local function DoClosePanel(self)
  local k, v, startPt = self:GetUserData()
  if startPt ~= nil then
    local time = 0.3
    local closeTime = 0.31
    self.root.transform:DOMove(startPt, time)
    self.root.transform:DOScale(Vector3.New(0.1, 0.1, 0.1), time)
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.ctrl:CloseSelf(false)
    end, closeTime)
  else
    self.ctrl:CloseSelf(true)
  end
end

UIActGiftBoxKeyAccessView.OnCreate = OnCreate
UIActGiftBoxKeyAccessView.OnDestroy = OnDestroy
UIActGiftBoxKeyAccessView.OnEnable = OnEnable
UIActGiftBoxKeyAccessView.OnDisable = OnDisable
UIActGiftBoxKeyAccessView.ComponentDefine = ComponentDefine
UIActGiftBoxKeyAccessView.ComponentDestroy = ComponentDestroy
UIActGiftBoxKeyAccessView.OnAddListener = OnAddListener
UIActGiftBoxKeyAccessView.OnRemoveListener = OnRemoveListener
UIActGiftBoxKeyAccessView.ReInit = ReInit
UIActGiftBoxKeyAccessView.ClearList = ClearList
UIActGiftBoxKeyAccessView.UseItemSuccessHandle = UseItemSuccessHandle
UIActGiftBoxKeyAccessView.OnRefreshView = OnRefreshView
UIActGiftBoxKeyAccessView.DoClosePanel = DoClosePanel
return UIActGiftBoxKeyAccessView
