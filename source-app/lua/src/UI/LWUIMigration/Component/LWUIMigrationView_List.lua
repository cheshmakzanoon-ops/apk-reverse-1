local LWUIMigration_TabBase = require("UI.LWUIMigration.Component.LWUIMigration_TabBase")
local LWUIMigrationView_List = BaseClass("LWUIMigrationView_List", LWUIMigration_TabBase)
local base = LWUIMigration_TabBase
local MyInsert = table.insert
local MyStrNull = string.IsNullOrEmpty
local ListItem_Cls = "UI.LWUIMigration.Component.LWUIMigrationView_ListItem"
local ListItem_Prefab = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_ListItem.prefab"
local top_path = "Top"
local btn_info_path = "Top/Title/TitleText/BtnInfo"
local text_title_path = "Top/Title/TitleText"
local s_content_path = "Top/SContent"
local more_btn_path = "Top/SContent/MoreBtn"
local text_server_path = "Top/ServerText"
local point_path = "Top/Point"
local inputField_path = "Top/Input/InputField"
local inputField_placeholder_path = "Top/Input/InputField/Placeholder"
local btn_search_path = "Top/Input/SearchBtn"
local toggle_check_path = "Top/Input/CheckToggle"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local Bottom_Prefab = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_Bottom.prefab"
local Bottom_Cls = "UI.LWUIMigration.Component.LWUIMigrationView_Bottom"

function LWUIMigrationView_List:OnCreate()
  base.OnCreate(self)
  self.topInit = false
  self.items = {}
  self.top = self:AddComponent(UIBaseComponent, top_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.s_content = self:AddComponent(UIBaseContainer, s_content_path)
  self.textServerObj = self.transform:Find(text_server_path).gameObject
  self.textServerObj:GameObjectCreatePool()
  self.more_btn = self:AddComponent(UIButton, more_btn_path)
  self.point = self:AddComponent(UIBaseComponent, point_path)
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.toggle_check = self:AddComponent(UIToggle, toggle_check_path)
  self.toggle_check:SetOnValueChanged(function(_)
    self:RefreshList()
  end)
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_search:SetOnClick(BindCallback(self, self.OnSearchClick))
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bottom = self:LoadComponentAsync(Bottom_Cls, Bottom_Prefab, self, function()
    if self.bottom ~= nil then
      self.bottom:SetAnchoredPositionXY(0, -15)
    end
  end)
  self.bottom:SetName("Bottom")
  self.bottom:SetSiblingIndex(1)
end

function LWUIMigrationView_List:OnDestroy()
  self.bottom = nil
  self.items = nil
  self.topInit = false
  self.point.transform:SetParent(self.top.transform)
  self.s_content:RemoveComponents(UITextMeshProUGUIEx)
  self.textServerObj:GameObjectRecycleAll()
  self.content:RemoveComponents(UIBaseContainer)
  self.scroll_view:ClearAllItems()
  base.OnDestroy(self)
end

function LWUIMigrationView_List:OnBtnMore()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local openConfig = DataCenter.ActMigrationManager:GetOpenConfig()
  local list = openConfig ~= nil and openConfig.serverList or {}
  local cnt = #list
  local sb = StringBuilder.New()
  for i, v in ipairs(list) do
    sb:Append("#")
    sb:Append(v)
    if i ~= cnt then
      sb:Append(" ")
    end
  end
  UIUtil.ShowIntro(CS.GameEntry.Localization:GetString("170001"), nil, sb:ToString())
end

function LWUIMigrationView_List:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationScore, {anim = true}, true)
end

function LWUIMigrationView_List:OnSearchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local value = self.inputField:GetText()
  if #value > MAX_AL_NAME_CHAR then
    UIUtil.ShowTipsId(120193)
    return
  end
  self:RefreshList()
end

function LWUIMigrationView_List:OnInputFieldValueChange(_)
  local value = self.inputField:GetText()
  self.inputField_placeholder:SetActive(value == "")
  if MyStrNull(value) then
    self:RefreshList()
    CS.UIGray.SetGray(self.btn_search.transform, true, true)
  elseif #value > MAX_AL_NAME_CHAR then
    CS.UIGray.SetGray(self.btn_search.transform, true, true)
  else
    CS.UIGray.SetGray(self.btn_search.transform, false, true)
  end
end

function LWUIMigrationView_List:IptOnValueChange(_)
  local value = self.inputField:GetText()
  if MyStrNull(value) then
    self:RefreshList()
  end
end

function LWUIMigrationView_List:SetData(serverId)
  base.SetData(self, serverId)
  self.toServerId = serverId or DataCenter.ActMigrationManager.jumpToServerId
  if self.bottom then
    self.bottom:RefreshView()
  end
  self:RefreshTop()
  self:RefreshList()
end

function LWUIMigrationView_List:RefreshTop()
  if self.topInit then
    return
  end
  self.topInit = true
  local openConfig = DataCenter.ActMigrationManager:GetOpenConfig()
  local list = openConfig ~= nil and openConfig.serverList or {}
  local cnt = #list
  self.text_title:SetLocalText("migration_activity_interface_10035", cnt)
  local xMax = self.s_content:GetSizeDeltaXY()
  local count = 0
  local maxCount = 32
  local line = 9
  local curIdx = 0
  local sb = StringBuilder.New()
  local lastOne, hasMore
  for i, v in ipairs(list) do
    count = count + 1
    curIdx = curIdx + 1
    if curIdx == line or i == cnt or count == maxCount then
      curIdx = 0
      local goItem = self.textServerObj:GameObjectSpawn(self.s_content.transform)
      goItem.name = "Sever_" .. i
      local text = self.s_content:AddComponent(UITextMeshProUGUIEx, goItem.name)
      text:SetText(sb:ToString() .. "#" .. v)
      local w = text:GetWidth()
      local bFix = xMax <= w
      if bFix then
        curIdx = 1
        text:SetText(sb:ToString())
      end
      sb:Clear()
      lastOne = text
      if maxCount <= count then
        if bFix then
          hasMore = true
        end
        break
      end
      if not bFix then
        goto lbl_100
      end
    end
    sb:Append("#")
    sb:Append(v)
    sb:Append(" ")
    ::lbl_100::
    if count == maxCount then
      break
    end
  end
  local bShow = (cnt > count or hasMore) and lastOne ~= nil
  self.more_btn:SetActive(bShow)
  self.point:SetActive(bShow)
  if bShow then
    self.point.transform:SetParent(lastOne.transform)
    self.point:SetAnchoredPositionXY(30, 0)
    self.more_btn:SetAsLastSibling()
    self.more_btn:SetOnClick(function()
      self:OnBtnMore()
    end)
  end
  local rtf = self.s_content.rectTransform
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)
  rtf = self.top.rectTransform
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.top.rectTransform)
  local topH = rtf.rect.height
  local baseH = 352
  if topH > baseH then
    local x, y = self.scroll_view:GetOffsetMaxXY()
    y = -topH
    self.scroll_view:SetOffsetMaxXY(x, y)
  end
end

function LWUIMigrationView_List:RefreshList()
  local actMgr = DataCenter.ActMigrationManager
  local actInfo = actMgr:GetActInfo()
  local serverIds = actInfo ~= nil and actInfo.serverIdList or {}
  local inputStr = self.inputField:GetText()
  local searchNum = tonumber(inputStr)
  local checkC = self.toggle_check:GetIsOn()
  local myInfo = actMgr:GetMyInfo()
  local identity = myInfo ~= nil and myInfo.identity or 0
  local myPower = LuaEntry.Player.power
  local myLv = DataCenter.BuildManager.MainLv
  local list = {}
  for _, v in ipairs(serverIds) do
    local sInfo = actMgr:GetServerInfo(v)
    if sInfo ~= nil and (searchNum == nil or searchNum == sInfo.serverId) then
      if checkC then
        local zInfo = actMgr:GetZoneStandard(sInfo.serverState)
        local checkNum, maxNum = 0, 0
        if identity == ActMigrationIdentity.Normal then
          checkNum = sInfo.playerIn
          maxNum = zInfo ~= nil and zInfo.normalNum or 0
        elseif identity == ActMigrationIdentity.High then
          checkNum = sInfo.highPlayerIn
          maxNum = zInfo ~= nil and zInfo.strongNum or 0
        elseif identity == ActMigrationIdentity.Low then
          checkNum = sInfo.lowPlayerIn
          maxNum = zInfo ~= nil and zInfo.lowNum or 0
        elseif identity == ActMigrationIdentity.SuperLow then
          checkNum = sInfo.superLowPlayerIn
          maxNum = zInfo ~= nil and zInfo.superLowNum or 0
        end
        if myLv < sInfo.applyLevel or myPower < sInfo.applyPower or checkNum >= maxNum then
          goto lbl_115
        end
      end
      MyInsert(list, sInfo)
    end
    ::lbl_115::
  end
  self.list = list
  self:CheckCreateList(list)
end

function LWUIMigrationView_List:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.list then
    return nil
  end
  local item = loopScroll:NewListViewItem("Item")
  local script = self.items[item]
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex("Item")
    item.gameObject.name = objectName
    local parent = self.content:AddComponent(UIBaseContainer, objectName)
    script = self:LoadComponentAsync(ListItem_Cls, ListItem_Prefab, parent, function()
      script:SetAnchoredPositionXY(17, 0)
    end)
    self.items[item] = script
  end
  script:SetData(self.list[index])
  return item
end

function LWUIMigrationView_List:CheckCreateList(list)
  local cnt = list ~= nil and #list or 0
  self.scroll_view:SetActive(0 < cnt)
  if cnt == 0 then
    return
  end
  self.scroll_view:SetListItemCount(cnt, false, false)
  self.scroll_view:RefreshAllShownItem()
  self:EndRefresh()
end

function LWUIMigrationView_List:EndRefresh()
  if self.toServerId then
    local to = 1
    for i, v in ipairs(self.list) do
      if v.serverId == self.toServerId then
        to = i
        break
      end
    end
    self.scroll_view:MovePanelToItemIndex(to - 1)
    TimerManager:GetInstance():DelayInvoke(function()
      local sInfo = DataCenter.ActMigrationManager:GetServerInfo(self.toServerId)
      if sInfo then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationRequest, {anim = true}, self.toServerId)
      end
      self.toServerId = nil
      if DataCenter.ActMigrationManager.jumpToServerId then
        DataCenter.ActMigrationManager.jumpToServerId = nil
      end
    end, 0.2)
  end
end

return LWUIMigrationView_List
