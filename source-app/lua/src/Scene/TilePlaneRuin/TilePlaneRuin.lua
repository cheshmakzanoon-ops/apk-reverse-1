local TilePlaneRuin = BaseClass("TilePlaneRuin")
local name_text_path = "XS_huoyunfeiji_timeline _1/cam03/XS_huoyunfeiji@_camera03/XS_huoyunfeiji_camera/VFX_xinshou_liangxiang_huoyunfeiji/ziti_da/ziti_01"
local name_text_outline_path = "XS_huoyunfeiji_timeline _1/cam03/XS_huoyunfeiji@_camera03/XS_huoyunfeiji_camera/VFX_xinshou_liangxiang_huoyunfeiji/ziti_da/ziti_02"

function TilePlaneRuin:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function TilePlaneRuin:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function TilePlaneRuin:ComponentDefine()
  self.name_text = self.transform:Find(name_text_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.name_text_outline = self.transform:Find(name_text_outline_path):GetComponent((typeof(CS.SuperTextMesh)))
end

function TilePlaneRuin:ComponentDestroy()
  self.name_text = nil
  self.name_text_outline = nil
  self.gameObject = nil
  self.transform = nil
end

function TilePlaneRuin:DataDefine()
  self.param = nil
end

function TilePlaneRuin:DataDestroy()
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self.param = nil
end

function TilePlaneRuin:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  self.name_text.text = param.des
  self.name_text_outline.text = param.des
end

return TilePlaneRuin
