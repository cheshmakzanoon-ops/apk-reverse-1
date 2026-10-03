local CellVipInfo = BaseClass("CellVipInfo", UIBaseContainer)
local base = UIBaseContainer
local CellEffect = require("UI.UIVip.Component.CellEffect")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray

function CellVipInfo:OnCreate()
  base.OnCreate(self)
  self._titleLeft_txt = self:AddComponent(UIText, "Txt_TitleLeft")
  self._titleRight_txt = self:AddComponent(UIText, "Txt_TitleRight")
  self._titleFree_txt = self:AddComponent(UIText, "FreeRward/Txt_TitleFree")
  self._alert_txt = self:AddComponent(UIText, "FreeRward/Txt_Alert")
  self._right_btn = self:AddComponent(UIButton, "FreeRward/Btn_Right")
  self._right_btn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self._right_txt = self:AddComponent(UIText, "FreeRward/Btn_Right/Txt_Right")
  self._time_rect = self:AddComponent(UIImage, "FreeRward/Rect_Time")
  self._time_txt = self:AddComponent(UIText, "FreeRward/Rect_Time/Txt_Time")
  self._box_btn = self:AddComponent(UIButton, "FreeRward/Btn_Box")
  self._box_btn:SetOnClick(function()
    self:OnTipsClick(1)
  end)
  self._boxClose_img = self:AddComponent(UIImage, "FreeRward/Btn_Box/Img_BoxClose")
  self._freeTipPos_rect = self:AddComponent(UIBaseContainer, "FreeRward/Btn_Box/Img_BoxClose/FreeTipPos")
  self._boxOpen_img = self:AddComponent(UIImage, "FreeRward/Btn_Box/Img_BoxOpen")
  self.effectView = self:AddComponent(UIBaseContainer, "EffectView")
  self.content = self:AddComponent(UIBaseContainer, "EffectView/Viewport/Content")
  self._rightGift_btn = self:AddComponent(UIButton, "PrivilegeReward/Btn_RightGift")
  self._rightGift_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self._titlePrivilege_txt = self:AddComponent(UIText, "PrivilegeReward/Txt_TitlePrivilege")
  self._priceGift_txt = self:AddComponent(UIText, "PrivilegeReward/Btn_RightGift/Txt_PriceGift")
  self._alertGift_txt = self:AddComponent(UIText, "PrivilegeReward/Txt_AlertGift")
  self._sold_img = self:AddComponent(UIBaseContainer, "PrivilegeReward/Img_Sold")
  self._sold_txt = self:AddComponent(UIText, "PrivilegeReward/Img_Sold/Txt_Sold")
  self._boxGift_btn = self:AddComponent(UIButton, "PrivilegeReward/BoxDown")
  self._boxOpenGift_img = self:AddComponent(UIBaseContainer, "PrivilegeReward/BoxDown/Img_BoxOpenGift")
  self._boxCloseGift_img = self:AddComponent(UIImage, "PrivilegeReward/BoxDown/Img_BoxCloseGift")
  self._boxTipPos_rect = self:AddComponent(UIBaseContainer, "PrivilegeReward/BoxDown/Img_BoxCloseGift/TipPos")
  self._boxGift_btn:SetOnClick(function()
    self:OnTipsClick(2)
  end)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, "PrivilegeReward/Btn_RightGift/UIGiftPackagePoint")
end

function CellVipInfo:OnDestroy()
  self:DeleteTimer()
  self:SetAllCellDestroy()
  self.timer_action = nil
  base.OnDestroy(self)
end

function CellVipInfo:OnEnable()
  base.OnEnable(self)
end

function CellVipInfo:OnDisable()
  base.OnDisable(self)
end

function CellVipInfo:RefreshData(data)
  self.param = data
  self._titleLeft_txt:SetLocalText(320225, self.param.level)
  self._titleRight_txt:SetLocalText(320226, self.param.level)
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self:RefreshFree()
  self:RefreshGift()
  self:RefreshTime()
  local tempCount = table.count(self.param.effect)
  if 0 < tempCount then
    self:SetAllCellDestroy()
    self.model = {}
    for i = 1, tempCount do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIVipCellEffectItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cellItem = self.content:AddComponent(CellEffect, go.name)
        cellItem:RefreshData(self.param.effect[i], i)
      end)
    end
  end
end

function CellVipInfo:SetAllCellDestroy()
  self.content:RemoveComponents(CellEffect)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function CellVipInfo:ScrollItemBack(state)
  self.effectView:SetActive(state)
end

function CellVipInfo:RefreshFree()
  self._titleFree_txt:SetLocalText(320227)
  self._titlePrivilege_txt:SetLocalText(320228)
  if DataCenter.VIPManager:GetVipData().level ~= self.param.level then
    UIGray.SetGray(self._right_btn.transform, true, false)
    self._right_btn:SetActive(false)
    self._alert_txt:SetActive(true)
    self._time_rect:SetActive(false)
    self:ShowBoxState(false, true)
    self._alert_txt:SetLocalText(320230, self.param.level)
    return
  end
  if DataCenter.VIPManager:FreeGoodCanGet(self.param.level) then
    self._right_btn:SetActive(true)
    UIGray.SetGray(self._right_btn.transform, false, true)
    self._right_txt:SetLocalText(170004)
    self._alert_txt:SetActive(false)
    self:ShowBoxState(false, true)
    self._time_rect:SetActive(false)
  else
    self:AddTimer()
    UIGray.SetGray(self._right_btn.transform, true, false)
    self._right_btn:SetActive(false)
    self._alert_txt:SetActive(false)
    self._time_rect:SetActive(true)
    self._boxOpen_img:SetActive(true)
    self:ShowBoxState(true, false)
  end
end

function CellVipInfo:ShowBoxState(box1, box2)
  self._boxOpen_img:SetActive(box1)
  self._boxClose_img:SetActive(box2)
end

function CellVipInfo:RefreshGift()
  self._priceGift_txt:SetText(GiftPackageData.getPackPrice(tostring(self.param.reward2)))
  self.point_rect:RefreshPoint(GiftPackageData.get(tostring(self.param.reward2)))
  local state = DataCenter.VIPManager:AnalyzePayGoodState(self.param.level, self.param.reward2)
  if state == VipPayGoodState.Lock then
    self._rightGift_btn:SetActive(false)
    self._alertGift_txt:SetActive(true)
    self._alertGift_txt:SetLocalText(320231, self.param.level)
    self._sold_img:SetActive(false)
    self:ShowBoxGiftState(false, true)
  elseif state == VipPayGoodState.CanBuy then
    if self.param.reward2 == "" then
      self._rightGift_btn:SetActive(false)
      self._alertGift_txt:SetActive(true)
      self._alertGift_txt:SetLocalText(120105)
    else
      self._rightGift_btn:SetActive(true)
      self._alertGift_txt:SetActive(false)
    end
    self._sold_img:SetActive(false)
    self:ShowBoxGiftState(false, true)
  elseif state == VipPayGoodState.HasGet or VipPayGoodState.CanGet then
    self._rightGift_btn:SetActive(false)
    self._alertGift_txt:SetActive(false)
    self._sold_img:SetActive(true)
    self._sold_txt:SetLocalText(320268)
    self:ShowBoxGiftState(true, false)
  end
end

function CellVipInfo:ShowBoxGiftState(box1, box2)
  self._boxOpenGift_img:SetActive(box1)
  self._boxCloseGift_img:SetActive(box2)
end

function CellVipInfo:BuyGiftCallBack()
  self._rightGift_btn:SetActive(false)
  self._alertGift_txt:SetActive(true)
  self._alertGift_txt:SetLocalText(320268)
  self:ShowBoxGiftState(true, false)
end

function CellVipInfo:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function CellVipInfo:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function CellVipInfo:RefreshTime()
  local resTime = UITimeManager:GetInstance():GetResSecondsTo24()
  if resTime ~= 0 then
    self._time_txt:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
  end
end

function CellVipInfo:OnTipsClick(param)
  local x = param == 1 and self._box_btn.transform.position.x or self._boxCloseGift_img.transform.position.x
  local y = param == 1 and self._box_btn.transform.position.y or self._boxCloseGift_img.transform.position.y
  local width = param == 1 and self._box_btn.rectTransform.rect.width or self._boxCloseGift_img.rectTransform.rect.width
  local pos = param == 1 and self._freeTipPos_rect.transform.position or self._boxTipPos_rect.transform.position
  local reward = param == 1 and self.param.reward1 or self.param.reward2
  if reward == "" then
    UIUtil.ShowTipsId(120105)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipRewardTip, param, x, y, reward, width, pos)
end

function CellVipInfo:OnBuyClick()
  self.param.callBack(self.param.index, true)
  self.view.ctrl:BuyPack(GiftPackageData.get(tostring(self.param.reward2)))
end

function CellVipInfo:OnReceiveClick()
  self.param.callBack(self.param.index, false)
  self.view.ctrl:ReceiveFreeReward()
  UIGray.SetGray(self._right_btn.transform, true, false)
end

return CellVipInfo
