local base = UIBaseContainer
local LWUIBerserkBossRankItemRender = BaseClass("LWUIBerserkBossRankItemRender", base)
local rankBg_path = "RankBg"
local topThreeIcon_path = "HasInfo/TopThreeIcon"
local topThreeText_path = "HasInfo/TopThreeIcon/TopThreeText"
local rankText_path = "HasInfo/RankText"
local playerHead_path = "HasInfo/UIPlayerHead"
local nameText_path = "HasInfo/VerLayout/NameText"
local powerText_path = "HasInfo/VerLayout/PowerText"
local damageText_path = "HasInfo/DamageText"
local allianceFlag_path = "HasInfo/AllianceFlag"
local btn_path = "HasInfo/Btn"
local emptyTipsText_path = "EmptyTipsText"
local hasInfo_path = "HasInfo"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.rankBg = self:AddComponent(UIImage, rankBg_path)
  self.topThreeIcon = self:AddComponent(UIImage, topThreeIcon_path)
  self.topThreeText = self:AddComponent(UIText, topThreeText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.powerText = self:AddComponent(UIText, powerText_path)
  self.damageText = self:AddComponent(UIText, damageText_path)
  self.allianceFlag = self:AddComponent(UIImage, allianceFlag_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.emptyTipsText = self:AddComponent(UIText, emptyTipsText_path)
  self.hasInfo = self:AddComponent(UIBaseContainer, hasInfo_path)
  self.playerHeadView = self:AddComponent(UICommonHead, playerHead_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.rankBg = nil
  self.topThreeIcon = nil
  self.topThreeText = nil
  self.rankText = nil
  self.playerHead = nil
  self.nameText = nil
  self.powerText = nil
  self.damageText = nil
  self.allianceFlag = nil
  self.btn = nil
  self.emptyTipsText = nil
  self.hasInfo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, rankType, rankData, rankTabType)
  if string.IsNullOrEmpty(rankData.uid) then
    self.hasInfo:SetActive(false)
    self.emptyTipsText:SetActive(true)
    self.emptyTipsText:SetLocalText(451033)
    return
  end
  self.hasInfo:SetActive(true)
  self.emptyTipsText:SetActive(false)
  self.rankType = rankType
  self.rankData = rankData
  self.rankTabType = rankTabType
  self.isSelfOrSelfAlliance = false
  if rankType == LWUIBerserkBossRankType.Personal then
    self.isSelfOrSelfAlliance = rankData.uid == LuaEntry.Player.uid
    self.powerText:SetActive(true)
    self.playerHeadView:SetActive(true)
    self.allianceFlag:SetActive(false)
    if self.isSelfOrSelfAlliance then
      self.nameText:SetText(LuaEntry.Player:GetFullName())
      self.powerText:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.power))
      local userPic = LuaEntry.Player:GetPic() or ""
      local userPicVer = LuaEntry.Player.picVer or 0
      self.playerHeadView:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
    else
      if not string.IsNullOrEmpty(rankData.alAbbr) then
        self.nameText:SetText("[" .. rankData.alAbbr .. "] " .. rankData.name)
      else
        self.nameText:SetText(rankData.name)
      end
      self.powerText:SetText(string.GetFormattedSeperatorNum(rankData.power))
      self.playerHeadView:SetData(rankData.uid, rankData.pic, rankData.picVer, nil, rankData:GetHeadBgImg())
    end
  elseif rankType == LWUIBerserkBossRankType.Alliance then
    self.isSelfOrSelfAlliance = rankData.uid == LuaEntry.Player.allianceId
    self.powerText:SetActive(false)
    self.playerHeadView:SetActive(false)
    self.allianceFlag:SetActive(true)
    if rankData.icon ~= "" then
      self.allianceFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(rankData.icon)))
    end
    if self.isSelfOrSelfAlliance then
      self.nameText:SetText(LuaEntry.Player:GetFullAllianceName())
    elseif not string.IsNullOrEmpty(rankData.abbr) then
      self.nameText:SetText("[" .. rankData.abbr .. "]" .. rankData.allianceName)
    else
      self.nameText:SetText(rankData.allianceName)
    end
  end
  self:SetRankIcon(rankData.rank)
  if self.isSelfOrSelfAlliance then
    self.rankBg:LoadSprite(string.format(LoadPath.UILWBerserkBoss, "FX_wordboss_paihangbang_4"))
  elseif 0 < rankData.rank and rankData.rank <= 3 then
    self.rankBg:LoadSprite(string.format(LoadPath.UILWBerserkBoss, string.format("FX_wordboss_paihangbang_%s", rankData.rank)))
  else
    self.rankBg:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_erji_dichen_1"))
  end
  self.damageText:SetText(string.GetFormattedStr2(rankData.score))
end

local function SetRankIcon(self, rank)
  if 0 < rank and rank <= 3 then
    self.topThreeIcon:SetActive(true)
    self.topThreeIcon:LoadSprite(string.format(LoadPath.UILWBerserkBoss, string.format("FX_wordboss_paihangbang_icon_huizhang0%s", rank)))
    self.rankText:SetText("")
    self.topThreeText:SetText(rank)
  else
    self.topThreeIcon:SetActive(false)
    if rank == 0 then
      self.rankText:SetLocalText("activity_berserkboss_desc_03")
    else
      self.rankText:SetText(rank)
    end
  end
end

local function BtnClick(self)
  if self.rankTabType == LWUIBerserkBossRankTabType.TotalPersonalDamage then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBerserkBossDamageStatistics, {anim = true}, self.rankData)
  elseif self.rankTabType == LWUIBerserkBossRankTabType.Boss then
    if not self.isSelfOrSelfAlliance then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rankData.uid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, LuaEntry.Player.uid)
    end
  end
end

LWUIBerserkBossRankItemRender.OnCreate = OnCreate
LWUIBerserkBossRankItemRender.OnDestroy = OnDestroy
LWUIBerserkBossRankItemRender.OnEnable = OnEnable
LWUIBerserkBossRankItemRender.OnDisable = OnDisable
LWUIBerserkBossRankItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossRankItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRankItemRender.DataDefine = DataDefine
LWUIBerserkBossRankItemRender.DataDestroy = DataDestroy
LWUIBerserkBossRankItemRender.InitData = InitData
LWUIBerserkBossRankItemRender.SetRankIcon = SetRankIcon
LWUIBerserkBossRankItemRender.BtnClick = BtnClick
return LWUIBerserkBossRankItemRender
