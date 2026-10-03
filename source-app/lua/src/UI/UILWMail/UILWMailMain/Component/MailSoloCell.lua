local MailSoloCell = BaseClass("MailSoloCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local Localization = CS.GameEntry.Localization
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")

function MailSoloCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailSoloCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailSoloCell:ComponentDefine()
  self.win1 = self:AddComponent(UIBaseComponent, "win1")
  self.win2 = self:AddComponent(UIBaseComponent, "win2")
  self.name1 = self:AddComponent(UIText, "name1")
  self.name2 = self:AddComponent(UIText, "name2")
  self.head1 = self:AddComponent(UICommonHead, "head1")
  self.head2 = self:AddComponent(UICommonHead, "head2")
  self.soloBtn = self:AddComponent(UIButton, "soloBtn")
  self.soloBtnTxt = self:AddComponent(UIText, "soloBtn/SoloBtnText")
  self.soloBtnTxt:SetLocalText(GameDialogDefine.SHOW_DETAIL)
  self.soloBtn:SetOnClick(function()
    self:ShowDetail()
  end)
  self.heroCellReqs = {}
  self.leftContent = self:AddComponent(UIBaseContainer, "LeftHero")
  self.rightContent = self:AddComponent(UIBaseContainer, "RightHero")
end

function MailSoloCell:ComponentDestroy()
  self:RemoveHeroCells()
end

function MailSoloCell:RemoveHeroCells()
  self.leftContent:RemoveComponents(UIHeroCellTiny)
  self.rightContent:RemoveComponents(UIHeroCellTiny)
  if self.heroCellReqs then
    for _, v in pairs(self.heroCellReqs) do
      v:Destroy()
    end
    self.heroCellReqs = {}
  end
end

function MailSoloCell:SetData(data, mailUuid)
  self:RemoveHeroCells()
  self.data = data
  self.mailUuid = mailUuid
  if data.fightResult == 1 then
    self.win1:SetActive(true)
    self.win2:SetActive(false)
  else
    self.win1:SetActive(false)
    self.win2:SetActive(true)
  end
  MailBattleParseHelper.DecodeLwBattlePlayerStat(data.player[1], nil, data.battlePointInfo)
  MailBattleParseHelper.DecodeLwBattlePlayerStat(data.player[2], nil, data.battlePointInfo)
  if MailBattleParseHelper.IsWerewolf(data.player[1]) then
    self.head1:ShowWerewolf()
    self.name1:SetLocalText(GameDialogDefine.WEREWOLF)
  elseif data.player[1].isActiveAnonymity then
    self.head1:SetHead("-1")
    self.name1:SetText(data.player[1].name)
  else
    self.head1:SetHead(data.player[1].uid, data.player[1].pic, data.player[1].picVer)
    self.name1:SetText(data.player[1].name)
  end
  self.head1:SetEnableClickShowInfo(true, true)
  if MailBattleParseHelper.IsWerewolf(data.player[2]) then
    self.head2:ShowWerewolf()
    self.name2:SetLocalText(GameDialogDefine.WEREWOLF)
  elseif data.player[2].isActiveAnonymity then
    self.head2:SetHead("-1")
    self.name2:SetText(data.player[2].name)
  else
    self.head2:SetHead(data.player[2].uid, data.player[2].pic, data.player[2].picVer)
    self.name2:SetText(data.player[2].name)
  end
  self.head2:SetEnableClickShowInfo(true, true)
  local units = data.units
  local result = MailBattleParseHelper.DecodeLwBattleHero(units)
  data.hero = {}
  if result then
    for _, v in pairs(units) do
      if not v.unitType or v.unitType == BattleUnitType.Hero or v.unitType == BattleUnitType.Dominator then
        data.hero[v.index] = v
      end
    end
  end
  local heroDatas = {}
  for _, heroData in pairs(data.hero) do
    heroDatas[heroData.index] = heroData
  end
  
  local function CreateLeftHero(index, setEmpty)
    local heroData = heroDatas[index]
    if heroData or setEmpty then
      self.heroCellReqs[index] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellTiny, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        go.name = "UIHeroCellTiny" .. index
        go:SetActive(true)
        go.transform:SetParent(self.leftContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_sizeDelta(60, 60)
        local item = self.leftContent:AddComponent(UIHeroCellTiny, go.name)
        if heroData then
          item:SetDataForMail(heroData, data.fightResult == 1)
        else
          item:SetData()
        end
        local players = data.player or {}
        item:SetMonsterHeadIcon(players[1], heroData)
      end)
    end
  end
  
  for i = 1, 5 do
    CreateLeftHero(i, true)
  end
  CreateLeftHero(PVPBattleSlot.SelfDominator, false)
  
  local function CreateRightHero(index, setEmpty)
    local heroData = heroDatas[index]
    if heroData or setEmpty then
      self.heroCellReqs[index] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellTiny, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        go.name = "UIHeroCellTiny" .. index
        go:SetActive(true)
        go.transform:SetParent(self.rightContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_sizeDelta(60, 60)
        local item = self.rightContent:AddComponent(UIHeroCellTiny, go.name)
        if heroData then
          item:SetDataForMail(heroData, data.fightResult ~= 1)
        else
          item:SetData()
        end
        local players = data.player or {}
        item:SetMonsterHeadIcon(players[2], heroData)
      end)
    end
  end
  
  for i = 10, 6, -1 do
    CreateRightHero(i, true)
  end
  CreateRightHero(PVPBattleSlot.EnemyDominator, false)
end

function MailSoloCell:ShowDetail()
  if not self.ext then
    self.ext = MailBattleReport.New()
    self.ext:ParseProto(self.data, true)
    self.ext.subIsMuster = true
  end
  if self.ext.parseFail then
    UIUtil.ShowTipsId(GameDialogDefine.MAIL_OUT_OF_DATE)
  else
    self.view.ctrl:SetMusterSoloMailData(self.ext)
    self.view.ctrl:SetCurrentView(4)
    self.view:ContentTrans()
  end
end

function MailSoloCell:DataDefine()
end

function MailSoloCell:DataDestroy()
  self.ext = nil
end

function MailSoloCell:OnEnable()
  base.OnEnable(self)
end

function MailSoloCell:OnDisable()
  base.OnDisable(self)
end

function MailSoloCell:OnAddListener()
  base.OnAddListener(self)
end

function MailSoloCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailSoloCell
