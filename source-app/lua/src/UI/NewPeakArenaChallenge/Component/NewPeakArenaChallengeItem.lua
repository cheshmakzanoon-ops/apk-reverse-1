local NewPeakArenaChallengeItem = BaseClass("NewPeakArenaChallengeItem", UIBaseContainer)
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
end

local function ComponentDefine(self)
  self.textRank = self:AddComponent(UIText, "Root/RankText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Root/UIPlayerHead")
  self.textName = self:AddComponent(UIText, "Root/NameText")
  self.textPower = self:AddComponent(UIText, "Root/PowerText")
  self.imgSoldierBase = self:AddComponent(UIImage, "Root/Soldier/SoldierBase")
  self.imgSoldier = self:AddComponent(UIImage, "Root/Soldier/SoldierBase/SoldierImg")
  self.compSoldier = self:AddComponent(UIBaseContainer, "Root/Soldier")
  self.textSoldier = self:AddComponent(UIText, "Root/Soldier/SoldierText")
  self.textScore = self:AddComponent(UIText, "Root/Score/ScoreText")
  self.btnCheck = self:AddComponent(UIButton, "Root/CheckBtn")
  self.btnCheck:SetOnClick(function()
    self:OnBtnCheckClick()
  end)
  self.btnChallange = self:AddComponent(UIButton, "Root/ChallangeBtn")
  self.btnChallange:SetOnClick(function()
    self:OnBtnChallangeClick()
  end)
  self.textChallangeBtn = self:AddComponent(UIText, "Root/ChallangeBtn/ChallangeBtnText")
  self.textChallangeBtn:SetLocalText("372258")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "Root")
end

local function ComponentDestroy(self)
  self.textRank = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textPower = nil
  self.imgSoldier = nil
  self.imgSoldierBase = nil
  self.compSoldier = nil
  self.textSoldier = nil
  self.textScore = nil
  self.btnChallange = nil
  self.textChallangeBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.__waitingForMsg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  self.textRank:SetText(data.rank)
  self.compUIPlayerHead:ParseHeadInfo(data.playerInfo)
  self.textScore:SetText(data.score)
  local nameStr = ""
  if data.playerInfo.serverId then
    nameStr = "#" .. data.playerInfo.serverId
  end
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    nameStr = nameStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. data.playerInfo.name
  self.textName:SetText(nameStr)
  self.textPower:SetText(string.GetFormattedStr(data.formationPower or 0))
  local soldierId = checknumber(data.formationSoldier)
  local showSoldier = 0 < soldierId
  if self.compSoldier then
    self.compSoldier:SetActive(showSoldier)
    if showSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
      if soldierTemplate ~= nil then
        local soldierEleven = self.data.soldierEleven
        local stage = 0
        local type = 0
        local elevenData
        if soldierEleven then
          type = T11Util.GetSoldierTypeByEffectStr(data.soldierEleven.effectMap)
          stage = data.soldierEleven.stage or 0
          elevenData = {type = type, stage = stage}
        end
        local soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconByTmp(soldierTemplate, elevenData)
        self.imgSoldierBase:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
        self.imgSoldier:LoadSprite(soldierIcon)
        self.textSoldier:SetText("Lv." .. soldierTemplate.lv)
      end
    end
  end
end

local function OnBtnCheckClick(self)
  self.view:OnBtnCheckClick(self.data.uid)
end

local function OnBtnChallangeClick(self)
  if self.data == nil or self.data.uid == nil then
    return
  end
  local pvpArenaType = self.view.userData and self.view.userData.type
  local showSoldierLevelConfirmWindow = false
  local mySoldierTemplate, targetSoldierTemplate
  if checknumber(self.data.formationSoldier) > 0 then
    local info
    if pvpArenaType == PVPArenaType.NewGaleArena then
      info = DataCenter.NewGaleArenaManager.rankData
    elseif pvpArenaType == PVPArenaType.NewPeakArena then
      info = DataCenter.NewPeakArenaManager.rankData
    end
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
    if pvpArenaType == PVPArenaType.NewGaleArena then
      param.myPower = DataCenter.NewGaleArenaManager:GetMyPower() or 0
    elseif pvpArenaType == PVPArenaType.NewPeakArena then
      param.myPower = DataCenter.NewPeakArenaManager:GetMyPower() or 0
    end
    
    function param.confirmCallback()
      self.view:OnBtnChallangeClick(self.data.uid)
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
    self.view:OnBtnChallangeClick(self.data.uid)
  end
end

function NewPeakArenaChallengeItem:SetAlpha(alpha)
  self.canvasGroup:SetAlpha(alpha)
end

function NewPeakArenaChallengeItem:PlayAnim()
  self.anim:Enable(true)
end

NewPeakArenaChallengeItem.OnCreate = OnCreate
NewPeakArenaChallengeItem.OnDestroy = OnDestroy
NewPeakArenaChallengeItem.OnEnable = OnEnable
NewPeakArenaChallengeItem.OnDisable = OnDisable
NewPeakArenaChallengeItem.ComponentDefine = ComponentDefine
NewPeakArenaChallengeItem.ComponentDestroy = ComponentDestroy
NewPeakArenaChallengeItem.DataDefine = DataDefine
NewPeakArenaChallengeItem.DataDestroy = DataDestroy
NewPeakArenaChallengeItem.OnAddListener = OnAddListener
NewPeakArenaChallengeItem.OnRemoveListener = OnRemoveListener
NewPeakArenaChallengeItem.SetData = SetData
NewPeakArenaChallengeItem.OnBtnCheckClick = OnBtnCheckClick
NewPeakArenaChallengeItem.OnBtnChallangeClick = OnBtnChallangeClick
return NewPeakArenaChallengeItem
