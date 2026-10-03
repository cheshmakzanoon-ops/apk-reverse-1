local NewPeakArenaRecordItem = BaseClass("NewPeakArenaRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local compBook = {
  {
    path = "imgTop",
    name = "imgTop",
    type = UIImage
  },
  {
    path = "imgTop/ResultIcon",
    name = "resultIcon",
    type = UIImage
  },
  {
    path = "imgTop/ResultIcon/txtDate",
    name = "txtDate",
    type = UIText
  },
  {
    path = "imgTop/btnReplay",
    name = "btnReplay",
    type = UIButton
  },
  {
    path = "Head",
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
    path = "ScoreChange/ScoreChangeText",
    name = "scoreChangeText",
    type = UIText
  },
  {
    path = "",
    name = "anim",
    type = UIAnimator
  },
  {
    path = "",
    name = "canvasGroup",
    type = UICanvasGroup
  },
  {
    path = "imgTop/ResultIcon/attackIcon",
    name = "attackIcon",
    type = UIImage
  },
  {
    path = "AttackIcon2",
    name = "attackIcon2",
    type = UIImage
  }
}

function NewPeakArenaRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function NewPeakArenaRecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function NewPeakArenaRecordItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnReplay:SetOnClick(function()
    if self.data and self.data.mailUid then
      if not DataCenter.LWKOFBattleManager:IsRecordRequested(self.data) then
        DataCenter.LWKOFBattleManager:RequestRecordsMails(self.data)
      end
      if not DataCenter.LWKOFBattleManager:IsRecordsParsed(self.data) then
        UIUtil.ShowTipsId(500260)
        return
      end
      if not MailParseHelper.CheckMailBattleReportIntegrity(self.data.mailUid, true) then
        UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
        return
      end
      local enterWay = self.view.pvpArenaType == PVPArenaType.NewGaleArena and "NewGaleArenaRecord" or "NewPeakArenaRecord"
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.data.mailUid, enterWay)
    end
  end)
  self.anim:Enable(false)
  self.head:SetEnableClickShowInfo(true, true)
end

function NewPeakArenaRecordItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function NewPeakArenaRecordItem:Refresh(data)
  self.data = data
  local isAttack = data.battleState == ArenaBattleStateType.AttackVictory or data.battleState == ArenaBattleStateType.AttackDefeat
  self.attackIcon:LoadSprite(isAttack and AttackIconSmall or DefendIconSmall)
  self.attackIcon2:LoadSprite(isAttack and AttackIconBig or DefendIconBig)
  local second = math.floor(data.time / 1000)
  self.txtDate:SetText(UITimeManager:GetInstance():GetNewsDateTime(second))
  local isWin = data.win
  if isWin == 1 then
    self.imgTop:SetColorRGBA(0.81, 0.89, 0.78, 1)
    self.resultIcon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png")
    self.resultIcon:SetNativeSize()
  else
    self.imgTop:SetColorRGBA(0.98, 0.85, 0.84, 1)
    self.resultIcon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png")
    self.resultIcon:SetNativeSize()
  end
  local playerInfo = data.playerInfo
  local abbr = string.IsNullOrEmpty(playerInfo.abbr) and "" or "[" .. playerInfo.abbr .. "]"
  self.txtName:SetText("#" .. playerInfo.serverId .. abbr .. playerInfo.name)
  if data.formationPower then
    self.txtPower:SetText(string.GetFormattedStr(data.formationPower))
  else
    self.txtPower:SetText(string.GetFormattedStr(playerInfo.power))
  end
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET, false)
  self.head:SetData(playerInfo.uid, playerInfo.pic, playerInfo.picver, nil, framePath)
  local changeScore = data.changeScore
  if data.extraAddScore then
    changeScore = changeScore + data.extraAddScore
  end
  if changeScore <= 0 then
    self.scoreChangeText:SetColorRGBA(0.976, 0.439, 0.466, 1)
    self.scoreChangeText:SetText(string.format("%d", changeScore))
  else
    self.scoreChangeText:SetColorRGBA(0.372, 0.937, 0.529, 1)
    self.scoreChangeText:SetText(string.format("+%d", changeScore))
  end
  self.btnReplay:SetActive(data.mailUid ~= nil)
end

function NewPeakArenaRecordItem:SetAlpha(alpha)
  self.canvasGroup:SetAlpha(alpha)
end

function NewPeakArenaRecordItem:PlayAnim()
  if self.anim then
    self.anim:Enable(true)
  end
end

return NewPeakArenaRecordItem
