local MailScoutHeroPage = BaseClass("MailScoutHeroPage", UIBaseContainer)
local base = UIBaseContainer
local MailFormationItem = require("UI.UILWMail.UILWMailMain.Component.MailFormationItem")

function MailScoutHeroPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ClearFormation(self)
  self.host:RemoveComponents(MailFormationItem)
  self.assist:RemoveComponents(MailFormationItem)
  self.formationPrefab.gameObject:GameObjectRecycleAll()
end

function MailScoutHeroPage:OnDestroy()
  ClearFormation(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutHeroPage:DataDefine()
end

function MailScoutHeroPage:DataDestroy()
end

function MailScoutHeroPage:OnEnable()
  base.OnEnable(self)
end

function MailScoutHeroPage:OnDisable()
  base.OnDisable(self)
end

function MailScoutHeroPage:OnAddListener()
  base.OnAddListener(self)
end

function MailScoutHeroPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailScoutHeroPage:ComponentDefine()
  self.host = self:AddComponent(UIBaseContainer, "host_container/Host")
  self.hostText = self:AddComponent(UIText, "host_container/HostText")
  self.hostText:SetLocalText(GameDialogDefine.MAIL_SCOUT_ASSIST_FORMATION)
  self.formationPrefab = self.transform:Find("host_container/Host/Formation").gameObject
  self.formationPrefab:SetActive(false)
  self.formationPrefab:GameObjectCreatePool()
  self.assistText = self:AddComponent(UIText, "assist_container/AssistText")
  self.assistText:SetLocalText(GameDialogDefine.MAIL_SCOUT_HOST_FORMATION)
  self.assist = self:AddComponent(UIBaseContainer, "assist_container/Assist")
  self.noAssist = self:AddComponent(UIText, "assist_container/NoAssistText")
  self.assist_container = self:AddComponent(UIBaseContainer, "assist_container")
  self.noHostText = self:AddComponent(UIText, "host_container/noHostText")
end

function MailScoutHeroPage:ComponentDestroy()
  self.formationPrefab = nil
  self.hostText = nil
  self.assistText = nil
  self.host = nil
  self.assist = nil
  self.noAssist = nil
end

function MailScoutHeroPage:Refresh(mailExt)
  self.extData = mailExt:GetExtData()
  self.version = self.extData.version or 0
  self.disturbedScoutLv = mailExt.disturbedScoutLv or 1
  self.scoutLv = mailExt.scoutLv or 1
  if mailExt then
    mailExt:ParseHero()
  end
  self:RefreshView(self.extData)
end

function MailScoutHeroPage:RefreshView(data)
  ClearFormation(self)
  local hasFormation = false
  for k, v in ipairs(data.army.target.formation) do
    if table.count(v.hero) > 0 then
      local hostFormationGo = self.formationPrefab:GameObjectSpawn(self.host.transform)
      hostFormationGo.name = "HostFormation" .. k
      local hostFormation = self.host:AddComponent(MailFormationItem, hostFormationGo.name)
      hostFormation:SetData(v, self.version, self.scoutLv, self.disturbedScoutLv)
      hasFormation = true
    end
  end
  self.host:SetActive(hasFormation)
  self.noHostText:SetActive(not hasFormation)
  local hasAssist = false
  for k, v in ipairs(data.army.help.formation) do
    hasAssist = true
    local assistFormationGo = self.formationPrefab:GameObjectSpawn(self.assist.transform)
    assistFormationGo.name = "AssistFormation" .. k
    local assistFormation = self.assist:AddComponent(MailFormationItem, assistFormationGo.name)
    assistFormation:SetData(v, self.version, self.scoutLv, self.disturbedScoutLv)
  end
  self.assist_container:SetActive(hasAssist)
end

return MailScoutHeroPage
