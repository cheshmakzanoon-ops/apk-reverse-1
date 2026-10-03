local UISeasonOfficialSelectMemberView = BaseClass("UISeasonOfficialSelectMemberView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UIGovernment.UISeasonOfficialSelectMember.SeasonOfficialSelectMemberItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local find_input_field_path = "PopUpTitle/Content/FindArea/FindInputField"
local find_click_btn_path = "PopUpTitle/Content/FindArea/FindClickBtn"
local btn_go_path = "PopUpTitle/Content/BtnGO"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/Content/cell"
local scroll_view_path = "PopUpTitle/Content/ScrollView"
local cd_path = "PopUpTitle/Content/cd"

function UISeasonOfficialSelectMemberView:OnCreate()
  base.OnCreate(self)
  self.serverId, self.buildingId, self.config = self:GetUserData()
  self:ComponentDefine()
end

function UISeasonOfficialSelectMemberView:OnDestroy()
  self:ComponentDestroy()
  self.config = nil
  base.OnDestroy(self)
end

function UISeasonOfficialSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:AddUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
end

function UISeasonOfficialSelectMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:RemoveUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
  base.OnRemoveListener(self)
end

function UISeasonOfficialSelectMemberView:ComponentDefine()
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

function UISeasonOfficialSelectMemberView:ComponentDestroy()
  self:ClearScroll()
  self.scrollView = nil
  self.content = nil
  self.btn_back = nil
end

function UISeasonOfficialSelectMemberView:OnSearchBtnClick()
  local str = self.find_input_field:GetText()
  if str ~= "" and 3 <= #str then
    SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearchNew, SearchPlayerType.BuildingOfficialAppointmentSearch, str)
  else
    UIUtil.ShowTipsId(390101)
  end
end

function UISeasonOfficialSelectMemberView:OnGiveBtnClick()
  if self.select_player ~= nil then
    DataCenter.BuildingOfficialManager:TryKingdomPositionAppoint(self.serverId, self.buildingId, self.config, self.select_player, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialSelectMember)
    end)
  end
end

function UISeasonOfficialSelectMemberView:UpdateData()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
  end
  self.theCD = nil
  local positionInfo = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId, self.config.id)
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

function UISeasonOfficialSelectMemberView:Update1000MS()
  if self.theCD ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.theCD - curTime
    if 0 < remainTime then
      self.cd_time:SetActive(true)
      self.cd_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.theCD = nil
      self.cd_time:SetActive(false)
    end
  else
    self.cd_time:SetActive(false)
  end
end

function UISeasonOfficialSelectMemberView:AppendUsers(DataList, abbr)
  if DataList ~= nil then
    self.select_player = nil
    self.player_list = {}
    if LuaEntry.Player:IsDeepLeader(self.serverId, self.buildingId) then
      for _, v in pairs(DataList) do
        table.insert(self.player_list, v)
      end
    else
      for _, v in pairs(DataList) do
        if v.uid ~= LuaEntry.Player.uid then
          table.insert(self.player_list, v)
        end
      end
    end
    self:Sort()
    self:ShowCells(abbr)
  end
end

function UISeasonOfficialSelectMemberView:SendContactGiftSearchBackSignal(message)
  if message ~= nil then
    self:AppendUsers(message.searchRet, nil)
  end
end

function UISeasonOfficialSelectMemberView:AllianceMemberSignal()
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

function UISeasonOfficialSelectMemberView:ShowCells(abbr)
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

function UISeasonOfficialSelectMemberView:GovernmentPresentRefreshSignal()
  self:RefreshLeftNum()
  self:ShowCells()
end

function UISeasonOfficialSelectMemberView:RefreshLeftNum()
  if self.select_player ~= nil then
    self.btn_go:SetInteractable(true)
    CS.UIGray.SetGray(self.btn_go.transform, false, true)
  else
    self.btn_go:SetInteractable(false)
    CS.UIGray.SetGray(self.btn_go.transform, true, false)
  end
end

function UISeasonOfficialSelectMemberView:OnCellClick(player, select)
  if select == true then
    self.select_player = player
  elseif self.select_player == player then
    self.select_player = nil
  end
  self:RefreshLeftNum()
end

function UISeasonOfficialSelectMemberView:CanSelect()
  return self.select_player == nil
end

function UISeasonOfficialSelectMemberView:Sort()
  if self.player_list[2] ~= nil then
    table.sort(self.player_list, function(a, b)
      return a.power > b.power
    end)
  end
end

function UISeasonOfficialSelectMemberView:OnItemMoveIn(itemObj, index)
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

function UISeasonOfficialSelectMemberView:OnItemMoveOut(itemObj, index)
end

function UISeasonOfficialSelectMemberView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(MemberItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

return UISeasonOfficialSelectMemberView
