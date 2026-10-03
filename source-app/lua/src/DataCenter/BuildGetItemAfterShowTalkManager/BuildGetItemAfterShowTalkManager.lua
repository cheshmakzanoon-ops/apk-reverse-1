local BuildGetItemAfterShowTalkManager = BaseClass("BuildGetItemAfterShowTalkManager")
local ResourceManager = CS.GameEntry.Resource
local BuildGetItemAfterShowTalk = require("Scene.BuildGetItemAfterShowTalk.BuildGetItemAfterShowTalk")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.allEffect = {}
  self.willShowTalkUuid = {}
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    v:OnDestroy()
    request:Destroy()
  end
  self.allEffect = nil
  self.willShowTalkUuid = nil
end

local function ShowOneEffect(self, uuid, posIndex, tileX, tileY, des)
  if self.allEffect[posIndex] ~= nil then
    self:DeleteOneTalk(self.allEffect[posIndex].param)
  end
  local request = ResourceManager:InstantiateAsync(UIAssets.BuildGetItemAfterShowTalk)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = BuildGetItemAfterShowTalk.New()
    effect:OnCreate(request)
    self.allEffect[posIndex] = effect
    local param = {}
    param.tileX = tileX
    param.tileY = tileY
    param.posIndex = posIndex
    param.request = request
    param.des = des
    param.uuid = uuid
    param.modelHeight = CS.SceneManager.World:GetBuildingHeight(posIndex)
    effect:ReInit(param)
  end)
end

local function ShowOneTalk(self, bUuid)
  self:RemoveOneWillShowTalkUuid(bUuid)
  if DataCenter.BuildManager:IsBuildInView(bUuid) then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
      local buildId = buildData.itemId
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildData.level)
      if buildTemplate ~= nil and buildLevelTemplate ~= nil then
        local des = Localization:GetString(buildLevelTemplate:GetShowTalkAfterGetItem())
        self:ShowOneEffect(bUuid, buildData.pointId, buildTemplate.tileX, buildTemplate.tileY, des)
      end
    end
  end
end

local function DeleteOneTalk(self, param)
  if param.request ~= nil then
    if self.allEffect[param.posIndex] ~= nil then
      self.allEffect[param.posIndex]:OnDestroy()
    end
    param.request:Destroy()
  end
  self.allEffect[param.posIndex] = nil
end

local function AddOneWillShowTalkUuid(self, uuid)
  self.willShowTalkUuid[uuid] = true
end

local function RemoveOneWillShowTalkUuid(self, uuid)
  self.willShowTalkUuid[uuid] = nil
end

local function RemoveWillShowTalkUuid(self)
  self.willShowTalkUuid = {}
end

local function IsDelayShowGetResourceBubble(self, uuid)
  return self.willShowTalkUuid[uuid]
end

BuildGetItemAfterShowTalkManager.__init = __init
BuildGetItemAfterShowTalkManager.__delete = __delete
BuildGetItemAfterShowTalkManager.ShowOneEffect = ShowOneEffect
BuildGetItemAfterShowTalkManager.ShowOneTalk = ShowOneTalk
BuildGetItemAfterShowTalkManager.DeleteOneTalk = DeleteOneTalk
BuildGetItemAfterShowTalkManager.AddOneWillShowTalkUuid = AddOneWillShowTalkUuid
BuildGetItemAfterShowTalkManager.RemoveOneWillShowTalkUuid = RemoveOneWillShowTalkUuid
BuildGetItemAfterShowTalkManager.RemoveWillShowTalkUuid = RemoveWillShowTalkUuid
BuildGetItemAfterShowTalkManager.IsDelayShowGetResourceBubble = IsDelayShowGetResourceBubble
return BuildGetItemAfterShowTalkManager
