local base = UIBaseContainer
local LWUIBerserkBossTopThreeRankItemRender = BaseClass("LWUIBerserkBossTopThreeRankItemRender", base)
local Localization = CS.GameEntry.Localization
local GoldAniName = "Eff_LWUIBerserkBossTopThreeRankGold"
local SilverAniName = "Eff_LWUIBerserkBossTopThreeRankSilver"
local CopperAniName = "Eff_LWUIBerserkBossTopThreeRankCopper"
local rankAni_path = ""
local playerHead_path = "RankBg/PlayerInfoContent/UIPlayerHead"
local rankIcon_path = "RankBg/RankIcon"
local allianceText_path = "RankBg/PlayerInfoContent/AllianceText"
local playerNameText_path = "RankBg/PlayerInfoContent/PlayerNameText"
local emptyTipsText_path = "RankBg/PlayerInfoContent/EmptyTipsText"
local playerInfoContent_path = "RankBg/PlayerInfoContent"
local likeBtn_path = "RankBg/LikeBtn"
local likeEffectObj_path = "RankBg/DianZanEffect"
local likeCountText_path = "RankBg/LikeBtn/LikeCountText"
local likeRedDot_path = "RankBg/LikeBtn/LikeRedDot"
local handEffectObj_path = "RankBg/DianZanEffect/Hand"
local diamondEffectObj_path = "RankBg/DianZanEffect/Diamond"
local headBtn_path = "RankBg/PlayerInfoContent/HeadBtn"
local damageText_path = "DamageContent/DamageText"
local damageContent_path = "DamageContent"
local rankFans_path = "RankBg/Rankfans"
local rankFansAdd_path = "RankBg/Rankfans/Rankfans_add"
local rankIconAdd_path = "RankBg/RankIcon/RankIcon_add"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:StopTweenSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rankAni = self:AddComponent(UIAnimator, rankAni_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.rankIcon = self:AddComponent(UIImage, rankIcon_path)
  self.allianceText = self:AddComponent(UIText, allianceText_path)
  self.playerNameText = self:AddComponent(UIText, playerNameText_path)
  self.emptyTipsText = self:AddComponent(UIText, emptyTipsText_path)
  self.playerInfoContent = self:AddComponent(UIBaseContainer, playerInfoContent_path)
  self.likeBtn = self:AddComponent(UIButton, likeBtn_path)
  self.likeEffectObj = self:AddComponent(UIBaseContainer, likeEffectObj_path)
  self.likeCountText = self:AddComponent(UIText, likeCountText_path)
  self.likeRedDot = self:AddComponent(UIBaseContainer, likeRedDot_path)
  self.handEffectObj = self:AddComponent(UIBaseContainer, handEffectObj_path)
  self.diamondEffectObj = self:AddComponent(UIBaseContainer, diamondEffectObj_path)
  self.headBtn = self:AddComponent(UIButton, headBtn_path)
  self.damageText = self:AddComponent(UIText, damageText_path)
  self.damageContent = self:AddComponent(UIBaseContainer, damageContent_path)
  self.rankFans = self:AddComponent(UIImage, rankFans_path)
  self.rankFansAdd = self:AddComponent(UIImage, rankFansAdd_path)
  self.rankIconAdd = self:AddComponent(UIImage, rankIconAdd_path)
  self.playerHeadView = self:AddComponent(UICommonHead, playerHead_path)
  self.likeBtn:SetOnClick(function()
    self:LikeBtnClick()
  end)
  self.headBtn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.rankAni = nil
  self.playerHead = nil
  self.rankIcon = nil
  self.allianceText = nil
  self.playerNameText = nil
  self.emptyTipsText = nil
  self.playerInfoContent = nil
  self.likeBtn = nil
  self.likeEffectObj = nil
  self.likeCountText = nil
  self.likeRedDot = nil
  self.handEffectObj = nil
  self.diamondEffectObj = nil
  self.headBtn = nil
  self.damageText = nil
  self.damageContent = nil
  self.rankFans = nil
  self.rankFansAdd = nil
  self.rankIconAdd = nil
end

local function DataDefine(self)
  self.playerRankInfo = nil
end

local function DataDestroy(self)
  self.playerRankInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateBerserkBossRankPraiseData, self.OnUpdateBerserkBossRankPraiseData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateBerserkBossRankPraiseData, self.OnUpdateBerserkBossRankPraiseData)
  base.OnRemoveListener(self)
end

local function OnUpdateBerserkBossRankPraiseData(self, playerUid)
  if self.playerRankInfo ~= nil and self.playerRankInfo.uid == playerUid then
    self:RefreshPraiseView()
    self:ShowLikeEffect()
  end
end

local function InitData(self, index, data, isPlayAni)
  self.playerRankInfo = data
  self.index = index
  local rankBgPath, rankIconPath = UIUtil.GetRankBgAndRankIconPathByRank(index)
  self.rankFans:LoadSprite(rankBgPath)
  self.rankFans:SetNativeSize()
  self.rankFansAdd:LoadSprite(rankBgPath)
  self.rankFansAdd:SetNativeSize()
  self.rankIcon:LoadSprite(rankIconPath)
  self.rankIcon:SetNativeSize()
  self.rankIconAdd:LoadSprite(rankIconPath)
  self.rankIconAdd:SetNativeSize()
  if index == 1 then
    self.playerHead:SetSizeDeltaXY(130, 130)
    self.allianceText:SetLocalPositionXYZ(0, -31.5, 0)
    self.playerNameText:SetLocalPositionXYZ(0, -60.8, 0)
    self.emptyTipsText:SetLocalPositionXYZ(0, -46, 0)
    self.headBtn:SetLocalPositionXYZ(0, 45, 0)
  else
    self.playerHead:SetSizeDeltaXY(100, 100)
    self.allianceText:SetLocalPositionXYZ(0, 4, 0)
    self.playerNameText:SetLocalPositionXYZ(0, -25, 0)
    self.emptyTipsText:SetLocalPositionXYZ(0, -10, 0)
    self.headBtn:SetLocalPositionXYZ(0, 55, 0)
  end
  self.allianceText:SetActive(self.playerRankInfo ~= nil)
  self.playerNameText:SetActive(self.playerRankInfo ~= nil)
  self.headBtn:SetActive(self.playerRankInfo ~= nil)
  self.likeBtn:SetActive(self.playerRankInfo ~= nil)
  self.damageContent:SetActive(self.playerRankInfo ~= nil)
  self.emptyTipsText:SetActive(self.playerRankInfo == nil)
  self.likeEffectObj:SetActive(false)
  local textColor = "#783A1F"
  if index == 1 then
    textColor = "#AB5100"
  elseif index == 2 then
    textColor = "#353372"
  end
  if self.playerRankInfo ~= nil then
    self.damageText:SetText(string.GetFormattedStr2(self.playerRankInfo.score))
    self.playerNameText:SetText(self.playerRankInfo.name)
    if not string.IsNullOrEmpty(self.playerRankInfo.alAbbr) then
      local allianceStr = string.format("<color=%s>%s</color>", textColor, "[" .. self.playerRankInfo.alAbbr .. "]")
      self.allianceText:SetText(allianceStr)
    else
      self.allianceText:SetText("")
    end
    self.playerHeadView:SetData(self.playerRankInfo.uid, self.playerRankInfo.pic, self.playerRankInfo.picVer, nil, self.playerRankInfo:GetHeadBgImg())
  else
    self.playerHeadView:SetData(nil, nil, nil, nil, nil)
    local emptyTipsStr = string.format("<color=%s>%s</color>", textColor, Localization:GetString("391071"))
    self.emptyTipsText:SetText(emptyTipsStr)
  end
  self:RefreshPraiseView()
  if isPlayAni then
    self:PlayRankAni(index)
  end
end

local function PlayRankAni(self, rank)
  if rank == 1 then
    self.rankAni:Play(GoldAniName, 0, 0)
  elseif rank == 2 then
    self.rankAni:Play(SilverAniName, 0, 0)
  else
    self.rankAni:Play(CopperAniName, 0, 0)
  end
end

local function RefreshPraiseView(self)
  if self.playerRankInfo ~= nil then
    local praiseNumber = self.playerRankInfo.praise or 0
    self.likeCountText:SetText(praiseNumber)
  end
  local remainPraise = DataCenter.LWBerserkBossManager:GetRankRemainPraise()
  self.likeRedDot:SetActive(0 < remainPraise and self.index == 1)
end

local function ShowLikeEffect(self)
  self:StopTweenSeq()
  self.likeEffectObj:SetActive(false)
  self.likeEffectObj:SetActive(true)
  self.handEffectObj.transform.localEulerAngles = Vector3(0, 0, 40)
  self.diamondEffectObj:SetActive(true)
  self.diamondSeq = CS.DG.Tweening.DOTween.Sequence()
  self.diamondSeq:Append(self.handEffectObj.transform:DOLocalRotate(Vector3(0, 0, -80), 0.6):SetEase(CS.DG.Tweening.Ease.InExpo))
  self.diamondSeq:AppendInterval(0.2)
  self.diamondSeq:AppendCallback(function()
    if self.likeEffectObj then
      self.likeEffectObj:SetActive(false)
    end
  end)
end

local function StopTweenSeq(self)
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
end

local function LikeBtnClick(self)
  if self.playerRankInfo ~= nil then
    DataCenter.LWBerserkBossManager:RequestBerserkBossRankPraiseData(self.playerRankInfo.uid)
  end
end

local function BtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBerserkBossDamageStatistics, {anim = true}, self.playerRankInfo)
end

LWUIBerserkBossTopThreeRankItemRender.OnCreate = OnCreate
LWUIBerserkBossTopThreeRankItemRender.OnDestroy = OnDestroy
LWUIBerserkBossTopThreeRankItemRender.OnEnable = OnEnable
LWUIBerserkBossTopThreeRankItemRender.OnDisable = OnDisable
LWUIBerserkBossTopThreeRankItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossTopThreeRankItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossTopThreeRankItemRender.DataDefine = DataDefine
LWUIBerserkBossTopThreeRankItemRender.DataDestroy = DataDestroy
LWUIBerserkBossTopThreeRankItemRender.OnAddListener = OnAddListener
LWUIBerserkBossTopThreeRankItemRender.OnRemoveListener = OnRemoveListener
LWUIBerserkBossTopThreeRankItemRender.InitData = InitData
LWUIBerserkBossTopThreeRankItemRender.RefreshPraiseView = RefreshPraiseView
LWUIBerserkBossTopThreeRankItemRender.OnUpdateBerserkBossRankPraiseData = OnUpdateBerserkBossRankPraiseData
LWUIBerserkBossTopThreeRankItemRender.ShowLikeEffect = ShowLikeEffect
LWUIBerserkBossTopThreeRankItemRender.StopTweenSeq = StopTweenSeq
LWUIBerserkBossTopThreeRankItemRender.LikeBtnClick = LikeBtnClick
LWUIBerserkBossTopThreeRankItemRender.BtnClick = BtnClick
LWUIBerserkBossTopThreeRankItemRender.PlayRankAni = PlayRankAni
return LWUIBerserkBossTopThreeRankItemRender
