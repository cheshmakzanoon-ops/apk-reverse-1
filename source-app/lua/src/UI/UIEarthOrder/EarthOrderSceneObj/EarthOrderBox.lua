local EarthOrderBox = BaseClass("EarthOrderBox")
local box_anim_path = "A_diqiudidan_XZ/A_diqiudidan@XZ_skin"
local box_icon_path = "A_diqiudidan_XZ/A_diqiudidan@XZ_skin/case_To_unity/root_case/jint_case5/jint_case5_end/Icon"
local box_num_path = "A_diqiudidan_XZ/A_diqiudidan@XZ_skin/case_To_unity/root_case/jint_case5/jint_case5_end/NeedCount"
local AnimName = {Submit = "XZ_hudong"}
local StartAnim = {
  "XZ_kaitou_01",
  "XZ_kaitou_02",
  "XZ_kaitou_03"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.box_anim = self.transform:Find(box_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.box_icon = self.transform:Find(box_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.box_icon_anim = self.transform:Find(box_icon_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.box_num = self.transform:Find(box_num_path):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
  self.box_anim = nil
  self.box_icon = nil
  self.box_icon_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function RefreshIcon(self, iconName)
  self.box_icon:LoadSprite(iconName)
  self:RefreshCount(self.param)
  if self.box_num ~= nil then
    local tempIconName = string.format(LoadPath.CommonNewPath, "Common_duihao")
    if iconName == tempIconName then
      self.box_num.gameObject:SetActive(false)
    else
      self.box_num.gameObject:SetActive(true)
    end
  end
end

local function ReInit(self, param)
  self.param = param
  self:RefreshIcon(param.iconName)
end

local function RefreshCount(self, param)
  if param.hide ~= nil and param.hide == true then
    self.box_num.gameObject:SetActive(false)
  else
    self.box_num.gameObject:SetActive(true)
  end
  local own = 0
  local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(param.resourceItemId)
  if item ~= nil then
    own = item.number
  end
  self.box_num.text = string.GetFormattedStr(own) .. "/" .. string.GetFormattedStr(param.needResourceItemCount)
  if own >= self.param.needResourceItemCount then
  else
  end
end

local function PlaySubmitAnim(self)
  self.box_anim:Play(AnimName.Submit, 0, 0)
end

local function PlayEnterAnim(self)
  local count = table.count(StartAnim)
  local name = StartAnim[self.param.index]
  if count < self.param.index then
    local index = math.floor(self.param.index % count)
    if index == 0 then
      index = count
    end
    name = StartAnim[index]
  end
  local ret, time = UIUtil.PlayAnimationReturnTime(self.box_anim, name)
  return time
end

local function PlayClickAnim(self)
  self.box_icon_anim:Play("EarthOrderBoxIconClick", 0, 0)
end

EarthOrderBox.OnCreate = OnCreate
EarthOrderBox.OnDestroy = OnDestroy
EarthOrderBox.ComponentDefine = ComponentDefine
EarthOrderBox.ComponentDestroy = ComponentDestroy
EarthOrderBox.DataDefine = DataDefine
EarthOrderBox.DataDestroy = DataDestroy
EarthOrderBox.ReInit = ReInit
EarthOrderBox.RefreshIcon = RefreshIcon
EarthOrderBox.PlayEnterAnim = PlayEnterAnim
EarthOrderBox.PlaySubmitAnim = PlaySubmitAnim
EarthOrderBox.PlayClickAnim = PlayClickAnim
EarthOrderBox.RefreshCount = RefreshCount
return EarthOrderBox
