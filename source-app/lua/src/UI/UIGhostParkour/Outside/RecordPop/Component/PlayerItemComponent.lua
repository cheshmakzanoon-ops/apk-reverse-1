local base = UIBaseContainer
local PlayerItemComponent = BaseClass("PlayerItemComponent", UIBaseContainer)
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")

function PlayerItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PlayerItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PlayerItemComponent:ComponentDefine()
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "time")
  self.rawImgRankImg = self:AddComponent(UIRawImage, "rankImg")
  self.imgWin = self:AddComponent(UIImage, "win")
  self.btnPlay = self:AddComponent(UIButton, "btnPlay")
  self.btnPlay:SetOnClick(function()
    self:OnBtnPlayClick()
  end)
  self.imgEmojiBg = self:AddComponent(UIImage, "emojiBg")
  self.imgEmoji = self:AddComponent(UIImage, "emojiBg/emoji")
  self.textName = self:AddComponent(UICommonHorseLampTMP, "UICommonHorseLampTMP")
  self.btnNotPlay = self:AddComponent(UIButton, "btnNotPlay")
  self.btnNotPlay:SetOnClick(function()
    UIUtil.ShowTipsId("ghost_parkour_no_replay")
  end)
  self.btnPlayImg = self:AddComponent(UIImage, "btnPlay/img")
  self.playerBtn = self:AddComponent(UIButton, "UIPlayerHead")
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.showInfo.uid)
  end)
end

function PlayerItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.textTime = nil
  self.rawImgRankImg = nil
  self.imgWin = nil
  self.btnPlay = nil
  self.imgEmojiBg = nil
  self.imgEmoji = nil
  self.textName = nil
end

function PlayerItemComponent:DataDefine()
end

function PlayerItemComponent:DataDestroy()
  self.showInfo = nil
  self.stageId = nil
end

function PlayerItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function PlayerItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function PlayerItemComponent:OnBtnPlayClick()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if self.showInfo and self.stageId and self.otherInfo then
    if round ~= self.round then
      UIUtil.ShowTipsId("ghost_parkour_share_expire")
      return
    end
    local param = {}
    param.type = PVEType.GhostParkour
    param.enterType = PVEEnterType.GhostPlayback
    param.levelId = self.stageId
    local uid = self.showInfo.uid
    if uid == nil or uid == 0 or uid == "" then
      Logger.LogError("GhostParkour -- PlayerItemComponent showInfo.uid error")
    end
    local uuid = self.showInfo.uuid
    if uuid == nil or uuid == 0 then
      Logger.LogError("GhostParkour -- PlayerItemComponent showInfo.uuid error")
    end
    local firstInfo = {}
    table.copy(self.showInfo, firstInfo)
    local otherInfo = {}
    table.copy(self.otherInfo, otherInfo)
    param.message = {firstInfo = firstInfo, otherInfo = otherInfo}
    DataCenter.LWBattleManager:Enter(param)
  end
end

function PlayerItemComponent:SetData(data, isAttacking, stageId, otherInfo, round)
  self.showInfo = data
  self.round = round
  self.otherInfo = otherInfo
  self.stageId = stageId
  self.imgEmojiBg.gameObject:SetActive(isAttacking)
  if isAttacking then
    local line = LocalController:instance():getLine(TableName.LW_EMOJI, data.emojiId)
    if line and line.path then
      self.imgEmoji:LoadSpriteAsync("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
    else
      self.imgEmojiBg.gameObject:SetActive(false)
    end
  end
  self.imgWin.gameObject:SetActive(data.flag == 1)
  local config = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(data.tier)
  local path = ""
  if config then
    path = config.icon
  end
  self.rawImgRankImg:LoadSpriteAsyncWithCallback(path, function(sprite)
    if self.rawImgRankImg then
      self.rawImgRankImg:SetNativeSize()
    end
  end)
  self.compUIPlayerHead:SetHeadAndFrame(data.uid, data.pic, data.picver, nil, data.headSkinId, data.headSkinET)
  local name = data.name
  if not string.IsNullOrEmpty(data.abbr) then
    name = UIUtil.FormatAllianceAndName(data.abbr, name)
  end
  self.textName:SetTextWithLength(name, 200)
  self.textTime:SetText(UITimeManager:GetInstance():GetCompetitionTimeFormat(data.score))
  if data.allowSameServerWatch then
    self.btnPlay.gameObject:SetActive(true)
    self.btnNotPlay.gameObject:SetActive(false)
  else
    self.btnPlay.gameObject:SetActive(false)
    self.btnNotPlay.gameObject:SetActive(true)
  end
end

return PlayerItemComponent
