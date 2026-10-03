local PlayerInfoLine = BaseClass("PlayerInfoLine", UIBaseContainer)
local base = UIBaseContainer
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function PlayerInfoLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PlayerInfoLine:OnDestroy()
  self.heroData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PlayerInfoLine:ComponentDefine()
  self.head = self:AddComponent(UICommonHead, "head_container/head")
  self.name_txt = self:AddComponent(UIText, "name_txt")
  self.level_txt = self:AddComponent(UIText, "head_container/lv_txt")
  self.power_txt = self:AddComponent(UIText, "power_txt")
  self.score = self:AddComponent(UIBaseContainer, "playerScore")
  self.score_txt = self:AddComponent(UIText, "playerScore/score_txt")
  self.scoreAdd_txt = self:AddComponent(UIText, "playerScore/scoreAdd_txt")
  self.state_container = self:AddComponent(UIBaseContainer, "state_container")
end

function PlayerInfoLine:ComponentDestroy()
  self:ClearState()
  self.head = nil
  self.name_txt = nil
  self.level_txt = nil
  self.power_txt = nil
  self.score = nil
  self.score_txt = nil
  self.scoreAdd_txt = nil
  self.state_container = nil
end

function PlayerInfoLine:ClearState()
  if self.stateReq then
    self:GameObjectDestroy(self.stateReq)
    self.stateReq = nil
  end
end

local VictoryGo_path = "Assets/Main/Prefabs/UI/Skirmish/VictoryGo.prefab"
local DefeatGo_path = "Assets/Main/Prefabs/UI/Skirmish/DefeatGo.prefab"

function PlayerInfoLine:SetData(playerInfo, isWin, scoreInfo)
  if MailBattleParseHelper.IsWerewolf(playerInfo) then
    self.head:ShowWerewolf()
    self.name_txt:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.head:ParseHeadInfo(playerInfo)
    self.name_txt:SetText(playerInfo.name)
  end
  self.level_txt:SetText(playerInfo.level)
  self.power_txt:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(playerInfo.totalHeroPower))
  self:ClearState()
  local prefabPath = isWin and VictoryGo_path or DefeatGo_path
  self.stateReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
    local go = req.gameObject
    if IsNull(go) then
      return
    end
    local transform = go.transform
    transform:SetParent(self.state_container.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
  end)
  if scoreInfo then
    self.score:SetActive(true)
    self.score_txt:SetText(scoreInfo.score)
    self.scoreAdd_txt:SetText(scoreInfo.addScore)
    self.scoreAdd_txt:SetColor(scoreInfo.addColor)
  else
    self.score:SetActive(false)
  end
end

return PlayerInfoLine
