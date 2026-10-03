local UIGhostreconRewardView = BaseClass("UIGhostreconRewardView", UIBaseView)
local base = UIBaseView
local GhostreconTaskCell = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardStealComponent")
local UIGhostreconRewardGroup = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardGroup")
local UIGhostreconRewardMemberGroup = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardMemberGroup")
local UIGhostreconRewardMemberTitle = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardMemberTitle")
local UIGhostreconRewardRecordBtn = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardRecordBtn")
local Localization = CS.GameEntry.Localization
local panel_path = "SpecialBg"
local title_name_path = "SpecialBg/OtherTitleBg/OtherTitleText"
local layout_path = "layout"
local dispatch_task_path = "layout/DispatchTask"
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
local all_scroll_view_path = "AllScrollView"
local content_path = "AllScrollView/Viewport/Content"
local cellDelay = 0.125
local lineCount = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

local function OnDestroy(self)
  if self.param and self.param.CloseFunc then
    self.param.CloseFunc()
  end
  self:ClearAllDataDelay()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetItemPrefabName(self, index)
  local data = self.allDataList[index]
  if data == nil then
    return "UIGhostreconRewardMemberTitle"
  end
  local type = data.type
  if type == "reward" then
    return "UIGhostreconRewardGroup"
  elseif type == "member" then
    return "UIGhostreconRewardMemberGroup"
  elseif type == "recordBtn" then
    return "UIGhostreconRewardRecordBtn"
  end
  return "UIGhostreconRewardMemberTitle"
end

local function GetItemScript(self, index)
  local data = self.allDataList[index]
  if data == nil then
    return UIGhostreconRewardMemberTitle
  end
  local type = data.type
  if type == "reward" then
    return UIGhostreconRewardGroup
  elseif type == "member" then
    return UIGhostreconRewardMemberGroup
  elseif type == "recordBtn" then
    return UIGhostreconRewardRecordBtn
  end
  return UIGhostreconRewardMemberTitle
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

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
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
    self.ghostreconTaskInfo = self:AddComponent(GhostreconTaskCell, dispatch_task_path)
    self.ghostreconTaskInfo:SetActive(false)
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
  self.all_scroll_view = self:AddComponent(UILoopListView2, all_scroll_view_path)
  self.all_scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
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
  self.all_scroll_view = nil
  self.content = nil
end

local function DataDefine(self)
  self.param = nil
  self.nameText = nil
  self.cells = {}
  self.showAnim = true
end

local function DataDestroy(self)
  self.param = nil
  self.nameText = nil
  self.cells = nil
  self.showAnim = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function PlayCellAnim(self)
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

local function SkipCellAnim(self)
  self.showAnim = false
  self.skip_anim_btn.gameObject:SetActive(false)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.param.rewardList)
  self.scroll_view:RefillCells()
  if #self.param.rewardList > lineCount * 2 then
    self.scroll_view:ScrollToCell(#self.param.rewardList - lineCount, 20000)
  end
end

local function SetNameText(self, value)
  if self.nameText ~= value then
    self.nameText = value
    self.title_name:SetText(value)
  end
end

local function OnStealMessageBtnClick(self)
  if self.param.fromGhostreconStealMessage and self.param.recordUuid then
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
        SFSNetwork.SendMessage(MsgDefines.GhostReconLeaveMessage, self.param.recordUuid, msgId, LuaEntry.Player:GetSourceServerId())
        self.stealMessage = true
      end
    end
  end
  self.stealStatus = false
  self:Close()
end

local function ClearAllDataDelay(self)
  if self.allDataDelay then
    self.allDataDelay:Stop()
    self.allDataDelay = nil
  end
  if self.allDataTween then
    self.allDataTween:Kill()
    self.allDataTween = nil
  end
end

local function ClearScroll(self)
  self.cells = {}
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICommonResItem)
  end
  if self.all_scroll_view then
    self.all_scroll_view:ClearAllItems()
  end
  self.content:RemoveComponents(UIGhostreconRewardGroup)
  self.content:RemoveComponents(UIGhostreconRewardMemberGroup)
  self.content:RemoveComponents(UIGhostreconRewardMemberTitle)
  self.content:RemoveComponents(UIGhostreconRewardRecordBtn)
end

local function OnCreateCell(self, itemObj, index)
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
  cellItem.name_text:SetActive(true)
  cellItem:ReInit(param)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ShowCells(self)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.param.rewardList)
  self.scroll_view:RefillCells()
end

local function Close(self)
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

local function ReInit(self)
  self.emojiList = nil
  self.stealStatus = false
  self.stealMessage = false
  if self.param.fromGhostreconStealMessage and self.ghostreconTaskInfo then
    if self.param.fromGhostreconStealMessage then
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
    end
    self.ghostreconTaskInfo:SetActive(true)
    self.ghostreconTaskInfo:ReInit(self.param)
    self:ShowCells()
  else
    if self.ghostreconTaskInfo then
      self.ghostreconTaskInfo:SetActive(false)
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

local function ShowReport(self)
  if self.param then
    local memberList = self.param.memberList
    if memberList and 0 < #memberList then
      local data = {}
      data.type = "memberTitle"
      table.insert(self.allDataList, data)
      local memberCount = #memberList
      local count = math.ceil(memberCount / 4)
      for i = 1, count do
        local data = {}
        data.type = "member"
        data.value = {}
        for j = 1, 4 do
          local index = (i - 1) * 4 + j
          if memberCount >= index then
            memberList[index].thumbsUpIdentifier = index
            Logger.Log("memberList[index].thumbsUpIdentifier" .. memberList[index].thumbsUpIdentifier)
            table.insert(data.value, memberList[index])
          end
        end
        table.insert(self.allDataList, data)
      end
    end
    local stealList = self.param.stealList
    if stealList and 0 < #stealList or memberList and 0 < #memberList then
      local data = {}
      data.type = "recordBtn"
      data.value = self.param
      table.insert(self.allDataList, data)
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
    else
      self.all_scroll_view:SetActive(false)
    end
  end
end

local function ZanAll(self)
  if self.param and self.param.memberList and #self.param.memberList > 0 then
    local number = InteractiveUtil.GetCanThumbsUpCount(InteractiveUtil.ThumbsUpType.GHOST_RECON)
    if number <= 0 then
      UIUtil.ShowTipsId("avatar_tips003")
    else
      UIUtil.ShowTipsId("ghostrecon_090")
      for i, v in ipairs(self.param.memberList) do
        if not v.zan then
          EventManager:GetInstance():Broadcast(EventId.GhostReconZanAll, i)
          number = number - 1
          if number <= 0 then
            break
          end
        end
      end
    end
  end
end

UIGhostreconRewardView.OnCreate = OnCreate
UIGhostreconRewardView.OnDestroy = OnDestroy
UIGhostreconRewardView.OnEnable = OnEnable
UIGhostreconRewardView.OnDisable = OnDisable
UIGhostreconRewardView.ComponentDefine = ComponentDefine
UIGhostreconRewardView.ComponentDestroy = ComponentDestroy
UIGhostreconRewardView.DataDefine = DataDefine
UIGhostreconRewardView.DataDestroy = DataDestroy
UIGhostreconRewardView.OnAddListener = OnAddListener
UIGhostreconRewardView.OnRemoveListener = OnRemoveListener
UIGhostreconRewardView.PlayCellAnim = PlayCellAnim
UIGhostreconRewardView.SkipCellAnim = SkipCellAnim
UIGhostreconRewardView.SetNameText = SetNameText
UIGhostreconRewardView.OnStealMessageBtnClick = OnStealMessageBtnClick
UIGhostreconRewardView.ClearAllDataDelay = ClearAllDataDelay
UIGhostreconRewardView.ClearScroll = ClearScroll
UIGhostreconRewardView.OnCreateCell = OnCreateCell
UIGhostreconRewardView.OnDeleteCell = OnDeleteCell
UIGhostreconRewardView.ShowCells = ShowCells
UIGhostreconRewardView.Close = Close
UIGhostreconRewardView.ReInit = ReInit
UIGhostreconRewardView.ShowReport = ShowReport
UIGhostreconRewardView.GetItemPrefabName = GetItemPrefabName
UIGhostreconRewardView.GetItemScript = GetItemScript
UIGhostreconRewardView.OnGetItemByIndex = OnGetItemByIndex
UIGhostreconRewardView.ZanAll = ZanAll
return UIGhostreconRewardView
