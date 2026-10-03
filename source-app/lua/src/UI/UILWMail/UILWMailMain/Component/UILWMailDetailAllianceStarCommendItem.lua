local UILWMailDetailAllianceStarCommendItem = BaseClass("UILWMailDetailAllianceStarCommendItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWMailDetailAllianceStarCommendItem:OnCreate()
  base.OnCreate(self)
  self.titleText = self:AddComponent(UIText, "TitleText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.playerNameText = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.gender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender")
  self.maleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Man")
  self.femaleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Woman")
  self.tipText = self:AddComponent(UIText, "TipText")
  self.zanBtn = self:AddComponent(UIButton, "ZanBtn")
  self.zanBtnText = self:AddComponent(UIText, "ZanNumText")
  self.zanBtn:SetOnClick(Bind(self, self.Interactive))
end

function UILWMailDetailAllianceStarCommendItem:OnDestroy()
  self.titleText = nil
  self.playerHead = nil
  self.playerNameText = nil
  self.gender = nil
  self.maleGender = nil
  self.femaleGender = nil
  self.tipText = nil
  self.zanBtn = nil
  self.zanBtnText = nil
  base.OnDestroy(self)
end

function UILWMailDetailAllianceStarCommendItem:OnAddListener()
  self:AddUIListener(EventId.AllianceStarGainThumbsUpAllRefresh, self.OnAllianceStarGainThumbsUpAllRefresh)
  self:AddUIListener(EventId.AllianceStarGainThumbsUpOneRefresh, self.OnAllianceStarGainThumbsUpOneRefresh)
  base.OnAddListener(self)
end

function UILWMailDetailAllianceStarCommendItem:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceStarGainThumbsUpAllRefresh, self.OnAllianceStarGainThumbsUpAllRefresh)
  self:RemoveUIListener(EventId.AllianceStarGainThumbsUpOneRefresh, self.OnAllianceStarGainThumbsUpOneRefresh)
  base.OnRemoveListener(self)
end

function UILWMailDetailAllianceStarCommendItem:SetData(data, edition)
  self.edition = edition
  self.playerHead:ParseHeadInfo(data)
  self.playerNameText:SetText(data.name)
  local template = DataCenter.AllianceStarManager:GetAlStarTemplateInfo(data.allianceStarConfigId)
  self.titleText:SetLocalText(template.name)
  self.tipText:SetLocalText(template.content, data.allianceStarScore)
  self.senderUid = data.uid
  self.maleGender:SetActive(data.gender == 1)
  self.femaleGender:SetActive(data.gender == 2)
  if data.gender ~= 1 and data.gender ~= 2 then
    self.gender:SetActive(false)
  else
    self.gender:SetActive(true)
  end
  self.seqId = data.mailUid
  self:RefreshInteractiveNum()
end

function UILWMailDetailAllianceStarCommendItem:Interactive()
  local seqId = self.seqId
  local targetUid = self.senderUid
  local thumbsUpType = InteractiveUtil.ThumbsUpType.AllianceStarCommend
  if targetUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local deltaTime = DataCenter.AllianceStarManager:GetGiveLikeMsgTime(seqId)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime - now + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  InteractiveUtil.TryThumbsUp(targetUid, thumbsUpType, seqId, function()
    DataCenter.AllianceStarManager:SetGiveLikeMsgTime(seqId)
  end, self.seqId)
end

function UILWMailDetailAllianceStarCommendItem:RefreshInteractiveNum()
  self.zanBtnText:SetText(0)
  local thumbsUpInfo = DataCenter.AllianceStarManager:GetMailThumbsUpDataItem(self.edition, self.seqId)
  if thumbsUpInfo then
    self.zanBtnText:SetText(thumbsUpInfo.mailCount)
  end
end

function UILWMailDetailAllianceStarCommendItem:OnAllianceStarGainThumbsUpAllRefresh(msg)
  if self.edition and msg.edition == self.edition then
    self:RefreshInteractiveNum()
  end
end

function UILWMailDetailAllianceStarCommendItem:OnAllianceStarGainThumbsUpOneRefresh(msg)
  if self.edition and self.seqId and msg.edition == self.edition and msg.mailUid == self.seqId then
    self:RefreshInteractiveNum()
  end
end

return UILWMailDetailAllianceStarCommendItem
