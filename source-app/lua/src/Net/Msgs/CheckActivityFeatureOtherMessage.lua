local CheckActivityFeatureOtherMessage = BaseClass("CheckActivityFeatureOtherMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckActivityFeatureOtherMessage:OnCreate(type, cfgId, param1, param2, param3, param4, param5, param6, param7)
  base.OnCreate(self)
  self.sfsObj:PutInt("checkType", type)
  self.sfsObj:PutInt("cfgId", cfgId)
  if type == 1 then
    self.sfsObj:PutFloat("radius", param1)
  elseif type == 2 then
    self.sfsObj:PutInt("rowCount", param1)
    self.sfsObj:PutInt("waveCount", param2)
    self.sfsObj:PutInt("damageCount", param3)
    self.sfsObj:PutFloat("radius", param4)
  elseif type == 3 then
    self.sfsObj:PutInt("num", param1)
  elseif type == 4 then
    self.sfsObj:PutFloat("speedZ", param1)
    self.sfsObj:PutInt("num", param2)
    self.sfsObj:PutInt("bossLine", param3)
  elseif type == 5 then
    self.sfsObj:PutFloat("radius", param1)
    self.sfsObj:PutInt("doorHeroId", param2)
  elseif type == 6 then
    self.sfsObj:PutFloat("speedZ", param1)
    local list = SFSArray.New()
    for _, v in ipairs(param2) do
      list:AddInt(v)
    end
    self.sfsObj:PutSFSArray("heroIdList", list)
    self.sfsObj:PutInt("bossLine", param3)
  elseif type == 7 then
    self.sfsObj:PutInt("trigger", param2)
    local list = SFSArray.New()
    for _, v in ipairs(param1) do
      list:AddInt(v)
    end
    self.sfsObj:PutSFSArray("list", list)
  elseif type == 8 then
    self.sfsObj:PutInt("skill", param5)
    self.sfsObj:PutInt("bullet", param6)
    self.sfsObj:PutInt("trigger", param7)
    self.sfsObj:PutInt("rowCount", param1)
    self.sfsObj:PutInt("waveCount", param2)
    self.sfsObj:PutInt("damageCount", param3)
    self.sfsObj:PutFloat("radius", param4)
  end
end

function CheckActivityFeatureOtherMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return CheckActivityFeatureOtherMessage
