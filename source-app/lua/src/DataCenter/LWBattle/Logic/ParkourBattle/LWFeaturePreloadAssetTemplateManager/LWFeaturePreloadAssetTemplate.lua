local LWFeaturePreloadAssetTemplate = BaseClass("LWFeaturePreloadAssetTemplate")

function LWFeaturePreloadAssetTemplate:__init()
end

function LWFeaturePreloadAssetTemplate:__delete()
  self.unit_name = nil
  self.unit_number = nil
  self.eff_name = nil
  self.eff_number = nil
  self.bullet_name = nil
  self.bullet_number = nil
  self.boom_name = nil
  self.boom_number = nil
end

function LWFeaturePreloadAssetTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.unit_name = rowData:getValue("unit_name")
  self.unit_number = rowData:getValue("unit_number")
  self.eff_name = rowData:getValue("eff_name")
  self.eff_number = rowData:getValue("eff_number")
  self.bullet_name = rowData:getValue("bullet_name")
  self.bullet_number = rowData:getValue("bullet_number")
  self.boom_name = rowData:getValue("boom_name")
  self.boom_number = rowData:getValue("boom_number")
  self.unitPreloadCount = Mathf.Min(#self.unit_name, #self.unit_number)
  self.effPreloadCount = Mathf.Min(#self.eff_name, #self.eff_number)
  self.bulletPreloadCount = Mathf.Min(#self.bullet_name, #self.bullet_number)
  self.boomPreloadCount = Mathf.Min(#self.boom_name, #self.boom_number)
end

return LWFeaturePreloadAssetTemplate
