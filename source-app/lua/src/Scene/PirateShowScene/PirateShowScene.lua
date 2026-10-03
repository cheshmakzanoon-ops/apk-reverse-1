local PirateShowScene = BaseClass("PirateShowScene")
local name_text_path = "ziti_01"
local name_text_outline_path = "ziti_02"

function PirateShowScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PirateShowScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PirateShowScene:ComponentDefine()
  local childrenObj = self.gameObject:GetComponentsInChildren(typeof(CS.SuperTextMesh), true)
  local length = childrenObj.Length
  if 0 < length then
    for i = 0, length - 1 do
      if childrenObj[i].name == name_text_path then
        self.name_text = childrenObj[i]
      elseif childrenObj[i].name == name_text_outline_path then
        self.name_text_outline = childrenObj[i]
      end
    end
  end
end

function PirateShowScene:ComponentDestroy()
  self.name_text = nil
  self.name_text_outline = nil
  self.gameObject = nil
  self.transform = nil
end

function PirateShowScene:DataDefine()
  self.param = nil
end

function PirateShowScene:DataDestroy()
  self.param = nil
end

function PirateShowScene:ReInit(param)
  self.param = param
  if self.name_text.text ~= nil then
    self.name_text.text = param.nameDes
  end
  if self.name_text_outline.text ~= nil then
    self.name_text_outline.text = param.nameDes
  end
end

function PirateShowScene:ChangeParam(param)
  self:ReInit(param)
end

return PirateShowScene
