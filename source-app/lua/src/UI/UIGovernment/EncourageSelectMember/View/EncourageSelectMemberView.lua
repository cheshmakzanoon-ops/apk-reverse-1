local EncourageSelectMemberView = BaseClass("EncourageSelectMemberView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UIGovernment.EncourageSelectMember.Component.EncourageSelectMemberItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/dialogTitle"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/Content/TitleText"
local find_input_field_path = "PopUpTitle/Content/FindArea/FindInputField"
local find_click_btn_path = "PopUpTitle/Content/FindArea/FindClickBtn"
local btn_go_path = "PopUpTitle/Content/BtnGO"
local go_text_path = "PopUpTitle/Content/BtnGO/GoText"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/Content/cell"
local scroll_view_path = "PopUpTitle/Content/ScrollView/"

function EncourageSelectMemberView:OnCreate()
  base.OnCreate(self)
  self.type, self.throneType = self:GetUserData()
  self:ComponentDefine()
end

function EncourageSelectMemberView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EncourageSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
  self:AddUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:AddUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
end

function EncourageSelectMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
  self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
  self:RemoveUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
  base.OnRemoveListener(self)
end

function EncourageSelectMemberView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_click_btn = self:AddComponent(UIButton, find_click_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.dialog_title_text:SetLocalText("457019")
  self.title_text:SetLocalText("457021")
  self.find_click_btn:SetOnClick(function()
    self:OnSearchBtnClick()
  end)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.btn_go:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
  self.go_text:SetLocalText("457022")
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self:UpdateData()
end

function EncourageSelectMemberView:ComponentDestroy()
  self.content:RemoveComponents(MemberItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.btn_back = nil
end

function EncourageSelectMemberView:OnSearchBtnClick()
  local str = self.find_input_field:GetText()
  if str ~= "" and 3 <= #str then
    SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearch, LuaEntry.Player:GetSourceServerId(), str)
  else
    UIUtil.ShowTipsId(390101)
  end
end

function EncourageSelectMemberView:OnGiveBtnClick()
  local result = {}
  for k, v in pairs(self.uid) do
    if not DataCenter.GovernmentManager:IsGetReward(k, self.throneType) then
      table.insert(result, k)
    end
  end
  if result[1] ~= nil then
    DataCenter.GovernmentManager:KingSendPresent(result, self.present.presentId)
  end
  self.ctrl:CloseSelf()
end

function EncourageSelectMemberView:UpdateData()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
  end
  self.uid = {}
  self.list = {}
  local present = DataCenter.GovernmentManager:GetPresentByRewardType(self.type, self.throneType)
  if present ~= nil then
    local config = DataCenter.WonderGiftTemplateManager:GetTemplateByType(self.type, self.throneType)
    if config ~= nil then
      self.useCount = present.useCount
      self.maxCount = config.num
    end
  end
  self.present = present
  local txt = Localization:GetString("2000291", self:GetLeftNum())
  self.title_text:SetText(Localization:GetString("457021") .. "(" .. txt .. ")")
  self:AllianceMemberSignal()
  self:RefreshLeftNum()
end

function EncourageSelectMemberView:GetLeftNum()
  return self.maxCount - self.useCount - table.count(self.uid)
end

function EncourageSelectMemberView:AppendUsers(DataList, abbr)
  if DataList ~= nil then
    self.list = {}
    for _, v in pairs(DataList) do
      if v.uid ~= LuaEntry.Player.uid then
        table.insert(self.list, v)
      end
    end
    self:Sort()
    self:ShowCells(abbr)
  end
end

function EncourageSelectMemberView:SendContactGiftSearchBackSignal(message)
  if message ~= nil then
    self:AppendUsers(message.searchRet, nil)
  end
end

function EncourageSelectMemberView:AllianceMemberSignal()
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

function EncourageSelectMemberView:ShowCells(abbr)
  local goItem, itemNode
  self.content:RemoveComponents(MemberItem)
  self.theItem:GameObjectRecycleAll()
  self.scroll_view:StopMovement()
  self.scroll_view:SetVerticalNormalizedPosition(1.0)
  for k, v in ipairs(self.list) do
    if not string.IsNullOrEmpty(v.uid) then
      local levelName = "user_" .. v.uid
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      itemNode = self.content:AddComponent(MemberItem, levelName)
      itemNode:ReInit(self:IsSelect(v.uid), v, abbr)
    end
  end
end

function EncourageSelectMemberView:GovernmentPresentRefreshSignal()
  self:RefreshLeftNum()
  self:ShowCells()
end

function EncourageSelectMemberView:RefreshLeftNum()
  local userCount = table.count(self.uid)
  if 0 < userCount and userCount + self.useCount <= self.maxCount then
    self.btn_go:SetInteractable(true)
    CS.UIGray.SetGray(self.btn_go.transform, false, true)
  else
    self.btn_go:SetInteractable(false)
    CS.UIGray.SetGray(self.btn_go.transform, true, false)
  end
end

function EncourageSelectMemberView:IsSelect(uid)
  return self.uid[uid] ~= nil
end

function EncourageSelectMemberView:OnCellClick(uid, select)
  if select == true then
    self.uid[uid] = true
    local userCount = table.count(self.uid)
    if userCount + self.useCount > self.maxCount then
      UIUtil.ShowTipsId(110266)
    end
  else
    self.uid[uid] = nil
  end
  self:RefreshLeftNum()
end

function EncourageSelectMemberView:CanSelect()
  return self:GetLeftNum() > 0
end

function EncourageSelectMemberView:Sort()
  if self.list[2] ~= nil then
    table.sort(self.list, function(a, b)
      local sendA = DataCenter.GovernmentManager:IsGetReward(a.uid, self.throneType)
      local sendB = DataCenter.GovernmentManager:IsGetReward(b.uid, self.throneType)
      if sendA and sendB then
        return a.power > b.power
      elseif sendA or sendB then
        if sendA then
          return false
        end
        return true
      end
      return a.power > b.power
    end)
  end
end

return EncourageSelectMemberView
