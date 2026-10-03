local AllianceShopCell = require("UI.UIAlliance.UIAllianceShop.Component.AllianceShopCell")
local AllianceCurShopItem = require("UI.UIAlliance.UIAllianceShop.Component.AllianceCurShopItem")
local UIAllianceShopView = BaseClass("UIAllianceShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local toogle1_path = "ImgBg/Tab/Toggle1"
local toogle2_path = "ImgBg/Tab/Toggle2"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local usr_point_obj_path = "ImgBg/messageBar/accItemImage"
local usr_point_txt_path = "ImgBg/messageBar/accItemImage/accItemCount"
local usr_point_btn_path = "ImgBg/messageBar/accItemImage/accItemBtn"
local al_point_obj_path = "ImgBg/messageBar/alPointItemImage"
local al_point_txt_path = "ImgBg/messageBar/alPointItemImage/alPointItemCount"
local al_point_btn_path = "ImgBg/messageBar/alPointItemImage/alPointItemBtn"
local zeroText_path = "ImgBg/CellList/ZeroText"
local item_path = "ImgBg/ItemContent"
local item_name_path = "ImgBg/ItemContent/ItemName"
local item_des_path = "ImgBg/ItemContent/ItemDesBg/Viewport/Content/ItemDes"
local input_path = "ImgBg/ItemContent/InputGo/InputField"
local dec_btn_path = "ImgBg/ItemContent/InputGo/InputField/DecBtn"
local dec_btn_active_path = "ImgBg/ItemContent/InputGo/InputField/DecBtn/DecActiveImage"
local dec_btn_passive_path = "ImgBg/ItemContent/InputGo/InputField/DecBtn/DecInActiveImage"
local add_btn_path = "ImgBg/ItemContent/InputGo/InputField/AddBtn"
local add_btn_active_path = "ImgBg/ItemContent/InputGo/InputField/AddBtn/AddActiveImage"
local add_btn_passive_path = "ImgBg/ItemContent/InputGo/InputField/AddBtn/AddInActiveImage"
local use_btn_path = "ImgBg/ItemContent/UseBtn"
local use_btn_name_path = "ImgBg/ItemContent/UseBtn/obj/UseBtnName"
local single_item_count_path = "ImgBg/ItemContent/UseBtn/obj/singleItemCount"
local buy_btn_path = "ImgBg/ItemContent/buyBtn"
local buy_btn_name_path = "ImgBg/ItemContent/buyBtn/obj/BuyBtnName"
local alliance_item_count_path = "ImgBg/ItemContent/buyBtn/obj/allianceItemCount"
local cur_item_obj_path = "ImgBg/ItemContent/UIBagCell"
local scroll_path = "ImgBg/CellList"
local price_text_path = "ImgBg/ItemContent/OwnNum"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.cells = {}
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.cur_item = self:AddComponent(AllianceCurShopItem, cur_item_obj_path)
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  self.toogle1:SetIsOn(true)
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle1.choose = self.toogle1:AddComponent(UIBaseContainer, "Choose")
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetIsOn(false)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle2.choose = self.toogle2:AddComponent(UIBaseContainer, "Choose")
  self.usr_point_obj = self:AddComponent(UIBaseContainer, usr_point_obj_path)
  self.al_point_obj = self:AddComponent(UIBaseContainer, al_point_obj_path)
  self.usr_point_txt = self:AddComponent(UIText, usr_point_txt_path)
  self.al_point_txt = self:AddComponent(UIText, al_point_txt_path)
  self.usrPointBtnN = self:AddComponent(UIButton, usr_point_btn_path)
  self.usrPointBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.alPointBtnN = self:AddComponent(UIButton, al_point_btn_path)
  self.alPointBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.zeroText = self:AddComponent(UIText, zeroText_path)
  self.item = self:AddComponent(UIText, item_path)
  self.item_name = self:AddComponent(UIText, item_name_path)
  self.item_des = self:AddComponent(UIText, item_des_path)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDecClick()
  end)
  self.dec_btn_active = self:AddComponent(UIImage, dec_btn_active_path)
  self.dec_btn_passive = self:AddComponent(UIImage, dec_btn_passive_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddClick()
  end)
  self.add_btn_active = self:AddComponent(UIImage, add_btn_active_path)
  self.add_btn_passive = self:AddComponent(UIImage, add_btn_passive_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseClick()
  end)
  self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
  self.use_btn_name:SetLocalText(110029)
  self.single_item_count = self:AddComponent(UIText, single_item_count_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyClick()
  end)
  self.buy_btn_name = self:AddComponent(UIText, buy_btn_name_path)
  self.buy_btn_name:SetLocalText(110029)
  self.alliance_item_count = self:AddComponent(UIText, alliance_item_count_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnShopItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnShopItemMoveOut(itemObj, index)
  end)
  self.price_text = self:AddComponent(UIText, price_text_path)
  self.price_text:SetText("")
  self.inputValue = 1
  self.item_list = {}
end

local function OnDestroy(self)
  self.txt_title = nil
  self.cur_item = nil
  self.toogle1.choose = nil
  self.toogle1 = nil
  self.toogle2.choose = nil
  self.toogle2 = nil
  self.usr_point_obj = nil
  self.al_point_obj = nil
  self.usr_point_txt = nil
  self.al_point_txt = nil
  self.zeroText = nil
  self.item = nil
  self.item_name = nil
  self.item_des = nil
  self.dec_btn = nil
  self.add_btn = nil
  self.use_btn = nil
  self.use_btn_name = nil
  self.single_item_count = nil
  self.buy_btn = nil
  self.buy_btn_name = nil
  self.alliance_item_count = nil
  self.input = nil
  self.close_btn = nil
  self.return_btn = nil
  self.ScrollView = nil
  self.selectItemId = nil
  self.inputValue = nil
  self.item_list = nil
  self.selectTab = nil
  self.cells = nil
  self.isChangeTab = nil
  self.tempTab = nil
  base.OnDestroy(self)
end

local function ToggleControlBorS(self)
  self.toogle1.choose:SetActive(self.toogle1:GetIsOn())
  self.toogle2.choose:SetActive(self.toogle2:GetIsOn())
  if self.toogle1:GetIsOn() then
    self.ctrl:SetTab(1)
  elseif self.toogle2:GetIsOn() then
    self.ctrl:SetTab(2)
  end
  self.ctrl:SetCurrentItemId("")
  self:RefreshData()
end

local function RefreshData(self)
  self.item_list = {}
  local tab = self.ctrl:GetTab()
  self.isChangeTab = tab ~= self.tempTab
  self.tempTab = tab
  self.usr_point_obj:SetActive(tab == 1)
  self.al_point_obj:SetActive(tab == 2)
  if tab == 1 then
    local data = self.ctrl:GetAllianceShopData()
    self.item_list = data.list
    self.usr_point_txt:SetText(data.accPoint)
    self.txt_title:SetLocalText(390168)
  elseif tab == 2 then
    local data = self.ctrl:GetAllianceBagData()
    self.item_list = data.list
    self.al_point_txt:SetText(data.alliancePoint)
    self.txt_title:SetLocalText(391097)
  end
  self:RefreshItemContent()
  if self.cells ~= nil and table.count(self.cells) > 0 and self.isChangeTab == false then
    for i = 1, table.count(self.cells) do
      if self.item_list[i] ~= nil then
        self.cells[i]:SetActive(true)
        self.cells[i]:SetItemShow(self.item_list[i])
      else
        self.cells[i]:SetActive(false)
      end
    end
    return
  end
  self:ClearScroll(self)
  if #self.item_list > 0 then
    self.ScrollView:SetTotalCount(#self.item_list)
    self.ScrollView:RefillCells()
  end
end

local function RefreshItemContent(self)
  local curItemData = self.ctrl:GetItemData(self.ctrl:GetCurrentItemId())
  if curItemData.itemId ~= nil and curItemData.itemId ~= "" then
    self.item:SetActive(true)
    self.zeroText:SetActive(false)
    self.cur_item:RefreshData(curItemData)
    self.item_name:SetText(curItemData.itemName)
    self.item_des:SetText(curItemData.des)
  else
    self.item:SetActive(false)
    self.zeroText:SetLocalText(391041)
    self.zeroText:SetActive(true)
  end
  self:SetInputValue(1)
end

local function CheckButtonState(self)
  local tab = self.ctrl:GetTab()
  self.stateData = self.ctrl:GetCurButtonState(self.inputValue)
  self.dec_btn_active:SetActive(self.stateData.canDec)
  self.dec_btn_passive:SetActive(not self.stateData.canDec)
  self.add_btn_active:SetActive(self.stateData.canAdd)
  self.add_btn_passive:SetActive(not self.stateData.canAdd)
  self.buy_btn:SetActive(tab == 2)
  self.use_btn:SetActive(tab == 1)
  if tab == 1 then
    self.single_item_count:SetText(self.stateData.needAlAcc)
    if self.stateData.canUse then
      self.single_item_count:SetColor(WhiteColor)
    else
      self.single_item_count:SetColor(RedColor)
    end
  elseif tab == 2 then
    self.alliance_item_count:SetText(self.stateData.needAlPoint)
    if self.stateData.canUse then
      self.alliance_item_count:SetColor(WhiteColor)
    else
      self.alliance_item_count:SetColor(RedColor)
    end
  end
end

local function Update(self)
  local tab = self.ctrl:GetTab()
  if tab == 1 then
    self.price_text:SetActive(false)
    return
  end
  if self.stateData.allianceNum ~= nil and self.stateData.allianceNum > -1 then
    self.price_text:SetActive(true)
    if self.stateData.allianceNum == 0 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local timeLeft = self.stateData.nextWeekTime - curTime
      local t = "00:00:00"
      if 0 < timeLeft then
        t = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
      end
      local time = Localization:GetString("391040", t)
      self.price_text:SetText(time)
    else
      local num = Localization:GetString("391039", self.stateData.allianceNum)
      self.price_text:SetText(num)
    end
    if self.stateData.allianceNum == 0 then
      CS.UIGray.SetGray(self.buy_btn.transform, true, false)
    else
      CS.UIGray.SetGray(self.buy_btn.transform, false, true)
    end
  else
    self.price_text:SetActive(false)
    CS.UIGray.SetGray(self.buy_btn.transform, false, true)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ToggleControlBorS()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemContent)
  self:AddUIListener(EventId.AllianceShopShow, self.RefreshData)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemContent)
  self:RemoveUIListener(EventId.AllianceShopShow, self.RefreshData)
end

local function OnShopItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AllianceShopCell, itemObj)
  cellItem:SetItemShow(self.item_list[index])
  self.cells[index] = cellItem
end

local function OnShopItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AllianceShopCell)
  self.cells[index] = nil
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(AllianceShopCell)
  self.cells = {}
end

local function IptOnValueChange(self, value)
  local cnt = tonumber(value)
  local changeNum = self.ctrl:OnChangeSelectNumCheck(cnt)
  self:SetInputValue(changeNum)
end

local function OnAddClick(self)
  local changeNum = self.ctrl:OnChangeSelectNumCheck(self.inputValue + 1)
  self:SetInputValue(changeNum)
end

local function OnDecClick(self)
  local changeNum = self.ctrl:OnChangeSelectNumCheck(self.inputValue - 1)
  self:SetInputValue(changeNum)
end

local function OnUseClick(self)
  self.ctrl:OnUseClick(self.inputValue, self.stateData.canUse)
end

local function OnBuyClick(self)
  self.ctrl:OnBuyClick(self.inputValue, self.stateData.canUse)
end

local function SetInputValue(self, value)
  self.inputValue = value
  self.input:SetText(self.inputValue)
  self:CheckButtonState()
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local trans = self.tempTab == 1 and self.usrPointBtnN.transform or self.alPointBtnN.transform
  local strTitle
  local strContent = self.tempTab == 1 and Localization:GetString("391085") or Localization:GetString("391086")
  local position = trans.position + Vector3.New(-50, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = strTitle
  param.content = strContent
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIAllianceShopView.OnCreate = OnCreate
UIAllianceShopView.OnDestroy = OnDestroy
UIAllianceShopView.ToggleControlBorS = ToggleControlBorS
UIAllianceShopView.OnEnable = OnEnable
UIAllianceShopView.OnDisable = OnDisable
UIAllianceShopView.OnAddListener = OnAddListener
UIAllianceShopView.OnRemoveListener = OnRemoveListener
UIAllianceShopView.RefreshData = RefreshData
UIAllianceShopView.RefreshItemContent = RefreshItemContent
UIAllianceShopView.CheckButtonState = CheckButtonState
UIAllianceShopView.OnShopItemMoveIn = OnShopItemMoveIn
UIAllianceShopView.OnShopItemMoveOut = OnShopItemMoveOut
UIAllianceShopView.ClearScroll = ClearScroll
UIAllianceShopView.IptOnValueChange = IptOnValueChange
UIAllianceShopView.OnAddClick = OnAddClick
UIAllianceShopView.OnDecClick = OnDecClick
UIAllianceShopView.OnUseClick = OnUseClick
UIAllianceShopView.OnBuyClick = OnBuyClick
UIAllianceShopView.SetInputValue = SetInputValue
UIAllianceShopView.Update = Update
UIAllianceShopView.OnClickInfoBtn = OnClickInfoBtn
return UIAllianceShopView
