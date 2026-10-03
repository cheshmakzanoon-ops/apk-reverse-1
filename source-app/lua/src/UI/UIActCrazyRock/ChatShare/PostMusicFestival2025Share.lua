local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local base = IChatItem
local PostMusicFestival2025Share = BaseClass("PostMusicFestival2025Share", base)
local M = PostMusicFestival2025Share
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Content/UIPlayerHead")
  self.textPlayerName = self:AddComponent(UITextMeshProUGUIEx, "Content/PlayerNameText")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "Content/DesText")
  self.btnLike = self:AddComponent(UIButton, "Content/LikeBg")
  self.btnLike:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
  self.pop_anim_root = self:AddComponent(UICanvasGroup, "Content/LikeBg/status/like/icon/PopAnim")
  self.pop_anim_text = self:AddComponent(UITextMeshProUGUIEx, "Content/LikeBg/status/like/icon/PopAnim/PopAnimText")
  self.theHeartPopAnim = self.pop_anim_root.gameObject
  self.heart = self:AddComponent(UIButton, "Content/LikeBg/status/like/icon")
  self.pop_anim_root:SetActive(false)
  self.theHeartPopAnim:GameObjectCreatePool()
end

function M:ComponentDestroy()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.theHeartPopAnim:GameObjectRecycleAll()
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textDes = nil
  self.btnLike = nil
  self.pop_anim_root = nil
  self.pop_anim_text = nil
  self.theHeartPopAnim = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
end

function M:UpdateItem(chatData, _index)
  if chatData == nil then
    return
  end
  self.chatData = chatData
  self.textPlayerName:SetText("")
  self.textDes:SetText("")
  if chatData.senderUid then
    self:UpdatePlayerHeadAndName(chatData.senderUid)
  end
  if chatData.attachmentId then
    local jsonObj = rapidjson.decode(chatData.attachmentId)
    if jsonObj then
      local scoreStr = string.format("<size=33>%s</size>", jsonObj.score)
      local advancePercentStr = string.format("<size=33>%s</size>", jsonObj.advancePercent)
      self.textDes:SetText(Localization:GetString("activity_concert_31", scoreStr, advancePercentStr))
    end
  end
end

function M:UpdatePlayerHeadAndName(uid)
  if uid == self.chatData.senderUid then
    local userinfo = ChatInterface.getUserData(uid, true)
    if userinfo ~= nil then
      local userPic = userinfo.headPic or ""
      local userPicVer = userinfo.headPicVer or 0
      local headSkinId = userinfo.headSkinId or 0
      local headSkinET = userinfo.headSkinET or 0
      self.compUIPlayerHead:ShowLoadingAinmation()
      self.compUIPlayerHead:SetCustomLoadCallback(function()
        self.compUIPlayerHead:HideLoadingAinmation()
      end)
      self.compUIPlayerHead:SetHeadAndFrame(uid, userPic, userPicVer, nil, headSkinId, headSkinET)
      local userName = userinfo.userName or ""
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.chatData.senderUid, userName)
      self.textPlayerName:SetText(showName)
    end
  end
end

function M:OnBtnLikeClick()
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.MusicFestival2025_ScoreRank) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  self:ShowClickEffect()
  InteractiveUtil.TryThumbsUp(self.chatData.senderUid, InteractiveUtil.ThumbsUpType.MusicFestival2025_ScoreRank, self.chatData.seqId, function()
  end)
end

function M:ShowClickEffect()
  local effectItem = self.theHeartPopAnim:GameObjectSpawn(self.heart.transform)
  local textTrans = effectItem.transform:Find("PopAnimText")
  local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  local unity_text = textTrans.gameObject:GetComponent(typeof(CS.TextMeshProUGUIEx))
  if unity_text and unity_canvas_group then
    unity_text.text = "+" .. 1
    effectItem.name = "Count" .. 1
    effectItem:SetActive(true)
    unity_canvas_group.alpha = 1
    unity_canvas_group:DOFade(0, 0.75)
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Join(effectItem.transform:DOLocalMove(Vector3.New(0, 50, 0), 0.75):SetEase(CS.DG.Tweening.Ease.OutCirc))
    self.sequence:AppendCallback(function()
      effectItem:GameObjectRecycle()
    end)
  else
    effectItem:GameObjectRecycle()
  end
end

function M:OnRecycle()
end

return M
