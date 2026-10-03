local LoadEditorBuildManager = BaseClass("LoadEditorBuildManager")

local function __init(self)
  self:AddListener()
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowLoadEditorBuild, self.ShowLoading)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowLoadEditorBuild, self.ShowLoading)
end

local function __delete(self)
  self:RemoveListener()
end

local function ShowLoading(data)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILoadEditorBuild, {anim = true}, data)
end

LoadEditorBuildManager.__init = __init
LoadEditorBuildManager.__delete = __delete
LoadEditorBuildManager.Startup = Startup
LoadEditorBuildManager.AddListener = AddListener
LoadEditorBuildManager.RemoveListener = RemoveListener
LoadEditorBuildManager.ShowLoading = ShowLoading
return LoadEditorBuildManager
