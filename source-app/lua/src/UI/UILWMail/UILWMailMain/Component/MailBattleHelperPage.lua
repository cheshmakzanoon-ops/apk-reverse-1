local MailBattleHelperPage = BaseClass("MailBattleHelperPage", UIBaseContainer)
local base = UIBaseContainer
local HeroOverview = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.HeroOverview")
local Localization = CS.GameEntry.Localization
local BattleHelperEnumtype = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperEnumtype")

function MailBattleHelperPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailBattleHelperPage:OnDestroy()
  BattleReportUtil.Cancel()
  self:RemoveAdvices()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailBattleHelperPage:DataDefine()
end

function MailBattleHelperPage:DataDestroy()
end

function MailBattleHelperPage:OnEnable()
  base.OnEnable(self)
end

function MailBattleHelperPage:OnDisable()
  base.OnDisable(self)
end

function MailBattleHelperPage:OnAddListener()
  base.OnAddListener(self)
end

function MailBattleHelperPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailBattleHelperPage:ComponentDefine()
  self.heroOverview = self:AddComponent(HeroOverview, "OverView")
  self.aiHelper_container = self:AddComponent(UIBaseContainer, "battleHelper_container")
  self.adviecs_container = self:AddComponent(UIBaseContainer, "battleHelper_container/advices")
  self.summary_txt = self:AddComponent(UIText, "battleHelper_container/desc_txt")
  self.guider = self:AddComponent(UIImage, "battleHelper_container/guider")
end

function MailBattleHelperPage:ComponentDestroy()
  self.heroOverview = nil
  self.aiHelper_container = nil
  self.adviecs_container = nil
  self.summary_txt = nil
  self.guider = nil
end

function MailBattleHelperPage:Refresh(extData)
  self.extData = extData
  self.advices = extData:GetHelperAdvices(true)
  self.heroOverview:SetData(self.extData)
  self:RefreshSummary()
  self:RefreshAIHelper()
  if DataCenter.LWSaveGirlManager:IsJPGirlOpen() and LuaEntry.Player.JPUser then
    self.guider:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_juese_02.png")
  else
    self.guider:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_juese.png")
  end
end

function MailBattleHelperPage:RefreshSummary()
  local low = LuaEntry.DataConfig:TryGetNum("battle_report_config", "k1", 0)
  local high = LuaEntry.DataConfig:TryGetNum("battle_report_config", "k2", 0)
  local myPower = 0
  local enemyPower = 0
  local players = self.extData.player or {}
  self.player1 = players[1]
  self.player2 = players[2]
  if self.extData.isAttack then
    if players[1] then
      myPower = players[1].totalHeroPower
    end
    if players[2] then
      enemyPower = players[2].totalHeroPower
    end
  else
    if players[2] then
      myPower = players[2].totalHeroPower
    end
    if players[1] then
      enemyPower = players[1].totalHeroPower
    end
  end
  local rate = myPower / enemyPower
  local summary = ""
  local hasNumericAdvice = false
  for i = 1, #self.advices do
    local advice = self.advices[i]
    if advice.template.cate == BattleHelperEnumtype.Category.Numeric then
      hasNumericAdvice = true
      break
    end
  end
  if rate < 1 - high then
    summary = Localization:GetString("report_help_conclude1")
  elseif rate >= 1 - high and rate <= 1 + low then
    if hasNumericAdvice then
      summary = Localization:GetString("report_help_conclude2")
    else
      summary = Localization:GetString("report_help_conclude3")
    end
  elseif rate > 1 + low then
    if hasNumericAdvice then
      summary = Localization:GetString("report_help_conclude4")
    else
      summary = Localization:GetString("report_help_conclude5")
    end
  end
  self.summary_txt:SetText(summary)
end

function MailBattleHelperPage:RemoveAdvices()
  if not table.IsNullOrEmpty(self.adviceItems) then
    self.adviecs_container:RemoveAllComponentes()
  end
  if not table.IsNullOrEmpty(self.adviceReqs) then
    for i = 1, #self.adviceReqs do
      local req = self.adviceReqs[i]
      self:GameObjectDestroy(req)
    end
  end
end

function MailBattleHelperPage:RefreshAIHelper()
  self:RemoveAdvices()
  local isPlayer1 = self.player1 ~= nil and self.player1.armyType == MailTargetType.Player
  local isPlayer2 = self.player2 ~= nil and self.player2.armyType == MailTargetType.Player
  for i = 1, #self.advices do
    if self.advices[i] and self.advices[i].displayType and (isPlayer1 and isPlayer2 or self.advices[i].id ~= 1) then
      local displayType = self.advices[i].displayType
      local prefabPath = string.format("Assets/Main/Prefabs/UI/LWMail/AIHelper/HelperItemType%d.prefab", displayType)
      local clsPath = string.format("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.HelperItemType%d", displayType) or ""
      local cls = require(clsPath)
      local request = self:GameObjectInstantiateAsync(prefabPath, function(request)
        local obj = request.gameObject
        if IsNull(obj) then
          return
        end
        local transform = obj.transform
        transform:SetParent(self.adviecs_container.transform, false)
        transform:Set_localPosition(0, 0, 0)
        transform:Set_localScale(1, 1, 1)
        local name = tostring(i)
        obj.name = name
        local item = self.adviecs_container:AddComponent(cls, name)
        item:SetData(self.advices[i])
        if not self.adviceItems then
          self.adviceItems = {}
        end
        self.adviceItems[#self.adviceItems + 1] = item
      end)
      if not self.adviceReqs then
        self.adviceReqs = {}
      end
      self.adviceReqs[#self.adviceReqs + 1] = request
    end
  end
end

return MailBattleHelperPage
