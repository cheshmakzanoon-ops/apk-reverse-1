local base = UIAsyncContainer
local StrongholdPond = BaseClass("StrongholdPond", base)
local fish_title_path = "FishTitle"
local content_path = "ScrollView/Viewport/Content"
local FishPic = require("UI.UIFishing.FishPic")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.data = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.fish_title = self:AddComponent(UITextMeshProUGUIEx, fish_title_path)
  self.fish_title:SetLocalText("s6_fish_title_5")
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:ClearFishList()
  self.fish_title = nil
  self.content = nil
end

function StrongholdPond:ReInit(data)
  self.data = data
  self:RefreshView()
end

function StrongholdPond:UpdateData()
  self:ClearFishList()
  if not self.data then
    return
  end
  local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId_Pro(self.data.serverId)
  local fishIdList = DataCenter.FishMetaManager:GetIdList(campId, self.data.level)
  for _, id in ipairs(fishIdList) do
    local item = self.content:LoadComponentAsync(FishPic, "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/FishPic.prefab")
    item:SetData(id)
    table.insert(self.fishItems, item)
  end
end

function StrongholdPond:ClearFishList()
  if self.fishItems then
    for _, v in pairs(self.fishItems) do
      self.content:RemoveAsyncComponent(v)
    end
  end
  self.fishItems = {}
end

StrongholdPond.OnCreate = OnCreate
StrongholdPond.OnDestroy = OnDestroy
StrongholdPond.OnEnable = OnEnable
StrongholdPond.OnDisable = OnDisable
StrongholdPond.ComponentDefine = ComponentDefine
StrongholdPond.ComponentDestroy = ComponentDestroy
StrongholdPond.DataDefine = DataDefine
StrongholdPond.DataDestroy = DataDestroy
return StrongholdPond
