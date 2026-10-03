local UIGhostParkourChallengeResultView = BaseClass("UIGhostParkourChallengeResultView", UIBaseView)
local base = UIBaseView
local UIGhostParkourSettleTopItem = require("UI.UIGhostParkour.Inside.Result.Component.UIGhostParkourSettleTopItem")
local top_root_path = "SafeArea/TopRoot"
local emoji_show_root_path = "SafeArea/CenterRoot/EmojiShowRoot"
local player_path = "SafeArea/CenterRoot/EmojiShowRoot/player"
local user_name_path = "SafeArea/CenterRoot/EmojiShowRoot/userName"
local emoji_icon1_path = "SafeArea/CenterRoot/EmojiShowRoot/TipRoot/TipBoxHappy/EmojiIcon1"
local emoji_icon2_path = "SafeArea/CenterRoot/EmojiShowRoot/TipRoot/TipBoxHappy/EmojiIcon2"
local emoji_icon3_path = "SafeArea/CenterRoot/EmojiShowRoot/TipRoot/TipBoxHappy/EmojiIcon3"
local steal_emoji1_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji1"
local emoji_img1_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji1/emojiImg1"
local steal_emoji2_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji2"
local emoji_img2_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji2/emojiImg2"
local steal_emoji3_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji3"
local emoji_img3_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji3/emojiImg3"
local steal_emoji4_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji4"
local emoji_img4_path = "SafeArea/CenterRoot/StealNode/StealEmojiNode/stealEmoji4/emojiImg4"
local tip_text_path = "SafeArea/CenterRoot/StealNode/TipText"
local bg_path = "SafeArea/Bg"
local send_message_btn_path = "SafeArea/CenterRoot/StealNode/BtnRoot/SendMessageBtn"
local send_message_btn_text_path = "SafeArea/CenterRoot/StealNode/BtnRoot/SendMessageBtn/SendMessageBtnText"
local safe_area_path = "SafeArea"

function UIGhostParkourChallengeResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIGhostParkourChallengeResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourChallengeResultView:ComponentDefine()
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.top_root = self:AddComponent(UIGhostParkourSettleTopItem, top_root_path)
  self.emoji_show_root = self:AddComponent(UICanvasGroup, emoji_show_root_path)
  self.emoji_show_root:SetActive(false)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.player:SetEnableClickShowInfo(false)
  self.user_name = self:AddComponent(UITextMeshProUGUIEx, user_name_path)
  self.emoji_icon1 = self:AddComponent(UIImage, emoji_icon1_path)
  self.emoji_icon2 = self:AddComponent(UIImage, emoji_icon2_path)
  self.emoji_icon3 = self:AddComponent(UIImage, emoji_icon3_path)
  self.steal_emoji1 = self:AddComponent(UIToggle, steal_emoji1_path)
  self.steal_emoji1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleSelected(1)
    end
  end)
  self.emoji_img1 = self:AddComponent(UIImage, emoji_img1_path)
  self.steal_emoji2 = self:AddComponent(UIToggle, steal_emoji2_path)
  self.steal_emoji2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleSelected(2)
    end
  end)
  self.emoji_img2 = self:AddComponent(UIImage, emoji_img2_path)
  self.steal_emoji3 = self:AddComponent(UIToggle, steal_emoji3_path)
  self.steal_emoji3:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleSelected(3)
    end
  end)
  self.emoji_img3 = self:AddComponent(UIImage, emoji_img3_path)
  self.steal_emoji4 = self:AddComponent(UIToggle, steal_emoji4_path)
  self.steal_emoji4:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleSelected(4)
    end
  end)
  self.emoji_img4 = self:AddComponent(UIImage, emoji_img4_path)
  self.emojiIconList = {}
  table.insert(self.emojiIconList, self.emoji_icon1)
  table.insert(self.emojiIconList, self.emoji_icon2)
  table.insert(self.emojiIconList, self.emoji_icon3)
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
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.tip_text:SetLocalText("ghost_parkour_close_desc")
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(BindCallback(self, self.OnBackBtnClick))
  self.send_message_btn = self:AddComponent(UIButton, send_message_btn_path)
  self.send_message_btn:SetOnClick(BindCallback(self, self.OnSendMessageBtnClick))
  self.send_message_btn_text = self:AddComponent(UITextMeshProUGUIEx, send_message_btn_text_path)
  self.send_message_btn_text:SetLocalText("ghost_parkour_message_btn")
  self.safe_area = self:AddComponent(UIBaseContainer, safe_area_path)
  self.safe_area:SetActive(false)
end

function UIGhostParkourChallengeResultView:ComponentDestroy()
  if self.topRootTimer ~= nil then
    self.topRootTimer:Stop()
    self.topRootTimer = nil
  end
  if self.emojiTimer ~= nil then
    self.emojiTimer:Stop()
    self.emojiTimer = nil
  end
  self.rootAnim = nil
  self.top_root = nil
  self.emoji_show_root = nil
  self.player = nil
  self.user_name = nil
  self.emoji_icon1 = nil
  self.emoji_icon2 = nil
  self.emoji_icon3 = nil
  self.emojiIconList = nil
  self.emojiToggleList = nil
  self.emojiImgList = nil
  self.tip_text = nil
  self.bg = nil
  self.steal_message_btn = nil
  self.send_message_btn_text = nil
  self.safe_area = nil
end

function UIGhostParkourChallengeResultView:DataDefine()
  self.message = nil
  self.isSendMsg = nil
end

function UIGhostParkourChallengeResultView:DataDestroy()
  self.message = nil
  self.isSendMsg = nil
end

function UIGhostParkourChallengeResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourOnEndAnimFinished, self.ShowPanel)
end

function UIGhostParkourChallengeResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourOnEndAnimFinished, self.ShowPanel)
  base.OnRemoveListener(self)
end

function UIGhostParkourChallengeResultView:InitView()
  local message = self:GetUserData()
  if message == nil or message.errorCode ~= nil then
    Logger.LogInfo("GhostParkour -- [InitView] message error")
    return
  end
  if message.fightType ~= 2 then
    Logger.LogInfo("GhostParkour -- [InitView] fightType error")
    return
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic == nil or message.uuid ~= logic:GetUuid() then
    return
  end
  self.message = message
  local isChallengeWin = message.isChallengeWin
  local rank = 1
  if not isChallengeWin then
    rank = 2
  end
  self.top_root:InitView(message, rank)
  local player = LuaEntry.Player
  local uid = player:GetUid()
  local pic = player:GetPic()
  local picVer = player:GetPicVer()
  self.player:SetHead(uid, pic, picVer, nil, nil)
  local name = player:GetFullName()
  self.user_name:SetText(name)
  self:InitEmojiPanel()
  logic:SaveLog(function(uuid, succeed)
    DataCenter.LWGhostParkourDataManager:ReqSyncChallengeInfo(uuid, succeed)
  end)
  if logic.showEndPanel then
    self:ShowPanel()
  end
end

function UIGhostParkourChallengeResultView:InitEmojiPanel()
  local selectedEmoji
  local emojiList = DataCenter.LWGhostParkourDataManager:GetEmojiConfigList()
  if emojiList then
    self.emojiList = {}
    table.insertto(self.emojiList, emojiList)
    for i, img in ipairs(self.emojiImgList) do
      local data = self.emojiList[i]
      if data then
        local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
        img:LoadSpriteAuto(path)
        self.emojiToggleList[i]:SetActive(true)
        if selectedEmoji == nil then
          selectedEmoji = i
          self.emojiToggleList[i]:SetIsOn(true)
          self:OnToggleSelected(i)
        end
      else
        self.emojiToggleList[i]:SetActive(false)
      end
    end
  end
  self.selectedIndex = selectedEmoji
end

function UIGhostParkourChallengeResultView:OnToggleSelected(index)
  self.selectedIndex = index
end

function UIGhostParkourChallengeResultView:SetEmojiImgData()
  local emojiList = self.emojiList
  if self.selectedIndex and emojiList then
    if self.emojiImgList then
      local img = self.emojiImgList[self.selectedIndex]
      if img then
        local sprite = img:GetImage()
        if sprite then
          for _, v in ipairs(self.emojiIconList) do
            if v then
              v:SetImage(sprite)
            end
          end
          return
        end
      end
    end
    local data = emojiList[self.selectedIndex]
    if data then
      local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
      for _, v in ipairs(self.emojiIconList) do
        if v then
          v:LoadSpriteAuto(path)
        end
      end
    end
  end
end

function UIGhostParkourChallengeResultView:OnSendMessageBtnClick()
  if self.isSendMsg and self.ctrl then
    self.ctrl:CloseSelf()
    DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
    return
  end
  local emojiList = self.emojiList
  if self.selectedIndex == nil or self.selectedIndex == 0 then
    self.selectedIndex = 1
  end
  if self.message and self.selectedIndex and self.selectedIndex > 0 and emojiList then
    local data = emojiList[self.selectedIndex]
    if data then
      local msgId = data.id
      local message = self.message
      local challengeInfo = message.challengeInfo
      if challengeInfo then
        self.isSendMsg = true
        DataCenter.LWGhostParkourDataManager:ReqSendRecordEmoji(msgId, message.ownerRecordUuid, challengeInfo.uid, message.targetRecordUuid)
      end
    end
  end
  self:ShowEmojiImg()
end

function UIGhostParkourChallengeResultView:OnBackBtnClick()
  if not self.isSendMsg then
    self:OnSendMessageBtnClick()
    return
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
    DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
  end
end

function UIGhostParkourChallengeResultView:ShowPanel()
  self.safe_area:SetActive(true)
  self.rootAnim:Play("V_ui_UIGhostParkourChallengeResult_in", 0, 0)
  local ret = self.top_root:PlayPanelAnim()
  if ret then
    self.topRootTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.topRootTimer ~= nil then
        self.topRootTimer:Stop()
        self.topRootTimer = nil
      end
      self.rootAnim:Play("V_ui_UIGhostParkourChallengeResult_btn", 0, 0)
    end, 0.4)
  end
end

function UIGhostParkourChallengeResultView:ShowEmojiImg()
  self:SetEmojiImgData()
  self.emoji_show_root:SetActive(true)
  local result, duration = self.rootAnim:PlayAnimationReturnTime("V_ui_UIGhostParkourChallengeResult_Emoji")
  if result then
    if self.emojiTimer then
      self.emojiTimer:Stop()
    end
    self.emojiTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.emojiTimer ~= nil then
        self.emojiTimer:Stop()
        self.emojiTimer = nil
      end
      if self.ctrl then
        self.ctrl:CloseSelf()
        DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
      end
    end, duration + 1.5)
  end
end

return UIGhostParkourChallengeResultView
