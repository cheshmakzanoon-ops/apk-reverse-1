local AllyDuelScheduleItem = BaseClass("AllyDuelScheduleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg1Img_path = "bg1Img"
local bg2Img_path = "bg2Img"
local bg3Img_path = "bg3Img"
local dayTxt_path = "dayTxt"
local memberTxt_path = "memeberTxt"
local scoreTxt_path = "scoreTxt"
local victoryTxt_path = "failureTxt"
local failureTxt_path = "victoryTxt"

function AllyDuelScheduleItem:OnCreate()
  base.OnCreate(self)
  self.bg1Img = self:AddComponent(UIImage, bg1Img_path)
  self.bg2Img = self:AddComponent(UIImage, bg2Img_path)
  self.bg3Img = self:AddComponent(UIImage, bg3Img_path)
  self.dayTxt = self:AddComponent(UIText, dayTxt_path)
  self.memberTxt = self:AddComponent(UITextMeshProUGUI, memberTxt_path)
  self.scoreTxt = self:AddComponent(UIText, scoreTxt_path)
  self.victoryTxt = self:AddComponent(UIText, victoryTxt_path)
  self.failureTxt = self:AddComponent(UIText, failureTxt_path)
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.playerInfoTipBtn = self:AddComponent(UIButton, "")
  self.playerInfoTipBtn:SetOnClick(function()
    if self.curIndex > 0 and self.curIndex ~= self.index then
      self:OnClickTipBtn()
    else
      EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueToday)
    end
  end)
end

function AllyDuelScheduleItem:OnClickTipBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelConditionTip, {anim = true}, {
    day = self.index,
    info = self.tipInfo
  })
end

function AllyDuelScheduleItem:OnDestroy()
  self.tipInfo = nil
  self.data = nil
  self.bg1Img = nil
  self.bg2Img = nil
  self.bg3Img = nil
  self.dayTxt = nil
  self.memberTxt = nil
  self.scoreTxt = nil
  self.victoryTxt = nil
  self.failureTxt = nil
  self.playerHead = nil
  self.playerInfoTipBtn = nil
  base.OnDestroy(self)
end

function AllyDuelScheduleItem:RefreshData(data, curIndex, vsAllianceInfo)
  self.data = data
  local index = data.day
  self.index = index
  self.curIndex = curIndex
  local selfAbbr, otherAbbr, selfScore, otherScore = "", "", 0, 0
  local myAllianceId = LuaEntry.Player.allianceId
  for _, v in pairs(vsAllianceInfo) do
    if not table.IsNullOrEmpty(v) then
      if v.allianceId == myAllianceId then
        selfAbbr = string.format("[%s]", v.abbr)
      else
        otherAbbr = string.format("[%s]", v.abbr)
      end
      for _, j in pairs(v.scoreHistory) do
        if j.day == data.day then
          if v.allianceId == myAllianceId then
            selfScore = j.score
          else
            otherScore = j.score
          end
        end
      end
    end
  end
  if 0 < curIndex and index == curIndex then
    self.bg3Img:SetActive(true)
    self.bg1Img:SetActive(false)
    self.bg2Img:SetActive(false)
  else
    local fd = math.fmod(index, 2)
    self.bg3Img:SetActive(false)
    if fd == 1 then
      self.bg1Img:SetActive(true)
      self.bg2Img:SetActive(false)
    else
      self.bg1Img:SetActive(false)
      self.bg2Img:SetActive(true)
    end
  end
  self.dayTxt:SetLocalText(372099, index)
  self.memberTxt:SetText(string.format("<u>%s</u>", Localization:GetString(data.name)))
  if data.score ~= nil then
    local scoreStr = string.GetFormattedSeperatorNum(data.score)
    self.scoreTxt:SetText(scoreStr)
  else
    self.scoreTxt:SetText("0")
  end
  local isWin = data.isWin
  if isWin ~= nil then
    if isWin == 1 then
      self.victoryTxt:SetActive(true)
      self.victoryTxt:SetText(selfAbbr)
      self.failureTxt:SetActive(false)
    else
      self.victoryTxt:SetActive(false)
      self.failureTxt:SetActive(true)
      self.failureTxt:SetText(otherAbbr)
    end
  else
    self.failureTxt:SetActive(false)
    self.victoryTxt:SetActive(false)
  end
  local mvp = data.mvp
  if mvp and mvp.uid then
    self.playerHead:SetActive(true)
    self.playerHead:SetHeadAndFrame(mvp.uid, mvp.pic, mvp.picVer, false, mvp.headSkinId, mvp.headSkinET)
  else
    self.playerHead:SetActive(false)
  end
  self.tipInfo = {
    day = index,
    abbrL = selfAbbr,
    abbrR = otherAbbr,
    scoreL = selfScore,
    scoreR = otherScore,
    isWin = isWin
  }
end

return AllyDuelScheduleItem
