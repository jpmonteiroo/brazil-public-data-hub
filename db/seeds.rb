bcb = DataSource.find_or_create_by!(slug: "bcb") do |source|
  source.name = "Banco Central do Brasil"
  source.base_url = "https://api.bcb.gov.br"
  source.active = true
end

ibge = DataSource.find_or_create_by!(slug: "ibge") do |source|
  source.name = "IBGE"
  source.base_url = "https://servicodados.ibge.gov.br/api"
  source.active = true
end

Indicator.find_or_create_by!(slug: "selic") do |indicator|
  indicator.data_source = bcb
  indicator.name = "Taxa Selic"
  indicator.category = "economico"
  indicator.unit = "%"
  indicator.source_code = "11"
  indicator.description = "Taxa básica de juros do Brasil via SGS do Banco Central."
  indicator.active = true
end

Indicator.find_or_create_by!(slug: "ibc_br") do |indicator|
  indicator.data_source = bcb
  indicator.name = "IBC-Br"
  indicator.category = "economico"
  indicator.unit = "índice"
  indicator.source_code = "24363"
  indicator.description = "Índice de Atividade Econômica do Banco Central."
  indicator.active = true
end

Indicator.find_or_create_by!(slug: "states_count") do |indicator|
  indicator.data_source = ibge
  indicator.name = "Quantidade de estados"
  indicator.category = "geografico"
  indicator.unit = "total"
  indicator.source_code = "localidades-estados"
  indicator.description = "Quantidade de UFs retornadas pela API de localidades do IBGE."
  indicator.active = true
end
