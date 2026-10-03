local SkyBattleTeamFormation = BaseClass("SkyBattleTeamFormation")
local Resource = CS.GameEntry.Resource
local teamFormationPathFormat = "Assets/Main/Prefabs/LWBattle/Plane/Formation/SkyBattleTeamFormation%d.prefab"

function SkyBattleTeamFormation:__init()
  self.pos = nil
  self.posCount = 0
end

function SkyBattleTeamFormation:__delete()
  self.pos = nil
  self.posCount = 0
  self:Destroy()
end

function SkyBattleTeamFormation:Init(formationType, teamRoot, onTeamFormationInited)
  local req = Resource:InstantiateAsync(string.format(teamFormationPathFormat, formationType or 1))
  req:completed("+", function()
    self.pos = {}
    local teamPrefab = req.gameObject.transform
    teamPrefab:SetParent(teamRoot)
    teamPrefab:Set_localPosition(0, 0, 0)
    local childCnt = teamPrefab.childCount
    for i = 0, childCnt - 1 do
      local child = teamPrefab:GetChild(i)
      if child and child.gameObject then
        local go = child.gameObject
        if go.activeInHierarchy then
          local x, y, z = go.transform:Get_localPosition()
          table.insert(self.pos, Vector3.New(x, y, z))
        end
      end
    end
    self.posCount = #self.pos
    if onTeamFormationInited then
      onTeamFormationInited()
    end
  end)
  self.req = req
  self.canResize = false
end

function SkyBattleTeamFormation:GetOffsetByIndex(index)
  return self.pos[index]
end

function SkyBattleTeamFormation:Destroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
end

return SkyBattleTeamFormation
