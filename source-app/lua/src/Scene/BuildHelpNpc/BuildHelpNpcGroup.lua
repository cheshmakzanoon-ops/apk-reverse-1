local BuildHelpNpcGroup = BaseClass("BuildHelpNpcGroup")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.showNum = 0
  self.checkTime = nil
end

local function __delete(self)
  self.showNum = 0
  if self.request then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.groupList = nil
  self.showFinshAnim = nil
end

local function ReInit(self, prefabPath, parent, showNum, checkTime, isFinish)
  self.prefabPath = prefabPath
  self.parent = parent
  self.showNum = showNum
  self.checkTime = checkTime
  self.isFinish = isFinish
  if self.request then
    if self.gameObject and self.groupList then
      self:RefreshGroup()
    end
  else
    local request = ResourceManager:InstantiateAsync(prefabPath)
    self.request = request
    request:completed("+", function()
      if request.isError then
        request:Destroy()
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(parent.parent)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local pos = parent.position
      request.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
      self.gameObject = request.gameObject
      self.transform = self.gameObject.transform
      self.groupList = {}
      for i = 1, 3 do
        local trans = self.transform:Find("Model/" .. i)
        local data = {}
        if trans then
          data.gameObject = trans.gameObject
          local childCount = trans.childCount
          local simpleAnims = {}
          for j = 0, childCount - 1 do
            local child = trans:GetChild(j).gameObject
            local simpleAnim = child:GetComponent(typeof(CS.SimpleAnimation))
            if simpleAnim then
              table.insert(simpleAnims, simpleAnim)
            end
          end
          data.simpleAnims = simpleAnims
        end
        table.insert(self.groupList, data)
      end
      self:RefreshGroup()
    end)
  end
end

local function RefreshGroup(self)
  if self.showFinshAnim then
    return
  end
  for i, v in ipairs(self.groupList) do
    if v and v.gameObject then
      local show = i <= self.showNum
      v.gameObject:SetActive(show)
    end
  end
  if self.isFinish then
    self:ShowFinshAnim()
  else
    self:ShowWorkAnim()
  end
end

local function ShowWorkAnim(self)
  if self.showFinshAnim then
    return
  end
  for _, v in ipairs(self.groupList) do
    if v and v.simpleAnims and #v.simpleAnims > 0 then
      for _, simpleAnim in ipairs(v.simpleAnims) do
        simpleAnim:Play("building")
      end
    end
  end
end

local function ShowFinshAnim(self)
  if self.showFinshAnim then
    return
  end
  self.showFinshAnim = true
  self:SetCheckTime(nil)
  for _, v in ipairs(self.groupList) do
    if v and v.simpleAnims and #v.simpleAnims then
      for _, simpleAnim in ipairs(v.simpleAnims) do
        simpleAnim:Play("celebrate")
      end
    end
  end
end

local function SetCheckTime(self, time)
  if self.showFinshAnim then
    return
  end
  self.checkTime = time
end

BuildHelpNpcGroup.__init = __init
BuildHelpNpcGroup.__delete = __delete
BuildHelpNpcGroup.ReInit = ReInit
BuildHelpNpcGroup.RefreshGroup = RefreshGroup
BuildHelpNpcGroup.ShowWorkAnim = ShowWorkAnim
BuildHelpNpcGroup.ShowFinshAnim = ShowFinshAnim
BuildHelpNpcGroup.SetCheckTime = SetCheckTime
return BuildHelpNpcGroup
