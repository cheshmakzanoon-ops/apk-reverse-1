local NewPeakArenaRankItem = BaseClass("NewPeakArenaRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.anim:Enable(false)
end

local function ComponentDefine(self)
  self.textRank = self:AddComponent(UIText, "Root/RankText")
  self.textLastRank = self:AddComponent(UIText, "Root/LastRankText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Root/UIPlayerHead")
  self.textName = self:AddComponent(UIText, "Root/NameText")
  self.textPower = self:AddComponent(UIText, "Root/PowerText")
  self.imgSoldierBase = self:AddComponent(UIImage, "Root/Soldier/SoldierBase")
  self.imgSoldier = self:AddComponent(UIImage, "Root/Soldier/SoldierBase/SoldierImg")
  self.textSoldier = self:AddComponent(UIText, "Root/Soldier/SoldierText")
  self.textScore = self:AddComponent(UIText, "Root/Score/ScoreText")
  self.vfxGlow = self:AddComponent(UIBaseContainer, "Root/vfxGlow")
  self.rankCanvasGroup = self.textRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.textLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.compSoldier = self:AddComponent(UIBaseContainer, "Root/Soldier")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "Root")
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
end

local function ComponentDestroy(self)
  self.textRank = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textPower = nil
  self.imgSoldier = nil
  self.textSoldier = nil
  self.textScore = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.ownShowData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshSelfItem(self, data)
  if self.ownShowData == nil then
    self.ownShowData = {}
    self.ownShowData.playerInfo = {}
  end
  self.ownShowData.uid = LuaEntry.Player:GetUid()
  self.ownShowData.rank = data.curRank
  self.ownShowData.score = data.curScore
  self.ownShowData.formationPower = data.formationPower
  self.ownShowData.formationSoldier = data.formationSoldier
  self.ownShowData.serverId = LuaEntry.Player:GetSourceServerId()
  self.ownShowData.praise = data.praiseNum
  self.ownShowData.playerInfo.uid = LuaEntry.Player:GetUid()
  self.ownShowData.playerInfo.pic = LuaEntry.Player:GetPic()
  self.ownShowData.playerInfo.picVer = LuaEntry.Player.picVer
  self.ownShowData.playerInfo.frameBg = LuaEntry.Player:GetHeadBgImg()
  self.ownShowData.playerInfo.name = LuaEntry.Player:GetName()
  self.ownShowData.playerInfo.abbr = ""
  self.ownShowData.animData = data.animData
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if not string.IsNullOrEmpty(allianceData.abbr) then
    self.ownShowData.playerInfo.abbr = allianceData.abbr
  end
  self:Refresh(self.ownShowData)
end

local function Refresh(self, data)
  local animData = data.animData
  local nameStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    nameStr = nameStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.playerInfo.uid, data.playerInfo.name)
  self.textName:SetText(nameStr)
  self.textPower:SetText(string.GetFormattedStr(data.formationPower or 0))
  self.compUIPlayerHead:ParseHeadInfo(data.playerInfo)
  self.textRank:SetText(data.rank)
  if animData and animData.rankScale then
    self.textRank:SetLocalScaleXYZ(animData.rankScale, animData.rankScale, animData.rankScale)
  else
    self.textRank:SetLocalScaleXYZ(1, 1, 1)
  end
  if animData and animData.rankAlpha then
    self.rankCanvasGroup.alpha = animData.rankAlpha
  else
    self.rankCanvasGroup.alpha = 1
  end
  if animData and animData.lastRank then
    self.textLastRank:SetActive(true)
    self.textLastRank:SetText(animData.lastRank)
    self.textLastRank:SetLocalScaleXYZ(animData.lastRankScale, animData.lastRankScale, animData.lastRankScale)
    self.lastRankCanvasGroup.alpha = animData.lastRankAlpha
  else
    self.textLastRank:SetActive(false)
  end
  if animData and animData.playVfxGlow then
    data.playVfxGlow = nil
    self.vfxGlow:SetActive(false)
    self.vfxGlow:SetActive(true)
  else
    self.vfxGlow:SetActive(false)
  end
  self.textScore:SetText(data.score)
  local soldierId = checknumber(data.formationSoldier)
  local showSoldier = 0 < soldierId
  if self.compSoldier then
    self.compSoldier:SetActive(showSoldier)
    if showSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
      if soldierTemplate ~= nil then
        self.imgSoldierBase:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
        local stage = 0
        local type = 0
        local elevenData
        if data.soldierEleven then
          type = T11Util.GetSoldierTypeByEffectStr(data.soldierEleven.effectMap)
          stage = data.soldierEleven.stage or 0
          elevenData = {type = type, stage = stage}
        end
        local soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconByTmp(soldierTemplate, elevenData)
        self.imgSoldier:LoadSprite(soldierIcon)
        self.textSoldier:SetText("Lv." .. soldierTemplate.lv)
      end
    end
  end
end

function NewPeakArenaRankItem:SetAlpha(alpha)
  self.canvasGroup:SetAlpha(alpha)
end

function NewPeakArenaRankItem:PlayAnim()
  self.anim:Enable(true)
end

NewPeakArenaRankItem.OnCreate = OnCreate
NewPeakArenaRankItem.OnDestroy = OnDestroy
NewPeakArenaRankItem.OnEnable = OnEnable
NewPeakArenaRankItem.OnDisable = OnDisable
NewPeakArenaRankItem.ComponentDefine = ComponentDefine
NewPeakArenaRankItem.ComponentDestroy = ComponentDestroy
NewPeakArenaRankItem.DataDefine = DataDefine
NewPeakArenaRankItem.DataDestroy = DataDestroy
NewPeakArenaRankItem.OnAddListener = OnAddListener
NewPeakArenaRankItem.OnRemoveListener = OnRemoveListener
NewPeakArenaRankItem.Refresh = Refresh
NewPeakArenaRankItem.RefreshSelfItem = RefreshSelfItem
return NewPeakArenaRankItem
