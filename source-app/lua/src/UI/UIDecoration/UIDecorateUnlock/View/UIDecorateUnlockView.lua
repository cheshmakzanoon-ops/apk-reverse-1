local UIDecorateUnlockView = BaseClass("UIDecorateUnlockView", UIBaseView)
local UIDecorateUnlockItem = require("UI.UIDecoration.UIDecorateUnlock.Component.UIDecorateUnlockItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_path = "UICommonPopUpTitle/panel"
local scroll_view = "Rect_Content/layout/ScrollViewLayout/Bg/ScrollView"
local empty_text_path = "Rect_Content/layout/ScrollViewLayout/Bg/EmptyText"
local icon_path = "Rect_Content/decoration_info/decorationIcon"
local name_path = "Rect_Content/decoration_info/decorationName"
local time_layout_path = "Rect_Content/layout/TimeLayout"
local time_title_path = "Rect_Content/layout/TimeLayout/decorationTxt"
local time_path = "Rect_Content/layout/TimeLayout/decorationTime"
local item_title_text_path = "Rect_Content/layout/ScrollViewLayout/ItemTitle/ItemTitleText"
local raw_decoration_icon_path = "Rect_Content/decoration_info/raw_decorationIcon"
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local ShowType = {Decoration = 1, Colour = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._title_txt = self:AddComponent(UIText, titleTxt_path)
  self._title_txt:SetLocalText(2000474)
  self._close_btn = self:AddComponent(UIButton, closeBtn_path)
  self._return_btn = self:AddComponent(UIButton, return_path)
  self.item_title_text = self:AddComponent(UIText, item_title_text_path)
  self.item_title_text:SetLocalText(2000475)
  self._close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.empty_text:SetLocalText(2000496)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.time_layout = self:AddComponent(UIBaseContainer, time_layout_path)
  self.time_title = self:AddComponent(UIText, time_title_path)
  self.time_title:SetLocalText(300648)
  self.time = self:AddComponent(UIText, time_path)
  
  function self.timer_action(temp)
    self:RefreshRemainTime()
  end
  
  self.raw_decoration_icon = self:AddComponent(UIDecorationMainCity, raw_decoration_icon_path)
  self:AddTimer()
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:DeleteTimer()
  self._title_txt = nil
  self._close_btn = nil
  self.item_title_text = nil
  self.scroll_view = nil
  self.empty_text = nil
  self.icon = nil
  self.name = nil
  self.time_layout = nil
  self.time_title = nil
  self.time = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetPanelData(self)
  if self.showType == ShowType.Decoration then
    return self.ctrl:GetPanelData(self.id)
  elseif self.showType == ShowType.Colour then
    return self.ctrl:GetColourData(self.id)
  end
end

local function GetData(self)
  if self.showType == ShowType.Decoration then
    return DataCenter.DecorationDataManager:GetSkinDataById(self.id)
  else
    return DataCenter.ItemSkinDataManager:GetItemSkinDataById(self.id)
  end
end

local function RefreshIcon(self, data)
  self.icon:SetActive(self.showType == ShowType.Decoration)
  self.raw_decoration_icon:SetActive(self.showType == ShowType.Colour)
  if self.showType == ShowType.Decoration then
    self.icon:LoadSpriteAsyncWithCallback(data.img, function()
      local sprite = self.icon:GetImage()
      if not IsNull(sprite) then
        local size = sprite.rect.size
        local x = 200
        local y = x * size.y / size.x
        self.icon.rectTransform.sizeDelta = Vector2.New(x, y)
      end
    end)
  else
    local decorationId = GetTableData(TableName.DecorationDazzle, tonumber(self.id), "decoration_id")
    local template = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateById(decorationId, self.id)
    self.raw_decoration_icon:SetRTLen(256)
    self.raw_decoration_icon:SetFov(template.get_fov or 15)
    self.raw_decoration_icon:ReInit({
      decorationId = template.decoration_id,
      posIndex = 1,
      colourId = self.id,
      cameraY = template.get_cameraY or 16.6
    })
  end
end

local function ReInit(self)
  self.id, self.showType = self:GetUserData()
  self.showType = self.showType or ShowType.Decoration
  local data = self:GetPanelData()
  self:RefreshIcon(data)
  self.dataList = data.list
  self.endTime = data.time
  self.name:SetLocalText(data.name)
  if not table.IsNullOrEmpty(self.dataList) then
    self.scroll_view:SetActive(true)
    self.empty_text:SetActive(false)
    self:ClearScroll()
    self.scroll_view:SetTotalCount(#self.dataList)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
    self.empty_text:SetActive(true)
  end
  local data = self:GetData()
  self.time_layout:SetActive(data ~= nil and data:IsInExpireTime())
  self:RefreshRemainTime()
end

local function OnUserSkinUpdate(self)
  self:ReInit()
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIDecorateUnlockItem, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.id)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDecorateUnlockItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDecorateUnlockItem)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshRemainTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local data = self:GetData()
  if data ~= nil and data:IsInExpireTime() then
    local restTime = data.expireTime - now
    restTime = math.max(0, restTime)
    local restTimeStr = Localization:GetString("302217", UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
    if data.expireTime <= 0 then
      restTimeStr = Localization:GetString("280098")
    end
    self.time:SetText(restTimeStr)
  else
    self.time:SetText("")
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
  self:AddUIListener(EventId.UpdateItemSkinData, self.OnUserSkinUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
  self:RemoveUIListener(EventId.UpdateItemSkinData, self.OnUserSkinUpdate)
end

UIDecorateUnlockView.OnAddListener = OnAddListener
UIDecorateUnlockView.OnRemoveListener = OnRemoveListener
UIDecorateUnlockView.OnCreate = OnCreate
UIDecorateUnlockView.OnDestroy = OnDestroy
UIDecorateUnlockView.OnEnable = OnEnable
UIDecorateUnlockView.OnDisable = OnDisable
UIDecorateUnlockView.ComponentDefine = ComponentDefine
UIDecorateUnlockView.ComponentDestroy = ComponentDestroy
UIDecorateUnlockView.DataDefine = DataDefine
UIDecorateUnlockView.DataDestroy = DataDestroy
UIDecorateUnlockView.ReInit = ReInit
UIDecorateUnlockView.GetData = GetData
UIDecorateUnlockView.GetPanelData = GetPanelData
UIDecorateUnlockView.OnCreateCell = OnCreateCell
UIDecorateUnlockView.OnDeleteCell = OnDeleteCell
UIDecorateUnlockView.ClearScroll = ClearScroll
UIDecorateUnlockView.DeleteTimer = DeleteTimer
UIDecorateUnlockView.AddTimer = AddTimer
UIDecorateUnlockView.RefreshIcon = RefreshIcon
UIDecorateUnlockView.RefreshRemainTime = RefreshRemainTime
UIDecorateUnlockView.OnUserSkinUpdate = OnUserSkinUpdate
return UIDecorateUnlockView
