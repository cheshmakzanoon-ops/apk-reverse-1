local base = UIBaseView
local UILWOldVipPacksView = BaseClass("UILWOldVipPacksView", base)
local OldVIPLevelPackageItem = require("UI.UIVip.UILWOldVipPacks.Component.OldVIPLevelPackageItem")
local title_txt_path = "root/topbar/textTitle"
local back_btn_path = "root/contentContainer/bottomBtns/backBtn"
local time_txt_path = "root/contentContainer/top/oldVipCountDown/timeText"
local desc_txt_path = "root/contentContainer/top/descTxt"
local level_txt_path = "root/contentContainer/top/VIPBg/VIPBgLevelText"
local pack_scroll_path = "root/contentContainer/center/packsScroll"
local pack_content_path = "root/contentContainer/center/packsScroll/viewport/content"

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packs then
    return nil
  end
  local pack = self.packs[index]
  local item = loopScroll:NewListViewItem("VIPLevelPackage")
  local script = self.pack_content:GetComponent(item.gameObject.name, OldVIPLevelPackageItem)
  if script == nil then
    local objectName = GetItemNameSequence(self)
    item.gameObject.name = objectName
    script = self.pack_content:AddComponent(OldVIPLevelPackageItem, objectName)
  end
  script:SetActive(true)
  script:RefreshData(pack)
  return item
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local timeStr = LuaEntry.DataConfig:TryGetStr("vip_old_gift_config", "k2")
  if not string.IsNullOrEmpty(timeStr) then
    local timeArr = string.split(timeStr, ";")
    if 2 <= #timeArr then
      self.endTime = tonumber(timeArr[2])
    end
  end
  if not self.endTime then
    self.ctrl:CloseSelf()
  end
  self.packs = self.ctrl:GetSortedPacks()
  self:RefreshPackList()
  self:OnVipDataRefresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.level_txt = self:AddComponent(UITextMeshProUGUIEx, level_txt_path)
  self.pack_scroll = self:AddComponent(UILoopListView2, pack_scroll_path)
  self.pack_content = self:AddComponent(UIBaseContainer, pack_content_path)
  self.title_txt:SetLocalText(372235)
  self.desc_txt:SetLocalText("vip_oldgift_desc1")
  self.pack_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.back_btn = nil
  self.time_txt = nil
  self.desc_txt = nil
  self.level_txt = nil
  self.pack_scroll = nil
  self.pack_content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnOpen(self)
end

local function Update1000MS(self)
  if self.endTime then
    local time = self.endTime - UITimeManager:GetInstance():GetServerTime()
    if time <= 0 then
      self.ctrl:CloseSelf()
    else
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
    end
  end
end

local function RefreshPackList(self)
  if self.packs and #self.packs > 0 then
    self.pack_scroll:SetActive(true)
    self.pack_scroll:SetListItemCount(#self.packs, false, false)
    self.pack_scroll:RefreshAllShownItem()
  else
    self.pack_scroll:SetActive(false)
  end
end

local function RefreshVipLevel(self)
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData then
    self.level_txt:SetText(string.format("VIP %d", vipData.level))
  else
    self.level_txt:SetText(0)
  end
end

local function OnVipDataRefresh(self)
  self:RefreshVipLevel()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshPackList)
  self:AddUIListener(EventId.VipDataRefresh, self.OnVipDataRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshPackList)
  self:RemoveUIListener(EventId.VipDataRefresh, self.OnVipDataRefresh)
end

UILWOldVipPacksView.OnCreate = OnCreate
UILWOldVipPacksView.OnDestroy = OnDestroy
UILWOldVipPacksView.OnEnable = OnEnable
UILWOldVipPacksView.OnDisable = OnDisable
UILWOldVipPacksView.ComponentDefine = ComponentDefine
UILWOldVipPacksView.ComponentDestroy = ComponentDestroy
UILWOldVipPacksView.DataDefine = DataDefine
UILWOldVipPacksView.DataDestroy = DataDestroy
UILWOldVipPacksView.OnOpen = OnOpen
UILWOldVipPacksView.Update1000MS = Update1000MS
UILWOldVipPacksView.RefreshPackList = RefreshPackList
UILWOldVipPacksView.RefreshVipLevel = RefreshVipLevel
UILWOldVipPacksView.OnVipDataRefresh = OnVipDataRefresh
UILWOldVipPacksView.OnAddListener = OnAddListener
UILWOldVipPacksView.OnRemoveListener = OnRemoveListener
return UILWOldVipPacksView
