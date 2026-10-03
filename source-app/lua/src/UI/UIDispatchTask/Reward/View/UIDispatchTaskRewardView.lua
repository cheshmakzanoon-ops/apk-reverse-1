local UIDispatchTaskRewardView = BaseClass("UIDispatchTaskRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDispatchTaskRecordItem = require("UI.UIDispatchTask.Record.Component.UIDispatchTaskRecordItem")
local UIDispatchTaskRecordItemNew = require("UI.UIDispatchTask.RecordNew.Component.UIDispatchTaskRecordItemNew")
local DispatchTaskCell = require("UI.UIDispatchTask.Reward.Component.UIDispatchTaskRewardStealComponent")
local UIDispatchTaskRewardReportTitleComponent = require("UI.UIDispatchTask.Reward.Component.UIDispatchTaskRewardReportTitleComponent")
local UIDispatchTaskRewardGroupComponent = require("UI.UIDispatchTask.Reward.Component.UIDispatchTaskRewardGroupComponent")
local UIGuidePioneerHeroExpCell = require("UI.UIPVE.UIPVEResult.Component.UIGuidePioneerHeroExpCell")
local panel_path = "SpecialBg"
local title_name_path = "SpecialBg/OtherTitleBg/OtherTitleText"
local layout_path = "layout"
local dispatch_task_path = "layout/DispatchTask"
local hero_list_path = "layout/heroList"
local scroll_view_path = "layout/CellList"
local skip_anim_btn_path = "SkipAnimButton"
local steal_node_path = "layout/StealNode"
local steal_message_btn_path = "layout/StealNode/StealMessageBtn"
local steal_message_btn_text_path = "layout/StealNode/StealMessageBtn/StealMessageBtnText"
local steal_emoji_node_path = "layout/StealNode/StealEmojiNode"
local steal_emoji1_path = "layout/StealNode/StealEmojiNode/stealEmoji1"
local emoji_img1_path = "layout/StealNode/StealEmojiNode/stealEmoji1/emojiImg1"
local steal_emoji2_path = "layout/StealNode/StealEmojiNode/stealEmoji2"
local emoji_img2_path = "layout/StealNode/StealEmojiNode/stealEmoji2/emojiImg2"
local steal_emoji3_path = "layout/StealNode/StealEmojiNode/stealEmoji3"
local emoji_img3_path = "layout/StealNode/StealEmojiNode/stealEmoji3/emojiImg3"
local steal_emoji4_path = "layout/StealNode/StealEmojiNode/stealEmoji4"
local emoji_img4_path = "layout/StealNode/StealEmojiNode/stealEmoji4/emojiImg4"
local steal_tip_path = "layout/StealNode/StealTip"
local report_node_path = "layout/ReportNode"
local report_title_path = "layout/ReportNode/ReportTitle"
local report_scroll_view_path = "layout/ReportNode/ReportScrollView"
local perfect_node_path = "layout/ReportNode/perfectNode"
local assist_item_path = "layout/ReportNode/perfectNode/assistItem"
local perfect_show_path = "layout/ReportNode/perfectNode/perfectShow"
local all_scroll_view_path = "AllScrollView"
local content_path = "AllScrollView/Viewport/Content"
local ui_common_res_item_path = "CellGo/UICommonResItem"
local btn_all_path = "btnLikeAll"
local cellDelay = 0.125
local lineCount = 4

function UIDispatchTaskRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  if self.param.heroExp ~= nil then
    self.heroList:SetActive(true)
  else
    self.heroList:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIDispatchTaskRewardView:OnDestroy()
  if self.param and self.param.CloseFunc then
    self.param.CloseFunc()
  end
  self:ClearAllDataDelay()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRewardView:GetItemPrefabName(index)
  local data = self.allDataList[index]
  if data == nil then
    return "UIDispatchTaskReportTitle"
  end
  local type = data.type
  if type == "reward" then
    return "UIDispatchTaskRewardGroup"
  elseif type == "report" then
    if LuaEntry.DataConfig:CheckSwitch("secret_team_information") then
      return "UIDispatchTaskRecordItemNew"
    else
      return "UIDispatchTaskRecordItem"
    end
  end
  return "UIDispatchTaskReportTitle"
end

function UIDispatchTaskRewardView:GetItemScript(index)
  local data = self.allDataList[index]
  if data == nil then
    return UIDispatchTaskRewardReportTitleComponent
  end
  local type = data.type
  if type == "reward" then
    return UIDispatchTaskRewardGroupComponent
  elseif type == "report" then
    if LuaEntry.DataConfig:CheckSwitch("secret_team_information") then
      return UIDispatchTaskRecordItemNew
    else
      return UIDispatchTaskRecordItem
    end
  end
  return UIDispatchTaskRewardReportTitleComponent
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.allDataList then
    return nil
  end
  local data = self.allDataList[index]
  local prefabName = self:GetItemPrefabName(index)
  local itemScript = self:GetItemScript(index)
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  if script.SetItem then
    script:SetItem(data.value)
  end
  return item
end

function UIDispatchTaskRewardView:ComponentDefine()
  self.ui_common_res_item = self:AddComponent(UICanvasGroup, ui_common_res_item_path)
  self.ui_common_res_item:SetActive(false)
  self.btnAll = self:AddComponent(UIButton, btn_all_path)
  self.btnAll:SetOnClick(function()
    self:BtnAllOnClick()
  end)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.heroList = self:AddComponent(UIBaseContainer, hero_list_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window and window.Ctrl:IsVisible() then
      local cfg = {}
      for i, v in ipairs(self.cells) do
        if v and not IsNull(v.transform) then
          table.insert(cfg, {
            v.transform.position,
            self.param.rewardList[i]
          })
        end
      end
      EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
    end
    self:Close()
  end)
  self.skip_anim_btn = self:AddComponent(UIButton, skip_anim_btn_path)
  self.skip_anim_btn.gameObject:SetActive(false)
  self.skip_anim_btn:SetOnClick(function()
    self:SkipCellAnim()
    self:Close()
  end)
  if self.transform:Find(dispatch_task_path) ~= nil then
    self.dispatchTaskInfo = self:AddComponent(DispatchTaskCell, dispatch_task_path)
    self.dispatchTaskInfo:SetActive(false)
  end
  self.steal_node = self:AddComponent(UIImage, steal_node_path)
  self.steal_message_btn = self:AddComponent(UIButton, steal_message_btn_path)
  self.steal_message_btn_text = self:AddComponent(UITextMeshProUGUIEx, steal_message_btn_text_path)
  self.steal_emoji_node = self:AddComponent(UIBaseContainer, steal_emoji_node_path)
  self.steal_emoji1 = self:AddComponent(UIToggle, steal_emoji1_path)
  self.emoji_img1 = self:AddComponent(UIImage, emoji_img1_path)
  self.steal_emoji2 = self:AddComponent(UIToggle, steal_emoji2_path)
  self.emoji_img2 = self:AddComponent(UIImage, emoji_img2_path)
  self.steal_emoji3 = self:AddComponent(UIToggle, steal_emoji3_path)
  self.emoji_img3 = self:AddComponent(UIImage, emoji_img3_path)
  self.steal_emoji4 = self:AddComponent(UIToggle, steal_emoji4_path)
  self.emoji_img4 = self:AddComponent(UIImage, emoji_img4_path)
  self.steal_tip = self:AddComponent(UITextMeshProUGUIEx, steal_tip_path)
  self.steal_message_btn_text:SetText(Localization:GetString("dispatch_des024"))
  self.steal_tip:SetText(Localization:GetString("dispatch_des039"))
  self.emojiToggleList = {}
  table.insert(self.emojiToggleList, self.steal_emoji1)
  table.insert(self.emojiToggleList, self.steal_emoji2)
  table.insert(self.emojiToggleList, self.steal_emoji3)
  table.insert(self.emojiToggleList, self.steal_emoji4)
  self.emojiImgList = {}
  table.insert(self.emojiImgList, self.emoji_img1)
  table.insert(self.emojiImgList, self.emoji_img2)
  table.insert(self.emojiImgList, self.emoji_img3)
  table.insert(self.emojiImgList, self.emoji_img4)
  self.steal_node:SetActive(false)
  self.steal_message_btn:SetOnClick(function()
    self:OnStealMessageBtnClick()
  end)
  self.report_node = self:AddComponent(UIBaseContainer, report_node_path)
  self.report_title = self:AddComponent(UITextMeshProUGUIEx, report_title_path)
  self.report_scroll_view = self:AddComponent(UIScrollView, report_scroll_view_path)
  self.perfect_node = self:AddComponent(UIBaseContainer, perfect_node_path)
  self.assist_item = self:AddComponent(UIDispatchTaskRecordItem, assist_item_path)
  self.perfect_show = self:AddComponent(UIBaseContainer, perfect_show_path)
  self.report_node:SetActive(false)
  self.perfect_node:SetActive(false)
  self.assist_item:SetActive(false)
  self.report_title:SetText(Localization:GetString("dispatch_des025"))
  self.report_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateRecordCell(itemObj, index)
  end)
  self.report_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteRecordCell(itemObj, index)
  end)
  self.all_scroll_view = self:AddComponent(UILoopListView2, all_scroll_view_path)
  self.all_scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btnAll.gameObject:SetActive(false)
end

function UIDispatchTaskRewardView:ComponentDestroy()
  self.ui_common_res_item = nil
  self.btn = nil
  self.title_name = nil
  self.scroll_view = nil
  self.skip_anim_btn = nil
  self.steal_node = nil
  self.steal_message_btn = nil
  self.steal_message_btn_text = nil
  self.steal_emoji_node = nil
  self.steal_emoji1 = nil
  self.emoji_img1 = nil
  self.steal_emoji2 = nil
  self.emoji_img2 = nil
  self.steal_emoji3 = nil
  self.emoji_img3 = nil
  self.steal_emoji4 = nil
  self.emoji_img4 = nil
  self.steal_tip = nil
  self.btnAll = nil
  self.report_node = nil
  self.report_title = nil
  self.report_scroll_view = nil
  self.perfect_node = nil
  self.assist_item = nil
  self.perfect_show = nil
  self.all_scroll_view = nil
  self.content = nil
end

function UIDispatchTaskRewardView:DataDefine()
  self.param = nil
  self.nameText = nil
  self.cells = {}
  self.showAnim = true
  self.reportList = nil
end

function UIDispatchTaskRewardView:DataDestroy()
  self.param = nil
  self.nameText = nil
  self.cells = nil
  self.showAnim = nil
end

function UIDispatchTaskRewardView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UIDispatchTaskRewardView:OnDisable()
  base.OnDisable(self)
end

function UIDispatchTaskRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnWorldInputPointDown, self.OnPointDown)
  self:AddUIListener(EventId.DispatchTaskGetThumbsUp, self.UpdateAllList)
end

function UIDispatchTaskRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnWorldInputPointDown, self.OnPointDown)
  self:RemoveUIListener(EventId.DispatchTaskGetThumbsUp, self.UpdateAllList)
  base.OnRemoveListener(self)
end

function UIDispatchTaskRewardView:OnPointDown()
  if self.allDataTween then
    self.allDataTween:Kill()
    self.allDataTween = nil
  end
end

function UIDispatchTaskRewardView:ReInit()
  self.emojiList = nil
  self.stealStatus = false
  self.stealMessage = false
  if (self.param.fromDispatchStealMessage or self.param.fromDispatchAssistMessage) and self.dispatchTaskInfo and self.param.ownerInfo then
    if self.param.fromDispatchStealMessage then
      self:SetNameText(Localization:GetString("456287"))
      self.steal_node:SetActive(true)
      self.steal_emoji1:SetIsOn(true)
      self.stealStatus = true
      local selectedEmoji
      local emojiList = DataCenter.ActDispatchTaskDataManager:GetStealEmojiList(true)
      self.emojiList = {}
      table.insertto(self.emojiList, emojiList)
      for i, img in ipairs(self.emojiImgList) do
        local data = self.emojiList[i]
        if data then
          local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
          img:LoadSprite(path)
          self.emojiToggleList[i]:SetActive(true)
          if selectedEmoji == nil then
            selectedEmoji = i
            self.emojiToggleList[i]:SetIsOn(true)
          end
        else
          self.emojiToggleList[i]:SetActive(false)
        end
      end
    elseif self.param.fromDispatchAssistMessage then
      self:SetNameText(Localization:GetString("456286"))
      self.steal_node:SetActive(false)
    end
    self.report_node:SetActive(false)
    self.dispatchTaskInfo:SetActive(true)
    self.dispatchTaskInfo:ReInit(self.param)
    self:ShowCells()
  else
    if self.dispatchTaskInfo then
      self.dispatchTaskInfo:SetActive(false)
    end
    self.steal_node:SetActive(false)
    self:SetNameText(Localization:GetString("128027"))
    self.allDataList = {}
    local rewardCount = #self.param.rewardList
    if 0 < rewardCount then
      local count = math.ceil(rewardCount / 4)
      for i = 1, count do
        local data = {}
        data.type = "reward"
        data.value = {}
        for j = 1, 4 do
          local index = (i - 1) * 4 + j
          if rewardCount >= index then
            table.insert(data.value, self.param.rewardList[index])
          end
        end
        table.insert(self.allDataList, data)
      end
    end
    self:ShowReport()
  end
end

function UIDispatchTaskRewardView:UpdateAllList(uuid)
  if not table.IsNullOrEmpty(self.allDataList) then
    for _, v in ipairs(self.allDataList or {}) do
      if v.type == "report" and v.value.uuid == uuid then
        v.value.isLike = 1
      end
    end
  end
  self.needLikeList = DataCenter.ActDispatchTaskDataManager:GetNeedThumbsUpList(self.allDataList)
  self.btnAll.gameObject:SetActive(#self.needLikeList > 0)
end

function UIDispatchTaskRewardView:ShowReport()
  local initReport = false
  if self.param.data then
    local stealInfoList = self.param.data.stealInfoList
    if stealInfoList and 0 < #stealInfoList then
      for _, v in ipairs(stealInfoList) do
        if v.type == nil then
          v.type = 1
        end
        if not initReport then
          initReport = true
          local data = {}
          data.type = "reportTitle"
          table.insert(self.allDataList, data)
        end
        local data = {}
        data.type = "report"
        data.value = v
        table.insert(self.allDataList, data)
      end
    end
    local assistInfo = self.param.data.assistInfo
    if assistInfo and assistInfo.uid then
      if assistInfo.type == nil then
        assistInfo.type = 0
      end
      if not initReport then
        initReport = true
        local data = {}
        data.type = "reportTitle"
        table.insert(self.allDataList, data)
      end
      local data = {}
      data.type = "report"
      data.value = assistInfo
      table.insert(self.allDataList, data)
    end
    local assistInfoList = self.param.data.assistInfoList
    if assistInfoList and 0 < #assistInfoList then
      for _, v in ipairs(assistInfoList) do
        if v.type == nil then
          v.type = 0
        end
        if not initReport then
          initReport = true
          local data = {}
          data.type = "reportTitle"
          table.insert(self.allDataList, data)
        end
        local data = {}
        data.type = "report"
        data.value = v
        table.insert(self.allDataList, data)
      end
    end
    if 0 < #self.allDataList then
      self.all_scroll_view:SetActive(true)
      self.all_scroll_view:StopMovement()
      self.all_scroll_view:SetListItemCount(#self.allDataList, false, false)
      self.all_scroll_view:RefreshAllShownItem()
      self:ClearAllDataDelay()
      self.allDataDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.allDataDelay = nil
        if self.all_scroll_view then
          local scrollRect = self.all_scroll_view.unity_looplistview2.ScrollRect
          if scrollRect and scrollRect.verticalNormalizedPosition > 0.1 then
            self.allDataTween = scrollRect:DOVerticalNormalizedPos(0, 3)
          end
        end
      end, 0.5)
      if LuaEntry.DataConfig:CheckSwitch("secret_team_information") then
        self.needLikeList = DataCenter.ActDispatchTaskDataManager:GetNeedThumbsUpList(self.allDataList)
        self.btnAll.gameObject:SetActive(#self.needLikeList > 0)
      else
        self.btnAll.gameObject:SetActive(false)
      end
    else
      self.all_scroll_view:SetActive(false)
      self.btnAll.gameObject:SetActive(false)
    end
  end
end

function UIDispatchTaskRewardView:ClearAllDataDelay()
  if self.allDataDelay then
    self.allDataDelay:Stop()
    self.allDataDelay = nil
  end
  if self.allDataTween then
    self.allDataTween:Kill()
    self.allDataTween = nil
  end
end

function UIDispatchTaskRewardView:ClearScroll()
  self.cells = {}
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICommonResItem)
  end
  if self.heroList then
    self.heroList:RemoveComponents(UIGuidePioneerHeroExpCell)
  end
  if self.all_scroll_view then
    self.all_scroll_view:ClearAllItems()
  end
  self.content:RemoveComponents(UIDispatchTaskRewardGroupComponent)
  self.content:RemoveComponents(UIDispatchTaskRewardReportTitleComponent)
  self.content:RemoveComponents(UIDispatchTaskRecordItem)
  self.content:RemoveComponents(UIDispatchTaskRecordItemNew)
end

function UIDispatchTaskRewardView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  local rewardParam = self.param.rewardList[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  cellItem:SetActive(true)
  cellItem.name_text:SetActive(true)
  cellItem:ReInit(param)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

function UIDispatchTaskRewardView:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIDispatchTaskRewardView:ShowCells()
  self:ClearScroll()
  if self.param.heroExp ~= nil then
    for _, heroExpInfo in ipairs(self.param.heroExp) do
      self:AddHeroExpObj(heroExpInfo)
    end
  end
  self.scroll_view:SetTotalCount(#self.param.rewardList)
  self.scroll_view:RefillCells()
end

function UIDispatchTaskRewardView:AddHeroExpObj(heroExpInfo)
  self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.heroList.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    go.name = tostring(heroExpInfo.heroUuid)
    local itemObj = self.heroList:AddComponent(UIGuidePioneerHeroExpCell, go.name)
    itemObj:InitData(heroExpInfo)
  end)
end

function UIDispatchTaskRewardView:PlayCellAnim()
  local seq = DOTween.Sequence()
  for index = 1, #self.param.rewardList do
    seq:AppendInterval(cellDelay):AppendCallback(function()
      if self.showAnim then
        local cell = self.cells[index]
        if not cell then
          return
        end
        if index > lineCount and #self.param.rewardList > lineCount then
          self.scroll_view:ScrollToCell(index, 750)
        end
        if index == #self.param.rewardList then
          self.skip_anim_btn.gameObject:SetActive(false)
          self.showAnim = false
        end
      end
    end)
  end
end

function UIDispatchTaskRewardView:SkipCellAnim()
  self.showAnim = false
  self.skip_anim_btn.gameObject:SetActive(false)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.param.rewardList)
  self.scroll_view:RefillCells()
  if #self.param.rewardList > lineCount * 2 then
    self.scroll_view:ScrollToCell(#self.param.rewardList - lineCount, 20000)
  end
end

function UIDispatchTaskRewardView:SetNameText(value)
  if self.nameText ~= value then
    self.nameText = value
    self.title_name:SetText(value)
  end
end

function UIDispatchTaskRewardView:OnStealMessageBtnClick()
  if self.param.fromDispatchStealMessage and self.param.recordUuid then
    local selectIndex = 0
    for i, toggle in ipairs(self.emojiToggleList) do
      if toggle:GetIsOn() then
        selectIndex = i
        break
      end
    end
    if 0 < selectIndex and self.emojiList then
      local emojiList = self.emojiList
      local data = emojiList[selectIndex]
      if data then
        local msgId = data.id
        local targetServer = checknumber(self.param.targetServer)
        if targetServer == 0 then
          targetServer = LuaEntry.Player:GetCurServerId()
        end
        SFSNetwork.SendMessage(MsgDefines.DispatchLeaveMessage, self.param.recordUuid, msgId, targetServer)
        self.stealMessage = true
      end
    end
  end
  self.stealStatus = false
  self:Close()
end

function UIDispatchTaskRewardView:OnCreateRecordCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.report_scroll_view:AddComponent(UIDispatchTaskRecordItem, itemObj)
  local logInfo = self.reportList[index]
  cellItem:SetItem(logInfo)
end

function UIDispatchTaskRewardView:OnDeleteRecordCell(itemObj, index)
  self.report_scroll_view:RemoveComponent(itemObj.name, UIDispatchTaskRecordItem)
end

function UIDispatchTaskRewardView:ClearRecordScroll()
  self.report_scroll_view:ClearCells()
  self.report_scroll_view:RemoveComponents(UIDispatchTaskRecordItem)
end

function UIDispatchTaskRewardView:Close()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIDispatchTaskRewardView:BtnAllOnClick()
  if #self.needLikeList > 0 then
    for key, value in ipairs(self.needLikeList) do
      local index = key
      local record = value
      if record and record.value.uid and record.value.uuid then
        InteractiveUtil.TryThumbsUp(tostring(record.value.uid), InteractiveUtil.ThumbsUpType.DispatchRecordLike, nil, function()
          DataCenter.ActDispatchTaskDataManager:UpdateRecordList(record.value.type, record.value.uuid)
          if index == 1 then
            UIUtil.ShowTipsId("secret_task_like_tips_01")
          end
        end, tostring(record.value.uuid))
      end
    end
    self.btnAll.gameObject:SetActive(false)
  end
end

return UIDispatchTaskRewardView
