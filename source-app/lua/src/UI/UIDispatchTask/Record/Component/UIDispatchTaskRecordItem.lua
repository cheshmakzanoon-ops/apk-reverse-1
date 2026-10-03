local UIDispatchTaskRecordItem = BaseClass("UIDispatchTaskRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local bg_icon_path = "bgIcon"
local txt_time_path = "Txt_Time"
local head_icon_path = "PlayerBtn/UIPlayerHead"
local point_text_path = "pointText"
local scroll_rewards_path = "scrollRewards"
local content_path = "scrollRewards/Viewport/Content"
local emoji_path = "emoji"
local emoji_img_path = "emoji/emojiImg"
local txt_name_path = "Txt_Name"
local txt_steal_path = "Txt_Steal"
local txt_assist_path = "Txt_Assist"

function UIDispatchTaskRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDispatchTaskRecordItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRecordItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.player_btn = self:AddComponent(UIButton, head_icon_path)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_path)
  self.point_text = self:AddComponent(UIText, point_text_path)
  self.scroll_rewards = self:AddComponent(UIScrollRect, scroll_rewards_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.emoji = self:AddComponent(UIImage, emoji_path)
  self.emoji_img = self:AddComponent(UIImage, emoji_img_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_steal = self:AddComponent(UITextMeshProUGUIEx, txt_steal_path)
  self.txt_assist = self:AddComponent(UITextMeshProUGUIEx, txt_assist_path)
  self.txt_steal:SetText(Localization:GetString("dispatch_des027"))
  self.txt_assist:SetText(Localization:GetString("dispatch_des026"))
  self.player_btn:SetOnClick(function()
    self:OnPlayerClick()
  end)
end

function UIDispatchTaskRecordItem:ComponentDestroy()
  self.bg = nil
  self.bg_icon = nil
  self.txt_time = nil
  self.player_btn = nil
  self.head_icon = nil
  self.point_text = nil
  self.scroll_rewards = nil
  self.content = nil
  self.emoji = nil
  self.emoji_img = nil
  self.txt_name = nil
  self.txt_steal = nil
  self.txt_assist = nil
end

function UIDispatchTaskRecordItem:DataDefine()
end

function UIDispatchTaskRecordItem:DataDestroy()
end

function UIDispatchTaskRecordItem:OnAddListener()
  base.OnAddListener(self)
end

function UIDispatchTaskRecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDispatchTaskRecordItem:SetItem(logInfo)
  self.playerUid = nil
  self.point_text:SetActive(false)
  self.serverId = logInfo.serverId or LuaEntry.Player:GetSourceServerId()
  if logInfo == nil then
    return
  end
  local langKey
  local name = logInfo.name
  if not string.IsNullOrEmpty(logInfo.abbr) then
    name = "[" .. logInfo.abbr .. "]" .. name
  end
  local logInfoUid = logInfo.uid
  self.playerUid = logInfoUid
  local fake = false
  if logInfoUid == LuaEntry.Player:GetUid() then
    fake = true
  end
  if fake then
    local fakeKey = DataCenter.ActDispatchTaskDataManager:GetAssistorName()
    if fakeKey then
      name = Localization:GetString(fakeKey)
    end
  end
  local msgId = 59
  if logInfo.type == 0 then
    langKey = 456212
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
    self.txt_name:SetText("<color=#249BC5>" .. name .. "</color>")
    self.txt_assist:SetActive(true)
    self.txt_steal:SetActive(false)
  else
    msgId = logInfo.msgId
    langKey = 456213
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_01")
    self.txt_name:SetText("<color=#F53C3D>" .. name .. "</color>")
    self.txt_assist:SetActive(false)
    self.txt_steal:SetActive(true)
  end
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(logInfo.time))
  if fake then
    local fakeIcon = DataCenter.ActDispatchTaskDataManager:GetAssistorHeadIcon()
    if not string.IsNullOrEmpty(fakeIcon) then
      self.head_icon:SetData(nil, fakeIcon, nil)
    end
  else
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(logInfo.headSkinId, logInfo.headSkinET)
    self.head_icon:SetData(logInfo.uid, logInfo.headPic, logInfo.headPicVer, nil, headFrame)
  end
  self:ShowReward(logInfo.reward)
  self:ShowEmoji(msgId)
end

function UIDispatchTaskRecordItem:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIDispatchTaskRecordItem:ShowReward(reward)
  self:SetAllCellDestroy()
  if reward and type(reward) == "table" and 0 < #reward then
    self.scroll_rewards:SetActive(true)
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
    if self.rewardList then
      self.model = {}
      for i = 1, table.length(self.rewardList) do
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(0.7, 0.7, 0.7)
          local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_sizeDelta(93, 92)
          rectTransform.pivot = Vector2.New(0.5, 0.5)
          go.name = "item" .. i
          local cell = self.content:AddComponent(UICommonResItem, go.name)
          cell:ReInit(self.rewardList[i])
        end)
      end
    end
  else
    self.scroll_rewards:SetActive(false)
  end
end

function UIDispatchTaskRecordItem:ShowEmoji(emojiId)
  if emojiId and 0 < emojiId then
    local data = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
    if data then
      local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
      self.emoji_img:LoadSprite(path)
      self.emoji:SetActive(true)
      return
    end
  end
  self.emoji:SetActive(false)
end

function UIDispatchTaskRecordItem:OnPlayerClick()
  if self.playerUid then
    if self.playerUid == LuaEntry.Player:GetUid() then
      return
    end
    local serverId = LuaEntry.Player:GetSourceServerId()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
      serverId = serverId,
      uid = self.playerUid
    })
  end
end

return UIDispatchTaskRecordItem
