local UIItemCell = require("UI.UIResourceBag.Component.UIItemCell")
local UITabCell = require("UI.UIResourceBag.Component.UITabCell")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIResourceBagView = BaseClass("UIMainPlayerReportTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local slider_go_path = "Bg/SliderGo"
local slider_path = "Bg/SliderGo/Common_bg1/Slider"
local slider_txt_path = "Bg/SliderGo/Common_bg1/LeftTime"
local slider_icon_path = "Bg/SliderGo/Common_bg1/BuildIcon"
local slider_image_path = "Bg/SliderGo/Common_bg1/Slider/Fill Area/Fill"
local tab_content_path = "TabContent"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local layout_path = "Bg"
local packageCell_path = "Bg/AdvCell"
local packageNameTxt_path = "Bg/AdvCell/Common_bg1/NameText"
local packageImgB_path = "Bg/AdvCell/Common_bg1/packageIcon"
local resourceImgB_path = "Bg/AdvCell/Common_bg1/resourceIcon"
local packageDescTxt_path = "Bg/AdvCell/Common_bg1/DesTextBg/DesText"
local packageBuyBtn_path = "Bg/AdvCell/Common_bg1/BuyBtn"
local packageBuyBtnTxt_path = "Bg/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
local packageCloseBtn_path = "Bg/AdvCell/CloseBtnBg/PackageCloseBtn"
local packageJumpBtn_path = "Bg/AdvCell/Common_bg1/jumpBtn"
local noItemTips_path = "NoItemTips"
local SliderMaxImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_pro_green"
local SliderNormalImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_pro_yellow"
local scroll_view_path = "Bg/ScrollView"
local content_path = "Bg/ScrollView/Content"
local point_path = "Bg/AdvCell/Common_bg1/BuyBtn/UIGiftPackagePoint"
local StateType = {Use = 0, Lack = 1}
local MaxFlyNum = 3
local UseResourceList = {
  ResourceType.Electricity,
  ResourceType.Food
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIResourceBag)
  self:ClearScroll()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:Dispose()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.tab_content = self:AddComponent(UIBaseContainer, tab_content_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
  self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
  self.use_count_btn_name = self:AddComponent(UIText, use_count_btn_name_path)
  self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
  self.use_max_btn_name = self:AddComponent(UIText, use_max_btn_name_path)
  self.slider_go = self:AddComponent(UIBaseContainer, slider_go_path)
  self.slider_image = self:AddComponent(UIImage, slider_image_path)
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, layout_path)
  self.noItemTips = self:AddComponent(UIText, noItemTips_path)
  self.packageCell = self:AddComponent(UIBaseContainer, packageCell_path)
  self.packageNameTxt = self:AddComponent(UIText, packageNameTxt_path)
  self.packageImgB = self:AddComponent(UIImage, packageImgB_path)
  self.resourceImgB = self:AddComponent(UIImage, resourceImgB_path)
  self.packageDescTxt = self:AddComponent(UIText, packageDescTxt_path)
  self.packageBuyBtn = self:AddComponent(UIButton, packageBuyBtn_path)
  self.packageBuyBtn:SetOnClick(function()
    if self.packageInfo then
      self.ctrl:BuyGift(self.packageInfo)
    end
  end)
  self.packageBuyBtnTxt = self:AddComponent(UIText, packageBuyBtnTxt_path)
  self.packageCloseBtn = self:AddComponent(UIButton, packageCloseBtn_path)
  self.packageCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.packageJumpBtn = self:AddComponent(UIButton, packageJumpBtn_path)
  self.packageJumpBtn:SetOnClick(function()
    self:OnClickJumpToPackBtn()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.use_count_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:UseBtnClick()
  end)
  self.scrollview = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
end

local function ComponentDestroy(self)
  self.more_btn_go.transform:SetParent(self.transform)
  self.more_btn_go:SetActive(false)
  self.txt_title = nil
  self.tab_content = nil
  self.close_btn = nil
  self.return_btn = nil
  self.slider = nil
  self.slider_icon = nil
  self.slider_txt = nil
  self.more_btn_go = nil
  self.use_count_btn = nil
  self.use_count_btn_name = nil
  self.use_max_btn = nil
  self.use_max_btn_name = nil
  self.scroll_view = nil
  self.noItemTips = nil
  self.slider_go = nil
  self.slider_image = nil
  self.layout = nil
  self.point_rect = nil
end

local function DataDefine(self)
  self.stateType = nil
  self.tabCells = {}
  self.freeTabCells = {}
  self.allResourceTab = {}
  self.template = {}
  self.buyItems = {}
  self.items = {}
  self.cells = {}
  self.resourceType = nil
  self.lackResource = {}
  self.itemNum = 0
  self.moreBtnGoActive = nil
  self.moreBtnMax = nil
  self.moreBtnName = nil
  self.moreBtnParent = nil
  self.gotoBtnName = nil
  self.gotoBtnDes = nil
  self.gotoBtnGoActive = nil
  self.sliderGoActive = nil
  self.storageGoActive = nil
  self.storageNum = nil
  self.storageMaxNum = nil
  self.storageDes = nil
  self.moreItemId = ""
  self.refreshAllCell = true
  self.lackreslist = {}
  self.curSelectItem = nil
end

local function DataDestroy(self)
  self.stateType = nil
  self.tabCells = nil
  self.freeTabCells = nil
  self.allResourceTab = nil
  self.template = nil
  self.buyItems = nil
  self.items = nil
  self.cells = nil
  self.resourceType = nil
  self.lackResource = nil
  self.itemNum = nil
  self.moreBtnGoActive = nil
  self.moreBtnMax = nil
  self.moreBtnName = nil
  self.moreBtnParent = nil
  self.gotoBtnName = nil
  self.gotoBtnDes = nil
  self.gotoBtnGoActive = nil
  self.sliderGoActive = nil
  self.storageGoActive = nil
  self.storageNum = nil
  self.storageMaxNum = nil
  self.storageDes = nil
  self.moreItemId = nil
  self.refreshAllCell = nil
  self.lackreslist = nil
  self.curSelectItem = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.resourceType, self.lackResource, self.isShowOther = self:GetUserData()
  if self.lackResource and table.count(self.lackResource) == 1 then
    self.tab_content:SetActive(false)
  else
    self.tab_content:SetActive(true)
  end
  self.isShowOther = self.isShowOther or false
  self.more_btn_go:SetActive(false)
  self:SetStateType()
  if self.stateType == StateType.Use then
    self.txt_title:SetLocalText(100024)
    local signal = {
      ResourceType.Electricity,
      ResourceType.Food
    }
    local param = {}
    param.list = signal
    param.uiName = UIWindowNames.UIResourceBag
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  elseif self.stateType == StateType.Lack then
    self.txt_title:SetLocalText(130255)
    local signal = {}
    if self.lackResource ~= nil then
      for k, v in pairs(self.lackResource) do
        table.insert(signal, k)
      end
    end
    local param = {}
    param.list = signal
    param.uiName = UIWindowNames.UIResourceBag
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  end
  self.listGO = {}
  self.isCreateScroll = false
  self:SetAllResourceTab()
  self:ShowTabCells()
  self:UpdateSlider()
  self:ShowCells()
  self:TryShowPackage()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateSlider)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.BuildDataUpgradeSignal)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateSlider)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.BuildDataUpgradeSignal)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function UpdateSlider(self)
  if self.stateType == StateType.Lack then
    self.slider_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.resourceType))
    if self.stateType == StateType.Use then
      local currentCount = LuaEntry.Resource:GetCntByResType(self.resourceType)
      if self.resourceType == ResourceType.Food then
        self.slider_go:SetActive(false)
      else
        self.slider_go:SetActive(true)
        self.slider:SetActive(false)
        self.slider_txt:SetText(string.GetFormattedSeperatorNum(currentCount))
      end
    elseif self.stateType == StateType.Lack then
      self.slider_go:SetActive(true)
      local needCount = self.lackResource[self.resourceType]
      local currentCount = LuaEntry.Resource:GetCntByResType(self.resourceType)
      local percent = currentCount / needCount
      if 1 <= percent then
        self.slider_image:LoadSprite(SliderMaxImage)
      else
        self.slider_image:LoadSprite(SliderNormalImage)
      end
      self.slider:SetValue(percent)
      self.slider_txt:SetText(string.GetFormattedSeperatorNum(currentCount) .. "/" .. string.GetFormattedSeperatorNum(needCount))
    end
  else
    self.slider_go:SetActive(false)
  end
end

local function ShowTabCells(self)
  for k, v in pairs(self.tabCells) do
    v:SetActive(false)
    table.insert(self.freeTabCells, v)
  end
  self.tabCells = {}
  for k, v in ipairs(self.allResourceTab) do
    self:AddOneTabCells(v)
  end
end

local function AddOneTabCells(self, tab)
  local param = UITabCell.Param.New()
  param.resourceType = tab
  
  function param.callBack(t)
    self:TabCallBack(t)
  end
  
  param.isSelect = tab == self.resourceType
  if #self.freeTabCells > 0 then
    local temp = table.remove(self.freeTabCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.tab_content.transform)
      temp.transform:SetAsLastSibling()
      self.tabCells[tab] = temp
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.UIResourceBagTab, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.tab_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.tabCells[tab] = self.tab_content:AddComponent(UITabCell, nameStr)
      self.tabCells[tab]:ReInit(param)
    end)
  end
end

local function TabCallBack(self, tab)
  self.more_btn_go:SetActive(false)
  if self.resourceType ~= tab then
    self:SetTabCellsSelect(self.resourceType, false)
    self:SetTabCellsSelect(tab, true)
    self.resourceType = tab
    self:UpdateSlider()
    self:ShowCells()
    self:TryShowPackage()
  end
end

local function OnBuyPackageSucc(self)
  self:ShowCells()
  self:TryShowPackage()
end

local function TryShowPackage(self)
  self.packageInfo = self.ctrl:GetQuickPackageInfo(self.resourceType)
  if self.packageInfo then
    self.packageCell:SetActive(true)
    self.packageNameTxt:SetLocalText(self.packageInfo:getName())
    local packageIcon = self.packageInfo:getPopupImageB()
    if packageIcon == "" then
      self.packageImgB:SetActive(true)
      self.resourceImgB:SetActive(false)
    else
      local iconPath = string.format("Assets/Main/Sprites/Resource/UIResource_Banner_band_%s.png", packageIcon)
      self.resourceImgB:LoadSprite(iconPath)
      self.packageImgB:SetActive(false)
      self.resourceImgB:SetActive(true)
    end
    self.packageDescTxt:SetText(self.packageInfo:getDescText())
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.packageBuyBtnTxt:SetText(price)
    self.point_rect:RefreshPoint(self.packageInfo)
  else
    self.packageCell:SetActive(false)
  end
end

local function ShowCells(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
  if self.stateType == StateType.Lack and not self.isShowOther then
    self:GetLackResList()
  end
  self:GetAllItems()
  self.more_btn_go:SetActive(false)
  local count = #self.items + #self.buyItems + table.count(self.lackreslist)
  if 0 < count then
    self.content:SetActive(true)
    if not self.isCreateScroll then
      local bindFunc1 = BindCallback(self, self.OnInitScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
      self.content:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.content:SetAnchoredPosition(Vector2.New(0, 0))
    self.isCreateScroll = true
    self.content:SetItemCount(count)
    self.content:ForceUpdate()
  else
    self.content:SetActive(false)
  end
  self.noItemTips:SetActive(count < 1)
  self.noItemTips:SetLocalText(110181)
end

local function ClearScroll(self)
  self.scrollview:RemoveComponents(UIItemCell)
  self.content:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.scrollview:AddComponent(UIItemCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local param = UIItemCell.Param.New()
  local extraNums = table.count(self.lackreslist)
  if index + 1 > self.itemNum + extraNums then
    param.btnType = UIResourceBagBtnType.Buy
    param.template = self.buyItems[index + 1 - self.itemNum - extraNums]
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  elseif extraNums < index + 1 then
    param.itemId = self.items[index + 1 - extraNums].itemId
    param.btnType = UIResourceBagBtnType.Use
    param.count = self.items[index + 1 - extraNums].count
    if param.itemId ~= "GolloesExplorer" then
      param.template = self:GetItemTemplate(self.items[index + 1 - extraNums].itemId)
    end
  elseif self.stateType == StateType.Lack and not self.isShowOther and next(self.lackreslist) then
    param.btnType = self.lackreslist[index + 1].btnType
    param.template = self.lackreslist[index + 1].template
  end
  
  function param.callBack(index, template, pos, isBuy)
    self:CellsCallBack(index, template, pos, isBuy)
  end
  
  param.index = index + 1
  if not param.btnType then
    return
  end
  cellItem:ReInit(param)
  self.cells[index + 1] = cellItem
end

local function OnDestroyScrollItem(self, go, index)
  if self.showTimer == nil then
    self:HideMoreBtn()
  end
end

local function GetLackResList(self)
  self.lackreslist = {}
  local resType = self.resourceType
  local needCount = self.lackResource[self.resourceType]
  local reslist = DataCenter.ResLackManager:CheckResAddWay(resType, needCount)
  for _, resItem in pairs(reslist) do
    if resItem:GetTips() ~= 11 and resItem:GetTips() ~= 12 then
      local param = {}
      param.btnType = UIResourceBagBtnType.LackResMode
      param.template = resItem
      self.lackreslist[#self.lackreslist + 1] = param
    end
  end
  if DataCenter.BuildManager.MainLv > 10 then
    local MaxShow = LuaEntry.DataConfig:TryGetNum("res_lack", "k3")
    if MaxShow == 0 then
      self.lackreslist = {}
    elseif MaxShow < table.count(self.lackreslist) then
      for i = table.count(self.lackreslist), MaxShow + 1, -1 do
        table.remove(self.lackreslist, i)
      end
    end
  end
end

local function SetTabCellsSelect(self, tab, value)
  local temp = self.tabCells[tab]
  if temp ~= nil then
    temp:SetSelect(value)
  end
end

local function ShowMoreBtnName(self, oneCount, item)
  if 0 < oneCount then
    local leftCount = self:GetCurLeftResourceCnt()
    if 0 < leftCount then
      self.moreBtnMax = math.floor((leftCount - oneCount) / oneCount)
      if self.moreBtnMax > item.count then
        self.moreBtnMax = item.count
      end
    elseif self.resourceType == ResourceType.Food then
      self.moreBtnMax = item.count
    else
      self.moreBtnMax = 0
    end
    if 0 < self.moreBtnMax then
      self:SetMoreBtnName("x" .. self.moreBtnMax)
    else
      self.more_btn_go:SetActive(false)
    end
  end
end

local function SetAllResourceTab(self)
  if self.stateType == StateType.Lack then
    if self.lackResource ~= nil then
      for k, v in pairs(self.lackResource) do
        table.insert(self.allResourceTab, k)
      end
    end
  elseif self.stateType == StateType.Use then
    self.allResourceTab = UseResourceList
  end
end

local function SetStateType(self)
  if self.lackResource ~= nil then
    self.stateType = StateType.Lack
  else
    self.stateType = StateType.Use
  end
end

local function GetCurLeftResourceCnt(self)
  local count = 0
  if self.stateType == StateType.Lack then
    local original = self.lackResource[self.resourceType]
    if original ~= nil then
      count = original - LuaEntry.Resource:GetCntByResType(self.resourceType)
    end
  elseif self.stateType == StateType.Use then
    count = 1
  end
  return count
end

local function SetMoreBtnName(self, value)
  if self.moreBtnName ~= value then
    self.moreBtnName = value
    self.use_count_btn_name:SetText(value)
  end
end

local function ShowMoreBtn(self)
  local moreBtnParent = self.cells[self.moreIndex]:GetMoreBtnParent()
  if self.moreBtnParent ~= moreBtnParent then
    self.moreBtnParent = moreBtnParent
    self.more_btn_go.transform:SetParent(moreBtnParent)
    self.more_btn_go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local ret, time = self.more_btn_go:PlayAnimationReturnTime("ShowMoreBtn")
    if ret then
      self.showTimer = TimerManager:GetInstance():GetTimer(time + 0.5, function()
        if self.showTimer ~= nil then
          self.showTimer:Stop()
          self.showTimer = nil
        end
      end, self, true, false, false)
      self.showTimer:Start()
    end
  end
end

local function HideMoreBtn(self)
  if self.moreBtnParent then
    self.more_btn_go.transform:SetParent(self.transform)
    self.more_btn_go.transform:SetAsFirstSibling()
    self.moreBtnParent = nil
    self.more_btn_go:Play("CloseMoreBtn", 0, 0)
  end
end

local function GetAllItems(self)
  self.buyItems, self.items = DataCenter.ItemData:GetResourceItem(self.resourceType)
  table.sort(self.items, self.SortItem)
  if self.resourceType == ResourceType.Food then
    self:TryAddGolloesExplorer()
  end
  self.itemNum = #self.items
  table.sort(self.buyItems, self.SortItemTemplate)
  for i = #self.buyItems, 1, -1 do
    for k = 1, #self.items do
      if self.items[k].para2 and self.buyItems[i] and self.buyItems[i].para2 == self.items[k].para2 then
        table.remove(self.buyItems, i)
      end
    end
  end
end

local function TryAddGolloesExplorer(self)
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  if not isAvailable then
    return
  end
  local virtualItem = {}
  virtualItem.itemId = "GolloesExplorer"
  virtualItem.use = "0"
  virtualItem.count = 0
  virtualItem.para1 = 7
  virtualItem.para2 = 1
  virtualItem.para3 = 60
  virtualItem.para4 = ""
  virtualItem.uuid = ""
  virtualItem.cbitem = ""
  virtualItem.cbpart = ""
  virtualItem.cbnum = ""
  virtualItem.rightseffect = ""
  table.insert(self.items, 1, virtualItem)
end

local function GetItemTemplate(self, id)
  local temp = self.template[id]
  if temp == nil then
    self.template[id] = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  end
  return self.template[id]
end

local function SortItem(a, b)
  local army1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
  local army2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
  if army1 == nil then
    return false
  elseif army2 == nil then
    return true
  elseif army1.order > army2.order then
    return false
  elseif army1.order < army2.order then
    return true
  else
    local id1 = tonumber(a.itemId)
    local id2 = tonumber(b.itemId)
    if id1 > id2 then
      return true
    elseif id1 < id2 then
      return false
    end
  end
  return false
end

local function SortItemTemplate(a, b)
  if a == nil then
    return false
  elseif b == nil then
    return true
  elseif a.order > b.order then
    return false
  elseif a.order < b.order then
    return true
  else
    local id1 = tonumber(a.id)
    local id2 = tonumber(b.id)
    if id1 > id2 then
      return true
    elseif id1 < id2 then
      return false
    end
  end
  return false
end

local function CellsCallBack(self, index, template, pos, isBuy)
  local extraAddResCnt = table.count(self.lackreslist)
  if isBuy then
    self:HideMoreBtn()
    local template = self.buyItems[index - self.itemNum - extraAddResCnt]
    if LuaEntry.Player.gold >= template.price then
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(template.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        if template.para ~= nil and template.para ~= "" then
          self:ConfirmBuy(template, 1, pos)
        else
          self:ConfirmBuy(template, 1, pos)
        end
      end)
    else
      GoToUtil.GotoPayTips(template.price)
    end
  elseif index > extraAddResCnt then
    self.moreIndex = index
    local item
    for i = 1, #self.items do
      if self.items[i].itemId == template.id then
        item = self.items[i]
        break
      end
    end
    if not item then
      return
    end
    self.moreItemId = item.itemId
    if template.para ~= nil and template.para ~= "" then
      local resourceCount = tonumber(template.para)
      self:ConfirmUse(template.id, item, resourceCount, template, pos)
    else
      self:ConfirmUse(template.id, item, 1, template, pos)
    end
  elseif self.stateType == StateType.Lack then
    local param = self.lackreslist[index]
    if param ~= nil and param.template ~= nil then
      param.template:TodoAction()
    end
    return
  end
end

local function ConfirmUse(self, id, item, count, template, pos)
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = item.uuid,
    num = 1
  })
  local rewardType = ResTypeToReward[template.type2]
  local pic = RewardUtil.GetPic(rewardType, id)
  UIUtil.DoFly(rewardType, MaxFlyNum, pic, pos, Vector3.New(0, 0, 0))
  self.curSelectItem = nil
  item.count = item.count - 1
  if 1 <= item.count then
    self.refreshAllCell = false
    if self.stateType == StateType.Lack then
      self.more_btn_go:SetActive(true)
      self:ShowMoreBtn()
      self:ShowMoreBtnName(count, item)
      self.curSelectItem = item
    end
    if self.cells[self.moreIndex] ~= nil then
      self.cells[self.moreIndex]:RefreshOwnCount(item.count)
    end
  else
    self:GetAllItems()
    local lenth = #self.items + #self.buyItems + table.count(self.lackreslist)
    local param = {}
    for i = 1, #self.buyItems do
      if item.para2 == self.buyItems[i].para2 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.btnType = UIResourceBagBtnType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, pos, isBuy)
        self:CellsCallBack(index, pos, isBuy)
      end
      
      param.index = self.moreIndex
      self.cells[self.moreIndex]:ReInit(param)
    else
      self.content:SetItemCount(lenth)
      self.content:ForceUpdate()
    end
    self.refreshAllCell = true
    self.more_btn_go:SetActive(false)
  end
  self:UpdateSlider()
end

local function ConfirmBuy(self, template, count, pos)
  SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, {
    itemId = template.id,
    num = count
  })
  local showCount = count > MaxFlyNum and MaxFlyNum or count
  local rewardType = ResTypeToReward[template.type2]
  local pic = RewardUtil.GetPic(rewardType, template.id)
  UIUtil.DoFly(rewardType, showCount, pic, pos, Vector3.New(0, 0, 0))
  self.more_btn_go:SetActive(false)
  self:UpdateSlider()
end

local function UseBtnClick(self)
  local extraNums = table.count(self.lackreslist)
  local item
  if self.curSelectItem then
    item = self.curSelectItem
  else
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = item.uuid,
    num = self.moreBtnMax
  })
  item.count = item.count - self.moreBtnMax
  if self.cells[self.moreIndex] ~= nil then
    self.cells[self.moreIndex]:RefreshOwnCount(item.count)
  end
  if item.count > 1 then
    self.refreshAllCell = false
    self:HideMoreBtn()
  else
    self:GetAllItems()
    local lenth = #self.items + #self.buyItems + table.count(self.lackreslist)
    local param = {}
    for i = 1, #self.buyItems do
      if item.para2 == self.buyItems[i].para2 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.btnType = UIResourceBagBtnType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, pos, isBuy)
        self:CellsCallBack(index, pos, isBuy)
      end
      
      param.index = self.moreIndex
      self.cells[self.moreIndex]:ReInit(param)
    else
      self.content:SetItemCount(lenth)
      self.content:ForceUpdate()
    end
    self.refreshAllCell = true
    self.more_btn_go:SetActive(false)
  end
  self:UpdateSlider()
end

local function RefreshGold(self)
  local gold = LuaEntry.Player.gold
  for k, v in pairs(self.cells) do
    v:RefreshColor(gold)
  end
end

local function RefreshItemSignal(self)
end

local function BuildDataUpgradeSignal(self, data)
  self:ShowCells()
end

local function OnClickJumpToPackBtn(self)
  if self.packageInfo then
    GoToUtil.GotoGiftPackView(self.packageInfo)
  end
end

UIResourceBagView.OnCreate = OnCreate
UIResourceBagView.OnDestroy = OnDestroy
UIResourceBagView.OnEnable = OnEnable
UIResourceBagView.OnDisable = OnDisable
UIResourceBagView.OnResourceItemMoveIn = OnResourceItemMoveIn
UIResourceBagView.OnResourceItemMoveOut = OnResourceItemMoveOut
UIResourceBagView.ClearScroll = ClearScroll
UIResourceBagView.OnAddListener = OnAddListener
UIResourceBagView.OnRemoveListener = OnRemoveListener
UIResourceBagView.UpdateSlider = UpdateSlider
UIResourceBagView.ShowTabCells = ShowTabCells
UIResourceBagView.AddOneTabCells = AddOneTabCells
UIResourceBagView.TabCallBack = TabCallBack
UIResourceBagView.ComponentDefine = ComponentDefine
UIResourceBagView.ComponentDestroy = ComponentDestroy
UIResourceBagView.DataDefine = DataDefine
UIResourceBagView.DataDestroy = DataDestroy
UIResourceBagView.ReInit = ReInit
UIResourceBagView.ShowCells = ShowCells
UIResourceBagView.SetTabCellsSelect = SetTabCellsSelect
UIResourceBagView.ShowMoreBtnName = ShowMoreBtnName
UIResourceBagView.SetAllResourceTab = SetAllResourceTab
UIResourceBagView.SetStateType = SetStateType
UIResourceBagView.GetCurLeftResourceCnt = GetCurLeftResourceCnt
UIResourceBagView.SetMoreBtnName = SetMoreBtnName
UIResourceBagView.ShowMoreBtn = ShowMoreBtn
UIResourceBagView.HideMoreBtn = HideMoreBtn
UIResourceBagView.GetAllItems = GetAllItems
UIResourceBagView.TryAddGolloesExplorer = TryAddGolloesExplorer
UIResourceBagView.GetItemTemplate = GetItemTemplate
UIResourceBagView.SortItem = SortItem
UIResourceBagView.SortItemTemplate = SortItemTemplate
UIResourceBagView.CellsCallBack = CellsCallBack
UIResourceBagView.ConfirmUse = ConfirmUse
UIResourceBagView.ConfirmBuy = ConfirmBuy
UIResourceBagView.UseBtnClick = UseBtnClick
UIResourceBagView.RefreshGold = RefreshGold
UIResourceBagView.RefreshItemSignal = RefreshItemSignal
UIResourceBagView.BuildDataUpgradeSignal = BuildDataUpgradeSignal
UIResourceBagView.GetLackResList = GetLackResList
UIResourceBagView.TryShowPackage = TryShowPackage
UIResourceBagView.OnBuyPackageSucc = OnBuyPackageSucc
UIResourceBagView.OnClickJumpToPackBtn = OnClickJumpToPackBtn
UIResourceBagView.OnInitScroll = OnInitScroll
UIResourceBagView.OnUpdateScroll = OnUpdateScroll
UIResourceBagView.OnDestroyScrollItem = OnDestroyScrollItem
return UIResourceBagView
