local OfficialSelectMemberView = BaseClass("OfficialSelectMemberView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UIGovernment.OfficialSelectMember.Component.OfficialSelectMemberItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local find_input_field_path = "PopUpTitle/Content/FindArea/FindInputField"
local find_click_btn_path = "PopUpTitle/Content/FindArea/FindClickBtn"
local btn_go_path = "PopUpTitle/Content/BtnGO"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/Content/cell"
local scroll_view_path = "PopUpTitle/Content/ScrollView"
local cd_path = "PopUpTitle/Content/cd"

function OfficialSelectMemberView:OnCreate()
  base.OnCreate(self)
  local governmentId = self:GetUserData()
  self.governmentId = governmentId
  self:ComponentDefine()
end

function OfficialSelectMemberView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
  self:AddUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:AddUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
end

function OfficialSelectMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
  self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:RemoveUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
  base.OnRemoveListener(self)
end

function OfficialSelectMemberView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_click_btn = self:AddComponent(UIButton, find_click_btn_path)
  self.cd_time = self:AddComponent(UIText, cd_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.find_click_btn:SetOnClick(function()
    self:OnSearchBtnClick()
  end)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
  self.scrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self:UpdateData()
end

function OfficialSelectMemberView:ComponentDestroy()
  self:ClearScroll()
  self.scrollView = nil
  self.content = nil
  self.btn_back = nil
end

function OfficialSelectMemberView:OnSearchBtnClick()
  local str = self.find_input_field:GetText()
  if str ~= "" and 3 <= #str then
    SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearch, LuaEntry.Player:GetSourceServerId(), str)
  else
    UIUtil.ShowTipsId(390101)
  end
end

function OfficialSelectMemberView:OnGiveBtnClick()
  if self.select_player ~= nil then
    local configData = DataCenter.GovernmentTemplateManager:GetTemplate(self.governmentId)
    DataCenter.GovernmentManager:TryKingdomPositionAppoint(self.governmentId, self.select_player, configData, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficialSelectMember)
    end)
  end
end

function OfficialSelectMemberView:UpdateData()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
  end
  self.theCD = nil
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.governmentId)
  if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
    self.theCD = positionInfo:GetAppointTimeCD()
  else
    self.cd_time:SetActive(false)
  end
  self.select_player = nil
  self.player_list = {}
  self:AllianceMemberSignal()
  self:RefreshLeftNum()
  self:Update1000MS()
end

function OfficialSelectMemberView:Update1000MS()
  if self.theCD ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.theCD - curTime
    if 0 < remainTime then
      self.cd_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.theCD = nil
      self.cd_time:SetActive(false)
    end
  else
    self.cd_time:SetActive(false)
  end
end

function OfficialSelectMemberView:AppendUsers(DataList, abbr)
  if DataList ~= nil then
    self.select_player = nil
    self.player_list = {}
    for _, v in pairs(DataList) do
      if v.uid ~= LuaEntry.Player.uid then
        table.insert(self.player_list, v)
      end
    end
    self:Sort()
    self:ShowCells(abbr)
  end
end

function OfficialSelectMemberView:SendContactGiftSearchBackSignal(message)
  if message ~= nil then
    self:AppendUsers(message.searchRet, nil)
  end
end

function OfficialSelectMemberView:AllianceMemberSignal()
  local all = DataCenter.AllianceMemberDataManager:GetAllMember()
  if all ~= nil then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
      self:AppendUsers(all, data.abbr)
    else
      self:AppendUsers(all, nil)
    end
  end
end

function OfficialSelectMemberView:ShowCells(abbr)
  if self.player_list and #self.player_list > 0 then
    self:ClearScroll()
    self.showDatalist = self.player_list
    self.abbr = abbr
    self.scrollView:StopMovement()
    self.scrollView:SetVerticalNormalizedPosition(1.0)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  end
end

function OfficialSelectMemberView:GovernmentPresentRefreshSignal()
  self:RefreshLeftNum()
  self:ShowCells()
end

function OfficialSelectMemberView:RefreshLeftNum()
  if self.select_player ~= nil then
    self.btn_go:SetInteractable(true)
    CS.UIGray.SetGray(self.btn_go.transform, false, true)
  else
    self.btn_go:SetInteractable(false)
    CS.UIGray.SetGray(self.btn_go.transform, true, false)
  end
end

function OfficialSelectMemberView:OnCellClick(player, select)
  if select == true then
    self.select_player = player
  elseif self.select_player == player then
    self.select_player = nil
  end
  self:RefreshLeftNum()
end

function OfficialSelectMemberView:CanSelect()
  return self.select_player == nil
end

function OfficialSelectMemberView:Sort()
  if self.player_list[2] ~= nil then
    table.sort(self.player_list, function(a, b)
      return a.power > b.power
    end)
  end
end

function OfficialSelectMemberView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(MemberItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:ReInit(self.select_player, self.showDatalist[index], self.abbr)
end

function OfficialSelectMemberView:OnItemMoveOut(itemObj, index)
end

function OfficialSelectMemberView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(MemberItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

return OfficialSelectMemberView
