local UILWSeasonMakeFriendsLinkedCityView = BaseClass("UILWSeasonMakeFriendsLinkedCityView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LinkedCityItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsLinkedCity.Component.UILWSeasonMakeFriendsLinkedCityItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local my_tile_path = "PopUpTitle/myTile"
local other_tile_path = "PopUpTitle/otherTile"
local btn_cancle_path = "PopUpTitle/BtnCancle"
local scroll_view1_path = "PopUpTitle/ScrollView1"
local content1_path = "PopUpTitle/ScrollView1/Viewport/Content1"
local scroll_view2_path = "PopUpTitle/ScrollView2"
local content2_path = "PopUpTitle/ScrollView2/Viewport/Content2"

function UILWSeasonMakeFriendsLinkedCityView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyHandshakeInfo)
  self.allyAllianceId = self:GetUserData()
  if self.allyAllianceId ~= nil then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allyAllianceId)
    else
      self.allianceInfo = allianceInfo
      self:UpdateData()
    end
  end
end

function UILWSeasonMakeFriendsLinkedCityView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsLinkedCityView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MFAllyHandshakeInfoUpdate, self.OnHandshakeInfoUpdate)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
end

function UILWSeasonMakeFriendsLinkedCityView:OnRemoveListener()
  self:RemoveUIListener(EventId.MFAllyHandshakeInfoUpdate, self.OnHandshakeInfoUpdate)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsLinkedCityView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_alliance_ally_tittle04")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.my_tile = self:AddComponent(UITextMeshProUGUIEx, my_tile_path)
  self.other_tile = self:AddComponent(UITextMeshProUGUIEx, other_tile_path)
  self.btn_cancle = self:AddComponent(UIButton, btn_cancle_path)
  self.btn_cancle:SetOnClick(function()
    self:DisConnect()
  end)
  self.scroll_view1 = self:AddComponent(UIScrollView, scroll_view1_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.scroll_view2 = self:AddComponent(UIScrollView, scroll_view2_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.scroll_view1:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(self.scroll_view1, itemObj, index)
  end)
  self.scroll_view1:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(self.scroll_view1, itemObj, index)
  end)
  self.scroll_view2:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(self.scroll_view2, itemObj, index)
  end)
  self.scroll_view2:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(self.scroll_view2, itemObj, index)
  end)
end

function UILWSeasonMakeFriendsLinkedCityView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
  self.my_tile = nil
  self.other_tile = nil
  self.btn_cancle = nil
  self.scroll_view1 = nil
  self.scroll_view2 = nil
  self.content1 = nil
  self.content2 = nil
end

function UILWSeasonMakeFriendsLinkedCityView:UpdateData()
  local allianceInfo = self.allianceInfo
  if allianceInfo == nil then
    allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      return
    end
    self.allianceInfo = allianceInfo
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data == nil or data.abbr == nil then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local name1 = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr, nil)
  local name2 = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  self.my_tile:SetText(name1)
  self.other_tile:SetText(name2)
  self:OnHandshakeInfoUpdate()
end

function UILWSeasonMakeFriendsLinkedCityView:OnHandshakeInfoUpdate()
  local allyHandshakeInfo = DataCenter.SeasonAllyFriendManager:GetHandshakeInfo(false)
  local myBuildings = allyHandshakeInfo and allyHandshakeInfo.myBuildings or nil
  local allyBuildings = allyHandshakeInfo and allyHandshakeInfo.allyBuildings or nil
  self.allyHandshakeInfo = allyHandshakeInfo
  if myBuildings and 0 < #myBuildings then
    self.myBuildings = myBuildings
    self.scroll_view1:SetActive(true)
    self.scroll_view1:SetTotalCount(#myBuildings)
    self.scroll_view1:RefillCells()
  else
    self.scroll_view1:SetActive(false)
  end
  if allyBuildings and 0 < #allyBuildings then
    self.allyBuildings = allyBuildings
    self.scroll_view2:SetActive(true)
    self.scroll_view2:SetTotalCount(#allyBuildings)
    self.scroll_view2:RefillCells()
  else
    self.scroll_view2:SetActive(false)
  end
end

function UILWSeasonMakeFriendsLinkedCityView:OnItemMoveIn(scroll_view, itemObj, index)
  itemObj.name = tostring(index)
  local item = scroll_view:AddComponent(LinkedCityItem, itemObj)
  if item then
    if scroll_view == self.scroll_view1 then
      local data = self.myBuildings[index]
      item:ReInit(index, data, self.allyHandshakeInfo.myAlliance)
    elseif scroll_view == self.scroll_view2 then
      local data = self.allyBuildings[index]
      item:ReInit(index, data, self.allyHandshakeInfo.allyAlliance)
    end
  end
end

function UILWSeasonMakeFriendsLinkedCityView:OnItemMoveOut(scroll_view, itemObj, index)
  scroll_view:RemoveComponent(itemObj.name, LinkedCityItem)
end

function UILWSeasonMakeFriendsLinkedCityView:ClearScroll()
  self.scroll_view1:ClearCells()
  self.scroll_view1:RemoveComponents(LinkedCityItem)
  self.scroll_view2:ClearCells()
  self.scroll_view2:RemoveComponents(LinkedCityItem)
end

function UILWSeasonMakeFriendsLinkedCityView:DisConnect()
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if not DataCenter.AllianceBaseDataManager:IsR5() and officialPos ~= LWAlMemberOffcialType.Al_Goddess then
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
    return
  end
  local allianceInfo = self.allianceInfo
  if allianceInfo == nil then
    allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      UIUtil.ShowTipsId("avatar_tips006")
      return
    end
    self.allianceInfo = allianceInfo
  end
  local name = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  local param = {}
  param.tipText = Localization:GetString("s6_alliance_ally_desc37", name)
  param.btnNum = 2
  param.showToggle = false
  param.delayConfirm = {delayTime = 10}
  
  function param.sureAction()
    local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
      SFSNetwork.SendMessage(MsgDefines.DissolveAllianceAlly)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsLinkedCity)
    else
      UIUtil.ShowTipsId(393018)
    end
  end
  
  UIUtil.ShowSecondMessageByParam(param)
end

return UILWSeasonMakeFriendsLinkedCityView
