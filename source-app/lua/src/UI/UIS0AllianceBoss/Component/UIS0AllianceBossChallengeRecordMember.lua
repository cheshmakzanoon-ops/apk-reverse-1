local base = UIBaseContainer
local UIS0AllianceBossChallengeRecordMember = BaseClass("UIS0AllianceBossChallengeRecordMember", UIBaseContainer)
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Localization = CS.GameEntry.Localization
local BG_PATH = {
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_shamo_jiesuan_mvpqizi.png",
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_shamo_qizi.png",
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_shamo_qizi.png"
}
local ICON_PATH = {
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_mvp.png",
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_jisha.png",
  "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_jijie.png"
}

function UIS0AllianceBossChallengeRecordMember:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIS0AllianceBossChallengeRecordMember:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossChallengeRecordMember:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textChallengeNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.compUIPlayerHead:SetEnableClickShowInfo(false, true)
end

function UIS0AllianceBossChallengeRecordMember:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textTitle = nil
  self.textChallengeNum = nil
  self.btnClick = nil
end

function UIS0AllianceBossChallengeRecordMember:RefreshView(flag, info)
  if info == nil then
    Logger.LogError("S0AllianceBoss -- info is nil")
    return
  end
  self.imgBg:LoadSpriteAuto(BG_PATH[flag])
  self.imgIcon:LoadSpriteAuto(ICON_PATH[flag])
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(info.headSkinId, info.headSkinET, false)
  self.compUIPlayerHead:SetData(info.uid, info.headPic, info.headPicVer, nil, headBgImg)
  self.textName:SetText(info.name)
  local contextId = ""
  local num = info.damage
  if flag == AllianceBossS0RecordMemberFlag.MVP then
    contextId = "s0_alliance_boss_best"
  elseif flag == AllianceBossS0RecordMemberFlag.HighestDmg then
    contextId = "s0_alliance_boss_firepower"
  elseif flag == AllianceBossS0RecordMemberFlag.MostAlly then
    contextId = "s0_alliance_boss_rally"
    num = info.attackCount
  end
  self.textTitle:SetLocalText(contextId)
  local dmgStr = string.GetFormattedStr2(num)
  self.textChallengeNum:SetText(dmgStr)
  self.flag = flag
end

function UIS0AllianceBossChallengeRecordMember:OnBtnClickClick()
  local contextId
  if self.flag == AllianceBossS0RecordMemberFlag.MVP then
    contextId = "s0_alliance_boss_top_damage"
  elseif self.flag == AllianceBossS0RecordMemberFlag.HighestDmg then
    contextId = "s0_alliance_boss_top_burst"
  elseif self.flag == AllianceBossS0RecordMemberFlag.MostAlly then
    contextId = "s0_alliance_boss_rally_leader"
  end
  if contextId == nil or contextId == "" then
    return
  end
  local context = Localization:GetString(contextId)
  if self.scaleFactor == nil then
    self.scaleFactor = UIManager:GetInstance():GetScaleFactor()
  end
  local position = self.compUIPlayerHead.transform.position + Vector3.New(0, 50, 0) * self.scaleFactor
  if self.tipParam == nil then
    self.tipParam = UIHeroTipView.Param.New()
  end
  self.tipParam.content = context
  self.tipParam.dir = UIHeroTipView.Direction.ABOVE
  self.tipParam.defWidth = 150
  self.tipParam.pivot = 0.5
  self.tipParam.position = position
  self.tipParam.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, self.tipParam)
end

return UIS0AllianceBossChallengeRecordMember
