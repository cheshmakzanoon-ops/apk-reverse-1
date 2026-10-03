local base = UIBaseContainer
local LLRankItem = BaseClass("LLRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgRankBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnFlag = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnFlag:SetOnClick(function()
    self:OnBtnFlagClick()
  end)
  self.compPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 7)
  self.textRankTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 10)
  self.textAlScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnFavor = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnFavor:SetOnClick(function()
    self:OnBtnFavorClick()
  end)
  self.textFavorTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compDianZanEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
end

function LLRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textName = nil
  self.textScore = nil
  self.imgRankBg = nil
  self.textRank = nil
  self.btnFlag = nil
  self.compPlayerHead = nil
  self.textRankTop = nil
  self.compIcon = nil
  self.slider = nil
  self.textAlScore = nil
  self.btnFavor = nil
  self.textFavorTxt = nil
  self.compDianZanEffect = nil
end

function LLRankItem:DataDefine()
  self.compDianZanEffect:SetActive(false)
  self.compPlayerHead:SetEnableClickShowInfo(true, true)
end

function LLRankItem:DataDestroy()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.data = nil
  self.allianceId = nil
  self.allianceName = ""
  self.serverId = nil
  self.uid = nil
end

function LLRankItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function LLRankItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function LLRankItem:OnBtnFlagClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local allianceId = self.allianceId
  local allianceName = self.allianceName
  if string.IsNullOrEmpty(allianceId) or string.IsNullOrEmpty(allianceName) then
    UIUtil.ShowTipsId("900507")
    return
  end
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
  if data == nil then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
  else
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceDetail) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, allianceName, allianceId, self.serverId)
  end
end

function LLRankItem:OnBtnFavorClick()
  if self.uid == nil then
    return
  end
  InteractiveUtil.TryThumbsUp(self.uid, InteractiveUtil.ThumbsUpType.LLRankLike, "LLRankItem", function()
    self:OnFavorClickSuccess()
  end)
end

function LLRankItem:OnGetNewUserInfoSucc(uid)
  if self.uid ~= nil and uid == self.uid then
    local info = UIUtil.GetPlayerInfoShowByUid(uid)
    self.textFavorTxt:SetText(info.thumbsUpCount or 0)
  end
end

function LLRankItem:OnFavorClickSuccess()
  if self.textFavorTxt == nil then
    return
  end
  local num = toInt(self.textFavorTxt:GetText()) + 1
  self.textFavorTxt:SetText(num)
  UIUtil.ShowTipsId("activity_sports_uitips_017")
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  self.compDianZanEffect:SetActive(true)
  self.diamondSeq = CS.DG.Tweening.DOTween.Sequence()
  self.diamondSeq:AppendInterval(0.8)
  self.diamondSeq:AppendCallback(function()
    if self.compDianZanEffect then
      self.compDianZanEffect:SetActive(false)
    end
  end)
end

function LLRankItem:BaseSet(bPerson, rank, score, firstData, bSelf)
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  self.compPlayerHead:SetActive(bPerson)
  self.compIcon:SetActive(bPerson)
  self.btnFlag:SetActive(not bPerson)
  self.slider:SetActive(not bPerson)
  local bgIdx = 4
  local bTopThree = 0 < rank and rank <= 3
  self.imgRankBg:SetActive(bTopThree)
  if 0 < rank then
    self.textRank:SetActive(not bTopThree)
    self.textRankTop:SetActive(bTopThree)
    if bTopThree then
      self.textRankTop:SetText(rank)
      self.imgRankBg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, string.format("lyp_huodong_zqzhg_paihangbang_%s.png", rank)))
      bgIdx = rank
    else
      self.textRank:SetText(rank)
    end
  else
    self.textRank:SetActive(true)
    self.textRank:SetLocalText(100206)
  end
  if not bSelf then
    self.imgBg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, string.format("ljq_tongyong_paihangbang_%s.png", bgIdx)))
  end
  if bPerson then
    self.textScore:SetText(string.GetFormattedSeparatorNum(score))
  else
    self.textAlScore:SetText(string.GetFormattedSeparatorNum(score))
    local max = firstData ~= nil and firstData.score or 0
    if 0 < max then
      self.slider:SetValue(score / max)
    else
      self.slider:SetValue(0)
    end
  end
end

function LLRankItem:SetData(data, bPerson, firstData)
  self.data = data
  self.serverId = data.serverId
  self:BaseSet(bPerson, data.rank or 0, data.score or 0, firstData)
  if bPerson then
    self.uid = data.uid
    self.btnFavor:SetActive(self.uid ~= LuaEntry.Player:GetUid())
    if self.btnFavor:GetActive() then
      self:OnGetNewUserInfoSucc(self.uid)
    end
    self.allianceId = nil
    self.allianceName = nil
    self.compPlayerHead:SetHeadAndFrame(self.uid, data.pic, data.picVer, false, data.picFrame)
    self.textName:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
  else
    self.btnFavor:SetActive(false)
    self.uid = nil
    self.allianceId = data.allianceId
    self.allianceName = data.allianceName
    self.btnFlag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
    self.textName:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.allianceName))
  end
end

function LLRankItem:SetAsSelf(data, bPerson, firstData)
  self.data = nil
  local player = LuaEntry.Player
  self.serverId = player:GetSourceServerId()
  self:BaseSet(bPerson, data.myRank or 0, data.myScore or 0, firstData, true)
  self.btnFavor:SetActive(false)
  if bPerson then
    self.uid = player:GetUid()
    self.allianceId = nil
    self.allianceName = nil
    self.compPlayerHead:SetHead(self.uid, player:GetPic(), player:GetPicVer(), false, player:GetHeadBgImg())
    self.textName:SetText(LuaEntry.Player:GetFullName())
  else
    self.uid = nil
    self.allianceId = LuaEntry.Player:GetAllianceUid()
    self.allianceName = LuaEntry.Player:GetAllianceName()
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData then
      self.btnFlag:LoadSpriteAuto(baseData:GetAllianceFlagPath())
    end
    self.textName:SetText(LuaEntry.Player:GetFullAllianceName())
  end
end

return LLRankItem
