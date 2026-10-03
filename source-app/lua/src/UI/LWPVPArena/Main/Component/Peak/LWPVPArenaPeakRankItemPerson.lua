local LWPVPArenaPeakRankItemPerson = BaseClass("LWPVPArenaPeakRankItemPerson", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "root",
    name = "root",
    type = nil
  },
  {
    path = "root/head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "root/btnHead",
    name = "btnHead",
    type = UIButton
  },
  {
    path = "root/txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "root/txtLastRank",
    name = "txtLastRank",
    type = UIText
  },
  {
    path = "root/txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "root/txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "root/btnChallenge",
    name = "btnChallenge",
    type = UIButton
  },
  {
    path = "root/btnChallenge/txtChallenge",
    name = "txtChallenge",
    type = UIText
  },
  {
    path = "root/vfxGlow",
    name = "vfxGlow",
    type = nil
  },
  {
    path = "root/soldier",
    name = "objSoldier",
    type = nil
  },
  {
    path = "root/soldier/imgSoldierBase",
    name = "imgSoldierBase",
    type = UIImage
  },
  {
    path = "root/soldier/imgSoldierBase/imgSoldier",
    name = "imgSoldier",
    type = UIImage
  },
  {
    path = "root/soldier/txtSoldier",
    name = "textSoldier",
    type = UITextMeshProUGUIEx
  }
}

function LWPVPArenaPeakRankItemPerson:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRankItemPerson:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LWPVPArenaPeakRankItemPerson:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtChallenge:SetText(Localization:GetString("372258"))
  self.btnChallenge:SetOnClick(function()
    self:OnChallengeClick()
  end)
  self.btnHead:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.txtLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.vfxGlow:SetActive(false)
end

function LWPVPArenaPeakRankItemPerson:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRankItemPerson:Refresh(data, canChallenge)
  if self.data and self.data.uid == data.uid and not data.lastRank and not data.playVfxGlow then
    return
  end
  self.data = data
  local nameStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    nameStr = nameStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. data.playerInfo.name
  self.txtName:SetText(nameStr)
  local power = data.formationPower
  if power and 0 < power then
    self.txtPower:SetText(string.GetFormattedStr(power))
  else
    self.txtPower:SetText(string.GetFormattedStr(data.playerInfo.power))
  end
  self.btnChallenge:SetActive(canChallenge)
  self.head:SetHeadAndFrame(data.uid, data.playerInfo.pic, data.playerInfo.picver, false, data.playerInfo.headSkinId, data.playerInfo.headSkinET)
  self.txtRank:SetText(data.rank)
  if data.rankScale then
    self.txtRank:SetLocalScaleXYZ(data.rankScale, data.rankScale, data.rankScale)
  else
    self.txtRank:SetLocalScaleXYZ(1, 1, 1)
  end
  if data.rankAlpha then
    self.rankCanvasGroup.alpha = data.rankAlpha
  else
    self.rankCanvasGroup.alpha = 1
  end
  if data.lastRank then
    self.txtLastRank:SetActive(true)
    self.txtLastRank:SetText(data.lastRank)
    self.txtLastRank:SetLocalScaleXYZ(data.lastRankScale, data.lastRankScale, data.lastRankScale)
    self.lastRankCanvasGroup.alpha = data.lastRankAlpha
  else
    self.txtLastRank:SetActive(false)
  end
  if data.playVfxGlow then
    data.playVfxGlow = nil
    self.vfxGlow:SetActive(false)
    self.vfxGlow:SetActive(true)
  end
  local soldierId = checknumber(data.formationSoldier)
  local showSoldier = 0 < soldierId
  if self.objSoldier then
    self.objSoldier:SetActive(showSoldier)
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

function LWPVPArenaPeakRankItemPerson:OnChallengeClick()
  if self.data == nil or self.data.uid == nil then
    return
  end
  local showSoldierLevelConfirmWindow = false
  local mySoldierTemplate, targetSoldierTemplate
  if checknumber(self.data.formationSoldier) > 0 then
    local info = DataCenter.LWPVPArenaManager.rankData
    if info ~= nil and info.formationSoldier ~= nil and checknumber(info.formationSoldier) > 0 then
      mySoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(checknumber(info.formationSoldier))
      targetSoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(checknumber(self.data.formationSoldier))
      if mySoldierTemplate ~= nil and targetSoldierTemplate ~= nil then
        local isMySoldierLevelLower = mySoldierTemplate.lv < targetSoldierTemplate.lv
        if isMySoldierLevelLower then
          showSoldierLevelConfirmWindow = true
        end
      end
    end
  end
  if showSoldierLevelConfirmWindow then
    local enemyPower = self.data.formationPower
    if not enemyPower or enemyPower <= 0 then
      enemyPower = self.data.playerInfo.power
    end
    local param = {}
    param.myPower = DataCenter.LWPVPArenaManager:GetMyPower() or 0
    
    function param.confirmCallback()
      self.view:Challenge(self.data.uid)
    end
    
    param.myHeadData = {
      uid = LuaEntry.Player:GetUid(),
      pic = LuaEntry.Player:GetPic(),
      picVer = LuaEntry.Player.picVer
    }
    param.mySoldierData = mySoldierTemplate
    param.enemyPower = enemyPower
    param.enemyHeadData = {
      uid = self.data.uid,
      pic = self.data.playerInfo.pic,
      picVer = self.data.playerInfo.picver
    }
    param.enemySoldierData = targetSoldierTemplate
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaSoldierConfirm, {anim = true}, param)
  else
    self.view:Challenge(self.data.uid)
  end
end

return LWPVPArenaPeakRankItemPerson
