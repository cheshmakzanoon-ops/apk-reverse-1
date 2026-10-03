local MailRoundCell = BaseClass("MailRoundCell", UIBaseContainer)
local base = UIBaseContainer
local MailSoloCell = require("UI.UILWMail.UILWMailMain.Component.MailSoloCell")
local Localization = CS.GameEntry.Localization

function MailRoundCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailRoundCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailRoundCell:ComponentDefine()
  self.RoundTitle = self:AddComponent(UIText, "RoundTitle")
  self.soloCell = self.transform:Find("SoloContent/SoloCell").gameObject
  self.soloCell:GameObjectCreatePool()
  self.soloCell:SetActive(false)
  self.soloContent = self:AddComponent(UIBaseContainer, "SoloContent")
end

function MailRoundCell:ComponentDestroy()
  self:ClearSolo()
  self.RoundTitle = nil
end

function MailRoundCell:SetData(data, mailUuid)
  self.RoundTitle:SetLocalText(GameDialogDefine.ROUND_NUM, tonumber(data.roundIndex) + 1)
  self.mailUuid = mailUuid
  self:ShowSolo(data.battle)
end

function MailRoundCell:ShowSolo(solo)
  self:ClearSolo()
  local count = 0
  for k, v in ipairs(solo) do
    count = count + 1
    local item = self.soloCell:GameObjectSpawn(self.soloContent.transform)
    item.name = "soloCell" .. count
    local obj = self.soloContent:AddComponent(MailSoloCell, item.name)
    v.mailUuid = self.mailUuid
    obj:SetData(v)
  end
end

function MailRoundCell:ClearSolo()
  self.soloContent:RemoveComponents(MailSoloCell)
  self.soloCell.gameObject:GameObjectRecycleAll()
end

function MailRoundCell:DataDefine()
end

function MailRoundCell:DataDestroy()
end

function MailRoundCell:OnEnable()
  base.OnEnable(self)
end

function MailRoundCell:OnDisable()
  base.OnDisable(self)
end

function MailRoundCell:OnAddListener()
  base.OnAddListener(self)
end

function MailRoundCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailRoundCell
