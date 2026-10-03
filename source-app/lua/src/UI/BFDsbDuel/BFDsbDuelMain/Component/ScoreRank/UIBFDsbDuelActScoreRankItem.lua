local base = UIBaseContainer
local UIBFDsbDuelActScoreRankItem = BaseClass("UIBFDsbDuelActScoreRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActScoreRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScoreRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScoreRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg1 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRankText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRankText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textPoint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnIcon = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
  self.btnPowerText = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPowerText:SetOnClick(function()
    self:OnBtnPowerTextClick()
  end)
  self.btnPointText = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnPointText:SetOnClick(function()
    self:OnBtnPointTextClick()
  end)
  self.btnScoreText = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnScoreText:SetOnClick(function()
    self:OnBtnScoreTextClick()
  end)
end

function UIBFDsbDuelActScoreRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg1 = nil
  self.imgRank = nil
  self.textRankText1 = nil
  self.textRankText2 = nil
  self.imgIcon = nil
  self.textName = nil
  self.textGroup = nil
  self.textScore = nil
  self.textPoint = nil
  self.textPower = nil
  self.btnIcon = nil
  self.btnPowerText = nil
  self.btnPointText = nil
  self.btnScoreText = nil
end

function UIBFDsbDuelActScoreRankItem:DataDefine()
end

function UIBFDsbDuelActScoreRankItem:DataDestroy()
end

function UIBFDsbDuelActScoreRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScoreRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

local BG_BASE_PATH = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_%d.png"

function UIBFDsbDuelActScoreRankItem:SetData(data)
  local isSelf = data.allianceId == LuaEntry.Player.allianceId
  self.data = data
  local nameColor = ""
  if not isSelf and data.rank > 0 and data.rank <= 3 then
    if data.rank == 1 then
      nameColor = "#915000"
    elseif data.rank == 2 then
      nameColor = "#4B5AA4"
    else
      nameColor = "#8C5A40"
    end
    self.imgBg1:LoadSpriteAuto(string.format(BG_BASE_PATH, data.rank))
  else
    nameColor = isSelf and "#466E31" or "#413C47"
    self.imgBg1:LoadSpriteAuto(string.format(BG_BASE_PATH, isSelf and 5 or 4))
  end
  local nameStr = string.format("<color=%s>%s</color>", nameColor, UIUtil.FormatAllianceAndName(data.abbr))
  self.textName:SetText(nameStr)
  if data.rank > 0 and data.rank <= 3 then
    self.textRankText1:SetText(data.rank)
    self.imgRank:LoadSpriteAsyncWithCallback(string.format("Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_zhengduosai_paiming0%d.png", data.rank), function()
      if self.imgRank then
        self.imgRank:SetNativeSize()
      end
    end)
    self.imgRank:SetActive(true)
    self.textRankText2:SetActive(false)
  else
    self.imgRank:SetActive(false)
    self.textRankText2:SetText(data.rank)
    self.textRankText2:SetActive(true)
  end
  self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
  self.textGroup:SetText(BattlefieldDsbDuelUtils.GetGroupLetter(data.group))
  self.textScore:SetText(string.GetFormattedStr2(data.score))
  self.textPoint:SetText(string.GetFormattedStr(data.totalScore))
  self.textPower:SetText(string.GetFormattedStr(data.power))
end

function UIBFDsbDuelActScoreRankItem:OnBtnIconClick()
  local allianceId = self.data.allianceId
  if string.IsNullOrEmpty(allianceId) or string.IsNullOrEmpty(self.data.name) then
    UIUtil.ShowTipsId("900507")
    return
  end
  UIUtil.TryShowAllianceInfo(self.data.serverId, allianceId, self.data.name)
end

function UIBFDsbDuelActScoreRankItem:OnBtnPowerTextClick()
  local str = self.data.power
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = str
  param.isLocal = true
  param.alignObject = self.btnPowerText
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIBFDsbDuelActScoreRankItem:OnBtnPointTextClick()
  local str = self.data.totalScore
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = str
  param.isLocal = true
  param.alignObject = self.btnPointText
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIBFDsbDuelActScoreRankItem:OnBtnScoreTextClick()
  local str = self.data.score
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = str
  param.isLocal = true
  param.alignObject = self.btnScoreText
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return UIBFDsbDuelActScoreRankItem
