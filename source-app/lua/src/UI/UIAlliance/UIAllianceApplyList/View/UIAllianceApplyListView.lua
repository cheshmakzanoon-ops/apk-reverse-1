local AllianceApplyItem = require("UI.UIAlliance.UIAllianceApplyList.Component.AllianceApplyItem")
local UIAllianceApplyListView = BaseClass("UIAllianceApplyListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local player_name_txt_path = "ImgBg/select/playerName"
local scroll_path = "ImgBg/ScrollView"
local empty_txt_path = "ImgBg/TxtEmpty"
local power_txt_path = "ImgBg/select/power"
local kill_txt_path = "ImgBg/select/kill"
local check_txt_path = "ImgBg/select/check"

local function OnCreate(self)
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.AlApplyList, 1)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390834)
  self.player_name_txt = self:AddComponent(UIText, player_name_txt_path)
  self.player_name_txt:SetLocalText(100184)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.empty_txt:SetLocalText(390154)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.power_txt:SetLocalText(100644)
  self.kill_txt = self:AddComponent(UIText, kill_txt_path)
  self.kill_txt:SetLocalText(104225)
  self.check_txt = self:AddComponent(UIText, check_txt_path)
  self.check_txt:SetLocalText(390297)
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
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.apply_list = {}
end

local function OnDestroy(self)
  self.txt_title = nil
  self.empty_txt = nil
  self.power_txt = nil
  self.kill_txt = nil
  self.check_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self.ScrollView = nil
  self.apply_list = nil
  base.OnDestroy(self)
end

local function RefreshApplyList(self)
  self:ClearScroll(self)
  self.apply_list = self.ctrl:GetAllianceApplyList()
  if #self.apply_list > 0 then
    self.ScrollView:SetTotalCount(#self.apply_list)
    self.ScrollView:RefillCells()
    self.empty_txt:SetActive(false)
  else
    self.empty_txt:SetActive(true)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshApplyList()
end

local function OnDisable(self)
  self:ClearScroll(self)
  base.OnDisable(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AllianceApplyItem, itemObj)
  cellItem:SetItemShow(self.apply_list[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AllianceApplyItem)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(AllianceApplyItem)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMemberRedPoint, self.RefreshApplyList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceMemberRedPoint, self.RefreshApplyList)
end

UIAllianceApplyListView.OnCreate = OnCreate
UIAllianceApplyListView.OnDestroy = OnDestroy
UIAllianceApplyListView.RefreshApplyList = RefreshApplyList
UIAllianceApplyListView.OnEnable = OnEnable
UIAllianceApplyListView.OnDisable = OnDisable
UIAllianceApplyListView.OnItemMoveIn = OnItemMoveIn
UIAllianceApplyListView.OnItemMoveOut = OnItemMoveOut
UIAllianceApplyListView.ClearScroll = ClearScroll
UIAllianceApplyListView.OnAddListener = OnAddListener
UIAllianceApplyListView.OnRemoveListener = OnRemoveListener
return UIAllianceApplyListView
