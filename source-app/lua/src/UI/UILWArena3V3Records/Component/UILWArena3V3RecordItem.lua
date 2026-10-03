local UILWArena3V3RecordItem = BaseClass("UILWArena3V3RecordItem", UIBaseContainer)
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
    path = "imgTop/ResultIcon/attackIcon",
    name = "attackIcon",
    type = UIImage
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
    path = "AttackIcon2",
    name = "attackIcon2",
    type = UIImage
  }
}

function UILWArena3V3RecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWArena3V3RecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function UILWArena3V3RecordItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnReplay:SetOnClick(function()
    if not DataCenter.LW3V3Manager:IsRecordRequested(self.data) then
      DataCenter.LW3V3Manager:RequestRecordsMails(self.data)
    end
    if self.data and not table.IsNullOrEmpty(self.data.battleArr) then
      if not DataCenter.LW3V3Manager:IsRecordsParsed(self.data) then
        UIUtil.ShowTipsId(500260)
        return
      end
      local reportIntegrity = true
      for _, v in pairs(self.data.battleArr) do
        if not MailParseHelper.CheckMailBattleReportIntegrity(v.mailUid, true) then
          reportIntegrity = false
        end
      end
      if not reportIntegrity then
        UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
        return
      end
      local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
      selfPlayerInfo.lastRank = self.data.oldRank
      selfPlayerInfo.curRank = self.data.curRank
      local otherPlayerInfo = self.data.playerInfo
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false}, self.data, selfPlayerInfo, otherPlayerInfo)
    end
  end)
  self.head:SetEnableClickShowInfo(true, true)
end

function UILWArena3V3RecordItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWArena3V3RecordItem:Refresh(data)
  self.data = data
  local isAttack = true
  if not table.IsNullOrEmpty(data.battleArr) then
    isAttack = data.battleArr[1].battleState == ArenaBattleStateType.AttackVictory or data.battleArr[1].battleState == ArenaBattleStateType.AttackDefeat
  end
  self.attackIcon:LoadSprite(isAttack and AttackIconSmall or DefendIconSmall)
  self.attackIcon2:LoadSprite(isAttack and AttackIconBig or DefendIconBig)
  local second = math.floor(data.time)
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
  self.btnReplay:SetActive(not table.IsNullOrEmpty(data.battleArr))
end

return UILWArena3V3RecordItem
