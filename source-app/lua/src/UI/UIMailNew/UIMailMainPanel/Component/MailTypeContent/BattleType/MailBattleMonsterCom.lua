local MailBattleMonsterCom = BaseClass("MailBattleMonsterCom", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_objLose = "Lose"
local _cp_Loose_Text = "Lose/Loose_Text"
local _cp_losetitle = "Lose/Improve%d/title%d"
local _cp_txtBtn = "Lose/Improve%d/button%d/txtBtn%d"
local _cp_button = "Lose/Improve%d/button%d"
local _cp_objWin = "Win"
local _cp_txt_wintitle = "Win/Win_Bg/Win_Title"
local _cp_txt_wintext = "Win/Win_Text"
local titleArray = {
  140062,
  140064,
  140063,
  140065
}

function MailBattleMonsterCom:OnCreate()
  base.OnCreate(self)
  self._txtLoseTitle = self:AddComponent(UIText, _cp_Loose_Text)
  self._objLose = self:AddComponent(UIBaseContainer, _cp_objLose)
  self._objWin = self:AddComponent(UIBaseContainer, _cp_objWin)
  self._txtWinTitle = self:AddComponent(UIText, _cp_txt_wintitle)
  self._txtWinContent = self:AddComponent(UIText, _cp_txt_wintext)
  self._txtWinTitle:SetLocalText(390186)
  self._txtWinContent:SetLocalText(311124)
  self._txtLoseTitle:SetLocalText(140061)
  self._title = {}
  self._button = {}
  self._txtbutton = {}
  for i = 1, 4 do
    local title = string.format(_cp_losetitle, i, i)
    local txtbutton = string.format(_cp_txtBtn, i, i, i)
    local btn = string.format(_cp_button, i, i)
    self._title[#self._title + 1] = self:AddComponent(UIText, title)
    self._title[#self._title]:SetLocalText(titleArray[i])
    self._button[#self._button + 1] = self:AddComponent(UIButton, btn)
    self._button[#self._button]:SetParam(i)
    self._button[#self._button]:SetOnClick(BindCallback(self, self.OnClickBtn))
    self._txtbutton[#self._txtbutton + 1] = self:AddComponent(UIText, txtbutton)
    self._txtbutton[#self._txtbutton]:SetLocalText(GameDialogDefine.GOTO)
  end
end

function MailBattleMonsterCom:OnClickBtn(btnIndex)
  if btnIndex == 1 then
    self:OnUpgradeHeroLevel()
  elseif btnIndex == 2 then
    self:OnUpgradeHeroQuality()
  elseif btnIndex == 3 then
    self:OnRecruitHero()
  elseif btnIndex == 4 then
    self:OnMoreHero()
  end
end

function MailBattleMonsterCom:OnUpgradeHeroLevel()
  local _selfUid = LuaEntry.Player.uid
  local firstHeroList = self._rounddata:GetPlayerHeroes(true, _selfUid, true)
  local lowestHeroLevel = 100000
  local lowestHeroUid = ""
  table.walk(firstHeroList, function(_, v)
    local data = DataCenter.HeroDataManager:GetHeroByUuid(v.heroUuid)
    if data ~= nil and data.level < lowestHeroLevel then
      lowestHeroUid = data.uuid
      lowestHeroLevel = data.level
    end
  end)
  if lowestHeroUid ~= nil then
    self.view.ctrl:OnUpgradeHeroLevel(lowestHeroUid)
  end
end

function MailBattleMonsterCom:OnUpgradeHeroQuality()
  self.view.ctrl:OnUpgradeHeroQuality()
  self.view.ctrl:CloseSelf()
end

function MailBattleMonsterCom:OnRecruitHero()
  self.view.ctrl:OnRecruitHero()
  self.view.ctrl:CloseSelf()
end

function MailBattleMonsterCom:OnMoreHero()
  self.view.ctrl:OnMoreHero()
  self.view.ctrl:CloseSelf()
end

function MailBattleMonsterCom:SetData(rounddata)
  self._rounddata = rounddata
  local battleResult = rounddata:GetBattleResult()
  if battleResult ~= FightResult.OTHER_WIN then
    self._objWin:SetActive(true)
    self._objLose:SetActive(false)
  else
    self._objWin:SetActive(false)
    self._objLose:SetActive(true)
  end
end

return MailBattleMonsterCom
