local UIALChallengeRankComponent = BaseClass("UIALChallengeRankComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local fullFinishTxtColor = "#407F22"
local otherTitleTxtColor = "#000000"
local selfTxtColor = "#407F22"
local difficultyLabelColor = "#736863"

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
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.textFirstNameTxt = self:AddComponent(UIText, "Name/firstNameTxt")
  self.textDfficultyLabelTxt = self:AddComponent(UIText, "Name/difficulty/dfficultyLabelTxt")
  self.textStarNumTxt = self:AddComponent(UIText, "Name/difficulty/starNumTxt")
  self.startImg = self:AddComponent(UIImage, "Name/difficulty/starImg")
  self.textPercentTxt = self:AddComponent(UIText, "percentTxt")
  self.player_flag = self:AddComponent(UICommonHead, "player")
  self.player_flag:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.imgBg = nil
  self.textFirstNameTxt = nil
  self.textDfficultyLabelTxt = nil
  self.textStarNumTxt = nil
  self.textPercentTxt = nil
  self.compPlayer = nil
end

function UIALChallengeRankComponent:SetItemShow(data, alDifficulty)
  self.data = data
  self.player_flag:SetActive(true)
  self.player_flag:SetHead(self.data.uid, self.data.pic, self.data.picver, nil, nil)
  local realDifficultyInLevel = DataCenter.ActivityKillZombieManager.GetRelDifficultyInLevel(data.curDifficulty)
  local curDifficultyALCondtions = DataCenter.ActivityKillZombieManager:GetALChallengeConditionList(alDifficulty)
  local curDifficultuMaxLevel = 0
  if curDifficultyALCondtions and curDifficultyALCondtions[1] then
    curDifficultuMaxLevel = tonumber(curDifficultyALCondtions[1].level)
  end
  if curDifficultuMaxLevel == -1 then
    local curDataDifficulty = data.curDifficulty
    local personChallengeDatas = DataCenter.ActivityKillZombieManager:GetListByType(1)
    local personChallengeData = personChallengeDatas.data[curDataDifficulty]
    curDifficultuMaxLevel = 0
    if personChallengeData then
      curDifficultuMaxLevel = #personChallengeData.monsterList
    end
  end
  local curLevel = self.data.level and tonumber(self.data.level) or 0
  local player = LuaEntry.Player
  local isSelf = player:GetUid() == self.data.uid
  local txtColor = isSelf and selfTxtColor or otherTitleTxtColor
  self.textPercentTxt:SetText(string.format("<color=%s>%d/%d</color>", txtColor, curLevel, curDifficultuMaxLevel))
  self.textFirstNameTxt:SetText(string.format("<color=%s>%s</color>", txtColor, self.data.name))
  local difficultyColor = isSelf and selfTxtColor or difficultyLabelColor
  self.textStarNumTxt:SetText(string.format("<color=%s>x%d</color>", difficultyColor, realDifficultyInLevel))
  self.textDfficultyLabelTxt:SetText(string.format("<color=%s>%s</color>", difficultyColor, Localization:GetString("challenge_zombie_005")))
  local bgPath = curDifficultuMaxLevel <= curLevel and "Assets/Main/Sprites/UI/UICitySkinExchange/zyf_yundonghuiduihuan_diban1.png" or "Assets/Main/Sprites/UI/UILWMail/ljq_zhanbao_diban_04"
  self.imgBg:LoadSprite(bgPath)
  local difficultyLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(data.curDifficulty) or 0
  local starImgPath = 0 < difficultyLevel and "Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_xingxing.png" or "Assets/Main/Sprites/UI/UIActivityKillZombie/zyf_nanduxuanze_star.png"
  self.startImg:LoadSprite(starImgPath)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIALChallengeRankComponent.OnCreate = OnCreate
UIALChallengeRankComponent.OnDestroy = OnDestroy
UIALChallengeRankComponent.OnEnable = OnEnable
UIALChallengeRankComponent.OnDisable = OnDisable
UIALChallengeRankComponent.ComponentDefine = ComponentDefine
UIALChallengeRankComponent.ComponentDestroy = ComponentDestroy
UIALChallengeRankComponent.DataDefine = DataDefine
UIALChallengeRankComponent.DataDestroy = DataDestroy
UIALChallengeRankComponent.OnAddListener = OnAddListener
UIALChallengeRankComponent.OnRemoveListener = OnRemoveListener
return UIALChallengeRankComponent
