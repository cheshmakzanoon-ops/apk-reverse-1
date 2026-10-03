local UIActGiftGivingSelectMemberView = BaseClass("UIActGiftGivingSelectMemberView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UIActGiftGiving.UIActGiftGivingSelectMember.Component.UIActGiftGivingSelectMemberItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local find_input_field_path = "PopUpTitle/Content/FindArea/FindInputField"
local find_click_btn_path = "PopUpTitle/Content/FindArea/FindClickBtn"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/Content/cell"
local scroll_view_path = "PopUpTitle/Content/ScrollView"
local chat_input_field_path = "PopUpTitle/Content/ChatArea/ChatInputField"
local resource_num_path = "PopUpTitle/ResBar/numContent/resourceNum"
local resource_icon_path = "PopUpTitle/ResBar/resourceIcon"
local add_btn_path = "PopUpTitle/ResBar/addBtn"

function UIActGiftGivingSelectMemberView:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:InitView()
end

function UIActGiftGivingSelectMemberView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActGiftGivingSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
  self:AddUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
  self:AddUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:AddUIListener(EventId.ActGiftGivingGive, self.SendActGiftGivingGiveMsg)
  self:AddUIListener(EventId.ActGiftGivingRecommandGetMsg, self.GetRecommandPlayerDataMsg)
end

function UIActGiftGivingSelectMemberView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
  self:RemoveUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
  self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:RemoveUIListener(EventId.ActGiftGivingGive, self.SendActGiftGivingGiveMsg)
  self:RemoveUIListener(EventId.ActGiftGivingRecommandGetMsg, self.GetRecommandPlayerDataMsg)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.player_list then
    return nil
  end
  local packData = self.player_list[index]
  local item = loopScroll:NewListViewItem("cell")
  local script = self.content:GetComponent(item.gameObject.name, MemberItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(MemberItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(packData, self.activityId, self.activityTemp.give_cost_item_tab[1], function(activityId, otherUid, num, index)
    self:OnSendGiveMsg(activityId, otherUid, num, index)
  end, index)
  return item
end

function UIActGiftGivingSelectMemberView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_click_btn = self:AddComponent(UIButton, find_click_btn_path)
  self.chat_input_field = self:AddComponent(UIInput, chat_input_field_path)
  self.find_input_field:SetCharacterLimit(1000)
  self.chat_input_field:SetCharacterLimit(1000)
  self.find_input_field:SetText("")
  self.chat_input_field:SetText("")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.find_click_btn:SetOnClick(function()
    self:OnSearchBtnClick()
  end)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIActGiftGivingSelectMemberView:ComponentDestroy()
  self.content:RemoveComponents(MemberItem)
  self.scroll_view:ClearAllItems()
  self.btn_back = nil
  self.chat_input_field = nil
  self.resource_num = nil
  self.resource_icon = nil
  self.add_btn = nil
end

function UIActGiftGivingSelectMemberView:InitView()
  self:InitData()
  self:RefreshView()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
  end
end

function UIActGiftGivingSelectMemberView:InitData()
  self.activityId = self:GetUserData()
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(self.activityInfo)
end

function UIActGiftGivingSelectMemberView:RefreshView()
  if self.activityDetailData == nil then
    return
  end
  self:RefreshResContent()
  self:UpdateData()
end

function UIActGiftGivingSelectMemberView:UpdateData()
  self:Update1000MS()
  self.player_list = {}
  local serverPlayers = self.activityDetailData.givePlayers
  local all = DataCenter.AllianceMemberDataManager:GetAllMember()
  local alExcludeDict = {}
  local alAddMemberList = {}
  alExcludeDict[LuaEntry.Player.uid] = true
  for k, v in ipairs(serverPlayers) do
    alExcludeDict[v.uid] = true
  end
  if all then
    for k, v in pairs(all) do
      if not alExcludeDict[v.uid] then
        table.insert(alAddMemberList, v)
      end
    end
  end
  table.sort(alAddMemberList, function(a, b)
    return a.power > b.power
  end)
  for k, v in ipairs(serverPlayers) do
    table.insert(self.player_list, {playerData = v, isMulit = false})
  end
  for k, v in ipairs(alAddMemberList) do
    table.insert(self.player_list, {playerData = v, isMulit = false})
  end
  self.content:SetAnchoredPositionXY(0, 0)
  self:ShowCells()
end

function UIActGiftGivingSelectMemberView:ShowCells()
  self.scroll_view:SetListItemCount(#self.player_list, false, false)
  self.scroll_view:RefreshAllShownItem()
end

function UIActGiftGivingSelectMemberView:OnSearchBtnClick()
  local str = self.find_input_field:GetText()
  if str ~= "" and 3 <= #str then
    SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearch, LuaEntry.Player.serverId, str)
  else
    UIUtil.ShowTipsId(390101)
  end
end

function UIActGiftGivingSelectMemberView:RefreshResContent()
  if not self.activityDetailData then
    return
  end
  local itemId = self.activityTemp.give_item
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  self.resource_icon:LoadSprite(iconPath)
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  self.resource_num:SetText(curNum)
end

function UIActGiftGivingSelectMemberView:GetActExchangeMsg()
  self:RefreshResContent()
  self:ShowCells()
end

function UIActGiftGivingSelectMemberView:OnAddBtnClick()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.activityId)
end

function UIActGiftGivingSelectMemberView:AllianceMemberSignal()
  self:UpdateData()
end

function UIActGiftGivingSelectMemberView:GetRecommandPlayerDataMsg()
  self:UpdateData()
end

function UIActGiftGivingSelectMemberView:Update1000MS()
end

function UIActGiftGivingSelectMemberView:SendContactGiftSearchBackSignal(message)
  if message ~= nil then
    local data = message.searchRet
    if data == nil then
      data = {}
    end
    self.player_list = {}
    for k, v in ipairs(data) do
      table.insert(self.player_list, {playerData = v, isMulit = false})
    end
    self.content:SetAnchoredPositionXY(0, 0)
    self:ShowCells()
    if #self.player_list == 0 then
      UIUtil.ShowTipsId("thxgiv_NoUser")
    end
  end
end

function UIActGiftGivingSelectMemberView:OnSendGiveMsg(activityId, otherUid, num, index)
  local returnGiftUuid = 0
  local leavingMessage = self.chat_input_field:GetText()
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingGive, activityId, otherUid, num, returnGiftUuid, leavingMessage)
  if index ~= nil then
    for k, v in ipairs(self.player_list) do
      v.isMult = k == index
    end
  end
end

function UIActGiftGivingSelectMemberView:SendActGiftGivingGiveMsg(message)
  self:RefreshResContent()
  self:ShowCells()
end

return UIActGiftGivingSelectMemberView
