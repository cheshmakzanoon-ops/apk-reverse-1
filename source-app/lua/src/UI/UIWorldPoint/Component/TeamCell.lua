local TeamCell = BaseClass("TeamCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")

function TeamCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TeamCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TeamCell:ComponentDefine()
  self.num = self:AddComponent(UIText, "team/num")
  self.power = self:AddComponent(UIText, "team/power")
  self.content = self:AddComponent(UIBaseContainer, "HeroContent")
end

function TeamCell:ComponentDestroy()
  self:RemoveHeroCell()
end

function TeamCell:DataDefine()
end

function TeamCell:DataDestroy()
end

function TeamCell:OnEnable()
  base.OnEnable(self)
end

function TeamCell:OnDisable()
  base.OnDisable(self)
end

function TeamCell:OnAddListener()
  base.OnAddListener(self)
end

function TeamCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TeamCell:Refresh(index, teamInfo)
  self.num:SetText(tostring(index))
  self:RemoveHeroCell()
  if teamInfo == nil then
    self.power:SetText(0)
    return
  end
  self.power:SetText(string.GetFormattedStr(teamInfo.power))
  local list = teamInfo.heros
  if list ~= nil then
    local num = 0
    for i = 1, 5 do
      num = num + 1
      self.heroSmallModel[i] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(FormationHeroItem, nameStr)
        local data = list[i]
        if data then
          cell:InitWithConfigId(data.heroId, nil, data.heroLevel, data.rankLv, data.weaponLevel, data.awakenLv, data.heroSkinId)
        else
          cell:InitWithConfigId(nil)
        end
      end)
    end
  end
end

function TeamCell:RemoveHeroCell()
  self.content:RemoveComponents(FormationHeroItem)
  if self.heroSmallModel ~= nil then
    for k, v in pairs(self.heroSmallModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.heroSmallModel = {}
end

return TeamCell
