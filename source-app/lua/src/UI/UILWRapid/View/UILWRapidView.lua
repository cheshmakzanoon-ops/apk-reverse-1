local UILWRapid = BaseClass("UILWRapid", UIBaseView)
local base = UIBaseView
local UIItemCell = require("UI.UISpeed.Component.UIItemCell")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local icon_path = "Bg/SliderGo/Common_bg1/BuildIcon"
local slider_path = "Bg/SliderGo/Common_bg1/Slider"
local pro_img_path = "Bg/SliderGo/Common_bg1/Slider/Fill Area/Fill"
local left_time_path = "Bg/SliderGo/Common_bg1/LeftTime"
local vfx_canFree_path = "Bg/SliderGo/Common_bg1/VFX_CanFree"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local package_path = "Bg/AdvCell"
local packageCloseBtn_path = "Bg/AdvCell/CloseBtnBg/PackageCloseBtn"
local packageNameTxt_path = "Bg/AdvCell/Common_bg1/NameText"
local packageDescTxt_path = "Bg/AdvCell/Common_bg1/DesText"
local packageBuyBtn_path = "Bg/AdvCell/Common_bg1/BuyBtn"
local packageBuyBtnTxt_path = "Bg/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
local packageImgB_path = "Bg/AdvCell/Common_bg1/packageIcon"
local resourceImgB_path = "Bg/AdvCell/Common_bg1/resourceIcon"
local packageJumpBtn_path = "Bg/AdvCell/Common_bg1/jumpBtn"
local scrollview_path = "Bg/ScrollViews"
local content_path = "Bg/ScrollViews/viewport/Content"
local bg_path = "Bg"
local ItemSpd = {
  [ItemSpdMenu.ItemSpdMenu_City] = EffectDefine.BUILD_TIME_REDUCE,
  [ItemSpdMenu.ItemSpdMenu_Science] = EffectDefine.RESEARCH_TIME_REDUCE
}
local SliderLength = 523
local MoreBtnPos = Vector3.New(360, 0, 0)
local OutTime = 600000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:Dispose()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.pro_img = self:AddComponent(UIImage, pro_img_path)
  self.left_time = self:AddComponent(UIText, left_time_path)
  self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
  self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
  self.use_count_btn_name = self:AddComponent(UIText, use_count_btn_name_path)
  self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
  self.use_max_btn_name = self:AddComponent(UIText, use_max_btn_name_path)
  self.title = self:AddComponent(UIText, "Bg/SliderGo/Title")
  self.title:SetLocalText(GameDialogDefine.RAPID_MARCH_TIME)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.use_count_btn:SetOnClick(function()
    self:MoreBtnClick()
  end)
  self.package = self:AddComponent(UIBaseContainer, package_path)
  self.packageNameTxt = self:AddComponent(UIText, packageNameTxt_path)
  self.packageDescTxt = self:AddComponent(UIText, packageDescTxt_path)
  self.packageImgB = self:AddComponent(UIImage, packageImgB_path)
  self.resourceImgB = self:AddComponent(UIImage, resourceImgB_path)
  self.packageCloseBtn = self:AddComponent(UIButton, packageCloseBtn_path)
  self.packageCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.packageBuyBtnTxt = self:AddComponent(UIText, packageBuyBtnTxt_path)
  self.packageBuyBtn = self:AddComponent(UIButton, packageBuyBtn_path)
  self.packageBuyBtn:SetOnClick(function()
    if self.packageInfo then
      self.ctrl:BuyGift(self.packageInfo)
    end
  end)
  self.packageBuyBtn:SetSafeClickMode(true)
  self.packageJumpBtn = self:AddComponent(UIButton, packageJumpBtn_path)
  self.packageJumpBtn:SetOnClick(function()
    self:OnClickJumpToPackBtn()
  end)
  self.scrollview = self:AddComponent(UIBaseContainer, scrollview_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.vfx_canFree = self:AddComponent(UIBaseContainer, vfx_canFree_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
end

local function ComponentDestroy(self)
  self.more_btn_go.transform:SetParent(self.transform)
  self.more_btn_go:SetActive(false)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.icon = nil
  self.science_icon_bg = nil
  self.slider = nil
  self.left_time = nil
  self.scroll_view = nil
  self.content = nil
  self.more_btn_go = nil
  self.more_btn = nil
  self.more_btn_name = nil
  self.use_count_btn = nil
  self.use_count_btn_name = nil
  self.use_max_btn = nil
  self.use_max_btn_name = nil
  self.packageNameTxt = nil
  self.packageDescTxt = nil
  self.packageImgB = nil
  self.resourceImgB = nil
  self.packageCloseBtn = nil
  self.packageBuyBtnTxt = nil
  self.packageBuyBtn = nil
  self.packageJumpBtn = nil
  self.bg = nil
end

local function DataDefine(self)
  self.queue = nil
  self.moreBtnGoActive = nil
  self.speedType = nil
  self.template = {}
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.buildData = nil
  self.originalEndTime = nil
  self.endTime = 0
  self.startTime = 0
  self.ScienceBgActive = nil
  self.items = {}
  self.buyItems = {}
  self.itemNum = nil
  self.laseTime = 0
  self.lastCurTime = 0
  self.lastChangeTime = 0
  self.sliderValue = nil
  self.leftText = nil
  self.useItem = {}
  self.moreBtnPosition = nil
  self.moreBtnName = nil
  self.changeGold = 0
  self.cells = {}
  self.titleText = nil
  self.isChangeRefreshGold = nil
  self.moreParent = nil
  self.cacheUsedGolloesFreeTime = 0
  self.isHeroFreeTime = false
  self.isSignHeroFreeTIme = false
  self.packageInfo = nil
  self.isUseHeroAddTime = false
  self.isCreateScroll = false
  self.listGO = {}
  self.addTime = 0
end

local function DataDestroy(self)
  self.queue = nil
  self.moreBtnGoActive = nil
  self.speedType = nil
  self.template = nil
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.buildData = nil
  self.originalEndTime = nil
  self.endTime = 0
  self.startTime = 0
  self.ScienceBgActive = nil
  self.items = nil
  self.buyItems = nil
  self.itemNum = nil
  self.laseTime = nil
  self.lastChangeTime = nil
  self.sliderValue = nil
  self.leftText = nil
  self.useItem = nil
  self.moreBtnPosition = nil
  self.moreBtnName = nil
  self.cells = nil
  self.changeGold = nil
  self.titleText = nil
  self.isChangeRefreshGold = nil
  self.moreParent = nil
  self.cacheUsedGolloesFreeTime = nil
  self.isHeroFreeTime = nil
  self.isUseHeroAddTime = nil
  self.addTime = 0
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
end

local function MoreBtnClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
  local template = self:GetItemTemplate(self.moreItemId)
  self:UseAddItem(template.id, self.moreBtnMax)
  local oneTime = 0
  local temp = string.split(template.para1, ";")
  if temp ~= nil and 1 < #temp then
    oneTime = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
    self:ReduceTime(oneTime * self.moreBtnMax)
  end
  DataCenter.ItemData:UseTool(template.id, self.moreBtnMax)
  local item = DataCenter.ItemData:GetItemById(template.id)
  if item == nil then
    self:HideMoreBtn()
    self:GetAllItems()
    local param = {}
    for i = 1, #self.buyItems do
      if template.para3 == self.buyItems[i].para3 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.stateType = UIItemCell.StateType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, template, isBuy)
        self:CellsCallBack(index, template, isBuy)
      end
      
      param.index = self.moreIndex
      param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
      self.cells[self.moreIndex]:ReInit(param)
    else
      self.content:SetItemCount(#self.items + #self.buyItems)
      self.content:ForceUpdate()
    end
  else
    self:HideMoreBtn()
    if self.cells[self.moreIndex] ~= nil then
      self.cells[self.moreIndex]:RefreshOwnCount(item.count)
    end
  end
end

local function ReInit(self)
  self.isChangeRefreshGold = true
  self.title_text:SetLocalText(100159)
  local speedType, uuid = self:GetUserData()
  self.speedType = tonumber(speedType)
  self.uuid = tonumber(uuid)
  self.needUpdate = true
  if self.speedType == ItemSpdMenu.ItemSpdMenu_Troop then
    self.buildData = nil
    self.queue = nil
    self.marchData = DataCenter.WorldMarchDataManager:GetMarch(uuid)
    if not self.marchData then
      return
    end
    self.originalEndTime = self.marchData.endTime
    self.endTime = self.marchData.endTime
    self.startTime = self.marchData.startTime
  end
  self.more_btn_go:SetActive(false)
  self:ShowCells()
end

local function ShowCells(self)
  self:GetAllItems()
  self.more_btn_go:SetActive(false)
  local count = #self.items + #self.buyItems
  self.content:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.rectTransform)
  if not self.isCreateScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:SetItemCount(count)
  self.content:ForceUpdate()
  self.isCreateScroll = true
end

local function GuidAutoScroll(self, itemId)
  if self.items then
    local index
    for i = 1, table.count(self.items) do
      if self.items[i].itemId == tostring(itemId) then
        index = i
      end
    end
    if index then
      if 3 < index then
        index = index - 2
      end
      self.content:MoveItemByIndex(index - 1, 0.3)
    end
  end
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
  if index + 1 > self.itemNum then
    param.stateType = UIItemCell.StateType.Buy
    param.template = self.buyItems[index + 1 - self.itemNum]
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  else
    param.stateType = UIItemCell.StateType.Own
    param.count = self.items[index + 1].count
    param.template = self:GetItemTemplate(self.items[index + 1].itemId)
    param.itemId = self.items[index + 1].itemId
    cellItem.gameObject.name = param.itemId
  end
  
  function param.callBack(index, template, isBuy)
    self:CellsCallBack(index, template, isBuy)
  end
  
  param.index = index + 1
  param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
  cellItem:ReInit(param)
  self.cells[index + 1] = cellItem
end

local function OnDestroyScrollItem(self, go, index)
  if self.showTimer == nil then
    self:HideMoreBtn()
  end
end

local function CellsCallBack(self, index, template, isBuy)
  if isBuy then
    self:HideMoreBtn()
    if LuaEntry.Player.gold >= template.price then
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(template.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local time = (self.endTime - curTime) * tonumber(template.para3) * 0.01
        self:ConfirmBuy(template, time)
      end)
    else
      GoToUtil.GotoPayTips(template.price)
    end
  else
    self.moreIndex = index
    local item
    if self.items[index].itemId == "GolloesFreeTime" or self.items[index].itemId == "Speedup_Consigliere" or self.items[index].itemId == "Speedup_kongzhitai" or self.items[index].itemId == "Speedup_FederalCop" then
      item = self.items[index]
    else
      for i = 1, #self.items do
        if self.items[i].itemId == template.id then
          item = self.items[i]
          break
        end
      end
    end
    if not item then
      return
    end
    self.moreItemId = item.itemId
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = (self.endTime - curTime) * tonumber(template.para3) * 0.01
    self:ConfirmUse(template.id, item, time)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
  end
end

local function ConfirmUse(self, id, item, time)
  SFSNetwork.SendMessage(MsgDefines.WorldMarchRapid, self.uuid, id, false)
  self:ReduceTime(time)
  DataCenter.ItemData:UseTool(id, 1)
  if item.count == 1 then
    self:GetAllItems()
    local param = {}
    for i = 1, #self.buyItems do
      if item.para3 == self.buyItems[i].para3 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.stateType = UIItemCell.StateType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, template, isBuy)
        self:CellsCallBack(index, template, isBuy)
      end
      
      param.index = self.moreIndex
      param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
      self.cells[self.moreIndex]:ReInit(param)
    else
      self.content:SetItemCount(#self.items + #self.buyItems)
      self.content:ForceUpdate()
    end
  end
  if self.cells[self.moreIndex] ~= nil and 1 <= item.count then
    self.cells[self.moreIndex]:RefreshOwnCount(item.count)
  end
  EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, NewQueueType.Science)
end

local function ConfirmBuy(self, template, time)
  SFSNetwork.SendMessage(MsgDefines.WorldMarchRapid, self.uuid, template.id, true)
  self:ReduceTime(time)
  LuaEntry.Player.gold = LuaEntry.Player.gold - template.price
  self.changeGold = self.changeGold + template.price
  self.isChangeRefreshGold = false
  EventManager:GetInstance():Broadcast(EventId.UpdateGold)
end

local function Update100MS(self)
  if self.endTime ~= nil then
    local curTime = 0
    if self.needUpdate then
      curTime = UITimeManager:GetInstance():GetServerTime()
    else
      curTime = self.startTime + self.addTime
    end
    if curTime >= self.endTime then
      self.endTime = 0
      self.ctrl:CloseSelf()
    else
      local changeTime = self.endTime - curTime
      local maxTime = self.endTime - self.startTime
      if 0 < changeTime then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.laseTime then
          self.laseTime = tempTimeSec
          local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
          self:SetLeftText(tempTimeValue)
          if self.isHeroFreeTime then
            local freeTime = 0
            if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
              freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
            elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
              freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
            end
            if freeTime ~= 0 then
              if changeTime <= freeTime * SecToMilSec then
                self.isSignHeroFreeTIme = true
                self:SetProBgPath(true)
                self.vfx_canFree:SetActive(true)
                for i, v in pairs(self.cells) do
                  if v:IsHeroFreeTimeCell() then
                    v:RefreshState(true)
                  end
                end
              else
                self:SetProBgPath(false)
                self.vfx_canFree:SetActive(false)
                for i, v in pairs(self.cells) do
                  if v:IsHeroFreeTimeCell() then
                    v:RefreshState(false)
                  end
                end
              end
            else
              self:SetProBgPath(false)
              self.vfx_canFree:SetActive(false)
            end
          end
        end
        if 0 < maxTime then
          local tempValue = 1 - changeTime / maxTime
          if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.lastChangeTime, maxTime, SliderLength) then
            self.lastChangeTime = changeTime
            self:SetSliderValue(tempValue)
          end
        end
      end
    end
  end
end

local function SetProBgPath(self, state)
  if self.lastState ~= state then
    if state then
      self.pro_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_pro_green"))
      self.content:MoveItemByIndex(0, 0.3)
    else
      self.pro_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_pro_yellow"))
    end
    self.lastState = state
  end
end

local function SetSliderValue(self, value)
  if self.sliderValue ~= value then
    self.sliderValue = value
    self.slider:SetValue(value)
  end
end

local function SetLeftText(self, value)
  if self.leftText ~= value then
    self.leftText = value
    self.left_time:SetText(value)
  end
end

local function GetAllItems(self)
  self.items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_108) or {}
  table.sort(self.items, self.SortItem)
  self.itemNum = #self.items
  local buyItems = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_108)
  self.buyItems = {}
  if buyItems then
    for _, v in pairs(buyItems) do
      if v.price > 0 then
        table.insert(self.buyItems, v)
      end
    end
  end
  table.sort(self.buyItems, self.SortItemTemplate)
  for i = #self.buyItems, 1, -1 do
    for k = 1, #self.items do
      if self.items[k].para1 and self.buyItems[i].para3 and self.items[k].para1 == self.buyItems[i].para3 then
        table.remove(self.buyItems, i)
      end
    end
  end
end

local function GetItemTemplate(self, id)
  local temp = self.template[id]
  if temp == nil then
    self.template[id] = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  end
  return self.template[id]
end

local function SortItem(a, b)
  local goodsTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
  local goodsTemplate2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
  if goodsTemplate1 == nil then
    return false
  elseif goodsTemplate2 == nil then
    return true
  else
    if goodsTemplate1.type2 < goodsTemplate2.type2 then
      return false
    elseif goodsTemplate1.type2 > goodsTemplate2.type2 then
      return true
    end
    if goodsTemplate1.order > goodsTemplate2.order then
      return false
    elseif goodsTemplate1.order < goodsTemplate2.order then
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

local function UseAddItem(self, itemId, count)
end

local function TryAddGolloesFreeTime(self)
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  if not isAvailable then
    return
  end
  local freeTime = DataCenter.GolloesCampManager:GetFreeSpeedTime() - self.cacheUsedGolloesFreeTime
  freeTime = freeTime < 0 and 0 or freeTime
  local virtualItem = {}
  virtualItem.itemId = "GolloesFreeTime"
  virtualItem.use = "0"
  virtualItem.count = freeTime
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

local function GetGolloesMaxFreeTime(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.endTime
  if self.isHeroFreeTime then
    local heroFreeTime = 0
    if ItemSpd[self.speedType] then
      heroFreeTime = LuaEntry.Effect:GetGameEffect(ItemSpd[self.speedType])
    end
    if self.endTime - serverTime > heroFreeTime * SecToMilSec then
      endTime = endTime - heroFreeTime * SecToMilSec
    end
  end
  local remainTimeMs = endTime - serverTime
  local golloesRemainTime = DataCenter.GolloesCampManager:GetFreeSpeedTime() - self.cacheUsedGolloesFreeTime
  local finalT = 0
  if remainTimeMs < golloesRemainTime then
    finalT = remainTimeMs
  else
    finalT = golloesRemainTime
  end
  return finalT
end

local function ReduceTime(self, time)
  if self.needUpdate then
    self.endTime = self.endTime - time
    self.startTime = self.startTime - time
  else
    self.addTime = self.addTime + time
  end
end

local function ShowMoreBtn(self)
  local moreParent = self.cells[self.moreIndex]:GetMoreBtnParent()
  if self.moreParent ~= moreParent then
    self.moreParent = moreParent
    self.more_btn_go.transform:SetParent(moreParent)
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
  if self.moreParent then
    self.moreParent = nil
    self.more_btn_go.transform:SetParent(self.transform)
    self.more_btn_go.transform:SetAsFirstSibling()
    self.more_btn_go:Play("CloseMoreBtn", 0, 0)
  end
end

local function ShowMoreBtnName(self, oneTime, item)
  if 0 < oneTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.endTime
    if self.isHeroFreeTime then
      local freeTime = 0
      if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
      elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
      end
      if freeTime ~= 0 and not self.isSignHeroFreeTIme then
        endTime = self.endTime - freeTime * SecToMilSec
      end
    end
    self.moreBtnMax = math.floor((endTime - curTime) / oneTime)
    if self.moreBtnMax > item.count then
      self.moreBtnMax = item.count
    end
    if 0 < self.moreBtnMax then
      self.use_count_btn_name:SetText("x" .. self.moreBtnMax)
    else
      self.more_btn_go:SetActive(false)
    end
  end
end

local function OnClickJumpToPackBtn(self)
  if self.packageInfo then
    GoToUtil.GotoGiftPackView(self.packageInfo)
  end
end

UILWRapid.OnCreate = OnCreate
UILWRapid.OnDestroy = OnDestroy
UILWRapid.OnEnable = OnEnable
UILWRapid.OnDisable = OnDisable
UILWRapid.ComponentDefine = ComponentDefine
UILWRapid.ComponentDestroy = ComponentDestroy
UILWRapid.DataDefine = DataDefine
UILWRapid.DataDestroy = DataDestroy
UILWRapid.OnAddListener = OnAddListener
UILWRapid.OnRemoveListener = OnRemoveListener
UILWRapid.MoreBtnClick = MoreBtnClick
UILWRapid.ClearScroll = ClearScroll
UILWRapid.ReInit = ReInit
UILWRapid.ShowCells = ShowCells
UILWRapid.GuidAutoScroll = GuidAutoScroll
UILWRapid.CellsCallBack = CellsCallBack
UILWRapid.Update100MS = Update100MS
UILWRapid.SetProBgPath = SetProBgPath
UILWRapid.SetSliderValue = SetSliderValue
UILWRapid.SetLeftText = SetLeftText
UILWRapid.GetAllItems = GetAllItems
UILWRapid.GetItemTemplate = GetItemTemplate
UILWRapid.SortItem = SortItem
UILWRapid.SortItemTemplate = SortItemTemplate
UILWRapid.UseAddItem = UseAddItem
UILWRapid.ReduceTime = ReduceTime
UILWRapid.ShowMoreBtn = ShowMoreBtn
UILWRapid.ShowMoreBtnName = ShowMoreBtnName
UILWRapid.ConfirmUse = ConfirmUse
UILWRapid.ConfirmBuy = ConfirmBuy
UILWRapid.HideMoreBtn = HideMoreBtn
UILWRapid.TryAddGolloesFreeTime = TryAddGolloesFreeTime
UILWRapid.GetGolloesMaxFreeTime = GetGolloesMaxFreeTime
UILWRapid.OnClickJumpToPackBtn = OnClickJumpToPackBtn
UILWRapid.OnInitScroll = OnInitScroll
UILWRapid.OnUpdateScroll = OnUpdateScroll
UILWRapid.OnDestroyScrollItem = OnDestroyScrollItem
return UILWRapid
