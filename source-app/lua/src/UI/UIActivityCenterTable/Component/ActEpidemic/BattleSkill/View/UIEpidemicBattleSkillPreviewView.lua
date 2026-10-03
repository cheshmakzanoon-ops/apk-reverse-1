local base = UIBaseView
local UIEpidemicBattleSkillPreviewView = BaseClass("UIEpidemicBattleSkillPreviewView", base)
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local ActMgr = DataCenter.ActEpidemicZoneManager
local panel_path = "panel"
local mask_path = "Root/mask"
local skill_play_path = "Root/SkillPlay"
local up_path = "Root/up"
local down_path = "Root/down"
local info_text_path = "Root/InfoText"

function UIEpidemicBattleSkillPreviewView:OnCreate()
  base.OnCreate(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.mask = self:AddComponent(UIImage, mask_path)
  self.rawImage = self:AddComponent(UIRawImage, skill_play_path)
  self.rawImage:SetColorRGBA(1, 1, 1, 0)
  self.up = self:AddComponent(UIImage, up_path)
  self.down = self:AddComponent(UIImage, down_path)
  self.info_text = self:AddComponent(UITextMeshProUGUIEx, info_text_path)
  self.bindOnTimelineEnd = Bind(self, self.OnTimelineEnd)
  local skillId = self:GetUserData()
  self.skillId = skillId
  local template = ActMgr:GetTemplateSkillById(skillId)
  local name = template ~= nil and template.name or nil
  if not string.IsNullOrEmpty(name) then
    self.info_text:SetLocalText(name)
  end
  local example = template ~= nil and template.example or nil
  if not string.IsNullOrEmpty(example) then
    self:LoadScene(example)
  end
end

function UIEpidemicBattleSkillPreviewView:OnDestroy()
  if self.director ~= nil then
    self.director:stopped("-", self.bindOnTimelineEnd)
    self.director = nil
  end
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
  base.OnDestroy(self)
end

function UIEpidemicBattleSkillPreviewView:LoadScene(prefab)
  self.scene = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/BF_Epidemic/" .. prefab)
  self.scene:completed("+", function()
    if self.scene.isError then
      return
    end
    local go = self.scene.gameObject
    local tf = go.transform
    go.name = "EpidemicSkill_" .. self.skillId
    go:SetActive(true)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local pos = Vector3.New(-5000, 0, -5000)
    tf.position = pos
    self.camera = tf:Find("root/camera/ Camera"):GetComponentInChildren(typeof(Camera))
    self:OnRenderTexture(self.camera)
    self:PlayTimeline()
  end)
end

function UIEpidemicBattleSkillPreviewView:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("UIEpidemicBattleSkillPreviewView:OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local w, h = self.rawImage:GetSizeDeltaXY()
    self.renderTexture = RenderTexture.GetTemporary(w, h, 24, RenderTextureFormat.ARGB32)
    self.renderTexture.name = "SkillShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColorRGBA(1, 1, 1, 1)
  end
  camera.targetTexture = self.renderTexture
end

function UIEpidemicBattleSkillPreviewView:PlayTimeline()
  if self.scene == nil or IsNull(self.scene.gameObject) then
    return
  end
  local director = self.scene.gameObject:GetComponent(typeof(PlayableDirector))
  if not IsNull(director) then
    director.time = 0
    director:Play()
    director:stopped("+", self.bindOnTimelineEnd)
    self.director = director
  end
end

function UIEpidemicBattleSkillPreviewView:OnTimelineEnd()
  if self.director ~= nil then
    self.director.time = 0
    self.director:Play()
  end
end

return UIEpidemicBattleSkillPreviewView
