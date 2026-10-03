local UILWBargainShopShareView = BaseClass("UIBuildHeroListView", UIBaseView)
local base = UIBaseView
local UICurrencyCell = require("UI.UIActivityCenterTable.Component.UIBargainShop.UICurrencyCell")
local UIHelpPlayerCell = require("UI.UILWBargainShopShare.Component.UIHelpPlayerCell")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local redKey = "<color=#dd2828> %s</color>"
local RemainingKey = "activity_bargain_shop_desc39"

function UILWBargainShopShareView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWBargainShopShareView:ComponentDefine()
  self.playerList = self:AddComponent(UIScrollView, "scrollView_playerList")
  self.resItem = self:AddComponent(UICommonResItem, "top/UICommonResItem")
  self.itemName = self:AddComponent(UIText, "top/itemName")
  self.currencyCell = self:AddComponent(UICurrencyCell, "ExpArea")
  self.shareCdText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/instantBtn/timeLayOut/instantIcon/CostInstantText")
  self.shareCdLayOut = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/btnLayout/instantBtn/timeLayOut")
  self.shareNotCd_text = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/instantBtn/btnText")
  self.share_text = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/btnLayout/instantBtn/timeLayOut/instantBtnText")
  self.shareBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/instantBtn")
  self.buyBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/TrainBtn")
  self.buyBtnText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/TrainBtn/GameObject/timeLayout/CostTimeText")
  self.buyBtnIcon = self:AddComponent(UIImage, "UICommonPopUpTitle/btnLayout/TrainBtn/GameObject/timeLayout/TimeIcon")
  self.buyBtnPrice = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/TrainBtn/GameObject/price")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.grayBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/grayBtn")
  self.surplusText = self:AddComponent(UIText, "UICommonPopUpTitle/surplusText")
  self.grayBtn:SetOnClick(function()
    self:OnGrayBtnClick()
  end)
  self.shareBtn:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.buyBtn:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.playerList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.multipleContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/MultipleContent")
  self.countSlider = self:AddComponent(UISlider, "UICommonPopUpTitle/MultipleContent/CountSlider")
  self.countSlider:SetOnValueChanged(function(value)
    self:OnCountValueChanged(value)
  end)
  self.countInput = self:AddComponent(UIInput, "UICommonPopUpTitle/MultipleContent/CountGroup/CountInput")
  self.countInput:SetOnEndEdit(function(value)
    self:InputListener(value)
  end)
  self.addBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/MultipleContent/addBtn")
  self.subtractBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/MultipleContent/subtractBtn")
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.subtractBtn:SetOnClick(function()
    self:OnSubtractBtnClick()
  end)
end

function UILWBargainShopShareView:OnGrayBtnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.actData.cd_end_time * 1000 - curTime
  if 0 < time then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(time)
    UIUtil.ShowTips(Localization:GetString("activity_bargain_shop_desc34", timeStr))
    return
  end
  if self.data:GetIsSuper() then
    UIUtil.ShowTipsId("activity_bargain_shop_desc35")
  end
end

function UILWBargainShopShareView:OnClickShareBtn()
  local share_param = {}
  share_param.itemUid = self.data.uuid
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.Activity_BargainShop
  share_param.postType = PostType.Activity_BargainShop
  share_param.itemId = self.data.shopId
  share_param.activityId = self.data.template.activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UILWBargainShopShareView:ComponentDestroy()
  self.playerList = nil
  self.multipleContent = nil
  self.countSlider = nil
  self.countInput = nil
  self.addBtn = nil
  self.subtractBtn = nil
end

function UILWBargainShopShareView:OnClickBuyBtn()
  if not self:GetIsCanBuy() then
    local actTemplate = DataCenter.ActivityListDataManager:GetActivityDataById(self.data.activityId)
    local info = DataCenter.ActBargainShopData:GetInfoByActId(self.data.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.data.activityId, info:GetGiftPackId(), tonumber(actTemplate.para_2))
    return
  end
  if #self.data.helpPlayers >= self.data.template.bargain_num then
    SFSNetwork.SendMessage(MsgDefines.BargainShopBuy, self.data.activityId, self.data.uuid, self.curCount)
  else
    UIUtil.ShowMessage(Localization:GetString("activity_bargain_shop_desc21"), 2, "activity_bargain_shop_desc23", "activity_bargain_shop_desc22", function()
      SFSNetwork.SendMessage(MsgDefines.BargainShopBuy, self.data.activityId, self.data.uuid, self.curCount)
    end, nil, nil, "activity_bargain_shop_desc20")
  end
end

function UILWBargainShopShareView:ShowScroll()
  self:ClearScroll()
  self.playerDataList = self.ctrl.GetPlayers(self.data, function()
    if self:GetIsCd() and not self.data:GetIsBargainCompleted() then
      self:OnGrayBtnClick()
    else
      self:OnClickShareBtn()
    end
  end)
  local count = #self.playerDataList
  self.playerList:SetTotalCount(count)
  if 0 < count then
    self.playerList:RefillCells()
  end
end

function UILWBargainShopShareView:ClearScroll()
  self.playerList:ClearCells()
  self.playerList:RemoveComponents(UIHelpPlayerCell)
end

function UILWBargainShopShareView:GetIsCd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.actData.cd_end_time * 1000 - curTime
  return 0 < time
end

function UILWBargainShopShareView:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.actData.cd_end_time * 1000 - curTime
  if time <= 0 then
    time = 0
    self:ReshfShareTimeBtnState()
  end
  self.shareCdText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
end

function UILWBargainShopShareView:AddTimer()
  self:RefreshTimerCountdown()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, function()
      self:RefreshTimerCountdown()
    end, self, false, false, false)
  end
  self.timer:Start()
end

function UILWBargainShopShareView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWBargainShopShareView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.playerList:AddComponent(UIHelpPlayerCell, itemObj)
  item:SetData(self.playerDataList[index])
end

function UILWBargainShopShareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainProp, self.ReshfShareView)
  self:AddUIListener(EventId.ShareBargainShopMessage, self.ReshfShareView)
  self:AddUIListener(EventId.RefreshItems, self.ReshfShareBtn)
end

function UILWBargainShopShareView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainProp, self.ReshfShareView)
  self:RemoveUIListener(EventId.ShareBargainShopMessage, self.ReshfShareView)
  self:RemoveUIListener(EventId.RefreshItems, self.ReshfShareBtn)
  base.OnRemoveListener(self)
end

function UILWBargainShopShareView:ReInit()
  self:ReshfShareView(self:GetUserData())
  SFSNetwork.SendMessage(MsgDefines.BargainShopDetail, self.data.uuid, self.data.activityId)
end

function UILWBargainShopShareView:GetIsCanBuy()
  local ownCurrencyCount = 0
  local itemData = DataCenter.ItemData:GetItemById(tonumber(self.data.template.currency))
  if itemData then
    ownCurrencyCount = itemData.count
  end
  local curCount = self.data.template.price - self.data:GetReducePrice()
  if ownCurrencyCount >= curCount * self.curCount then
    return true
  else
    return false
  end
end

function UILWBargainShopShareView:GetCurrencyCountText()
  local curCount = self.data.template.price - self.data:GetReducePrice()
  local str
  if self:GetIsCanBuy() then
    str = curCount * self.curCount
  else
    str = string.format(redKey, curCount * self.curCount)
  end
  return str
end

function UILWBargainShopShareView:ReshfShareView(data)
  self.data = data
  self.resItem:ReInit(self.data.template)
  self:ShowScroll()
  self.actData = DataCenter.ActBargainShopData:GetInfoByActId(self.data.activityId)
  self:ReshfShareTimeBtnState()
  self.itemName:SetText(DataCenter.RewardManager:GetNameByType(self.data.template.rewardType, self.data.template.itemId))
  self.buyBtnIcon:LoadSprite(self.data.template:GetCurrencyIconPath())
  self.currencyCell:UpdateData(self.data)
  self.count = self.data.template.buyTimeLimit - self.data.buyNum
  self.surplusText:SetLocalText(RemainingKey, self.count)
  self.countSlider.unity_uislider.maxValue = self.count
  self.countSlider.unity_uislider.minValue = 1
  self.multipleContent:SetActive(self.count > 1)
  self.countSlider:SetValue(self:GetMinCanBuyNum())
  if self:GetMinCanBuyNum() == self.countSlider:GetValue() then
    self:OnCountValueChanged(self:GetMinCanBuyNum())
  end
end

function UILWBargainShopShareView:ReshfShareBtn()
  self.buyBtnPrice:SetActive(self.data.helpPlayers and table.count(self.data.helpPlayers) > 0)
  self.buyBtnPrice:SetText(self.data.template.price * self.curCount)
  self.buyBtnText:SetText(self:GetCurrencyCountText())
end

function UILWBargainShopShareView:ReshfShareTimeBtnState()
  if self:GetIsCd() and not self.data:GetIsBargainCompleted() then
    self.shareCdLayOut:SetActive(true)
    self.share_text:SetActive(false)
    self.grayBtn:SetActive(true)
    self.shareNotCd_text:SetActive(false)
    self.share_text:SetActive(true)
    UIGray.SetGray(self.shareBtn.transform, true, false)
    self:AddTimer()
  else
    if self.data:GetIsBargainCompleted() then
      UIGray.SetGray(self.shareBtn.transform, true, false)
    else
      UIGray.SetGray(self.shareBtn.transform, false, true)
    end
    self.shareNotCd_text:SetLocalText("activity_bargain_shop_desc11")
    self.shareCdLayOut:SetActive(false)
    self.shareNotCd_text:SetActive(true)
    self.share_text:SetActive(false)
    self.grayBtn:SetActive(false)
    self.shareCdText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
  end
end

function UILWBargainShopShareView:OnDeleteCell(itemObj, index)
  self.playerList:RemoveComponent(itemObj.name, UIHelpPlayerCell)
end

function UILWBargainShopShareView:OnCountValueChanged(value)
  self.curCount = math.ceil(value)
  self.countInput:SetText(self.curCount)
  self:ReshfShareBtn()
end

function UILWBargainShopShareView:OnAddBtnClick()
  if self.countSlider.unity_uislider.value < self.countSlider.unity_uislider.maxValue then
    self.countSlider:SetValue(self.countSlider.unity_uislider.value + 1)
  end
end

function UILWBargainShopShareView:OnSubtractBtnClick()
  if self.countSlider.unity_uislider.value > self.countSlider.unity_uislider.minValue then
    self.countSlider:SetValue(self.countSlider.unity_uislider.value - 1)
  end
end

function UILWBargainShopShareView:GetMinCanBuyNum()
  local num = 1
  return num
end

function UILWBargainShopShareView:InputListener(value)
  local count = tonumber(value)
  if count then
    if count < 1 then
      count = 1
    end
    if count > self.count then
      count = self.count
    end
    self.countSlider:SetValue(count)
    self.countInput:SetText(count)
  end
end

function UILWBargainShopShareView:OnDestroy()
  SFSNetwork.SendMessage(MsgDefines.BargainShopDetail, self.data.uuid, self.data.activityId)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBargainShopShareView:OnEnable()
  base.OnEnable(self)
end

function UILWBargainShopShareView:OnDisable()
  base.OnDisable(self)
end

function UILWBargainShopShareView:DataDefine()
  self.curCount = 1
end

function UILWBargainShopShareView:DataDestroy()
  self:DeleteTimer()
  self.data = nil
  self.actData = nil
  self.curCount = nil
end

return UILWBargainShopShareView
