local WorldTroopVirus = BaseClass("WorldTroopVirus")
local ResourceManager = CS.GameEntry.Resource
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")

function WorldTroopVirus:__init(theModelGo, pos, scale, displayLevel, marchInfo)
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/March/WorldTroopVirus.prefab")
  request:completed("+", function()
    if request.isError or IsNull(theModelGo) then
      return
    end
    local go = request.gameObject
    go.name = "Virus"
    go:SetActive(false)
    go.transform:SetParent(theModelGo)
    go.transform:Set_localScale(scale.x, scale.y, scale.z)
    go.transform:Set_localPosition(pos.x, pos.y, pos.z)
    self:OnCreate(go)
    self:UpdateVirusInfo(displayLevel, marchInfo)
  end)
  self.request = request
end

function WorldTroopVirus:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
    self.VirusEffect = self.transform:Find("Eff_Common_tuoweidu_01").gameObject
    self.Virus1bg = self.transform:Find("icon1").gameObject
    self.Virus2bg = self.transform:Find("icon2").gameObject
    self.Virus1Icon = self.transform:Find("iconVirus1").gameObject
    self.Virus2Icon = self.transform:Find("iconVirus2").gameObject
    self.virus_level1 = self.transform:Find("level1"):GetComponent(typeof(CS.SuperTextMesh))
    self.virus_level2 = self.transform:Find("level2"):GetComponent(typeof(CS.SuperTextMesh))
    self.virus_level3 = self.transform:Find("level3"):GetComponent(typeof(CS.SuperTextMesh))
  end
end

function WorldTroopVirus:OnDestroy()
  self.gameObject = nil
  self.transform = nil
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

function WorldTroopVirus:HideVirus()
  if IsNull(self.gameObject) then
  else
    self.gameObject:SetActive(false)
  end
end

function WorldTroopVirus:UpdateVirusInfo(displayLevel, marchInfo)
  if not IsNull(self.gameObject) then
    if displayLevel == nil or marchInfo == nil then
      self.gameObject:SetActive(false)
      return
    end
    self.displayLevel = toInt(displayLevel)
    self.marchInfo = marchInfo
    local baseVirusLayer = marchInfo.baseVirusLayer or 0
    local extraVirusLayer = marchInfo.extraVirusLayer or 0
    if baseVirusLayer ~= 0 or extraVirusLayer ~= 0 then
      if marchInfo.ownerUid ~= LuaEntry.Player.uid then
        baseVirusLayer = baseVirusLayer + extraVirusLayer
        extraVirusLayer = 0
      end
      if extraVirusLayer == 0 or baseVirusLayer == 0 then
        self.Virus1bg:SetActive(true)
        self.Virus2bg:SetActive(false)
        self.Virus1Icon:SetActive(true)
        self.Virus2Icon:SetActive(false)
        self.virus_level2.text = ""
        self.virus_level3.text = ""
        if baseVirusLayer == 0 then
          self.virus_level1.text = "+" .. extraVirusLayer
          self.virus_level1.color32 = Color32.New(230, 65, 65, 255)
        else
          self.virus_level1.text = tostring(baseVirusLayer)
          self.virus_level1.color32 = Color32.New(255, 255, 255, 255)
        end
      else
        self.Virus1bg:SetActive(false)
        self.Virus2bg:SetActive(true)
        self.Virus1Icon:SetActive(false)
        self.Virus2Icon:SetActive(true)
        self.virus_level1.text = ""
        self.virus_level2.text = tostring(baseVirusLayer)
        self.virus_level3.text = "+" .. extraVirusLayer
      end
      self.gameObject:SetActive(true)
      self.VirusEffect:SetActive(DisplaySettings.HasBattleProcess(self.displayLevel))
    else
      self.gameObject:SetActive(false)
    end
  end
end

return WorldTroopVirus
