local LWActivityArenaRecordItem = BaseClass("LWActivityArenaRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local compBook = {
  {
    path = "imgTop",
    name = "imgTop",
    type = UIImage
  },
  {
    path = "imgTop/txtDate",
    name = "txtDate",
    type = UIText
  },
  {
    path = "imgTop/btnReplay",
    name = "btnReplay",
    type = UIButton
  },
  {
    path = "head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "btnChallenge",
    name = "btnChallenge",
    type = UIButton
  },
  {
    path = "btnChallenge/txtChallenge",
    name = "txtChallenge",
    type = UIText
  },
  {
    path = "imgUp",
    name = "imgUp",
    type = UIImage
  },
  {
    path = "imgDown",
    name = "imgDown",
    type = UIImage
  },
  {
    path = "txtUp",
    name = "txtUp",
    type = UIText
  },
  {
    path = "txtDown",
    name = "txtDown",
    type = UIText
  },
  {
    path = "imgTop/ResultIcon",
    name = "imgResultIcon",
    type = UIImage
  },
  {
    path = "imgTop/attackIcon",
    name = "imgAttackIcon",
    type = UIImage
  },
  {
    path = "AttackIcon2",
    name = "imgAttackIcon2",
    type = UIImage
  }
}

function LWActivityArenaRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWActivityArenaRecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LWActivityArenaRecordItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtChallenge:SetText(Localization:GetString("372258"))
  self.btnChallenge:SetOnClick(function()
    if self.data then
      Notifier.Dispatch("LWNewbieArenaV2PageArea.RevangeFromRecord", self.data.log.playerId)
    end
  end)
  self.btnReplay:SetOnClick(function()
    if self.data and self.data.log and self.data.log.mailUid then
      if not DataCenter.LWKOFBattleManager:IsRecordRequested(self.data.log) then
        DataCenter.LWKOFBattleManager:RequestRecordsMails(self.data.log)
      end
      if not DataCenter.LWKOFBattleManager:IsRecordsParsed(self.data.log) then
        UIUtil.ShowTipsId(500260)
        return
      end
      if not MailParseHelper.CheckMailBattleReportIntegrity(self.data.log.mailUid, true) then
        UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.data.log.mailUid, "ActivityArenaRecord", self.data.activityId)
      self.view.ctrl:CloseSelf()
    end
  end)
end

function LWActivityArenaRecordItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaRecordItem:Refresh(data)
  self.data = data
  local second = math.floor(data.log.time / 1000)
  self.txtDate:SetText(UITimeManager:GetInstance():GetNewsDateTime(second))
  local state = data.log.battleState
  local isWin = state == 1 or state == 3
  if isWin then
    self.imgTop:SetColorRGBA(0.81, 0.89, 0.78, 1)
    self.imgResultIcon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png")
    self.imgResultIcon:SetNativeSize()
  else
    self.imgTop:SetColorRGBA(0.98, 0.85, 0.84, 1)
    self.imgResultIcon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png")
    self.imgResultIcon:SetNativeSize()
  end
  if data.log.shareInfo then
    local abbr = string.IsNullOrEmpty(data.log.shareInfo.abbr) and "" or "[" .. data.log.shareInfo.abbr .. "]"
    self.txtName:SetText(abbr .. data.log.shareInfo.name)
    self.txtPower:SetText(string.GetFormattedStr(data.log.shareInfo.power))
    self.head:SetHeadAndFrame(data.log.shareInfo.uid, data.log.shareInfo.pic, data.log.shareInfo.picver, false, data.log.shareInfo.headSkinId, data.log.shareInfo.headSkinET)
  else
    local nameKey = LocalController:instance():getValue(TableName.LWArmy, data.log.playerId, "name")
    self.txtName:SetText(Localization:GetString(nameKey))
    local powerStr = LocalController:instance():getValue(TableName.LWArmy, data.log.playerId, "pve_power")
    local powerStrArr = string.split(powerStr, "|")
    local totalPower = 0
    for _, power in ipairs(powerStrArr) do
      totalPower = totalPower + tonumber(power)
    end
    self.txtPower:SetText(string.GetFormattedStr(totalPower))
    local iconRes = LoadPath.HeroIconsSmallPath .. LocalController:instance():getValue(TableName.LWArmy, data.log.playerId, "army_icon")
    self.head:SetData(nil, iconRes, nil)
  end
  self.btnChallenge:SetActive(data.canChallenge)
  if not data.log.changeRank or data.log.changeRank == 0 then
    self.imgUp:SetActive(false)
    self.imgDown:SetActive(false)
    self.txtUp:SetText("")
    self.txtDown:SetText("")
  elseif 0 < data.log.changeRank then
    self.imgUp:SetActive(true)
    self.imgDown:SetActive(false)
    self.txtUp:SetText("+" .. data.log.changeRank)
    self.txtDown:SetText("")
  else
    self.imgUp:SetActive(false)
    self.imgDown:SetActive(true)
    self.txtUp:SetText("")
    self.txtDown:SetText(data.log.changeRank)
  end
  self.btnReplay:SetActive(data.log.mailUid ~= nil)
  local isAttack = state == ArenaBattleStateType.AttackVictory or state == ArenaBattleStateType.AttackDefeat
  self.imgAttackIcon:LoadSprite(isAttack and AttackIconSmall or DefendIconSmall)
  self.imgAttackIcon2:LoadSprite(isAttack and AttackIconBig or DefendIconBig)
end

return LWActivityArenaRecordItem
