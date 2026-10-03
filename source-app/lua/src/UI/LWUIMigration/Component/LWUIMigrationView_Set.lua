local LWUIMigration_TabBase = require("UI.LWUIMigration.Component.LWUIMigration_TabBase")
local LWUIMigrationView_Set = BaseClass("LWUIMigrationView_Set", LWUIMigration_TabBase)
local base = LWUIMigration_TabBase
local Localization = CS.GameEntry.Localization
local ApplyItem = require("UI.LWUIMigration.Component.LWUIMigrationView_ApplyItem")
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local SeatIconList = {
  ActMigrationIdentity.SuperLow,
  ActMigrationIdentity.Low,
  ActMigrationIdentity.Normal,
  ActMigrationIdentity.High
}
local DropDownSelectEnum = {
  All = 0,
  WhiteSeat = 1,
  BlueSeat = 2,
  PurpleSeat = 3,
  OrangeSeat = 4
}
local DropDownEnum2Identity = {
  [DropDownSelectEnum.WhiteSeat] = ActMigrationIdentity.SuperLow,
  [DropDownSelectEnum.BlueSeat] = ActMigrationIdentity.Low,
  [DropDownSelectEnum.PurpleSeat] = ActMigrationIdentity.Normal,
  [DropDownSelectEnum.OrangeSeat] = ActMigrationIdentity.High
}
local btn_share_path = "Bottom/ShareBtn"
local btn_set_path = "Bottom/SetBtn"
local list_path = "List"
local drop_down_path = "List/drop_down"
local inputField_path = "List/Input/InputField"
local inputField_placeholder_path = "List/Input/InputField/Placeholder"
local btn_search_path = "List/Input/SearchBtn"
local scroll_view_path = "List/ScrollView"
local content_path = "List/ScrollView/Viewport/Content"
local text_empty_path = "List/EmptyText"
local migration_btn_path = "Top/MigrationSignBtn"
local king_path = "Top/King"
local player_king_path = "Top/King/KPlayer"
local text_king_title_path = "Top/King/KTitleText"
local text_king_name_path = "Top/King/KNameText"
local btn_super_low_path = "Top/Layout/SuperLow"
local text_super_low_path = "Top/Layout/SuperLow/SLText"
local icon_super_low_path = "Top/Layout/SuperLow/SLIcon"
local btn_low_path = "Top/Layout/Low"
local text_low_path = "Top/Layout/Low/LText"
local icon_low_path = "Top/Layout/Low/LIcon"
local btn_normal_path = "Top/Layout/Normal"
local text_normal_path = "Top/Layout/Normal/NText"
local icon_normal_path = "Top/Layout/Normal/NIcon"
local btn_strong_path = "Top/Layout/Strong"
local text_strong_path = "Top/Layout/Strong/SText"
local icon_strong_path = "Top/Layout/Strong/SIcon"
local sp_path = "Top/Layout/Sp"
local btn_sp_path = "Top/Layout/Sp/SpBtn"
local text_sp_path = "Top/Layout/Sp/SPText"
local text_p_path = "Top/Layout/Sp/PText"
local un_open_path = "Top/Layout/UnOpen"
local text_un_open_path = "Top/Layout/UnOpen/UOText"

function LWUIMigrationView_Set:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(BindCallback(self, self.OnBtnShareClick))
  self.btn_set = self:AddComponent(UIButton, btn_set_path)
  self.btn_set:SetOnClick(BindCallback(self, self.OnBtnSetClick))
  self.list = self:AddComponent(UIBaseComponent, list_path)
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_search:SetOnClick(BindCallback(self, self.OnSearchClick))
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.text_empty = self:AddComponent(UIText, text_empty_path)
  self.btnMigrationSign = self:AddComponent(UIButton, migration_btn_path)
  self.btnMigrationSign:SetOnClick(function()
    self:OnClickMigrationSign()
  end)
  self:RefreshMigrationSignState()
  self.king = self:AddComponent(UIBaseComponent, king_path)
  self.player_king = self:AddComponent(UICommonHead, player_king_path)
  self.player_king:SetEnableClickShowInfo(true, true)
  self.text_king_title = self:AddComponent(UIText, text_king_title_path)
  self.text_king_name = self:AddComponent(UIText, text_king_name_path)
  self.text_super_low = self:AddComponent(UIText, text_super_low_path)
  self.icon_super_low = self:AddComponent(UIBaseComponent, icon_super_low_path)
  self.btn_super_low = self:AddComponent(UIButton, btn_super_low_path)
  self.btn_super_low:SetOnClick(function()
    DataCenter.ActMigrationManager:OnBtnIdentityClick(self.icon_super_low.transform, 3)
  end)
  self.text_low = self:AddComponent(UIText, text_low_path)
  self.icon_low = self:AddComponent(UIBaseComponent, icon_low_path)
  self.btn_low = self:AddComponent(UIButton, btn_low_path)
  self.btn_low:SetOnClick(function()
    DataCenter.ActMigrationManager:OnBtnIdentityClick(self.icon_low.transform, 0)
  end)
  self.text_normal = self:AddComponent(UIText, text_normal_path)
  self.icon_normal = self:AddComponent(UIBaseComponent, icon_normal_path)
  self.btn_normal = self:AddComponent(UIButton, btn_normal_path)
  self.btn_normal:SetOnClick(function()
    DataCenter.ActMigrationManager:OnBtnIdentityClick(self.icon_normal.transform, 1)
  end)
  self.text_strong = self:AddComponent(UIText, text_strong_path)
  self.icon_strong = self:AddComponent(UIBaseComponent, icon_strong_path)
  self.btn_strong = self:AddComponent(UIButton, btn_strong_path)
  self.btn_strong:SetOnClick(function()
    DataCenter.ActMigrationManager:OnBtnIdentityClick(self.icon_strong.transform, 2)
  end)
  self.text_p = self:AddComponent(UIText, text_p_path)
  self.text_sp = self:AddComponent(UIText, text_sp_path)
  self.btnTextSp = self:AddComponent(UIButton, text_sp_path)
  self.btnTextSp:SetOnClick(function()
    local curNum = self.serverInfo ~= nil and self.serverInfo.curFupinScore or 0
    UIUtil.ShowBubbleTips(string.GetFormattedSeparatorNum(curNum), self.btnTextSp.transform.position, 0, -30, 0, nil, nil)
  end)
  self.btn_sp = self:AddComponent(UIButton, btn_sp_path)
  self.btn_sp:SetOnClick(function()
    DataCenter.ActMigrationManager:OpenFupinGuide()
  end)
  self.sp = self:AddComponent(UIBaseComponent, sp_path)
  self.un_open = self:AddComponent(UIBaseComponent, un_open_path)
  self.text_un_open = self:AddComponent(UIText, text_un_open_path)
  self.tipUOStr = Localization:GetString("migration_activity_interface_10121")
  self.drop_down = self:AddComponent(UIDropdown, drop_down_path)
  self.drop_down:SetText("")
  self.drop_down:SetValue(DropDownSelectEnum.All - 1)
  self.drop_down:SetIsInvokeCbOnValueUnchanged(true)
  self.curSelectedIndex = DropDownSelectEnum.All
end

function LWUIMigrationView_Set:RefreshMigrationSignState()
  local canSet = DataCenter.ActMigrationManager:CheckCanSetting(false)
  self.btnMigrationSign:SetActive(canSet)
end

function LWUIMigrationView_Set:ClearSpriteReq()
  if self.spriteReqList then
    for _, v in ipairs(self.spriteReqList) do
      if v ~= nil then
        v:Release()
      end
    end
  end
  self.spriteReqList = {}
end

function LWUIMigrationView_Set:OnDestroy()
  self.curSelectedIndex = nil
  self.dataInit = nil
  self:ClearSpriteReq()
  self.endTime = nil
  self.content:RemoveComponents(ApplyItem)
  self.scroll_view:ClearAllItems()
  self.drop_down:SetOnValueChanged(nil)
  self.drop_down:SetValue(DropDownSelectEnum.All - 1)
  self.drop_down:Clear()
  self.drop_down = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_Set:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationGetPlayerList, self.UpdateData)
  self:AddUIListener(EventId.ActMigrationServerInfoUpdate, self.UpdateServerInfo)
end

function LWUIMigrationView_Set:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationGetPlayerList, self.UpdateData)
  self:RemoveUIListener(EventId.ActMigrationServerInfoUpdate, self.UpdateServerInfo)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_Set:OnBtnShareClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(false) then
    UIUtil.ShowTipsId("migration_activity_tips_20039")
    return
  end
  if not DataCenter.ActMigrationManager:CheckShareImmigrantInviteCd(true) then
    return
  end
  local myInfo = DataCenter.ActMigrationManager:GetMyInfo()
  local myServerInfo = DataCenter.ActMigrationManager:GetMyServerInfo()
  local tips = CS.GameEntry.Localization:GetString("migration_activity_tips_20015", DataCenter.ActMigrationManager:GetShareImmigrantInviteCd())
  DataCenter.ActMigrationManager:ShareImmigrantInvite(myInfo, myServerInfo, tips)
end

function LWUIMigrationView_Set:OnBtnSetClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationSetting)
end

function LWUIMigrationView_Set:OnSearchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local value = self.inputField:GetText()
  if #value > MAX_AL_NAME_CHAR then
    UIUtil.ShowTipsId(120193)
    return
  end
  if string.IsNullOrEmpty(value) then
    self:UpdateData(DataCenter.ActMigrationManager.applyIdList)
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnClickTime ~= nil and curTime - self.lastBtnClickTime <= 3000 then
    return
  end
  self.lastBtnClickTime = curTime
  DataCenter.ActMigrationManager:ReqApplyListSearch(value)
end

function LWUIMigrationView_Set:OnClickMigrationSign()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationPlayerMark)
end

function LWUIMigrationView_Set:OnInputFieldValueChange(_)
  local value = self.inputField:GetText()
  self.inputField_placeholder:SetActive(value == "")
  if string.IsNullOrEmpty(value) or #value > MAX_AL_NAME_CHAR then
    CS.UIGray.SetGray(self.btn_search.transform, true, true)
  else
    CS.UIGray.SetGray(self.btn_search.transform, false, true)
  end
end

function LWUIMigrationView_Set:IptOnValueChange(_)
  local value = self.inputField:GetText()
  if string.IsNullOrEmpty(value) then
    self:UpdateData(DataCenter.ActMigrationManager.applyIdList)
  end
end

function LWUIMigrationView_Set:InitDropDown()
  self:ClearSpriteReq()
  local optionDataList = {}
  for k, v in ipairs(SeatIconList) do
    local temp = OptionData()
    local idx = k
    temp.text = DataCenter.ActMigrationManager:GetCountByMigrationIdentity(v)
    self.spriteReqList[idx] = CS.GameEntry.Resource:LoadAssetAsync(DataCenter.ActMigrationManager:GetPlayerTypeImg(v), typeof(CS.UnityEngine.Sprite))
    self.spriteReqList[idx].completed = function()
      local req = self.spriteReqList[idx]
      if not req or req.isError or not self.drop_down then
        return
      end
      temp.image = req.asset
      optionDataList[idx] = temp
      if table.count(optionDataList) >= #SeatIconList then
        for _, v1 in ipairs(optionDataList) do
          self.drop_down:Add(v1)
        end
      end
    end
  end
  self.drop_down:SetOnValueChanged(function(selectedIndex)
    if self.curSelectedIndex ~= selectedIndex + 1 then
      self.curSelectedIndex = selectedIndex + 1
    else
      self.curSelectedIndex = DropDownSelectEnum.All
      self.drop_down:SetValueWithoutNotify(DropDownSelectEnum.All - 1)
    end
    self:UpdateData(DataCenter.ActMigrationManager.applyIdList)
  end)
end

function LWUIMigrationView_Set:UpdateData(playerIdList)
  if self:IsMvHide() then
    return
  end
  if not self.dataInit then
    self.dataInit = true
    self:InitDropDown()
  end
  local _, info = DataCenter.ActMigrationManager:GetCurStageInfo()
  local flag = info ~= nil and info.state == ActMigrationState.Apply
  local oriPlayerIdList = {}
  if flag then
    oriPlayerIdList = playerIdList
  else
    oriPlayerIdList = {}
    for _, v in ipairs(playerIdList) do
      local playerData = DataCenter.ActMigrationManager:GetPlayerDataByUid(v)
      if playerData.applyState == 2 then
        table.insert(oriPlayerIdList, v)
      end
    end
  end
  self.playerIdList = {}
  for _, v in ipairs(oriPlayerIdList) do
    local playerData = DataCenter.ActMigrationManager:GetPlayerDataByUid(v)
    if self.curSelectedIndex == DropDownSelectEnum.All or playerData.identity == DropDownEnum2Identity[self.curSelectedIndex] then
      table.insert(self.playerIdList, v)
    end
  end
  self:RefreshList(self.playerIdList)
end

function LWUIMigrationView_Set:SetData()
  base.SetData(self)
  self:RefreshData()
  DataCenter.ActMigrationManager:ReqApplyList()
end

function LWUIMigrationView_Set:RefreshData()
  self:OnInputFieldValueChange()
  self:RefreshMigrationSignState()
  self:UpdateServerInfo(LuaEntry.Player:GetSourceServerId())
  self:CheckStage()
end

function LWUIMigrationView_Set:UpdateServerInfo(serverId)
  if self:IsMvHide() then
    return
  end
  if serverId ~= LuaEntry.Player:GetSourceServerId() then
    return
  end
  self:RefreshMigrationSignState()
  self.serverInfo = DataCenter.ActMigrationManager:GetMyServerInfo()
  if self.serverInfo == nil then
    return
  end
  local pKing = self.serverInfo.presidentInfo
  self.king:SetActive(pKing ~= nil)
  if pKing ~= nil then
    self.player_king:ParseHeadInfo(pKing)
    self.text_king_title:SetLocalText(457202)
    local nameStr = UIUtil.FormatAllianceAndName(pKing.abbr, pKing.name, pKing.uid)
    self.text_king_name:SetText(nameStr)
  end
  local zInfo = DataCenter.ActMigrationManager:GetMyZoneStandard()
  local isFupin = self.serverInfo:IsFupin()
  self.sp:SetActive(isFupin)
  self.btn_super_low:SetActive(not isFupin)
  self.btn_low:SetActive(not isFupin)
  self.btn_normal:SetActive(not isFupin)
  if isFupin then
    local curNum = self.serverInfo.curFupinScore
    self.text_sp:SetText(string.GetFormattedStr(curNum))
    self.text_p:SetText(DataCenter.ActMigrationManager.remainNumber)
  else
    local maxSuperLow = zInfo ~= nil and zInfo.superLowNum or 0
    local maxLow = zInfo ~= nil and zInfo.lowNum or 0
    local maxNormal = zInfo ~= nil and zInfo.normalNum or 0
    self.text_super_low:SetText(self.serverInfo.superLowPlayerIn .. "/" .. maxSuperLow)
    self.text_low:SetText(self.serverInfo.lowPlayerIn .. "/" .. maxLow)
    self.text_normal:SetText(self.serverInfo.playerIn .. "/" .. maxNormal)
  end
  local maxStrong = zInfo ~= nil and zInfo.strongNum or 0
  self.text_strong:SetText(self.serverInfo.highPlayerIn .. "/" .. maxStrong)
end

function LWUIMigrationView_Set:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.playerIdList then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWUIMigration_SetItem")
  local script = self.content:GetComponent(item.gameObject.name, ApplyItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(ApplyItem, objectName)
  end
  script:SetActive(true)
  local uid = self.playerIdList[index]
  local playerInfo = uid and DataCenter.ActMigrationManager:GetPlayerDataByUid(uid) or nil
  script:SetData(playerInfo)
  return item
end

function LWUIMigrationView_Set:RefreshList(playerIdList)
  local cnt = playerIdList ~= nil and #playerIdList or 0
  self.scroll_view:SetActive(0 < cnt)
  self.text_empty:SetActive(cnt == 0)
  if cnt == 0 then
    local _, stageInfo = DataCenter.ActMigrationManager:GetCurStageInfo()
    if stageInfo == nil or stageInfo.state < ActMigrationState.Apply then
      self.text_empty:SetLocalText("migration_activity_interface_10057")
    else
      self.text_empty:SetLocalText("migration_activity_tips_20001")
    end
    return
  end
  self.scroll_view:SetListItemCount(cnt, false, false)
  self.scroll_view:RefreshAllShownItem()
  self.scroll_view:MovePanelToItemIndex(0)
end

function LWUIMigrationView_Set:CheckStage()
  local _, info = DataCenter.ActMigrationManager:GetCurStageInfo()
  local flag = info == nil or info.state == ActMigrationState.Notice
  self.un_open:SetActive(flag)
  if flag and info then
    self.endTime = info.eTime
    local str = "???"
    self.text_super_low:SetText(str)
    self.text_low:SetText(str)
    self.text_normal:SetText(str)
    self.text_strong:SetText(str)
    self.text_sp:SetText(str)
    self.text_p:SetText(str)
    self:Update1000MS()
  else
    self.endTime = nil
  end
end

function LWUIMigrationView_Set:Update1000MS()
  if self:IsMvHide() then
    return
  end
  if self.endTime == nil then
    return
  end
  local uiMgr = UITimeManager:GetInstance()
  local curSec = uiMgr:GetServerSeconds()
  local remainTime = self.endTime / 1000 - curSec
  remainTime = remainTime < 0 and 0 or remainTime
  local str = self.tipUOStr .. "\n" .. uiMgr:SecondToFmtString(remainTime)
  self.text_un_open:SetText(str)
  if remainTime == 0 then
    self.endTime = nil
    return
  end
end

return LWUIMigrationView_Set
